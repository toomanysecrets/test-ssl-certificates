SSL Certificate & Key Validator for PowerShell
A simple, interactive PowerShell script to validate an SSL certificate against its private key before deployment. This tool helps prevent common server configuration errors by ensuring your certificate and key are a valid pair and providing crucial details at a glance.

Why Use This Script?
Deploying a mismatched SSL certificate and private key is a frequent cause of downtime and frustrating troubleshooting sessions. This script provides a quick, local sanity check to:

Confirm you have the correct key for your certificate.

Quickly review certificate details like expiration dates.

Verify the trust chain with an intermediate certificate.

Features
Interactive GUI File Picker: Easily select your certificate (.crt) and private key (.key) files.

Key Matching Verification: Mathematically confirms that the public key in the certificate corresponds to the provided private key by comparing their moduli.

Detailed Certificate Information: Displays essential details:

Subject (Common Name)

Issuer

Validity Period (Valid From / Valid To)

Thumbprint

Optional Chain Verification: Allows you to select an intermediate/CA certificate file to verify the trust chain using OpenSSL.

Prerequisites
PowerShell:

PowerShell 7+ (Recommended): The script is developed and tested on PowerShell 7 for its cross-platform compatibility and modern features.

Windows PowerShell 5.1: While the script is expected to work on Windows PowerShell 5.1, it is not officially tested on this version and functionality is not guaranteed.

OpenSSL:

The openssl command must be installed and available in your system's PATH.

On Windows, you can easily install it using winget:

# Choose one of the following providers
winget install ShiningLight.OpenSSL.Light
# or
winget install FireDaemon.OpenSSL


How to Use
Download the Test-SslCertificate.ps1 script to your local machine.

Open a PowerShell terminal.

Navigate to the directory where you saved the script.

Run the script:

.\Test-SslCertificate.ps1


Follow the interactive prompts:

A file dialog will open to select the certificate (.crt) file.

A second file dialog will open to select the private key (.key) file.

The script will perform the validation and display the results.

You will be asked if you want to perform an additional chain verification.

Example Output
A successful validation will look like this:

Client SSL Certificate Validation
Verifying that the certificate and key match...
Match confirmed between certificate and key.
Certificate Information:

Subject    : CN=mydomain.com
Issuer     : C=US, O=Let's Encrypt, CN=R3
Valid From : 9/15/2025 10:00:00 AM
Valid To   : 12/14/2025 10:00:00 AM
Thumbprint : A1B2C3D4E5F6A1B2C3D4E5F6A1B2C3D4E5F6A1B2

Do you want to verify the chain with an intermediate certificate? (y/n): y

🔗 Verifying trust chain...
C:\path\to\your\cert.crt: OK
Validation completed successfully.


If the certificate and key do not match, the script will abort with an error message:

Client SSL Certificate Validation
Verifying that the certificate and key match...
The certificate and key DO NOT match.
Error: Aborting validation.


License
This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.
