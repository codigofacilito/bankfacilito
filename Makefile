run:
	@echo "🚀 Running the application..."
	bundle exec rails server

migrate:
	@echo "🚀 Running the migrations..."
	bundle exec rake db:migrate
	annotate --models

shell:
	@echo "🚀 Running the console..."
	bundle exec rails console

recreate_db:
	@echo "🚀 Recreating the database..."
	bundle exec rake db:drop
	bundle exec rake db:create
	bundle exec rake db:migrate