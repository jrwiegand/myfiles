#### general
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

#### aliases
# be very careful with this
alias destroy="rm -rf"
alias sudo_destroy="sudo rm -rf"

# replace vim with neovim
alias vim="nvim"

# copy all!
alias copy="cp -R"

# extract the file from the tar
alias untar="tar -zxvf"

# start a static python server
alias pyserv="python -m SimpleHTTPServer 7977"

# start a static node server
alias jsserv="serve"

# update list of brew installed formula
alias update_brew_list='brew ls --versions > "$DOT_FILES_DIR"/brew.txt && brew cask ls --versions > "$DOT_FILES_DIR"/brew-casks.txt'

# install npm packages from a list
alias install_npm_packages='cat "$DOT_FILES_DIR"/npm.txt | xargs npm install --global'

# did.txt
alias did='vim +"normal Go" +"r!date" +"put_" "$HOME"/did.txt'

#### functions
# update functions
update() {
    while [ ! $# -eq 0 ]
    do
        case "$1" in
            --all | -a)
                local all=true;;
            --mac | -m)
                local mac=true;;
            --npm | -n)
                local npm=true;;
            --rust | -r)
                local rust=true;;
            --brew | -b)
                local brew=true;;
            --cask | -c)
                local cask=true;;
        esac
        shift
    done

    if [[ ! -z ${all+x} ]] || [[ ! -z ${mac+x} ]]; then
        echo "Updating macOS..."
        softwareupdate -i -a
    fi

    if [[ ! -z ${all+x} ]] || [[ ! -z ${npm+x} ]]; then
        echo "Updating npm..."
        npm update npm -g
        npm update -g
    fi

    if [[ ! -z ${all+x} ]] || [[ ! -z ${rust+x} ]]; then
        echo "Updating rust..."
        rustup update
    fi

    if [[ ! -z ${all+x} ]] || [[ ! -z ${brew+x} ]]; then
        echo "Updating brew..."
        brew update
        brew upgrade
        brew cleanup
        brew doctor --verbose --debug
    fi

    if [[ ! -z ${all+x} ]] || [[ ! -z ${cask+x} ]]; then
        echo "Updating brew cask..."
        brew cleanup
        brew cask doctor --verbose --debug
        brew cask outdated --greedy --verbose --debug
    fi
}

# find all the things
sudo_search_for_file() { sudo find "$1" -iname "$2"; }
search_for_file() { find "$1" -iname "$2"; }

# find all the things in files
sudo_search_for_string() { sudo rg -F -i -p "$1" "$2"; }
search_for_string() { rg -F -i -p "$1" "$2"; }

# delete all files with this name
sudo_destroy_all_files() { sudo find / -name "$1" -type f -delete; }
destroy_all_files() { find ~/ -name "$1" -type f -delete; }

# change the owner of the database by replacing all the instances with sed
change_db_owner(){
    find "$1" -type f -exec sed -i "" "s/ Owner: $2/  Owner: $3/g" {} \;
    find "$1" -type f -exec sed -i "" "s/ $2;/ $3;/g" {} \;
}

# edit file or files with sed
edit_file(){ find "$1" -type f -exec sed -i "" "s/$2/$3/g" {} \; }

# edit file that requires root permission
sudo_edit_file() { sudo find "$1" -type f -exec sed -i "" "s/$2/$3/g" {} \; }

# psql function to clear the database to a usable state
reset_db() { dropdb "$1" && createdb "$1" && psql "$1" -f "$2"; }

# psql function to create a new db with the given .sql file
new_db() { createdb "$1" && psql "$1" -f "$2"; }

# get ip information
get_ip_info() { curl ipinfo.io/"$1"; }

# get weather updates
get_weather() { curl -s -N http://wttr.in/"$1"; }

# kill a process based on the port number
kill_from_port() { kill -9 $(lsof -i :"$1" -t); }

# get all ec2 instances
get_ec2_instances() {
    aws ec2 describe-instances --query 'Reservations[].Instances[].[Tags[?Key==`Name`]|[0].Value,InstanceId,InstanceType,State.Name,PublicIpAddress,PrivateIpAddress]' --output table;
}

# check target group health
check_health() {
    for arn in "$(aws elbv2 describe-target-groups --query "TargetGroups[*].TargetGroupArn" --output text)"
    do
        echo "$arn"
        aws elbv2 describe-target-health --target-group-arn "$arn" --query "TargetHealthDescriptions[*].[Target.Id,TargetHealth.State]";
    done
}

#### exports
# default path
export PATH="/usr/local/bin:/usr/local/sbin:/usr/sbin:/usr/bin:/sbin:/bin"

# android
export ANDROID_SDK_ROOT="$HOME/Library/Android/sdk"
# avdmanager, sdkmanager
export PATH="$PATH:$ANDROID_SDK_ROOT/tools/bin"

# adb, logcat
export PATH="$PATH:$ANDROID_SDK_ROOT/platform-tools"

# emulator
export PATH="$PATH:$ANDROID_SDK_ROOT/emulator"

# ruby
export PATH="$HOME/.rbenv/shims:$PATH"

# rust
export PATH="$HOME/.cargo/bin:$PATH"

#composer
export PATH="$HOME/.composer/vendor/bin:$PATH"

# openssl
export PATH="/usr/local/opt/openssl@1.1/bin:$PATH"
