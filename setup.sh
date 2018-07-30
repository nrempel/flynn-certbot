# Install flynn-cli
export FLYNN_CMD="/app/flynn"
L="$FLYNN_CMD" && curl -sSL -A "`uname -sp`" https://dl.flynn.io/cli | zcat >$L && chmod +x $L

# Add cluster
"$FLYNN_CMD" cluster add -p "$FLYNN_TLS_PIN" default "$FLYNN_CLUSTER_HOST" "$FLYNN_CONTROLLER_KEY"

if [ "$CERTBOT_DNS_PLUGIN" != "digitalocean" ]; then
   echo "CERTBOT_DNS_PLUGIN only supports 'digitalocean'";
   exit 1;
fi

# Create file needed for certbot
export DIGITAL_OCEAN_SECRET_PATH="/app/digitalocean.ini"
cat "dns_digitalocean_token = $DIGITAL_OCEAN_API_KEY" > "$DIGITAL_OCEAN_SECRET_PATH"
chmod 600 digitalocean.ini

