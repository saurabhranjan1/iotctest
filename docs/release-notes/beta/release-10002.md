# EnOcean IoT Connector - Beta 0.2.0 Released

## General

### Features

- New structure of the technical product documentation
- Documentation now available in HTML format
- Technical documentation is now available on: https://iotconnector-docs.readthedocs.io/
- IoTC now available on Azure Marketplace https://azuremarketplace.microsoft.com/de-de/marketplace/apps/enoceangmbh1606401683119.iotc-saas
- Automated build scripts
- Persistent storage of all configuration & runtime variables enabled. (after container restarts status is preserved))

### Bugs

- Some logging messages where using root logger instead of instance logging
- Deleted devices are removed from licensing count at runtime
- Workaround for arm/v7 platform, because it does not correctly hash ca-certificates
- Introduced Technical Documentation Versioning

## API Container

### Bugs

- UI redirect includes a slash /api.beta/v1/ui/ at the end to avoid unnecessary redirect
- Sanitized string outputs / inputs

## Engine Container

### Features

- In docker compose file IOT_ENABLE_MQTT is preferred. MQTT_LOCAL_EGRESS_ENABLE is deprecated.  IOT_MQTT_CLIENT_ID is used to set a client ID of the form IoTC:<cllient_id>. If not provided, a random one will be generated.
- Publishing Aruba Health Messages content on MQTT
- EEP D2-14-52 supported
- Added additional reports to the Container console. Reports for at startup, periodical e.g. telegram count and event triggered e.g. eep malformed
- Selected Sensor-meta events e.g. EEP malformed are forwarded to the MQTT interface

### Bugs

- Unknown EEPs handled gracefully

## Ingress Container

### Features

- Processing Aruba Health messages. Posting status into console of connected USB and AP Status.
- Change password for from IOT_ARUBA_* to  IOT_GATEWAY_**
- Support for ESP3 Packet Type 10 - required for Japan region
- Support for generic APs on ingress

### Bugs

- Support & Documentation extended for older Aruba OS Versions (8.7.x)
- Aruba APs will appear in the gateway list even without EnOcean traffic (3-5 min delay) - feature based on Aruba AP.

## MQTT Container

### Features

- MQTT Connection is keept alive and not closed after each transmission. The communication is executed in asynch.

