require "mercadopago"

class PaymentsController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_student
  before_action :set_payment, only: [ :show ]

  def index
    @payments = current_user.payments.order(created_at: :desc).includes(:booking)
  end

  def show
  end

  private
  def set_payment
    @payment = current_user.payments.find(params[:id])
  end
end
