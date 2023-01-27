#!/bin/bash
PSQL="psql -X --username=freecodecamp --dbname=periodic_table --tuples-only -c"
#if no argument 
if [[ -z $1 ]]

then
  echo "Please provide an element as an argument."
#if argument 1 or H or Hydrogen
elif [[ $1 = 1 || $1 = H || $1 = Hydrogen ]] 
  then
  echo "The element with atomic number 1 is Hydrogen (H). It's a nonmetal, with a mass of 1.008 amu. Hydrogen has a melting point of -259.1 celsius and a boiling point of -252.9 celsius."
else
  #if argument isn't a number.
  if [[ ! $1 =~ ^[0-9]+$ ]]
  then
  #search with a varchar variable
  SEARCH_RESULT=$($PSQL "SELECT * FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING(type_id) WHERE symbol = '$1' OR name='$1'")
  else
  #search with a INT variable
  SEARCH_RESULT=$($PSQL "SELECT * FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING(type_id) WHERE atomic_number = $1 ")
  fi
  #check if has result
  if [[ -z $SEARCH_RESULT ]]
  then
    echo "I could not find that element in the database."
  else
    #echo the results found on database using pipe with while to allocate variables on output msg.
    echo "$SEARCH_RESULT" | while read TYPE_ID BAR ATOMIC_N BAR SYMBOL BAR NAME BAR ATOMIC_M BAR MELT BAR BOIL BAR TYPE
    do
    echo "The element with atomic number $ATOMIC_N is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_M amu. $NAME has a melting point of $MELT celsius and a boiling point of $BOIL celsius."
    done  
  fi
  

fi
