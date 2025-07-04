PROJECT_NAMESPACE=$(to-kebab-case "$1")
DOMAIN="web.local.${PROJECT_NAMESPACE}.com"

if [ -z "$DOMAIN" ]; then
    echo "Usage: $0 <domain>"
    exit 1
fi

RESULT=$(dig "$DOMAIN" @127.0.0.1 +short)

if [ -z "$RESULT" ]; then
    echo -e "\033[31mDNS Problem:\033[0m No DNS entry found for $DOMAIN via 127.0.0.1"
    echo ""
    echo "Please ensure dnsmasq is running and configured to resolve ${DOMAIN} to 127.0.0.1"
    echo ""
    echo "If using nix-darwin, you can add the following module to your configuration:"
    echo "
    { ... }:
    {
    services.dnsmasq = {
        enable = true;
        addresses = {
            \"$DOMAIN\" = \"127.0.0.1\";
        };
    };
    }
    "
    echo ""
    echo "If you are not using nix-darwin, you can install dnsmasq with homebrew via 'brew install dnsmasq'."
    echo ""
    echo "Example here: https://maxschmitt.me/posts/local-subdomains-dnsmasq-caddy/"
else
    echo -e "\033[32mDNS entry for $DOMAIN is working!\033[0m"
fi
