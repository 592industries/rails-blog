require "test_helper"

class CommentTest < ActiveSupport::TestCase
  test "valid comment" do
    assert Comment.new(commenter: "Jane", body: "Hello", article: articles(:one)).valid?
  end

  test "requires a commenter" do
    comment = Comment.new(body: "Hello", article: articles(:one))
    assert_not comment.valid?
    assert_includes comment.errors[:commenter], "can't be blank"
  end

  test "requires a body" do
    comment = Comment.new(commenter: "Jane", article: articles(:one))
    assert_not comment.valid?
    assert_includes comment.errors[:body], "can't be blank"
  end

  test "requires an article" do
    comment = Comment.new(commenter: "Jane", body: "Hello", article: nil)
    assert_not comment.valid?
    assert_includes comment.errors[:article], "must exist"
  end

  test "belongs to an article" do
    assert_equal articles(:one), comments(:one).article
  end
end
