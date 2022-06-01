#!/bin/bash

if [[ ! $BASH_SOURCE ]]; then
    echo "You cannot source this script. Run it as ./$0" >&2
    exit 33
fi

# going to compute our own local (non-exported) VIRTUALIZE_ROOT and ignore any preset one
VIRTUALIZE_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE}" )" &> /dev/null && pwd )
VIRTUALIZE_ROOT=$( dirname -- "${VIRTUALIZE_DIR}" )

for install in $VIRTUALIZE_ROOT/virtualize*/install.sh; do
    if [[ $install == "$VIRTUALIZE_ROOT/virtualize/install.sh" ]]; then
       continue
    fi
    shortname=$( dirname $install | sed 's/^virtualize-//' )
    echo "installing $shortname"
    ( $install ) >/dev/null
done

if [[ -e $VIRTUALIZE_ROOT/activate ]]; then
    echo "./activate script already exists, not installing it"
else
    ln -s virtualize/activate $VIRTUALIZE_ROOT/activate
    echo "installed ./activate file"
fi

if [[ -e $VIRTUALIZE_ROOT/install.sh ]]; then
    echo "install.sh exists, skipping making install.sh template"
else
    cat >>$VIRTUALIZE_ROOT/install.sh <<-EOF
	#!/bin/sh

	#export VIRTUALIZE_NODE_VERSION=16.13.2
	#export VIRTUALIZE_PYTHON_VERSION=3

	# install git submodules
	git submodule init
	git submodule update
	virtualize/install.sh

	### as you add virtualize modules (node, python, etc...) you will
	### probably want to edit the following sections and enable them

	### node
	# yarn install

	### python
	# pip install -f requirments.txt
EOF
    chmod +x $VIRTUALIZE_ROOT/install.sh

    echo "added install.sh template, edit it to suit your project"
fi

echo
echo "done installing virtualize"
echo "be sure to commit the new files including .gitmodules"
echo
echo "to start using virtualize:"
echo "  source ./activate"
echo "  virtualize help"

exit
