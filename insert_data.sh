#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do

  # check if reading title of file

  if [[ $YEAR != "year" ]]
  then

    #check if winner is already in teams database by getting team_id
    TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")

    #if team_id not found (ie, winner is not in teams yet)
    if [[ -z $TEAM_ID ]]
    then
      #insert winner into teams table
      INSERT_TEAM_NAME=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
    
    fi

    #check if opponent is already in teams table by getting team_id
    TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")

    #if team_id not found (ie opponent not in teams database)
    if [[ -z $TEAM_ID ]]
    then
      #insert opponent into teams table
      INSERT_TEAM_NAME=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")

    fi

  fi

done

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  
  if [[ $YEAR != "year" ]]
  then

    WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")

    OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")

  #insert year, round into games
    GAME_INSERT_RESULT=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($YEAR, '$ROUND', '$WINNER_ID', '$OPPONENT_ID', $WINNER_GOALS, $OPPONENT_GOALS)")

  fi

done
