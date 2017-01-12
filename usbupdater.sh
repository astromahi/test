#!/bin/bash
stdbuf -oL -eL udevadm monitor | while read -r line;
do
  if [[ "$line" =~ UDEV.*add.*usb.*block/.*/.*\(block\)$ ]] || [[ "$line" =~ UDEV.*add.*VMBUS.*block/.*/.*\(block\)$ ]]
  then
    parts=($line)
    p=${parts[3]}
    d=`udevadm info -p $p -q name`
    mount /dev/$d /mnt
    if [[ -d "/mnt/il-logs" ]]
    then
      echo "dumping logs to folder"
      journalctl > /mnt/il-logs/$(date -I)-journal.txt
      ip -s address > /mnt/il-logs/$(date -I)-ip.txt
      cat /proc/cpuinfo > /mnt/il-logs/$(date -I)-cpu.txt
      free -h  > /mnt/il-logs/$(date -I)-free.txt
    fi
    if [[ -e "/mnt/cloud-config.yaml" ]]
    then
      echo "updating to usb cloud-config.yaml"
      cp /mnt/cloud-config.yaml /var/lib/coreos-install/user_data
      umount /dev/$d
      systemctl reboot
    elif [[ -e "/mnt/user_data" ]]
    then
      echo "updating to usb user_data"
      cp /mnt/user_data /var/lib/coreos-install/user_data
      umount /dev/$d
      systemctl reboot
    elif [[ -e "/mnt/ilmstorage.tar" ]]
    then
      echo "extracting usb media"
      systemctl stop ilmscli-sync
      cat /mnt/ilmstorage.tar | docker exec -i ilms /bin/tar -x
      systemctl start ilmscli-sync
      echo "usb media extracted"
    fi
    umount /dev/$d
  fi
done