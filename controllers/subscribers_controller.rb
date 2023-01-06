class SubscribersController < ApplicationController
  skip_before_action :authenticate_user!

  def create
    @subscriber = Subscriber.new(subscriber_input_params)
    if @subscriber.save
      cookies[:saved_subscriber] = true
      flash.notice = t("subscribers.flash.register_ok")
      redirect_to root_path
    else
      flash.alert = t("subscribers.flash.register_nok")
      redirect_to root_path
    end
  end

  private

  def subscriber_input_params
    params.permit(:name, :email, :accept_private_data_policy)
  end
end
