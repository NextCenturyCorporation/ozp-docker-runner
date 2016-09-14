# Use the python base container that has the correct version of python
# This is loosely based on the Dockerfile example here:
# http://michal.karzynski.pl/blog/2015/04/19/packaging-django-applications-as-docker-container-images/
FROM python:3.4.5

MAINTAINER Next Century Corporation "ozone_sales@nextcentury.com"

ENV OZP_RELEASE=ozp-backend.tar.gz

# Add the ozp release bundle.  Note that using `ADD` here automatically
# extracts the release tarball
ADD $OZP_RELEASE /

# Add certs directory
ADD certs /certs

WORKDIR /release

RUN chmod -R 400 /certs

# Install missing native libraries required by Python Imaging Library

# This container is based on Debian Jessie, which has libjpeg-turbo.  To get
# good old libjpeg, we have to reference the packages for Debian Wheezy
RUN echo 'deb http://ftp.de.debian.org/debian wheezy main' >> /etc/apt/sources.list && \
    apt-get update && \
    apt-get install libjpeg8 libopenjp2-7

# Install python dependency packages
RUN pip install --no-index --find-links=wheelhouse -r requirements.txt

# Create initial database and move it into /var/lib/ozp
# Since this is done before the volume is declared, the contents set in it
# here will be copied into the new volume when it is first created
RUN python manage.py makemigrations ozpcenter && \
    python manage.py makemigrations ozpiwc && \
    python manage.py migrate && \
    mkdir -p /var/lib/ozp && \
    mv db.sqlite3 /var/lib/ozp/ozp-db.sqlite3

VOLUME /etc/ozp
VOLUME /var/lib/ozp
VOLUME /mnt/media
VOLUME /var/log/ozp
VOLUME /certs

# Remove the default settings.py file and use the one from the volume
RUN rm ozp/settings.py && ln -s /etc/ozp/backend-settings.py ozp/settings.py

EXPOSE 8000

ENTRYPOINT ["gunicorn", "--bind", "0.0.0.0:8000", "ozp.wsgi"]
