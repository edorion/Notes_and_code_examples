#Create Sinatra Hello World env and deploy

# Created: by Andrew McDonald
# note: this requires module:
# rvm - on puppet master "puppet module install maestrodev/rvm"
# The file sinatraSetup.sh need to be in the default puppet file store


class prereqs{
        exec { "apt-update": command => "/usr/bin/apt-get -y update" }
        package { ['git-core', 'screen', 'libgdbm-dev', 'libncurses5-dev', 'libtool', 'libffi-dev']: ensure => installed }
}

class installrvm{
        include rvm
        rvm::system_user { andrew: ; }
}

class installruby{
        rvm_system_ruby {
          'ruby-1.9.3':
            ensure => 'present',
            default_use => true;}
}

class installgems{
        rvm_gem {
          'bundler':
            name => 'bundler',
            ruby_version => 'ruby-1.9.3',
            ensure => latest,
        }

        rvm_gem {
          'sinatra':
            name => 'sinatra',
            ruby_version => 'ruby-1.9.3',
            ensure => latest,
        }
}

class installpassenger {
    class {
        'rvm::passenger::apache':
            version     => '3.0.19',
            ruby_version    => 'ruby-1.9.3',
            mininstances    => '3',
            maxinstancesperapp  => '0',
            maxpoolsize     => '30',
            spawnmethod     => 'smart-lv2';
    }
}

class finalisesinatraappinstall {
        file { '/tmp/sinatraSetup.sh':
                ensure => present,
                owner => 'root',
                group => 'root',
                mode => '0755',
                source => 'puppet://puppet/files/sinatraSetup.sh',
        }

        exec { '/tmp/sinatraSetup.sh': require => File['/tmp/sinatraSetup.sh'] }
}

#setting class execution order
class setstage{
                stage { 'first': before => Stage['main'] }
                stage { 'second': require  => Stage['first'] }
                stage { 'third': require => Stage['second'] }
}

class { setstage: }
class { prereqs: stage => first }
class { installrvm: stage => first }
class { installruby: stage => second }
class { installgems: stage => third }
class { installpassenger: stage => third }
class { finalisesinatraappinstall: require => Class[installgems] }
