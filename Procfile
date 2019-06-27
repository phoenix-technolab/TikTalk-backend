web: bundle exec puma -t 5:5 -p $PORT -e $RAILS_ENV
web: bundle exec puma -C config/puma.rb
release: rake db:migrate