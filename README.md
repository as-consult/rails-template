# Template for Rails 7

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

`MAIL_USERNAME=`

`MAIL_PASSWORD=`

`MAIL_DOMAIN=`

`MAIL_SMTP_SERVER=`

`CONTACT_FORM_RECIPIENT=`

## Project Creation

`rails new APP_NAME --database=postgresql -m "https://raw.githubusercontent.com/alexstan67/rails-template/master/template.rb"`

## AFTER Project Creation

- config/environments/production.rb
  `config.action_mailer.default_url_options = { host: "http://TODO_PUT_YOUR_DOMAIN_HERE", :protocol => "http" }`

- app/mailers/application_mailer.rb
  `default from: "from@example.com"`

- Deployment Setup Client

    - Capfile
    - config/deploy.rb
    - config/deploy/production
    - run: `bundle exec rails secret`

- Deployment Setup Server

    - /home/deploy/*APP_NAME*/.rbenv-vars

        - DATABASE_URL=
        - SECRET_KEY_BASE=

    - copy .env to /home/deploy/*APP_NAME*/shared/.env.production

- Deploy in Production

    `cap production deploy`
