#!/usr/bin/env bash

# place proper values into conf files

#Variables
SurDir=./suricata
suricataConf=${SurDir}/suricata.yaml
source .env
MYINTERFACE=$(route | grep default | awk '{ print $8 }')

#Fonctions
setupSuricata(){
  echo "setupSuricata: start: changing file ${suricataConf}.tpl => ${suricataConf}"
  echo "setupSuricata: changing MYHOMENET =>${MYHOMENET}"
  sed "s#MYHOMENET#${MYHOMENET}#g" ${suricataConf2}.tpl > ${suricataConf2}
  echo "setupSuricata: changing MYINTERFACE =>${MYINTERFACE}"
  sed -i "s/MYINTERFACE/${MYINTERFACE}/g" ${suricataConf2}
  echo "setupSuricata: end"
}

#Main
setupSuricata
mkdir -p ./logs/suricata ./logs/es01

sudo sh -c "ip link set ${MYINTERFACE} multicast off; ip link set ${MYINTERFACE} promisc on; ip link set ${MYINTERFACE} up "