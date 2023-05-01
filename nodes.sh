#!/bin/bash
# fonts color
red(){
    echo -e "\033[31m\033[01m$1\033[0m"
}
green(){
    echo -e "\033[32m\033[01m$1\033[0m"
}
yellow(){
    echo -e "\033[33m\033[01m$1\033[0m"
}
blue(){
    echo -e "\033[34m\033[01m$1\033[0m"
}
bold(){
    echo -e "\033[1m\033[01m$1\033[0m"
}



function showHeaderGreen(){
    echo
    green " =================================================="

    for parameter in "$@"
    do
        if [[ -n "${parameter}" ]]; then
            green " ${parameter}"
        fi
    done

    green " =================================================="
    echo
}
function showHeaderRed(){
    echo
    red " =================================================="
    for parameter in "$@"
    do
        if [[ -n "${parameter}" ]]; then
            red " ${parameter}"
        fi
    done
    red " =================================================="
    echo
}
function showInfoGreen(){
    echo
    for parameter in "$@"
    do
        if [[ -n "${parameter}" ]]; then
            green " ${parameter}"
        fi
    done
    echo
}

PROJ_ROOT="${HOME}/${APP_NAME:-"proxy"}"
ACME_ROOT="${PROJ_ROOT}/acme"
BACKUP_ROOT="${PROJ_ROOT}/backup"
TRAEFIK_ROOT="${PROJ_ROOT}/etc/traefik"
XRAYR_ROOT="${PROJ_ROOT}/etc/XrayR"
NGINX_ROOT="${PROJ_ROOT}/etc/nginx"
COMPOSE_ROOT="${PROJ_ROOT}/compose"
ENV_FILE=${COMPOSE_ROOT}/.env

function makeDirIfNotExist() {
    if [ -d "$1" ]; then
      echo "Directory $1 exist."
    else
        mkdir -p $1
    fi
}

function makePanelDir() {
    makeDirIfNotExist "${PROJ_ROOT}/${PANEL_CONTAINER_NAME}"
    makeDirIfNotExist "${PROJ_ROOT}/${PANEL_CONTAINER_NAME}/conf"
    makeDirIfNotExist "${PROJ_ROOT}/${PANEL_CONTAINER_NAME}/logs"
    makeDirIfNotExist "${PROJ_ROOT}/${PANEL_CONTAINER_NAME}/logs/nginx"
    makeDirIfNotExist "${PROJ_ROOT}/${PANEL_CONTAINER_NAME}/db"
    makeDirIfNotExist "${PROJ_ROOT}/compose"
}

function makeTraefiklDir() {
    makeDirIfNotExist "${PROJ_ROOT}/traefik"
    makeDirIfNotExist "${PROJ_ROOT}/traefik/certificates"
    makeDirIfNotExist "${PROJ_ROOT}/traefik/configs"
    makeDirIfNotExist "${PROJ_ROOT}/traefik/configs/dynamic"
    makeDirIfNotExist "${PROJ_ROOT}/logs"
}

function makeDefDir() {
   makeDirIfNotExist "${PROJ_ROOT}"
   makeDirIfNotExist "${PROJ_ROOT}/compose"
   makeDirIfNotExist "${ACME_ROOT}/out"
   makeDirIfNotExist "${BACKUP_ROOT}"
   makeDirIfNotExist "${TRAEFIK_ROOT}/logs"
   makeDirIfNotExist "${XRAYR_ROOT}/logs"
   makeDirIfNotExist "${NGINX_ROOT}/logs"
   makeDirIfNotExist "${NGINX_ROOT}/conf"
   makeDirIfNotExist "${NGINX_ROOT}/conf.d"
   makeDirIfNotExist "${NGINX_ROOT}/extra"
   makeDirIfNotExist "${NGINX_ROOT}/ssl"
   makeDirIfNotExist "${NGINX_ROOT}/ssl/self"
}

function getHTTPSCertificateCheckEmail(){
    if [ -z $2 ]; then
        
        if [[ $1 == "email" ]]; then
            red " The input email address cannot be empty, please re-enter !"
            getHTTPSCertificateInputEmail
        elif [[ $1 == "googleEabKey" ]]; then
            red " Enter EAB key can not be empty, please re-enter !"
            getHTTPSCertificateInputGoogleEABKey
        elif [[ $1 == "googleEabId" ]]; then
            red " Enter EAB Id cannot be empty, please re-enter !"
            getHTTPSCertificateInputGoogleEABId            
        fi
    fi
}

function getHTTPSCertificateInputEmail(){
    echo
    read -r -p "Please enter your email address to apply for a SSL certificate:" acmeSSLRegisterEmailInput
    getHTTPSCertificateCheckEmail "email" "${acmeSSLRegisterEmailInput}"
}

function getHTTPSCertificateInputGoogleEABKey(){
    echo
    read -r -p "Please enter Google EAB key :" isDomainSSLGoogleEABKeyInput
    getHTTPSCertificateCheckEmail "googleEabKey" "${isDomainSSLGoogleEABKeyInput}"
}

function getHTTPSCertificateInputGoogleEABId(){
    echo
    read -r -p "please enter Google EAB id :" isDomainSSLGoogleEABIdInput
    getHTTPSCertificateCheckEmail "googleEabId" "${isDomainSSLGoogleEABIdInput}"
}

function compareRealIpWithLocalIp(){
    echo
    green " Check whether the IP pointed to by the domain name is correct. Press Enter to check by default."
    red " If the IP pointed to by the domain name is not the local IP, or the CDN is turned on and it is inconvenient to close, or the VPS only has IPv6, you can choose whether to not detect"
    read -r -p "Does the detection domain name point to the correct IP? Please enter [Y/n]:" isDomainValidInput
    isDomainValidInput=${isDomainValidInput:-Y}

    if [[ $isDomainValidInput == [Yy] ]]; then
        if [[ -n "$1" ]]; then
            configNetworkRealIp=$(ping $1 -c 1 | sed '1{s/[^(]*(//;s/).*//;q}')
            # https://unix.stackexchange.com/questions/22615/how-can-i-get-my-external-ip-address-in-a-shell-script
            configNetworkLocalIp1="$(curl http://whatismyip.akamai.com/)"
            configNetworkLocalIp2="$(curl https://checkip.amazonaws.com/)"
            #configNetworkLocalIp3="$(curl https://ipv4.icanhazip.com/)"
            #configNetworkLocalIp4="$(curl https://v4.ident.me/)"
            #configNetworkLocalIp5="$(curl https://api.ip.sb/ip)"
            #configNetworkLocalIp6="$(curl https://ipinfo.io/ip)"
            
            
            #configNetworkLocalIPv61="$(curl https://ipv6.icanhazip.com/)"
            #configNetworkLocalIPv62="$(curl https://v6.ident.me/)"


            green " ================================================== "
            green " The domain name resolution address is ${configNetworkRealIp},The IP of this VPS is ${configNetworkLocalIp1} "

            echo
            if [[ ${configNetworkRealIp} == "${configNetworkLocalIp1}" || ${configNetworkRealIp} == "${configNetworkLocalIp2}" ]] ; then

                green " The IP address of the domain name resolution is normal !"
                green " ================================================== "
                true
            else
                red "The domain name resolution address is inconsistent with the IP address of this VPS !"
                red " This installation failed, please ensure that the domain name resolution is normal, please check whether the domain name and DNS are valid!"
                green " ================================================== "
                false
            fi
        else
            green " ================================================== "        
            red "     Domain name entered incorrectly!"
            green " ================================================== "        
            false
        fi
        
    else
        green " ================================================== "
        green "     Do not check whether the domain name resolution is correct!"
        green " ================================================== "
        true
    fi
}

function getHTTPSCertificateStep1(){
    if [ -z $1 ]; then
        echo
        green " ================================================== "
        yellow " Please enter the domain name that resolves to this VPS, such as www.xxx.com: (In this step, please close the CDN and install it after nginx to avoid the failure to apply for a certificate due to port 80 occupation)"
        read -r -p "Please enter the domain name resolved to this VPS:" configSSLDomain
    else
        configSSLDomain=$1
    fi

    if compareRealIpWithLocalIp "${configSSLDomain}" ; then
        echo
        getHTTPSCertificateWithAcme ${configSSLDomain} $2
    else
        exit
    fi
}

function getPanelSSLCertification() {

  if [[ -z $1 ]]; then
    while [[ -z ${configSSLDomain} ]]; do
      read -r -p "Please Input SSL Domain Name: " configSSLDomain
    done
  else
      configSSLDomain=$1
  fi

  DOMAIN_SSL_Day=$(getDomainEccSslRemainingDays ${configSSLDomain})
  if [[ ${DOMAIN_SSL_Day} != false ]]; then
    if [[ $DOMAIN_SSL_Day -le 7 ]]; then
      read -r -p "SSL Cerificates for $domain Domain Must be renew! Only $DOMAIN_SSL_Day Day Remaining !!!, press Enter to renew, [Yn]:" isRenewSSLInput
      isRenewSSLInput=${isRenewSSLInput:-Y}
      if [[ "$isRenewSSLInput" == [Yy] ]]; then
        # renewCertificationWithAcme ${DOMAIN}
        docker exec acme.sh --renew -d ${configSSLDomain} --force --ecc
        echo
        green " domain name ${configSSLDomain} 's certificate has been successfully renewed!"
        deployCertificatesToNginxDocker ${configSSLDomain}
      fi
    else
      echo "SSL Certificate for domain :$configSSLDomain FOUND and valid until ${DOMAIN_SSL_Day} day from now !!!!"
    fi
  else
    read -r -p "SSL Certificate for domain :$configSSLDomain NOT FOUND !!!! Are you Want Generating New one ?, press Enter to Get New, [Yn]:" isnewSSLInput
      isnewSSLInput=${isnewSSLInput:-Y}
      if [[ "$isnewSSLInput" == [Yy] ]]; then
        if compareRealIpWithLocalIp "${configSSLDomain}" ; then
          echo
          getHTTPSCertificateWithAcme ${configSSLDomain}
        else
            exit
        fi
      fi
  fi
}

function deployCertificatesToNginxDocker() {

    if [[ -z $1 ]]; then
      while [[ -z ${SSLDomainCertificate} ]]; do
        read -r -p "Please Input SSL Domain Name: " SSLDomainCertificate
      done
    else
      SSLDomainCertificate=$1
    fi
    green "Publish to docker"
    docker exec acme.sh --deploy -d ${SSLDomainCertificate} --deploy-hook docker --ecc
    docker-compose -f ${acmeDockerComposeFile} down
}

function getDomainEccSslRemainingDays() {
  if [[ -z $2 ]]; then
    len="ec-256"
  fi

  installAcmeContainer $1
  COUNTER3=0
  while read -r line
  do
      if [[ "${COUNTER3}" == '0' ]]; then
        COUNTER3=$((COUNTER3 +1))
        continue
      fi
      renewDomainArrayFix[${COUNTER3}]=$line | tr -s ' '
      Main_Domain[${COUNTER3}]=$(echo $line | cut -f1 -d ' ')
      KeyLength[${COUNTER3}]=$(echo $line | cut -f2 -d ' ' | cut -f2 -d '"')
      SAN_Domains[${COUNTER3}]=$(echo $line | cut -f3 -d ' ')
      CA[${COUNTER3}]=$(echo $line | cut -f4 -d ' ')
      Created[${COUNTER3}]=$(echo $line | cut -f5 -d ' ')
      Renew[${COUNTER3}]=$(echo $line | cut -f6 -d ' ')
      SSL_Day=$(SslRemainingDay ${Renew[${COUNTER3}]})
      if [[ "${Main_Domain[${COUNTER3}]}" == "$1" ]]; then
        if [[ "${KeyLength[${COUNTER3}]}" == "${len}" ]]; then
          echo $SSL_Day
          exit
        fi
      fi
      COUNTER3=$((COUNTER3 +1))
  done < <(docker exec acme.sh --list)
  docker-compose -f ${acmeDockerComposeFile} down
  echo false
}



function SslRemainingDay() {
  time=$(date +"%s")
  execute=$(date +"%s" -d "$1")
  math=$(((execute-time) / (3600*24) ))
  echo $math
}

function renewCertificationWithAcme(){

    # https://stackoverflow.com/questions/8880603/loop-through-an-array-of-strings-in-bash
    # https://stackoverflow.com/questions/9954680/how-to-store-directory-files-listing-into-an-array
    
    shopt -s nullglob
    configSSLAcmeScriptPath="${PROJ_ROOT}/etc/acme"
    renewDomainArray=("${configSSLAcmeScriptPath}"/*ecc*)

    COUNTER1=1

    if [ ${#renewDomainArray[@]} -ne 0 ]; then
        echo
        green " ================================================== "
        green " It is detected that the machine has already applied for a domain name certificate. Whether to add a new domain name certificate"
        echo
        green " 1. Newly apply for a domain name certificate"
        green " 2. Renew the applied domain name certificate"
        green " 3. Delete the domain name certificate that has been applied for"
        echo
        read -r -p "Please choose whether to add a domain name certificate? By default, press Enter to add, please enter pure numbers:" isAcmeSSLAddNewInput
        isAcmeSSLAddNewInput=${isAcmeSSLAddNewInput:-1}
        if [[ "$isAcmeSSLAddNewInput" == "2" || "$isAcmeSSLAddNewInput" == "3" ]]; then

            echo
            green " ================================================== "
            green " Please select a domain name to renew or delete:"
            echo
            for renewDomainName in "${renewDomainArray[@]}"; do
                
                substr=${renewDomainName##*/}
                substr=${substr%_ecc*}
                renewDomainArrayFix[${COUNTER1}]="$substr"
                echo " ${COUNTER1}. domain name: ${substr}"

                COUNTER1=$((COUNTER1 +1))
            done

            echo
            read -r -p "Please select a domain name? Please enter only numbers:" isRenewDomainSelectNumberInput
            isRenewDomainSelectNumberInput=${isRenewDomainSelectNumberInput:-99}
        
            if [[ "$isRenewDomainSelectNumberInput" == "99" ]]; then
                red " Input errors, please re-enter!"
                echo
                read -r -p "Please select a domain name? Please enter only numbers:" isRenewDomainSelectNumberInput
                isRenewDomainSelectNumberInput=${isRenewDomainSelectNumberInput:-99}

                if [[ "$isRenewDomainSelectNumberInput" == "99" ]]; then
                    red " typo, exit!"
                    exit
                else
                    echo
                fi
            else
                echo
            fi

            configSSLRenewDomain=${renewDomainArrayFix[${isRenewDomainSelectNumberInput}]}


            installAcmeContainer ${configSSLRenewDomain}
            if [ -n `docker exec acme.sh --list | grep ${configSSLRenewDomain}` ]; then

                if [[ "$isAcmeSSLAddNewInput" == "2" ]]; then
                    docker exec acme.sh --renew -d ${configSSLRenewDomain} --force --ecc
                    echo
                    green " domain name ${configSSLRenewDomain} 's certificate has been successfully renewed!"
                    deployCertificatesToNginxDocker ${configSSLRenewDomain}
                    # docker-compose -f ${acmeDockerComposeFile} down

                elif [[ "$isAcmeSSLAddNewInput" == "3" ]]; then
                    ${configSSLAcmeScriptPath}/acme.sh --revoke -d ${configSSLRenewDomain} --ecc
                    ${configSSLAcmeScriptPath}/acme.sh --remove -d ${configSSLRenewDomain} --ecc

                    rm -rf "${configSSLAcmeScriptPath}/${configSSLRenewDomain}_ecc"
                    echo
                    green " domain name ${configSSLRenewDomain} The certificate has been deleted successfully!"
                    exit
                fi  
            else
                echo
                red " domain name ${configSSLRenewDomain} certificate does not exist！"
            fi
        else 
            getHTTPSCertificateStep1 $1 $2
        fi
    else
        getHTTPSCertificateStep1 $1 $2
    fi
docker-compose -f ${acmeDockerComposeFile} down
}
acmeSSLDays="89"
function getHTTPSCertificateWithAcme(){
    installAcmeContainer ${configSSLDomain}
    getHTTPSCertificateInputEmail

    echo
    green " ================================================== "
    green " Domain Name : ${configSSLDomain}"
    green " Please select a certificate provider, the default is to apply for a certificate through Letsencrypt.org "
    green " If the certificate application fails, such as too many applications through Letsencrypt.org in one day, you can choose BuyPass.com or ZeroSSL.com to apply."
    green " 1 Letsencrypt.org "
    green " 2 BuyPass.com "
    green " 3 ZeroSSL.com "
    green " 4 Google Public CA "
    echo
    read -r -p "Please select a certificate provider? The default is to apply through Letsencrypt.org, please enter pure numbers:" isDomainSSLFromLetInput
    isDomainSSLFromLetInput=${isDomainSSLFromLetInput:-1}
        
    if [[ "$isDomainSSLFromLetInput" == "2" ]]; then

        acmeSSLDays="179"
        acmeSSLServerName="buypass"
        echo
        docker exec acme.sh --register-account --accountemail ${acmeSSLRegisterEmailInput} --server buypass
            
    elif [[ "$isDomainSSLFromLetInput" == "3" ]]; then

        acmeSSLServerName="zerossl"
        echo
        docker exec acme.sh --register-account -m ${acmeSSLRegisterEmailInput} --server zerossl

    elif [[ "$isDomainSSLFromLetInput" == "4" ]]; then
        green " ================================================== "
        yellow " Please follow the link below to apply google Public CA  https://hostloc.com/thread-993780-1-1.html"
        yellow " For details, please refer to https://github.com/acmesh-official/acme.sh/wiki/Google-Public-CA"

        acmeSSLServerName="google"
        getHTTPSCertificateInputGoogleEABKey
        getHTTPSCertificateInputGoogleEABId
        docker exec acme.sh --register-account -m ${acmeSSLRegisterEmailInput} --server google --eab-kid ${isDomainSSLGoogleEABIdInput} --eab-hmac-key ${isDomainSSLGoogleEABKeyInput}    
    else
        acmeSSLServerName="letsencrypt"
        #docker exec acme.sh --issue -d ${configSSLDomain} --webroot ${configWebsitePath} --keylength ec-256 --days 89 --server letsencrypt
    fi

    echo
    green " ================================================== "
    green "Please select the acme.sh script to apply for the SSL certificate method: 1 http method, 2 dns method "
    green " The default is to press Enter directly to apply for http, otherwise it is to use dns"
    echo
    read -r -p "Please select an SSL certificate application method [Y/n]:" isAcmeSSLRequestMethodInput
    isAcmeSSLRequestMethodInput=${isAcmeSSLRequestMethodInput:-Y}
    echo

    if [[ $isAcmeSSLRequestMethodInput == [Yy] ]]; then

        echo
        green " Start requesting certificate acme.sh via http standalone mode from ${acmeSSLServerName} To apply, please make sure that port 80 is not occupied "
        echo
        docker exec acme.sh --issue --webroot /acme.sh --keylength ec-256 --days ${acmeSSLDays} --server ${acmeSSLServerName} -d ${configSSLDomain}
    else
        green " Start to apply for a certificate, acme.sh applies through dns mode "

        echo
        green "Please select DNS provider DNS provider: 1 CloudFlare, 2 Arvan,  3 DNSPod(Tencent), 4 GoDaddy "
        red "Note that CloudFlare no longer supports using API to apply for DNS certificates for some free domain names such as .tk .cf, etc. "
        echo
        read -r -p "Please select a DNS provider? The default is 1. CloudFlare, please enter pure numbers:" isAcmeSSLDNSProviderInput
        isAcmeSSLDNSProviderInput=${isAcmeSSLDNSProviderInput:-1}    

            
        if [ "$isAcmeSSLDNSProviderInput" == "2" ]; then
            read -r -p "Please Input Arvan Token: " Arvan_Token
            acmeSSLDNSProvider="dns_arvan"

            docker exec \
                -e Arvan_Token=${Arvan_Token} \
                acme.sh --issue -d ${configSSLDomain} -d *.${configSSLDomain} --dns ${acmeSSLDNSProvider} \
                --force --keylength ec-256 --server ${acmeSSLServerName} --debug
            
        elif [ "$isAcmeSSLDNSProviderInput" == "3" ]; then
            read -r -p "Please Input DNSPod API ID: " DP_Id
            read -r -p "Please Input DNSPod API Key: " DP_Key
            acmeSSLDNSProvider="dns_dp"

            docker exec \
                -e DP_Key=${DP_Key} \
                -e DP_Id=${DP_Id} \
                acme.sh --issue -d ${configSSLDomain} -d *.${configSSLDomain} --dns ${acmeSSLDNSProvider} \
                --force --keylength ec-256 --server ${acmeSSLServerName} --debug

        elif [ "$isAcmeSSLDNSProviderInput" == "4" ]; then
            read -r -p "Please Input GoDaddy API Key: " gd_Key
            read -r -p "Please Input GoDaddy API Secret: " gd_Secret
            acmeSSLDNSProvider="dns_gd"

            docker exec \
                -e GD_Key=${gd_Key} \
                -e GD_Secret=${gd_Secret}  \
                acme.sh --issue -d ${configSSLDomain} -d *.${configSSLDomain} --dns ${acmeSSLDNSProvider} \
                --force --keylength ec-256 --server ${acmeSSLServerName} --debug

        else
            read -r -p "Please Input CloudFlare Email: " cf_email
            read -r -p "Please Input CloudFlare Global API Key: " cf_key
            acmeSSLDNSProvider="dns_cf"
            
            docker exec \
                -e CF_Email=${cf_email} \
                -e CF_Key=${cf_key} \
                acme.sh --issue -d ${configSSLDomain} -d *.${configSSLDomain}  --dns ${acmeSSLDNSProvider} \
                --force --keylength ec-256 --server ${acmeSSLServerName} --debug
        fi
    fi
    deployCertificatesToNginxDocker ${configSSLDomain}
    # Deploy=${2:-${configSSLDomain}}
    echo
    docker-compose -f ${acmeDockerComposeFile} down
    green " ================================================== "
}


