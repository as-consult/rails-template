class ContactsMailer < ApplicationMailer
  default from: 'noreply@aerostan.com'

  def new_submission
    @contact = params[:contact]
    recipient = params[:recipient]
    mail(to: recipient, subject: "[#{@contact.category}] - #{@contact.email}")
  end
end
