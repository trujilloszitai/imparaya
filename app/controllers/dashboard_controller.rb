class DashboardController < ApplicationController
  before_action :authenticate_user!

  # GET /dashboard
  def index
    if current_user.student?
      redirect_to students_dashboard_path
    elsif current_user.mentor?
      redirect_to mentors_dashboard_path
    else
      redirect_to root_path, alert: "No tienes permisos para acceder al dashboard"
    end
  end
end
