#!/bin/bash -x
TORNADO_MVC_SRC_TARGET=${1%/}

if [ -z $TORNADO_MVC_SRC_TARGET ]; then
  >&2 echo "Must specify a target directory for the Tornado-MVC source checkout"
  exit 1
fi

cd "$TORNADO_MVC_SRC_TARGET" \
&& git clone https://github.com/luisjba/tornado-mvc.git \
&& cd tornado-mvc \
&& git submodule update --init --recursive \
&& pip install -r requirements.txt || exit 1

make || exit 1

# Clean up Tornado-MVC artifacts
#
echo "Cleaning Tornado-MVC artifacts"
rm -rf submodules
rm .gitignore .gitmodules requirements.txt Makefile
rm -rf .git
true