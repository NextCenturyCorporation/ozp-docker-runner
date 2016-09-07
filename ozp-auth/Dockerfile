# Use the python base container that has the correct version of python
# This is loosely based on the Dockerfile example here:
# http://michal.karzynski.pl/blog/2015/04/19/packaging-django-applications-as-docker-container-images/
FROM python:3.4.5

MAINTAINER Next Century Corporation "ozone_sales@nextcentury.com"

ENV OZP_AUTH_RELEASE=ozp-auth.tar.gz

# Add the ozp release bundle.  Note that using `ADD` here automatically
# extracts the release tarball
ADD $OZP_AUTH_RELEASE /
WORKDIR /demo-auth-service

RUN pip install -r requirements.txt

EXPOSE 8000
ENTRYPOINT ["gunicorn", "--bind", "0.0.0.0:8000", "demoauth.wsgi"]
