#!/bin/bash
# Wrintten by Andrew McDonald
# This is to be run in a Bash environment and also required sed
# This script allows for the control and checking of a Volt device's status
########### Function Declaration ########### 

function TurnOn {
echo
curl -k https://$DOMAINNAME/api/rest/device-action -X POST -H Content-type:application/xml -u $USERNAME:$PASSWORD -d '
<setVoltDataRequest xmlns="<some url>" deviceId="'$DEVICEID'" locationId="'$LOCATIONID'">
  <data>
    <mode>On</mode>
  </data>
</setVoltDataRequest>' >/dev/null 2>&1
echo
}

function TurnOff {
echo
curl -k https://$DOMAINNAME/api/rest/device-action -X POST -H Content-type:application/xml -u $USERNAME:$PASSWORD -d '
<setVoltDataRequest xmlns="<some url>" deviceId="'$DEVICEID'" locationId="'$LOCATIONID'">
  <data>
    <mode>Off</mode>
  </data>
</setVoltDataRequest>' >/dev/null 2>&1
echo
}

function GetState {
echo
STATEKEY=$(curl -s -k https://$DOMAINNAME/<some path> -X POST -H Content-type:application/xml -u $USERNAME:$PASSWORD -d '
<getVoltDataRequest xmlns="<some url>" deviceId="'$DEVICEID'" locationId="'$LOCATIONID'">
</getVoltDataRequest>' | cut -d'"' -f 20)
curl -k <some url>$STATEKEY -u $USERNAME:$PASSWORD  >/dev/null 2>&1
echo The device is $(curl -s -k <some url>$STATEKEY -u $USERNAME:$PASSWORD | xmllint --format - | grep "<mode>" | sed 's/<'"mode"'>\(.*\)<\/'"mode"'>/\1/' | sed -e 's/^[ \t]*//')
}


# the following 2 functions are for the setup of script variables
function SetupVariables {
echo
echo -n "Enter User Name: "
read USERNAME
echo -n "Enter Password: "
read PASSWORD
echo -n "Enter DomainName: "
read DOMAINNAME
echo -n "Enter Device Id: "
read DEVICEID
echo -n "Enter Location Id: "
read LOCATIONID
echo
}

function DisplaySetupVariables {
echo
echo "User Name: $USERNAME"
echo "Password: $PASSWORD"
echo "DomainName: $DOMAINNAME"
echo "Device Id: $DEVICEID"
echo "Location Id: $LOCATIONID"
echo
}

########### Start of Main Code ########### 


if [ $1 ] && [ $2 ] && [ $3 ] && [ $4 ] && [ $5 ]
then
	USERNAME=$1
	PASSWORD=$2
	DOMAINNAME=$3
	DEVICEID=$4
	LOCATIONID=$5
	DisplaySetupVariables
else
	echo 
	echo CurlTest can be started from the command prompt
	echo "use: ./CurlVolt <UserName> <Password> <DomainName> <DeviceID> <LocationID>"
	echo Alternativly please use the following prompts
	echo
	SetupVariables
fi

COUNTER=0
while [ $COUNTER -lt 10 ]; do
	echo
	echo "== Menu =="
	echo "1. Turn On"
	echo "2. Turn Off"
	echo "3. Check state"
	echo "4. Exit"
	echo "5. Display setup Variables"
        echo "6. re enter setup Variables"
	echo -n "Enter Option: "
	read option
	case $option in
        	1) TurnOn
       	        ;;
       		2) TurnOff
        	;;
       		3) GetState
        	;;
       		4) echo Exiting;
		   COUNTER=10
        	;;
       		5) DisplaySetupVariables
        	;;
       		6) SetupVariables
        	;;
        	*) echo "Invalid input"
        	        ;;
	esac
done

