#!/usr/bin/env bash

TARGETDIR="./build/tools"

declare -a tools=("phpab"
                  "phpcpd"
                  "phpdox"
                  "phploc"
                  "phpunit"
                  )
for tool in "${tools[@]}"
do
    echo "installing $tool..."
    phive install --target ${TARGETDIR} $tool
done

#nonphive compliant phars
declare -a pharurls=(
                  "https://static.pdepend.org/php/latest/pdepend.phar"
                  "https://static.phpmd.org/php/latest/phpmd.phar"
                  "https://squizlabs.github.io/PHP_CodeSniffer/phpcs.phar"
                  "https://squizlabs.github.io/PHP_CodeSniffer/phpcbf.phar"
)
for pharurl in "${pharurls[@]}"
do
    phar=${pharurl##*/}
    if [ ! -f ~/.phive/phars/${phar} ] || [ "$1" = "update" ]; then
        echo "installing ${pharurl}..."
        wget ${pharurl}
        chmod +x ${phar}
        mv ${phar} ~/.phive/phars/
    else
        echo "${phar} already installed."
    fi
    if [ ! -f ${TARGETDIR}/${phar%.*} ] || [ "$1" = "update" ]; then
        echo "Linking ${phar}"
        ln -s ~/.phive/phars/${phar} ${TARGETDIR}/${phar%.*}
    fi
done
