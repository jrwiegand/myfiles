# general
ZSH_THEME="ys"
ENABLE_CORRECTION="true"
COMPLETION_WAITING_DOTS="true"
HIST_STAMPS="yyyy.mm.dd"
HOMEBREW_NO_ANALYTICS=1

export ZSH="$HOME"/.oh-my-zsh
export UPDATE_ZSH_DAYS=7
export NVM_LAZY_LOAD=true
export DOT_FILES_DIR="$(dirname $(readlink "$HOME"/.zshrc))"

plugins=(
    history-substring-search
    zsh-nvm
    zsh-navigation-tools
    zsh_reload
)

source "$ZSH"/oh-my-zsh.sh

unsetopt correct_all

# aliases

## replace vim with neovim
alias vim="nvim"

## extract the file from the tar
alias untar="tar -zxvf"

## did.txt
alias did='vim +"normal Go" +"r!date" +"put_" "$HOME"/did.txt'

## brew reinstall
alias bcr='brew cask reinstall'

# functions

## update functions
update() {
    local all=false
    local mac=false
    local node=false
    local rust=false
    local php=false
    local brew=false
    local cask=false

    while [ ! $# -eq 0 ]
    do
        case "$1" in
            --all | -a)
                all=true;;
            --mac | -m)
                mac=true;;
            --node | -n)
                node=true;;
            --rust | -r)
                rust=true;;
            --php | -r)
                php=true;;
            --brew | -b)
                brew=true;;
            --cask | -c)
                cask=true;;
        esac
        shift
    done

    if [ "$all" = true ] || [ "$mac" = true ] ; then
        echo "Updating macOS..."
        softwareupdate -i -a
    fi

    if [ "$all" = true ] || [ "$node" = true ] ; then
        echo "\nUpdating node..."
        nvm install --lts
        npm update npm -g
        npm update -g
    fi

    if [ "$all" = true ] || [ "$rust" = true ] ; then
        echo "\nUpdating rust..."
        rustup update
    fi

    if [ "$all" = true ] || [ "$php" = true ] ; then
        echo "\nUpdating composer..."
        composer global update
    fi

    if [ "$all" = true ] || [ "$brew" = true ] ; then
        echo "\nUpdating brew..."
        brew update
        brew upgrade
        brew cleanup
        brew doctor --verbose --debug
    fi

    if [ "$all" = true ] || [ "$cask" = true ] ; then
        echo "\nUpdating brew cask..."
        brew cleanup
        brew cask doctor --verbose --debug
        brew cask outdated --greedy --verbose --debug
    fi
}

## find all the things
sf() { find "$1" -iname "$2"; }
sfs() { sudo find "$1" -iname "$2"; }

## find all the things in files
ss() { rg -F -i -p "$1" "$2"; }
sss() { sudo rg -F -i -p "$1" "$2"; }

## delete all files with this name
del() { find ~/ -name "$1" -type f -delete; }
dels() { sudo find ~/ -name "$1" -type f -delete; }

## edit file or files with sed
ef() { find "$1" -type f -exec sed -i "" "s/$2/$3/g" {} \; }
efs() { sudo find "$1" -type f -exec sed -i "" "s/$2/$3/g" {} \; }

## function to update the owner of a psql database file
pdbo() {
    find "$1" -type f -exec sed -i "" "s/ Owner: $2/ Owner: $3/g" {}\;
    find "$1" -type f -exec sed -i "" "s/ $2;/$3;/g" {}\;
}

## psql function to clear the database to a usable state
pdbr() { dropdb "$1" && createdb "$1" && psql "$1" -f "$2"; }

## psql function to create a new db with the given .sql file
pdbn() { createdb "$1" && psql "$1" -f "$2"; }

## get ip information
ip() { curl https://ipinfo.io/"$1"; }

## get crypto rates
cr() { (IFS=+; curl https://rate.sx/"$*"; ); }

## get weather
cw() { ( IFS=+; curl https://wttr.in/"$*"; ); }

## kill a process based on the port number
kp() { kill -9 $(lsof -i :"$1" -t); }

## get all ec2 instances
ec2() {
    aws ec2 describe-instances --query 'Reservations[].Instances[].[Tags[?Key==`Name`]|[0].Value,InstanceId,InstanceType,State.Name,PublicIpAddress,PrivateIpAddress]' --output table;
}

## check target group health
ah() {
    for arn in "$(aws elbv2 describe-target-groups --query "TargetGroups[*].TargetGroupArn" --output text)"
    do
        echo "$arn"
        aws elbv2 describe-target-health --target-group-arn "$arn" --query "TargetHealthDescriptions[*].[Target.Id,TargetHealth.State]";
    done
}

hc() {
    cat "$1" | while read line
    do
        echo -n "$line" | md5 >> "$1"_hashed.csv
    done;
}

# exports
## default path
export PATH="/usr/local/bin:/usr/local/sbin:/usr/sbin:/usr/bin:/sbin:/bin"

## android
export ANDROID_SDK_ROOT="$HOME/Library/Android/sdk"
### avdmanager, sdkmanager
export PATH="$PATH:$ANDROID_SDK_ROOT/tools/bin"

### adb, logcat
export PATH="$PATH:$ANDROID_SDK_ROOT/platform-tools"

### emulator
export PATH="$PATH:$ANDROID_SDK_ROOT/emulator"

## ruby
export PATH="$HOME/.rbenv/shims:$PATH"

## rust
export PATH="$HOME/.cargo/bin:$PATH"

## composer
export PATH="$HOME/.composer/vendor/bin:$PATH"

## openssl
export PATH="/usr/local/opt/openssl@1.1/bin:$PATH"

