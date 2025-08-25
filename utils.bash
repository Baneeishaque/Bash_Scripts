#!/bin/bash

TOOL_DIRNAME="dirname"
TOOL_TREE="tree"
TOOL_CURL="curl"
TOOL_SUDO="sudo"
TOOL_DD="dd"
TOOL_CHMOD="chmod"
TOOL_TEE="tee"
TOOL_APT="apt"
TOOL_GH="gh"
TOOL_GREP="grep"
TOOL_DPKG="dpkg"
TOOL_WHICH="which"
TOOL_UNAME="uname"
TOOL_DATE="date"
TOOL_MKDIR="mkdir"
TOOL_RM="rm"
TOOL_MV="mv"
TOOL_TOUCH="touch"
TOOL_PACMAN="pacman"
TOOL_BREW="brew"
TOOL_APT_GET="apt-get"
TOOL_DNF="dnf"
TOOL_SED="sed"
TOOL_TR="tr"
TOOL_CUT="cut"
TOOL_HEAD="head"
TOOL_TAIL="tail"
TOOL_AWK="awk"
TOOL_STAT="stat"
TOOL_MKTEMP="mktemp"
TOOL_TAR="tar"
TOOL_ZIP="zip"
TOOL_UNZIP="unzip"
TOOL_GIT="git"
TOOL_MAKE="make"
TOOL_GCC="gcc"
TOOL_GPP="g++"
TOOL_PYTHON3="python3"
TOOL_NODE="node"
TOOL_NPM="npm"
TOOL_YARN="yarn"
TOOL_RUSTC="rustc"
TOOL_CARGO="cargo"
TOOL_GO="go"
TOOL_DOCKER="docker"
TOOL_DOCKER_COMPOSE="docker-compose"
TOOL_KUBECTL="kubectl"
TOOL_HELM="helm"
TOOL_AWS="aws"
TOOL_AZ="az"
TOOL_GCLOUD="gcloud"
TOOL_TERRAFORM="terraform"
TOOL_ANSIBLE="ansible"
TOOL_VAGRANT="vagrant"
TOOL_VIRTUALBOX="virtualbox"
TOOL_SSH="ssh"
TOOL_SCP="scp"
TOOL_WGET="wget"
TOOL_SYSTEMCTL="systemctl"
TOOL_SERVICE="service"
TOOL_PS="ps"
TOOL_KILL="kill"
TOOL_NETSTAT="netstat"
TOOL_LSOF="lsof"
TOOL_IFCONFIG="ifconfig"
TOOL_IP="ip"
TOOL_PING="ping"
TOOL_TRACEROUTE="traceroute"
TOOL_NSLOOKUP="nslookup"
TOOL_DIG="dig"
TOOL_CRON="cron"
TOOL_AT="at"
TOOL_JQ="jq"
TOOL_SORT="sort"
TOOL_UNIQ="uniq"
TOOL_WC="wc"
TOOL_DIFF="diff"
TOOL_PATCH="patch"
TOOL_STRACE="strace"
TOOL_LTRACE="ltrace"
TOOL_TMUX="tmux"
TOOL_SCREEN="screen"
TOOL_HTOP="htop"
TOOL_TOP="top"
TOOL_DF="df"
TOOL_DU="du"
TOOL_FREE="free"
TOOL_UPTIME="uptime"
TOOL_WATCH="watch"

SCRIPT_INSTALL_TREE="installTree.bash"
SCRIPT_INSTALL_GH="installGitHubCli.bash"
SCRIPT_UPDATE_PACKAGE_INDEX="updatePackageIndex.bash"
SCRIPT_APT_INSTALL_HELPER="aptInstallHelper.bash"

