#!/usr/bin/env bash

PUBLICFOLDER=""

# Store the script working directory
WD="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

if [[ $PUBLICFOLDER = "" ]] && [[ -d "$WD/public_html" ]] ; then
    PUBLICFOLDER="public_html"
elif [[ $PUBLICFOLDER = "" ]] && [[ -d "$WD/html" ]] ; then
    PUBLICFOLDER="html"
elif [[ $PUBLICFOLDER = "" ]] && [[ -d "$WD/public" ]] ; then
    PUBLICFOLDER="public"
elif [[ $PUBLICFOLDER = "" ]] ; then
    echo ""
    echo "ERROR: Could not determine the PUBLICFOLDER. Please edit workflow.sh, and set PUBLICFOLDER manually."
fi

if [[ $1 = "update" ]] ; then
    COMPOSERCOMMAND="update"
else
    COMPOSERCOMMAND="install"
fi

if [[ $1 = "selfupdate" ]] ; then
    curl -O https://raw.githubusercontent.com/bobdenotter/boltflow/master/files/boltflow.sh
    chmod a+x ./boltflow.sh
    echo "Updated 'boltflow.sh' to the latest version."
    exit 1
fi

if [[ $1 = "config_local_dev" ]] ; then
    curl -o $WD/app/config/config_local.yml https://raw.githubusercontent.com/bobdenotter/boltflow/master/files/config_local_dev.yml
    echo "Fetched 'app/config/config_local.yml' for DEV. Open it in an editor, and edit your credentials."
    # TODO: only do this on MacOS
    # ${FCEDIT:-${VISUAL:-${EDITOR:-vi}}} $WD/app/config/config_local.yml &
    exit 1
fi

if [[ $1 = "config_local_prod" ]] ; then
    curl -o $WD/app/config/config_local.yml https://raw.githubusercontent.com/bobdenotter/boltflow/master/files/config_local_prod.yml
    echo "Fetched 'app/config/config_local.yml' for PROD. Open it in an editor, and edit your credentials."
    # TODO: only do this on MacOS
    # ${FCEDIT:-${VISUAL:-${EDITOR:-vi}}} $WD/app/config/config_local.yml &
    exit 1
fi

if [[ ! -f "$WD/app/config/config_local.yml" ]] ; then
    echo ""
    echo "Note: No local config is present at 'app/config/config_local.yml'. Run either of the following to get it:"
    echo ""
    echo "./boltflow.sh config_local_dev"
    echo "./boltflow.sh config_local_prod"
    echo ""
fi

if [[ ! -f "$WD/composer.json" ]] ; then
    mv $WD/composer.json.dist $WD/composer.json
fi

git config core.fileMode false

if ! (git pull) then
    echo "\n\nGit pull was not successful. Fix what went wrong, and run this script again.\n\n"
    exit 1
fi

if [[ ! -f "$WD/composer.json" ]] ; then
    mv $WD/composer.json.dist $WD/composer.json
fi

mkdir -p app/database app/cache extensions/ $PUBLICFOLDER/files/ $PUBLICFOLDER/thumbs/ $PUBLICFOLDER/extensions/
chmod -Rf 777 app/database/ app/cache/ app/config/ extensions/
chmod -Rf 777 $PUBLICFOLDER/files/ $PUBLICFOLDER/theme/ $PUBLICFOLDER/thumbs/ $PUBLICFOLDER/extensions/

if [[ ! -f "$WD/composer.phar" ]] ; then
    curl -sS https://getcomposer.org/installer | php
fi

if [[ $1 = "update" ]] ; then
    php composer.phar selfupdate
fi

php composer.phar $COMPOSERCOMMAND --ignore-platform-reqs --no-dev

if [[ -f "$WD/extensions/composer.json" ]] ; then
    cd extensions
    php ../composer.phar $COMPOSERCOMMAND --ignore-platform-reqs --no-dev
fi
