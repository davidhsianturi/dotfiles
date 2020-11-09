#!/bin/sh

# Color key
green=$'\e[1;32m'
yellow=$'\e[1;33m'
cyan=$'\e[1;36m'
end=$'\e[0m'

# Prep directories.
go_path="$HOME/Golang"
dotfiles="$HOME/.dotfiles"
github_dir="$HOME/Code/github.com/davidhsianturi"
gitlab_dir="$HOME/Code/gitlab.com/davidhsianturi"

printf "%s\n***** Loading davidhsianturi/dotfiles *****\n%s" $yellow $end


#-----------------------------------------------------------------------------
# Codespace directories                                                      -
#-----------------------------------------------------------------------------

printf "%s\n# Creating codespace directories...\n%s" $yellow $end

# Creating GO workspace.
printf "%s- Creating $go_path...%s"
if [[ ! -e "$go_path" ]]; then
  mkdir $go_path
  printf "%s Success!\n%s" $green $end
else
  printf "%s already created\n%s" $cyan $end
fi

# Creating Github directory.
printf "%s- Creating $github_dir...%s"
if [[ ! -e "$github_dir" ]]; then
  mkdir -p $github_dir
  printf "%s Success!\n%s" $green $end
else
  printf "%s already created\n%s" $cyan $end
fi

# Creating Gitlab directory.
printf "%s- Creating $gitlab_dir...%s"
if [[ ! -e "$gitlab_dir" ]]; then
  mkdir -p $gitlab_dir
  printf "%s Success!\n%s" $green $end
else
  printf "%s already created\n%s" $cyan $end
fi 


#-----------------------------------------------------------------------------
# Apps, packages, and dependencies                                           -
#-----------------------------------------------------------------------------

printf "%s\n# Installing apps and dependencies...\n%s" $yellow $end

# Install Hombrew and additional dependencies with bundle (See Brewfile)
printf "%s- Installing Homebrew...%s"
if [[ ! -e "/usr/local/bin/brew" ]]; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
else
  printf "%s already installed \n%s" $cyan $end
fi

printf "%s- Updating Homebrew recipes... \n%s"
brew update
printf "%s- Loading Brewfile... \n%s"
brew tap homebrew/bundle
brew bundle

# Install global Composer packages.
packages=( laravel/installer laravel/spark-installer laravel/valet tightenco/takeout )
for package in "${packages[@]}"
do
  printf "%s- Installing $package...%s"
  if [[ ! -e "$HOME/.composer/vendor/$package" ]]; then
    /usr/local/bin/composer global require $package
  else
    printf "%s already installed\n%s" $cyan $end
  fi
done


#-----------------------------------------------------------------------------
# Repositories                                                               -
#-----------------------------------------------------------------------------

printf "%s\n# Cloning repositories...\n%s" $yellow $end

cd $github_dir
github_repos=( laravel-compass davidhsianturi.com blade-bootstrap-icons mansion )
for repo in "${github_repos[@]}"
do
  printf "%s- davidhsianturi/$repo %s"
  if [[ ! -e "$github_dir/$repo" ]]; then
    git clone git@github.com:davidhsianturi/$repo.git $github_dir/$repo/
  else
    printf "%s already cloned\n%s" $cyan $end
  fi
done


#-----------------------------------------------------------------------------
# Symbolic Links                                                             -
#-----------------------------------------------------------------------------

printf "%s\n# Creating symbolic links...\n%s" $yellow $end

# Global gitignore.
printf "%s- Symlink .gitignore_global file...%s" $yellow $end
ln -s $HOME/.dotfiles/.gitignore_global $HOME/.gitignore_global
git config --global core.excludesfile $HOME/.gitignore_global
printf "%s Done!\n%s" $green $end

# .zshrc.
printf "%s- Symlink .zshrc file...%s" $yellow $end
rm -rf $HOME/.zshrc
ln -s $HOME/.dotfiles/.zshrc $HOME/.zshrc
printf "%s Done!\n%s" $green $end

# Mackup config.
printf "%s- Symlink .mackup.cfg file...%s" $yellow $end
ln -s $HOME/.dotfiles/.mackup.cfg $HOME/.mackup.cfg
printf "%s Done!\n%s" $green $end


#-----------------------------------------------------------------------------
# macOS Preferences                                                          -
#-----------------------------------------------------------------------------

printf "%s\n# Adjusting macOS...\n%s" $yellow $end
cd $dotfiles
source .macos
printf "%sDone. Note that some of these changes require a logout/restart to take effect.\n%s" $green $end

#-----------------------------------------------------------------------------
# All Done!                                                          -
#-----------------------------------------------------------------------------
printf "%s\n***** ALL DONE *****\n%s" $green $end
