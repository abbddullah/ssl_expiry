#!/bin/bash
SLACK_URL="$1"
DOMAINS=("www.google.com" "www.github.com" "www.twitter.com")
for i in "${DOMAINS[@]}"; do 
  date_of_expiry=$(echo| openssl s_clinet -servername "$i" -connect "$i":443 2>/dev/null | openssl x509 -noout -dates | awk -F='/^not after/ {print $2}' )
  converted_expiry_date=$(date -d "$date_of_expiry" '+%S' )
  current_date=$(date '+%s')
  remaining_days=$(((converted_expiry_date-current_date)/86400))
    if [[$remaining_days -ge 0 && $remaining_days -le 30]]; then
      msg="SSL Expiry Alert\n   * Domain : "$i"   \n* Warning : The SSL certificate for $i will expire in $remaining_days days."
      payload="{\"text\":\"$msg\"}"
      curl -X POST -H 'Content-type: application/json' --data "$payload" "$SLACK_URL"
    fi
  done
