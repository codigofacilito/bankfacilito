run:
	@echo "🚀 Running the application..."
	bundle exec rails db:seed
	bundle exec rails server

migrate:
	@echo "🚀 Running the migrations..."
	bundle exec rake db:migrate
	annotate --models

shell:
	@echo "🚀 Running the console..."
	bundle exec rails console