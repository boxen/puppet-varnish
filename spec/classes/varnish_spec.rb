require 'spec_helper'

describe 'varnish' do
    let(:facts) do
        {
            :boxen_home => "/test/boxen",
        }
    end

    it do

        should contain_file('/Library/LaunchDaemons/dev.varnish.plist').with({
          :group  => 'wheel',
          :notify => 'Service[dev.varnish]',
          :owner  => 'root'
        })

        should contain_file('/test/boxen/config/varnish').with_ensure('directory')
        should contain_file('/test/boxen/data/varnish').with_ensure('directory')
        should contain_file('/test/boxen/log/varnish').with_ensure('directory')

        should contain_file('/test/boxen/config/varnish/default_boxen.vcl').with_notify('Service[dev.varnish]')

        should contain_homebrew__formula('varnish').with_before('Package[boxen/brews/varnish]')

        should contain_package('boxen/brews/varnish').with({
          :ensure => '4.1.0-boxen1',
          :notify => 'Service[dev.varnish]'
        })

        should contain_service('dev.varnish').with({
          :ensure  => 'running',
          :require => 'Package[boxen/brews/varnish]',
        })
   end
end
