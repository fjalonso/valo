# Vagrant LAMP & MEAN #

VALO is fully configured and ready to use development environment (LAMP & MEAN) built with VirtualBox, Vagrant & Ubuntu:

* ubuntu trusty 64
* apache2
* php5 (cURL, GD and Imagick, GeoIP, Mcrypt, Memcached, OAuth, Xdebug)
* git (with [git in bash](https://git-scm.com/book/es/v2/Git-in-Other-Environments-Git-in-Bash))
* mysql (phpmyadmin)
* [mongodb](http://docs.mongodb.org/manual/tutorial/install-mongodb-on-ubuntu)
* [composer](https://getcomposer.org/doc/00-intro.md#globally)
* [node](https://github.com/joyent/node/wiki/Installing-Node.js-via-package-manager#debian-and-ubuntu-based-linux-distributions) ([npm](https://www.npmjs.com), [forever](https://github.com/foreverjs/forever), [inspector](https://github.com/node-inspector/node-inspector), [supervisor](https://github.com/petruisfan/node-supervisor))
* [yeoman](http://yeoman.io/learning/index.html)
* [bower](http://bower.io/#install-bower)
* [gulp](https://github.com/gulpjs/gulp/blob/master/docs/getting-started.md)
* [grunt](http://gruntjs.com/getting-started)
* [sass](http://sass-lang.com/install)
* [stylus](https://learnboost.github.io/stylus/#get-styling-with-stylus)
* [angular](https://angularjs.org)
* [express](http://expressjs.com)
* vim, nmap, bmon


### Vagrant's Basic Usage ###

Inside your VALO copy's directory you can find 'data' directory. This directory
is visible (synchronized) to your virtual machine, so you can edit your project
locally with your favorite editor. VALO will never delete data from data directory,
but you should backup it.

Vagrant's basic commands (should be executed inside VALO directory):

  * $ vagrant ssh : SSH into virtual machine.
  * $ vagrant up : Start virtual machine.
  * $ vagrant halt : Halt virtual machine.
  * $ vagrant destroy : Destroy your virtual machine. Source code and content of data directory will remain unchangeable. VirtualBox machine instance will be destroyed only. You can build your machine again with 'vagrant up' command. The command is useful if you want to save disk space.
  * $ vagrant provision : Configure virtual machine after source code change.
  * $ vagrant reload : Reload virtual machine. Useful when you need to change network or synced folders settings.

[Official Vagrant site has beautiful documentation](http://docs.vagrantup.com/v2/)


### Git in Bash ###

Show information in your prompt about the current directory’s Git repository. This can be as simple or complex as you want, but there are generally a few key pieces of information that most people want, like the current branch, and the status of the working directory.

Symbols after the branch name indicate additional information about the repo state:

* \* : The branch has modifications
* $ : There are stashed changes
* = : The branch is equal with the remote branch
* < : The branch is behind the remote branch (can be fast-forwarded)
* \> : The branch is ahead of the remote branch (remote branch can be fast-forwarded)
* <> : The branch and remote branch have diverged (will need merge)
