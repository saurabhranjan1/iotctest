# Support

For bug reports, questions or comments, please [submit an issue here](https://bitbucket.org/enocean-cloud/iotconnector-docs/issues).

Alternatively, contact [support@enocean.com](mailto:support@enocean.com)

## Debugging

A possible way of debugging and isolating connection problems can be also the use of the [simulation UI](./deploy-ui-simulation.md) as reference.

## Console log

Main debug & info messages from the IoTC can be viewed in the log of the `engine` container.

```shell
 ______        ____
|  ____|      / __ \
| |__   _ __ | |  | | ___ ___  __ _ _ __
|  __| | '_ \| |  | |/ __/ _ \/ _` | '_ \
| |____| | | | |__| | (_|  __/ (_| | | | |
|______|_| |_|\____/ \___\___|\__,_|_| |_|

 _____   _______      _____                            _
|_   _| |__   __|    / ____|                          | |
  | |  ___ | |______| |     ___  _ __  _ __   ___  ___| |_ ___  _ __
  | | / _ \| |______| |    / _ \| '_ \| '_ \ / _ \/ __| __/ _ \| '__|
 _| || (_) | |      | |___| (_) | | | | | | |  __/ (__| || (_) | |
|_____\___/|_|       \_____\___/|_| |_|_| |_|\___|\___|\__\___/|_|

...
INFO::2021-04-19 14:03:29,500::dedupper::Adding gateway with mac='1c28afc2950a' to approved list.
INFO::2021-04-19 14:03:41,505::dedupper::Adding sensor with eurid='04138bb4' to approved list.
INFO::2021-04-19 14:04:41,525::dedupper::Adding sensor with eurid='feee14ab' to approved list.
INFO::2021-04-19 14:07:47,597::dedupper::Adding sensor with eurid='0412d7ef' to approved list.
INFO::2021-04-19 14:08:05,605::dedupper::Adding sensor with eurid='0412d7c3' to approved list.
INFO::2021-04-19 14:08:32,616::dedupper::Adding sensor with eurid='0412d7ab' to approved list.
INFO::2021-04-21 08:16:54,861::dedupper::Adding gateway with mac='d015a6ce04a2' to approved list.
...
```

Other containers post messages to their console as well. To see logs:

- on Docker Desktop: open Docker Desktop -> go to Containers/Apps, find the container group e.g. `local_deployment`, click on the line of interest. e.g. `local_deploment_proxy_1`.
- on Azure Container Instances: Go to Settings -> Container. Select the container e.g. `engine` and select the `Logs` tab.

Most relevant log messages are:

- logs on start up
- logs on device communication
- licensing reports
- health information about Aruba AP
- periodic and continuos summary reports of incoming, processed and outgoing traffic of onboarded devices
- authentication of gateways

Samples of the most important messages and short description are below.

### Start up

```shell
  ERROR::...::Azure egress is enabled but connections string is not set.
  #Check your docker deployment file for any issues and redeploy the IoTC.
  ERROR::...::MQTT is enabled but MQTT_CONNECTION_STRING is empty or invalid.
  #Check your docker deployment file for any issues and redeploy the IoTC.
  ERROR::...::Could not determined host &/or port from MQTT_CONNECTION_STRING. Exiting with code 0.
  #Check your docker deployment file for any issues and redeploy the IoTC.

  INFO::...::MQTT client id not set. Using a random one.
  #The MQTT client ID can be set in the docker file but this is not mandatory.
```

### Sensor communication

```shell
INFO::...::Adding sensor with XXXXXXXX to approved list.
#A sensor communicated first time to the IoTC. Sensor is added to the approved list (license consumption).
INFO::...::Adding gateway with XXXX-XXXX-XXXX to approved list.
#A gateway is communicating first time to the IoTC. It is added to the approved list (license consumption).

ERROR::...::EEP AA-BB-CC sent by XXXXXXXX is not supported.
#The used EEP of the device is not supported and not processed. Please check if the EEP is correct (in the API). Please contact support@enocean.com for more details.
ERROR::...::EEP AA-BB-CC Parsing error id=XXXXXXXX
#The Telegram was malformed / corrupted, IoTC could not parse the telegram. Should this message repeat itself frequently contact support@enocean.com for advise.

INFO::...::Replay Exception ....
#A secured device is communicating with an already used sequence counter. Indication of a possible thread.
WARNING::...::CMAC verification failed id=XXXXXXXX
#A message from a secured device could not be authenticated.
WARNING::...::Device XXXXXXXX now unsecure. Dropping.
#A device which was onboarded as secure is not transmitting in standard mode. Possible thread.

WARNING::...::Received telegram from device: XXXXXXXX, but the device is not active. Dropping
#Messages from an onboarded device received but the `active flag` is disabled. Set the flag to active once ready.

```

### Licensing reports

Licensing reports are mainly listed in the `engine` container log, but also in the `ingress` container.

#### `engine` container log
```shell
# logs on start up

ERROR::...::License key is not set.
#The key was not set during IoTC deployment in the properties. Check the deployment file and redeploy the IoTC Containers.
WARNING::...::License key XXXXX-YYYYY-XXXXX-YYYYY is not active.
#The License was set properly but it is not active on the licensing server. Contact your sales representative.
ERROR::...::Could not contact the server.”
ERROR::...::Could not contact the server. Error message: {URLException}
ERROR::...::The signature check failed
#There seems to be a a problem with the internet connection to reach the licensing server.

# logs on first or periodic Activation

ERROR::...::Retrying activation in XXX s.
ERROR::...::Activation failed. Tried YYY times to activate.
WARNING::...::Could not activate license key:XXXXX-YYYYY-XXXXX-YYYYY.
# If this issues prevail contact support@enocean.com or your sales representative.

INFO::...:: License Key: XXXXX-YYYYY-XXXXX-YYYYY expired on ...
#Your trial or commercial license expired. It has to be renewed, the IoTC will stop to operate after the grace period. Contact your sales representative.

WARNING::...::Using grace period. Grace period expires in ...
#Your license is not valid and the IoTC runs in the grace period.
WARNING::...::Grace period expired on ...
#The grace period expired. IoTC is not functional.

# logs on license limits

WARNING::...::Package received from gateway XXXX-XXXX-XXXX outside of license allowance. Dropping.
#Your license reached its limit for allowed gateway connections. Please contact your sales representative.
WARNING::...::Sensor XXXXXXX is outside of license allowance or is not learned in. Dropping.
#Your license reached its limit for allowed sensor connections or there is no teach in information. Check if device is listed via the API. Please contact your sales representative,
```

#### `ingress` container log

```shell
# logs on start up
ERROR::...::License key is not set. Exiting ingress. #The key was not set during IoTC deployment in the properties. Check the deployment file and redeploy the IoTC Containers.

ERROR::...::License XXXXX-YYYYY-XXXXX-YYYYY activation failed.
ERROR::...::Retrying license activation in XXX s.
# If this issues prevail contact support@enocean.com or your sales representative.

INFO::...::License activation ok. # License check was OK. The ingress will start.
```

Check this [page](./deployment-notes.md#license-key) for details on the license key.

### Aruba health messages

With the Aruba OS 8.8.0.0 the manufacturer introduces [AP health information updates](https://support.hpe.com/hpesc/public/docDisplay?docId=a00113045en_us) which includes also the EnOcean USB Stick connection status.
Health update is send every 120 seconds. The IoT Connector will decode the incoming Health updates and put this information into the ingress container console output. With this messages it is easy to identify should a USB be non operational or removed during operation.

Following descriptors a included in a log message:

- `MAC` The MAC of the Aruba AP.
- `HW_DESC` The Hardware descriptor for the access point.
- `SW_VERSION` The Software version of the access point.
- `USB`
    - `ENOCEAN_USB` Hash of unique for the specific EnOcean USB Stick used.
    - `USB_HEALTH`  Health information showing the status of the USB link.

Healthy example messages are listed here:

`ingress` container

```shell
INFO::...::Aruba AP Health--> MAC=aaaaaaaaaaaa HW_DESC=AP-505 SW_VERSION=8.8.0.0 USB: ENOCEAN_USB:deb480d77718bbbe5253896b9300acfd USB_HEALTH: healthy
INFO::...::Aruba AP Health--> MAC=bbbbbbbbbbbb HW_DESC=AP-505 SW_VERSION=8.8.0.0 USB: ENOCEAN_USB:c3df093db12e57a6e121722ce042f95c USB_HEALTH: healthy
INFO::...::Aruba AP Health--> MAC=aaaaaaaaaaaa HW_DESC=AP-505 SW_VERSION=8.8.0.0 USB: ENOCEAN_USB:deb480d77718bbbe5253896b9300acfd USB_HEALTH: healthy
INFO::...::Aruba AP Health--> MAC=bbbbbbbbbbbb HW_DESC=AP-505 SW_VERSION=8.8.0.0 USB: ENOCEAN_USB:c3df093db12e57a6e121722ce042f95c USB_HEALTH: healthy
INFO::...::Aruba AP Health--> MAC=aaaaaaaaaaaa HW_DESC=AP-505 SW_VERSION=8.8.0.0 USB: ENOCEAN_USB:deb480d77718bbbe5253896b9300acfd USB_HEALTH: healthy
INFO::...::Aruba AP Health--> MAC=bbbbbbbbbbbb HW_DESC=AP-505 SW_VERSION=8.8.0.0 USB: ENOCEAN_USB:c3df093db12e57a6e121722ce042f95c USB_HEALTH: healthy
INFO::...::Aruba AP Health--> MAC=aaaaaaaaaaaa HW_DESC=AP-505 SW_VERSION=8.8.0.0 USB: ENOCEAN_USB:deb480d77718bbbe5253896b9300acfd USB_HEALTH: healthy
INFO::...::Aruba AP Health--> MAC=bbbbbbbbbbbb HW_DESC=AP-505 SW_VERSION=8.8.0.0 USB: ENOCEAN_USB:c3df093db12e57a6e121722ce042f95c USB_HEALTH: healthy
INFO::...::Aruba AP Health--> MAC=aaaaaaaaaaaa HW_DESC=AP-505 SW_VERSION=8.8.0.0 USB: ENOCEAN_USB:deb480d77718bbbe5253896b9300acfd USB_HEALTH: healthy
```
Should the EnOcean USB stick be disconnected then this message will appear:

```shell
INFO::...::Aruba Health message contains no USB info.
INFO::...::Aruba AP Health--> MAC=aaaaaaaaaaaa HW_DESC=AP-505 SW_VERSION=8.8.0.0 USB: N/A USB_HEALTH: N/A
```

### Periodic summary

A periodic summary is posted to the `engine` log to summarize the most important statistics about the operation.

```shell
INFO::...::Total processed Telegrams: 138940
INFO::...::Total learned-in devices: 15
INFO::...::Total MQTT messages: 138935
INFO::...::Total processed Telegrams: 138943
INFO::...::Total learned-in devices: 15
INFO::...::Total MQTT messages: 138938
```

The information provided:
- `Total processed Telegrams` represents the incoming telegram counter. In a common EnOcean environment this number will increase continuously, maybe not every report. The increase factor depends on the count of installed devices. A continuously increasing number is a strong signal that the ingress and collection of telegrams is operational.
- `Total learned-in devices` summarizes the count of all onboarded devices. This does not mean the devices are actively communicating.
- `Total MQTT messages` represent the outgoing telegram counter. A continuously increasing number is a strong signal that the egress interface is working correctly.

### Authentication of gateways

`ingress` container

```shell
# logs at first connect

WARNING::...::Failed to authenticate AP. Payload is not JSON.
#The AP is not compatible
WARNING::...::Incorrect credentials.
#Entered credentials on AP do not match the ones specified in the docker file during deployment. Check it.
WARNING::...::Validation Error. Could not authenticated AP.
#Validation failed, if the issue prevails check the AP for details.


#The HTTPS authentification token expires periodically. Every connected AP will need to renew the token. Following messages will periodically repeat:
INFO::...::Disconnecting client on WS handler: x.x.x.x
INFO::...::AP Authentication request from: x.x.x.x
INFO::...::Connected client on WS handler: x.x.x.x

INFO::...::Disconnecting AP with code 1008 due to invalid token.
#Token is invalid or expired. Should this message repeat check the AP for details.
```
