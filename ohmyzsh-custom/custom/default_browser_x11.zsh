#!/bin/zsh
#xdg-mime default firefox.desktop x-scheme-handler/http
#xdg-mime default firefox.desktop x-scheme-handler/https

target_browser="microsoft-edge.desktop"

xdg_mime_props=(x-scheme-handler/http x-scheme-handler/https)
for i in ${xdg_mime_props[@]}; do
  if [[ "$(xdg-mime query default $i)" != "$target_browser" ]];then
    echo "Setting $i to $target_browser"
    xdg-mime default $target_browser "$i"
  fi
done

xdg_setting_props=("default-url-scheme-handler" "default-url-scheme-handler") 
xdg_url_schemes=("http" "https")
for t in ${xdg_setting_props[@]}; do
  for j in ${xdg_url_schemes[@]}; do
    if [[ "$(xdg-settings get $t $j)" != "$target_browser" ]];then
      echo "Setting $t $j to $target_browser"
      xdg-settings set $t $j "$target_browser"
    fi
  done
done

if [[ "$(xdg-settings get default-web-browser)" != "$target_browser" ]];then
  echo "Setting default-web-browser to $target_browser"
  xdg-settings set default-web-browser "$target_browser"
fi
#export BROWSER=/usr/bin/firefox
#export BROWSER=/usr/bin/microsoft-edge-stable
