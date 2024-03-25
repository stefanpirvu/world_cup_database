#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

# Reset data
echo $($PSQL "TRUNCATE TABLE games, teams;")

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS

do

  # TEAMS PART BEGIN

  if [[ $WINNER != 'winner' ]]
    then
      # get team winner ID
      TEAM_WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$WINNER'")

      # if not found
      if [[ -z $TEAM_WINNER_ID ]]
        then
          # insert team winner name
          INSERT_TEAM_WINNER_NAME=$($PSQL "INSERT INTO teams (name) VALUES ('$WINNER')")
          if [[ $INSERT_TEAM_WINNER_NAME == 'INSERT 0 1' ]]
            then
              echo Inserted into teams, $WINNER
          fi

          # get new team winner ID
          TEAM_WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$WINNER'")
      fi
  fi

  if [[ $OPPONENT != 'opponent' ]]
    then
      # get team opponent ID
      TEAM_OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$OPPONENT'")

      # if not found
      if [[ -z $TEAM_OPPONENT_ID ]]
        then
          # insert team opponent name
          INSERT_TEAM_OPPONENT_NAME=$($PSQL "INSERT INTO teams (name) VALUES ('$OPPONENT')")
          if [[ $INSERT_TEAM_OPPONENT_NAME == 'INSERT 0 1' ]]
            then
              echo Inserted into teams, $OPPONENT
          fi

          # get new team opponent ID
          TEAM_OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$OPPONENT'")
      fi
  fi

  # TEAMS PART END

  # GAMES PART BEGIN

  if [[ $YEAR != 'year' ]]
    then
      # get the winner id
      TEAM_WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$WINNER'")
      
      # get the opponent ID
      TEAM_OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$OPPONENT'")

      # insert all
      INSERT_INTO_GAMES=$($PSQL "INSERT INTO games (year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES ($YEAR, '$ROUND', $TEAM_WINNER_ID, $TEAM_OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS)") 
  fi

  # GAMES PART END
done