#!/bin/bash
telegrambot () {
  curl -s "https://api.telegram.org/bot6738701037:AAFjGhETFYUcX_D2rO3GUbo85Q4V48mw25w/sendMessage?chat_id=752903466&text=$1" -o /dev/null
}
URL_RESIDENCE='https://qtermin.de/api/timeslots?date=2024-01-01&serviceid=174044&rangesearch=1&caching=false&capacity=1&duration=20&cluster=false&slottype=0&fillcalendarstrategy=0&showavcap=false&appfuture=180&appdeadline=1920&appdeadlinewm=2&oneoff=null&msdcm=0&calendarid='
URL_ANMELDUNG='https://qtermin.de/api/timeslots?date=2024-01-13&serviceid=171321&rangesearch=1&caching=false&capacity=1&duration=15&cluster=false&slottype=0&fillcalendarstrategy=0&showavcap=false&appfuture=150&appdeadline=1440&appdeadlinewm=2&oneoff=null&msdcm=0&calendarid='

DATE="2024-07-20T00:00:00"
DATE_ANMELDUNG="2024-07-30T00:00:00"

while true; do
  APPOINT=$(curl -s $URL_RESIDENCE -H 'content-type: application/json' -H 'webid: qtermin-stadtheilbronn-abh' | jq '.[0]["start"]' | tr -d '"')
  APPOINT_ANMELDUNG=$(curl -s $URL_ANMELDUNG -H 'content-type: application/json' -H 'webid: qtermin-stadtheilbronn-abh' | jq '.[0]["start"]' | tr -d '"')
  if [[ $(date -d "$APPOINT" +%s) -lt $(date -d "$DATE" +%s) ]];
    then
          echo "permit $APPOINT"
          telegrambot "New_date_available_residence_depot:$APPOINT"
        #   DATE=$APPOINT
  else
          echo "permit NOPE..."
  fi
  # if [[ $(date -jf "%Y-%m-%dT%H:%M:%S" "$APPOINT_ANMELDUNG" +%s) -lt $(date -jf "%Y-%m-%dT%H:%M:%S" "$DATE_ANMELDUNG" +%s) ]];
   if [[ -n "$APPOINT_ANMELDUNG" && $(date -d "$APPOINT_ANMELDUNG" +%s 2>/dev/null) -lt $(date -d "$DATE_ANMELDUNG" +%s 2>/dev/null) ]];

    then
          echo "anmeldung $APPOINT_ANMELDUNG"
        #   telegrambot "New_date_available_anmeldung:$APPOINT_ANMELDUNG"
          # DATE=$APPOINT
  else
          echo "anmeldung NOPE..."
  fi
  sleep 60
done