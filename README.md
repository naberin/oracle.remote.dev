# VM for Development
This repository contains files and scripts to help you develop web-applications in a VM.



## Get Started
1. __[Provision with ORM (recommended)](./documentation/orm.md) or [Provision with Terraform CLI](./documentation/terraform.md)__

2. __[Connect to Work VM](./documentation/connection.md)__


## Customizing your VM Setup
To customize your setup and have it ready by the time provisioning is done, you can customize your own cloud-init script. The following link points to the script that is ran after provisioning:
- [View init.yaml](./terraform/scripts/init.yaml)

Refer to the following resources to add on to your `init.yaml`. Other resources like `chef`, `ansible` can also be used to prepare your VM.
- [Cloud Init Documentation](https://cloudinit.readthedocs.io/en/latest/index.html)

- [Cloud Init Examples](https://cloudinit.readthedocs.io/en/latest/topics/examples.html)