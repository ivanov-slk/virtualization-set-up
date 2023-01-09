# Adapted from https://austincloud.guru/2020/02/27/building-packer-image-with-terraform/

resource "null_resource" "packer-build" {
  triggers = {
    virtual_machine_image = var.virtual_machine_image
    always_run            = "${timestamp()}"
  }
  provisioner "local-exec" {
    working_dir = "."
    command     = <<EOF
RED='\033[0;31m' # Red Text
GREEN='\033[0;32m' # Green Text
BLUE='\033[0;34m' # Blue Text
NC='\033[0m' # No Color

cd packer-vmis
packer build ubuntu-22.10-live-server-amd64.pkr.hcl

if [ $? -eq 0 ]; then
  printf "\n $GREEN Packer Succeeded $NC \n"
else
  printf "\n $RED Packer Failed $NC \n" >&2
  exit 1
fi
EOF
  }
}