function readXrayrEnv(){

  readEnvFile

  if [[ -z "$XRAYR_IMAGE" ]]; then
    read -p "XRAYR_IMAGE is not set, press enter to using default value [ghcr.io/kontorol/xrayr:master]:" XRAYR_IMAGE
    XRAYR_IMAGE=${XRAYR_IMAGE:-ghcr.io\/kontorol\/xrayr:master}
  fi

  if [[ -z "$LOG_LEVEL" ]]; then
    read -p "LOG_LEVEL is not set, press enter to using default value [none/error/warning/info/debug]:" LOG_LEVEL
    LOG_LEVEL=${LOG_LEVEL:-warning}
  fi

  if [[ -z "$TIME_ZONE" ]]; then
    read -p "TIME_ZONE is not set, press enter to using default value [Asia/Tehran]:" TIME_ZONE
    TIME_ZONE=${TIME_ZONE:-"Asia/Tehran"}
  fi

  if [[ -z "$LOG_ACCESS_PATH" ]]; then
    read -p "LOG_ACCESS_PATH is not set, press enter to using default value [/etc/XrayR/access.Log]:" LOG_ACCESS_PATH
    LOG_ACCESS_PATH=${LOG_ACCESS_PATH:-"\/etc\/XrayR\/access.Log"}
  fi

  if [[ -z "$LOG_ERROR_PATH" ]]; then
    read -p "LOG_ERROR_PATH is not set, press enter to using default value [/etc/XrayR/error.Log]:" LOG_ERROR_PATH
    LOG_ERROR_PATH=${LOG_ERROR_PATH:-"\/etc\/XrayR\/error.log"}
  fi

  if [[ -z "$DNS_CONFIG_PATH" ]]; then
    read -p "DNS_CONFIG_PATH is not set, press enter to using default value [/etc/XrayR/dns.json]:" DNS_CONFIG_PATH
    DNS_CONFIG_PATH=${DNS_CONFIG_PATH:-"\/etc\/XrayR\/dns.json"}
  fi

  if [[ -z "$ROUTE_CONFIG_PATH" ]]; then
    read -p "ROUTE_CONFIG_PATH is not set, press enter to using default value [/etc/XrayR/route.json]:" ROUTE_CONFIG_PATH
    ROUTE_CONFIG_PATH=${ROUTE_CONFIG_PATH:-"\/etc\/XrayR\/route.json"}
  fi

  if [[ -z "$INBOUND_CONFIG_PATH" ]]; then
    read -p "INBOUND_CONFIG_PATH is not set, press enter to using default value [/etc/XrayR/custom_inbound.json]:" INBOUND_CONFIG_PATH
    INBOUND_CONFIG_PATH=${INBOUND_CONFIG_PATH:-"\/etc\/XrayR\/custom_inbound.json"}
  fi

  if [[ -z "$OUTBOUND_CONFIG_PATH" ]]; then
    read -p "OUTBOUND_CONFIG_PATH is not set, press enter to using default value [/etc/XrayR/custom_outbound.json]:" OUTBOUND_CONFIG_PATH
    OUTBOUND_CONFIG_PATH=${OUTBOUND_CONFIG_PATH:-"\/etc\/XrayR\/custom_outbound.json"}
  fi

  if [[ -z "$HANDSHAKE" ]]; then
    read -p "HANDSHAKE is not set, press enter to using default value [4]:" HANDSHAKE
    HANDSHAKE=${HANDSHAKE:-4}
  fi

  if [[ -z "$CONN_IDLE" ]]; then
    read -p "CONN_IDLE is not set, press enter to using default value [30]:" CONN_IDLE
    CONN_IDLE=${CONN_IDLE:-30}
  fi

  if [[ -z "$UPLINK_ONLY" ]]; then
    read -p "UPLINK_ONLY is not set, press enter to using default value [2]:" UPLINK_ONLY
    UPLINK_ONLY=${UPLINK_ONLY:-2}
  fi

  if [[ -z "$DOWNLINK_ONLY" ]]; then
    read -p "DOWNLINK_ONLY is not set, press enter to using default value [4]:" DOWNLINK_ONLY
    DOWNLINK_ONLY=${DOWNLINK_ONLY:-4}
  fi

  if [[ -z "$BUFFER_SIZE" ]]; then
    read -p "BUFFER_SIZE is not set, press enter to using default value [64]:" BUFFER_SIZE
    BUFFER_SIZE=${BUFFER_SIZE:-64}
  fi

  if [[ -z "$PANEL_TYPE" ]]; then
    read -p "PANEL_TYPE is not set, press enter to using default value [SSpanel]:" PANEL_TYPE
    PANEL_TYPE=${PANEL_TYPE:-SSpanel}
  fi

  if [[ -z "$API_HOST" ]]; then
    read -p "API_HOST is not set, press enter to using default value [http://127.0.0.1:667]:" API_HOST
    API_HOST=${API_HOST:-"http:\/\/127.0.0.1\:667"}
  fi

  while [ -z ${API_KEY} ]; do
    read -p "API_KEY is not set, press enter to using default value ["123"]:" API_KEY
  done

  # while [ -z ${API_KEY} ]; do
  # 	read -p "API_KEY is not set, press enter Correct key:" API_KEY
  # done

  if [[ -z "$NODE_ID" ]]; then
    read -p "NODE_ID is not set, press enter to using default value [1]:" NODE_ID
    NODE_ID=${NODE_ID:-1}
  fi

  if [[ -z "$NODE_TYPE" ]]; then
    read -p "NODE_TYPE is not set, press enter to using default value [V2ray]:" NODE_TYPE
    NODE_TYPE=${NODE_TYPE:-V2ray}
  fi

  if [[ -z "$NODE_TIMEOUT" ]]; then
    read -p "NODE_TIMEOUT is not set, press enter to using default value [30]:" NODE_TIMEOUT
    NODE_TIMEOUT=${NODE_TIMEOUT:-30}
  fi

  if [[ -z "$ENABLE_VLESS" ]]; then
    read -p "ENABLE_VLESS is not set, press enter to using default value [false]:" ENABLE_VLESS
    ENABLE_VLESS=${ENABLE_VLESS:-false}
  fi

  if [[ -z "$ENABLE_XTLS" ]]; then
    read -p "ENABLE_XTLS is not set, press enter to using default value [false]:" ENABLE_XTLS
    ENABLE_XTLS=${ENABLE_XTLS:-false}
  fi

  if [[ -z "$NODE_SPEED_LIMIT" ]]; then
    read -p "NODE_SPEED_LIMIT is not set, press enter to using default value [0]:" NODE_SPEED_LIMIT
    NODE_SPEED_LIMIT=${NODE_SPEED_LIMIT:-0}
  fi

  if [[ -z "$NODE_DEVICE_LIMIT" ]]; then
    read -p "NODE_DEVICE_LIMIT is not set, press enter to using default value [0]:" NODE_DEVICE_LIMIT
    NODE_DEVICE_LIMIT=${NODE_DEVICE_LIMIT:-0}
  fi

  if [[ -z "$NODE_RULE_LIST_PATH" ]]; then
    read -p "NODE_RULE_LIST_PATH is not set, press enter to using default value [0]:" NODE_RULE_LIST_PATH
    NODE_RULE_LIST_PATH=${NODE_RULE_LIST_PATH:-0}
  fi

  if [[ -z "$LISTEN_IP" ]]; then
    read -p "LISTEN_IP is not set, press enter to using default value [0.0.0.0]:" LISTEN_IP
    LISTEN_IP=${LISTEN_IP:-0.0.0.0}
  fi

  if [[ -z "$SEND_IP" ]]; then
    read -p "SEND_IP is not set, press enter to using default value [0.0.0.0]:" SEND_IP
    SEND_IP=${SEND_IP:-0.0.0.0}
  fi

  if [[ -z "$UPDATE_PERIODIC" ]]; then
    read -p "UPDATE_PERIODIC is not set, press enter to using default value [60]:" UPDATE_PERIODIC
    UPDATE_PERIODIC=${UPDATE_PERIODIC:-60}
  fi

  if [[ -z "$ENABLE_DNS" ]]; then
    read -p "ENABLE_DNS is not set, press enter to using default value [false]:" ENABLE_DNS
    ENABLE_DNS=${ENABLE_DNS:-false}
  fi

  if [[ ${ENABLE_DNS} = "true" ]] && [[ -z "$DNS_TYPE" ]]; then
    read -p "DNS_TYPE is not set, press enter to using default value [AsIs]:" DNS_TYPE
    DNS_TYPE=${DNS_TYPE:-AsIs}
  fi

  if [[ -z "$ENABLE_PROXY_PROTOCOL" ]]; then
    read -p "ENABLE_PROXY_PROTOCOL is not set, press enter to using default value [false]:" ENABLE_PROXY_PROTOCOL
    ENABLE_PROXY_PROTOCOL=${ENABLE_PROXY_PROTOCOL:-false}
  fi

  if [[ -z "$SPEED_LIMIT" ]]; then
    read -p "SPEED_LIMIT is not set, press enter to using default value [0]:" SPEED_LIMIT
    SPEED_LIMIT=${SPEED_LIMIT:-0}
  fi

  if [[ -z "$SPEED_WARN_TIMES" ]]; then
    read -p "SPEED_WARN_TIMES is not set, press enter to using default value [0]:" SPEED_WARN_TIMES
    SPEED_WARN_TIMES=${SPEED_WARN_TIMES:-0}
  fi

  if [[ -z "$SPEED_LIMIT_SPEED" ]]; then
    read -p "SPEED_LIMIT_SPEED is not set, press enter to using default value [0]:" SPEED_LIMIT_SPEED
    SPEED_LIMIT_SPEED=${SPEED_LIMIT_SPEED:-0}
  fi

  if [[ -z "$SPEED_LIMIT_DURATION" ]]; then
    read -p "SPEED_LIMIT_DURATION is not set, press enter to using default value [0]:" SPEED_LIMIT_DURATION
    SPEED_LIMIT_DURATION=${SPEED_LIMIT_DURATION:-0}
  fi

  if [[ -z "$RADIS_ENABLE" ]]; then
    read -p "RADIS_ENABLE is not set, press enter to using default value [false]:" RADIS_ENABLE
    RADIS_ENABLE=${RADIS_ENABLE:-false}
  fi
  if [[ ${RADIS_ENABLE} = "true" ]]; then
    if [[ -z "$RADIS_ADDR" ]]; then
      read -p "RADIS_ADDR is not set, press enter to using default value [127.0.0.1:6379]:" RADIS_ADDR
      RADIS_ADDR=${RADIS_ADDR:-"127.0.0.1\:6379"}
    fi

    if [[ -z "$RADIS_PASSWORD" ]]; then
      read -p "RADIS_PASSWORD is not set, press enter to using default value [SSRADIS]:" RADIS_PASSWORD
      RADIS_PASSWORD=${RADIS_PASSWORD:-SSRADIS}
    fi

    if [[ -z "$RADIS_DB" ]]; then
      read -p "RADIS_DB is not set, press enter to using default value [0]:" RADIS_DB
      RADIS_DB=${RADIS_DB:-0}
    fi

    if [[ -z "$RADIS_TIME_OUT" ]]; then
      read -p "RADIS_TIME_OUT is not set, press enter to using default value [5]:" RADIS_TIME_OUT
      RADIS_TIME_OUT=${RADIS_TIME_OUT:-5}
    fi

    if [[ -z "$RADIS_EXPIRY" ]]; then
      read -p "RADIS_EXPIRY is not set, press enter to using default value [60]:" RADIS_EXPIRY
      RADIS_EXPIRY=${RADIS_EXPIRY:-60}
    fi
  fi
  if [[ -z "$FALLBACK_ENABLE" ]]; then
    read -p "FALLBACK_ENABLE is not set, press enter to using default value [false]:" FALLBACK_ENABLE
    FALLBACK_ENABLE=${FALLBACK_ENABLE:-false}
  fi
  if [[ -z "$FALLBACK_ENABLE" ]]; then
    if [[ -z "$FALLBACK_SNI" ]]; then
      read -p "FALLBACK_SNI is not set, press enter to using default value [empty]:" FALLBACK_SNI
      FALLBACK_SNI=${FALLBACK_SNI:-\"\"}
    fi

    if [[ -z "$FALLBACK_PATH" ]]; then
      read -p "FALLBACK_PATH is not set, press enter to using default value [empty]:" FALLBACK_PATH
      FALLBACK_PATH=${FALLBACK_PATH:-\"\"}
    fi

    if [[ -z "$FALLBACK_DEST" ]]; then
      read -p "FALLBACK_DEST is not set, press enter to using default value [80]:" FALLBACK_DEST
      FALLBACK_DEST=${FALLBACK_DEST:-80}
    fi

    if [[ -z "$FALLBACK_PROXY_PROTOCOL_VER" ]]; then
      read -p "FALLBACK_PROXY_PROTOCOL_VER is not set, press enter to using default value [0]:" FALLBACK_PROXY_PROTOCOL_VER
      FALLBACK_PROXY_PROTOCOL_VER=${FALLBACK_PROXY_PROTOCOL_VER:-0}
    fi
  fi  

  if [[ -z "$CERT_MODE" ]]; then
    read -p "CERT_MODE is not set, press enter to using default value [dns]:" CERT_MODE
    CERT_MODE=${CERT_MODE:-dns}
  fi

  if [[  "$CERT_MODE" != "none" ]]; then
    if [[ -z "$CERT_DOMAIN" ]]; then
      read -p "CERT_DOMAIN is not set, press enter to using default value [node1.test.com]:" CERT_DOMAIN
      CERT_DOMAIN=${CERT_DOMAIN:-node1.test.com}
    fi

    if [[ -z "$CERT_FILE" ]] && [[ $CERT_MODE == "file" ]]; then
      read -p "CERT_FILE is not set, press enter to using default value [/etc/XrayR/cert/node1.test.com.cert]:" CERT_FILE
      CERT_FILE=${CERT_FILE:-"\/etc\/XrayR\/cert\/${CERT_DOMAIN}.cert"}
    fi

    if [[ -z "$CERT_KEY_FILE" ]] && [[ $CERT_MODE == "file" ]]; then
      read -p "CERT_KEY_FILE is not set, press enter to using default value [/etc/XrayR/cert/node1.test.com.key]:" CERT_KEY_FILE
      CERT_KEY_FILE=${CERT_KEY_FILE:-"\/etc\/XrayR\/cert\/${CERT_DOMAIN}.key"}
    fi

    if [[ -z "$CERT_PROVIDER" ]] && [[ $CERT_MODE == "dns" || $CERT_MODE == "http" || $CERT_MODE == "ssl" ]]; then
      read -p "CERT_PROVIDER is not set, press enter to using default value [cloudflare]:" CERT_PROVIDER
      CERT_PROVIDER=${CERT_PROVIDER:-cloudflare}
    fi

    if [[ -z "$CERT_EMAIL" ]] && [[ $CERT_MODE == "dns" || $CERT_MODE == "http" || $CERT_MODE == "ssl" ]]; then
      read -p "CERT_EMAIL is not set, press enter to using default value [test@me.com]:" CERT_EMAIL
      CERT_EMAIL=${CERT_EMAIL:-"test\@me.com"}
    fi

    if [[ "$CERT_PROVIDER" ==  "alidns" ]] && [[ $CERT_MODE == "dns" ]]; then
      if [[ -z "$ALICLOUD_ACCESS_KEY" ]]; then
        read -p "ALICLOUD_ACCESS_KEY is not set, please enter key [aaa]:" ALICLOUD_ACCESS_KEY
        ALICLOUD_ACCESS_KEY=${ALICLOUD_ACCESS_KEY:-aaa}
      fi

      if [[ -z "$ALICLOUD_SECRET_KEY" ]] && [[ $CERT_MODE == "dns" ]]; then
        read -p "ALICLOUD_SECRET_KEY is not set, please enter key [bbb]:" ALICLOUD_SECRET_KEY
        ALICLOUD_SECRET_KEY=${ALICLOUD_SECRET_KEY:-bbb}
      fi
    fi

    if [[ "$CERT_PROVIDER" ==  "cloudflare" ]] && [[ $CERT_MODE == "dns" ]]; then
      if [[ -z "$CLOUDFLARE_API_KEY" ]]; then
        read -p "CLOUDFLARE_API_KEY is not set, please enter key [bbb]:" CLOUDFLARE_API_KEY
        CLOUDFLARE_API_KEY=${CLOUDFLARE_API_KEY:-bbb}
      fi

      if [[ -z "$CLOUDFLARE_EMAIL" ]]; then
        read -p "CLOUDFLARE_EMAIL is not set, please enter key [$CERT_EMAIL]:" CLOUDFLARE_EMAIL
        CLOUDFLARE_EMAIL=${CLOUDFLARE_EMAIL:-$CERT_EMAIL}
      fi
    fi

    if [[ "$CERT_PROVIDER" ==  "arvancloud" ]] && [[ $CERT_MODE == "dns" ]]; then
      if [[ -z "$ARVANCLOUD_API_KEY" ]]; then
        read -p "ARVANCLOUD_API_KEY is not set, please enter key [Apikey aaa]:" ARVANCLOUD_API_KEY
        ARVANCLOUD_API_KEY=${ARVANCLOUD_API_KEY:-Apikey aaa}
      fi
    fi
  fi

  if [[ -z "$NODE_NAME" ]]; then
    if [[ -z "$NODE_STREAM_TYPE" ]]; then
      read -p "NODE_STREAM_TYPE is not set, please enter type [tcp]:" NODE_STREAM_TYPE
      NODE_STREAM_TYPE=${NODE_STREAM_TYPE:-grpc}
    fi

    if [[ "$NODE_STREAM_TYPE" == "websocket" ]]; then
      TRANS="ws"
    elif [[ "$NODE_STREAM_TYPE" == "grpc" ]]; then
      TRANS="pc"
    elif [[ "$NODE_STREAM_TYPE" == "tcp" ]]; then
      TRANS="tc"
    fi

    if [[ "$NODE_TYPE" == "V2ray" ]]; then
      if [[ "$ENABLE_VLESS" == "true" ]]; then
        TYP="vl"
      else
        TYP="vm"
      fi
    elif [[ "$NODE_TYPE" == "Trojan" ]]; then
      PRE="tr"
    fi
    TEMP_NODE_NAME=${TYP}-${TRANS}
    read -p "NODE_NAME is not set, please enter NODE_NAME or press enter to use auto generated [${TEMP_NODE_NAME}]:" NODE_NAME
    NODE_NAME=${NODE_NAME:-${TEMP_NODE_NAME}}
    CONTAINER_NAME=${NODE_ID}-${NODE_NAME}
  fi
}

function configXrayrDocker() {
  readXrayrEnv

  CERT_DOMAIN

# TODO
  # rm -rf $reverseDockerComposeFile
  checkReverseProxy

  # addNginxNewDomainConf



  createDockerNetwork
  COMPOSE_FILE=${COMPOSE_ROOT}/docker-compose-nodes.yaml
  if [ -f "$COMPOSE_FILE" ]; then
      echo "Read $COMPOSE_FILE ."
      composetemp=$(<$COMPOSE_FILE)
  else 
      echo "init $COMPOSE_FILE"
      read -r -d '' composetemp << EOM
version: "2.1"

networks:
  nodes:
    external: true
  panel:
    external: true

services:
EOM
  fi
  # echo $COMPOSE_FILE
  read -r -d '' NodeConfig << EOM

  ${CONTAINER_NAME}:
    image: ${XRAYR_IMAGE}
    restart: unless-stopped
    env_file:
      - .env
    container_name: ${CONTAINER_NAME}
    networks:
      - nodes
    external_links:
      - TRAEFIK
    environment:
      - "TIME_ZONE:${TIME_ZONE}"
      ## Log
      - "LOG_LEVEL:${LOG_LEVEL}" # Log level: none, error, warning, info, debug 
      - "LOG_ACCESS_PATH:/etc/XrayR/${CONTAINER_NAME}_access.Log"
      - "LOG_ERROR_PATH:/etc/XrayR/${CONTAINER_NAME}_error.log"
      ## Custom Rule
      - "DNS_CONFIG_PATH:${DNS_CONFIG_PATH}" # Path to dns config, check https://xtls.github.io/config/dns.html for help
      - "ROUTE_CONFIG_PATH:${ROUTE_CONFIG_PATH}" # Path to route config, check https://xtls.github.io/config/routing.html for help
      - "INBOUND_CONFIG_PATH:${INBOUND_CONFIG_PATH}" # Path to custom inbound config, check https://xtls.github.io/config/inbound.html for help
      - "OUTBOUND_CONFIG_PATH:${OUTBOUND_CONFIG_PATH}" # Path to custom outbound config, check https://xtls.github.io/config/outbound.html for help
      ## ConnectionConfig
      - "HANDSHAKE:${HANDSHAKE}" # Handshake time limit, Second
      - "CONN_IDLE:${CONN_IDLE}" # Connection idle time limit, Second
      - "UPLINK_ONLY:${UPLINK_ONLY}" # Time limit when the connection downstream is closed, Second
      - "DOWNLINK_ONLY:${DOWNLINK_ONLY}" # Time limit when the connection is closed after the uplink is closed, Second
      - "BUFFER_SIZE:${BUFFER_SIZE}" # The internal cache size of each connection, kB
      ## Nodes
      - "PANEL_TYPE:${PANEL_TYPE}" # Panel type: SSpanel, V2board, NewV2board, PMpanel, Proxypanel, V2RaySocks
      ## ApiConfig
      - "API_HOST:${API_HOST}"
      - "API_KEY:${API_KEY}"
      - "NODE_ID:${NODE_ID}"
      - "NODE_TYPE:${NODE_TYPE}" # Node type: V2ray, Shadowsocks, Trojan, Shadowsocks-Plugin
      - "NODE_TIMEOUT:${NODE_TIMEOUT}" # Timeout for the api request
      - "ENABLE_VLESS:${ENABLE_VLESS}" # Enable Vless for V2ray Type
      - "ENABLE_XTLS:${ENABLE_XTLS}" # Enable XTLS for V2ray and Trojan
      - "NODE_SPEED_LIMIT:${NODE_SPEED_LIMIT}" # Mbps, Local settings will replace remote settings, 0 means disable
      - "NODE_DEVICE_LIMIT:${NODE_DEVICE_LIMIT}" # Local settings will replace remote settings, 0 means disable
      - "NODE_RULE_LIST_PATH:${NODE_RULE_LIST_PATH}" #Path to local rulelist file
      ## ControllerConfig
      - "LISTEN_IP:${LISTEN_IP}" # IP address you want to listen
      - "SEND_IP:${SEND_IP}" # IP address you want to send pacakage
      - "UPDATE_PERIODIC:${UPDATE_PERIODIC}" # Time to update the nodeinfo, how many sec.
      - "ENABLE_DNS:${ENABLE_DNS}" # Use custom DNS config, Please ensure that you set the dns.json well
      - "DNS_TYPE:${DNS_TYPE}" # AsIs, UseIP, UseIPv4, UseIPv6, DNS strategy
      - "ENABLE_PROXY_PROTOCOL:${ENABLE_PROXY_PROTOCOL}" # Only works for WebSocket and TCP
      ## AutoSpeedLimitConfig
      - "SPEED_LIMIT:${SPEED_LIMIT}" # Warned speed. Set to 0 to disable AutoSpeedLimit (mbps)
      - "SPEED_WARN_TIMES:${SPEED_WARN_TIMES}" # After (WarnTimes) consecutive warnings, the user will be limited. Set to 0 to punish overspeed user immediately.
      - "SPEED_LIMIT_SPEED:${SPEED_LIMIT_SPEED}" # The speedlimit of a limited user (unit: mbps)
      - "SPEED_LIMIT_DURATION:${SPEED_LIMIT_DURATION}" # How many minutes will the limiting last (unit: minute)
      ## GlobalDeviceLimitConfig
      - "RADIS_ENABLE:${RADIS_ENABLE}" # Enable the global device limit of a user
      - "RADIS_ADDR:${RADIS_ADDR}" # The redis server address
      - "RADIS_PASSWORD:${RADIS_PASSWORD}" # Redis password
      - "RADIS_DB:${RADIS_DB}" # Redis DB
      - "RADIS_TIME_OUT:${RADIS_TIME_OUT}" # Timeout for redis request
      - "RADIS_EXPIRY:${RADIS_EXPIRY}" # Expiry time (second)
      ## FallBackConfigs:  # Support multiple fallbacks
      - "FALLBACK_ENABLE:${FALLBACK_ENABLE}" # Only support for Trojan and Vless
      - "FALLBACK_SNI:${FALLBACK_SNI}" # TLS SNI(Server Name Indication), Empty for any
      - "FALLBACK_ALPN:${FALLBACK_ALPN}" # Alpn, Empty for any
      - "FALLBACK_PATH:${FALLBACK_PATH}" # HTTP PATH, Empty for any
      - "FALLBACK_DEST:${FALLBACK_DEST}" # Required, Destination of fallback, check https://xtls.github.io/config/features/fallback.html for details.
      - "FALLBACK_PROXY_PROTOCOL_VER:${FALLBACK_PROXY_PROTOCOL_VER}" # Send PROXY protocol version, 0 for dsable
      ## CertConfig
      - "CERT_MODE:${CERT_MODE}" # Option about how to get certificate: none, file, http, tls, dns. Choose "none" will forcedly disable the tls config.
      - "CERT_DOMAIN:${CERT_DOMAIN}" # Domain to cert
      - "CERT_FILE:${CERT_FILE}" # Provided if the CertMode is file
      - "CERT_KEY_FILE:${CERT_KEY_FILE}"
      - "CERT_PROVIDER:${CERT_PROVIDER}" # DNS cert provider, Get the full support list here: https://go-acme.github.io/lego/dns/
      - "CERT_EMAIL:${CERT_EMAIL}"
      ## DNSEnv: # DNS ENV option used by DNS provider
      - "ALICLOUD_ACCESS_KEY:${ALICLOUD_ACCESS_KEY}"
      - "ALICLOUD_SECRET_KEY:${ALICLOUD_SECRET_KEY}"
      - "CLOUDFLARE_API_KEY:${CLOUDFLARE_API_KEY}"
      - "CLOUDFLARE_EMAIL:${CLOUDFLARE_EMAIL}"
      - "ARVANCLOUD_API_KEY:${ARVANCLOUD_API_KEY}"
    labels:
      - "traefik.enable: true"
      - "traefik.http.routers.${CONTAINER_NAME}.service: ${CONTAINER_NAME}"
      - "traefik.http.routers.${CONTAINER_NAME}.rule: Host(\`${NODE_NAME}.localhost\`)"
      - "traefik.http.routers.${CONTAINER_NAME}.entrypoints: web"
      - "traefik.http.services.${CONTAINER_NAME}.loadbalancer.server.port: 443"

    labels:
      - "traefik.enable=true"
      # https
      - "traefik.http.routers.CONTAINER_NAME.rule=Host(`${NODE_DOMAIN}`)"
      - "traefik.http.routers.CONTAINER_NAME.tls=true"
      - "traefik.http.routers.CONTAINER_NAME.tls.certresolver=letsencrypt"
      - "traefik.http.routers.CONTAINER_NAME.entrypoints=websecure"
      # http (redirect to https)
      - "traefik.http.routers.CONTAINER_NAME-http.rule=Host(`${NODE_DOMAIN}`)"
      - "traefik.http.routers.CONTAINER_NAME-http.entrypoints=web"
      - "traefik.http.routers.CONTAINER_NAME-http.middlewares=redirect-to-https@file"
      - "traefik.http.services.CONTAINER_NAME.loadbalancer.server.port=80

    
EOM

  if [[ "$TRANS" == "pc" ]]; then
    read -r -d '' nodescheme << EOM
      - "traefik.http.services.${CONTAINER_NAME}.loadbalancer.server.scheme=h2c"
EOM
  fi

  cat > ${COMPOSE_FILE} <<-EOF
${composetemp}
  ${NodeConfig}
      ${nodescheme}
EOF
}


function StartXrayrNode(){
  if [[ -z "$START_CONTAINER" ]]; then
    read -p "START_CONTAINER is not set, are you want to start Container [true]:" START_CONTAINER
    START_CONTAINER=${START_CONTAINER:-true}
  fi
  if [[ "$START_CONTAINER" = "true" ]]; then
    docker-compose -f ${COMPOSE_FILE} up -d ${NODE_NAME}
  fi
}

function addNginxNewDomainConf(){

    if [[ -z $1 ]]; then
      while [[ -z ${DOMAIN} ]]; do
        read -r -p "Please Enter Domain name to add nginx config: " configSSLDomain
      done
    else
      DOMAIN=$1
    fi

    if compareRealIpWithLocalIp "${DOMAIN}" ; then
        echo
    else
        exit
    fi

    DOMAIN_CONF_FILE=${PROJ_ROOT}/etc/nginx/conf.d/${DOMAIN}.conf
    if [ -f "$DOMAIN_CONF_FILE" ]; then
        echo "$DOMAIN_CONF_FILE exists! exit..."
        exit
    fi

    if [[ -z "$IS_REAL_IP_FROM_CDN" ]]; then
        read -p "IS_REAL_IP_FROM_CDN is not set, Are domain behind cdn [Yy]:" IS_REAL_IP_FROM_CDN
        IS_REAL_IP_FROM_CDN=${IS_REAL_IP_FROM_CDN:Y}
    fi
    if [[ "$IS_REAL_IP_FROM_CDN" == [Yy] ]]; then

        green " Please select a CDN provider, the default is to apply CDN through cloudflare "
        green " 1 CloudFlare "
        green " 2 Arvan "
        # green " 3 GCore "
        echo
        read -r -p "Please select a CDN provider? the default is to apply CDN through cloudflare, please enter pure numbers:" CdnRealIpFrom
        CDN_REAL_IP_FROM=${CdnRealIpFrom:-1}
        if [[ "$CDN_REAL_IP_FROM" == "1" ]]; then
            RIP=include ${PROJ_ROOT}/nginx/extra/cf_real_ip.conf
        elif [[ "$CDN_REAL_IP_FROM" == "2" ]]; then
            RIP=include ${PROJ_ROOT}/nginx/extra/ar_real_ip.conf
        # elif [[ "$CDN_REAL_IP_FROM" == "3" ]]; then

        fi
    else
        RIP=""
    fi
    
    cat > "${DOMAIN_CONF_FILE}" <<-EOF
        
server {
    listen 80 so_keepalive=on;
    listen [::]:80 so_keepalive=on;
    server_name  ${DOMAIN};
    sendfile off;
    root /var/www/public;
    index index.php index.html index.htm;

    ${RIP}
    include ${PROJ_ROOT}/nginx/extra/xray.conf;
    # include ${PROJ_ROOT}/nginx/extra/common.conf;
    # include ${PROJ_ROOT}/nginx/extra/def-link.conf;

    # http redirect to https
    if ( \$remote_addr != 127.0.0.1 ){
        rewrite ^/(.*)$ https://${DOMAIN}/\$1 redirect;
    }
}

server {

    listen 443 ssl http2 so_keepalive=on;
    listen [::]:443 ssl http2 so_keepalive=on;
    server_name ${DOMAIN};
    sendfile off;
    root /var/www/public;
    index index.php index.html;

    ${RIP}
    include ${PROJ_ROOT}/nginx/extra/xray.conf;
    include ${PROJ_ROOT}/nginx/extra/common.conf;
    include ${PROJ_ROOT}/nginx/extra/def-link.conf;

    ssl_certificate /etc/nginx/ssl/${DOMAIN}/fullchain.cer; 
    ssl_certificate_key /etc/nginx/ssl/${DOMAIN}/${DOMAIN}.key;

}

EOF
    # getPanelNewDomainCertificate
    getPanelSSLCertification ${DOMAIN}
}


# function getPanelNewDomainCertificate(){
#         echo
#         green " =================================================="
#         read -p "Whether to apply for an SSL certificate, please enter [Y/n]:" isGetNewDomainSSLCertificateInput
#         isGetNewDomainSSLCertificateInput=${isGetNewDomainSSLCertificateInput:-Y}

#         if [[ "${isGetNewDomainSSLCertificateInput}" == [Yy] ]]; then
#             renewCertificationWithAcme ${DOMAIN} ${NGINX_REVERSE_CONTAINER_NAME}
        
#         else
#             docker exec -it ${NGINX_REVERSE_CONTAINER_NAME} nginx -s reload
#         fi
# }

function readEnvFile(){
    if [ -f ${ENV_FILE} ]; then
        while read -r LINE; do
            if [[ $LINE == *'='* ]] && [[ $LINE != '#'* ]]; then
            ENV_VAR="$(echo $LINE | envsubst)"
            eval "declare $ENV_VAR"
            fi
        done < ${ENV_FILE}
    else
    echo ".env file not found"
    touch ${ENV_FILE}

    fi
}

SQL_PHP_ADMIN=
DB_HOST=
DB_DATABASE=
DB_PORT=3306
DB_PASSWORD=
function getDbEnv(){
    echo
    yellow DB_HOST is not set

    green " 1. Install MySql & phpmyadmin Container"
    green " 2. Use Exist DB Server"

    read -p "Please input number:" menuNumberInput
    case "$menuNumberInput" in
        1 )
            DB_HOST=${APP_NAME}-DB
            DB_DATABASE=${DB_HOST}
            DB_USERNAME="root"

            DB_PASSWORD=$(cat /dev/urandom | head -1 | md5sum | head -c 10)
            
        ;;
        
        2 )
            while [ -z ${DB_HOST} ]; do
	            read -p "DB_HOST is not set, please enter the external mysql/maria db server :" DB_HOST
            done
            DB_DATABASE=${APP_NAME}-DB
            DB_USERNAME="root"

            while [ -z ${DB_PASSWORD} ]; do
	            read -p "DB_PASSWORD is not set, please enter the external mysql/maria db server root password :" DB_PASSWORD
            done

        ;;

        * )
            red "Please enter the correct number!"
            sleep 2s
            getDbEnv
        ;;
    esac

}

