web: bundle exec puma -C config/puma.rb
worker: bundle exec sidekiq -e $RACK_ENV -c 3 -v
