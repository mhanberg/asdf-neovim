#!/usr/bin/env bash

case "$(uname -s)" in
  "Linux")
    platform=linux64
    ;;
  "Darwin")
    platform=macos
    ;;
esac

download_path() {
  local version=$1
  local tmp_download_dir=$2

  echo "$tmp_download_dir/neovim-${version}.tar.gz"
}

download_version() {
  local install_type=$1
  local version=$2
  local download_path=$3
  local download_url

  download_url=$(download_url "$install_type" "$version")

  rm "$download_path"

  echo "==> curl -Lo $download_path -C - $download_url"
  curl -Lo "$download_path" -C - "$download_url" || exit 1
}

download_url() {
  local install_type=$1
  local version_arg=$2
  local version
  if [[ "${version_arg}" =~ ^[0-9]+\.* ]] ; then
    version="v$2"
  else
    version="$2"
  fi

  if [ "$install_type" = "version" ]; then
    echo "https://github.com/neovim/neovim/releases/download/${version}/nvim-${platform}.tar.gz"
  else
    # otherwise it can be a branch name or commit sha
    echo "https://github.com/neovim/neovim/archive/${version}.tar.gz"
  fi

  return
}
