#!/bin/bash

mypassword_main(){
  </dev/urandom tr -dc "$mypassword_characters" | head -c$mypassword_length
  echo
}
mypassword_args(){
  while getopts :l:s: OPT; do
    case $OPT in
      l)
        mypassword_length=$OPTARG
        ;;
      s)
        case $OPTARG in
          09azAZ)
            ;;
          *)
            echo "unknown strategy [$OPTARG]"
            exit 1
            ;;
        esac
        mypassword_strategy=$OPTARG
        ;;
    esac
  done

  mypassword_length=${mypassword_length:-8}
  mypassword_strategy_${mypassword_strategy:-09azAZ}
}
mypassword_strategy_09azAZ(){
  mypassword_characters=0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ
}

mypassword_args "$@"
mypassword_main
