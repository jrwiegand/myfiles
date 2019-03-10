#### general
ZSH_THEME="ys"
ENABLE_CORRECTION="true"
COMPLETION_WAITING_DOTS="true"
HIST_STAMPS="yyyy.mm.dd"

export ZSH=$HOME/.oh-my-zsh
export UPDATE_ZSH_DAYS=7
export NVM_LAZY_LOAD=true

plugins=(
    history-substring-search
    zsh-nvm
    zsh-navigation-tools
    zsh_reload
)

source "$ZSH"/oh-my-zsh.sh

unsetopt correct_all

#### aliases
# be very careful with this
alias destroy="rm -rf"
alias sudo-destroy="sudo rm -rf"

# copy all!
alias copy="cp -R"

# extract the file from the tar
alias untar="tar -zxvf"

# start a static python server
alias pyserv="python -m SimpleHTTPServer 7977"

# start a static node server
alias jsserv="nvm use lts/* && serve"

# update list of brew installed formula
alias update-brew-list='brew ls --versions > "$HOME"/dotfiles/brew_list.txt && brew cask ls --versions > "$HOME"/dotfiles/brew_casks_list.txt'

# install npm packages from a list
alias install-npm-packages='cat "$HOME"/dotfiles/npm_global.txt | xargs npm install --global'

# update os
alias update-os='echo "Updating macOS..." && softwareupdate -i -a'

# update pip
alias update-pip='echo "Updating pip..." && pip3 freeze --local | grep -v "^\-e" | cut -d = -f 1  | xargs -n1 pip3 install -U'

# update npm
alias update-npm='echo "Updating npm..." && npm update npm -g && npm update -g'

# update brew
alias update-brew='echo "Updating brew..." && brew update && brew upgrade && brew cleanup && brew doctor --verbose --debug'

# update brew cask
alias update-brew-cask='echo "Updating brew cask..." && brew cleanup && brew cask doctor --verbose --debug && brew cask outdated --greedy --verbose --debug'

# update all
alias update-all="update-os; update-pip; update-npm; update-brew; update-brew-cask"

# did.txt
alias did='vim +"normal Go" +"r!date" +"put_" "$HOME"/did.txt'

# android emulator
alias emulate-android="emulator -avd pixel-2-xl-27 &"

# ios simulator
alias simulate-ios="ios-sim start --devicetypeid com.apple.CoreSimulator.SimDeviceType.iPhone-X"

#### functions
# find all the things
sudo-search-for-file() { sudo find "$1" -iname "$2"; }
search-for-file() { find "$1" -iname "$2"; }

# find all the things in files
sudo-search-for-string() { sudo rg -F -i -p "$1" "$2"; }
search-for-string() { rg -F -i -p "$1" "$2"; }

# delete all files with this name
sudo-destroy-all-files() { sudo find / -name "$1" -type f -delete; }
destroy-all-files() { find ~/ -name "$1" -type f -delete; }

# change the owner of the database by replacing all the instances with sed
change-db-owner(){
    find "$1" -type f -exec sed -i "" "s/ Owner: $2/  Owner: $3/g" {} \;
    find "$1" -type f -exec sed -i "" "s/ $2;/ $3;/g" {} \;
}

# edit file or files with sed
edit-file(){ find "$1" -type f -exec sed -i "" "s/$2/$3/g" {} \; }

# edit file that requires root permission
sudo-edit-file() { sudo find "$1" -type f -exec sed -i "" "s/$2/$3/g" {} \; }

# psql function to clear the database to a usable state
reset-db() { dropdb "$1" && createdb "$1" && psql "$1" -f "$2"; }

# psql function to create a new db with the given .sql file
new-db() { createdb "$1" && psql "$1" -f "$2"; }

# get ip information
ip-info() { curl ipinfo.io/"$1"; }

# get weather updates
weather-info() { curl -s -N http://wttr.in/"$1"; }

# kill a process based on the port number
kill-from-port() { kill -9 $(lsof -i :"$1" -t); }

# download a page with a proper filename
get-web-page() {
    wget --quiet -O - "$@" \
        | paste -s -d " " \
        | sed -n -e "s!.*<head[^>]*>\(.*\)</head>.*!\1!p" \
        | sed -n -e "s!.*<title>\(.*\)</title>.*!\1!p";
}

# get all ec2 instances
get-ec2-instances() {
    aws ec2 describe-instances --query "Reservations[].Instances[].[Tags[?Key==`Name`]|[0].Value,InstanceId,InstanceType,State.Name,PublicIpAddress,PrivateIpAddress]" --output table;
}

# check target group health
check-health() {
    for arn in "$(aws elbv2 describe-target-groups --query "TargetGroups[*].TargetGroupArn" --output text)"
    do
        echo "$arn"
        aws elbv2 describe-target-health --target-group-arn "$arn" --query "TargetHealthDescriptions[*].[Target.Id,TargetHealth.State]";
    done
}

# listen to youtube video
listen-to-youtube() { mpv --no-video https://www.youtube.com/watch\?v\="$1" }

#### exports
# default path
export PATH="/usr/local/bin:/usr/local/sbin:/usr/sbin:/usr/bin:/sbin:/bin"

# android
export ANDROID_HOME="$HOME/Library/Android/sdk"
export PATH="$ANDROID_HOME/emulator:$ANDROID_HOME/tools:$PATH"

# java home
export JAVA_HOME="$(/usr/libexec/java_home -v 1.8)"
export PATH="$JAVA_HOME:$PATH"

# flutter home
export PATH="$HOME/Library/flutter/bin:$PATH"

# virtualenvwrapper
export WORKON_HOME="$HOME/.virtualenvs"
export PROJECT_HOME="$HOME/side-projects"
export VIRTUALENVWRAPPER_PYTHON="/usr/local/bin/python3"
init-pyenv() { source /usr/local/bin/virtualenvwrapper.sh }

# rbenv
init-rbenv() { eval "$(rbenv init -)" }

#openssl
export PATH="/usr/local/opt/openssl@1.1/bin:$PATH"

# homebrew
HOMEBREW_NO_ANALYTICS=1

