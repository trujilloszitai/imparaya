module Mentors
  class DashboardController < ApplicationController
    before_action :authenticate_user!
    before_action :authorize_mentor

    # GET /mentors/dashboard
    def index
      @availabilities = current_user.availabilities.order(day_of_week: :asc, starts_at: :asc)
      @upcoming_bookings = Booking.by_mentor(current_user).upcoming.limit(10)
      @recent_bookings = Booking.by_mentor(current_user).order(created_at: :desc).limit(10)
    end

    private

    def authorize_mentor
      unless current_user.mentor?
        redirect_to root_path, alert: "No tienes permisos para acceder a esta sección"
      end
    end
  end
end
