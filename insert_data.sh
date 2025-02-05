#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

# Truncate existing data
$PSQL "TRUNCATE TABLE games, teams;"

# Read data from games.csv and insert into the database
while IFS="," read -r year round winner opponent winner_goals opponent_goals
do
    if [[ $year != "year" ]]
    then
        # Insert teams if not exists
        winner_id=$($PSQL "SELECT team_id FROM teams WHERE name='$winner'")
        if [[ -z $winner_id ]]
        then
            $PSQL "INSERT INTO teams(name) VALUES('$winner')"
            winner_id=$($PSQL "SELECT team_id FROM teams WHERE name='$winner'")
        fi

        opponent_id=$($PSQL "SELECT team_id FROM teams WHERE name='$opponent'")
        if [[ -z $opponent_id ]]
        then
            $PSQL "INSERT INTO teams(name) VALUES('$opponent')"
            opponent_id=$($PSQL "SELECT team_id FROM teams WHERE name='$opponent'")
        fi

        # Insert game
        $PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals)
               VALUES($year, '$round', $winner_id, $opponent_id, $winner_goals, $opponent_goals)"
    fi
done < games.csv
