### Docker container

Before we go forward create a folder called csv in this directory and add the six csv files that will make up the database to this folder. The docker-compose.yml file mounts this folder for csv access.

IMPORTANT: Update any container/folder/file names to whatever you choose to use
---

First we need to create the database container in docker. Go to the directory in which you want to build the container.
 ```bash
 mkdir anulandgames
 cd anulandgames
 ```
 Load the docker compose from the postgres_docker_compose.yml. Make sure to change the file name to docker-compose.yml. This will also create a container for adminer, a web GUI for the database, and a REST API (postgrest).

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
  postgrest:
    image: postgrest/postgrest:latest 
    container_name: anuland_postgrest
    restart: unless-stopped
    platform: linux/arm64 # specifies platform
    ports:
      - "3005:3000"  # <-- Public API port (change if needed)
    environment:
      PGRST_DB_URI: "postgres://admin:adminpassword@db:5432/gamesdb"
      PGRST_DB_SCHEMA: "public"
      PGRST_DB_ANON_ROLE: "anon"
    depends_on:
      - db


      
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
PostgREST requires a Postgres role that matches PGRST_DB_ANON_ROLE.

Right now, youther Postgres user is admin, but postgres is the default superuser, so we need to configure proper permissions.

```sql
-- Create anonymous role
CREATE ROLE postgres NOLOGIN;

-- Allow this role to read all tables in the public schema
GRANT USAGE ON SCHEMA public TO postgres;
GRANT SELECT ON ALL TABLES IN SCHEMA public TO postgres;

-- Ensure future tables also grant SELECT
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT SELECT ON TABLES TO postgres;
```
