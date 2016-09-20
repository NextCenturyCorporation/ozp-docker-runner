FROM nginx:stable-alpine

ADD ozp-center.tar.gz /usr/share/nginx/html/
ADD ozp-hud.tar.gz /usr/share/nginx/html/
ADD ozp-webtop.tar.gz /usr/share/nginx/html/
ADD ozp-iwc.tar.gz /usr/share/nginx/html/
ADD ozp-help.tar.gz /usr/share/nginx/html/

# Add ozp site configuration to nginx
ADD ozp.conf /etc/nginx/conf.d/

VOLUME /certs
VOLUME /var/log/nginx
VOLUME /etc/ozp

# Replace default OzoneConfig.js with links to the one
# from /etc/ozp
RUN cd /usr/share/nginx/html && \
    for dir in ozp-center ozp-hud ozp-webtop ozp-help; do \
        rm ${dir}/OzoneConfig.js; \
        ln -s /etc/ozp/OzoneConfig.js ${dir}/OzoneConfig.js; \
    done