dbcomposetemp=
function getDbContainer(){
    clear
    getDbEnv
    PHPMYADMIN_CONTAINER_NAME="${DB_HOST}-phpmyadmin"
    read -r -d '' dbcomposetemp << EOM
  ${DB_HOST}:
    image: mariadb:10.9
    container_name: ${DB_HOST}
    env_file:
      - ${ENV_FILE}
    volumes:
      - ${PROJ_ROOT}/etc/${PANEL_CONTAINER_NAME}/db:/var/lib/mysql
    networks:
      - db
    restart: always
    command: ['mysqld', '--character-set-server=utf8mb4', '--collation-server=utf8mb4_unicode_ci']
    environment:
      # MARIADB_AUTO_UPGRADE: "yes"
      MYSQL_ROOT_PASSWORD: ${DB_PASSWORD}
      MYSQL_DATABASE: ${DB_DATABASE}
    healthcheck:
      test: ["CMD", "mysqladmin" ,"ping", "-h", "localhost"]
      timeout: 20s
      retries: 10
  ${PHPMYADMIN_CONTAINER_NAME}:
    image: phpmyadmin
    container_name: ${PHPMYADMIN_CONTAINER_NAME}
    restart: always
    env_file:
      - ${ENV_FILE}
    ports:
      - 8880:8080
      - 4444:443
    links:
       - ${DB_HOST}:${DB_HOST}
    networks:
      - db
      - front
    # labels:
    #   - "traefik.enable=true"
    #   # https
    #   - "traefik.http.routers.${PHPMYADMIN_CONTAINER_NAME}.rule=Host(`${MYADMIN_DOMAIN}`)"
    #   - "traefik.http.routers.${PHPMYADMIN_CONTAINER_NAME}.tls=true"
    #   - "traefik.http.routers.${PHPMYADMIN_CONTAINER_NAME}.tls.certresolver=letsencrypt"
    #   - "traefik.http.routers.${PHPMYADMIN_CONTAINER_NAME}.tls.domains[0].main=*.${MYADMIN_DOMAIN}"
    #   - "traefik.http.routers.${PHPMYADMIN_CONTAINER_NAME}.entrypoints=websecure"
    #   # http (redirect to https)
    #   - "traefik.http.routers.${PHPMYADMIN_CONTAINER_NAME}-http.rule=Host(`${MYADMIN_DOMAIN}`)"
    #   - "traefik.http.routers.${PHPMYADMIN_CONTAINER_NAME}-http.entrypoints=web"
    #   - "traefik.http.routers.${PHPMYADMIN_CONTAINER_NAME}-http.middlewares=redirect-to-https@file"
    #   - "traefik.http.services.${PHPMYADMIN_CONTAINER_NAME}.loadbalancer.server.port=80
    depends_on:
      ${DB_HOST}:
        condition: service_healthy
    environment:
      - PMA_ARBITRARY=1
EOM
}


