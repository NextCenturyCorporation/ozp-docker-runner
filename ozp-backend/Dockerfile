# Use the python base container that has the correct version of python
# This is loosely based on the Dockerfile example here:
# http://michal.karzynski.pl/blog/2015/04/19/packaging-django-applications-as-docker-container-images/
FROM python:3.4.5

MAINTAINER Next Century Corporation "ozone_sales@nextcentury.com"

ENV OZP_VERSION=1.0.28
ENV OZP_RELEASE=ozp-backend.tar.gz
ENV OZP_SRVHOME=/srv
ENV OZP_SRVPROJ=$OZP_SRVHOME/ozp

# Add the ozp release bundle.  Note that using `ADD` here automatically
# extracts the release tarball
ADD $OZP_RELEASE /

RUN pip install --no-index --find-links=release/wheelhouse -r release/requirements.txt

EXPOSE 8000

WORKDIR /release
ENTRYPOINT ["gunicorn", "ozp.wsgi"]
