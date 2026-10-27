#! /bin/bash
PSQL='psql --username=freecodecamp --dbname=salon --tuples-only -c'

echo -e "\n~~~~~ MY SALON ~~~~~\n"
echo "Welcome to My Salon, how can I help you?"

MAIN_MENU () {
  if [[ $1 ]] 
  then
    echo -e "\n$1"
  fi
  
  echo -e "\n1) cut\n2) color\n3) perm\n4) style\n5) trim"
  read SERVICE_ID_SELECTED

  case $SERVICE_ID_SELECTED in
    [1-5]) SERVICE_ID=$SERVICE_ID_SELECTED ;;
    *) MAIN_MENU  "I could not find that service. What would you like today?" ;;
  esac
}

MAIN_MENU

SERVICE=$($PSQL "SELECT name FROM services WHERE service_id = '$SERVICE_ID'")

echo -e "\nWhat's your phone number?"
read CUSTOMER_PHONE

NAME=$($PSQL "SELECT name FROM customers WHERE phone = '$CUSTOMER_PHONE'")
if [[ -z $NAME ]]
then 
  echo -e "\nI don't have a record for that phone number, what's your name?"
  read CUSTOMER_NAME

  INSERT_CUSTOMER=$($PSQL "INSERT INTO customers(phone, name) VALUES('$CUSTOMER_PHONE', '$CUSTOMER_NAME')")
  NAME=$CUSTOMER_NAME
fi

CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE'")

echo -e "\nWhat time would you like your$SERVICE, $NAME?"
  read SERVICE_TIME
  INSERT_APPT=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES($CUSTOMER_ID, $SERVICE_ID, '$SERVICE_TIME')")

echo -e "\nI have put you down for a$SERVICE at $SERVICE_TIME, $NAME."