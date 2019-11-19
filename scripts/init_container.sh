#!/bin/bash
# MAINTAINER: Jose Luis Bracamonte A. <luisjba@gmail.com>
# Date Created: 2019-11-19
# Las Updated: 2019-11-19
cat >/etc/motd <<EOL
v 1.0
 _          _       _      _  _
| |_  _ _  | | _ _ <_> ___<_>| |_  ___
| . \| | | | || | || |<_-<| || . \<_> |
|___/\_  | |_| ___||_|/__/| ||___/<___|
     <___|               <__|
This docker Instance is build for run a Tronadoweb app 
with MVC libraries configured.
Python version: `python --version`
MAINTAINER: Jose Luis Bracamonte Amavizca. <luisjba@gmail.com>
-------------------------------------------------------------------------
EOL
cat /etc/motd
service rsyslog start

function pip_install_requirements(){
#install requirements from requirements.txt
    if [ -f requirements.txt ]; then
          echo "Installing requirements from file"
          pip install -r requirements.txt
    fi
    if [ -n "$PIP_INSTALL_REQUIREMENTS" ]; then
          for py_package in $PIP_INSTALL_REQUIREMENTS; do
               echo "installing python package $py_package via pip"
               pip install ${py_package}
          done
    fi
    return 0
}
# installing requirements
pip_install_requirements
service rsyslog start
$@