class Contact < ApplicationRecord
  CATEGORIES = ["Devis", "Problème Facturation", "Autre" ]

  validates :email, presence: true
  validates_format_of :email, with: URI::MailTo::EMAIL_REGEXP
  validates :category, inclusion: { in: CATEGORIES }
  validates :description, presence: true, length: { minimum: 10 }
end
