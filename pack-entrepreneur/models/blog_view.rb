require 'csv'

class BlogView < ApplicationRecord
  belongs_to :blog
  
  def increase_views
    self.views += 1
    save!
  end

  def self.to_csv
    attributes = %w[id blog_title ip_address created_at]
    CSV.generate(headers: true) do |csv|
      csv << attributes
      all.each do |blog_view|
        #csv << blog_view.attributes.values_at(*attributes)
        csv << [ blog_view.id, blog_view.blog.title, blog_view.ip_address, blog_view.created_at ]
      end
    end
  end
end
