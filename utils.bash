# utils.bash

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