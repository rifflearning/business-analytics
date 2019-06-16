# business-analytics
Tools to produce Riff Business analytic reports on RiffEdu and RiffPlatform deployments

This repository uses a third-party package called [Metabase][] to visualize usage metrics for Mattermost. Two docker containers are run; one using the metabase image and another using the
official mysql image. Commands are provided to restore sql database backups from Mattermost to the mysql container.

## Getting Started

These instructions will get you a copy of the project up and running on your local machine for development and testing purposes.

### Database Backups

Download sql backups from the Riff Learning backup location (ask for the URL if you don't have it), and place all .sql files in the folder called 'database-backups' in the root of this repo.

### Prerequisites

- [docker CE][docker-install] (Community Edition)
- [docker-compose][docker-compose-install]
- git
- make


## Running the Software

#### Note:
The SQL container uses port 3306 and the metabase container uses port 3000 on your local machine. You will need to stop any servers running locally on those ports in order to continue.

The first step is to clone this repository. The following commands are defined in a Makefile, and can be run as follows:


```
make up
```
This command will create the mysql and metabase containers and show the logs for each

```
make up-detach
```
This command will create the mysql and metabase containers in detached mode (no logs).

```
make down
```
This command will stop and remove the mysql and metabase containers. The mysql volume containing the sql backups will
persist locally however, so only make up or make up-detach is needed to start the software again.

#### Restoring Database Backups
Once the `make up` command has completed (about 2-3 minutes), open a new terminal tab and run `bin/restore-database-backups.sh`. It will restore databases from all .sql files in the folder ./database-backups. You may need to run `chmod +x ./bin/restore-database-backups.sh`, to make the file executable.

#### make clean
It is recommended that, after running the previous command to restore database backups, you run ```make clean```, which will delete all .sql files in the folder ./database-backups.

### Using and Configuring Metabase

If you are using a backup from our current deployment of edu-nexted, the database name in the sql backups
will be 'mattermost_test'. This is what Metabase is currently configured to look for, so it will run automatically with this
configuration. If you are restoring an sql backup which contains databases other than 'mattermost_test', see the section
'Setting Up New Databases in Metabase' below.

## View the Dashboard

Open a web-browser and navigate to http://localhost:3000. You will be shown the metabase sign-in prompt. Ask a developer for the login credentials. Once logged in, you will be presented with the metabase homepage. I have pinned the Mattermost dashboard to the
top, under the heading 'Start Here'. If you click on it, you will be taken to the dashboard, which shows all of the
questions, and a brief summary of each.

## View a Question and Download Reports

If you click on a question in the dashboard, you will be taken to the query builder, which also shows a larger
visualisation of the data. You can change the way the data is visualised using the dropdown under 'Visualisation. You can
edit/view the sql query by clicking 'OPEN EDITOR'. Some questions have optional parameters, for which values can
be provided in the text fields above the data visualisation. After running the query, you can click the down arrow on the top right of the data visualisation to download the data in various formats.

You can run the same questions on different databases by clicking 'OPEN EDITOR' in the question, and using
the dropdown to select a different database. See 'Setting Up New Databases in Metabase' below.

## Making Changes in Metabase

If you make any changes to a question or dashboard, remember to click SAVE. At this point, you will want to commit the
./metabase-db folder to github to save those changes for future use.

## Setting Up New Databases in Metabase

Once you have used the make up-restore command to restore the sql database to the mysql container
as described above, you can add a new database to metabase by:
  1. Clicking the gear icon in the top-right of the screen and selecting Admin
  2. Selecting Databases at the top, and clicking Add database.
  3. Name the database connection. With the current docker-compose configuration, the host will be `ba-mmdb` and the port will be `3306`. You can also refer to the existing database connection settings.
You will need to do this for every database you want to add, even if existing in the same sql schema


[Metabase]: <https://metabase.com/> "Metabase home"
[docker-install]: <https://docs.docker.com/install/> "Docker installation instructions"
[docker-compose-install]: <https://docs.docker.com/compose/install/> "docker-compose installation instructions"
