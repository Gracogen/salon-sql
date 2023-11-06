#! /bin/bash

PSQL="psql --username=freecodecamp --dbname=salon --tuples-only -c"
#PSQL="psql -X --username=freecodecamp --dbname=bikes --tuples-only -c"


echo -e "\nGracogen Salon"
MAIN_MENU () {
echo -e "\nWelcome to the salon, What do you want us to do for you?\n"
SERVICES_WE_OFFER=$($PSQL "SELECT * FROM services")

echo "$SERVICES_WE_OFFER" | while read SERVICE_ID BAR NAME
do
echo "$SERVICE_ID) $NAME"
done

read SERVICE_ID_SELECTED

case $SERVICE_ID_SELECTED in
  1) GET_DETAILS ;;
  2) GET_DETAILS ;;
  3) GET_DETAILS ;;
  *) MAIN_MENU ;;
esac
}

GET_DETAILS () {
  echo -e "\nEnter your phone number"
  read CUSTOMER_PHONE
    EXISTING_CUST=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")

    if [[ -z $EXISTING_CUST ]]
    then
  echo -e "\nEnter your name"
  read CUSTOMER_NAME
  echo -e "\nEnter your convenient service time"
  read SERVICE_TIME

  INSERT_CUSTOMER=$($PSQL "INSERT INTO customers(name, phone) VALUES('$CUSTOMER_NAME', '$CUSTOMER_PHONE')")

CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")
  
SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id=$SERVICE_ID_SELECTED")

  CREATE_APPOINTMENT=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES('$CUSTOMER_ID', $SERVICE_ID_SELECTED, '$SERVICE_TIME')")
      echo -e "\nI have put you down for a $SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."

  else
  CHECK_APPOINTMENT=$($PSQL "SELECT appointment_id FROM appointments WHERE customer_id=$EXISTING_CUST AND service_id=$SERVICE_ID_SELECTED")
      echo -e "\nI have put you down for a $SERVICE_NAME at '$SERVICE_TIME', $CUSTOMER_NAME."

  if [[ -z $CHECK_APPOINTMENT ]]
  then

    CREATE_APPOINTMENT=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES($EXISTING_CUST, $SERVICE_ID_SELECTED, '$SERVICE_TIME')")
    echo -e "\nI have put you down for a $SERVICE_NAME at '$SERVICE_TIME', $CUSTOMER_NAME."
    else
    SERVICE_TIME=$($PSQL "SELECT time FROM appointments WHERE service_id=$SERVICE_ID_SELECTED")
    echo -e "\nYou aready have an appointment for $SERVICE_NAME at $SERVICE_TIME.\nThanks."
fi

  fi
}
MAIN_MENU