# general
ZSH_THEME="ys"
ENABLE_CORRECTION="true"
COMPLETION_WAITING_DOTS="true"
HIST_STAMPS="yyyy.mm.dd"
HOMEBREW_NO_ANALYTICS=1

export ZSH="$HOME"/.oh-my-zsh
export UPDATE_ZSH_DAYS=7
export NVM_LAZY_LOAD=true
export REPO_DIR="$(dirname $(readlink "$HOME"/.zshrc))"
export VOLTA_HOME="$HOME"/.volta

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

# functions

## update functions
update() {
    local all=false
    local mac=false
    local node=false
    local rust=false
    local php=false
    local brew=false

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
            --php | -p)
                php=true;;
            --brew | -b)
                brew=true;;
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
        npm update npm --global
        npm update --global
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
        brew upgrade --casks
        brew cleanup
        brew doctor
    fi
}

## find all the things
sf() { find "$1" -iname "$2"; }
ssf() { sudo find "$1" -iname "$2"; }

## find all the things in files
ss() { rg -F -i -p "$1" "$2"; }
sss() { sudo rg -F -i -p "$1" "$2"; }

## delete all files with this name
del() { find ~/ -name "$1" -type f -delete; }
sdel() { sudo find ~/ -name "$1" -type f -delete; }

## edit file or files with sed
ef() { find "$1" -type f -exec sed -i "" "s/$2/$3/g" {} \; }
sef() { sudo find "$1" -type f -exec sed -i "" "s/$2/$3/g" {} \; }

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

## kill a process based on the port number
kp() { kill -9 $(lsof -i :"$1" -t); }

## get all ec2 instances
ec2() {
    aws ec2 describe-instances --query 'Reservations[].Instances[].[Tags[?Key==`Name`]|[0].Value,InstanceId,InstanceType,State.Name,PublicIpAddress,PrivateIpAddress]' --output table --profile "$1";
}

## check target group health
ah() {
    for arn in "$(aws elbv2 describe-target-groups --query "TargetGroups[*].TargetGroupArn" --output text --profile $1)"
    do
        echo "$arn"
        aws elbv2 describe-target-health --target-group-arn "$arn" --query "TargetHealthDescriptions[*].[Target.Id,TargetHealth.State]";
    done
}

## hash content of the file line-by-line
hc() {
    cat "$1" | while read line
    do
        echo -n "$line" | md5 >> "$1"_hashed.csv
    done;
}

## check status on a given url and notify
cs() {
    local status_result=$(curl -I -L -s "$1" | grep 200)
    if [ -z "$status_result" ]
    then

    else
        terminal-notifier -title "Success!" -message "Click to open URL" -open "$1"
    fi
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

## java
export JAVA_HOME="/usr/local/Cellar/openjdk@8/1.8.0+282/libexec/openjdk.jdk/Contents/Home"

## ruby
export PATH="$HOME/.rbenv/shims:$PATH"

## rust
export PATH="$HOME/.cargo/bin:$PATH"

## composer
export PATH="$HOME/.composer/vendor/bin:$PATH"

## openssl
export PATH="/usr/local/opt/openssl@1.1/bin:$PATH"

## volta
export PATH="$VOLTA_HOME/bin:$PATH"
