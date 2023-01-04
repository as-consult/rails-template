# Deleting current users
puts "---"
puts "All Environment Seeds"
puts "---"
puts "Cleaning databases..."
Blog.destroy_all
User.destroy_all
Faq.destroy_all

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
  puts "---"
  puts "Test Specific Environment Seeds"
  puts "---"
  # #####################
  # BLOGS
  # #####################
  puts "Cleaning blogs..."
  Blog.destroy_all
  # Create blog 1
  blog = Blog.new(title: "Mon premier Billet!", content: "Hello World</br>How are you today?", views: 52, user_id: User.last.id, created_at: DateTime.current, updated_at: DateTime.current)
  if blog.save!
    puts "Blog#1 cretaed in test"
  else
    puts "Error creation Blog#1 in test"
  end
  # Create blog 2
  blog = Blog.new(title: "Et v'la, un autre!", content: "Hello World</br>Still nothing to say!", views: 2, user_id: User.last.id, created_at: DateTime.current, updated_at: DateTime.current)
  if blog.save!
    puts "Blog#2 cretaed in test"
  else
    puts "Error creation Blog#2 in test"
  end

  # #####################
  # FAQS
  # #####################
  puts "Cleaning FAQs..."
  Faq.destroy_all
  # Create FAQ1
  faq = Faq.new( question: "Pourquoi n’y a-t-il pas de remboursement possible?", 
                 answer: "In finibus vestibulum pretium. Nunc vel suscipit ligula. Nullam orci orci, sagittis ut egestas nec, viverra nec diam. Vivamus commodo nibh nulla, nec interdum nisi semper ut. Vestibulum lacinia, felis eget aliquam convallis, urna enim vulputate felis, eu porta purus lacus et sapien. Aliquam convallis in dui vitae pellen tesque. Integer sagittis semper vestibulum.",
                 lang: "fr",
                 rank: 1)
  if faq.save!
    puts "FAQ#1 created in test"
  else
    puts "Error creation FAQ#1 in test"
  end
  # Create FAQ2
  faq = Faq.new( question: "Quels sont vos délais d'envoi des achats?", 
                 answer: "In finibus vestibulum pretium. Nunc vel suscipit ligula. Nullam orci orci, sagittis ut egestas nec, viverra nec diam. Vivamus commodo nibh nulla, nec interdum nisi semper ut. Vestibulum lacinia, felis eget aliquam convallis, urna enim vulputate felis, eu porta purus lacus et sapien. Aliquam convallis in dui vitae pellen tesque. Integer sagittis semper vestibulum.",
                 lang: "fr",
                 rank: 2)
  if faq.save!
    puts "FAQ#2 created in test"
  else
    puts "Error creation FAQ#2 in test"
  end
  # Create FAQ3
  faq = Faq.new( question: "Pourquoi avez-vous arrêté de commercialiser le produit X?", 
                 answer: "In finibus vestibulum pretium. Nunc vel suscipit ligula. Nullam orci orci, sagittis ut egestas nec, viverra nec diam. Vivamus commodo nibh nulla, nec interdum nisi semper ut. Vestibulum lacinia, felis eget aliquam convallis, urna enim vulputate felis, eu porta purus lacus et sapien. Aliquam convallis in dui vitae pellen tesque. Integer sagittis semper vestibulum.",
                 lang: "fr",
                 rank: 3)
  if faq.save!
    puts "FAQ#3 created in test"
  else
    puts "Error creation FAQ#3 in test"
  end
end
