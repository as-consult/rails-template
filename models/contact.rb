class Contact < ApplicationRecord
  CATEGORIES = [  I18n.t('activerecord.attributes.contact.categories.quotation'),
                  I18n.t('activerecord.attributes.contact.categories.invoicing_problem'),
                  I18n.t('activerecord.attributes.contact.categories.other') ]

  validates :email, presence: true
  validates_format_of :email, with: URI::MailTo::EMAIL_REGEXP
  validates :category, inclusion: { in: CATEGORIES }
  validates :description, presence: true, length: { minimum: 10 }
  validates_inclusion_of :accept_private_data_policy, in: [ true ]
  validates_inclusion_of :active, in: [ true, false ]

end
