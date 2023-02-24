require "test_helper"

class ContactTest < ActiveSupport::TestCase

  test "Correct contact form should save" do
    contact = contacts(:contact_form_one)
    assert contact.save
  end

  test "Correct contact form with minimum fields should save" do
    contact = contacts(:contact_form_two)
    assert contact.save
  end
  
  test "Correct contact form without category should not save" do
    contact = contacts(:contact_form_tree)
    assert_not contact.save
  end

  test "Too short description should not save" do
    contact = Contact.new(email: "test@example.com", description: "Too short", accept_private_data_policy: true)
    assert_not contact.save
  end

  test "Contact form should accept privacy policy" do
    contact = Contact.new(email: "test@example.com", description: "Too short", accept_private_data_policy: false)
    assert_not contact.save
  end

end
