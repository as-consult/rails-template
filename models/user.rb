class User < ApplicationRecord
# Remainings timeoutable :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :trackable, :confirmable, :lockable
  #enum role: [ :user, :admin ]
  #after_initialize :set_default_role, if: :new_record?

  private

  def set_default_role
    self.role ||= :user
  end 
end
