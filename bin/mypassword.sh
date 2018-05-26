#!/bin/bash

mypassword_main(){
  local mypassword_length
  local mypassword_strategy

  mypassword_args "$@"
  mypassword_generate_${mypassword_strategy}
}
mypassword_args(){
  mypassword_strategy=random09azAZ

  while getopts :l:p OPT; do
    case $OPT in
      l)
        mypassword_length=$OPTARG
        ;;
      p)
        mypassword_strategy=by_passphrase
        ;;
    esac
  done
}
mypassword_generate_random09azAZ(){
  local map
  map=0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ

  </dev/urandom tr -dc "$map" | fold -w ${mypassword_length:-8} | head -1 2> /dev/null
}

mypassword_generate_by_passphrase(){
  local map
  local hash_command
  local service_key
  local stretch_count
  local stretch_count_remain
  local service_hash
  local service_hash_tip
  local service_hash_remain
  local passphrase1
  local passphrasa2
  local passphrase3
  local passphrase4
  local confirm1
  local confirm2
  local confirm3
  local confirm4
  local passphrase_limit
  local passphrase_length
  local passphrase_error
  local passphrase_collect
  local tip
  local result
  local loop_count
  local loop_confirm
  local loop_break
  map='0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ!"#$%&+*'
  passphrase_limit=27

  hash_command=sha${mypassword_length:-512}sum
  if [ -z "$(which $hash_command)" ]; then
    hash_command=shasum
    if [ -z "$(which $hash_command)" ]; then
      echo "hash command not implemented. (sha${mypassword_length:-512}sum or shasum -a ${mypassword_length:-512})"
      exit 1
    fi
    hash_command="shasum -a ${mypassword_length:-512}"
  fi
  if [ -z "$(echo 'test' | $hash_command)" ]; then
    exit 1
  fi

  echo "command: $hash_command"

  while [ -z "$passphrase_collect" ]; do
    passphrase_error=
    passphrase1=
    passphrase2=
    passphrase3=
    passphrase4=
    confirm1=
    confirm2=
    confirm3=
    confirm4=

    while [ -z "$passphrase1" ]; do
      read -sp "passphrase(1/4): " passphrase1
      echo
    done
    while [ -z "$passphrase2" ]; do
      read -sp "passphrase(2/4): " passphrase2
      echo
    done
    while [ -z "$passphrase3" ]; do
      read -sp "passphrase(3/4): " passphrase3
      echo
    done
    while [ -z "$passphrase4" ]; do
      read -sp "passphrase(4/4): " passphrase4
      echo
    done

    read -sp "confirm(1/4): " confirm1
    echo
    read -sp "confirm(2/4): " confirm2
    echo
    read -sp "confirm(3/4): " confirm3
    echo
    read -sp "confirm(4/4): " confirm4
    echo

    if [ "$passphrase1" != "$confirm1" ]; then
      passphrase_error="$passphrase_error, 1"
    fi
    if [ "$passphrase2" != "$confirm2" ]; then
      passphrase_error="$passphrase_error, 2"
    fi
    if [ "$passphrase3" != "$confirm3" ]; then
      passphrase_error="$passphrase_error, 3"
    fi
    if [ "$passphrase4" != "$confirm4" ]; then
      passphrase_error="$passphrase_error, 4"
    fi

    if [ -z "$passphrase_error" ]; then
      passphrase_length=$((${#passphrase1} + ${#passphrase2} + ${#passphrase3} + ${#passphrase4}))
      if [ $passphrase_length -gt $passphrase_limit ]; then
        echo
        echo "passphrase size too long. (limit: $passphrase_limit)"
        echo "please retry."
        echo
      else
        passphrase_collect=1
      fi
    else
      echo
      echo "passphrase word$passphrase_error is incorrect."
      echo "please retry."
      echo
    fi
  done

  while [ true ]; do
    service_key=
    stretch_count=

    while [ -z "$service_key" ]; do
      read -p "service: " service_key
    done
    read -p "stretch: " stretch_count
    stretch_count=$(($stretch_count))
    if [ $stretch_count -lt 0 ]; then
      stretch_count=0
    fi

    loop_break=
    while [ -z "$loop_break" ]; do
      loop_count=10
      while [ $loop_count -gt 0 ]; do
        result=
        service_hash=$service_key
        stretch_count_remain=$(($stretch_count + 1))
        while [ $stretch_count_remain -gt 0 ]; do
          service_hash=$(echo $service_hash | $hash_command)
          service_hash=${service_hash%% *}

          stretch_count_remain=$(($stretch_count_remain - 1))
        done

        service_hash_remain=${service_hash}

        mypassword_generate_by_passphrase_update "=" $passphrase1
        mypassword_generate_by_passphrase_update "-" $passphrase2
        mypassword_generate_by_passphrase_update "." $passphrase3
        mypassword_generate_by_passphrase_update "-" $passphrase4

        echo "password: ${result}= ($service_key:$stretch_count)"
        loop_count=$(( $loop_count - 1 ))
        stretch_count=$(( $stretch_count + 1 ))
      done

      read -p "continue? [Y/n] " loop_confirm
      if [ -z "$loop_confirm" ]; then
        loop_confirm=Y
      fi
      case $loop_confirm in
        Y*|y*)
          ;;
        *)
          loop_break=y
          ;;
      esac
    done
    echo
  done
}
mypassword_generate_by_passphrase_update(){
  local padding
  local passphrase

  padding=$1
  passphrase=$2

  result=$result$padding
  while [ "$passphrase" ]; do
    if [ -z "$service_hash_remain" ]; then
      service_hash_remain=${service_hash}
    fi
    service_hash_tip=${service_hash_remain:0:2}
    service_hash_tip=$((0x${service_hash_tip}))
    service_hash_remain=${service_hash_remain:2:${#service_hash_remain}}

    tip=${passphrase:0:1}
    tip=$(LC_CTYPE=C printf '%d' "'$tip")
    tip=$(($tip + $service_hash_tip))
    tip=$(($tip % ${#map}))

    passphrase=${passphrase:1:${#passphrase}}
    result=$result${map:$tip:1}
  done
}

mypassword_main "$@"
