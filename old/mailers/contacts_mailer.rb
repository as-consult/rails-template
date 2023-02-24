class ContactsMailer < ApplicationMailer

  def new_submission
    @contact = params[:contact]
    recipient = params[:recipient]
    mail(to: recipient, subject: default_i18n_subject(category: @contact.category))
  end
end
