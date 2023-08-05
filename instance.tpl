#!/bin/sh

set -e

sudo yum update -y

sudo vgchange -ay

if [ "`blkid -o value -s TYPE ${device}`" == "" ]; then
  sudo pvcreate ${device}
  sudo vgcreate ${vg} ${device}
  sudo lvcreate --name ${lv} -l 100%FREE ${vg}
  sudo mkfs.xfs /dev/${vg}/${lv}
fi

sudo mkdir -p ${data_path}
sudo echo "/dev/${vg}/${lv} ${data_path} xfs defaults 0 0" | sudo tee -a /etc/fstab > /dev/null
sudo mount /dev/${vg}/${lv} ${data_path}
echo "Instance Started"
