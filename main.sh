# Get domains array
DOMAINS_ARRAY=(${DOMAINS//,/ })
CERTBOT_COMMAND_STRING=""
for i in "${DOMAINS_ARRAY[@]}"
do
    CERTBOT_COMMAND_STRING="-d $i $CERTBOT_COMMAND_STRING"
done

certbot certonly \
  --dns-digitalocean \
  --dns-digitalocean-credentials "$DIGITAL_OCEAN_SECRET_PATH" \
  "$CERTBOT_COMMAND_STRING"