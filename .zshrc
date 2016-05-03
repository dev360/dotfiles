# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="dev360"

# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# Set to this to use case-sensitive completion
# CASE_SENSITIVE="true"

# Comment this out to disable weekly auto-update checks
# DISABLE_AUTO_UPDATE="true"

# Uncomment following line if you want to disable colors in ls
# DISABLE_LS_COLORS="true"

# Uncomment following line if you want to disable autosetting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment following line if you want red dots to be displayed while waiting for completion
# COMPLETION_WAITING_DOTS="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
#plugins=(git)
#compdef -d git
#

# Bash autocomplete fix
autoload bashcompinit
bashcompinit

source $ZSH/oh-my-zsh.sh

__git_files () { 
    _wanted files expl 'local files' _files     
}


# Unixy stuff
alias ls="ls -lh"
alias c="clear"
alias ss="source ~/.zshrc"

function greph() {
    history | grep "$1"
}

# To get into dirs
alias cd_d="cd ~/Downloads/"
alias cd_p="cd ~/Projects/"
alias cd_w="cd ~/Work/"
alias cd_o="cd ~/OpenSource/"

# Vim
alias clean_swp="find . -name '.*.swp' | xargs rm -f"

# Python/Django aliases
alias runserver="python manage.py runserver"
alias shell="python manage.py shell"
alias collectstatic="python manage.py collectstatic"
alias migrate_all="python manage.py migrate"
alias migrate="python manage.py migrate"
alias migration="python manage.py schemamigration"
alias worker="python manage.py celery worker -l info"

alias fab="nocorrect fab"
alias ipython="nocorrect ipython"
alias nose="nocorrect nose"

alias my_ip="curl icanhazip.com"
alias puff="git pull origin master && git push origin master"

alias clean_pyc="find . -name '*.pyc' | xargs rm -f"

# Rails stuff 
alias pow_install="curl get.pow.cx | sh"
alias pow_uninstall="curl get.pow.cx/uninstall.sh | sh"
alias rake_migrate="rake db:migrate && rake db:test:prepare"
export PATH=/Users/ctoivola/.rbenv/shims:/Users/ctoivola/.rbenv/bin:/usr/local/bin:/usr/bin:$PATH
eval "$(rbenv init -)"



# Customize to your needs...
export PATH=/Applications/Postgres.app/Contents/MacOS/bin:/usr/local/bin:/usr/local/sbin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/X11/lib


export PYTHONPATH=/usr/local/lib/python2.7/site-packages

# java
export JAVA_HOME="$(/usr/libexec/java_home)"

# Node
export NVM_DIR="/Users/ctoivola/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm

# Go
export GOPATH="$HOME/Work/go"



# EC2 Tools
export EC2_HOME="/usr/local/Cellar/ec2-api-tools/1.6.12.0/libexec"

# Added by the Heroku Toolbelt
export PATH="/usr/local/heroku/bin:$PATH"
export PATH="/usr/local/share/npm/bin:$PATH"
export CLASSPATH=/usr/share/java:$CLASSPATH
