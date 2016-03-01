#!/bin/bash

set -eu

if [ x"${TRAVIS_SMALLTALK_VERSION}" != x"Pharo-4.0" ]; then
    exit 0
fi

cat <<- EOF > ~/.oscrc
[general]
apiurl = https://api.opensuse.org

[https://api.opensuse.org]
user = ${OBS_USER}
pass = ${OBS_PASS}
EOF

OBS_HOME="home:${OBS_USER}/osmo-smsc/"

pwd
osc co home:${OBS_USER} osmo-smsc
pushd .
cd ${OBS_HOME}
osc rm *.dsc *.tar.gz *.changes
popd
cp *.dsc *.tar.gz *.changes ${OBS_HOME}
cd ${OBS_HOME}
osc add *.dsc *.tar.gz *.changes
osc ci -m "new build"
