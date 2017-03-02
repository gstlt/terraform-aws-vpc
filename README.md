# terraform-aws-vpc

Terraform module for managing VPCs

## Sample usage

```
module "sample_vpc" {
    source = "github.com/gstlt/terraform-aws-vpc"

    name = "sample_vpc DEV"

    region = "eu-central-1"
    map_public_ip_on_launch = true
}

```

# Author

* [Grzegorz Adamowicz](https://github.com/gstlt)

# Contributors

# License

MIT license, see `LICENSE` file for details

