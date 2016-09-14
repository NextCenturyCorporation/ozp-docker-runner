#!/bin/sh

# Create, populate, and move the sample database
python manage.py makemigrations ozpcenter && \
    python manage.py makemigrations ozpiwc && \
    python manage.py migrate && \
    python manage.py runscript sample_data_generator
