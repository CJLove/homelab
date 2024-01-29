#!/bin/bash
# Script to create certificate authority and/or self-signed certificate
#

function ShowUsage()
{
    cat <<EOT
$(basename "$0") --path=<path> options
    [--caCrt=<ca.crt>]
    [--caKey=<ca.key>]
    [--host=<shortHost>]
    [--full=<fullHost>]
    [--ip=<IP address>]
    [--alias=<alias>]
EOT
    return 0
}

PARAM_CA_CRT=
PARAM_CA_KEY=
PARAM_PATH=
PARAM_HOST=
PARAM_FULL=
PARAM_IP=
PARAM_ALIAS=

while test $# -gt 0; do
    param="$1"
    if test "${1::1}" = "-"; then
        if test ${#1} -gt 2 -a "${1::2}" = "--" ; then
            param="${1:2}"
        else
            param="${1:1}"
        fi
    else
        break
    fi

    shift

    case $param in
    caCrt=*)
        PARAM_CA_CRT=$(echo "$param"|cut -f2 -d'=')
        ;;
    caKey=*)
        PARAM_CA_KEY=$(echo "$param"|cut -f2 -d'=')
        ;;
    path=*)
        PARAM_PATH=$(echo "$param"|cut -f2 -d'=')
        ;;
    host=*)
        PARAM_HOST=$(echo "$param"|cut -f2 -d'=')
        ;;
    full=*)
        PARAM_FULL=$(echo "$param"|cut -f2- -d'=')
        ;;
    ip=*)
        PARAM_IP=$(echo "$param"|cut -f2- -d'=')
        ;;
    alias=*)
        PARAM_ALIAS=$(echo "$param"|cut -f2- -d'=')
        ;;
    help|h|?|-?)
        ShowUsage
        exit 0
        ;;
    *)
        echo "Error: Unknown parameter: $param"
        ShowUsage
        exit 2
        ;;    
    esac
done

echo "Creating certs in ${PARAM_PATH}/reg_certs for host ${PARAM_HOST} (${PARAM_FULL}) ip ${PARAM_IP} alias ${PARAM_ALIAS}..."

# Define where to store the generated certs and metadata.
DIR="${PARAM_PATH}"

# Optional: Ensure the target directory exists and is empty.
rm -rf "${DIR}"
mkdir -p "${DIR}"

# If not specified then we will generate a root CA
[ -z "$PARAM_CA_KEY" ] && PARAM_CA_KEY="${DIR}/ca.key"
[ -z "$PARAM_CA_CRT" ] && PARAM_CA_CRT="${DIR}/ca.crt"

# If necessary, create the certificate authority (CA). This will be a self-signed CA, 
# and this command generates both the private key and the certificate. 
if [ ! -f "${PARAM_CA_KEY}" ] || [ ! -f "${PARAM_CA_CRT}" ]; then
  echo "Generating root CA"
  openssl req \
    -new \
    -newkey rsa:2048 \
    -days 999 \
    -nodes \
    -x509 \
    -subj "/C=US/ST=CA/L=San Diego/O=Chris Love CA" \
    -keyout "${PARAM_CA_KEY}" \
    -out "${PARAM_CA_CRT}"
else
  echo "Using existing root CA"
fi

# If only generate the root CA then exit here
[ -z "${PARAM_HOST}" ] && exit 1 

# Create the openssl configuration file. This is used for both generating
# the certificate as well as for specifying the extensions. It aims in favor
# of automation, so the DN is encoding and not prompted.
cat > "${DIR}/openssl.cnf" << EOF
[req]
default_bits = 2048
encrypt_key  = des3
default_md   = sha256
prompt       = no
utf8         = yes

# Specify the DN here so we aren't prompted (along with prompt = no above).
distinguished_name = req_distinguished_name

# Extensions for SAN IP and SAN DNS
req_extensions = v3_req

# Be sure to update the subject to match your organization.
[req_distinguished_name]
C  = US
ST = CA
L  = San Diego
O  = Demo
CN = ${PARAM_FULL}

# Allow client and server auth. You may want to only allow server auth.
# Link to SAN names.
[v3_req]
basicConstraints     = CA:FALSE
subjectKeyIdentifier = hash
keyUsage             = digitalSignature, keyEncipherment
extendedKeyUsage     = clientAuth, serverAuth
subjectAltName       = @alt_names

# Alternative names are specified as IP.# and DNS.# for IP addresses and
# DNS accordingly. 
[alt_names]
IP.1  = ${PARAM_IP}
IP.2  = 127.0.0.1
DNS.1 = ${PARAM_HOST}.local
DNS.2 = ${PARAM_HOST}
DNS.3 = localhost
DNS.4 = ${PARAM_ALIAS}
EOF

#
# For each server/service you want to secure with your CA, repeat the
# following steps:
#

# Generate the private key for the service. Again, you may want to increase
# the bits to 4096.
openssl genrsa -out "${DIR}/${PARAM_HOST}.key" 2048

# Generate a CSR using the configuration and the key just generated. We will
# give this CSR to our CA to sign.
openssl req \
  -new -key "${DIR}/${PARAM_HOST}.key" \
  -out "${DIR}/${PARAM_HOST}.csr" \
  -config "${DIR}/openssl.cnf"
  
# Sign the CSR with our CA. This will generate a new certificate that is signed
# by our CA.
openssl x509 \
  -req \
  -days 999 \
  -in "${DIR}/${PARAM_HOST}.csr" \
  -CA "${PARAM_CA_CRT}" \
  -CAkey "${PARAM_CA_KEY}" \
  -CAcreateserial \
  -extensions v3_req \
  -extfile "${DIR}/openssl.cnf" \
  -out "${DIR}/${PARAM_HOST}.crt"

# (Optional) Verify the certificate.
openssl x509 -in "${DIR}/${PARAM_HOST}.crt" -noout -text
