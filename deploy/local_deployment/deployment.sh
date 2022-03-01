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

echo "\n\n-----------------------Replacing Gateway Credentials-----------------------"
sed -i "s/  #enter new username for the AP.*/user1/g" docker-compose.yml
sed -i "s/  #enter new password for the AP.*/gkj35zkjasb5/g" docker-compose.yml

echo "\n\n-----------------------Replacing API Credentials-----------------------"
sed -i "s/BASIC_AUTH_USERNAME=   #enter new username for API.*/BASIC_AUTH_USERNAME=user1/g" docker-compose.yml
sed -i "s/BASIC_AUTH_PASSWORD=   #enter new password for API.*/BASIC_AUTH_PASSWORD=5a4sdFaedsa/g" docker-compose.yml

proxyservicecheck=`docker-compose ps -q proxy | wc -l`
if [ $proxyservicecheck -eq 0 ]; then
  echo "\n\n-----------------------Services are not up. Bringing the services up."
  docker-compose up -d
else
  echo "\n\n-----------------------All Services Are already Up. Restarting it with Latest Configs-----------------------"
  docker-compose down
  docker-compose up -d
fi

echo "\n\n-----------------------Bringing Simulation UI Up.-----------------------"

echo "\n\n-----------------------Sleeping for 1 Minute-----------------------"
sleep 1m

echo "\n\n-----------------------Replacing Docker host with Public IP Address-----------------------"
sed -i "s/host.docker.internal/$publicipaddress/g" ../simulation_ui_deployment/docker-compose.yml

echo "\n\n-----------------------Replacing Gateway Credentials-----------------------"
iotendpointusername=`grep IOT_GATEWAY_USERNAME docker-compose.yml | cut -d "=" -f2`
sed -i "s/IOT_ENDPOINT_USERNAME=us.*/IOT_ENDPOINT_USERNAME=$iotendpointusername/g" ../simulation_ui_deployment/docker-compose.yml

iotendpointpassword=`grep IOT_GATEWAY_PASSWORD docker-compose.yml | cut -d "=" -f2`
sed -i "s/IOT_ENDPOINT_PASSWORD=pa.*/IOT_ENDPOINT_PASSWORD=$iotendpointpassword/g" ../simulation_ui_deployment/docker-compose.yml

echo "\n\n-----------------------Replacing API Credentials-----------------------"
apiusername=`grep BASIC_AUTH_USERNAME docker-compose.yml | cut -d "=" -f2`
sed -i "s/IOT_API_USERNAME=us.*/IOT_API_USERNAME=$apiusername/g" ../simulation_ui_deployment/docker-compose.yml

apipassword=`grep BASIC_AUTH_PASSWORD docker-compose.yml | cut -d "=" -f2`
sed -i "s/IOT_API_PASSWORD=pa.*/IOT_API_PASSWORD=$apipassword/g" ../simulation_ui_deployment/docker-compose.yml

checkuicontainer=`docker ps | grep 3000 | wc -l`
if [ $checkuicontainer -eq 1 ]; then
  echo "\n\n-----------------------UI is already Running. Restarting it-----------------------"
  docker-compose -f ../simulation_ui_deployment/docker-compose.yml down
  docker-compose -f ../simulation_ui_deployment/docker-compose.yml up -d
else
  echo "\n\n-----------------------UI is Down. Bringing it up. -----------------------"
  docker-compose -f ../simulation_ui_deployment/docker-compose.yml up -d
fi

echo "\n\n-----------------------UI is running and can be accessed on http://$publicipaddress:3000-----------------------"
