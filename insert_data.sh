#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

echo $($PSQL "TRUNCATE TABLE games, teams")

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  # GET WINNER TEAM NAME
  #exclude column names row
  if [[ $WINNER != "winner" ]]
  then
    # get team name
    TEAM_NAME=$($PSQL "SELECT name FROM teams WHERE name='$WINNER'")
    #if team name not found
    if [[ -z $TEAM_NAME ]]
    then
      #insert team
      INSERT_TEAM_NAME=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
      #echo team was inserted
      if [[ $INSERT_TEAM_NAME == "INSERT 0 1" ]]
      then
        echo Inserted team $WINNER
      fi
    fi
  fi

  # GET OPPONENT TEAM NAME
  #exclude column names row
  if [[ $OPPONENT != "opponent" ]]
  then
  # get team name
    TEAM_NAME=$($PSQL "SELECT name FROM teams WHERE name='$OPPONENT'")
    #if team name not found
    if [[ -z $TEAM_NAME ]]
    then
      #insert team
      INSERT_TEAM_NAME=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
      #echo team was inserted
      if [[ $INSERT_TEAM_NAME == "INSERT 0 1" ]]
      then
        echo Inserted team $OPPONENT
      fi
    fi
  fi
done

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  # INSERT GAMES
  # exclude first row
  if [[ YEAR != "year" ]]
  then
    # GET WINNER ID and OPPONENT ID
    WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")

    # INSERT GAME
    INSERT_GAME=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS)")
    if [[ $INSERT_GAME == "INSERT 0 1" ]]
    then
      echo Inserted game $WINNER $WINNER_GOALS : $OPPONENT_GOALS $OPPONENT
    fi
  fi
done