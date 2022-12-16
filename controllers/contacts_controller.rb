class ContactsController < ApplicationController
  skip_before_action :authenticate_user!
  def new
    @contact = Contact.new
    @categories = Contact::CATEGORIES
  end

  def create
    @contact = Contact.new(contact_input_params)
    @contact.active = true  #False would mean not accepting any emails from company

    if @contact.save
      redirect_to root_path
    else
      render "new", contact: @contact
    end
  end

  private

  def contact_input_params
    params.require(:contact).permit(:first_name, :last_name, :company, :email, :phone, :category, :description, :accept_private_data_policy, :active)

  end
end
