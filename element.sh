PSQL="psql --username=freecodecamp --dbname=periodic_table --no-align -t -c"

if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
else
  if [[ $1 =~ ^[0-9]+$ ]]
  then
    ELEMENT_INFO="$($PSQL "
    SELECT e.atomic_number, e.name, e.symbol, t.type, p.atomic_mass, p.melting_point_celsius, p.boiling_point_celsius
    FROM elements e
    JOIN properties p 
    USING(atomic_number)
    JOIN types t
    USING(type_id)
    WHERE e.atomic_number = $1;
    ")"
  else
    ELEMENT_INFO="$($PSQL "
    SELECT e.atomic_number, e.name, e.symbol, t.type, p.atomic_mass, p.melting_point_celsius, p.boiling_point_celsius
    FROM elements e
    JOIN properties p 
    USING(atomic_number)
    JOIN types t
    USING(type_id)
    WHERE e.symbol = '$1';
    ")"

    if [[ -z $ELEMENT_INFO ]]
    then
      ELEMENT_INFO="$($PSQL "
    SELECT e.atomic_number, e.name, e.symbol, t.type, p.atomic_mass, p.melting_point_celsius, p.boiling_point_celsius
    FROM elements e
    JOIN properties p 
    USING(atomic_number)
    JOIN types t
    USING(type_id)
    WHERE e.name = '$1';
    ")"
    fi
  fi

  if [[ -z $ELEMENT_INFO ]]
  then
    echo "I could not find that element in the database." 
  else
    echo "$ELEMENT_INFO" | sed 's/|/ /g' | while read NUMBER NAME SYMBOL TYPE MASS MELTING BOILING
    do 
      echo "The element with atomic number $NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius."

    done
  fi
fi


