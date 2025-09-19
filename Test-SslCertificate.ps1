<#
.SYNOPSIS
    Validates an SSL certificate and its private key before installing it on the server.

.DESCRIPTION
    This interactive script checks that the `.crt` certificate and the `.key` file match,
    that the certificate is well-formed, and displays relevant information such as validity dates,
    issuer, subject, and fingerprint. It also allows verifying the chain if an intermediate certificate is included.

.NOTES
    Requires OpenSSL to be installed and accessible from PowerShell.
    > winget install ShiningLight.OpenSSL.Light
    or you can also install:
    > winget install FireDaemon.OpenSSL
    or use pwsh in a WSL session.
    Author: Manuel Trujillo Albarral
#>

function Request-FilePath($message, $filter) {
    Add-Type -AssemblyName System.Windows.Forms
    $dialog = New-Object System.Windows.Forms.OpenFileDialog
    $dialog.Title = $message
    $dialog.Filter = $filter
    if ($dialog.ShowDialog() -eq 'OK') {
        return $dialog.FileName
    } else {
        throw "Operation canceled by the user."
    }
}

try {
    Write-Host "Client SSL Certificate Validation" -ForegroundColor Cyan

    # Request files
    $crtPath = Request-FilePath "Select the client's .crt file" "Certificate (*.crt)|*.crt"
    $keyPath = Request-FilePath "Select the client's .key file" "Private key (*.key)|*.key"

    # Verify that CRT and KEY match
    Write-Host "Verifying that the certificate and key match..."
    $crtMod = & openssl x509 -noout -modulus -in $crtPath | openssl md5
    $keyMod = & openssl rsa -noout -modulus -in $keyPath | openssl md5

    if ($crtMod -eq $keyMod) {
        Write-Host "Match confirmed between certificate and key." -ForegroundColor Green
    } else {
        Write-Host "The certificate and key DO NOT match." -ForegroundColor Red
        throw "Aborting validation."
    }

    # Load certificate and display data
    Write-Host "Certificate Information:"
    $cert = New-Object System.Security.Cryptography.X509Certificates.X509Certificate2($crtPath)
    $info = [PSCustomObject]@{
        "Subject"    = $cert.Subject
        "Issuer"     = $cert.Issuer
        "Valid From" = $cert.NotBefore
        "Valid To"   = $cert.NotAfter
        "Thumbprint" = $cert.Thumbprint
    }
    $info | Format-List

    # Verify chain (optional)
    $response = Read-Host "`nDo you want to verify the chain with an intermediate certificate? (y/n)"
    if ($response -eq 'y') {
        $caPath = Request-FilePath "Select the intermediate .crt file" "Certificate (*.crt)|*.crt"
        Write-Host "`n🔗 Verifying trust chain..."
        $result = & openssl verify -CAfile $caPath $crtPath
        Write-Host $result
    }

    Write-Host "Validation completed successfully." -ForegroundColor Green

} catch {
    Write-Host "Error: $($_.Exception.Message)" -ForegroundColor Yellow
}
