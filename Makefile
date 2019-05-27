#
# Makefile to run the business analytics software using metabase
#

#runs the docker-compose.yml showing logs
up :
	@echo "Starting Riff Business Analytics.";
	@docker-compose up;
	@echo "Processes Complete. Metabase running on port 3000.";

#runs the docker-compose.yml detached
up-detach :
	@echo "Starting Riff Business Analytics.";
	@docker-compose up --detach;
	@echo "Processes Complete. Metabase running on port 3000.";

#stops and removes containers
down :
	@docker-compose down

#runs the script to restore database backups for metabase to run queries on
restore :
	@echo "Restoring mysql database backups from 'database-backups' folder.";
	@bash bin/restore-database-backups.sh;
	@echo "Processes Complete. Metabase running on port 3000.";
