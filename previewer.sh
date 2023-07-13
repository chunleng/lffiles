#!/bin/bash

set -eu

# We can use the following link for guide on file previewer
# https://pkg.go.dev/github.com/gokcehan/lf#hdr-Previewing_Files

file_path=$1
width=$2
height=$3
previewer_x=$4
previewer_y=$5

mimetype="$( file --dereference --brief --mime-type -- "${file_path}" )"
tmp_dir="/tmp/lf/"

function place_image() {
    kitty +kitten icat --place ${width}x${height}@${previewer_x}x${previewer_y} --transfer-mode file --stdin no "${1}" < /dev/null > /dev/tty
}

function default_handler() {
    bat --color=always --style=plain "${1}"
}

case "${mimetype}" in
    application/x-tar | \
    application/gzip | \
    application/zip)
        tar -tf "${file_path}";;
    application/pdf)
        mkdir -p ${tmp_dir}`dirname ${file_path}`
        pdftoppm -f 1 -l 1 \
                -scale-to-x "2000" \
                -scale-to-y -1 \
                -singlefile \
                -jpeg -tiffcompression jpeg \
                -- "${file_path}" "${tmp_dir}${file_path}"
        place_image "${tmp_dir}${file_path}.jpg"
        exit 1;;
    application/json)
        jq . "${file_path}"|bat --color=always --style=plain --language=json;;
    application/xml)
        yq "${file_path}";;
    image/*)
        place_image "${file_path}"
        exit 1;;
    text/plain)
        extension="${file_path#*.}"
        case "${extension}" in
            xml)
                yq -p=xml -o=xml "${file_path}"|bat --color=always --style=plain --language=xml;;
            *) default_handler "${file_path}"
        esac
        ;;
    *) default_handler "${file_path}"
esac
