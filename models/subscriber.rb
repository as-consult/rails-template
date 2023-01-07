class Subscriber < ApplicationRecord
  before_create :add_unsubscribe_hash

  validates :name, :email, presence: true
  validates_format_of :email, with: URI::MailTo::EMAIL_REGEXP
  validates_inclusion_of :accept_private_data_policy, in: [ true ]

  private

  def add_unsubscribe_hash
    self.unsubscribe_hash = SecureRandom.hex
  end
end
