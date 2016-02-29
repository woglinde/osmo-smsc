#!/bin/bash

set -eu

if [ x"${TRAVIS_SMALLTALK_VERSION}" != x"Pharo-4.0" ]; then
    exit 0
fi

cat <<- EOF > ~/.oscrc
[general]
apiurl = https://api.opensuse.org

[https://api.opensuse.org]
user = woglinde
pass = ${OBS_PASS}
EOF

osc co home:woglinde osmo-smsc
cd home:woglinde/osmo-smsc/
osc rm *.dsc *.tar.gz *.changes
cd
cp *.dsc *.tar.gz *.changes home:woglinde/osmo-smsc/
cd home:woglinde/osmo-smsc/
osc add *.dsc *.tar.gz *.changes
osc ci -m "new build"
