require "test_helper"

class ArticlesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @article = articles(:one)
  end

  test "should get index" do
    get articles_url
    assert_response :success
  end

  test "should get new" do
    get new_article_url, headers: auth_headers
    assert_response :success
  end

  test "should create article" do
    assert_difference("Article.count") do
      post articles_url, params: { article: { body: @article.body, title: @article.title } }, headers: auth_headers
    end

    assert_redirected_to article_url(Article.last)
  end

  test "should show article" do
    get article_url(@article)
    assert_response :success
  end

  test "should get edit" do
    get edit_article_url(@article), headers: auth_headers
    assert_response :success
  end

  test "should update article" do
    patch article_url(@article), params: { article: { body: @article.body, title: @article.title } }, headers: auth_headers
    assert_redirected_to article_url(@article)
  end

  test "should destroy article" do
    assert_difference("Article.count", -1) do
      delete article_url(@article), headers: auth_headers
    end

    assert_redirected_to articles_url
  end

  test "rejects unauthenticated article management actions" do
    get new_article_url
    assert_response :unauthorized

    post articles_url, params: { article: { title: "New article", body: "Body" } }
    assert_response :unauthorized

    get edit_article_url(@article)
    assert_response :unauthorized

    patch article_url(@article), params: { article: { title: "Updated title" } }
    assert_response :unauthorized

    delete article_url(@article)
    assert_response :unauthorized
  end

  test "accepts valid credentials for article management" do
    get new_article_url, headers: auth_headers
    assert_response :success
  end

  test "rejects incorrect credentials for article management" do
    get new_article_url, headers: {
      "HTTP_AUTHORIZATION" => ActionController::HttpAuthentication::Basic.encode_credentials("wrong", "wrong")
    }

    assert_response :unauthorized
  end

  test "rejects invalid article title" do
    assert_no_difference("Article.count") do
      post articles_url, params: { article: { title: "Four", body: "Body" } }, headers: auth_headers
    end

    assert_response :unprocessable_content
    assert_select "[role=alert]"
  end

  test "public article pages can be browsed without credentials" do
    get articles_url
    assert_response :success

    get article_url(@article)
    assert_response :success
  end

  test "lists only the comments that belong to the article" do
    get article_url(@article)

    assert_select "#comments article", count: @article.comments.count
    assert_select "#comments", text: /A fixture comment/
    assert_select "#comments", { text: /#{comments(:two).body}/, count: 0 }
  end

  private

  def auth_headers
    { "HTTP_AUTHORIZATION" => ActionController::HttpAuthentication::Basic.encode_credentials(
      ENV.fetch("BLOG_USERNAME"), ENV.fetch("BLOG_PASSWORD")
    ) }
  end
end
