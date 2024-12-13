#!/bin/bash

set -o nounset
set -o errexit
set -o pipefail

echo "************ image based install create identity secrets command ************"

source "${SHARED_DIR}/packet-conf.sh"

ssh "${SSHOPTS[@]}" "root@${IP}" bash - << "EOF"

# prepending each printed line with a timestamp
exec > >(awk '{ print strftime("[%Y-%m-%d %H:%M:%S]"), $0 }') 2>&1

set -xeo pipefail

cd /root/dev-scripts
source common.sh
source utils.sh
source network.sh

tee <<EOSEC | oc create -f -
EOSEC

EOF
