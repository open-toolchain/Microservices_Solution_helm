#!/bin/bash
GRUNTFILE="tests/Gruntfile.js"
if [ -f $GRUNTFILE ]; then
  export PATH=/opt/IBM/node-v4.2/bin:$PATH
  npm install
  npm install -g grunt-idra3
  grunt test_real --gruntfile $GRUNTFILE --base .
  grunt_result=$?

  FILE_LOCATION=./xunit.xml
  TEST_TYPE=fvt

  # publish results on solution
  # idra --publishtestresult --filelocation=$FILE_LOCATION --type=$TEST_TYPE

  # publish results on all components
  source <(curl -sSL "https://raw.githubusercontent.com/open-toolchain/commons/master/scripts/publish_umbrella_test_results.sh.sh")

  if [ $grunt_result -ne 0 ]; then
     exit $grunt_result
  fi
else
  echo "$GRUNTFILE not found."
fi