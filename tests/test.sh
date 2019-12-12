#!/bin/bash

# base colours
red="\e[1;31m"
d_red="\e[31m"
green="\e[32m"
yellow="\e[33m"
blue="\e[34m"
purple="\e[35m"
magenta="\e[36m"
white="\e[0m"

BIN_DIR="../bin"
CHECK_FILE_MD5="${BIN_DIR}/check_file_md5"

function assert () {
  if [[ $1 -eq $2 ]]; then
    echo -e "${green}Pass${white}"
  else
    echo -e "${d_red}Fail${white}. Expected $2 but got $1"
  fi
  echo ""
}

function cleanup () {
  rm -f not_allowed_to_change.file
  rm -f /usr/local/nagios/md5s*
}

function test_createMd5sumFile () {
  echo "${FUNCNAME[0]}:"
  echo "this is a file with critical content" > not_allowed_to_change.file
  $CHECK_FILE_MD5 not_allowed_to_change.file

  echo "Creating MD5sum file"
  assert $? 0
}

function test_unchangedFile () {
  echo "${FUNCNAME[0]}:"
  echo "Validating unchanged file"
  $CHECK_FILE_MD5 not_allowed_to_change.file
  assert $? 0
}

function test_changedFile () {
  echo "${FUNCNAME[0]}:"
  echo "Changes" >> not_allowed_to_change.file
  echo "Validating changed file"
  $CHECK_FILE_MD5 not_allowed_to_change.file
  assert $? 2
}

test_createMd5sumFile
test_unchangedFile
test_changedFile

#cleanup
