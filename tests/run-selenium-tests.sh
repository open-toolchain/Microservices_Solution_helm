#!/bin/bash
GRUNTFILE="tests/Gruntfile.js"
if [ -f $GRUNTFILE ]; then
  npm install -g grunt
  npm install
  npm install -g grunt-idra3
  
  # start selenium server
  /opt/bin/entry_point.sh &

  grunt test_selenium --gruntfile $GRUNTFILE --base .
  grunt_result=$?

  FILE_LOCATION=./xunit.xml
  TEST_TYPE=fvt

  # publish results on solution
  idra --publishtestresult --filelocation=$FILE_LOCATION --type=$TEST_TYPE

  # publish results on all components
  source <(wget --quiet --output-document - "https://raw.githubusercontent.com/open-toolchain/commons/master/scripts/publish_umbrella_test_results.sh.sh")

  # Kill selenium server
  kill %1
  if [ $grunt_result -ne 0 ]; then
     exit $grunt_result
  fi
else
  echo "$GRUNTFILE not found."
fi
