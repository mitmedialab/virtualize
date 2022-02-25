#!/bin/bash

if [[ -e activate ]]; then
    echo "./activate script already exists, not installing"
    exit 33
fi

ln -s virtualize/activate ./activate
echo "./activate installed"



if [[ -e install.sh ]]; then
    echo "install.sh exists, skipping making install.sh template"
    exit
fi

cat >>install.sh <<-EOF
#!/bin/sh

# install git submodules
git submodule init
git submodule update

### as you add virtualize modules (node, python, etc...) you will want to
### edit the following sections and enable them

###
### node
###

# yarn install

###
### python
###

# pip install -f requirments.txt
EOF

chmod +x 

echo "added install.sh template, edit it to suit your project"
echo
echo "done installing virtualize"
echo "be sure to commit the new files"
echo
echo "to start using virtualize:"
echo "  source ./activate"
echo "  virtualize help"

exit
