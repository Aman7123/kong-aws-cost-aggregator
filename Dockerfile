# Choose a default image
# Check https://hub.docker.com/r/kong/kong-gateway/tags for latest versions
FROM kong/kong-gateway:3.0.0.0-alpine

# Establish variables for Kong and hardset our plugin
ENV KONG_PLUGINS="bundled,aws-cost-aggregator"
# This variable informs Kong where to look for custom code
ENV KONG_LUA_PACKAGE_PATH="/usr/local/share/lua/5.1/?.lua;;/usr/local/custom/?.lua;;"

# Copy our code
COPY ./kong/plugins/aws-cost-aggregator /usr/local/custom/kong/plugins/aws-cost-aggregator