# function StartContainer() {

#   docker-compose -f $2 up -d $1
#   if [ $( docker ps -a -f name=$1 | wc -l ) -eq 2 ]; then
#     if [ "$( docker container inspect -f '{{.State.Status}}' $1 )" = "running" ]; then
#       green "$1 Container Start successfull & now is running"
#     else
#       yellow "$1 container is started but not running ! please check it manually"
#       promptContinueOpeartion
#     fi
#   else
#     echo
#     red "$1 Container could not start ! Please fix it manualy"
#     promptContinueOpeartion
#   fi


# }


# function checkPanelStatus() {

#  until [ "`docker inspect -f {{.State.Health.Status}} ${PANEL_CONTAINER_NAME}`"=="healthy" ]; do
#     echo 
#     yellow "wainting for ${PANEL_CONTAINER_NAME} container to be healthy"
#     sleep 0.1;
#   done;

# }

APP_NAME=
hostNameSplit=
PANEL_NON_SSL_PORT=
PANEL_SSL_PORT=
PANEL_CONTAINER_NAME=panel
function getPanelEnv(){
    clear
    readEnvFile
    getPanelType

    if [[ -z "$APP_NAME" ]]; then
	    read -p "APP_NAME is not set, Press enter to use default value or enter custom name [Dashboard]:" APP_NAME
	    APP_NAME=${APP_NAME:-"Dashboard"}
    fi

    while [ -z ${ADMIN_EMAIL} ]; do
	    read -p "ADMIN_EMAIL is not set, please enter the email you can access to :" ADMIN_EMAIL
    done

    ranadminPasswd=$(cat /dev/urandom | head -1 | md5sum | head -c 16)
    if [[ -z "$ADMIN_PASSWORD" ]]; then
	    read -p "ADMIN_PASSWORD is not set, Are You want To Generate random key ${ranadminPasswd}? [Y/n]:" ADMIN_PASSWORD_ANS
	    ADMIN_PASSWORD_ANS=${ADMIN_PASSWORD_ANS:-Y}

        if [[ "$ADMIN_PASSWORD_ANS" == [Yy] ]]; then
            ADMIN_PASSWORD=${ranadminPasswd}
        else
            while [ -z ${ADMIN_PASSWORD} ]; do
	            read -p "ADMIN_PASSWORD is not set, please enter strong value :" ADMIN_PASSWORD
            done
        fi
    fi

    if [[ -z "$ENABLE_TELEGRAM" ]]; then
	    read -p "ENABLE_TELEGRAM is not set, press enter to use default value [false]:" ENABLE_TELEGRAM
	    ENABLE_TELEGRAM=${ENABLE_TELEGRAM:-false}
    fi
    
    if [[ "$ENABLE_TELEGRAM" == "true" ]]; then

        while [ -z ${TELEGRAM_TOKEN} ]; do
	        read -p "TELEGRAM_TOKEN is not set, press enter correct telegram token value:" TELEGRAM_TOKEN
        done

        while [ -z ${TELEGRAM_CHAT_ID} ]; do
	        read -p "TELEGRAM_CHAT_ID is not set, press enter correct telegram chat id:" TELEGRAM_CHAT_ID
        done

        while [ -z ${TELEGRAM_BOT} ]; do
	        read -p "TELEGRAM_BOT is not set, press enter correct telegram chat bot:" TELEGRAM_BOT
        done

        if [[ -z "$TELEGRAM_LOGIN" ]]; then
	        read -p "TELEGRAM_LOGIN is not set, press enter to use default value [true]:" TELEGRAM_LOGIN
            TELEGRAM_LOGIN=${TELEGRAM_LOGIN:-true}
        fi

    fi

    ranApiKey=$(cat /dev/urandom | head -1 | md5sum | head -c 32)
    if [[ -z "$API_KEY" ]]; then
	    read -p "API_KEY is not set, Are You want To Generate random key ${ranApiKey}? [Y/n]:" API_KEY_ANS
	    API_KEY_ANS=${API_KEY_ANS:-Y}

        if [[ "$API_KEY_ANS" == [Yy] ]]; then
            API_KEY=${ranApiKey}
        else
            while [ -z ${API_KEY} ]; do
	            read -p "API_KEY is not set, please enter strong string :" API_KEY
            done
        fi
    fi


    ranMUKEY=$(cat /dev/urandom | head -1 | md5sum | head -c 10)
    if [[ -z "$MUKEY" ]]; then
	    read -p "MUKEY is not set, Are You want To Generate random key ${ranMUKEY}? [Y/n]:" MUKEY_ANS
	    MUKEY_ANS=${MUKEY_ANS:-Y}

        if [[ "$MUKEY_ANS" == [Yy] ]]; then
            MUKEY=${ranMUKEY}
        else
            while [ -z ${MUKEY} ]; do
	            read -p "MUKEY is not set, please enter strong string :" MUKEY
            done
        fi
    fi

    if [[ -z "$DEBUG" ]]; then
	    read -p "DEBUG is not set, press enter to use default value [false]:" DEBUG
	    DEBUG=${DEBUG:-false}
    fi

    if [[ -z "$TIME_ZONE" ]]; then
	    read -p "TIME_ZONE is not set, press enter to use default value or enter correct timezone value [Asia/Tehran]:" TIME_ZONE
	    TIME_ZONE=${TIME_ZONE:-Asia\/Tehran}
    fi

    if [[ -z "$GITHUB_ACCESS_TOKEN" ]]; then
	    read -p "GITHUB_ACCESS_TOKEN is not set, press enter correct token value:" GITHUB_ACCESS_TOKEN
    fi

    if [[ -z "$PANEL_IMAGE" ]]; then
	    read -p "PANEL_IMAGE is not set, press enter to using default value [ttracy/panel]:" XRAYR_IMAGE
	    PANEL_IMAGE=${PANEL_IMAGE:-ttracy\/panel}
    fi

    
    getDbContainer

}

function createDockerNetwork() {
  docker network create db
  docker network create panel
  docker network create front
  docker network create nodes
}

panelDockerComposeFile=${COMPOSE_ROOT}/docker-compose-panel.yaml  
function StartPanel(){
    if [ ! -f "$panelDockerComposeFile" ]; then
        echo "$panelDockerComposeFile not exists! exit..."
        exit
    fi
    green "pulling docker images"
    docker-compose -f ${panelDockerComposeFile} pull
    green "Starting docker images"
    docker-compose -f ${panelDockerComposeFile} down
    docker-compose -f ${panelDockerComposeFile} up -d
}

function configPanelDocker(){
    # panelDockerComposeFile=${COMPOSE_ROOT}/docker-compose-panel.yaml
    makePanelDir
    createDockerNetwork
    cat > "${panelDockerComposeFile}" <<-EOF
version: "2.1"

services:

  ${PANEL_CONTAINER_NAME}:
    image: ${PANEL_IMAGE}
    env_file:
      - ${ENV_FILE}
    container_name: "${PANEL_CONTAINER_NAME}"
    restart: always
    ports:
      - "${PANEL_NON_SSL_PORT}:80"
      - "${PANEL_SSL_PORT}:443"
    networks:
      - panel
      - db
    volumes:
      - ${PROJ_ROOT}/etc/${PANEL_CONTAINER_NAME}/logs:/var/www/log
      - ${PROJ_ROOT}/etc/${PANEL_CONTAINER_NAME}/logs/nginx:/var/log/nginx
      - ${PROJ_ROOT}/etc/nginx/ssl/${PANEL_DOMAIN}:/etc/nginx/ssl/${PANEL_DOMAIN}:ro
    #   - ${PROJ_ROOT}/etc/${PANEL_CONTAINER_NAME}/conf/:/var/www/conf
    depends_on:
      ${DB_HOST}:
        condition: service_healthy
    environment:
      API_KEY: ${API_KEY}
      APP_NAME: ${APP_NAME}
      PANEL_DOMAIN: "${PANEL_DOMAIN}"
      MUKEY: ${MUKEY}
      ADMIN_EMAIL: ${ADMIN_EMAIL}
      ADMIN_PASSWORD: ${ADMIN_PASSWORD}
      DEBUG: "${DEBUG}"
      TIME_ZONE: ${TIME_ZONE}
      STREAMING_UNLOCK: ${STREAMING_UNLOCK}
      GITHUB_ACCESS_TOKEN: ${GITHUB_ACCESS_TOKEN}
      ENABLE_TELEGRAM: "${ENABLE_TELEGRAM}"
      TELEGRAM_TOKEN: ${TELEGRAM_TOKEN}
      TELEGRAM_CHAT_ID: ${TELEGRAM_CHAT_ID}
      TELEGRAM_BOT: ${TELEGRAM_BOT}
      TELEGRAM_LOGIN: ${TELEGRAM_LOGIN}
      DB_HOST: ${DB_HOST}
      DB_PORT: ${DB_PORT}
      DB_DATABASE: ${DB_DATABASE}
      DB_PASSWORD: ${DB_PASSWORD}
      DB_USERNAME: ${DB_USERNAME}
    ${panelContainerTraefikLink}
  ${dbcomposetemp}
#   BACKUP:
#     image: phpmyadmin
#     container_name: BACKUP
#     links:
#        - ${DB_HOST}:${DB_HOST}
#     environment:
#       - CUSTOM_ENV_VAR=foobar
#     volumes:
#       - ${PROJ_ROOT}/backup/ubuntu-crontab-example.txt:/etc/crontab

networks:
  front:
    external: true
  nodes:
    external: true
  panel:
    external: true
  db:
    external: true

EOF

}






acmeDockerComposeFile=${COMPOSE_ROOT}/docker-compose-acme.yaml
reverseDockerComposeFile=${COMPOSE_ROOT}/docker-compose-reverse.yaml
ReverseProxyDefaultConf=${NGINX_ROOT}/conf/nginx.conf
ReverseProxyConfD=${NGINX_ROOT}/conf.d/default.conf
ReverseProxyExtra=${NGINX_ROOT}/extra
ReverseProxySelfSSL=${NGINX_ROOT}/ssl/self



function addReverseProxyConfigsNginx() {
    addReverseProxyDefaultConf
    addReverseProxyDefaultConfD
    addReverseProxyXrayConf
    addReverseProxyDefLinkConf
    addReverseProxyCommonConf
    addReverseProxyCfRealIp
    addReverseProxyArRealIp
}

function addReverseProxyDefaultConfD() {
  openssl req \
  -subj '/O=Google Inc/CN=google.com/C=US' \
  -new -newkey rsa:2048 -sha256 -days 365 -nodes -x509 -keyout \
  ${ReverseProxySelfSSL}/server.key -out ${ReverseProxySelfSSL}/server.crt

    cat > "${ReverseProxyConfD}" <<-EOF
server {
    listen 80 default_server;
    listen 443 http2 default_server;
    server_name _;
    sendfile off;
    root /var/www/public;
    index index.php index.html;

    ssl_certificate ${ReverseProxySelfSSL}/server.crt;
    ssl_certificate_key ${ReverseProxySelfSSL}/server.key;

    return 400;
}
EOF
}

