#!/bin/bash

# --- MODO DE DEPURACIÓN ACTIVADO ---
# Esto imprimirá cada comando que se ejecuta para que podamos ver si falla.
set -x

# Comprueba si se han proporcionado los dos ficheros como argumentos
if [ "$#" -ne 2 ]; then
    echo "Uso: $0 <fichero.crt> <fichero.key>"
    echo "Ejemplo: $0 mi_dominio.crt mi_dominio.key"
    exit 1
fi

CERT_FILE=$1
KEY_FILE=$2

# Comprueba que los ficheros existen
if [ ! -f "$CERT_FILE" ]; then
    echo "Error: El fichero del certificado no existe: $CERT_FILE" >&2
    exit 1
fi
if [ ! -f "$KEY_FILE" ]; then
    echo "Error: El fichero de la clave privada no existe: $KEY_FILE" >&2
    exit 1
fi

echo "Verificando el par..."
echo "  - Certificado: $CERT_FILE"
echo "  - Clave:       $KEY_FILE"
echo ""

# --- CAMBIO IMPORTANTE ---
# Usamos 'openssl pkey', que es compatible con claves RSA, EC, etc.
CERT_HASH=$(openssl x509 -in "$CERT_FILE" -noout -modulus | openssl md5)
KEY_HASH=$(openssl pkey -in "$KEY_FILE" -noout -modulus | openssl md5)

# --- MODO DE DEPURACIÓN DESACTIVADO ---
set +x

# Comprobación de seguridad por si algún hash está vacío
if [ -z "$CERT_HASH" ] || [ -z "$KEY_HASH" ]; then
    echo "❌ NO COINCIDEN: No se pudo generar la huella de uno de los ficheros."
    exit 1
fi

# Compara los dos hashes
if [ "$CERT_HASH" == "$KEY_HASH" ]; then
    echo "✅ COINCIDEN: El certificado y la clave privada se corresponden."
    exit 0
else
    echo "❌ NO COINCIDEN: El certificado y la clave privada son diferentes."
    exit 1
fi
