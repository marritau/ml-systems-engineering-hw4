.DEFAULT_GOAL := help

.PHONY: help up down deps run test unit-test docs lint clean

help:
	@echo "make up        - start ClickHouse, loader and dbt"
	@echo "make deps      - install dbt packages"
	@echo "make run       - build dbt models"
	@echo "make test      - run dbt data tests"
	@echo "make unit-test - run dbt unit tests"
	@echo "make docs      - build and serve dbt docs on port 8082"
	@echo "make lint      - lint SQL models and tests"
	@echo "make down      - stop containers"

up:
	docker compose up -d --build

down:
	docker compose down

deps:
	docker compose exec dbt dbt deps

run:
	docker compose exec dbt dbt run

test:
	docker compose exec dbt dbt test

unit-test:
	docker compose exec dbt dbt test --select test_type:unit

docs:
	docker compose exec dbt dbt docs generate
	docker compose exec -d dbt dbt docs serve --host 0.0.0.0 --port 8082

lint:
	docker compose exec dbt sqlfluff lint models tests

clean:
	docker compose exec dbt dbt clean
