# Install flynn-cli
L="$FLYNN_CMD" && curl -sSL -A "`uname -sp`" https://dl.flynn.io/cli | zcat >$L && chmod +x $L

# Add cluster
"$FLYNN_CMD" cluster add -p "$FLYNN_TLS_PIN" default "$FLYNN_CLUSTER_HOST" "$FLYNN_CONTROLLER_KEY"

if [ "$CERTBOT_DNS_PLUGIN" != "digitalocean" ]; then
   echo "CERTBOT_DNS_PLUGIN only supports 'digitalocean'";
   exit 1;
fi

# Create file needed for certbot
echo "dns_digitalocean_token = $DIGITAL_OCEAN_API_KEY" > "$DIGITAL_OCEAN_SECRET_PATH"
chmod 600 "$DIGITAL_OCEAN_SECRET_PATH"

# Get domains array
DOMAINS_PAIRS_ARRAY=(${DOMAINS//,/ })
CERTBOT_COMMAND_STRING=""
for ROUTE_DOMAIN_PAIR in "${DOMAINS_PAIRS_ARRAY[@]}"
do
    # Get domain from route:domain pair
    DOMAINS_ARRAY=(${ROUTE_DOMAIN_PAIR//:/ })
    DOMAIN="${DOMAINS_ARRAY[1]}"
    # Make a string like '-d <domain 1> -d <domain 2>
    CERTBOT_COMMAND_STRING="-d $DOMAIN $CERTBOT_COMMAND_STRING"
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
  --dns-digitalocean-credentials "$DIGITAL_OCEAN_SECRET_PATH" \
  "$CERTBOT_COMMAND_STRING"


for ROUTE_DOMAIN_PAIR in "${DOMAINS_PAIRS_ARRAY[@]}"
do
    # Get app name and domain from app:domain pair
    DOMAINS_ARRAY=(${ROUTE_DOMAIN_PAIR//:/ })
    
    APP_NAME="${DOMAINS_ARRAY[0]}"
    DOMAIN="${DOMAINS_ARRAY[1]}"
    
    ROUTE_ID=$("$FLYNN_CMD" -a "$APP_NAME" route | grep "$DOMAIN" | awk '{print $3}')

    if [ -z "$ROUTE_ID" ]; then
        echo "Cannot determine route id from '$ROUTE_DOMAIN_PAIR'"
        exit 1
    fi

    "$FLYNN_CMD" -a $APP_NAME route update $ROUTE_ID \
        --tls-cert /app/config/live/$DOMAIN-0001/fullchain.pem \
        --tls-key /app/config/live/$DOMAIN-0001/privkey.pem
done
