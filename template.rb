# Test presence of 'env' file
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

#gsub_file('Gemfile', /# gem 'sassc-rails'/, "gem 'sassc-rails'")

# app/assets
########################################
run 'rm -rf app/assets/stylesheets'
run 'rm -rf vendor'
# local way
#run "tar -xf ../stylesheets.tar.gz --directory app/assets"
#run "tar -xf ../images.tar.gz --directory app/assets"

# Github way
run "curl -L https:///raw.githubusercontent.com/alexstan67/rails-template/master/stylesheets.tar.gz > stylesheets.tar.gz"
run "tar -xf stylesheets.tar.gz --directory app/assets && rm stylesheets.tar.gz"
run "curl -L https:///raw.githubusercontent.com/alexstan67/rails-template/master/images.tar.gz > images.tar.gz"
run "tar -xf images.tar.gz --directory app/assets && rm images.tar.gz"

#run "curl -L https://github.com/alexstan67/css-components/raw/master/scss/stylesheets.zip > stylesheets.zip"
#run "unzip stylesheets.zip -d app/assets && rm -f stylesheets.zip"

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

  # Gem Devise + user model + init
  ######################################
  generate('devise:install')
  generate('devise', 'User')
  generate("devise:views")
  
  gsub_file(
    "app/views/devise/registrations/new.html.erb",
    "<%= form_for(resource, as: resource_name, url: registration_path(resource_name)) do |f| %>",
    "<%= form_for(resource, as: resource_name, url: registration_path(resource_name), data: { turbo: :false }) do |f| %>"
  )
  gsub_file(
    "app/views/devise/sessions/new.html.erb",
    "<%= form_for(resource, as: resource_name, url: session_path(resource_name)) do |f| %>",
    "<%= form_for(resource, as: resource_name, url: session_path(resource_name), data: { turbo: :false }) do |f| %>"
  )
  link_to = <<~HTML
    <p>Unhappy? <%= link_to "Cancel my account", registration_path(resource_name), data: { confirm: "Are you sure?" }, method: :delete %></p>
  HTML
  button_to = <<~HTML
    <div class="d-flex align-items-center">
      <div>Unhappy?</div>
      <%= button_to "Cancel my account", registration_path(resource_name), data: { confirm: "Are you sure?" }, method: :delete, class: "btn btn-link" %>
    </div>
  HTML
  gsub_file("app/views/devise/registrations/edit.html.erb", link_to, button_to)

  gsub_file('config/initializers/devise.rb', "config.mailer_sender = 'please-change-me-at-config-initializers-devise@example.com'", "config.mailer_sender = 'noreply@aerostan.com'")

  #Hereunder we extend devise to :confirmable, :trackable, :lockable, :rememberable, :recoverable
  run 'rm app/models/user.rb'
  file 'app/models/user.rb'
  append_to_file 'app/models/user.rb' do
    <<~RUBY
    class User < ApplicationRecord
    # Remainings timeoutable :omniauthable
      devise :database_authenticatable, :registerable,
             :recoverable, :rememberable, :validatable,
             :trackable, :confirmable, :lockable
    end
    RUBY
  end 

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
  generate(:controller, 'contacts', 'new')

  # Devise Authentication update
  ######################################
  inject_into_file "app/controllers/application_controller.rb", :after => "class ApplicationController < ActionController::Base\n" do
    "  before_action :authenticate_user!\n"
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
  inject_into_file "app/controllers/contacts_controller.rb", :before => "def new\n" do
    "  skip_before_action :authenticate_user!\n"
  end
  
end

# View shared
########################################
file "app/views/shared/_alerts.html.erb"
file "app/views/shared/_navbar.html.erb"
run "curl -L https://raw.githubusercontent.com/alexstan67/rails-template/master/shared.tar.gz > shared.tar.gz"
run "tar -xf shared.tar.gz --directory app/views && rm shared.tar.gz"
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
run "tar -xf javascript.tar.gz --directory app/javascript/controllers && rm javascript.tar.gz"

# Pages
########################################
after_bundle do
  run "rm app/views/pages/home.html.erb"
  run "curl -L https://raw.githubusercontent.com/alexstan67/rails-template/master/pages.tar.gz > pages.tar.gz"
  run "tar -xf pages.tar.gz --directory app/views/ && rm pages.tar.gz"
end
