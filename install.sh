############################  SETUP PARAMETERS
app_name='dvim'
[ -z "$APP_PATH" ] && APP_PATH="$HOME/.dvim"
[ -z "$REPO_URI" ] && REPO_URI='https://github.com/dantame/dvim.git'
[ -z "$REPO_BRANCH" ] && REPO_BRANCH='master'
[ -z "$VUNDLE_URI" ] && VUNDLE_URI="https://github.com/gmarik/vundle.git"

############################  BASIC SETUP TOOLS
msg() {
    printf '%b\n' "$1" >&2
}

success() {
    if [ "$ret" -eq '0' ]; then
        msg "\33[32m[✔]\33[0m ${1}${2}"
    fi
}

error() {
    msg "\33[31m[✘]\33[0m ${1}${2}"
    exit 1
}

debug() {
    if [ "$debug_mode" -eq '1' ] && [ "$ret" -gt '1' ]; then
        msg "An error occurred in function \"${FUNCNAME[$i+1]}\" on line ${BASH_LINENO[$i+1]}, we're sorry for that."
    fi
}

variable_set() {
    if [ -z "$1" ]; then
        error "You must have your HOME environmental variable set to continue."
    fi
}

sync_repo() {
    local repo_path="$1"
    local repo_uri="$2"
    local repo_branch="$3"
    local repo_name="$4"

    msg "Trying to update $repo_name"

    if [ ! -e "$repo_path" ]; then
        mkdir -p "$repo_path"
        git clone -b "$repo_branch" "$repo_uri" "$repo_path"
        ret="$?"
        success "Successfully cloned $repo_name."
    else
        cd "$repo_path" && git pull origin "$repo_branch"
        ret="$?"
        success "Successfully updated $repo_name"
    fi

    debug
}

setup_vundle() {
    local system_shell="$SHELL"
    export SHELL='/bin/sh'

    vim \
        -u "$1" \
        "+set nomore" \
        "+BundleInstall!" \
        "+BundleClean" \
        "+qall"

    export SHELL="$system_shell"

    success "Now updating/installing plugins using Vundle"
    debug
}

############################ MAIN()
variable_set "$HOME"

unamestr=`uname`
if [[ "$unamestr" == 'Linux' ]]; then
    sudo apt-get install libncurses5-dev libgnome2-dev libgnomeui-dev \
                        libgtk2.0-dev libatk1.0-dev libbonoboui2-dev \
                        libcairo2-dev libx11-dev libxpm-dev libxt-dev python-dev \
                        ruby-dev git
elif [[ "$unamestr" == 'Darwin' ]]; then
    ruby -e "$(curl -fsSL https://raw.github.com/Homebrew/homebrew/go/install)"
    xcode-select --install
    brew update
    brew install git
fi



git clone https://github.com/vim/vim.git $APP_PATH/vim 

$APP_PATH/vim/configure --with-features=huge \
						--enable-rubyinterp \
						--enable-multibyte \
						--enable-luainterp \
						--prefix $APP_PATH/vim

$APP_PATH/vim/make VIMRUNTIMEDIR=$APP_PATH/.vim

ln -s /usr/local/bin/e $APP_PATH/vim/bin/vim

sync_repo       "$APP_PATH" \
                "$REPO_URI" \
                "$REPO_BRANCH" \
                "$app_name"

sync_repo       "$APP_PATH/.vim/bundle/vundle" \
                "$VUNDLE_URI" \
                "master" \
                "vundle"

setup_vundle    "$APP_PATH/.vimrc.bundles.default"

msg             "\nThanks for installing $app_name."