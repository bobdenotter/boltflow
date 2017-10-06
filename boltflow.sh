#!/usr/bin/env bash

function get_composer () {
    EXPECTED_SIGNATURE=$(wget -q -O - https://composer.github.io/installer.sig)
    php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
    ACTUAL_SIGNATURE=$(php -r "echo hash_file('SHA384', 'composer-setup.php');")

    if [ "$EXPECTED_SIGNATURE" != "$ACTUAL_SIGNATURE" ]
    then
        >&2 echo 'ERROR: Invalid installer signature'
        rm composer-setup.php
        exit 1
    fi

    php composer-setup.php
    RESULT=$?
    rm composer-setup.php
    if [[ $RESULT == 1 ]] ; then
        exit 1
    fi
}

PUBLICFOLDER=""

echo "⇒ Boltflow 🚀 - version 0.6.0"

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
    echo "ERROR: Could not determine the PUBLICFOLDER. Please edit boltflow.sh, and set PUBLICFOLDER manually."
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

if [[ ! -f "$WD/composer.json" ]] ; then
    mv $WD/composer.json.dist $WD/composer.json
fi

if [ -d "$WD/.git" ]; then
    git config core.fileMode false

    if ! (git pull) then
        printf "\n\n\e[31mGit pull was not successful. Fix what went wrong, and run this script again.\n\n"
        exit 1
    fi
else
    printf "\e[31mNo git repository found.\n"
fi

if [[ ! -f "$WD/composer.json" ]] ; then
    mv $WD/composer.json.dist $WD/composer.json
fi

mkdir -p app/database app/cache extensions/ $PUBLICFOLDER/files/ $PUBLICFOLDER/thumbs/ $PUBLICFOLDER/extensions/
chmod -Rf 777 app/database/ app/cache/ app/config/ extensions/
chmod -Rf 777 $PUBLICFOLDER/files/ $PUBLICFOLDER/theme/ $PUBLICFOLDER/thumbs/ $PUBLICFOLDER/extensions/

if [[ ! -f "$WD/composer.phar" ]] ; then
    get_composer
fi

if [[ $1 = "update" ]] ; then
    php composer.phar selfupdate
fi

php composer.phar $COMPOSERCOMMAND --no-dev

if [[ -f "$WD/extensions/composer.json" ]] ; then
    cd extensions
    php ../composer.phar $COMPOSERCOMMAND --no-dev
    cd ..
fi

php app/nut cache:clear

if [[ ! -f "$WD/app/config/config_local.yml" ]] ; then
    echo ""
    echo "Note: No local config is present at 'app/config/config_local.yml'. Run either of the following to get it:"
    echo ""
    echo "./boltflow.sh config_local_dev"
    echo "./boltflow.sh config_local_prod"
    echo ""
fi

echo ""
echo "Done! 👍"
