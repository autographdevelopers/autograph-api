source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

ruby '2.5.7'

gem 'rails', '~> 6.1'
gem 'pg'
gem 'puma', '~> 3.7'
gem 'jbuilder', '~> 2.5'
# Use Redis adapter to run Action Cable in production
gem 'redis'
gem 'discard', '~> 1.2'
gem 'json-schema'
# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin AJAX possible
gem 'rack-cors'
# gem 'mini_magick', '>= 4.9.5'
gem 'image_processing', '~> 1.2'

group :development, :test do
  gem 'dotenv-rails', require: 'dotenv/rails-now'
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'rspec-rails'
end

group :development do
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem "letter_opener", '~> 1.7.0'
end

group :test do
  gem 'database_cleaner'
  gem 'shoulda-matchers'
end

gem 'factory_bot_rails'
gem 'ffaker'

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

gem 'devise_token_auth'
gem 'devise_invitable'
gem 'pundit'
gem 'aasm'
gem 'timezone'
gem 'bulk_insert'
gem 'holidays'

gem 'sidekiq'
gem 'has_scope'
gem 'sidekiq-cron', '~> 0.6.3'
gem 'one_signal'
gem 'kaminari'
gem 'active_storage_validations'
gem 'acts-as-taggable-on', '~> 7.0'