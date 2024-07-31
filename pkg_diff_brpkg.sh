#!/bin/bash

# Check if both directories are provided
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 directory1 directory2"
    exit 1
fi

TMPD="./tmp"
if [ ! -d $TMPD ]; then
  mkdir -p $TMPD
fi

DIR1="$TMPD/$1"
DIR2="$TMPD/$2"
DIRR="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"

# Ver1
git clone --depth 1 --branch $1 https://github.com/InvoiceShelf/InvoiceShelf.git /tmp/download &>/dev/null
cd /tmp/download
make dist &>/dev/null
if [ -d $DIR1 ]; then
  rm -rf $DIR1
fi
unzip InvoiceShelf.zip -d $DIR1 &>/dev/null
cd $DIRR

# Ver2
curl -o $DIR2.zip https://invoiceshelf.com/releases/download/$2.zip &>/dev/null
unzip $DIR2.zip -d $TMPD &>/dev/null
if [ -d $DIR2 ]; then
  rm -rf $DIR2
fi
mv $TMPD/InvoiceShelf $DIR2

# List files in DIR2 not in DIR1
comm -13 <(cd "$DIR1" && find . -type f ! -path './.git/*' | sort) <(cd "$DIR2" && find . -type f ! -path './.git/*' | sort)