function addReverseProxyArRealIp() {
    cat > "${ReverseProxyExtra}/ar_real_ip.conf" <<-EOF
set_real_ip_from 2.146.0.0/28;
set_real_ip_from 46.224.2.32/29;
set_real_ip_from 92.114.16.80/28;
set_real_ip_from 185.143.232.0/22;
set_real_ip_from 89.187.178.96/29;
set_real_ip_from 89.187.169.88/29;
set_real_ip_from 195.181.173.128/29;
set_real_ip_from 188.229.116.16/29;
set_real_ip_from 164.138.128.28/31;
set_real_ip_from 83.123.255.56/31;
set_real_ip_from 94.182.182.28/30;
set_real_ip_from 185.17.115.176/30;
set_real_ip_from 5.213.255.36/31;
set_real_ip_from 188.122.83.176/29;
set_real_ip_from 213.179.201.192/29;
set_real_ip_from 138.128.139.144/29;
set_real_ip_from 5.200.14.8/29;
set_real_ip_from 188.122.78.136/29;
set_real_ip_from 213.179.197.16/29;
set_real_ip_from 185.179.201.192/29;
set_real_ip_from 188.122.68.224/29;
set_real_ip_from 43.239.139.192/29;
set_real_ip_from 213.179.217.16/29;
set_real_ip_from 103.194.164.24/29;
set_real_ip_from 185.50.105.136/29;
set_real_ip_from 213.179.211.32/29;
set_real_ip_from 138.128.141.16/29;
set_real_ip_from 162.244.52.120/29;
set_real_ip_from 213.179.213.16/29;
set_real_ip_from 109.200.214.248/29;
set_real_ip_from 188.122.80.240/29;
set_real_ip_from 109.200.195.64/29;
set_real_ip_from 109.200.199.224/29;
set_real_ip_from 185.228.238.0/28;
set_real_ip_from 94.182.153.24/29;
set_real_ip_from 94.101.182.0/27;
set_real_ip_from 37.152.184.208/28;
set_real_ip_from 78.39.156.192/28;
set_real_ip_from 158.255.77.238/31;
set_real_ip_from 81.12.28.16/29;
set_real_ip_from 176.65.192.202/31;
set_real_ip_from 2.144.3.128/28;
set_real_ip_from 89.45.48.64/28;
set_real_ip_from 37.32.16.0/27;
set_real_ip_from 37.32.17.0/27;
set_real_ip_from 37.32.18.0/27;
set_real_ip_from 169.150.206.149/32;
set_real_ip_from 89.187.187.59/32;
set_real_ip_from 138.199.46.196/32;
set_real_ip_from 37.32.19.0/27;
set_real_ip_from 185.247.68.64/29;
set_real_ip_from 146.70.154.64/29;
set_real_ip_from 62.133.44.8/29;
set_real_ip_from 146.70.86.152/29;
set_real_ip_from 146.70.139.96/29;
set_real_ip_from 192.145.125.144/29;
set_real_ip_from 89.187.169.90/32;
set_real_ip_from 185.215.232.0/22;
set_real_ip_from 185.17.113.216/30;
set_real_ip_from 185.17.113.208/30;


real_ip_header ar-real-ip;

EOF
}


function addReverseProxyCfRealIp() {
    cat > "${ReverseProxyExtra}/cf_real_ip.conf" <<-EOF
set_real_ip_from 103.21.244.0/22;
set_real_ip_from 103.22.200.0/22;
set_real_ip_from 103.31.4.0/22;
set_real_ip_from 104.16.0.0/12;
set_real_ip_from 108.162.192.0/18;
set_real_ip_from 131.0.72.0/22;
set_real_ip_from 141.101.64.0/18;
set_real_ip_from 162.158.0.0/15;
set_real_ip_from 172.64.0.0/13;
set_real_ip_from 173.245.48.0/20;
set_real_ip_from 188.114.96.0/20;
set_real_ip_from 190.93.240.0/20;
set_real_ip_from 197.234.240.0/22;
set_real_ip_from 198.41.128.0/17;
set_real_ip_from 2400:cb00::/32;
set_real_ip_from 2606:4700::/32;
set_real_ip_from 2803:f800::/32;
set_real_ip_from 2405:b500::/32;
set_real_ip_from 2405:8100::/32;
set_real_ip_from 2c0f:f248::/32;
set_real_ip_from 2a06:98c0::/29;

real_ip_header CF-Connecting-IP;

EOF
}

function addReverseProxyCommonConf() {
    cat > "${ReverseProxyExtra}/common.conf" <<-EOF
if (\$request_uri ~ "^/redirect/(.*)(%3A%2F%2F|://)(.*)\$") {
  return 307 \$1://\$3;
}

location /ghr/ {
  #for proxy github raw
  proxy_set_header Host raw.githubusercontent.com;
  proxy_pass https://raw.githubusercontent.com:443/;
}

location /gho/ {
  #for proxy github object
  proxy_set_header Host objects.githubusercontent.com;
  proxy_pass https://objects.githubusercontent.com:443/;
}

location /gh/ {
  #for proxy github
  proxy_set_header Host github.com;
  proxy_pass https://github.com:443/;
  proxy_redirect https://raw.githubusercontent.com/ https://\$host/ghr/;
  proxy_redirect https://objects.githubusercontent.com/ https://\$host/gho/;

  proxy_set_header Accept-Encoding "";
  sub_filter_once off;
  sub_filter    https://github.com/ /gh/;
  sub_filter    href="/ href="/gh/;
  sub_filter    src="/ src="/gh/;
}

location /dns/ {
  # use it in your browser as https://defaultserverhost/dns/dns-query{?dns}
  proxy_pass https://dns.google:443/; 
}

resolver 8.8.8.8;

EOF
}

function addReverseProxyDefLinkConf() {
    cat > "${ReverseProxyExtra}/def-link.conf" <<-EOF

location / {
   proxy_pass http://TRAEFIK:$TRAEFIK_ENTRY_POINT_PORT;
   proxy_ssl_server_name on;
   proxy_ssl_name \$http_host;
   proxy_set_header Upgrade \$http_upgrade;
   proxy_set_header Connection "upgrade";
   proxy_set_header Host \$http_host;
   proxy_set_header X-Real-IP \$remote_addr;
   proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
}

location /dashboard {
   proxy_pass http://TRAEFIK:$TRAEFIK_DASHBOARD_ENTRY_POINT_PORT;
   proxy_ssl_server_name on;
   proxy_ssl_name \$http_host;
   proxy_set_header Upgrade \$http_upgrade;
   proxy_set_header Connection "upgrade";
   proxy_set_header Host \$http_host;
   proxy_set_header X-Real-IP \$remote_addr;
   proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
}

EOF
}

function addReverseProxyXrayConf() {
    cat > "${ReverseProxyExtra}/xray.conf" <<-EOF
location ~* ^/(?<prefix>.+-)?(?<type>ss|tr|vm|vl)(?<trans>ws|pc|tc)/?\$ {

    if (\$type = "vm") {
        set \$fall "\${trans}vm";
    }

    if (\$type = "ss") {
        set \$fall "\${trans}ss";
    }
    
    if (\$content_type !~ "application/grpc") {
        set \$fall "\${fall}gr";
    }
    
    if (\$content_type !~ "websocket") {
        set \$fall "\${fall}ws";
    }
    
    if (\$fall = "wsvmws") {
      return 404;
    }

    if (\$fall = "pcvmgr") {
      return 404;
    }
    
    if (\$fall = "wsssws") {
      return 404;
    }

    if (\$fall = "pcssgr") {
      return 404;
    }

    set \$sub "\$type-\$trans";

    grpc_connect_timeout 60s;
    grpc_read_timeout 720m;
    grpc_send_timeout 720m;
    grpc_set_header Host \$host;
    grpc_set_header X-Real-IP \$remote_addr;
    grpc_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;

    proxy_redirect off;
    proxy_http_version 1.1;
    proxy_set_header Upgrade \$http_upgrade;
    proxy_set_header Connection "upgrade";
    proxy_set_header Host \$host;
    proxy_set_header X-Real-IP \$remote_addr;
    proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;

    if (\$trans = "pc") {
      grpc_pass grpc://\$sub.TRAEFIK:$TRAEFIK_ENTRY_POINT_PORT;
	  }

    if (\$trans = "ws") {
      proxy_pass http://\$sub.TRAEFIK:$TRAEFIK_ENTRY_POINT_PORT;
	  }

    if (\$trans = "tc") {
      proxy_pass http://\$sub.TRAEFIK:$TRAEFIK_ENTRY_POINT_PORT;
	  }

}

EOF
}

