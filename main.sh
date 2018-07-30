while true
do
    echo "Renewing..."
    certbot renew \
        --work-dir /app \
        --config-dir /app/config \
        --logs-dir /app/logs \
        --test-cert \

    sleep 60
done