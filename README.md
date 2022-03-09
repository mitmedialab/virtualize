# virtualize
Tools for virtualizing your Mac development environment

Currently supported tools:
 - node
 - python
 - homebrew
 - macports

## Installing

To add virtualize to the git repo for your project:

```
git submodule add git@github.com:mitmedialab/virtualize
virtualize/install.sh
```

The install script will create an `activate` script, and an `install.sh` script. Be sure to commit these into your project, along with the added submodule:

```
git add activate install.sh
git commit -m "added virtualize"
```

## Using
The `activate` script configures your shell to use the virtualized tools. Anytime you are working in your project, be sure to activate your shell:

```
source ./activate
```

Activated shells will show their activation status in a line right above your prompt:

```
[my-awesome-project]
$
```

You can type `unactivate` to disable the activation, or you can just close your shell and open a new one.

The `install.sh` script is meant to be used as a first step after a fresh `git clone` of your project. It installs the virtualize submodule(s) and sets them up. It is a starting template file and you can modify it to do any additional setup for your project.


## Adding Tools
Now that you have `virtualize` installed, and have activated it, you can add one or more of the supported virtualize tools.

For example, here is how to add node:
```
virtualize add node
git commit -m "added virtualize-node
```

When you add a new tool, you will need to reactivate to get the new tool into your shell:
```
unactivate
source ./activate
```

## Auto Activating
Here is a handy function you can add to your `.zshrc` if you are using `zsh` (which is now the default on newer macs). It checks for `activate` scripts whenever you `cd` into a directory and automatically activates the project for you. It helps to not have to remember `source ./activate` everytime you open a new shell.
```
function chpwd() {
    if [[ ! $VIRTUALIZE_ROOT && ! $VIRTUAL_ENV && ! $check_for_activate ]]; then
	original_pwd="$PWD"
	check_for_activate="$PWD"
	while [ "$check_for_activate" != "/" ]; do
	    if [ -e "$check_for_activate/activate" ]; then
		echo "activating $check_for_activate/activate"
		cd "$check_for_activate"
		source ./activate
		cd "$original_pwd"
		break
	    fi
	    check_for_activate=`dirname "$check_for_activate"`
	done
	unset check_for_activate
	unset original_pwd
    fi
}
```
