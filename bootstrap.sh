#!/bin/bash

set -eu

APP_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd  )"

ln -sfn ${APP_PATH}/lfrc ${HOME}/.config/lf
ln -sfn ${APP_PATH}/icons ${HOME}/.config/lf
ln -sfn ${APP_PATH}/previewer.sh ${HOME}/.config/lf
ln -sfn ${APP_PATH}/cleaner.sh ${HOME}/.config/lf
