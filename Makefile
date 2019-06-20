#
# Makefile to run the business analytics software using metabase
#
#||: means or true, and prevents the target from crashing if there is an error
#

help :
	@echo ""                                                         ; \
	echo "Useful targets in this business-analytics Makefile:"       ; \
	echo "- up: run docker-compose up"  								       			 ; \
	echo ""																													 ; \
	echo "- up-detach: run docker-compose up --detach"   				     ; \
	echo ""																								  			   ; \
	echo "- remove-database-backups: run rm ./database-backups/*.sql"; \
	echo ""																													 ; \
	echo "- clean: removes metabase log file"  											 ; \
	echo "         and removes the mysql volume"    								 ; \
	echo ""																													 ; \
	echo "- down: run docker-compose down"                           ; \
	echo ""																													 ; \

#runs the docker-compose.yml showing logs
up :
	@echo "Starting Riff Business Analytics."
	@docker-compose up

#runs the docker-compose.yml detached
up-detach :
	@echo "Starting Riff Business Analytics."
	@docker-compose up --detach

#removes all .sql files inside ./database-backups
remove-database-backups :
	@echo "Removing local coping of database backups."
	rm ./database-backups/*.sql ||:

#removes metabase log file and mysql volume containing mysql course backups
clean:
	@echo "Removing metabase log file and mysql volume containing mysql course backups"
	rm ./metabase-db/metabase.db/metabase.db.trace.db ||:
	@docker volume rm $(notdir $(CURDIR))_ba-mmdb-data ||:

#stops and removes containers
down :
	@docker-compose down
