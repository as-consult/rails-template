class Blog < ApplicationRecord
  has_one_attached :picture do | attachable |
    attachable.variant :thumb, resize_to_fill: [ 100, 100 ]
    attachable.variant :thumb_big, resize_to_limit: [ 200, 200 ]
  end
  belongs_to :user

  validates :title, presence: true, length: { minimum: 3 }
  validates :content, presence: true, length: { minimum: 10 }
  validate :picture_format
  
  def increase_views
    self.views += 1
    save!
  end
  
  private
  
  def picture_format
    return unless picture.attached?
    if picture.blob.content_type.start_with? 'image/'
      if picture.blob.byte_size > 5.megabytes
        errors.add(:picture, I18n.t('blogs.errors.image_size'))
        picture.purge
      end
    else
      picture.purge
      errors.add(:picture, I18n.t('blogs.errors.file_type'))
    end
  end

end
