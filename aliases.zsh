# Open file.
alias zshrc="code ~/.zshrc"
alias hostfile="code /etc/hosts/"
alias sshconfig="code ~/.ssh/config"
alias sshnew="ssh-keygen -t rsa -b 4096 -C "davidhsianturi@gmail.com""

# Change directory.
alias chub="cd $HOME/Code/github.com/"
alias clab="cd $HOME/Code/gitlab.com/"
alias dotfiles="cd $DOTFILES"

# PHP.
alias p="vendor/bin/phpunit"
alias pf="p --filter "
alias pw="phpunit-watcher watch"
alias pfresh="rm -rf vendor/ composer.lock && composer i"

# Laravel.
alias art="php artisan"
alias mfs='art migrate:fresh --seed'
alias deploy='envoy run deploy'
alias deploy-code='envoy run deploy-code'

# Git.
alias commit="git add . && git commit -m"
alias first="commit first"
alias wip="commit wip"
alias nah='git reset --hard;git clean -df'
alias glog="git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"

# Composer.
composer-link() { composer config repositories.local '{"type": "path", "url": "'$1'"}' --file composer.json }
alias c="composer"
alias cu="composer update"
alias cr="composer require"
alias ci="composer install"
alias cda="composer dump-autoload"

# NPM.
alias ni="npm install"
alias nu="npm uninstall"
alias nid="ni --save-dev"
alias nrd="npm run dev"
alias nrp="npm run prod"
alias nrw="npm run watch"

# List files.
alias lf="ls -laF"
alias lsa="ls -la"
alias ll="ls -lh"

# Remove file or folder.
alias del="rm -rf"

# IP addresses.
alias ip="dig +short myip.opendns.com @resolver1.opendns.com"
alias localip="ifconfig -a | grep -o 'inet6\? \(addr:\)\?\s\?\(\(\([0-9]\+\.\)\{3\}[0-9]\+\)\|[a-fA-F0-9:]\+\)' | awk '{ sub(/inet6? (addr:)? ?/, \"\"); print }'"

# Flush Directory Service cache.
alias flushdns="sudo dscacheutil -flushcache; sudo killall -HUP mDNSResponder"

# Empty the Trash on all mounted volumes and the main HDD
# Also, clear Apple’s System Logs to improve shell startup speed
alias emptytrash="sudo rm -rfv /Volumes/*/.Trashes; sudo rm -rfv ~/.Trash; sudo rm -rfv /private/var/log/asl/*.asl"

alias cl="clear"
alias q="exit"
