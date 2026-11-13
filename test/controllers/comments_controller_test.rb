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
    assert_equal @article, Comment.order(:id).last.article
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
      delete article_comment_url(@article, comment), headers: auth_headers
    end

    assert_redirected_to article_url(@article)
    assert Article.exists?(@article.id)
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
    delete article_comment_url(@other_article, comments(:one)), headers: auth_headers

    assert_response :not_found
    assert Comment.exists?(comments(:one).id)
  end

  test "rejects unauthenticated comment deletion" do
    delete article_comment_url(@article, comments(:one))

    assert_response :unauthorized
    assert Comment.exists?(comments(:one).id)
  end

  test "allows multiple comments on the same article" do
    assert_difference("@article.comments.count", 2) do
      2.times do |index|
        post article_comments_url(@article), params: {
          comment: { commenter: "Reader #{index}", body: "Comment #{index}" }
        }
      end
    end

    assert_equal @article, Comment.order(:id).last.article
  end

  private

  def auth_headers
    { "HTTP_AUTHORIZATION" => ActionController::HttpAuthentication::Basic.encode_credentials(
      ENV.fetch("BLOG_USERNAME"), ENV.fetch("BLOG_PASSWORD")
    ) }
  end
end
