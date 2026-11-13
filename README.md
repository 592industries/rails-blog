# 592 Industries Rails Blog

A small Rails application for creating and managing articles and their comments. Articles support create, read, update, and delete operations. Each article can have multiple comments, which can be added and removed from its page.

## Requirements

- Ruby 3.2.8
- Rails 8.1.4
- SQLite3
- Bundler

Dependencies are listed in `Gemfile` and locked in `Gemfile.lock`. The application also uses Puma, Propshaft, Turbo, Stimulus, and Importmap as configured by Rails.

## Setup

Install the bundle and prepare the database:

```sh
bundle install
bin/rails db:create
bin/rails db:migrate
```

Start the development server:

```sh
bin/rails server
```

Open the local server and navigate to `/articles` to manage articles and comments.

## Tests

Run the Minitest suite with:

```sh
bin/rails test
```

The repository also includes `bin/rubocop`, `bin/brakeman`, and `bin/bundler-audit` for style and security checks.
