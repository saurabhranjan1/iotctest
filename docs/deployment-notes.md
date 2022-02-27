# Deployment Notes

## Environment Variables

### Mandatory

To deploy the IoTC certain environment variable must be specified. Mandatory paramters are listed below.

|Container | Environment Variable     | Usage                                                        |
|-|-|-|
|ingress,engine| IOT_LICENSE_KEY          | IoTC license key. Contact your EnOcean [sales](mailto:info@enocean.com) partner.
|ingress| IOT_GATEWAY_USERNAME       | Username used for the [AP authentication](./setup-aruba-ap.md#configure-aruba-ap-to-forward-data-to-the-iotc). |
|ingress| IOT_GATEWAY_PASSWORD       | Password used for [AP authentication](./setup-aruba-ap.md#configure-aruba-ap-to-forward-data-to-the-iotc). |
|ingress| IOT_AUTH_CALLBACK        | Authentication callback for APs. The `hostname of the container group instance` + `:8080`. <br />Example: `192.167.1.1:8080` or `myiotc.eastus.azurecontainer.io:8080` |
|proxy| BASIC_AUTH_USERNAME      | User name for basic authentication on the API interface.     |
|proxy| BASIC_AUTH_PASSWORD      | Password for basic authentication on the API interface.      |

### End Point connection

For endpoints either MQTT or Azure has to be selected.

|Container | Environment Variable     | Usage                                                        |
|-|-|-|
|engine | IOT_AZURE_CONNSTRING     | The *Connection String* to be use for sending data to the [Azure IoT Hub](https://docs.microsoft.com//azure/iot-hub/tutorial-connectivity). | Required if `IOT_AZURE_ENABLE` is set. |
| | IOT_AZURE_ENABLE         | This variable enables the Azure IoT Hub end-point. If this variable is set, the *IOT_AZURE_CONNSTRING* variable must also be set. <br>**If you do not wish to send data to the Azure IoT Hub, don't set this variable, simply leave it out.** |
| | MQTT_CONNSTRING          | The *Connection String* to be use for publishing data to an MQTT broker. | Required if `MQTT_LOCAL_EGRESS_ENABLE` is set. |
| | IOT_ENABLE_MQTT          | This variable enables publishing of telemetry into an MQTT broker. <br>**If you do not wish to send data to an MQTT broker, don't set this variable, simply leave it out.**
| | IOT_MQTT_CLIENT_ID       | MQTT Client ID variable used for the IoTC as client for the MQTT protocol |
| | MQTT_AUTH | Set to true and specify the basic auth parameters (`MQTT_USERNAME` & `MQTT_PASSWORD`) for MQTT connection. |
| | MQTT_USERNAME| Username used for MQTT connection. **Required if MQTT_AUTH is true**|
| | MQTT_PASSWORD| Username used for MQTT connection. **Required if MQTT_AUTH is true**|

### Reporting behavior

|Container | Environment Variable     | Usage                                                        |
|-|-|-|
|engine | GATEWAY_STATS_INTERVAL|Report interval in seconds for Gateway statistics as described [here](/#gateway-meta). When setting to 0 or not setting the variable at all, the reports are off. |
| | SENSOR_STATS_INTERVAL |Report interval in seconds for Sensor statistics as described [here](/#sensor-meta). When setting to 0 or not setting the variable at all, the reports are off.|
|||
|engine | SENSOR_TELEMETRY |Specify a custom MQTT publish path for the sensor telemetry. Default path is listed [here](/#mqtt-topics). The `ID` identifies a specific device and is represented as by `<ID>` in the custom PATH. e.g. `SENSOR_TELEMETRY="devices/telegram/<ID>` will result in a new path `devices/telegram/aabbccdd`.  |
| | SENSOR_EVENT |Specify a custom MQTT publish path for the sensor meta events. Default path is listed [here](/#mqtt-topics). The `ID` identifies a specific device and is represented as by `<ID>` in the custom PATH. e.g. `SENSOR_EVENT="devices/event/<ID>` will result in a new path `devices/event/aabbccdd`.  |
| | SENSOR_STATS |Specify a custom MQTT publish path for the sensor meta stats. Default path is listed [here](/#mqtt-topics). The `ID` identifies a specific device and is represented as by `<ID>` in the custom PATH. e.g. `SENSOR_STATS="devices/stats/<ID>` will result in a new path `devices/stats/aabbccdd`.  |
| | GATEWAY_EVENT |Specify a custom MQTT publish path for the gateway meta events. Default path is listed [here](/#mqtt-topics). The `MAC` identifies a specific gateway and is represented as by `<MAC>` in the custom PATH. e.g. `GATEWAY_EVENT="ap/event/<MAC>` will result in a new path `ap/event/aabbccddeeff`.  |
| | GATEWAY_STATS |Specify a custom MQTT publish path for the gateway meta events. Default path is listed [here](/#mqtt-topics). The `MAC` identifies a specific gateway and is represented as by `<MAC>` in the custom PATH. e.g. `GATEWAY_STATS="ap/stats/<MAC>` will result in a new path `ap/stats/aabbccddeeff`.  |

## Overview of required Secrets

| Secret                   | Usage
| ------------------------ | -----------------------------------------------------------
| secret-proxy-certificate | Certificate for the NGINX proxy to protect IoTC interfaces.
| secret-proxy-key         | Private key of the certificate for the NGINX proxy.

## Ports

The following ports are used:

| Service                    | Description                                                  | Port                                         |
| -------------------------- | ------------------------------------------------------------ | -------------------------------------------- |
| Management API             | Used to commission EnOcean devices into the IoTC. A Swagger UI is available on the root. Supported protocols: `https` | 443 (requests on port 80 will be redirected) |
| WebSocket Ingress          | WebSocket end-point for IoTC compatible gateways. Supported protocols: `wss` | 8080                                         |
| MQTT (Optional deployment) | Mosquitto MQTT broker. Supported protocols: `mqtt`           | 1883                                         |

!!! note
    Should different ports mapping be needed please contact [EnOcean support](mailto:support@enocean.com) for detailed instructions.

## License key

To deploy the IoTC a license key is required. You can get a license from the [product page](https://iot.enocean.com#trial-version) or please use the [contact form](https://iot.enocean.com/).

Each license is specified for a defined usage. The usage is defined by a maximum number of sensor/gateways which will be processed by the IoTC. If the consumption is reached additional sensors or gateways will be dropped at processing.

You can see the allowed usage of each of your licenses after you log in to the [licensing portal](https://app.cryptolens.io/Account/Login). After EnOcean has assigned a license you will receive an invitation e-mail.

Log information about the license status and consumption limit is posted to the [console](./support.md#console-log-messages).

### License activation

There is a license activation limit. If you deploy the IoTC several times within a very short period (e.g. during testing, debugging), you might experience license activation failed. Please wait for couple of minutes and try again.

The IoT Connector has to communicate with our licensing server periodically to reactivate the license. If the IoT Connector can not successfully activate the license the IoT Connector will cease to process incoming traffic after a defined grace period. The grace period is only valid if the IoT Connector could validate the license at least once. Details are include in the [Licensing Agreement](./index.md#license-agreement-and-data-privacy).
