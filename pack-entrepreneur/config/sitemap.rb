# Set the host name for URL creation
SitemapGenerator::Sitemap.default_host = "https://www.TO_UPDATE"

SitemapGenerator::Sitemap.create do
  # Put links creation logic here.
  #
  # The root path '/' and sitemap index file are added automatically for you.
  # Links are added to the Sitemap in the order they are specified.
  #
  # Usage: add(path, options={})
  #        (default options are used if you don't specify)
  #
  # Defaults: :priority => 0.5, :changefreq => 'weekly',
  #           :lastmod => Time.now, :host => default_host
  #
  # Examples:
  #
  # Add '/articles'
  #
  #   add articles_path, :priority => 0.7, :changefreq => 'daily'
  #
  # Add all articles:
  #
  #   Article.find_each do |article|
  #     add article_path(article), :lastmod => article.updated_at
  #   end

  add services_index_path,  :priority => 0.8, :changefreq => 'daily'
  add apropos_index_path,   :priority => 0.8, :changefreq => 'daily'
  add blogs_path,           :priority => 0.8, :changefreq => 'daily'
  add faqs_index_path,      :priority => 0.8, :changefreq => 'daily'
  add new_contact_path,     :priority => 0.8, :changefreq => 'daily'

  I18n.available_locales.each do |locale| 
    Blog.find_each do |b|
      add url_for(:controller => 'blogs', :action => 'show', :id => b, :host => '', :only_path => true, :locale => locale), :lastmod => b.updated_at
    end
  end
  
end
