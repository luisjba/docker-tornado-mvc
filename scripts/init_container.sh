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
This docker Instance is build to run a Tronado Webserver 
with MVC python framework from https://github.com/luisjba/tornado-mvc.
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
function setup_tornado_mvc(){
    local TORNADO_MVC_SRC_TARGET=${1%/}
    for py_file_src in $TORNADO_MVC_SRC_TARGET/*.py; do
        py_file=`basename $py_file_src`
        if [ ! -f $WORKDIR/$py_file ]; then 
            cp $py_file_src $WORKDIR/$py_file
        else
            echo "Custom core $py_file"
        fi
    done
    # Install default controller if not exista
    [ -d $WORKDIR/controllers ] || mkdir $WORKDIR/controllers
    for py_file_src in $TORNADO_MVC_SRC_TARGET/controllers/*; do
        py_file=`basename $py_file_src`
        if [ ! -f $WORKDIR/controllers/$py_file ]; then 
            echo "Installed controller $py_file"
            cp $py_file_src $WORKDIR/controllers/$py_file
        fi
    done
    # Install default views
    [ -d $WORKDIR/views ] || mkdir $WORKDIR/views
    for py_file_src in $TORNADO_MVC_SRC_TARGET/views/*; do
        b_name=`basename $py_file_src`
        #if is file, copy if not exists
        if [ -f $py_file_src ]; then
            if [ ! -f $WORKDIR/views/$b_name ]; then 
                cp $py_file_src $WORKDIR/views/$b_name
            fi
        else 
            [ -d $WORKDIR/views/$b_name ] || mkdir $WORKDIR/views/$b_name
            for html_file_src in $TORNADO_MVC_SRC_TARGET/views/$b_name/*.html; do 
                html_file=`basename $html_file_src`
                if [ ! -f $WORKDIR/views/$b_name/$html_file ]; then
                    echo "Installed view into $b_name/$html_file"
                    cp $html_file_src $WORKDIR/views/$b_name/$html_file
                fi   
            done
        fi
    done
    # Install the assets
    [ -d $WORKDIR/assets ] || mkdir $WORKDIR/assets
    for asset_dir_src in $TORNADO_MVC_SRC_TARGET/assets/*; do
        asset_dir=`basename $asset_dir_src`
        #if is file, copy if not exists
        if [ -d $asset_dir_src ]; then
            [ -d $WORKDIR/assets/$asset_dir ] || mkdir $WORKDIR/assets/$asset_dir
            for asset_file_src in $TORNADO_MVC_SRC_TARGET/views/$b_name/*; do 
                asset_file=`basename $asset_file_src`
                if [ ! -f $WORKDIR/assets/$asset_dir/$asset_file ]; then
                    echo "Installed asset into $asset_dir/$asset_file"
                    cp $asset_file_src $WORKDIR/assets/$asset_dir/$asset_file
                fi   
            done
        fi
    done
}
# installing requirements
pip_install_requirements
setup_tornado_mvc $TORNADO_MVC_SRC_TARGET/tornado-mvc

service rsyslog start
$@