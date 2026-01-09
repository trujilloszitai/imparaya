class MentorsController < ApplicationController
  # GET /mentors
  def index
    @mentors = User.mentors
  end

  # GET /mentors/:id
  def show
      @mentor = User.mentors.find(params[:id])
      @availabilities = @mentor.availabilities.order(:day_of_week, :starts_at)
  end

  # GET /mentors/:id/weekly_schedule
  def weekly_schedule
    @mentor = User.mentors.find(params[:id])
    @availabilities = @mentor.availabilities.order(:day_of_week, :starts_at)
  end
end
