require "test_helper"

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  test "Correct user should save" do
    user = users(:regular_user)
    assert user.save
  end

  test "user missing last_name should not save" do
    assert_not User.new(email: "test@example.com", password: "123456", first_name: "First name").save
  end

  test "user missing first_name should not save" do
    assert_not User.new(email: "test@example.com", password: "123456", last_name: "last name").save
  end

  test "new created user should have a role" do
    user = User.new(email: "test@example.com", password: "123456", last_name: "last name", first_name: "first name")
    assert_equal  user.role.nil?, false
  end

  test "user invalid email should not save" do
    assert_not User.new(email: "wrong_email", password: "123456", last_name: "last name", first_name: "first name").save
  end
end
