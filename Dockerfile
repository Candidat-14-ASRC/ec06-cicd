# Image Nginx contenant le site statique Catal-Log.
# Base alpine : petite taille, surface d'attaque reduite, adaptee a un site statique.
FROM nginx:1.27-alpine

LABEL org.opencontainers.image.title="catal-log-site"
LABEL org.opencontainers.image.description="Site statique Catal-Log - Projet CICD EC06"
LABEL org.opencontainers.image.licenses="MIT"

# Copie du site statique dans le repertoire servi par Nginx.
COPY site/ /usr/share/nginx/html/

# Nginx ecoute sur le port 80 par defaut dans l'image officielle.
EXPOSE 80

# Healthcheck : permet a Docker/Compose de savoir si le conteneur sert
# correctement le contenu, utile pour les tests automatises et la supervision.
HEALTHCHECK --interval=10s --timeout=3s --retries=3 \
  CMD wget --quiet --tries=1 --spider http://localhost/ || exit 1
