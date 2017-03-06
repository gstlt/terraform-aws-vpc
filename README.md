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

We expect to get `azs_mapping` variable in form:

```
variable "azs_mapping" {
    description = "Mapping of region to availability zones"
    type = "map"

    default = {
        # US, North Virginia
        us-east-1      = "a,b,c,d,e"
    }
}
```

This will allow us to generate subnets in all AZs automatically.

Terraform handling map of lists is not implemented (yet) in 0.8.8; eg. lookup() function expect string, not a list in map, also it is converting list to a string. Because of this, it was far more easier to implement it as a string and then split it to get a list.

# Author

* [Grzegorz Adamowicz](https://github.com/gstlt)

# Contributors

# License

MIT license, see `LICENSE` file for details

