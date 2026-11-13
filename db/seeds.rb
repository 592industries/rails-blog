# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
articles = [
  {
    title: "A Walk Along the Harbor",
    body: "The harbor is quiet just after sunrise. Fishing boats return as the first cafes open along the waterfront."
  },
  {
    title: "A Small Kitchen Garden",
    body: "A few pots of herbs can make a sunny windowsill feel like a garden. Basil, mint, and parsley are easy places to start."
  },
  {
    title: "Notes from the Old Bookshop",
    body: "The best bookshops invite you to slow down. We spent Saturday finding old maps, travel journals, and a well-loved cookbook."
  }
]

records = articles.map do |attributes|
  Article.find_or_create_by!(title: attributes[:title]) do |article|
    article.body = attributes[:body]
  end
end

comments = {
  records[0] => [
    [ "Maya", "The early morning light there is beautiful." ],
    [ "Elliot", "I would love to try the cafe by the pier." ],
    [ "Sam", "This brought back a lovely weekend walk." ]
  ],
  records[1] => [
    [ "Nora", "Mint has been the easiest one for me to grow." ],
    [ "Luis", "Fresh basil makes such a difference." ]
  ]
}

comments.each do |article, entries|
  entries.each do |commenter, body|
    article.comments.find_or_create_by!(commenter: commenter, body: body)
  end
end
