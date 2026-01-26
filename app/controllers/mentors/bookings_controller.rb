module Mentors
  class BookingsController < ApplicationController
    before_action :authenticate_user!
    before_action :authorize_mentor
    before_action :set_booking, only: [ :show, :update ]

    # GET /mentors/bookings
    def index
      @bookings = Booking.by_mentor(current_user)
                         .includes(:availability, :student)
                         .order(created_at: :desc)
    end

    # GET /mentors/bookings/:id
    def show
      @student = @booking.student
    end

    # PATCH/PUT /mentors/bookings/:id
    def update
      if @booking.update(booking_params)
        redirect_to mentors_booking_path(@booking), notice: "Reserva actualizada exitosamente"
      else
        render :show, status: :unprocessable_entity
      end
    end

    private

    def set_booking
      @booking = Booking.by_mentor(current_user)
                        .find(params[:id])
    end

    def booking_params
      params.require(:booking).permit(:status, :preference_id)
    end

    def authorize_mentor
      unless current_user.mentor?
        redirect_to root_path, alert: "No tienes permisos para acceder a esta sección"
      end
    end
  end
end
