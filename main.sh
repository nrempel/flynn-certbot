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
  --config-dir /app \
  --logs-dir /app/logs \
  --dns-digitalocean \
  --email "$EMAIL" \
  --agree-tos \
  --dns-digitalocean-credentials "$DIGITAL_OCEAN_SECRET_PATH" \
  "$CERTBOT_COMMAND_STRING"