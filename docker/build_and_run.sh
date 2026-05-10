#!/bin/bash
set -e
flutter build web --release --web-renderer canvaskit --base-href /
docker build -t costrutrain:local .
docker run --rm -p 8080:80 costrutrain:local
echo "CostruTrain running at http://localhost:8080"
