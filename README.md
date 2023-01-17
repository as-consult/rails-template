# Template for Rails 7
This template generates a full working webiste based on Ruby On Rails framework. It is intended to be customized afterwards.

## Includes

- sassc
- devise
- dotenv-rails
- image_processing
- capistrano
- chartkick
- groupdate 
- active_storage

## BEFORE Project Creation

Ensure to have a "env" file at root directory containing devise confirmable email settings and contact form recipient:
````bash
MAIL_USERNAME=noreply
MAIL_PASSWORD=password
MAIL_DOMAIN=example.com
MAIL_SMTP_SERVER=example.com
CONTACT_FORM_RECIPIENT=noreply@example.com
````

## Project Creation

`rails new APP_NAME --database=postgresql -m "https://raw.githubusercontent.com/alexstan67/rails-template/master/template.rb"`

## AFTER Project Creation
We will use here [Capistrano](https://github.com/capistrano/capistrano) to deploy in production.
### Client Side
````ruby
# config/environments/production.rb
config.action_mailer.default_url_options = { host: "http://TODO_PUT_YOUR_DOMAIN_HERE", :protocol => "http" }
````
````ruby
# config/initializers/devise.rb
config.mailer_sender = 'example@test.com'
````
````ruby
# Capfile
require 'capistrano/rails'
require 'capistrano/passenger'
require 'capistrano/rbenv'
require 'capistrano/rake'
# At the end of the file
set :rbenv_type, :user
set :rbenv_ruby, '3.0.3' # or whatever version you chose
````
````ruby
# config/deploy.rb
set :application, "APP_NAME"
set :repo_url, "git@github.com:user/APP_NAME.git"
set :branch, 'main'
# Deploy to the user's home directory
set :deploy_to, "/home/deploy/#{fetch :application}"
append :linked_dirs, 'log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', '.bundle', 'public/system', 'public/uploads'
append :linked_files, ".env.production"
# Only keep the last 5 releases to save disk space
set :keep_releases, 5
````
````ruby
# config/deploy/production
server 'SERVER_IP', user: 'deploy', roles: %w{app db web}
````

`bundle exec rails secret`

````ruby
# config/environments/production.rb
config.action_mailer.default_url_options = { host: 'yourdomain', :protocol => 'http' }
````
````ruby
# The admin user is created via the seeds
# db/seeds.rb
user.email = "contact@as-consult.io"
user.role = "admin"
user.password = "password123"
````
### Server Side
#### .rbenv-vars
````bash
mkdir -p ~/APP_NAME/shared
vi /home/deploy/APP_NAME/.rbenv-vars
DATABASE_URL=postgresql://DB_USER:DB_PASSWORD@DB_DOMAIN/APP_NAME_production
SECRET_KEY_BASE=# the result of above bundle exec rails secret
````
#### .env.production
Execute on client side:

`scp .env deploy@SERVER_IP:/home/deploy/APP_NAME/shared/.env.production`

### Deploy on production server
`cap production deploy`
