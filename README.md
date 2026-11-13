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
bin/rails db:seed
```

Article browsing and comment submission are public. Article creation, editing, deletion, and comment deletion use HTTP Basic Authentication. Set both `BLOG_USERNAME` and `BLOG_PASSWORD` in the server environment before starting the app. If either variable is missing, Rails uses a fresh random fallback and protected actions remain inaccessible. Do not commit credentials or place them in source files.

For example, set the variables in the shell that will run the server:

```sh
export BLOG_USERNAME="your-username"
export BLOG_PASSWORD="your-password"
bin/rails server
```

On PowerShell, use `$env:BLOG_USERNAME = "your-username"` and `$env:BLOG_PASSWORD = "your-password"` before running `bin/rails server`.

Open the local server and navigate to `/articles` to browse articles, read comments, and add comments. The idempotent seed data provides three example articles and comments.

## Tests

Run the Minitest suite with:

```sh
bin/rails test
```

The repository also includes `bin/rubocop`, `bin/brakeman`, and `bin/bundler-audit` for style and security checks.
