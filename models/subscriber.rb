class Subscriber < ApplicationRecord
  validates :name, :email, presence: true
  validates_format_of :email, with: URI::MailTo::EMAIL_REGEXP
  validates_inclusion_of :accept_private_data_policy, in: [ true ]
end
