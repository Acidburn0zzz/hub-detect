#!/bin/sh

# This value should not be updated - the Jenkins
# build process will, for ANY snapshot build,
# override the latest snapshot jar.

PACKMAN_LATEST_SNAPSHOT=hub-packman-latest-SNAPSHOT.jar

# This value should be automatically updated by the
# gradle build process for a non-snapshot build.
PACKMAN_LATEST_RELEASE_VERSION="0.0.3.1"
PACKMAN_LATEST_RELEASE="hub-packman-${PACKMAN_LATEST_RELEASE_VERSION}.jar"

# If you would like to enable the shell script to use
# the latest snapshot instead of the latest release,
# specify PACKMAN_USE_SNAPSHOT=1 in your environment.
# The default is to NOT use snapshots. If you enable
# snapshots, the jar file will always be downloaded.

PACKMAN_USE_SNAPSHOT=${PACKMAN_USE_SNAPSHOT:-0}

# To override the default location of /tmp, specify
# your own PACKMAN_JAR_PATH in your environment and
# *that* location will be used.

PACKMAN_JAR_PATH=${PACKMAN_JAR_PATH:-/tmp}

all_command_line_args=$@

run() {
  get_packman
  run_packman
}

get_packman() {
  VERSION_FILE_DESTINATION="${PACKMAN_JAR_PATH}/hub-packman-latest-commit-id.txt"
  CURRENT_VERSION=""
  if [ -f $VERSION_FILE_DESTINATION ]; then
    CURRENT_VERSION=$( <$VERSION_FILE_DESTINATION )
  fi

  curl -o $VERSION_FILE_DESTINATION https://blackducksoftware.github.io/hub-detect/latest-commit-id.txt
  LATEST_VERSION=$( <$VERSION_FILE_DESTINATION )

  if [ $PACKMAN_USE_SNAPSHOT -eq 1 ]; then
    echo "will look for snapshot: ${PACKMAN_LATEST_SNAPSHOT}"
    PACKMAN_DESTINATION="${PACKMAN_JAR_PATH}/${PACKMAN_LATEST_SNAPSHOT}"
    PACKMAN_SOURCE=$PACKMAN_LATEST_SNAPSHOT
  else
    echo "will look for release: ${PACKMAN_LATEST_RELEASE}"
    PACKMAN_DESTINATION="${PACKMAN_JAR_PATH}/${PACKMAN_LATEST_RELEASE}"
    PACKMAN_SOURCE=$PACKMAN_LATEST_RELEASE
  fi

  USE_REMOTE=1
  if [ "$CURRENT_VERSION" != "$LATEST_VERSION" ] && [ $PACKMAN_USE_SNAPSHOT -eq 1 ]; then
    echo "You don't have the latest snapshot, so the new snapshot will be downloaded."
  elif [ ! -f $PACKMAN_DESTINATION ]; then
    echo "You don't have the current file, so it will be downloaded."
  else
    echo "You have already downloaded the latest file, so the local file will be used."
    USE_REMOTE=0
  fi

  if [ $USE_REMOTE -eq 1 ]; then
    echo "getting ${PACKMAN_SOURCE} from remote"
    curl -o $PACKMAN_DESTINATION https://blackducksoftware.github.io/hub-detect/$PACKMAN_SOURCE
    echo "saved ${PACKMAN_SOURCE} to ${PACKMAN_DESTINATION}"
  fi
}

run_packman() {
  echo "running packman: ${PACKMAN_DESTINATION} ${all_command_line_args}"
  java -jar $PACKMAN_DESTINATION $all_command_line_args
}

run
