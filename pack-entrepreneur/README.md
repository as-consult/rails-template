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

`rails new APP_NAME --database=postgresql -m "https://raw.githubusercontent.com/alexstan67/rails-template/master/pack-entrepreneur-template.rb"`

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

#### Seeds

````ruby
# The admin user is created via the seeds
# db/seeds.rb
user.email = "contact@as-consult.io"
user.role = "admin"
user.password = "password123"
````

#### Sitemap

````ruby
#config/sitemap.rb
SitemapGenerator::Sitemap.default_host = "https://www.TO_UPDATE"
````
````ruby
#public/robots.txt
Sitemap: https://TO_UPDATE/sitemap.xml.gz
````
````bash
#Available capistrano tasks:
cap production sitemap:create   #Create sitemaps without pinging search engines
cap production sitemap:refresh  #Create sitemaps and ping search engines
cap production sitemap:clean    #Clean up sitemaps in the sitemap path
````
#### seo and meta tags configurations
````bash
#config/meta.yml
#app/views/blogs/_seo.html.erb
#app/views/pages/_seo.html.erb
#app/views/faqs/_seo.html.erb
#app/views/services/_seo.html.erb
#app/views/apropos/_seo.html.erb
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

To seed the database, run on server side in current folder:

`bundle exec rake db:seed RAILS_ENV=production`
