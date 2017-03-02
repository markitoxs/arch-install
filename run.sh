#!/bin/bash
PS3='Select Environment: '
options=("VirtualBox" "Other")
select opt in "${options[@]}"
do
  case "$opt" in
    "VirtualBox")
      DISK=sda
      PORT=22
      HOST=192.168.1.17
      break
      ;;
    "Other")
      DISK=vda
      PORT=22
      echo -n "HOST: "
      read HOST
      break
      ;;
    *) echo Invalid;;
  esac
done
echo DISK="$DISK", PORT="$PORT", HOST="$HOST"
HOST_ROOT="root@$HOST"
PUBKEY=$(cat ~/.ssh/id_rsa.pub)
# copy your public key, so can ssh without a password later on
ssh -tt -p "$PORT" "$HOST_ROOT" "mkdir -m 700 ~/.ssh; echo $PUBKEY > ~/.ssh/authorized_keys; chmod 600 ~/.ssh/authorized_keys"
# copy install scripts from ./root folder
scp -P "$PORT" ./scripts/* "$HOST_ROOT:/root"
ssh -tt -p "$PORT" "$HOST_ROOT" "chmod +x *.sh"
#
# run the install script remotely
ssh -tt -p "$PORT" "$HOST_ROOT" "./install.sh $DISK"
