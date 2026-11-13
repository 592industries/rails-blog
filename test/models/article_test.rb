require "test_helper"

class ArticleTest < ActiveSupport::TestCase
  test "valid article" do
    assert Article.new(title: "A valid title").valid?
  end

  test "requires a title" do
    article = Article.new(title: "")
    assert_not article.valid?
    assert_includes article.errors[:title], "can't be blank"
  end

  test "requires a title of at least five characters" do
    article = Article.new(title: "Four")
    assert_not article.valid?
    assert_includes article.errors[:title], "is too short (minimum is 5 characters)"
  end

  test "has many comments" do
    assert_equal [ comments(:one) ], articles(:one).comments.to_a
  end

  test "destroys associated comments" do
    article = articles(:one)
    assert_difference("Comment.count", -article.comments.count) do
      article.destroy!
    end
  end
end
