#!/usr/bin/env bash

install_jdks_based_on_gradle_version() {

    set -eo pipefail
    
    # Check for dpkg on Debian-based systems
    if ! command -v dpkg >/dev/null 2>&1; then
        echo "Error: dpkg is required but not installed."
        echo "This script requires a Debian/Ubuntu-based system."
        return 1
    fi

    # Verify basic GNU coreutils
    coreutils_commands=(cd dirname pwd grep cut tr curl read printf sort head)
    for cmd in "${coreutils_commands[@]}"; do
        if ! command -v "$cmd" >/dev/null 2>&1; then
            echo "Error: $cmd is required but not found"
            return 1
        fi
    done

    local DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

    # Ensure dependencies
    . "${DIR}/installJq.bash"
    . "${DIR}/installPup.bash"
    . "${DIR}/installMise.bash"

    # Main function logic
    local gradleVersion="${1:-}"
    local gradleWrapperPath="${2:-./gradle/wrapper/gradle-wrapper.properties}"

    # Validate Gradle version detection
    if [[ -z "$gradleVersion" ]]; then
        if [[ -f "$gradleWrapperPath" ]]; then
            gradleVersion=$(grep 'distributionUrl' "$gradleWrapperPath" \
                | cut -d'=' -f2 | cut -d'-' -f2 | tr -d '*')
            echo "Detected Gradle version: $gradleVersion"
        else
            echo "Error: gradle-wrapper.properties not found at $gradleWrapperPath"
            return 1
        fi
    fi

    echo "Fetching Gradle-Java compatibility information…"
    local html_content=$(curl -sf https://docs.gradle.org/current/userguide/compatibility.html)

    # Local associative arrays for compatibility data
    declare -A compile_gradle_map runtime_gradle_map
    while IFS=$'\t' read -r jdk compile runtime; do
        compile_gradle_map["$jdk"]=$compile
        runtime_gradle_map["$jdk"]=$runtime
    done < <(
        echo "$html_content" \
        | pup 'div#content div.sect1 > h2#java_runtime + div.sectionbody table.tableblock tbody tr json{}' \
        | jq -r '
            .[] |
            .children[0].children[0].text as $jdk |
            (.children[1].children[0].text | split(" ")[0] | sub("\\*";"")) as $compile |
            (.children[2].children[0].text | split(" ")[0] | sub("\\*";"") | sub("\\.$";"")) as $runtime |
            "\($jdk)\t\($compile)\t\($runtime)"
          '
    )

    # Validate parsed data
    if (( ${#compile_gradle_map[@]} == 0 )); then
        echo "ERROR: Failed to parse compatibility table"
        return 1
    fi

    # Determine compatible JDKs
    local sorted_jdks=( $(printf "%s\n" "${!compile_gradle_map[@]}" | sort -V) )
    local compile_jdk="" run_jdk=""

    for jdk in "${sorted_jdks[@]}"; do
        local cv=${compile_gradle_map[$jdk]}
        local rv=${runtime_gradle_map[$jdk]}

        if [[ "$cv" != "N/A" ]] && dpkg --compare-versions "$gradleVersion" ge "$cv"; then
            compile_jdk="$jdk"
        fi

        if [[ "$rv" != "N/A" ]] && dpkg --compare-versions "$gradleVersion" ge "$rv"; then
            run_jdk="$jdk"
        fi
    done

    echo
    echo "Java ↔ Gradle Compatibility Table:"
    for jdk in "${sorted_jdks[@]}"; do
        echo "  Java $jdk → compile w/ Gradle ${compile_gradle_map[$jdk]}, run w/ Gradle ${runtime_gradle_map[$jdk]}"
    done

    echo
    echo "For Gradle $gradleVersion:"
    echo "  • Minimum Java to compile your build: $compile_jdk"
    echo "  • Minimum Java to run Gradle itself:  $run_jdk"

    echo "Installing Java $compile_jdk and Java $run_jdk via mise…"
    mise install java@"$compile_jdk" && mise use java@"$compile_jdk"
    mise install java@"$run_jdk" && mise use java@"$run_jdk"

    echo
    echo "Check compile-JDK version directly:"
    mise exec java@"$compile_jdk" -- java --version

    echo
    echo "Check run-JDK version directly:"
    mise exec java@"$run_jdk" -- java --version
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    install_jdks_based_on_gradle_version "$@"
fi
