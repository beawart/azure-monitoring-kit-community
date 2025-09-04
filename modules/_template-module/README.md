# <Module Name>

Short description of what this module does.

## Usage

```hcl
module "<module-name>" {
  source              = "./modules/<module-name>"
  name                = "example-name"
  location            = "australiaeast"
  resource_group_name = "rg-example"
  tags = {
    environment = "dev"
    owner       = "platform-team"
  }
}
```
