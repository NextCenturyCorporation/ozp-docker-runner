#!/bin/sh

# Create, populate, and move the sample database
python manage.py makemigrations ozpcenter && \
    python manage.py makemigrations ozpiwc && \
    python manage.py migrate && \
    echo -n 'Generating sample data... ' && \
    python manage.py runscript sample_data_generator && \
    echo 'Done'
