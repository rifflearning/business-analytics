# Riff Business Analytics (READ ME A WIP)

This repository uses a third-party package called Metabase to visualize usage metrics for Mattermost, 
which is embedded in our product. Two docker containers are run; one using the metabase image and another using the
official mysql image. Commands are provided to restore sql database backups from Mattermost to the mysql container. 

## Getting Started

These instructions will get you a copy of the project up and running on your local machine for development and testing purposes.

### Prerequisites

```
docker
```

## Running the Software
The first step is to clone this repository. The following commands are defined in a Makefile, and can be run as follows:

```
make up-restore
```
This command should be your starting point. It will create the mysql and metabase containers (in detached mode) and restore databases from all .sql files in the folder ./database-backups

```
make up
```
This command will create the mysql and metabase containers and show the logs for each

```
make up-detach
```
This command will create the mysql and metabase containers in detached mode (no logs)

```
make down
```
This command will stop and remove the mysql and metabase containers. The mysql volume containing the sql backups will 
persist locally however, so only make up or make up-detach is needed to start the software again.

#### Metabase will be run on port 3000

### Using and Configuring Metabase

If you are using a backup from our current deployment of edu-nexted, the database name in the sql backups 
will be 'mattermost_test'. This is what Metabase is currently configured to look for, so it will run automatically with this
configuration. If you are restoring an sql backup which contains databases other than 'mattermost_test', see the section 
'Setting Up New Databases in Metabase' below.

## View the Dashboard

Once you navigate to port 3000, you will be shown the metabase homepage. I have pinned the Mattermost dashboard to the 
top, under the heading 'Start Here'. If you click on it, you will be taken to the dashboard, which shows all of the 
questions, and a brief summary of each.

## View a Question

If you click on a question in the dashboard, you will be taken to the query builder, which also shows a larger 
visualisation of the data. You can change the way the data is visualised using the dropdown under 'Visualisation' and 
edit/view the sql query by clicked 'OPEN EDITOR'. Some questions have optional parameters, for which values can
be provided in the text fields above the data visualisation. 

You can run the same questions on different databases by clicking 'OPEN EDITOR' in the question, and using 
the dropdown to select a different database. You could also duplicate a dashboard, and individually change the database 
for all questions. See 'Setting Up New Databases in Metabase' below.

## Editing in Metabase

If you make any changes to a question or dashboard, remember to click SAVE. At this point, you will want to commit the 
./metabase-db folder to github to save those changes.

## Setting Up New Databases in Metabase

Once you have used the make up-restore command to restore the sql database to the mysql container
as described above, you can add this database to metabase by:
  1. Clicking the gear icon in the top-right of the screen and selecting Admin
  2. Selecting Databases at the top, and clicking Add database.
You will need to do this for every database you want to add, even if existing in the same sql schema
