# Generating self-signed certificates

!!! warning
    Self-signed certificates are inherently insecure (since they lack a chain of trust). Please contact your IT Admin if you are unsure/unaware of the consequences of generating & using self-signed certificates. These instructions should be used for development environments only.

**For Windows users**: Use the `openssl` Docker image to generate a CA, CSR and finally a certificate. **Create a dedicated folder for the process.**

**For Linux users**: Since most Linux distributions already include `openssl` there is no need to use docker for this step. Simply run the command directly by removing the initial call to docker:`docker run -it --rm -v ${PWD}:/export frapsoft/`. **Create the export directory at root to simplify the process.**

## Generate private key for CA authority:

**For Windows users:**

```bash
docker run -it --rm -v ${PWD}:/export frapsoft/openssl genrsa -des3 -out /export/myCA.key 2048
```

**For Linux users**:

```bash
$ mkdir /export
$ cd /export
$ openssl genrsa -des3 -out /export/myCA.key 2048
```

Complete the fields with the information corresponding to your organization.

## Generate root certificate

```bash
docker run -it --rm -v ${PWD}:/export frapsoft/openssl req -x509 -new -nodes -key /export/myCA.key -sha256 -days 1825 -out /export/myCA.pem
```

For common name enter the hostname of the deployment or `localhost` for local test deployments.

## Generate a key for the certificate going into the connector

```bash
docker run -it --rm -v ${PWD}:/export frapsoft/openssl genrsa -out /export/dev.localhost.key 2048
```

## Generate a CSR for the connector

```bash
docker run -it --rm -v ${PWD}:/export frapsoft/openssl req -new -key /export/dev.localhost.key -out /export/dev.localhost.csr
```

For common name enter the hostname of the deployment or `localhost` for local test deployments.

## Create the .ext file

Create a new `localhost.ext` file with the following contents:

```bash
authorityKeyIdentifier=keyid,issuer
basicConstraints=CA:FALSE
#keyUsage = digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment
subjectAltName = @alt_names
subjectKeyIdentifier = hash

[alt_names]
DNS.1 = localhost
```

Edit the `localhost.ext` file to match your domain. Make sure the `DNS.1` matches the hostname of your deployment.

## Generate a certificate from CSR for the connector

```bash
docker run -it -v ${PWD}:/export frapsoft/openssl x509 -req -in /export/dev.localhost.csr -CA /export/myCA.pem -CAkey /export/myCA.key -CAcreateserial -out /export/dev.localhost.crt  -days 825 -sha256 -extfile /export/localhost.ext
```

Keep the generated files safe and without access of 3rd parties.