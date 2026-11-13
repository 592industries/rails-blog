require "test_helper"

class CommentsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @article = articles(:one)
    @other_article = articles(:two)
  end

  test "creates a comment" do
    assert_difference("Comment.count") do
      post article_comments_url(@article), params: { comment: { commenter: "Jane", body: "Great post" } }
    end

    assert_redirected_to article_url(@article)
  end

  test "renders validation errors for an invalid comment" do
    assert_no_difference("Comment.count") do
      post article_comments_url(@article), params: { comment: { commenter: "", body: "" } }
    end

    assert_response :unprocessable_content
    assert_select "[role=alert]"
  end

  test "destroys a comment" do
    comment = comments(:one)
    assert_difference("Comment.count", -1) do
      delete article_comment_url(@article, comment)
    end

    assert_redirected_to article_url(@article)
  end

  test "returns not found for a missing article" do
    post article_comments_url(article_id: -1), params: { comment: { commenter: "Jane", body: "Hello" } }
    assert_response :not_found
  end

  test "returns not found for a missing comment" do
    delete article_comment_url(@article, id: -1)
    assert_response :not_found
  end

  test "prevents deleting a comment through another article" do
    delete article_comment_url(@other_article, comments(:one))

    assert_response :not_found
    assert Comment.exists?(comments(:one).id)
  end
end
