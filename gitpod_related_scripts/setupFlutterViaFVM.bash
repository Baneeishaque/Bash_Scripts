#!/bin/bash

SOURCE=${BASH_SOURCE[0]}
while [ -L "$SOURCE" ]; do
  DIR=$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )
  SOURCE=$(readlink "$SOURCE")
  [[ $SOURCE != /* ]] && SOURCE=$DIR/$SOURCE
done
DIR=$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )

. $DIR/../installJq.bash

os=$(uname -s | tr '[:upper:]' '[:lower:]')
if [[ "$os" == "darwin" ]]; then
    json_url="https://storage.googleapis.com/flutter_infra_release/releases/releases_macos.json"
else
    json_url="https://storage.googleapis.com/flutter_infra_release/releases/releases_linux.json"
fi

json_data=$(curl -s "$json_url")
valid_versions=$(echo "$json_data" | jq -r '.releases[].version')

user_version=${1:-master}
if [[ "$user_version" != "master" ]] && ! grep -qx "$user_version" <<<"$valid_versions"; then
    echo "Error: '$user_version' is not a valid Flutter version."
    echo "Valid versions:"
    echo "$valid_versions" | tr ' ' '\n'
    exit 1
fi

. $DIR/../installFVM.bash

sudo apt install -y curl git unzip xz-utils zip libglu1-mesa

cd /workspace
if [ -d "fvm/versions/$user_version" ]; then
    cd "fvm/versions/$user_version" && git pull
    cd /workspace
else
    fvm install "$user_version"
fi

gradleVersion=$(grep 'distributionUrl' \
  "fvm/versions/$user_version/examples/hello_world/android/gradle/wrapper/gradle-wrapper.properties" \
  | cut -d'=' -f2 | cut -d'-' -f2 | tr -d '*')
echo "Gradle Version: $gradleVersion"

echo "Fetching Gradle-Java compatibility information…"
html_content=$(curl -s https://docs.gradle.org/current/userguide/compatibility.html)

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
        # take only the first token, strip "*" or trailing "."
        (.children[1].children[0].text
           | split(" ")[0]
           | sub("\\*";""))                as $compile |
        (.children[2].children[0].text
           | split(" ")[0]
           | sub("\\*";"")
           | sub("\\.$";""))               as $runtime |
        "\($jdk)\t\($compile)\t\($runtime)"
      '
)

if (( ${#compile_gradle_map[@]} == 0 )); then
  echo "ERROR: Could not parse Java-Gradle table!"
  exit 1
fi

sorted_jdks=( $(printf "%s\n" "${!compile_gradle_map[@]}" | sort -V) )

compile_jdk=""
run_jdk=""
for jdk in "${sorted_jdks[@]}"; do
  cv=${compile_gradle_map[$jdk]}
  rv=${runtime_gradle_map[$jdk]}

  if [[ "$cv" != "N/A" ]] \
    && dpkg --compare-versions "$gradleVersion" ge "$cv"; then
    compile_jdk="$jdk"
  fi

  if [[ "$rv" != "N/A" ]] \
    && dpkg --compare-versions "$gradleVersion" ge "$rv"; then
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

. $DIR/../installMise.bash

echo "Installing Java $compile_jdk and Java $run_jdk via mise…"
mise install java@"$compile_jdk"
mise install java@"$run_jdk"

echo
echo "Check compile-JDK version directly:"
mise exec java@"$compile_jdk" -- java --version

echo
echo "Check run-JDK version directly:"
mise exec java@"$run_jdk" -- java --version

. $DIR/installAndroidSdk.bash

. $DIR/../initializeFlutter.bash "$user_version"