ensure_timeout_cmd() {
    if [[ -n "${TIMEOUT_CMD:-}" ]]; then return; fi  # Already set

    OS_TYPE="$(uname -s)"
    case "$OS_TYPE" in
        Darwin)
            if command -v gtimeout >/dev/null 2>&1; then
                TIMEOUT_CMD="gtimeout"
            else
                echo "gtimeout not found. Installing with Homebrew..."
                if command -v brew >/dev/null 2>&1; then
                    brew install coreutils || { echo "Failed to install coreutils. Exiting."; exit 1; }
                    command -v gtimeout >/dev/null 2>&1 && TIMEOUT_CMD="gtimeout"
                else
                    echo "Homebrew not found. Please install Homebrew first: https://brew.sh/"
                    exit 1
                fi
            fi
            ;;
        Linux)
            if command -v timeout >/dev/null 2>&1 && timeout --version 2>&1 | grep -qi 'gnu coreutils'; then
                TIMEOUT_CMD="timeout"
            else
                echo "GNU timeout not found. Installing coreutils..."
                if command -v apt-get >/dev/null 2>&1; then
                    sudo apt-get update && sudo apt-get install -y coreutils
                elif command -v dnf >/dev/null 2>&1; then
                    sudo dnf install -y coreutils
                elif command -v pacman >/dev/null 2>&1; then
                    sudo pacman -Syu coreutils
                else
                    echo "Unknown package manager. Please install coreutils manually."
                    exit 1
                fi
                command -v timeout >/dev/null 2>&1 && timeout --version 2>&1 | grep -qi 'gnu coreutils' && TIMEOUT_CMD="timeout"
            fi
            ;;
        MINGW*|MSYS*)
            # MSYS2 has pacman, Git Bash does not
            if command -v pacman >/dev/null 2>&1; then
                if command -v timeout >/dev/null 2>&1 && timeout --version 2>&1 | grep -qi 'gnu coreutils'; then
                    TIMEOUT_CMD="timeout"
                else
                    echo "GNU timeout not found. Installing coreutils via pacman..."
                    pacman -S --noconfirm coreutils
                    command -v timeout >/dev/null 2>&1 && timeout --version 2>&1 | grep -qi 'gnu coreutils' && TIMEOUT_CMD="timeout"
                fi
            else
                echo "Git Bash detected. GNU timeout is not available. Will run commands without timeout."
                TIMEOUT_CMD=""
            fi
            ;;
        CYGWIN*)
            echo "Cygwin detected. GNU timeout is not available. Will run commands without timeout."
            TIMEOUT_CMD=""
            ;;
        *)
            echo "Unsupported OS. Please run this script on Linux, macOS, or Windows with MSYS2/Git Bash and GNU coreutils."
            exit 1
            ;;
    esac

    # If still not set, fallback to no timeout
    if [[ -z "$TIMEOUT_CMD" ]]; then
        echo "No suitable timeout command found. Will run commands without timeout."
    fi
}

run_with_timeout() {
    ensure_timeout_cmd
    if [[ -n "$TIMEOUT_CMD" ]]; then
        $TIMEOUT_CMD "$@"
    else
        # Print a warning only the first time
        if [[ -z "${_NO_TIMEOUT_WARNED:-}" ]]; then
            echo "Warning: Running without timeout. If a command hangs, you must interrupt it manually."
            _NO_TIMEOUT_WARNED=1
        fi
        # Remove the timeout argument (e.g., "10s") if present
        local first_arg="$1"
        if [[ "$first_arg" =~ ^[0-9]+[smhd]?$ ]]; then
            shift
        fi
        "$@"
    fi
}

press_enter_to_continue() {
    echo "Press Enter to continue..."
    read
}

is_installed() {

    local tool="$1"
    local custom_check="${2:-}"

    if [[ -z "$custom_check" ]]; then
        command -v "$tool" >/dev/null 2>&1
    else
        eval "$custom_check"
    fi
}

require_tool_with_installer() {

    local tool="$1"
    local installer="${2:-}"
    local is_subshell="${3:-true}"
    local custom_check="${4:-}"

    if ! is_installed "$tool" "$custom_check"; then

        if [[ -z "$installer" ]]; then
            echo "Error: Installer path for $tool is empty."
            exit 1
        fi

        if [[ ! -e "$installer" ]]; then
            echo "Error: Installer script $installer does not exist."
            exit 1
        fi

        if [[ ! -r "$installer" ]]; then
            echo "Error: Installer script $installer is not readable."
            exit 1
        fi

        if [[ ! -x "$installer" ]]; then
            echo "Error: Installer script $installer is not executable."
            exit 1
        fi

        if [[ "$is_subshell" == "true" ]]; then
            bash "$installer"
        else
            # shellcheck disable=SC1090
            source "$installer"
        fi

        if ! is_installed "$tool" "$custom_check"; then

            echo "Error: $tool is still not available after attempting install."
            exit 1
        fi
    fi
}

require_tool_with_installer_in_shell() {

    require_tool_with_installer "$1" "$2" "false" "${3:-}"
}

require_dirname()  { require_tool_with_installer "$TOOL_DIRNAME"; }

require_tree()  {

    require_dirname
    require_tool_with_installer "$TOOL_TREE" "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/$SCRIPT_INSTALL_TREE";
}

