module Mentors
  class AvailabilitiesController < ApplicationController
    before_action :authenticate_user!
    before_action :authorize_mentor, except: [ :show ]
    before_action :set_availability, only: [ :edit, :update, :destroy ]

    # GET /mentors/availabilities
    def index
        @availabilities = current_user.availabilities
                     .includes(:category)
                     .order(day_of_week: :asc, starts_at: :asc)
    end

    # GET /mentors/availabilities/:id
    def show
      @availability = Availability.find(params[:id])
    end

    # GET /mentors/availabilities/new
    def new
      @availability = current_user.availabilities.new
      @categories = Category.all.pluck(:name, :id)
    end

    # GET /mentors/availabilities/:id/edit
    def edit
    end

    # POST /mentors/availabilities
    def create
      # check if there's an overlapping availability
      overlapping = current_user.availabilities
                    .where(day_of_week: availability_params[:day_of_week])
                    .where("starts_at < ? AND ends_at > ?", availability_params[:ends_at], availability_params[:starts_at])
      if overlapping.exists?
        flash.now[:alert] = "El horario se superpone con una disponibilidad existente"
        render :new, status: :unprocessable_entity
        return
      end

      @availability = current_user.availabilities.new(availability_params)

      if @availability.save
        redirect_to mentors_availability_path(@availability), notice: "Horario agregado exitosamente"
      else
        render :new, status: :unprocessable_entity
      end
    end

    # PATCH/PUT /mentors/availabilities/:id
    def update
      if @availability.update(availability_params)
        redirect_to mentors_availability_path(@availability), notice: "Horario actualizado exitosamente"
      else
        render :edit, status: :unprocessable_entity
      end
    end

    # DELETE /mentors/availabilities/:id
    def destroy
      @availability.destroy
      redirect_to mentors_availabilities_path, notice: "Horario eliminado exitosamente"
    end

    private

    def set_availability
      @availability = current_user.availabilities.find(params[:id])
    end

    def availability_params
      params.require(:availability).permit(
        :day_of_week,
        :category_id,
        :starts_at,
        :ends_at,
        :price_per_hour,
        :capacity,
        :description
      )
    end

    def authorize_mentor
      unless current_user.mentor?
        redirect_to root_path, alert: "No tienes permisos para acceder a esta sección"
      end
    end
  end
end
