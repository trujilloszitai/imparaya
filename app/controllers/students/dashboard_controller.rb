module Students
  class DashboardController < ApplicationController
    before_action :authenticate_user!
    before_action :authorize_student

    # GET /students/dashboard
    def index
      @bookings = current_user.bookings.includes(availability: [ :mentor, :category ])
                          .order(created_at: :desc)
      @previous_bookings = current_user
                          .bookings
                          .previous
                          .includes(availability: [ :mentor, :category ])
                          .limit(10)
      @upcoming_bookings = current_user
                          .bookings
                          .upcoming
                          .includes(availability: [ :mentor, :category ])
                          .limit(10)
    end

    private

    def authorize_student
      unless current_user.student?
        redirect_to root_path, alert: "No tienes permisos para acceder a esta sección"
      end
    end
  end
end
