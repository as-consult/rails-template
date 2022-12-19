# Deleting current users
puts "Cleaning databases..."
User.destroy_all

# Create an admin user
puts "Create admin user..."
user = User.new
user.first_name = "Alexandre"
user.last_name = "Stanescot"
user.email = "contact@as-consult.io"
user.role = :admin
user.password = "password123"
user.confirmed_at = Time.zone.now - 1.hour
user.confirmation_sent_at = Time.zone.now - 2.hours
if user.valid?
  puts "Admin user created"
  user.save
else
  user.errors.each do | error |
    puts "#{error.full_message}"
  end
  puts "Error in admin user creation"
end

# Development specific tests
if Rails.env.development?
  #
end
