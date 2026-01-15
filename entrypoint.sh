#!/bin/sh
set -e

cd /app

# Auto install dependencies if vendor/autoload.php not exists
if [ ! -f vendor/autoload.php ]; then
    echo "Composer dependencies not found, installing..."
    composer install --no-interaction --no-scripts --no-plugins
fi

# Execute s6-overlay init then the command
exec /init "$@"
