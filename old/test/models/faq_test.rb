require "test_helper"

class FaqTest < ActiveSupport::TestCase
  
  test "Normal question should save" do
    question = faqs(:question_one)
    assert question.save
  end

  test "Only available locales should save" do
    question = faqs(:question_two)
    #By default we accept :fr and :en
    assert_equal I18n.available_locales.include?(question.lang), false
  end

  test "A question should be present to save" do
    assert_not Faq.new(answer: "This is an answer", lang: "en").save
  end
  
  test "An answer should be present to save" do
    assert_not Faq.new(question: "This is a question", lang: "en").save
  end
end
