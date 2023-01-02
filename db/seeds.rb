# Deleting current users
puts "Cleaning databases..."
Blog.destroy_all
User.destroy_all

# Create an admin user
puts "Create admin user..."
user = User.new
user.first_name = "Alexandre"
user.last_name = "Stanescot"
user.email = "contact@as-consult.io"
user.role = "admin"
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
  puts "Cleaning blogs..."
  Blog.destroy_all
  # Create blog 1
  blog = Blog.new(title: "Blog1", content: "Hello World</br>How are you today?", views: 52, user_id: User.last.id, created_at: DateTime.current, updated_at: DateTime.current)
  if blog.save!
    puts "Blog 1 cretaed in test"
  else
    puts "Error creation Blog 1 in test"
  end
  # Create blog 2
  blog = Blog.new(title: "Blog2", content: "Hello World</br>Still nothing to say!", views: 2, user_id: User.last.id, created_at: DateTime.current, updated_at: DateTime.current)
  if blog.save!
    puts "Blog 1 cretaed in test"
  else
    puts "Error creation Blog 2 in test"
  end

end
