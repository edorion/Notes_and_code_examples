#!/bin/bash


if [ $1 ]

then
 ACCOUNTNUMBER=$1

else
	
echo 
	
echo To be started from the command prompt
	
echo "use: ./showUserByAccount.sh <AccountNumber>"
	
echo

fi



EMAILADDRESS=$(psql -h <ip address> -d <DB name> -U <DB user name> -c "select email_address from <table name> where id in (select <row name> from <table name> where <row name> ='$ACCOUNTNUMBER')" -t -w | sed -e 's/^[ \t]*//'i);

<some function to have string piped into> -u $EMAILADDRESS;
