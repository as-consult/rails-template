# Documentation
# https://guides.rubyonrails.org/rails_application_templates.html

# Test presence of 'env' file, only for email services
run 'if [ ! -e "../env" ]; then echo "File env not found, please check README.md" && exit 1; fi'

# GEMFILE
###################################
gem "devise"
gem "dotenv-rails"
#gem 'whenever', '~> 1.0'
gem 'sassc-rails'
#gem 'image_processing', '~> 1.12'
#gem 'chartkick', '~> 4.2', '>= 4.2.1'
#gem 'groupdate', '~> 6.1'
#gem 'sitemap_generator', '~> 6.3'
gem 'ed25519', '>= 1.2', '< 2.0'
gem 'bcrypt_pbkdf', '>= 1.0', '< 2.0'

gem_group :development do
  gem 'capistrano-rake', require: false
  gem 'capistrano', '~> 3.11'
  gem 'capistrano-rails', '~> 1.4'
  gem 'capistrano-passenger', '~> 0.2.0'
  gem 'capistrano-rbenv', '~> 2.1', '>= 2.1.4'
end

# app/assets
########################################
run 'rm -rf app/assets/stylesheets'
run 'rm -rf vendor'
run "curl -L https:///raw.githubusercontent.com/alexstan67/rails-template/master/kickstart/stylesheets.tar.gz > stylesheets.tar.gz"
run "tar -xf stylesheets.tar.gz --directory app/assets && rm stylesheets.tar.gz"
run "curl -L https:///raw.githubusercontent.com/alexstan67/rails-template/master/kickstart/images.tar.gz > images.tar.gz"
run "tar -xf images.tar.gz --directory app/assets && rm images.tar.gz"

# config/environments/development.rb
########################################
environment 'config.action_mailer.default_url_options = { host: "http://localhost:3000" }', env: 'development'

# config/environments/test.rb
########################################
environment 'config.action_mailer.default_url_options = { host: "http://localhost:3000" }', env: 'test'

# config/environments/production.rb
########################################
environment 'config.action_mailer.default_url_options = { host: "http://TODO_PUT_YOUR_DOMAIN_HERE", :protocol => "http" }', env: 'production'
environment 'config.active_storage.service = :production', env: 'production'


# config/environment.rb
########################################
inject_into_file "config/environment.rb", after: "Rails.application.initialize!\n" do
  <<~RUBY
  # ActionMailer setup
  Rails.application.config.assets.paths << Rails.root.join("node_modules")
  ActionMailer::Base.delivery_method = :smtp
  ActionMailer::Base.perform_deliveries = true
  ActionMailer::Base.smtp_settings = {
  :address              => ENV["MAIL_SMTP_SERVER"],
  :port                 => 587,
  :domain               => ENV["MAIL_DOMAIN"],
  :user_name            => ENV["MAIL_USERNAME"],
  :password             => ENV["MAIL_PASSWORD"],
  :authentication       => :plain,
  :enable_starttls_auto => true }
  RUBY
end

# config/application.rb
########################################
application 'config.time_zone = "Europe/Paris"'

# .env
########################################
run 'cp ../env .env'

# .gitignore
########################################
inject_into_file ".gitignore", after: "/config/master.key\n" do
  <<~GIT
  \n
  # AS-Consult specific
  *.swp
  *.env
  /public/sitemap.xml.gz
  GIT
end

# config/databases.yml | development
########################################
inject_into_file "config/database.yml", :after => "#password:\n" do
    "  username: rubyuser\n"
end
inject_into_file "config/database.yml", :after => "username: rubyuser\n" do
    "  port: 5432\n"
end
inject_into_file "config/database.yml", :after => "username: rubyuser\n" do
    "  host: localhost\n"
end
inject_into_file "config/database.yml", :after => "username: rubyuser\n" do
    "  password: rubyuser\n"
end

# config/databases.yml | test
########################################
inject_into_file "config/database.yml", :before => "#   production:", force: true do
    "  username: rubyuser\n"
