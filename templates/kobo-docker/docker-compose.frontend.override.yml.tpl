# For public, HTTPS servers.
version: '3'

services:
  kobocat:
    ${USE_KC_DEV_MODE}build: ${KC_PATH}
    ${USE_KC_DEV_MODE}image: kobocat:dev.${KC_DEV_BUILD_ID}
    ${USE_KC_DEV_MODE}volumes:
    ${USE_KC_DEV_MODE}  - ${KC_PATH}:/srv/src/kobocat
    environment:
      - ENKETO_PROTOCOL=${PROTOCOL}
      - KC_UWSGI_WORKERS_COUNT=${WORKERS_MAX}
      - KC_UWSGI_CHEAPER_WORKERS_COUNT=${WORKERS_START}
      - NGINX_PUBLIC_PORT=${NGINX_PUBLIC_PORT}
      - KC_UWSGI_MAX_REQUESTS=${MAX_REQUESTS}
      - KC_UWSGI_CHEAPER_RSS_LIMIT_SOFT=${SOFT_LIMIT}
    ${USE_DNS}extra_hosts:
      ${USE_PUBLIC_DNS}- ${KOBOFORM_SUBDOMAIN}.${PUBLIC_DOMAIN_NAME}:${LOCAL_INTERFACE_IP}
      ${USE_PUBLIC_DNS}- ${KOBOCAT_SUBDOMAIN}.${PUBLIC_DOMAIN_NAME}:${LOCAL_INTERFACE_IP}
      ${USE_PUBLIC_DNS}- ${ENKETO_SUBDOMAIN}.${PUBLIC_DOMAIN_NAME}:${LOCAL_INTERFACE_IP}
      ${USE_PRIVATE_DNS}- postgres.${PRIVATE_DOMAIN_NAME}:${MASTER_BACKEND_IP}
      ${USE_PRIVATE_DNS}- mongo.${PRIVATE_DOMAIN_NAME}:${MASTER_BACKEND_IP}
      ${USE_PRIVATE_DNS}- redis-main.${PRIVATE_DOMAIN_NAME}:${MASTER_BACKEND_IP}
      ${USE_PRIVATE_DNS}- redis-cache.${PRIVATE_DOMAIN_NAME}:${MASTER_BACKEND_IP}

  kpi:
    ${USE_KPI_DEV_MODE}build: ${KPI_PATH}
    ${USE_KPI_DEV_MODE}image: kpi:dev.${KPI_DEV_BUILD_ID}
    ${USE_KPI_DEV_MODE}volumes:
    ${USE_KPI_DEV_MODE}  - ${KPI_PATH}:/srv/src/kpi
    environment:
      - KPI_UWSGI_WORKERS_COUNT=${WORKERS_MAX}
      - KPI_UWSGI_CHEAPER_WORKERS_COUNT=${WORKERS_START}
      - NGINX_PUBLIC_PORT=${NGINX_PUBLIC_PORT}
      - KPI_UWSGI_MAX_REQUESTS=${MAX_REQUESTS}
      - KPI_UWSGI_CHEAPER_RSS_LIMIT_SOFT=${SOFT_LIMIT}
      ${USE_HTTPS}- SECURE_PROXY_SSL_HEADER=HTTP_X_FORWARDED_PROTO, https
      ${USE_NPM_FROM_HOST}- FRONTEND_DEV_MODE=host
    ${USE_DNS}extra_hosts:
      ${USE_PUBLIC_DNS}- ${KOBOFORM_SUBDOMAIN}.${PUBLIC_DOMAIN_NAME}:${LOCAL_INTERFACE_IP}
      ${USE_PUBLIC_DNS}- ${KOBOCAT_SUBDOMAIN}.${PUBLIC_DOMAIN_NAME}:${LOCAL_INTERFACE_IP}
      ${USE_PUBLIC_DNS}- ${ENKETO_SUBDOMAIN}.${PUBLIC_DOMAIN_NAME}:${LOCAL_INTERFACE_IP}
      ${USE_PRIVATE_DNS}- postgres.${PRIVATE_DOMAIN_NAME}:${MASTER_BACKEND_IP}
      ${USE_PRIVATE_DNS}- mongo.${PRIVATE_DOMAIN_NAME}:${MASTER_BACKEND_IP}
      ${USE_PRIVATE_DNS}- redis-main.${PRIVATE_DOMAIN_NAME}:${MASTER_BACKEND_IP}
      ${USE_PRIVATE_DNS}- redis-cache.${PRIVATE_DOMAIN_NAME}:${MASTER_BACKEND_IP}

  nginx:
    environment:
      - NGINX_PUBLIC_PORT=${NGINX_PUBLIC_PORT}
    ports:
      - ${NGINX_EXPOSED_PORT}:80
    ${USE_DNS}extra_hosts:
      ${USE_PUBLIC_DNS}- ${KOBOFORM_SUBDOMAIN}.${PUBLIC_DOMAIN_NAME}:${LOCAL_INTERFACE_IP}
      ${USE_PUBLIC_DNS}- ${KOBOCAT_SUBDOMAIN}.${PUBLIC_DOMAIN_NAME}:${LOCAL_INTERFACE_IP}
      ${USE_PUBLIC_DNS}- ${ENKETO_SUBDOMAIN}.${PUBLIC_DOMAIN_NAME}:${LOCAL_INTERFACE_IP}
      ${USE_PRIVATE_DNS}- postgres.${PRIVATE_DOMAIN_NAME}:${MASTER_BACKEND_IP}
      ${USE_PRIVATE_DNS}- mongo.${PRIVATE_DOMAIN_NAME}:${MASTER_BACKEND_IP}
      ${USE_PRIVATE_DNS}- redis-main.${PRIVATE_DOMAIN_NAME}:${MASTER_BACKEND_IP}
      ${USE_PRIVATE_DNS}- redis-cache.${PRIVATE_DOMAIN_NAME}:${MASTER_BACKEND_IP}
    networks:
      kobo-fe-network:
        aliases:
          - ${KOBOFORM_SUBDOMAIN}.${INTERNAL_DOMAIN_NAME}
          - ${KOBOCAT_SUBDOMAIN}.${INTERNAL_DOMAIN_NAME}
          - ${ENKETO_SUBDOMAIN}.${INTERNAL_DOMAIN_NAME}

  ${USE_DNS}enketo_express:
    ${USE_DNS}extra_hosts:
      ${USE_PUBLIC_DNS}- ${KOBOFORM_SUBDOMAIN}.${PUBLIC_DOMAIN_NAME}:${LOCAL_INTERFACE_IP}
      ${USE_PUBLIC_DNS}- ${KOBOCAT_SUBDOMAIN}.${PUBLIC_DOMAIN_NAME}:${LOCAL_INTERFACE_IP}
      ${USE_PUBLIC_DNS}- ${ENKETO_SUBDOMAIN}.${PUBLIC_DOMAIN_NAME}:${LOCAL_INTERFACE_IP}
      ${USE_PRIVATE_DNS}- postgres.${PRIVATE_DOMAIN_NAME}:${MASTER_BACKEND_IP}
      ${USE_PRIVATE_DNS}- mongo.${PRIVATE_DOMAIN_NAME}:${MASTER_BACKEND_IP}
      ${USE_PRIVATE_DNS}- redis-main.${PRIVATE_DOMAIN_NAME}:${MASTER_BACKEND_IP}
      ${USE_PRIVATE_DNS}- redis-cache.${PRIVATE_DOMAIN_NAME}:${MASTER_BACKEND_IP}
