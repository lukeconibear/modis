#!/bin/bash

function usage {
  echo "Usage:"
  echo "  $0 [options]"
  echo ""
  echo "Description:"
  echo "  This script will recursively download all files if they don't exist"
  echo "  from a LAADS URL and stores them to the specified path"
  echo ""
  echo "Options:"
  echo "    -s|--source [URL]         Recursively download files at [URL]"
  echo "    -d|--destination [path]   Store directory structure to [path]"
  echo "    -t|--token [token]        Use app token [token] to authenticate"
  echo ""
  echo "Dependencies:"
  echo "  Requires 'jq' which is available as a standalone executable from"
  echo "  https://stedolan.github.io/jq/download/"
}

function recurse {
  local src=$1
  local dest=$2
  local token=$3
  
  echo "Querying ${src}.json"

  for dir in $(curl -s -H "Authorization: Bearer ${token}" ${src}.json | jq '.[] | select(.size==0) | .name' | tr -d '"')
  do
    echo "Creating ${dest}/${dir}"
    mkdir -p "${dest}/${dir}"
    echo "Recursing ${src}/${dir}/ for ${dest}/${dir}"
    recurse "${src}/${dir}/" "${dest}/${dir}"
  done

  for file in $(curl -s -H "Authorization: Bearer ${token}" ${src}.json | jq '.[] | select(.size!=0) | .name' | tr -d '"')
  do
    if [ ! -f ${dest}/${file} ] 
    then
      echo "Downloading $file to ${dest}"
      # replace '-s' with '-#' below for download progress bars
      curl -s -H "Authorization: Bearer ${token}" ${src}/${file} -o ${dest}/${file}
    else
      echo "Skipping $file ..."
    fi
  done
}

POSITIONAL=()
while [[ $# -gt 0 ]]
do
  key="$1"

  case $key in
    -s|--source)
    src="$2"
    shift # past argument
    shift # past value
    ;;
    -d|--destination)
    dest="$2"
    shift # past argument
    shift # past value
    ;;
    -t|--token)
    token="$2"
    shift # past argument
    shift # past value
    ;;
    *)    # unknown option
    POSITIONAL+=("$1") # save it in an array for later
    shift # past argument
    ;;
  esac
done

if [ -z ${src+x} ]
then 
  echo "Source is not specified"
  usage
  exit 1
fi

if [ -z ${dest+x} ]
then 
  echo "Destination is not specified"
  usage
  exit 1
fi

if [ -z ${token+x} ]
then 
  echo "Token is not specified"
  usage
  exit 1
fi

recurse "$src" "$dest" "$token"