function addReverseProxyDefaultConf() {
    cat > "${ReverseProxyDefaultConf}" <<-EOF
user root;
worker_processes  1;
error_log  /var/log/nginx/error.log warn;
pid        /var/run/nginx.pid;
events {
    worker_connections  1024;
}

http {
    include       /etc/nginx/mime.types;
    default_type  application/octet-stream;
    log_format  main  '\$remote_addr - \$remote_user [\$time_local] '
                      '"\$request" \$status \$body_bytes_sent  '
                      '"\$http_referer" "\$http_user_agent" "\$http_x_forwarded_for"';
    
    log_format  proxy '[\$time_local] \$proxy_protocol_addr '
                 '\$upstream_addr \$status \$bytes_sent \$request_length \$request_time';

    access_log  \$nginxAccessLogFilePath  proxy;
    error_log \$nginxErrorLogFilePath;
    sendfile        on;
    #tcp_nopush     on;
    client_max_body_size 20m;
    gzip  on;
    ssl_protocols TLSv1 TLSv1.1 TLSv1.2 TLSv1.3; # Dropping SSLv3, ref: POODLE
    ssl_prefer_server_ciphers on;
    ssl_ciphers ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:DHE-RSA-AES128-GCM-SHA256:DHE-RSA-AES256-GCM-SHA384;
	  client_header_timeout 52w;
    keepalive_timeout 52w;
    include /etc/nginx/conf.d/*.conf;
}
EOF
}

ACME_CONTAINER_NAME=acme.sh
function installAcmeContainer() {

  if [[ ! -z "$1" ]]; then
    ACME_DOMAIN=$1
  fi
  
  while [[ -z "$ACME_DOMAIN" ]]; do
	    read -p " ACME_DOMAIN not set . please enter domain to get ssl certificate" ACME_DOMAIN
  done


  makeDirIfNotExist "${PROJ_ROOT}/etc/nginx/templates-initiate"
  cat > "${PROJ_ROOT}/etc/nginx/templates-initiate/default.conf.template" <<-EOF
server {
    listen       80;
    listen  [::]:80;
    server_name  localhost;

    #access_log  /var/log/nginx/host.access.log  main;

    location / {
        root   /usr/share/nginx/html;
        index  index.html index.htm;
    }

    #error_page  404              /404.html;

    # redirect server error pages to the static page /50x.html
    #
    error_page   500 502 503 504  /50x.html;
    location = /50x.html {
        root   /usr/share/nginx/html;
    }

    location ~ /.well-known/acme-challenge {
        allow all;
        root /acme.sh;
    }
}


EOF



    cat > "${acmeDockerComposeFile}" <<-EOF
version: "2.1"

services:

  ${ACME_CONTAINER_NAME}:
    image: ttracy/acme.sh
    container_name: ${ACME_CONTAINER_NAME} 
    command: daemon
    networks:
      - front
    environment:
        - DEPLOY_DOCKER_CONTAINER_LABEL="sh.acme.autoload.domain"
        - DEPLOY_DOCKER_CONTAINER_KEY_FILE="/etc/nginx/ssl/${ACME_DOMAIN}/${ACME_DOMAIN}.key"
        - DEPLOY_DOCKER_CONTAINER_CERT_FILE="/etc/nginx/ssl/${ACME_DOMAIN}/${ACME_DOMAIN}.cer"
        - DEPLOY_DOCKER_CONTAINER_CA_FILE="/etc/nginx/ssl/${ACME_DOMAIN}/ca.cer"
        - DEPLOY_DOCKER_CONTAINER_FULLCHAIN_FILE="/etc/nginx/ssl/${ACME_DOMAIN}/fullchain.cer"
        - DEPLOY_DOCKER_CONTAINER_RELOAD_CMD="service nginx force-reload"
    volumes:
      - /usr/share/zoneinfo/Asia/Tehran:/etc/localtime:ro
      - ${PROJ_ROOT}/etc/acme:/acme.sh
      - ${PROJ_ROOT}/etc/nginx/ssl:/etc/nginx/ssl
      - /var/run/docker.sock:/var/run/docker.sock
  nginx-acme-temp:
    container_name: nginx-acme-temp
    image: nginx:latest
    ports:
      - 80:80
    labels:
      - "sh.acme.autoload.domain"
    volumes:
      - ${PROJ_ROOT}/etc/nginx/templates-initiate:/etc/nginx/templates
      - ${PROJ_ROOT}/etc/nginx/ssl:/etc/nginx/ssl
      - ${PROJ_ROOT}/etc/acme:/acme.sh

networks:
  front:
    external: true
EOF
    docker-compose -f ${acmeDockerComposeFile} pull
    docker-compose -f ${acmeDockerComposeFile} down
    docker-compose -f ${acmeDockerComposeFile} up -d
}
traefik_static_conf=${PROJ_ROOT}/traefik/configs/traefik.yml
traefik_dynamic_conf=${PROJ_ROOT}/traefik/configs/dynamic

function addReverseProxyConfigs() {

  while [[ -z "$CERT_EMAIL" ]]; do
    read -p "CERT_EMAIL is not set? Please enter Email to contact you :" CERT_EMAIL
  done
    
  cat > "${traefik_static_conf}" <<-EOF
## static configuration

global:
  # Send anonymous usage data
  sendAnonymousUsage: false

entryPoints:
  web:
    address: ":80"
    forwardedHeaders:
      insecure: true
      trustedIPs:
        - "127.0.0.1/32"
    proxyProtocol:
      insecure: true
      trustedIPs:
        - "127.0.0.1/32"
  websecure:
    address: ":443"
    forwardedHeaders:
      insecure: true
      trustedIPs:
        - "127.0.0.1/32"
    proxyProtocol:
      insecure: true
      trustedIPs:
        - "127.0.0.1/32"


log:
  filePath: "/var/log/traefik.log"
  format: json
  level: ERROR

# Access logs
# Limiting the Logs to Specific Fields
accessLog:
  filePath: "/var/log/traefik_access.log"
  format: json
  # fields:
  #   defaultMode: keep
  #   names:
  #     ClientUsername: drop
  #   headers:
  #     defaultMode: keep
  #     names:
  #         User-Agent: redact
  #         Authorization: drop
  #         Content-Type: keep

providers:
  docker:
    endpoint: "unix:///var/run/docker.sock"
    exposedByDefault: false
  file:
    directory: /etc/traefik/dynamic
    watch: true

certificatesResolvers:
  letsencrypt:
    acme:
      certificatesDuration: 
      email: ${CERT_EMAIL}
      keyType: EC384
      preferredChain: 'ISRG Root X1'
      tlschallenge: true
      httpchallenge:
        entrypoint: web
      storage: /etc/traefik/acme/acme-letsencrypt.json

  arvancloud:
    acme:
      certificatesDuration: 
      email: ${CERT_EMAIL}
      storage: /etc/traefik/acme/acme-arvan.json
      keyType: EC384
      preferredChain: 'ISRG Root X1'
      dnsChallenge:
        provider: arvancloud
        delayBeforeCheck: 1

          
  cloudflare:
    acme:
      certificatesDuration: 
      email: ${CERT_EMAIL}
      storage: /etc/traefik/acme/acme-cloudflare.json
      keyType: EC384
      preferredChain: 'ISRG Root X1'
      dnsChallenge:
        provider: cloudflare
        resolvers:
          - "1.1.1.1:53"

  zerossl:
    acme:
      caServer: https://acme.zerossl.com/v2/DV90
      email: ${CERT_EMAIL}
      storage: /etc/traefik/acme/acme-zerossl.json
      dnsChallenge:
        provider: cloudflare
        resolvers:
          - "1.1.1.1:53"
          - "1.0.0.1:53"
      eab:
        kid: abc123xyz
        hmacEncoded: abc123xzy

  zerossl:
    acme:
      keyType: EC384
      preferredChain: 'ISRG Root X1'
      email: ${CERT_EMAIL}
      storage: /etc/traefik/acme/acme-zerossl.json

      dnsChallenge:
        provider: cloudflare
        resolvers:
          - "1.1.1.1:53"
          - "1.0.0.1:53"
      caServer: buypass.acme.caserver=https://api.buypass.com/acme/directory
      eab:
        kid: abc123xyz
        hmacEncoded: abc123xzy

  ${acmeSSLServerName}:
    acme:
      keyType: EC384
      preferredChain: 'ISRG Root X1'
      email: ${CERT_EMAIL}
      storage: /etc/traefik/acme/acme-${acmeSSLServerName}.json

      dnsChallenge:
        provider: cloudflare
        resolvers:
          - "1.1.1.1:53"
          - "1.0.0.1:53"
      caServer: buypass.acme.caserver=https://api.buypass.com/acme/directory
      eab:
        kid: abc123xyz
        hmacEncoded: abc123xzy

api:
  dashboard: true

EOF

cat > "${traefik_dynamic_conf}/dashboard.yml" <<-EOF
http:
  routers:
    traefik:
      rule: Host(`reverse-proxy.somedomain.com`)
      entryPoints:
        - websecure
      service: api@internal
      middlewares:
        - dashboardauth
      tls:
        certResolver: letsencrypt
    traefik-http-redirect:
      rule: Host(`reverse-proxy.somedomain.com`)
      entryPoints:
        - web
      service: api@internal
      middlewares:
        - "redirect-to-https"
  middlewares:
    dashboardauth:
      basicAuth:
        users:
          - "user1:$2y$05$/x10KYbrHtswyR8POT.ny.H4fFd1n.0.IEiYiestWzE1QFkYIEI3m"
EOF

cat > "${traefik_dynamic_conf}/global-middlewares.yml" <<-EOF
http:
  middlewares:
    redirect-to-https:
      redirectScheme:
        scheme: https
        permanent: true
    secureHeaders:
      headers:
        sslRedirect: true
        forceSTSHeader: true
        stsIncludeSubdomains: true
        stsPreload: true
        stsSeconds: 31536000
    hsts-minimal:
      headers:
        stsSeconds: 31536000
        stsIncludeSubdomains: false
        stsPreload: false
        forceSTSHeader: true
    hsts-standard:
      headers:
        stsSeconds: 31536000
        stsIncludeSubdomains: true
        stsPreload: false
        forceSTSHeader: true
    hsts-full:
      headers:
        stsSeconds: 31536000
        stsIncludeSubdomains: true
        stsPreload: true
        forceSTSHeader: true
EOF

cat > "${traefik_dynamic_conf}/tls.yml" <<-EOF
tls:
  options:
    default:
      cipherSuites:
        - TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384
        - TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        - TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256
        - TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        - TLS_ECDHE_ECDSA_WITH_CHACHA20_POLY1305
        - TLS_ECDHE_RSA_WITH_CHACHA20_POLY1305
        - TLS_AES_128_GCM_SHA256
        - TLS_AES_256_GCM_SHA384
        - TLS_AES_128_CCM_8_SHA256:
        - TLS_AES_128_CCM_SHA256:
        - TLS_CHACHA20_POLY1305_SHA256
      minVersion: VersionTLS12
    mintls13:
      minVersion: VersionTLS13
EOF



}

acmeSSLRegisterEmailInput=""
isDomainSSLEABKeyInput=""
isDomainSSLEABIdInput=""

function getHTTPSCertificateCheckEmail(){
    if [ -z $2 ]; then
        
        if [[ $1 == "email" ]]; then
            red " The input email address cannot be empty, please re-enter !"
            getHTTPSCertificateInputEmail
        elif [[ $1 == "EabKey" ]]; then
            red " Enter EAB key can not be empty, please re-enter !"
            getHTTPSCertificateInputEABKey
        elif [[ $1 == "EabId" ]]; then
            red " Enter EAB Id cannot be empty, please re-enter !"
            getHTTPSCertificateInputEABId            
        fi
    fi
}
function getHTTPSCertificateInputEmail(){
    echo
    read -r -p "Please enter your email address to apply for a SSL certificate:" acmeSSLRegisterEmailInput
    getHTTPSCertificateCheckEmail "email" "${acmeSSLRegisterEmailInput}"
}
function getHTTPSCertificateInputEABKey(){
    echo
    read -r -p "Please enter EAB key :" isDomainSSLEABKeyInput
    getHTTPSCertificateCheckEmail "EabKey" "${isDomainSSLEABKeyInput}"
}
function getHTTPSCertificateInputEABId(){
    echo
    read -r -p "please enter EAB id :" isDomainSSLEABIdInput
    getHTTPSCertificateCheckEmail "EabId" "${isDomainSSLEABIdInput}"
}


acmeSSLDays="89"
acmeSSLServerName="letsencrypt"
acmeSSLDNSProvider="dns_cf"

acmeSSLDaysInHours=${acmeSSLDays} * 24
getHTTPSCertificateInputEmail
  ${acmeSSLServerName}:
    acme:
      keyType: EC384
      preferredChain: 'ISRG Root X1'
      email: ${acmeSSLRegisterEmailInput}
      storage: /etc/traefik/acme/acme-${acmeSSLServerName}.json
      certificatesDuration: ${acmeSSLDaysInHours}

      dnsChallenge:
        provider: ${acmeSSLDNSProvider}
        resolvers:
          - "1.1.1.1:53"
          - "1.0.0.1:53"
      caServer: ${caServer}
      eab:
        kid: ${isDomainSSLEABIdInput}
        hmacEncoded: ${isDomainSSLEABKeyInput}




    echo
    green " ================================================== "
    green " Domain Name : ${configSSLDomain}"
    green " Please select a certificate provider, the default is to apply for a certificate through Letsencrypt.org "
    green " If the certificate application fails, such as too many applications through Letsencrypt.org in one day, you can choose BuyPass.com or ZeroSSL.com to apply."
    green " 1 Letsencrypt.org "
    green " 2 BuyPass.com "
    green " 3 ZeroSSL.com "
    green " 4 Google Public CA "
    green " 5 SSL.com "
    echo
    read -r -p "Please select a certificate provider? The default is to apply through Letsencrypt.org, please enter pure numbers:" isDomainSSLFromLetInput
    isDomainSSLFromLetInput=${isDomainSSLFromLetInput:-1}
        
    if [[ "$isDomainSSLFromLetInput" == "2" ]]; then

        acmeSSLDays="179"
        acmeSSLServerName="buypass"
        caServer=https://api.buypass.com/acme/directory
        # caTestServer=https://api.test4.buypass.no/acme/directory
        
            
    elif [[ "$isDomainSSLFromLetInput" == "3" ]]; then

        acmeSSLServerName="zerossl"
        getHTTPSCertificateInputEABKey
        getHTTPSCertificateInputEABId
        caServer=https://acme.zerossl.com/v2/DV90
        

    elif [[ "$isDomainSSLFromLetInput" == "4" ]]; then
        green " ================================================== "
        yellow " Please follow the link below to apply google Public CA  https://hostloc.com/thread-993780-1-1.html"
        yellow " For details, please refer to https://github.com/acmesh-official/acme.sh/wiki/Google-Public-CA"

        acmeSSLServerName="google"
        getHTTPSCertificateInputEABKey
        getHTTPSCertificateInputEABId
        caServer=https://dv.acme-v02.api.pki.goog/directory
        # caTestServer=https://dv.acme-v02.test-api.pki.goog/directory
         
    elif [[ "$isDomainSSLFromLetInput" == "5" ]]; then
        green " ================================================== "
        yellow " Please follow the link below to apply google Public CA  https://hostloc.com/thread-993780-1-1.html"
        yellow " For details, please refer to https://github.com/acmesh-official/acme.sh/wiki/Google-Public-CA"

        acmeSSLServerName="sslcom"
        getHTTPSCertificateInputEABKey
        getHTTPSCertificateInputEABId
        caServer=https://acme.ssl.com/sslcom-dv-rsa, https://acme.ssl.com/sslcom-dv-ecc
         
    else
        acmeSSLServerName="letsencrypt"
        caServer=https://acme-v02.api.letsencrypt.org/directory
        # caTestServer=https://acme-staging-v02.api.letsencrypt.org/directory
    fi

    echo
    green " ================================================== "
    green "Please select the acme.sh script to apply for the SSL certificate method: 1 http method, 2 dns method "
    green " The default is to press Enter directly to apply for http, otherwise it is to use dns"
    echo
    read -r -p "Please select an SSL certificate application method, default is http . are you want using default? [Y/n]:" isAcmeSSLRequestMethodInput
    isAcmeSSLRequestMethodInput=${isAcmeSSLRequestMethodInput:-Y}
    echo

    if [[ $isAcmeSSLRequestMethodInput == [Yy] ]]; then

        echo
        green " Start requesting certificate acme.sh via http standalone mode from ${acmeSSLServerName} To apply, please make sure that port 80 is not occupied "
        echo
        docker exec acme.sh --issue --webroot /acme.sh --keylength ec-256 --days ${acmeSSLDays} --server ${acmeSSLServerName} -d ${configSSLDomain}
    else
        green " Start to apply for a certificate, acme.sh applies through dns mode "

        echo
        green "Please select DNS provider DNS provider: 1 CloudFlare, 2 Arvan,  3 DNSPod(Tencent), 4 GoDaddy "
        red "Note that CloudFlare no longer supports using API to apply for DNS certificates for some free domain names such as .tk .cf, etc. "
        echo
        read -r -p "Please select a DNS provider? The default is 1. CloudFlare, please enter pure numbers:" isAcmeSSLDNSProviderInput
        isAcmeSSLDNSProviderInput=${isAcmeSSLDNSProviderInput:-1}    

            
        if [ "$isAcmeSSLDNSProviderInput" == "2" ]; then
            read -r -p "Please Input Arvan Token: " Arvan_Token
            acmeSSLDNSProvider="dns_arvan"
            
        elif [ "$isAcmeSSLDNSProviderInput" == "3" ]; then
            read -r -p "Please Input DNSPod API ID: " DP_Id
            read -r -p "Please Input DNSPod API Key: " DP_Key
            acmeSSLDNSProvider="dns_dp"

        elif [ "$isAcmeSSLDNSProviderInput" == "4" ]; then
            read -r -p "Please Input GoDaddy API Key: " gd_Key
            read -r -p "Please Input GoDaddy API Secret: " gd_Secret
            acmeSSLDNSProvider="dns_gd"

        else
            read -r -p "Please Input CloudFlare Email: " cf_email
            read -r -p "Please Input CloudFlare Global API Key: " cf_key
            acmeSSLDNSProvider="dns_cf"
            
        fi
    fi
function installReverseProxy() {
    makeTraefiklDir
    addReverseProxyConfigs
    cat > "${reverseDockerComposeFile}" <<-EOF
version: '3.8'
networks:
  routing:
    driver: bridge
services:
  traefik:
    image: traefik:2.9.1
    restart: always
    container_name: reverse_proxy_traefik
    ports:
      - "80:80"
      - "443:443"
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
      - ${PROJ_ROOT}/traefik/configs/traefik.yml:/etc/traefik/traefik.yml
      - ${PROJ_ROOT}/traefik/configs/dynamic:/etc/traefik/dynamic
      - ${PROJ_ROOT}/traefik/certificates/acme.json:/etc/traefik/acme/acme.json
      - ${PROJ_ROOT}/traefik/logs/traefik_access.log:/var/log/traefik_access.log
      - ${PROJ_ROOT}/traefik/logs/traefik.log:/var/log/traefik.log
    networks:
      - routing
EOF
  checkReverseProxy
}


function installReverseProxyNginx() {
    CheckReverseProxyEnv
    makeDefDir
    addReverseProxyConfigsNginx
    cat > "${reverseDockerComposeFile}" <<-EOF
version: "2.1"

services:

  ${TRAEFIK_CONTAINER_NAME}:
    image: "traefik:v2.9"
    container_name: ${TRAEFIK_CONTAINER_NAME}
    networks:
      - front
      - nodes
      - panel
    command:
      - "--log.level=DEBUG"
      - "--api.insecure=true"
      - "--api.dashboard=true"
      - "--api.debug=true"
      - "--log.level=DEBUG"
      - "--log.filePath=/var/log/traefik/traefik.log"
      - "--accessLog=/var/log/traefik/access.log"
      - "--providers.docker=true"
      - "--providers.docker.exposedbydefault=false"
      - "--entrypoints.web.address=:1080"
      - "--entrypoints.web.forwardedHeaders.insecure=true"
      - "--entrypoints.web.forwardedHeaders.trustedIPs=127.0.0.1/32"
      - "--entrypoints.web.ProxyProtocol.insecure=true"
      - "--entrypoints.web.ProxyProtocol.trustedIPs=127.0.0.1/32"
    # labels:
      - "traefik.http.routers.dashboard.rule=Host(\`traefik.localhost\`)"
      - "traefik.http.services.dashboard.loadbalancer.server.port=8080"
    ports:
      - "${TRAEFIK_ENTRY_POINT_PORT}:${TRAEFIK_ENTRY_POINT_PORT}"
      - "${TRAEFIK_DASHBOARD_ENTRY_POINT_PORT}:${TRAEFIK_DASHBOARD_ENTRY_POINT_PORT}"
    volumes:
      - ${PROJ_ROOT}/etc/traefik/logs:/var/log/traefik
      - "/var/run/docker.sock:/var/run/docker.sock:ro"
  ${NGINX_REVERSE_CONTAINER_NAME}:
    container_name: ${NGINX_REVERSE_CONTAINER_NAME}
    image: nginx:latest
    restart: unless-stopped
    networks:
      - front
    labels:
      - "sh.acme.autoload.domain: ${NGINX_REVERSE_CONTAINER_NAME}"
    external_links:
       - ${TRAEFIK_CONTAINER_NAME}:TRAEFIK
    ports:
      - 80:80
      - 443:443
    volumes:
      - ${PROJ_ROOT}/etc/nginx/logs:/var/log/nginx
      - ${PROJ_ROOT}/etc/nginx/ssl:/etc/nginx/ssl
      - ${PROJ_ROOT}/etc/nginx/conf.d:/etc/nginx/conf.d
      - ${PROJ_ROOT}/etc/nginx/extra:${PROJ_ROOT}/nginx/extra
      # - ${PROJ_ROOT}/etc/nginx/templates/nginx.conf:/etc/nginx/nginx.conf
      # - ${PROJ_ROOT}/etc/nginx/templates:/etc/nginx/templates:ro

networks:
  front:
    external: true
  nodes:
    external: true
  panel:
    external: true
EOF
  checkReverseProxyNginx
}

function getPanelType() {
  tmpPANEL_NON_SSL_PORT="$(($RANDOM + 10000))"
  tmpPANEL_SSL_PORT="$(($RANDOM + 10000))"
  clear
  echo
  yellow Panel Route Type is not set
  green " Are you want install panel behind the traefik ?"
  green " 1. Yes, Install panel behind the traefik"
  green " 2. NO, Panel Only"

    read -p "Please input number:" menuNumberInput
    case "$menuNumberInput" in
        
        1 )
            PANEL_NON_SSL_PORT=80
            # if [[ -z "$PANEL_NON_SSL_PORT" ]]; then
            #   read -p "PANEL_NON_SSL_PORT is not set . press enter for random port, else please enter custom port [$tmpPANEL_NON_SSL_PORT]:" PANEL_NON_SSL_PORT
            #   PANEL_NON_SSL_PORT=${PANEL_NON_SSL_PORT:-$tmpPANEL_NON_SSL_PORT}
            # fi
            while [[ -z "$PANEL_DOMAIN" ]]; do
              read -p "PANEL_DOMAIN is not set . press enter for correct domain:" PANEL_DOMAIN
            done
            testPortUsage ${PANEL_NON_SSL_PORT}
            # PANEL_SSL_PORT=${PANEL_NON_SSL_PORT}
            # IS_SSL=false
            PANEL_HOST=https://${PANEL_CONTAINER_NAME}
            rm -rf $reverseDockerComposeFile
            checkReverseProxy
            addNginxNewDomainConf ${PANEL_DOMAIN}

      read -r -d '' panelContainerTraefikLink << EOM
labels:
  - "traefik.enable=true"
  # https
  - "traefik.http.routers.${PANEL_CONTAINER_NAME}.rule=Host(`${PANEL_DOMAIN}`)"
  - "traefik.http.routers.${PANEL_CONTAINER_NAME}.tls=true"
  - "traefik.http.routers.${PANEL_CONTAINER_NAME}.tls.certresolver=letsencrypt"
  - "traefik.http.routers.${PANEL_CONTAINER_NAME}.entrypoints=websecure"
  # http (redirect to https)
  - "traefik.http.routers.${PANEL_CONTAINER_NAME}-http.rule=Host(`${PANEL_DOMAIN}`)"
  - "traefik.http.routers.${PANEL_CONTAINER_NAME}-http.entrypoints=web"
  - "traefik.http.routers.${PANEL_CONTAINER_NAME}-http.middlewares=redirect-to-https@file"
  - "traefik.http.services.${PANEL_CONTAINER_NAME}.loadbalancer.server.port=80
EOM

        ;;
        
        2 )
            clear
            echo
            green "installing mode: Panel Only"
            while [ -z ${PANEL_DOMAIN} ]; do
              echo
              green " ================================================== "
              yellow " Please enter the domain name that resolves to this VPS, such as www.xxx.com: (In this step, please close the CDN and install it after nginx to avoid the failure to apply for a certificate due to port 80 occupation)"
              read -p "Please enter the domain name that resolves to this VPS:" PANEL_DOMAIN
            done

            if compareRealIpWithLocalIp "${PANEL_DOMAIN}" ; then
                echo
            else
                exit
            fi

            if [[ -z "$IS_SSL" ]]; then
              echo
              yellow IS_SSL is not set
              green " Are you want get and install SSL Certificate For Panel Domain: ${PANEL_DOMAIN} ?"
              green " 1. Sure(SSL Recomended)"
              green " 2. No, Thanks (HTTP Not Safe)"
              read -p "Please input number:" menuNumberInput2
              yellow PORTS is not set
              green " Please select port number ?"
              green " 1. 80/443"
              green " 2. random ports ${tmpPANEL_NON_SSL_PORT}/${tmpPANEL_SSL_PORT}"
              green " 3. manual input"
              read -p "Please input number:" menuNumberInputport
              case "$menuNumberInputport" in
                1 )
                    PANEL_NON_SSL_PORT=80
                    PANEL_SSL_PORT=443
                ;;

                2 )
                    PANEL_NON_SSL_PORT=${tmpPANEL_NON_SSL_PORT}
                    PANEL_SSL_PORT=${tmpPANEL_SSL_PORT}
                ;;

                3 )
                    while [[ -z "$PANEL_NON_SSL_PORT" ]]; do
                      read -p "PANEL_NON_SSL_PORT is not set? press enter port[80]:" PANEL_NON_SSL_PORT
                    done

                    while [[ -z "$PANEL_SSL_PORT" ]]; do
                      read -p "PANEL_SSL_PORT is not set? press enter port[443]:" PANEL_SSL_PORT
                    done
                ;;

                * )
                  red "Please enter the correct number!"
                  sleep 2s
                  getPanelType
                ;;
                esac
              
              
              
              case "$menuNumberInput2" in
                1 )
                    testPortUsage ${PANEL_SSL_PORT}
                    testPortUsage ${PANEL_NON_SSL_PORT}
                    IS_SSL=true
                    PANEL_HOST=https://${PANEL_DOMAIN}
                ;;

                2 )
                  testPortUsage ${PANEL_NON_SSL_PORT}
                  # PANEL_SSL_PORT=${PANEL_NON_SSL_PORT}
                  IS_SSL=false
                  PANEL_HOST=http://${PANEL_DOMAIN}
                ;;
                * )
                  red "Please enter the correct number!"
                  sleep 2s
                  getPanelType
                ;;
              esac
            fi
        ;;

        * )
            red "Please enter the correct number!"
            sleep 2s
            getPanelType
        ;;
    esac
}


IS_PANEL_INTERNAL=
IS_PANEL_CONTAINERD=
function IsPanelInternal() {
  echo
  green " ================================================== "
  echo
  green " is panel hosted locally ?"
  green " 1. yes,container running"
  green " 2. yes,port/host"
  green " 3. no, external port/host"

  echo 
  read -p "Please select the panel hosted mode . Press Enter to select 1 by default, please enter pure numbers:" isModeInput1
  isModeInput1=${isModeInput1:-1}

  if [[ "${isModeInput1}" == "1" ]]; then
    IS_PANEL_INTERNAL=true
    IS_PANEL_CONTAINERD=true

  elif [[ "${isModeInput1}" == "2" ]]; then
    IS_PANEL_INTERNAL=true
    IS_PANEL_CONTAINERD=false

  elif [[ "${isModeInput1}" == "3" ]]; then
    IS_PANEL_INTERNAL=false
    IS_PANEL_CONTAINERD=false
  else
    red "invalid input ! press correct number"
    sleep 1
    IsPanelInternal
  fi
}

function CheckReverseProxyEnv() {

    if [[ -z "$PANEL_HOST" ]]; then
        IsPanelInternal
        if [[ "$IS_PANEL_INTERNAL" == "true" && "$IS_PANEL_CONTAINERD" == "true" ]]; then
          while [[ -z "$PANEL_CONTAINER_NAME" ]]; do
            read -p "PANEL_CONTAINER_NAME is not set? press enter correct container name ex: panel :" PANEL_CONTAINER_NAME
          done
          while [[ -z "$PANEL_NON_SSL_PORT" ]]; do
            read -p "PANEL_NON_SSL_PORT is not set? press enter correct container port: eg:443 :" PANEL_NON_SSL_PORT
          done
          PANEL_HOST=http://${PANEL_CONTAINER_NAME}:${PANEL_NON_SSL_PORT}
          read -r -d '' panelContainerLinkTemp << EOM
external_links:
      - ${PANEL_CONTAINER_NAME}:PANEL_HOST
      - ${TRAEFIK_CONTAINER_NAME}:TRAEFIK
EOM
        fi

        if [[ "$IS_PANEL_INTERNAL" == "true" && "$IS_PANEL_CONTAINERD" == "false" ]]; then
          while [[ -z "$PANEL_NON_SSL_PORT" ]]; do
            read -p "PANEL_NON_SSL_PORT is not set? press enter correct panel port: " PANEL_NON_SSL_PORT
          done
          PANEL_HOST=http://127.0.0.1:${PANEL_NON_SSL_PORT}
        fi

        if [[ "$IS_PANEL_INTERNAL" == "false"  ]]; then
          while [[ -z "$PANEL_EXT_DOMAIN" ]]; do
            read -p "PANEL_EXT_DOMAIN is not set? press enter correct container panel url: http(s)://panel.xxx.xom:123 :" PANEL_EXT_DOMAIN
          done
          PANEL_HOST=${PANEL_EXT_DOMAIN}
        fi
      fi
    # fi

    if [[ -z "$TRAEFIK_CONTAINER_NAME" ]]; then
	    read -p "TRAEFIK_CONTAINER_NAME is not set, press enter to use default value or enter custom name [TRAEFIK]:" TRAEFIK_CONTAINER_NAME
	    TRAEFIK_CONTAINER_NAME=${TRAEFIK_CONTAINER_NAME:-TRAEFIK}
    fi

    if [[ -z "$NGINX_REVERSE_CONTAINER_NAME" ]]; then
	    read -p "NGINX_REVERSE_CONTAINER_NAME is not set, press enter to use default value or enter custom name [NGINXREV]:" NGINX_REVERSE_CONTAINER_NAME
	    NGINX_REVERSE_CONTAINER_NAME=${NGINX_REVERSE_CONTAINER_NAME:-NGINXREV}
    fi

    if [[ -z "$TRAEFIK_ENTRY_POINT_PORT" ]]; then
	    read -p "TRAEFIK_CONTAINER_NAME is not set, press enter to use default value or enter custom name [1080]:" TRAEFIK_ENTRY_POINT_PORT
	    TRAEFIK_ENTRY_POINT_PORT=${TRAEFIK_ENTRY_POINT_PORT:-1080}
    fi

    if [[ -z "$TRAEFIK_DASHBOARD_ENTRY_POINT_PORT" ]]; then
	    read -p "TRAEFIK_DASHBOARD_ENTRY_POINT_PORT is not set, press enter to use default value or enter custom name [8080]:" TRAEFIK_DASHBOARD_ENTRY_POINT_PORT
	    TRAEFIK_DASHBOARD_ENTRY_POINT_PORT=${TRAEFIK_DASHBOARD_ENTRY_POINT_PORT:-8080}
    fi

}

function checkReverseProxy() {

    if [ -f "$reverseDockerComposeFile" ]; then
        echo "$reverseDockerComposeFile exists!"
        docker-compose -f ${reverseDockerComposeFile} pull
        docker-compose -f ${reverseDockerComposeFile} down
        docker-compose -f ${reverseDockerComposeFile} up -d
    else
        installReverseProxy
    fi

}

function installPanelNodes() {
    clear

    testLinuxPortUsage

    echo
    green " ================================================== "
    echo
    green " 1. Install Panel"
    green " 2. Add XrayR Node"
    green " 3. Add New Nodes Domain"

    echo 
    read -p "Please select the installation mode . Press Enter to select 1 by default, please enter pure numbers:" isModeInput
    isModeInput=${isModeInput:-1}

    if [[ "${isModeInput}" == "1" ]]; then
        clear
        getPanelEnv
        configPanelDocker
        
        green "Panel Container's Configured Successfully"
        if [[ ${IS_SSL} == "true" ]]; then
          getPanelSSLCertification ${PANEL_DOMAIN}
        fi
        StartPanel

    elif [[ "${isModeInput}" == "2" ]]; then
        clear
        configXrayrDocker
        StartXrayrNode
    elif [[ "${isModeInput}" == "3" ]]; then
        clear
        rm -rf $reverseDockerComposeFile
        checkReverseProxy
        addNginxNewDomainConf
    fi

}




function promptContinueOpeartion(){
	read -r -p "Do you want to continue the operation? Just press Enter to continue the operation by default, please enter[Y/n]:" isContinueInput
	isContinueInput=${isContinueInput:-Y}

	if [[ $isContinueInput == [Yy] ]]; then
		echo ""
	else 
		exit 1
	fi
}

osPort80=""
osPort443=""
osSELINUXCheck=""
osSELINUXCheckIsRebootInput=""

function testPortUsage(){
    $osSystemPackage -y install net-tools socat

    osPort=$(netstat -tlpn | awk -F '[: ]+' '$1=="tcp"{print $5}' | grep -w $1)

    if [ -n "$osPort" ]; then
        process=$(netstat -tlpn | awk -F '[: ]+' '$5=="$1"{print $9}')
        red "==========================================================="
        red "It is detected that port $1 is occupied, and the occupying process is：${process} "
        red "==========================================================="
        promptContinueOpeartion
    fi

}

function testLinuxPortUsage(){
    $osSystemPackage -y install net-tools socat

    osPort80=$(netstat -tlpn | awk -F '[: ]+' '$1=="tcp"{print $5}' | grep -w 80)
    osPort443=$(netstat -tlpn | awk -F '[: ]+' '$1=="tcp"{print $5}' | grep -w 443)

    if [ -n "$osPort80" ]; then
        process80=$(netstat -tlpn | awk -F '[: ]+' '$5=="80"{print $9}')
        red "==========================================================="
        red "It is detected that port 80 is occupied, and the occupying process is：${process80} "
        red "==========================================================="
        promptContinueOpeartion
    fi

    if [ -n "$osPort443" ]; then
        process443=$(netstat -tlpn | awk -F '[: ]+' '$5=="443"{print $9}')
        red "============================================================="
        red "It is detected that port 443 is occupied, and the occupying process is：${process443} "
        red "============================================================="
        promptContinueOpeartion
    fi

}

function turnOffSELINUX() {

    osSELINUXCheck=$(grep SELINUX= /etc/selinux/config | grep -v "#")
    if [ "$osSELINUXCheck" == "SELINUX=enforcing" ]; then
        red "======================================================================="
        red "It is detected that SELinux is in mandatory mode, and SELinux will be disabled to prevent certificate application failure. Please restart the VPS before executing this script"
        red "======================================================================="
        read -p "Do you want to reboot now? Please enter [Y/n] :" osSELINUXCheckIsRebootInput
        [ -z "${osSELINUXCheckIsRebootInput}" ] && osSELINUXCheckIsRebootInput="y"

        if [[ $osSELINUXCheckIsRebootInput == [Yy] ]]; then
            sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config
            setenforce 0
            echo -e "VPS restarting..."
            reboot
        fi
        exit
    fi

    if [ "$osSELINUXCheck" == "SELINUX=permissive" ]; then
        red "======================================================================="
        red "It is detected that SELinux is in permissive mode. In order to prevent certificate application failure, SELinux will be closed. Please restart the VPS before executing this script"
        red "======================================================================="
        read -p "Do you want to reboot now? Please enter [Y/n] :" osSELINUXCheckIsRebootInput
        [ -z "${osSELINUXCheckIsRebootInput}" ] && osSELINUXCheckIsRebootInput="y"

        if [[ $osSELINUXCheckIsRebootInput == [Yy] ]]; then
            sed -i 's/SELINUX=permissive/SELINUX=disabled/g' /etc/selinux/config
            setenforce 0
            echo -e "VPS restarting..."
            reboot
        fi
        exit
    fi

}    
function turnOffFirewall() {
    
    if [ "$osRelease" == "centos" ]; then
        if  [[ ${osReleaseVersionNoShort} == "6" || ${osReleaseVersionNoShort} == "5" ]]; then
            green " =================================================="
            red " This script does not support Centos 6 or earlier versions of Centos 6"
            green " =================================================="
            exit
        fi

        red " turn off firewall firewalld"
        ${sudoCmd} systemctl stop firewalld
        ${sudoCmd} systemctl disable firewalld

    elif [ "$osRelease" == "ubuntu" ]; then
        if  [[ ${osReleaseVersionNoShort} == "14" || ${osReleaseVersionNoShort} == "12" ]]; then
            green " =================================================="
            red " This script does not support Ubuntu 14 or earlier versions of Ubuntu 14"
            green " =================================================="
            exit
        fi

        red " turn off firewall ufw"
        ${sudoCmd} systemctl stop ufw
        ${sudoCmd} systemctl disable ufw
        ufw disable
        
    elif [ "$osRelease" == "debian" ]; then
        $osSystemPackage update -y
    fi
}

function changeLinuxSSHPort(){
    green " The modified SSH login port number, do not use common port numbers. For example 20|21|23|25|53|69|80|110|443|123!"
    read -p "Please enter the port number to be modified (must be pure numbers and between 1024~65535 or 22):" osSSHLoginPortInput
    osSSHLoginPortInput=${osSSHLoginPortInput:-0}

    if [ $osSSHLoginPortInput -eq 22 -o $osSSHLoginPortInput -gt 1024 -a $osSSHLoginPortInput -lt 65535 ]; then
        sed -i "s/#\?Port [0-9]*/Port $osSSHLoginPortInput/g" /etc/ssh/sshd_config

        if [ "$osRelease" == "centos" ] ; then

            if  [[ ${osReleaseVersionNoShort} == "7" ]]; then
                yum -y install policycoreutils-python
            elif  [[ ${osReleaseVersionNoShort} == "8" ]]; then
                yum -y install policycoreutils-python-utils
            fi

            # semanage port -l
            semanage port -a -t ssh_port_t -p tcp ${osSSHLoginPortInput}
            if command -v firewall-cmd &> /dev/null; then
                firewall-cmd --permanent --zone=public --add-port=$osSSHLoginPortInput/tcp 
                firewall-cmd --reload
            fi


            ${sudoCmd} systemctl restart sshd.service

        fi

        if [ "$osRelease" == "ubuntu" ] || [ "$osRelease" == "debian" ] ; then
            semanage port -a -t ssh_port_t -p tcp $osSSHLoginPortInput
            ${sudoCmd} ufw allow $osSSHLoginPortInput/tcp

            ${sudoCmd} service ssh restart
            ${sudoCmd} systemctl restart ssh
        fi

        green "The setting is successful, please remember the port number set ${osSSHLoginPortInput}!"
        green "login server command: ssh -p ${osSSHLoginPortInput} root@111.111.111.your ip !"
    else
        echo "Wrong port number entered! Range: 22,1025~65534"
    fi
}


function setLinuxDateZone(){

    tempCurrentDateZone=$(date +'%z')

    echo
    if [[ ${tempCurrentDateZone} == "+0330" ]]; then
        yellow "The current time zone is Tehran time  $tempCurrentDateZone | $(date -R) "
    else 
        green " =================================================="
        yellow " The current time zone is: $tempCurrentDateZone | $(date -R) "
        yellow " Whether to set the time zone to Tehran time +0330 zone, so that the cron restart script runs according to Tehran time."
        green " =================================================="
        # read 默认值 https://stackoverflow.com/questions/2642585/read-a-variable-in-bash-with-a-default-value

        read -p "Is it set to Tehran time +0330 time zone? Please enter[Y/n]:" osTimezoneInput
        osTimezoneInput=${osTimezoneInput:-Y}

        if [[ $osTimezoneInput == [Yy] ]]; then
            if [[ -f /etc/localtime ]] && [[ -f /usr/share/zoneinfo/Asia/Tehran ]];  then
                mv /etc/localtime /etc/localtime.bak
                cp /usr/share/zoneinfo/Asia/Tehran /etc/localtime

                yellow " Successfully set! The current time zone has been set to $(date -R)"
                green " =================================================="
            fi
        fi

    fi
    echo

    if [ "$osRelease" == "centos" ]; then   
        if  [[ ${osReleaseVersionNoShort} == "7" ]]; then
            systemctl stop chronyd
            systemctl disable chronyd

            $osSystemPackage -y install ntpdate
            $osSystemPackage -y install ntp
            ntpdate -q 0.rhel.pool.ntp.org
            systemctl enable ntpd
            systemctl restart ntpd
            ntpdate -u  pool.ntp.org

        elif  [[ ${osReleaseVersionNoShort} == "8" || ${osReleaseVersionNoShort} == "9" ]]; then
            $osSystemPackage -y install chrony
            systemctl enable chronyd
            systemctl restart chronyd

            if command -v firewall-cmd &> /dev/null; then
                firewall-cmd --permanent --add-service=ntp
                firewall-cmd --reload
            fi

            chronyc sources

            echo
        fi
        
    else
        $osSystemPackage install -y ntp
        systemctl enable ntp
        systemctl restart ntp
    fi    
}



configDockerDownloadPath="${HOME}/download"
configDockerComposePath="/usr/local/lib/docker/cli-plugins"

function installDocker(){

    showHeaderGreen "ready to install Docker and Docker Compose"

    mkdir -p ${configDockerDownloadPath}
    cd ${configDockerDownloadPath}


    if [[ -s "/usr/bin/docker" ]]; then
        showHeaderRed "Docker already installed!"
    else

        if [[ "${osInfo}" == "AlmaLinux" ]]; then
            ${sudoCmd} yum module remove container-tools
            # https://linuxconfig.org/install-docker-on-almalinux
            ${sudoCmd} dnf config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
            ${sudoCmd} dnf remove -y podman buildah 
            ${sudoCmd} dnf install -y docker-ce docker-ce-cli containerd.io
 
        else
            # curl -fsSL https://get.docker.com -o get-docker.sh  
            curl -sSL https://get.daocloud.io/docker -o ${configDockerDownloadPath}/get-docker.sh  
            chmod +x ${configDockerDownloadPath}/get-docker.sh
            ${configDockerDownloadPath}/get-docker.sh

        fi
        ${sudoCmd}
        ${sudoCmd} systemctl start docker.service
        ${sudoCmd} systemctl enable docker.service
        
        showHeaderGreen "Docker installed successfully !"
        docker version
        echo
    fi


    if [[ -s "/usr/local/bin/docker-compose" ]]; then
        showHeaderRed "Docker Compose already installed!"
    else

        versionDockerCompose=$(getGithubLatestReleaseVersion "docker/compose")

        # dockerComposeUrl="https://github.com/docker/compose/releases/download/v${versionDockerCompose}/docker-compose-$(uname -s)-$(uname -m)"
        dockerComposeUrl="https://github.com/docker/compose/releases/download/v2.9.0/docker-compose-linux-x86_64"
        dockerComposeUrl="https://get.daocloud.io/docker/compose/releases/download/v${versionDockerCompose}/docker-compose-linux-x86_64"
        
        showInfoGreen "Downloading  ${dockerComposeUrl}"


        mkdir -p ${configDockerComposePath}

        ${sudoCmd} wget -O ${configDockerComposePath}/docker-compose "${dockerComposeUrl}"
        ${sudoCmd} chmod a+x ${configDockerComposePath}/docker-compose
        ${sudoCmd} ln -s ${configDockerComposePath}/docker-compose /usr/local/bin/docker-compose
        #${sudoCmd} ln -s ${configDockerComposePath}/docker-compose /usr/bin/docker-compose

        rm -f "$(which dc)"
        ${sudoCmd} ln -s ${configDockerComposePath}/docker-compose /usr/bin/dc
        
        # rm -f "/usr/bin/docker-compose"
        # ${sudoCmd} ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
        
        showHeaderGreen "Docker-Compose installed successfully !"
        docker compose version
        echo
    fi

    showHeaderGreen "Docker and Docker Compose Successful installation !"
    # systemctl status docker.service
}

function removeDocker(){

    if [ "$osRelease" == "centos" ] ; then

        sudo yum remove docker docker-common container-selinux docker-selinux docker-engine

    else 
        sudo apt-get remove docker docker-engine

    fi

    rm -rf /var/lib/docker/

    rm -f "$(which dc)" 
    rm -f "/usr/bin/docker-compose"
    rm -f "/usr/local/bin/docker-compose"
    rm -f "${DOCKER_CONFIG}/cli-plugins/docker-compose"

    showHeaderGreen "Docker has been uninstalled !"
}


function installSoftDownload(){
	if [[ "${osRelease}" == "debian" || "${osRelease}" == "ubuntu" ]]; then


		if ! dpkg -l | grep -qw curl; then
			${osSystemPackage} -y install wget curl git

            if [[ "${osRelease}" == "debian" ]]; then
                echo "deb http://deb.debian.org/debian buster-backports main contrib non-free" > /etc/apt/sources.list.d/buster-backports.list
                echo "deb-src http://deb.debian.org/debian buster-backports main contrib non-free" >> /etc/apt/sources.list.d/buster-backports.list
                ${sudoCmd} apt update -y
            fi

		fi

		if ! dpkg -l | grep -qw wget; then
			${osSystemPackage} -y install wget curl git

            if [[ "${osRelease}" == "debian" ]]; then
                echo "deb http://deb.debian.org/debian buster-backports main contrib non-free" > /etc/apt/sources.list.d/buster-backports.list
                echo "deb-src http://deb.debian.org/debian buster-backports main contrib non-free" >> /etc/apt/sources.list.d/buster-backports.list
                ${sudoCmd} apt update -y
            fi

		fi

        if ! dpkg -l | grep -qw bc; then
			${osSystemPackage} -y install bc
            # https://stackoverflow.com/questions/11116704/check-if-vt-x-is-activated-without-having-to-reboot-in-linux
            ${osSystemPackage} -y install cpu-checker
		fi

        if ! dpkg -l | grep -qw ca-certificates; then
			${osSystemPackage} -y install ca-certificates dmidecode
            update-ca-certificates
		fi        

	elif [[ "${osRelease}" == "centos" ]]; then
		if ! rpm -qa | grep -qw wget; then
			${osSystemPackage} -y install wget curl git bc
		fi

        if ! rpm -qa | grep -qw bc; then
			${osSystemPackage} -y install bc
		fi

        # 处理ca证书
        if ! rpm -qa | grep -qw ca-certificates; then
			${osSystemPackage} -y install ca-certificates dmidecode
            update-ca-trust force-enable
		fi
	fi
    
}

function listInstalledLinuxKernel(){
    echo
    green " =================================================="
    green " Status display - currently installed Linux kernel: "
    echo

	if [[ "${osRelease}" == "debian" || "${osRelease}" == "ubuntu" ]]; then
        dpkg --get-selections | grep linux-
		# dpkg -l | grep linux-
        # dpkg-query -l | grep linux-
        # apt list --installed | grep linux-
        echo
        red " If you encounter inconsistencies in the version of kernel linux-image linux-headers when installing the kernel, please manually uninstall the installed kernel"
        red " Uninstall kernel command 1 apt remove -y --purge linux-xxx name"
        red " uninstall kernel command 2 apt autoremove -y --purge linux-xxx name"

	elif [[ "${osRelease}" == "centos" ]]; then
        ${sudoCmd} rpm -qa | grep kernel
        echo
        red " If you encounter inconsistent kernel-headers kernel-devel versions when installing the kernel, please manually uninstall the installed kernel" 
        red " Uninstall the kernel command rpm --nodeps -e kernel-xxx name" 
	fi
    green " =================================================="
    echo
}


# https://stackoverflow.com/questions/4023830/how-to-compare-two-strings-in-dot-separated-version-format-in-bash
versionCompare () {
    if [[ $1 == $2 ]]; then
        return 0
    fi
    local IFS=.
    local i ver1=($1) ver2=($2)
    # fill empty fields in ver1 with zeros
    for ((i=${#ver1[@]}; i<${#ver2[@]}; i++))
    do
        ver1[i]=0
    done
    for ((i=0; i<${#ver1[@]}; i++))
    do
        if [[ -z ${ver2[i]} ]]
        then
            # fill empty fields in ver2 with zeros
            ver2[i]=0
        fi
        if ((10#${ver1[i]} > 10#${ver2[i]}))
        then
            return 1
        fi
        if ((10#${ver1[i]} < 10#${ver2[i]}))
        then
            return 2
        fi
    done
    return 0
}

versionCompareWithOp () {
    versionCompare $1 $2
    case $? in
        0) op='=';;
        1) op='>';;
        2) op='<';;
    esac
    if [[ $op != $3 ]]; then
        # echo "Version Number Compare Fail: Expected '$3', Actual '$op', Arg1 '$1', Arg2 '$2'"
        return 1
    else
        # echo "Version Number Compare Pass: '$1 $op $2'"
        return 0
    fi
}



function showLinuxKernelInfo(){
    
    # https://stackoverflow.com/questions/8654051/how-to-compare-two-floating-point-numbers-in-bash
    # https://stackoverflow.com/questions/229551/how-to-check-if-a-string-contains-a-substring-in-bash

    isKernelSupportBBRVersion="4.9"

    green " =================================================="
    green " Status display -- the current Linux kernel version: ${osKernelVersionShort} , $(uname -r) "

    if versionCompareWithOp "${isKernelSupportBBRVersion}" "${osKernelVersionShort}" ">"; then
        green "           The current system kernel is lower than 4.9, does not support enabling BBR "   
    else
        green "           The current system kernel is higher than 4.9, support to open BBR, ${systemBBRRunningStatusText}"
    fi

    if [[ ${osKernelVersionFull} == *"xanmod"* ]]; then
        green "           The current system kernel already supports enabling BBR2, ${systemBBRRunningStatusText}"
    else
        green "           The current system kernel does not support enabling BBR2"
    fi

    if [[ ${osKernelVersionFull} == *"bbrplus"* ]]; then
        green "           The current system kernel already supports enabling BBR Plus, ${systemBBRRunningStatusText}"
    else
        green "           The current system kernel does not support enabling BBR Plus"
    fi
    # sysctl net.ipv4.tcp_available_congestion_control 返回值 net.ipv4.tcp_available_congestion_control = bbr cubic reno 或 reno cubic bbr
    # sysctl net.ipv4.tcp_congestion_control 返回值 net.ipv4.tcp_congestion_control = bbr
    # sysctl net.core.default_qdisc 返回值 net.core.default_qdisc = fq
    # lsmod | grep bbr 返回值 tcp_bbr     20480  3  或 tcp_bbr                20480  1   注意：并不是所有的 VPS 都会有此返回值，若没有也属正常。

    # isFlagBbr=$(sysctl net.ipv4.tcp_congestion_control | awk '{print $3}')

    # if [[ (${isFlagBbr} == *"bbr"*)  &&  (${isFlagBbr} != *"bbrplus"*) && (${isFlagBbr} != *"bbr2"*) ]]; then
    #     green " 状态显示--是否فعالBBR: 已فعال "
    # else
    #     green " 状态显示--是否فعالBBR: 未فعال "
    # fi

    # if [[ ${isFlagBbr} == *"bbrplus"* ]]; then
    #     green " 状态显示--是否فعالBBR Plus: 已فعال "
    # else
    #     green " 状态显示--是否فعالBBR Plus: 未فعال "
    # fi
    
    # if [[ ${isFlagBbr} == *"bbr2"* ]]; then
    #     green " 状态显示--是否فعالBBR2: 已فعال "
    # else
    #     green " 状态显示--是否فعالBBR2: 未فعال "
    # fi

    green " =================================================="
    echo
}


virt_check(){
	# if hash ifconfig 2>/dev/null; then
		# eth=$(ifconfig)
	# fi

	virtualx=$(dmesg) 2>/dev/null


    if  [ "$(command -v dmidecode)" ]; then
		sys_manu=$(dmidecode -s system-manufacturer) 2>/dev/null
		sys_product=$(dmidecode -s system-product-name) 2>/dev/null
		sys_ver=$(dmidecode -s system-version) 2>/dev/null
	else
		sys_manu=""
		sys_product=""
		sys_ver=""
	fi
	
	if grep docker /proc/1/cgroup -qa; then
	    virtual="Docker"
	elif grep lxc /proc/1/cgroup -qa; then
		virtual="Lxc"
	elif grep -qa container=lxc /proc/1/environ; then
		virtual="Lxc"
	elif [[ -f /proc/user_beancounters ]]; then
		virtual="OpenVZ"
	elif [[ "$virtualx" == *kvm-clock* ]]; then
		virtual="KVM"
	elif [[ "$cname" == *KVM* ]]; then
		virtual="KVM"
	elif [[ "$cname" == *QEMU* ]]; then
		virtual="KVM"
	elif [[ "$virtualx" == *"VMware Virtual Platform"* ]]; then
		virtual="VMware"
	elif [[ "$virtualx" == *"Parallels Software International"* ]]; then
		virtual="Parallels"
	elif [[ "$virtualx" == *VirtualBox* ]]; then
		virtual="VirtualBox"
	elif [[ -e /proc/xen ]]; then
		virtual="Xen"
	elif [[ "$sys_manu" == *"Microsoft Corporation"* ]]; then
		if [[ "$sys_product" == *"Virtual Machine"* ]]; then
			if [[ "$sys_ver" == *"7.0"* || "$sys_ver" == *"Hyper-V" ]]; then
				virtual="Hyper-V"
			else
				virtual="Microsoft Virtual Machine"
			fi
		fi
	else
		virtual="Dedicated母鸡"
	fi
}


function checkCPU(){
	osCPUText=$(cat /proc/cpuinfo | grep vendor_id | uniq)
	if [[ $osCPUText =~ "GenuineIntel" ]]; then
		osCPU="intel"
    elif [[ $osCPUText =~ "AMD" ]]; then
        osCPU="amd"
    else
        echo
    fi

	# green " Status 状态显示--当前CPU是: $osCPU"
}

function checkArchitecture(){
	# https://stackoverflow.com/questions/48678152/how-to-detect-386-amd64-arm-or-arm64-os-architecture-via-shell-bash

	case $(uname -m) in
		i386)   osArchitecture="386" ;;
		i686)   osArchitecture="386" ;;
		x86_64) osArchitecture="amd64" ;;
		arm)    dpkg --print-architecture | grep -q "arm64" && osArchitecture="arm64" || osArchitecture="arm" ;;
		aarch64)    dpkg --print-architecture | grep -q "arm64" && osArchitecture="arm64" || osArchitecture="arm" ;;
		* )     osArchitecture="arm" ;;
	esac
}


getLinuxOSVersion(){
    if [[ -s /etc/redhat-release ]]; then
        osReleaseVersion=$(grep -oE '[0-9.]+' /etc/redhat-release)
    else
        osReleaseVersion=$(grep -oE '[0-9.]+' /etc/issue)
    fi

    # https://unix.stackexchange.com/questions/6345/how-can-i-get-distribution-name-and-version-number-in-a-simple-shell-script

    if [ -f /etc/os-release ]; then
        # freedesktop.org and systemd
        source /etc/os-release
        osInfo=$NAME
        osReleaseVersionNo=$VERSION_ID

        if [ -n "$VERSION_CODENAME" ]; then
            osReleaseVersionCodeName=$VERSION_CODENAME
        fi
    elif type lsb_release >/dev/null 2>&1; then
        # linuxbase.org
        osInfo=$(lsb_release -si)
        osReleaseVersionNo=$(lsb_release -sr)

    elif [ -f /etc/lsb-release ]; then
        # For some versions of Debian/Ubuntu without lsb_release command
        . /etc/lsb-release
        osInfo=$DISTRIB_ID
        osReleaseVersionNo=$DISTRIB_RELEASE
        
    elif [ -f /etc/debian_version ]; then
        # Older Debian/Ubuntu/etc.
        osInfo=Debian
        osReleaseVersion=$(cat /etc/debian_version)
        osReleaseVersionNo=$(sed 's/\..*//' /etc/debian_version)
    elif [ -f /etc/redhat-release ]; then
        osReleaseVersion=$(grep -oE '[0-9.]+' /etc/redhat-release)
    else
        # Fall back to uname, e.g. "Linux <version>", also works for BSD, etc.
        osInfo=$(uname -s)
        osReleaseVersionNo=$(uname -r)
    fi

    osReleaseVersionNoShort=$(echo $osReleaseVersionNo | sed 's/\..*//')
}


function getLinuxOSRelease(){
    if [[ -f /etc/redhat-release ]]; then
        osRelease="centos"
        osSystemPackage="yum"
        osSystemMdPath="/usr/lib/systemd/system/"
        osReleaseVersionCodeName=""
    elif cat /etc/issue | grep -Eqi "debian|raspbian"; then
        osRelease="debian"
        osSystemPackage="apt-get"
        osSystemMdPath="/lib/systemd/system/"
        osReleaseVersionCodeName="buster"
    elif cat /etc/issue | grep -Eqi "ubuntu"; then
        osRelease="ubuntu"
        osSystemPackage="apt-get"
        osSystemMdPath="/lib/systemd/system/"
        osReleaseVersionCodeName="bionic"
    elif cat /etc/issue | grep -Eqi "centos|red hat|redhat"; then
        osRelease="centos"
        osSystemPackage="yum"
        osSystemMdPath="/usr/lib/systemd/system/"
        osReleaseVersionCodeName=""
    elif cat /proc/version | grep -Eqi "debian|raspbian"; then
        osRelease="debian"
        osSystemPackage="apt-get"
        osSystemMdPath="/lib/systemd/system/"
        osReleaseVersionCodeName="buster"
    elif cat /proc/version | grep -Eqi "ubuntu"; then
        osRelease="ubuntu"
        osSystemPackage="apt-get"
        osSystemMdPath="/lib/systemd/system/"
        osReleaseVersionCodeName="bionic"
    elif cat /proc/version | grep -Eqi "centos|red hat|redhat"; then
        osRelease="centos"
        osSystemPackage="yum"
        osSystemMdPath="/usr/lib/systemd/system/"
        osReleaseVersionCodeName=""
    fi

    getLinuxOSVersion
    checkArchitecture
	checkCPU
    virt_check

    [[ -z $(echo $SHELL|grep zsh) ]] && osSystemShell="bash" || osSystemShell="zsh"

    echo "OS info: ${osInfo}, ${osRelease}, ${osReleaseVersion}, ${osReleaseVersionNo}, ${osReleaseVersionCodeName}, ${osSystemShell}, ${osSystemPackage}, ${osSystemMdPath}"
}

function start_menu(){
    readEnvFile
    clear
    configLanguageFilePath="${HOME}/language_setting_v2ray_trojan.md"
    if [ -f "${configLanguageFilePath}" ]; then
        getLinuxOSRelease
        installSoftDownload

    else
        echo "en" > ${configLanguageFilePath}
    fi

    clear
    showLinuxKernelInfo
    # listInstalledLinuxKernel

    echo
    # green " 1. Show current linux kernel version, check supoort BBR / BBR2 / BBR Plus or not"
    green " 1. Install Panel & nodes"
    red " 2. remove Docker"
    green " 3. Modify SSH login port number. Secure your VPS"
    red " 4. Turn Off Firewall"
 
    echo
    green " 0. exit"

    

    echo
    read -p "Please input number:" menuNumberInput
    case "$menuNumberInput" in
        # 1 )
        #     clear
        #     showLinuxKernelInfo
        #     listInstalledLinuxKernel
        # ;;
        1 )
            testLinuxPortUsage
            turnOffSELINUX
            setLinuxDateZone
            installDocker
            installPanelNodes
        ;;
        2 )
            removeDocker
        ;;
        3 )
            changeLinuxSSHPort
            sleep 10s
            start_menu
        ;;
        4 )
            turnOffFirewall
            sysctl -p
        ;;


        0 )
            exit 1
        ;;
        * )
            clear
            red "Please enter the correct number!"
            sleep 2s
            start_menu
        ;;
    esac
}
start_menu
