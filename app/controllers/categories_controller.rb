class CategoriesController < ApplicationController
  before_action :set_category, only: [ :show, :availabilities ]

  # GET /categories
  def index
    @categories = Category.all
  end

  # GET /categories/:id
  def show
  end

  # GET /categories/:id/availabilities
  def availabilities
    @availabilities = @category.availabilities.order(starts_at: :asc).includes(:mentor)
  end

  private

  def set_category
    @category = Category.find(params[:id])
  end
end
