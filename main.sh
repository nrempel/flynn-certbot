# Get domains array
DOMAINS_ARRAY=(${DOMAINS//,/ })
CERTBOT_COMMAND_STRING=""
for i in "${DOMAINS_ARRAY[@]}"
do
    # Make a string like '-d <domain 1> -d <domain 2>
    CERTBOT_COMMAND_STRING="-d $i $CERTBOT_COMMAND_STRING"
done

certbot certonly \
  --work-dir /app \
  --config-dir /app/config \
  --logs-dir /app/logs \
  --agree-tos \
  --no-eff-email \
  --test-cert \
  --dns-digitalocean \
  --email "$EMAIL" \
  --dns-digitalocean-credentials /app/digitalocean.ini \
  "$CERTBOT_COMMAND_STRING"