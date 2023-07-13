#!/bin/bash

set -eu

kitty +kitten icat --clear --transfer-mode file --stdin no < /dev/null > /dev/tty
