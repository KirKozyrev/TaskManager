clean_world: 
	destroy_shell 
	build_shell 
	prepare_shell 
	up

destroy_shell:
	docker-compose down -v

build_shell:
	docker-compose build

prepare_shell:
	docker-compose run --rm web bash -c "make prepare"

up:
	docker-compose up

shell:
	docker-compose run --rm web bash
	
service_shell:
	docker-compose run --service-ports --rm web bash

prepare:
	bundle install
	yarn install
	rails db:create db:migrate

lint: test_web lint_web lint_frontend

lint_web:
	bundle exec rubocop --auto-correct

test_web:
	bundle exec rails test

lint_frontend:
	yarn run eslint --fix
