#!/usr/bin/env sh

has() {
    type -a "$1" &>/dev/null || return 1
}

maybe_install_composer() {
    has composer || install_composer
}

maybe_install_git() {
    has git || apk add --no-cache git
}

install_composer() {
    curl -sS https://getcomposer.org/installer | php
    chmod +x composer.phar
    mv composer.phar /usr/bin/composer
    [[ $PUBLIC_BIN ]] && ln -s $HOME/.composer/vendor/bin "$PUBLIC_BIN"
}

install_laravel() {
    maybe_install_composer
    maybe_install_git
    composer global require 'laravel/installer'
}

install_lumen() {
    maybe_install_composer
    composer global require 'laravel/lumen-installer'
}

show_help() {
    echo "Usage: ${0##*/} composer|laravel|lumen [-v|--verbose]";
    exit 1
}

[ $# -eq 0 ] && show_help

VERBOSE=false
while true; do
    case "$1" in
        composer)
            TARGET=composer; shift ;;
        laravel)
            TARGET=laravel; shift ;;
        lumen)
            TARGET=lumen; shift ;;
        -v|--verbose)
            VERBOSE=true; shift ;;
        -h|--help)
            show_help ;;
        *)
            break ;;
    esac
done

$VERBOSE && set -x
[[ $TARGET ]] && install_$TARGET "$@"
