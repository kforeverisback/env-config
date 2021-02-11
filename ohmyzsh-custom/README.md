# Oh-my-zsh Custom

This is a collection of useful custom aliases and functions on top of [OhMyZsh's](https://github.com/ohmyzsh/ohmyzsh).

## Installation

### Method 1

After cloning this repo simply copy/link some files to custom folder:

```bash

# This assumes that you have ohmyzsh installed
# git clone git@github.com:kforeverisback/env-config.git
# Assuming you've cloned in $HOME

cp $HOME/env-config/ohmyzsh-custom/custom/* ~/.oh-my-zsh/custom/

```

### Method 2

After cloning this repo simple soft linking would do:

```bash

# This assumes that you have ohmyzsh installed
# git clone git@github.com:kforeverisback/env-config.git
# Assuming you've cloned in $HOME

mv ~/.oh-my-zsh/{custom,custom_bak}
ln -s $HOME/env-config/ohmyzsh-custom/custom ~/.oh-my-zsh/custom

mv ~/.oh-my-zsh/custom_bak/{plugins,themes} $HOME/env-config/ohmyzsh-custom/custom/

```
