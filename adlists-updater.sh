[ -z $BASH ] && { exec bash "$0" "$@" || exit; }
#!/usr/bin/env bash

# author  : Javan Rasokat (javan.de)
# license : gplv3

# we need to be root to have write access to gravity.db
if [ "$EUID" -ne 0 ]
  then echo "Warning: Please run as root"
  exit 1
fi

basename="pihole"
PIHOLE_COMMAND="/usr/local/bin/${basename}"
piholeDir="/etc/${basename}"
gravityDBfile="${piholeDir}/gravity.db"
adListSource="https://raw.githubusercontent.com/JavanXD/ya-pihole-list/master/adlists.list.updater"
adListFile="$HOME/adlists.list.updater"
tmpFile="$HOME/adlists.list.updater.tmp"
table="adlist"
timestamp="$(date --utc +'%s')"

# check if we're actually on a pihole (and a new version at that)
command -v pihole >/dev/null 2>&1 || { \
    echo >&2 "Error: You must run this on a pihole!"; exit 1; }

# auto update arguments
if [ -z "$1" ] ; then
  echo "Info: No argument for enabling auto raspbian update. Default is 'no update'."
  update=0
else
  update=$1
fi

if [ $update -eq 1 ] ; then
  # update raspbian
  echo "Info: Updating Raspbian"
  apt-get update && apt-get dist-upgrade -y

  # update pihole
  echo "Info: Updating Pi-hole"
  pihole updatePihole
fi

# update gravity table (create or migrate if not exists yet)
echo "Info: Create or migrate gravity.db table if not exists yet"
pihole updateGravity

# download latest adlists list
echo "Info: Download latest adlists list to ${adListFile}"
curl --url ${adListSource} --output ${adListFile}

# add lists to gravity db
# Migrate list files to new database
if [ -e "${adListFile}" ]; then
  # Store adlist domains in database
  echo "Info: Adding content of ${adListFile} into gravity database"

  # Get MAX(id) when INSERTing into this table
  rowid="$(sqlite3 "${gravityDBfile}" "SELECT MAX(id) FROM ${table};")"
  if [[ -z "$rowid" ]]; then
    rowid=0
  fi
  rowid=$((rowid+1))

  # Loop over all domains in ${adListFile} file
  # Read file line by line
  grep -v '^ *#' < "${adListFile}" | while IFS= read -r domain
  do
    # Only add non-empty lines
    if [[ -n "${domain}" ]]; then
      # Adlist table format
      echo "${rowid},\"${domain}\",1,${timestamp},${timestamp},\"Added by Updater\",,0,0,0" >> "${tmpFile}"
      rowid=$((rowid+1))
    fi
  done

  # Store domains in database table specified by ${table}
  # Use printf as .mode and .import need to be on separate lines
  # see https://unix.stackexchange.com/a/445615/83260
  output=$( { printf ".timeout 30000\\n.mode csv\\n.import \"%s\" %s\\n" "${tmpFile}" "${table}" | sqlite3 "${gravityDBfile}"; } 2>&1 )
  status="$?"

  # delete temporary file
  rm ${tmpFile}

  if [[ "${status}" -ne 0 ]]; then
    echo "Warning: Some warnings in table ${table} in database ${gravityDBfile}:"
    echo "${output}"
  else
    echo "Info: Successfull inserted the adlists list"
  fi
fi

# update gravity table (activate the changes to the gravity.db)
echo "Info: Caling 'pihole -g' because of the changes to the gravity.db"
pihole updateGravity
