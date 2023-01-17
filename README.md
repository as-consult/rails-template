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
MAIL_USERNAME=
MAIL_PASSWORD=
MAIL_DOMAIN=
MAIL_SMTP_SERVER=
CONTACT_FORM_RECIPIENT=
````

## Project Creation

`rails new APP_NAME --database=postgresql -m "https://raw.githubusercontent.com/alexstan67/rails-template/master/template.rb"`

## AFTER Project Creation
We will use here [Capistrano](https://github.com/capistrano/capistrano) to deploy in production.
### Client Side
````ruby
# gemfile
group :development do
  gem 'capistrano', '~> 3.11'
  gem 'capistrano-rake', require: false
  gem 'capistrano', '~> 3.11'
  gem 'capistrano-rails', '~> 1.4'
  gem 'capistrano-passenger', '~> 0.2.0'
  gem 'capistrano-rbenv', '~> 2.1', '>= 2.1.4'
end
````
````bash
bundle
bundle exec cap install STAGES=production
````
````ruby
# config/environments/production.rb
config.action_mailer.default_url_options = { host: "http://TODO_PUT_YOUR_DOMAIN_HERE", :protocol => "http" }
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
