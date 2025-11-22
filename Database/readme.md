### Docker container

Before we go forward create a folder called csv in this directory and add the six csv files that will make up the database to this folder. The docker-compose.yml file mounts this folder for csv access.

<mark style="background: #FF5582A6;">IMPORTANT: Update any container/folder/file names to whatever you choose to use</mark>
---

First we need to create the database container in docker. Go to the directory in which you want to build the container.
 ```bash
 mkdir anulandgames
 cd anulandgames
 ```
 Load the docker compose from the postgres_docker_compose.yml. Make sure to change the file name to docker-compose.yml

 ```yml
 # change file name to docker-compose.yml
services:
  db:
    image: postgres:15
    container_name: anuland_postgres
    restart: unless-stopped
    ports:
      - "5422:5432"
    environment:
      POSTGRES_USER: admin
      POSTGRES_PASSWORD: adminpassword
      POSTGRES_DB: gamesdb
    volumes:
      - pgdata:/var/lib/postgresql/data   # <-- named volume
      - ./csv:/csv                        # <-- bind mount for CSV access
  adminer:
    image: adminer
    container_name: anuland_adminer
    restart: unless-stopped
    ports:
      - "8081:8080"
      
volumes:
  pgdata:                                  # <-- named volume declared here
  ```

Start the container with:
```
docker compose up -d

```
Now we can connect to postgres by running a shell inside the container:
```
docker exec -it anuland_postgres bash
```
```
psql -U admin -d gamesdb
```
Now we need to add the tables and copy them into the database. Use the Create_table.sql file to add the tables one by one, adding the games_data table at last. Then copy all the tables into the database, copying the games_data table last.

---
Once that's done test to see if the data is added. Use the following command to connect to the postgres shell:
```
docker exec -it anuland_postgres psql -U admin -d gamesdb
```
In the postgres shell use the following command. It should return the first 10 games in your database.
```pgsql
\dt
SELECT COUNT(*) FROM games;
SELECT * FROM games LIMIT 10;
```
The database setup is now complete. We can also go to the web GUI created with the adminer container within our docker-compose.yml file at localhost:8081 for an interface that lets us interact with the database.
