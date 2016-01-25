# Install Varnish
class varnish(
    $ensure = present,
    $vcl_template = 'varnish/default.vcl.erb',
    $port = 8080,
) {
    include varnish::config
    include homebrew

    case $ensure {
        present: {

            # Install our custom plist for Varnish. Listens on port 8080
            file { '/Library/LaunchDaemons/dev.varnish.plist':
                content => template('varnish/dev.varnish.plist.erb'),
                group   => 'wheel',
                notify  => Service['dev.varnish'],
                owner   => 'root'
            }

            # Create directories
            file { [
                $varnish::config::configdir,
                $varnish::config::datadir,
                $varnish::config::logdir,
            ]:
                ensure => directory
            }

            # Create default vcl in boxen path
            file { $varnish::config::vclfile:
                content => template($vcl_template),
                notify  => Service['dev.varnish']
            }

            # Install varnish with custom brew formula
            homebrew::formula { 'varnish':
                before => Package['boxen/brews/varnish'],
            }

            package { 'boxen/brews/varnish':
                ensure => '4.1.0-boxen1',
                notify => Service['dev.varnish']
            }

            # Remove Homebrew's varnish vcl to avoid confusion.
            file { "${boxen::config::homebrewdir}/etc/varnish":
                ensure  => absent,
                force   => true,
                recurse => true,
                require => Package['boxen/brews/varnish']
            }

            service { 'dev.varnish':
                ensure  => running,
                require => Package['boxen/brews/varnish']
            }
        }

        absent: {
            service { 'dev.varnish':
                ensure  => stopped,
            }

            file { '/Library/LaunchDaemons/dev.varnish.plist':
                ensure => absent
            }

            file { [
                $varnish::config::configdir,
                $varnish::config::datadir,
                $varnish::config::logdir,
            ]:
                ensure => absent
            }

            package { 'boxen/brews/varnish':
                ensure => absent,
            }
        }

        default: {
            fail('Varnish#Illegal ensure: must be present or absent.')
        }
    }
}
