# My dotfiles

This directory contains the dotfiles for my system

## Requirements 

Ensure you have git & stow installed on your system
 
```
pacman -S git stow
```

## Installation

First, clone the dotfiles repo in your $HOME repository 

```
$ git clone git@github.com:akhilesh-w/dotfiles.git
$ cd dotfiles
```

then use stow to create symlinks 

```
$ stow .
```