require_curl()  { require_tool_with_installer "$TOOL_CURL"; }
require_sudo()  { require_tool_with_installer "$TOOL_SUDO"; }
require_dd()    { require_tool_with_installer "$TOOL_DD"; }
require_chmod() { require_tool_with_installer "$TOOL_CHMOD"; }
require_tee()   { require_tool_with_installer "$TOOL_TEE"; }
require_apt()   { require_tool_with_installer "$TOOL_APT"; }

require_gh()    {

    require_dirname
    require_tool_with_installer "$TOOL_GH" "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/$SCRIPT_INSTALL_GH";
}

require_grep()    { require_tool_with_installer "$TOOL_GREP"; }
require_dpkg()    { require_tool_with_installer "$TOOL_DPKG"; }
require_which()   { require_tool_with_installer "$TOOL_WHICH"; }
require_uname()  { require_tool_with_installer "$TOOL_UNAME"; }
require_date()   { require_tool_with_installer "$TOOL_DATE"; }
require_mkdir()  { require_tool_with_installer "$TOOL_MKDIR"; }
require_rm()     { require_tool_with_installer "$TOOL_RM"; }
require_mv()     { require_tool_with_installer "$TOOL_MV"; }
require_touch()  { require_tool_with_installer "$TOOL_TOUCH"; }

require_arch_pacman() {

    require_tool_with_installer "$TOOL_PACMAN" "" "true" 'is_linux && command -v pacman >/dev/null 2>&1'
}

require_msys2_pacman() {

    # shellcheck disable=SC2016
    require_tool_with_installer "$TOOL_PACMAN" "" "true" '[[ "$(uname -s)" =~ MSYS|MINGW ]] && command -v pacman >/dev/null 2>&1 && [[ -f /etc/msys2.ini || -d /etc/msys2 ]]'
}

