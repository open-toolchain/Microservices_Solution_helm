#!/bin/bash
GRUNTFILE="./tests/Gruntfile.js"
if [ -f $GRUNTFILE ]; then
  npm install
  npm install -g grunt-cli
  
  set +e
  grunt test_real --gruntfile $GRUNTFILE --base .
  grunt_result=$?
  set -e
  FILE_LOCATION=./xunit.xml
  TEST_TYPE=fvt

  # publish results on all components
  source <(curl -sSL "https://raw.githubusercontent.com/open-toolchain/commons/master/scripts/publish_umbrella_test_results.sh")

  if [ $grunt_result -ne 0 ]; then
     exit $grunt_result
  fi
else
  echo "$GRUNTFILE not found."
fi
