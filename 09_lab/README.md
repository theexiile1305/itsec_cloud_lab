# Assignment 9: ACME Simplified Part II -- Fresh Certificates, delivered in less than 10s

Log in to the isolated VM from Assignment 7 (you may have to allow SSH access).

Use the **easy-rsa** package (https://easy-rsa.readthedocs.io/en/latest/, Ubuntu/Debian package easy-rsa) to set up a new CA (you may want to use the nokey option for the CA to avoid having to provide a password)

Receive messages from the Lambda function created in the previous assignment, and create server (or client) certificates with the Common Name set to the requested group, and deliver them to the requestor. You can either use a synchronous or an asynchronous flow.

**Bonus 1**: Set up an additional endpoint that accepts only the client certificates given out by our CA.

**Bonus 2**: Isolate the VPC by not having an internet gateway, communicating only over a service endpoint.

**Bonus 3**: Use https://github.com/nakedible/openssl-engine-kms to store the private key in KMS. (Note: It is probably sufficient if you verify that you can use the KMS key to sign, making easy-rsa use the engine might be too much work)

**Bonus 4**: Setup and use a dedicated CloudHSM instead of KMS to store the private keys. (Note: Please make sure you stop/destroy the CloudHSM, it's expensive)

## Solution
## Used resources
## Links