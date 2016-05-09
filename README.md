## Vagrant provisioning scripts.

This project was created to gather in one place all the provisioning 
scripts I use in my projects.

Currently it includes scripts to install and configure:

- Apache
- Nginx
- PHP 5
- Memcached
- MySQL

## Prerequisites.

You need to have [VirtualBox](https://www.virtualbox.org/wiki/Downloads) and 
of course [Vagrant](https://www.vagrantup.com/downloads.html) installed.

## Configuration.

Customize `Vagrantfile` and `Vagrantconf` file and then run `vagrant up`.  

## Composer install.

{
    "require": {
        "rzajac/vagrant-prov": "0.2.*"
    }
}

After running `composer install` you must run `vendor/bin/php-vagrant-init` to 
initialize the `Vagrantfile` and `Vagrantconf` in your project root directory.

To use directory other then `project` for web server root edit line:
  
    config.vm.synced_folder "./project", "/usr/local/var/www/myproject", :owner => "vagrant"
    
in `Vagrantfile`.

## License.

Apache License, Version 2.0.

For details see LICENSE.txt file.
