class ContactsMailer < ApplicationMailer
   default from: 'noreply@aerostan.com'

  def new_submission
    @contact = params[:contact]
    mail(to: @contact.email, subject: "[#{@contact.category}] - #{@contact.email}")
  end
end