end
inject_into_file "config/database.yml", :before => "#   production:", force: true do
    "  password: rubyuser\n"
end
inject_into_file "config/database.yml", :before => "#   production:", force: true do
    "  host: localhost\n"
end
inject_into_file "config/database.yml", :before => "#   production:", force: true do
    "  port: 5432\n"
end

# AFTER BUNDLE
########################################
after_bundle do

  # Gem Devise
  ######################################
  generate('devise:install')

  # Adding a role, first_name, last_name to user
  generate('devise', 'User', 'role:integer', 'first_name:string', 'last_name:string')
  generate("devise:views")
  
  # Devise init
  gsub_file('config/initializers/devise.rb', "config.mailer_sender = 'please-change-me-at-config-initializers-devise@example.com'", "config.mailer_sender = 'noreply@as-consult.io'")

  # Remove devise default translations
  run 'rm config/locales/devise.en.yml'
  run 'rm config/locales/en.yml'

  # Solve turbo-links issues with flash notice
  inject_into_file 'config/initializers/devise.rb', :after => "# config.navigational_formats = ['*/*', :html, :turbo_stream]\n" do
    "  config.navigational_formats = ['*/*', :html, :turbo_stream]\n"
  end

  # Active Storage
  ######################################
  #rails_command 'active_storage:install'

  #storage_production = <<~YML
  #production:
  #  service: Disk
  #  root: <%= Rails.root.join("../shared/storage") %>
  #YML
  #prepend_to_file('config/storage.yml', storage_production)
  #gsub_file('config/environments/production.rb', 'config.active_storage.service = :local', 'config.active_storage.service = :production')

  # Models
  ######################################
  # user.rb
  # extended devise with: :confirmable, :trackable, :lockable, :rememberable, :recoverable
  generate(:migration, "AddDeviseOptionsToUser",  "sign_in_count:integer",
                                                  "current_sign_in_at:datetime",
                                                  "last_sign_in_at:datetime",
                                                  "current_sign_in_ip:string",
                                                  "last_sign_in_ip:string",
                                                  "confirmation_token:string",
                                                  "confirmed_at:datetime",
                                                  "confirmation_sent_at:datetime",
                                                  "unconfirmed_email:string",
                                                  "failed_attempts:integer",
                                                  "unlock_token:string",
                                                  "locked_at:datetime"
  )
  
  generate(:migration, "ChangeSignInCountToUser",  "sign_in_count:string")

  # Loading all models
  run 'rm app/models/user.rb'
  run "curl -L https:///raw.githubusercontent.com/alexstan67/rails-template/master/kickstart/models.tar.gz > models.tar.gz"
  run "tar -xf models.tar.gz --directory app/ && rm models.tar.gz"

  # Generators: db
  ######################################
  rails_command 'db:drop db:create db:migrate'

  # Controllers
  ######################################
  generate(:controller, 'pages', 'home', 'console', '--skip-routes')

  # Views
  ########################################
  file "app/views/shared/_alerts.html.erb"
  file "app/views/shared/_navbar.html.erb"
  run "curl -L https://raw.githubusercontent.com/alexstan67/rails-template/master/kickstart/views.tar.gz > views.tar.gz"
  run "tar -xf views.tar.gz --directory app/ && rm views.tar.gz"
  inject_into_file "app/views/layouts/application.html.erb", :after => "<%= csp_meta_tag %>\n" do
    <<~RUBY
    <%= favicon_link_tag %>
    <title><%= meta_product %></title>
    <!-- Primary Meta Tags -->
    <meta name="title" content="<%= meta_title %>">
    <meta name="description" content="<%= meta_description %>">
    <!-- Open Graph / Facebook -->
    <meta property="og:type" content="website">
    <meta property="og:url" content="<%= request.original_url %>">
    <meta property="og:title" content="<%= meta_title %>">
    <meta property="og:description" content="<%= meta_description %>">
    <meta property="og:image" content="<%= meta_image %>">
    <!-- Twitter -->
    <!--
    <meta name="twitter:card" content="summary_large_image">
    <meta name="twitter:site" content="<%= DEFAULT_META["twitter_account"] %>">
    <meta name="twitter:title" content="<%= meta_title %>">
    <meta name="twitter:description" content="<%= meta_description %>">
    <meta name="twitter:creator" content="<%= DEFAULT_META["twitter_account"] %>">
    <meta name="twitter:image:src" content="<%= meta_image %>">
    -->
    <link rel="canonical" href="<%= url_for(:only_path => false) %>" />
    RUBY
  end
  inject_into_file "app/views/layouts/application.html.erb", :after => "<body>\n" do
     "    <%= render 'shared/alerts' %>\n"
  end
  inject_into_file "app/views/layouts/application.html.erb", :after => "<body>\n" do
     "    <%= render 'shared/navbar' %>\n"
  end
  inject_into_file "app/views/layouts/application.html.erb", :after => "<body>\n" do
     "  <div class='container'>\n"
  end
  inject_into_file "app/views/layouts/application.html.erb", :before => "</body>\n" do
   "</div>\n"
  end
  gsub_file("app/views/layouts/application.html.erb","<html>", '<html lang="<%= I18n.locale %>">')

  # Javascripts
  ########################################
  file "app/javascript/controllers/alerts_controller.js"
  file "app/javascript/controllers/burger_controller.js"
  file "app/javascript/controllers/account_controller.js"
  run "curl -L https://raw.githubusercontent.com/alexstan67/rails-template/master/kickstart/javascript.tar.gz > javascript.tar.gz"
  run "tar -xf javascript.tar.gz --directory app/ && rm javascript.tar.gz"

  # Helpers
  ########################################
  run "curl -L https://raw.githubusercontent.com/alexstan67/rails-template/master/kickstart/helpers.tar.gz > helpers.tar.gz"
  run "tar -xf helpers.tar.gz --directory app/ && rm helpers.tar.gz"

  # Capistrano config files
  ########################################
  run "bundle exec cap install STAGES=production"
  capfile = <<~RUBY
    require 'capistrano/rails'
    require 'capistrano/passenger'
    require 'capistrano/rbenv'
    require 'capistrano/rake'
    require 'capistrano/sitemap_generator'
    set :rbenv_type, :user
    set :rbenv_ruby, '3.1.3'
  RUBY
  append_file('Capfile', capfile)

  # Config files
  ########################################
  # Config folder including i18n
  run "curl -L https://raw.githubusercontent.com/alexstan67/rails-template/master/kickstart/config.tar.gz > config.tar.gz"
  run "tar -xf config.tar.gz && rm config.tar.gz"

  # i18n
  ########################################
  file "config/initializers/locale.rb"
  locale = <<~RUBY
  # Where the I18n library should search for translation files
  I18n.load_path += Dir[Rails.root.join('lib', 'locale', '*.{rb,yml}')]
  # Permitted locales available for the application
  I18n.available_locales = [:en, :fr]
  # Set default locale to something other than :en
  I18n.default_locale = :fr
  RUBY
  append_file("config/initializers/locale.rb", locale)
  
  # seo - meta tags
  ########################################
  file("config/meta.yml")
  meta_config =<<~RUBY
    meta_product_name: "Product Name"
    meta_title: "Product name | Product tagline"
    meta_description: "Relevant description"
    meta_image: "" # should exist in `app/assets/images/`
    #twitter_account: "@product_twitter_account"   # required for Twitter Cards
  RUBY
  append_file("config/meta.yml", meta_config)

  file("config/initializers/default_meta.rb")
  append_file("config/initializers/default_meta.rb", 'DEFAULT_META = YAML.load_file(Rails.root.join("config/meta.yml"))')

  # Git
  ########################################
  git :init
  git add: "."
  git commit: "-m 'Initial commit with template https://raw.githubusercontent.com/alexstan67/rails-template/master/template.rb'"

end
