# Documentation
# https://guides.rubyonrails.org/rails_application_templates.html

# Test presence of 'env' file, only for email services
run 'if [ ! -e "../env" ]; then echo "File env not found, please check README.md" && exit 1; fi'

# GEMFILE
###################################
gem "devise"
gem "dotenv-rails"
gem 'whenever', '~> 1.0'
gem 'sassc-rails'

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
run "curl -L https:///raw.githubusercontent.com/alexstan67/rails-template/master/stylesheets.tar.gz > stylesheets.tar.gz"
run "tar -xf stylesheets.tar.gz --directory app/assets && rm stylesheets.tar.gz"
run "curl -L https:///raw.githubusercontent.com/alexstan67/rails-template/master/images.tar.gz > images.tar.gz"
run "tar -xf images.tar.gz --directory app/assets && rm images.tar.gz"

# config/environments/development.rb
########################################
environment 'config.action_mailer.default_url_options = { host: "http://localhost:3000" }', env: 'development'
environment 'config.action_mailer.default_url_options = { host: "http://TODO_PUT_YOUR_DOMAIN_HERE", :protocol => "http" }', env: 'production'

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
  # config/routes.rb
  ######################################
  route "root to: 'pages#home'"

  # Gem Devise
  ######################################
  generate('devise:install')

  # Adding a role, first_name, last_name to user
  generate('devise', 'User', 'role:integer', 'first_name:string', 'last_name:string')
  generate("devise:views")
  
  # Devise init
  gsub_file('config/initializers/devise.rb', "config.mailer_sender = 'please-change-me-at-config-initializers-devise@example.com'", "config.mailer_sender = 'noreply@aerostan.com'")

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

  # contact.rb
  generate(:model, "contact", "last_name:string", "first_name:string", "company:string", "email:string", "phone:string", "category:string", "description:text", "accept_private_data_policy:boolean", "active:boolean")

  # Loading all models
  run 'rm app/models/user.rb'
  run "curl -L https:///raw.githubusercontent.com/alexstan67/rails-template/master/models.tar.gz > models.tar.gz"
  run "tar -xf models.tar.gz --directory app/ && rm models.tar.gz"

  # Generators: db +  pages controller
  ######################################
  rails_command 'db:drop db:create db:migrate'
  generate(:controller, 'pages', 'home', '--skip-routes')
  generate(:controller, 'mentions-legales', 'index')
  generate(:controller, 'politique-confidentialite', 'index')
  generate(:controller, 'cgv', 'index')
  generate(:controller, 'services', 'index')
  generate(:controller, 'apropos', 'index')
  generate(:controller, 'faq', 'index')
  generate(:controller, 'contacts', 'new', '--skip-routes')
  run "rm app/controllers/contacts_controller.rb"
  run "curl -L https:///raw.githubusercontent.com/alexstan67/rails-template/master/controllers.tar.gz > controllers.tar.gz"
  run "tar -xf controllers.tar.gz --directory app/ && rm controllers.tar.gz"


  # Devise Authentication update
  ######################################
  inject_into_file "app/controllers/application_controller.rb", :after => "class ApplicationController < ActionController::Base\n" do
    <<-RUBY
    before_action :configure_permitted_parameters, if: :devise_controller?
    before_action :authenticate_user!
  
    protected
  
    def configure_permitted_parameters
      attributes = [ :last_name, :first_name ]
      devise_parameter_sanitizer.permit(:account_update, keys: attributes)
      devise_parameter_sanitizer.permit(:sign_up, keys: attributes)
    end
    RUBY
  end
  inject_into_file "app/controllers/pages_controller.rb", :after => "class PagesController < ApplicationController\n" do
    "  skip_before_action :authenticate_user!\n"
  end
  inject_into_file "app/controllers/mentions_legales_controller.rb", :before => "def index\n" do
    "  skip_before_action :authenticate_user!\n"
  end
  inject_into_file "app/controllers/politique_confidentialite_controller.rb", :before => "def index\n" do
    "  skip_before_action :authenticate_user!\n"
  end
  inject_into_file "app/controllers/cgv_controller.rb", :before => "def index\n" do
    "  skip_before_action :authenticate_user!\n"
  end
  inject_into_file "app/controllers/services_controller.rb", :before => "def index\n" do
    "  skip_before_action :authenticate_user!\n"
  end
  inject_into_file "app/controllers/apropos_controller.rb", :before => "def index\n" do
    "  skip_before_action :authenticate_user!\n"
  end
  inject_into_file "app/controllers/faq_controller.rb", :before => "def index\n" do
    "  skip_before_action :authenticate_user!\n"
  end

  # Update routes
  inject_into_file "config/routes.rb", :after => "Rails.application.routes.draw do\n" do
    "  resources :contacts\n"
  end

  # Views
  ########################################
  file "app/views/shared/_alerts.html.erb"
  file "app/views/shared/_navbar.html.erb"
  run "curl -L https://raw.githubusercontent.com/alexstan67/rails-template/master/views.tar.gz > views.tar.gz"
  run "tar -xf views.tar.gz --directory app/ && rm views.tar.gz"
  inject_into_file "app/views/layouts/application.html.erb", :after => "<%= csp_meta_tag %>\n" do
     "    <%= favicon_link_tag %>\n"
  end
  inject_into_file "app/views/layouts/application.html.erb", :after => "<body>\n" do
     "    <%= render 'shared/alerts' %>\n"
  end
  inject_into_file "app/views/layouts/application.html.erb", :after => "<body>\n" do
     "    <%= render 'shared/navbar' %>\n"
  end
  inject_into_file "app/views/layouts/application.html.erb", :after => "<%= yield %>\n" do
     "    <%= render 'shared/footer' %>\n"
  end
  inject_into_file "app/views/layouts/application.html.erb", :after => "<body>\n" do
     "  <div class='container'>\n"
  end
  inject_into_file "app/views/layouts/application.html.erb", :before => "</body>\n" do
   "</div>\n"
  end

  # Javascripts
  ########################################
  file "app/javascript/controllers/alerts_controller.js"
  file "app/javascript/controllers/burger_controller.js"
  file "app/javascript/controllers/account_controller.js"
  run "curl -L https://raw.githubusercontent.com/alexstan67/rails-template/master/javascript.tar.gz > javascript.tar.gz"
  run "tar -xf javascript.tar.gz --directory app/ && rm javascript.tar.gz"

  # Mailer
  ########################################
  run "curl -L https://raw.githubusercontent.com/alexstan67/rails-template/master/mailers.tar.gz > mailers.tar.gz"
  run "tar -xf mailers.tar.gz --directory app/ && rm mailers.tar.gz"

  # Seeds
  ########################################
  run "curl -L https://raw.githubusercontent.com/alexstan67/rails-template/master/db.tar.gz > db.tar.gz"
  run "tar -xf db.tar.gz && rm db.tar.gz"
  rails_command 'db:seed'

  # Capistrano config files
  ########################################
  run "bundle exec cap install STAGES=production"
  capfile = <<~RUBY
    require 'capistrano/rails'
    require 'capistrano/passenger'
    require 'capistrano/rbenv'
    require 'capistrano/rake'
    set :rbenv_type, :user
    set :rbenv_ruby, '3.1.3'
  RUBY
  append_file('Capfile', capfile)

  # i18n and locales
  ########################################
  # Translation files
  run "curl -L https://raw.githubusercontent.com/alexstan67/rails-template/master/locales.tar.gz > locales.tar.gz"
  run "tar -xf locales.tar.gz --directory config/ && rm locales.tar.gz"

  # Initializers
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

  # Git
  ########################################
  git :init
  git add: "."
  git commit: "-m 'Initial commit with template https://raw.githubusercontent.com/alexstan67/rails-template/master/template.rb'"

end
