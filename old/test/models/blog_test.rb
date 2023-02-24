require "test_helper"

class BlogTest < ActiveSupport::TestCase

  test "Correct blog should save" do
    blog = blogs(:blog_one)
    assert blog.save
  end

  test "Blog without title should not save" do
    assert_not Blog.new(user: users(:regular_user), content: "This is a content").save
  end

  test "Blog without content should not save" do
    assert_not Blog.new(user: users(:regular_user), title: "This is a title").save
  end

  test "Blog with too short title should not save" do
    assert_not Blog.new(user: users(:regular_user), title: "12", content: "This is a content").save
  end

  test "Blog with too short content should not save" do
    assert_not Blog.new(user: users(:regular_user), title: "Title", content: "content").save
  end

  test "Blog destroy should work" do
    blog = blogs(:blog_two)
    assert blog.destroy
  end

end
