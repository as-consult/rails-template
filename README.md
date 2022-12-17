# Template for Rails 7

## Includes

- sassc
- devise
- dotenv-rails
- capistrano
- whenever

## BEFORE Installation

Ensure to have a "env" file at root directory containing devise confirmable email settings:

`MAIL_USERNAME=`

`MAIL_PASSWORD=`

`MAIL_DOMAIN=`

`MAIL_SMTP_SERVER=`

## Installation

`rails new APP_NAME --database=postgresql -m "https://raw.githubusercontent.com/alexstan67/rails-template/master/template.rb"`

## AFTER Installation

- config/environments/production.rb
  `config.action_mailer.default_url_options = { host: "http://TODO_PUT_YOUR_DOMAIN_HERE", :protocol => "http" }`

- app/mailers/application_mailer.rb
  `default from: "from@example.com"`
