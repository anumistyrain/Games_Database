CREATE TABLE franchise (
    franchise_id   INTEGER PRIMARY KEY,
    franchise_name TEXT NOT NULL
);

CREATE TABLE genre (
    genre_id    INTEGER PRIMARY KEY,
    genre_name  TEXT NOT NULL
);

CREATE TABLE platform (
    platform_id    INTEGER PRIMARY KEY,
    platform_name  TEXT NOT NULL
);

CREATE TABLE play_status (
    play_status_id   INTEGER PRIMARY KEY,
    play_status_name TEXT NOT NULL
);

CREATE TABLE store (
    store_id   INTEGER PRIMARY KEY,
    store_name TEXT NOT NULL
);

CREATE TABLE games (
    game_id        INTEGER PRIMARY KEY,
    game_name      TEXT NOT NULL,

    platform_id    INTEGER NOT NULL,
    genre_id       INTEGER NOT NULL,
    store_id       INTEGER,
    play_status    INTEGER,
    franchise_id   INTEGER,
    
    release_date   DATE,
    game_length    NUMERIC,
    rating         NUMERIC,

    FOREIGN KEY (platform_id)  REFERENCES platform(platform_id),
    FOREIGN KEY (genre_id)     REFERENCES genre(genre_id),
    FOREIGN KEY (store_id)     REFERENCES store(store_id),
    FOREIGN KEY (play_status)  REFERENCES play_status(play_status_id),
    FOREIGN KEY (franchise_id) REFERENCES franchise(franchise_id)
);

COPY franchise (franchise_id, franchise_name)
FROM '/csv/franchise_data.csv'
DELIMITER ','
CSV HEADER;

COPY genre (genre_id, genre_name)
FROM '/csv/genre_data.csv'
DELIMITER ','
CSV HEADER;

COPY platform (platform_id, platform_name)
FROM '/csv/platform_data.csv'
DELIMITER ','
CSV HEADER;

COPY store (store_id, store_name)
FROM '/csv/store_data.csv'
DELIMITER ','
CSV HEADER;

COPY play_status (play_status_id, play_status_name)
FROM '/csv/play_status_data.csv'
DELIMITER ','
CSV HEADER;

COPY games (
    game_id,
    game_name,
    platform_id,
    genre_id,
    release_date,
    store_id,
    play_status,
    game_length,
    franchise_id,
    rating
)
FROM '/csv/games_data.csv'
DELIMITER ','
CSV HEADER;