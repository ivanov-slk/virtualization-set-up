# Adapted from https://austincloud.guru/2020/02/27/building-packer-image-with-terraform/

resource "null_resource" "packer-build" {
  triggers = {
    distribution_name            = var.distribution_name
    virtual_machine_image        = var.virtual_machine_image
    virtual_machine_image_sha    = var.virtual_machine_image_sha
    virtual_machine_image_exists = fileexists(".packer-vmis/${var.virtual_machine_image}.box")
    # always_run            = "${timestamp()}"
  }
  provisioner "local-exec" {
    working_dir = "."
    command     = <<EOF
cd packer-vmis
packer build -var "distribution_name=${self.triggers.distribution_name}" \
             -var "virtual_machine_image=${self.triggers.virtual_machine_image}" \
             -var "virtual_machine_image_sha=${self.triggers.virtual_machine_image_sha}" \
             ${self.triggers.virtual_machine_image}.pkr.hcl
EOF
  }

  # Keep the image to avoid rebuilding each time; uncomment when stable.
  provisioner "local-exec" {
    when    = destroy
    command = "rm -rf ./packer-vmis/${self.triggers.virtual_machine_image}.box"
  }
}
