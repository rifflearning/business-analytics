#
# Makefile to run the business analytics software using metabase
#

#runs the docker-compose.yml showing logs
up :
	@echo "Starting Riff Business Analytics on port 3000.";
	@docker-compose up;

#runs the docker-compose.yml detached
up-detach :
	@echo "Starting Riff Business Analytics on port 3000 - detached.";
	@docker-compose up --detach;

#stops and removes containers
down :
	@docker-compose down

#runs the docker-compose.yml detached
#runs the script to restore database backups for metabase to run queries on
up-restore:
	@echo "Starting Riff Business Analytics.";
	@docker-compose up --detach;
	@echo "Restoring mysql database backups from 'database-backups' folder.";
	@bash bin/restore-database-backups.sh;
	@echo "Processes Complete. Metabase running on port 3000.";
