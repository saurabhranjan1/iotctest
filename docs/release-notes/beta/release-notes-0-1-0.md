# EnOcean IoT Connector - Beta 0.1.0 Released

### Bug

- Switched fields friendlyID and location on output.


### Features

- Cryptolens Licensing added.
- Optimize web sockets and use Secure web sockets.
- Allow users to provide a certificate \+ key for NGINX.
- Allow APs to connect using secure  web sockets.
- Receive respective sensor health data \(parsed signal telegram\) triggered by signal telegram
- Add, remove & update sensors via API.
- Add tags to onboarded sensors
- Enable activated flag for devices
- Authenticate with the API.
- Get Gateways list via the API.
- Add CT Clamp EEPs
- Query last 5 data telegrams incl. RSSI
- Get telegram statistics per Gateway / per Device.

### Container Hotfixes Version Beta 0.1.0

#### API Hotfixes

###### API - Hotfix 0.1.3

- PUT devices fixed

###### API - Hotfix 0.1.2

- Source ID forced conversion to lowercase
- Boolean correction from Redis without quotes

###### API - Hotfix 0.1.1

- REDIS save of device configuration on new device interaction

#### Engine Hotfixes

###### Engine - Bugfix 0.1.3

- Removing of deleted devices at runtime
- Additional debug messages

###### Engine - Hotfix 0.1.2

- Additional debug messages for device onboarding
- Rehashing of user certificates after update forced
- Processing empty message as hello to complete onboarding

###### Engine - Hotfix 0.1.1

- Improved licensing performance

#### Ingress Hotfixes

###### Ingress - Bugfix 0.1.3

- Rehashing of user certificates after update forced

###### Ingress - Hotfix 0.1.2

- Processing empty message as hello to complete onboarding
- Support for AOS 8.7.x.x - Client ID is optional

###### Ingress - Hotfix 0.1.1

- Improved licensing performance, retry on fail
