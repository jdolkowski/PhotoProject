#!/bin/bash

# Wait for databases
sleep 20

echo "Apply database migrations"
python photo_api/manage.py migrate

echo "Starting server"
python photo_api/manage.py runserver 0.0.0.0:8020 --settings=config.settings
