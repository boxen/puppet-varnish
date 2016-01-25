# Varnish Puppet Module for Boxen

## Usage

```puppet
include varnish
```

To specify a different template for the vcl or a different port to listen to, use options `vcl_template` and `port`:
```puppet
class { "varnish":
    vcl_template => "path/to/template.erb",
    port => 80
}
```

## Required Puppet Modules

* `boxen`
* `homebrew`
* `stdlib`

## Development

Write some code.
Run `script/cibuild` to test it.
Check the `script` directory for other useful tools.


## Credits

This module is inspired in the [boxen/puppet-nginx](https://github.com/boxen/puppet-nginx) module.