require_brew()   { require_tool_with_installer "$TOOL_BREW"; }
require_apt_get() { require_tool_with_installer "$TOOL_APT_GET"; }
require_dnf()    { require_tool_with_installer "$TOOL_DNF"; }
require_sed()    { require_tool_with_installer "$TOOL_SED"; }
require_tr()     { require_tool_with_installer "$TOOL_TR"; }
require_cut()    { require_tool_with_installer "$TOOL_CUT"; }
require_head()   { require_tool_with_installer "$TOOL_HEAD"; }
require_tail()   { require_tool_with_installer "$TOOL_TAIL"; }
require_awk()    { require_tool_with_installer "$TOOL_AWK"; }
require_stat()   { require_tool_with_installer "$TOOL_STAT"; }
require_mktemp() { require_tool_with_installer "$TOOL_MKTEMP"; }
require_tar()   { require_tool_with_installer "$TOOL_TAR"; }
require_zip()   { require_tool_with_installer "$TOOL_ZIP"; }
require_unzip() { require_tool_with_installer "$TOOL_UNZIP"; }
require_git()   { require_tool_with_installer "$TOOL_GIT"; }
require_make()  { require_tool_with_installer "$TOOL_MAKE"; }
require_gcc()   { require_tool_with_installer "$TOOL_GCC"; }
require_g++()   { require_tool_with_installer "$TOOL_GPP"; }
require_python3() { require_tool_with_installer "$TOOL_PYTHON3"; }
require_node()  { require_tool_with_installer "$TOOL_NODE"; }
require_npm()   { require_tool_with_installer "$TOOL_NPM"; }
require_yarn()  { require_tool_with_installer "$TOOL_YARN"; }
require_rustc() { require_tool_with_installer "$TOOL_RUSTC"; }
require_cargo() { require_tool_with_installer "$TOOL_CARGO"; }
require_go()    { require_tool_with_installer "$TOOL_GO"; }
require_docker() { require_tool_with_installer "$TOOL_DOCKER"; }
require_docker_compose() { require_tool_with_installer "$TOOL_DOCKER_COMPOSE"; }
require_kubectl() { require_tool_with_installer "$TOOL_KUBECTL"; }
require_helm()  { require_tool_with_installer "$TOOL_HELM"; }
require_aws()   { require_tool_with_installer "$TOOL_AWS"; }
require_az()    { require_tool_with_installer "$TOOL_AZ"; }
require_gcloud() { require_tool_with_installer "$TOOL_GCLOUD"; }
require_terraform() { require_tool_with_installer "$TOOL_TERRAFORM"; }
require_ansible() { require_tool_with_installer "$TOOL_ANSIBLE"; }
require_vagrant() { require_tool_with_installer "$TOOL_VAGRANT"; }
require_virtualbox() { require_tool_with_installer "$TOOL_VIRTUALBOX"; }
require_ssh()   { require_tool_with_installer "$TOOL_SSH"; }
require_scp()   { require_tool_with_installer "$TOOL_SCP"; }
require_wget()  { require_tool_with_installer "$TOOL_WGET"; }
require_systemctl() { require_tool_with_installer "$TOOL_SYSTEMCTL"; }
require_service() { require_tool_with_installer "$TOOL_SERVICE"; }
require_ps()    { require_tool_with_installer "$TOOL_PS"; }
require_kill()  { require_tool_with_installer "$TOOL_KILL"; }
require_netstat() { require_tool_with_installer "$TOOL_NETSTAT"; }
require_lsof()  { require_tool_with_installer "$TOOL_LSOF"; }
require_ifconfig() { require_tool_with_installer "$TOOL_IFCONFIG"; }
require_ip()    { require_tool_with_installer "$TOOL_IP"; }
require_ping()  { require_tool_with_installer "$TOOL_PING"; }
require_traceroute() { require_tool_with_installer "$TOOL_TRACEROUTE"; }
require_nslookup() { require_tool_with_installer "$TOOL_NSLOOKUP"; }
require_dig()   { require_tool_with_installer "$TOOL_DIG"; }
require_cron()  { require_tool_with_installer "$TOOL_CRON"; }
require_at()    { require_tool_with_installer "$TOOL_AT"; }
require_jq()    { require_tool_with_installer "$TOOL_JQ"; }
require_sort()  { require_tool_with_installer "$TOOL_SORT"; }
require_uniq()  { require_tool_with_installer "$TOOL_UNIQ"; }
require_wc()    { require_tool_with_installer "$TOOL_WC"; }
require_diff()  { require_tool_with_installer "$TOOL_DIFF"; }
require_patch() { require_tool_with_installer "$TOOL_PATCH"; }
require_strace() { require_tool_with_installer "$TOOL_STRACE"; }
require_ltrace() { require_tool_with_installer "$TOOL_LTRACE"; }
require_tmux()  { require_tool_with_installer "$TOOL_TMUX"; }
require_screen() { require_tool_with_installer "$TOOL_SCREEN"; }
require_htop()  { require_tool_with_installer "$TOOL_HTOP"; }
require_top()   { require_tool_with_installer "$TOOL_TOP"; }
require_df()    { require_tool_with_installer "$TOOL_DF"; }
require_du()    { require_tool_with_installer "$TOOL_DU"; }
require_free()  { require_tool_with_installer "$TOOL_FREE"; }
require_uptime() { require_tool_with_installer "$TOOL_UPTIME"; }
require_watch() { require_tool_with_installer "$TOOL_WATCH"; }

is_linux() { [[ "$(uname -s)" == "Linux" ]]; }
is_macos() { [[ "$(uname -s)" == "Darwin" ]]; }
is_windows() { [[ "$(uname -s)" =~ MINGW|MSYS|CYGWIN ]]; }

is_apt_based() { is_linux && command -v apt >/dev/null 2>&1; }
is_dnf_based() { is_linux && command -v dnf >/dev/null 2>&1; }
is_arch_pacman_based() { is_linux && command -v pacman >/dev/null 2>&1; }
is_yum_based() { is_linux && command -v yum >/dev/null 2>&1; }
is_zypper_based() { is_linux && command -v zypper >/dev/null 2>&1; }
is_nix_based() { command -v nix-env >/dev/null 2>&1; }
is_guix_based() { command -v guix >/dev/null 2>&1; }

TOOL_SNAP="snap"
TOOL_FLATPAK="flatpak"
TOOL_PIP="pip"
TOOL_PIP3="pip3"
TOOL_WINGET="winget"
TOOL_CHOCOLATEY="choco"
TOOL_SCOOP="scoop"
require_snap() { require_tool_with_installer "$TOOL_SNAP"; }
require_flatpak() { require_tool_with_installer "$TOOL_FLATPAK"; }
require_pip() { require_tool_with_installer "$TOOL_PIP"; }
require_pip3() { require_tool_with_installer "$TOOL_PIP3"; }
require_winget() { require_tool_with_installer "$TOOL_WINGET"; }
require_chocolatey() { require_tool_with_installer "$TOOL_CHOCOLATEY"; }
require_scoop() { require_tool_with_installer "$TOOL_SCOOP"; }

todo_msg() {
    echo "TODO: $1"
    exit 1
}
