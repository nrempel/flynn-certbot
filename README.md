# Flynn Certbot

This tool can help you automatically issue and renew SSL certificates and secure Flynn routes for related domains. The tool uses [Let's Encrypt](https://letsencrypt.org) to generate certificates.

Pull requests with improvements are welcome. For significant changes, create an issue first to discuss the topic.

## Caveats

I'm using this tool right now and it works for me but it is not well tested. I would recommend reading the script before following these instructions.

Currently, this only works for clusters hosted on Digital Ocean.

Since Flynn does not support persistent volumes, every time the process starts it issues a certificate then begins watching to renew the certificate. Due to [Let's Encrypt rate limits](https://letsencrypt.org/docs/rate-limits/), this can only happen 20 times per week.

Scaling the process will trigger this. Changing environment variables will trigger this. Deployments will trigger this. I recommend double checking your configuration is correct before scaling up the process.

If you scale deployment past a single process, you may see problems.

You've been warned!

## Installing

Clone this repository.

Create a new Flynn app using this repository.

`flynn create certbot`

Set the following environment variables:

### CERTBOT_DNS_PLUGIN 

Only supports digitalocean right now.

### DIGITAL_OCEAN_API_KEY

Get one from [https://cloud.digitalocean.com/account/api/tokens](https://cloud.digitalocean.com/account/api/tokens)

### DOMAINS

A list of flynn app/domain pairs. Must be in the format <flynn app 1>:<valid route for flynn app 1>,<flynn app 2>:<valid route for flynn app 2>,...,n

Example: DOMAINS=app1:app1.cluster.mydomain.com,app2:app2url.cluster.mydomain.com

### EMAIL

A valid email address for Let's Encrypt

### FLYNN_CLUSTER_HOST

Look in `flynn cluster`

### FLYNN_CONTROLLER_KEY

This can be obtained with:

`flynn -a controller env get AUTH_KEY`


### FLYNN_TLS_PIN

This can be obtained with:

```
openssl s_client -connect controller.$CLUSTER_DOMAIN:443 \
  -servername controller.$CLUSTER_DOMAIN 2>/dev/null </dev/null \
  | sed -ne '/-BEGIN CERTIFICATE-/,/-END CERTIFICATE-/p' \
  | openssl x509 -inform PEM -outform DER \
  | openssl dgst -binary -sha256 \
  | openssl base64
```

Where $CLUSTER_DOMAIN is the domain for your cluster.


Finally, when you're ready, push this repository to your flynn remote then scale it to 1 process (exactly).

If everything goes well, all of the domains in $DOMAINS should now support https routes with a valid certificate!

🍻