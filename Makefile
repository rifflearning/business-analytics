#
# Makefile to run the business analytics software using metabase
#

help :
	@echo ""                                                                           ; \
	echo "Useful targets in this business-analytics Makefile:"                         ; \
	echo "- up           : run docker-compose up"  								                     ; \
	echo "- up-detach    : run docker-compose up --detach"   				                   ; \
	echo "- clean        : run rm ./database-backups/*.sql"   				                 ; \
	echo "- down         : run docker-compose down"                                    ; \
	echo ""

#runs the docker-compose.yml showing logs
up :
	@echo "Starting Riff Business Analytics."
	@docker-compose up

#runs the docker-compose.yml detached
up-detach :
	@echo "Starting Riff Business Analytics."
	@docker-compose up --detach

#removes all .sql files inside ./database-backups
clean :
	@echo "Removing local coping of database backups."
	rm ./database-backups/*.sql

#stops and removes containers
down :
	@docker-compose down
