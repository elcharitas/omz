if [ -z $ZSH ]; then
  echo "Uninstalling OhMyZSH"
  uninstall_oh_my_zsh

  ./set-up-omz.sh
 fi
