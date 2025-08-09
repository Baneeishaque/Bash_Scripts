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

source "$DIR/../gradle_java_compatibility.bash"
install_jdks_based_on_gradle_version "" "fvm/versions/$user_version/examples/hello_world/android/gradle/wrapper/gradle-wrapper.properties"

. $DIR/installAndroidSdk.bash

source $DIR/../initializeFlutter.bash
initialize_flutter "$user_version"
