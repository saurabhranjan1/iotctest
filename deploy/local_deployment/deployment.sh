if [ -z "$1" ]
  then
    echo "License Key is not supplied. Exiting."
    exit 1
  else
    echo "-----------------------License Key Entered. Supplying to Compose File.-----------------------"
fi

licensekey="$1"
sed -i "s/ #enter license.*/$licensekey/g" docker-compose.yml

echo "\n\n-----------------------Passing Public IP Address in IOT_AUTH_CALLBACK variable.-----------------------"
publicipaddress=`curl --silent ifconfig.co`
sed -i "s/ #enter URL here.*/$publicipaddress:8080/g" docker-compose.yml

path="$2"
if [ -z "$2" ]
  then
    echo "\n\nPath for Localhost Cert and Key Not Provided. Exiting."
    exit 1
  else
    echo "\n\n-----------------------Path for Localhost Cert and Key Provided. Copying in NGINX folder.-----------------------"
fi

cp $path/dev.localhost.key ../nginx/
cp $path/dev.localhost.crt ../nginx/

echo "\n\n-----------------------Enabling Endpoint for IOTC-----------------------"
sed -i "s/\# - IOT_AZURE_ENABLE=1/- IOT_AZURE_ENABLE=1/g" docker-compose.yml
replace "# - IOT_AZURE_CONNSTRING=" "- IOT_AZURE_CONNSTRING=HostName=testhub.azure-devices.net;DeviceId=device;SharedAccessKey=FxyfIfddsgd4+r2/kk6d36Wkmlgsfd+Vyo8uPV8JmY5+pmM=" -- docker-compose.yml

echo "\n\n-----------------------Replacing API Credentials-----------------------"
replace "- BASIC_AUTH_USERNAME=   #enter new username for API connection of IoTC. e.g. user1" "user1" -- docker-compose.yml
replace "- BASIC_AUTH_PASSWORD=   #enter new password for API connection to IoTC. e.g. 5a4sdFa$dsa" "5a4sdFa$dsa" -- docker-compose.yml

proxyservicecheck=`docker-compose ps -q proxy | wc -l`
if [ $proxyservicecheck -eq 0 ]; then
  echo "\n\n-----------------------Services are not up. Bringing the services up."
  docker-compose up -d
  exit 0
else
  echo "\n\n-----------------------All Services Are already Up. Exiting-----------------------".
  exit 0
fi
