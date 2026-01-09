module Mentors
  class StudentsController < ApplicationController
    before_action :authenticate_user!
    before_action :authorize_mentor

    # GET /mentors/students
    def index
      @students = User.with_bookings_by_mentor(current_user)
                      .order(:first_name, :last_name)
    end

    # GET /mentors/students/with_bookings
    def with_bookings
      @students = User.with_upcoming_bookings_by_mentor(current_user)
                      .includes(bookings: { availability: :category })
                      .order(:first_name, :last_name)
    end

    # GET /mentors/students/:id
    def show
      @student = User.with_bookings_by_mentor(current_user)
                     .find(params[:id])

      if @student
        @bookings = Booking.by_mentor(current_user)
                           .by_student(@student)
                           .includes(availability: :category)
                           .order("starts_at DESC")
      else
        redirect_to mentors_students_path, alert: "Estudiante no encontrado, o no tiene reservas contigo"
      end
    end

    private

    def authorize_mentor
      unless current_user.mentor?
        redirect_to root_path, alert: "No tienes permisos para acceder a esta sección"
      end
    end
  end
end
