#!/bin/bash

set -o nounset
set -o errexit
set -o pipefail

echo "************ image based install verify reinstall command ************"

source "${SHARED_DIR}/packet-conf.sh"

ssh "${SSHOPTS[@]}" "root@${IP}" bash - << "EOF"

# prepending each printed line with a timestamp
exec > >(awk '{ print strftime("[%Y-%m-%d %H:%M:%S]"), $0 }') 2>&1

set -xeo pipefail

cd /root/dev-scripts
source common.sh
source utils.sh
source network.sh

mkdir /root/ibi-cluster
cat > /root/ibi-cluster/kubeconfig <<-EOKUBECONFIG

EOKUBECONFIG

installed_id=$(oc --kubeconfig /root/ibi-cluster/kubeconfig get clusterversion version -ojson | jq -r .spec.clusterID)
if [[ "$installed_id" != "uuidhere" ]]
then
  echo "installed cluster ID $installed_id does not match expected cluster ID uuidhere"
  return 1
fi

EOF
