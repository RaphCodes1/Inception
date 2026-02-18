DATA_PATH = /home/rcreer/data
all: inception

up: create_dirs
	docker compose -f ./srcs/docker-compose.yml up -d

build: create_dirs
	docker compose -f ./srcs/docker-compose.yml up --build -d

down:
	docker compose -f ./srcs/docker-compose.yml down

create_dirs:
	@sudo mkdir -p $(DATA_PATH)/mariadb
	@sudo mkdir -p $(DATA_PATH)/wordpress
	@sudo chmod 777 $(DATA_PATH)/mariadb
	@sudo chmod 777 $(DATA_PATH)/wordpress

inception: create_dirs
	docker compose -f ./srcs/docker-compose.yml up --build -d

clean:
	docker compose -f ./srcs/docker-compose.yml down --rmi all -v --remove-orphans 2> /dev/null

fclean: clean
	@sudo rm -rf $(DATA_PATH)/*
	@sudo rm -rf $(DATA_PATH) 2>/dev/null || true  # Delete parent if exists
	@mkdir -p $(DATA_PATH)  # Recreate empty
	@sudo chown -R $(USER):$(USER) $(DATA_PATH)
	docker system prune -a --volumes -f

re: fclean all

.PHONY: all clean fclean re up build down inception create_dirs