#!/bin/bash
SLACK_URL="$1"
DOMAINS=("www.google.com" "www.github.com" "www.twitter.com")

for i in "${DOMAINS[@]}"; do 
  date_of_expiry=$(echo | openssl s_client -servername "$i" -connect "$i":443 2>/dev/null | openssl x509 -noout -dates | awk -F= '/notAfter/{print $2}')
  converted_expiry_date=$(date -d "$date_of_expiry" '+%s')
  current_date=$(date '+%s')
  remaining_days=$(( (converted_expiry_date - current_date) / 86400 ))

  if [[ $remaining_days -ge 0 && $remaining_days -le 30 ]]; then
    msg="SSL Expiry Alert\n   * Domain: $i\n   * Warning: The SSL certificate for $i will expire in $remaining_days days."
    
  fi
done
