# Use the python base container that has the correct version of python
# This is loosely based on the Dockerfile example here:
# http://michal.karzynski.pl/blog/2015/04/19/packaging-django-applications-as-docker-container-images/
FROM python:3.4.5

MAINTAINER Next Century Corporation "ozone_sales@nextcentury.com"

ENV OZP_RELEASE=ozp-backend.tar.gz

# Add the ozp release bundle.  Note that using `ADD` here automatically
# extracts the release tarball
ADD $OZP_RELEASE /
WORKDIR /release

# Install missing native libraries required by Python Imaging Library

# This container is based on Debian Jessie, which has libjpeg-turbo.  To get
# good old libjpeg, we have to reference the packages for Debian Wheezy
RUN echo 'deb http://ftp.de.debian.org/debian wheezy main' >> /etc/apt/sources.list && \
    apt-get update && \
    apt-get install libjpeg8 libopenjp2-7

RUN pip install --no-index --find-links=wheelhouse -r requirements.txt

EXPOSE 8000

ENTRYPOINT ["gunicorn", "--bind", "0.0.0.0:8000", "ozp.wsgi"]
