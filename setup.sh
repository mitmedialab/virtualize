#!/bin/bash

if [[ ! $BASH_SOURCE ]]; then
    echo "You cannot source this script. Run it as ./$0" >&2
    exit 33
fi

# going to compute our own local (non-exported) VIRTUALIZE_ROOT and ignore any preset one
VIRTUALIZE_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE}" )" &> /dev/null && pwd )
VIRTUALIZE_ROOT=$( dirname -- "${VIRTUALIZE_DIR}" )

for setup in $VIRTUALIZE_ROOT/virtualize*/setup.sh; do
    if [[ $setup == "$VIRTUALIZE_ROOT/virtualize/setup.sh" ]]; then
       continue
    fi
    shortname=$( dirname $setup | sed 's/^virtualize-//' )
    echo "installing $shortname"
    ( $setup ) >/dev/null
done

if [[ -e $VIRTUALIZE_ROOT/activate ]]; then
    echo "./activate script already exists, not installing it"
else
    ln -s virtualize/activate $VIRTUALIZE_ROOT/activate
    echo "installed ./activate file"
fi

if [[ -e $VIRTUALIZE_ROOT/setup.sh ]]; then
    echo "setup.sh exists, skipping making setup.sh template"
else
    cat >>$VIRTUALIZE_ROOT/setup.sh <<-EOF
	#!/bin/sh

	# install git submodules
	git submodule init
	git submodule update
	virtualize/setup.sh

	### as you add virtualize modules (node, python, etc...) you will
	### probably want to edit the following sections and enable them

	source ./activate

	### node
	if [[ -f package.json && -d virtualize-node ]]; then
	    yarn install
	fi   

	### python
	if [[ -f requirements.txt && -d virtualize-python ]]; then
	    pip install -f requirments.txt
	fi

	### miniconda
	if [[ -f environment.yml && -d virtualize-miniconda ]]; then
	    conda env create --file $VIRTUALIZE_ROOT/environment.yml
	fi

	### homebrew
	if [[ -f Brewfile && -d virtualize-homebrew ]]; then
	    brew bundle --file Brewfile
	fi

        ### macports
        # unknown
EOF
    chmod +x $VIRTUALIZE_ROOT/setup.sh

    echo "added initial setup.sh script, edit it to suit your project"
fi

echo
echo "done installing virtualize"
echo "be sure to commit the new files including .gitmodules"
echo
echo "to start using virtualize:"
echo "  source ./activate"
echo "  virtualize help"

exit
