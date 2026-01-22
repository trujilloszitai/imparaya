require "mercadopago"

module Students
  class BookingsController < ApplicationController
    before_action :authenticate_user!
    before_action :authorize_student
    before_action :set_booking, only: [ :show, :update, :cancel, :checkout, :payment_success, :payment_failure, :payment_pending ]

    # GET /students/bookings
    def index
      @bookings = current_user.bookings.order(created_at: :desc).includes(availability: [ :mentor, :category ])
    end

    # GET /students/bookings/:id
    def show
      @last_payment = @booking.payments.order(created_at: :desc).first
    end

    # GET /students/bookings/new
    def new
      @availability = Availability.find(params[:availability_id]) if params[:availability_id]
      slots = AvailabilityScheduler.new(@availability, current_user).perform
      if slots.empty?
        redirect_to students_bookings_path, alert: "No hay cupos disponibles para la disponibilidad seleccionada."
        return
      end
      @slot_options = slots.map do |s|
        # date format
        slot_datetime = TimeUtils.combine(s[:date], s[:start_time])
        date_str = l(slot_datetime, format: :short)

        label = s[:is_available] ? date_str : "#{date_str} - #{s[:reason]}"

        # using iso8601 for value to ensure proper time format
        [ label, slot_datetime.iso8601 ]
      end

      @disabled_slots = slots.reject { |s| s[:is_available] }.map { |s| s[:date].iso8601 }

      @booking = current_user.bookings.new
    end

    # POST /students/bookings
    def create
      @availability = Availability.find(booking_params[:availability_id])
      duration_in_hours = @availability.duration
      ends_at = params[:booking][:starts_at].to_datetime + duration_in_hours.hours
      @booking = current_user.bookings.new(booking_params.merge(ends_at: ends_at, price: @availability.price_per_hour * duration_in_hours))


      if @booking.save
        redirect_to students_booking_path(@booking), notice: "Clase agendada exitosamente"
      else
        render :new, status: :unprocessable_entity
      end
    end

    # PATCH/PUT /students/bookings/:id
    def update
      if @booking.update(booking_params)
        redirect_to students_booking_path(@booking), notice: "Agenda actualizada exitosamente"
      else
        render :show, status: :unprocessable_entity
      end
    end

    # PATCH /students/bookings/:id/cancel
    def cancel
      if @booking.update(status: "cancelled")
        redirect_to students_bookings_path, notice: "Clase cancelada exitosamente"
      else
        redirect_to students_booking_path(@booking), alert: "No se pudo cancelar la clase"
      end
    end

    def payment_success
      payment_id = params[:payment_id]

      if payment_id.present?
        process_payment(payment_id, @booking)
      end

      render :payment_success
    end

    def payment_failure
      render :payment_failure
    end

    def payment_pending
      payment_id = params[:payment_id]

      if payment_id.present?
        process_payment(payment_id, @booking)
      end

      render :payment_pending
    end

    # POST /students/bookings/:id/checkout
    def checkout
      # Rails.logger.info "init_point: #{preference['init_point']}"
      # Rails.logger.info "sandbox_init_point: #{preference['sandbox_init_point']}"
      # Rails.logger.info "========================="
      if @booking.present?
        back_urls = {
          success: payment_success_students_booking_url(@booking),
          failure: payment_failure_students_booking_url(@booking),
          pending: payment_pending_students_booking_url(@booking)
        }

        preference = MercadoPagoService.create_preference(@booking, current_user, back_urls)

        Rails.logger.info "=== PAGO DEBUG ==="
        Rails.logger.info "Response: #{preference.inspect}"

        if preference[:status] == 201
          @booking.update(preference_id: preference[:response]["id"])

          # please use preference[:response]["sandbox_init_point"] when using test credentials
          # use preference[:response]["init_point"] when using production credentials
          redirect_to preference[:response]["init_point"], allow_other_host: true
        else
          redirect_to students_booking_path(@booking), alert: "Error al crear la preferencia de pago"
        end
      else
        redirect_to root_path, alert: "Reserva no encontrada"
      end
    end

    private

    def process_payment(payment_id, booking)
      payment_response = $mp.payment.get(payment_id)
      payment_data = payment_response[:response]

      return unless payment_data["id"]

      return if Payment.exists?(mp_payment_id: payment_id.to_s)

      payment = booking.payments.create(
        mp_payment_id: payment_data["id"].to_s,
        status: payment_data["status"],
        status_detail: payment_data["status_detail"],
        transaction_amount: payment_data["transaction_amount"],
        net_received_amount: payment_data.dig("transaction_details", "net_received_amount"),
        payment_method_id: payment_data["payment_method_id"],
        payer_email: payment_data.dig("payer", "email"),
        external_reference: payment_data["external_reference"]
      )

      case payment_data["status"]
      when "approved"
        booking.update(status: :paid)
      when "rejected"
        booking.update(status: :rejected)
      end

      payment
    end

    def set_booking
      @booking = current_user.bookings.find(params[:id])
    end

    def booking_params
      params.require(:booking).permit(:availability_id, :starts_at, :preference_id, :status)
    end

    def authorize_student
      unless current_user.student?
        redirect_to root_path, alert: "No tienes permisos para acceder a esta sección"
      end
    end
  end
end
