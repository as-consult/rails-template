class Faq < ApplicationRecord
  validates :lang, inclusion: { in: I18n.available_locales.map { |l| l.to_s }}
  validates :question, presence: true
  validates :answer, presence: true
end
