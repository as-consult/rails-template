class BlogView < ApplicationRecord
  belongs_to :blog
  
  def increase_views
    self.views += 1
    save!
  end
end
