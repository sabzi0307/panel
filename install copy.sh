#!/usr/bin/bash

[ $(id -u) != "0" ] && { echo "Error: You must be root to run this script!"; exit 1; }

do_install_sspanel() {
    read -p "Please input root password of your Database server: " db_root_password
    read -p "Please input db_host(127.0.0.1): " db_host
    read -p "Please input db_database(sspanel): " db_database
    read -p "Please input db_username(sspanel): " db_username
    read -p "Please input db_password: " db_password
    read -p "Please input key: " key
    read -p "Please input appName(SSPanel-UIM): " app_name
    read -p "Please input baseUrl(https://example.com): " base_url
    read -p "Please input muKey(SSPanel): " mu_key

    echo "Writting configuration..."
    sed -i -e "s/$_ENV['key']        = 'ChangeMe';/$_ENV['key']        = '$key';/g" \
    -e "s/$_ENV['appName']    = 'SSPanel-UIM';/$_ENV['appName']    = '$app_name';/g" \
    -e "s|$_ENV['baseUrl']    = 'https://example.com';|$_ENV['baseUrl']    = '$base_url';|g" \
    -e "s/$_ENV['muKey']      = 'SSPanel';/$_ENV['muKey']      = '$mu_key';/g" \
    -e "s/$_ENV['db_host']      = '';/$_ENV['db_host']      = '$db_host';/g" \
    -e "s/$_ENV['db_database']  = 'sspanel';/$_ENV['db_database']  = '$db_database';/g" \
    -e "s/$_ENV['db_username']  = 'root';/$_ENV['db_username']  = '$db_username';/g" \
    -e "s/$_ENV['db_password']  = 'sspanel';/$_ENV['db_password']  = '$db_password';/g" \
    config/.config.php


    echo "Installation completed! Now you can create your first admin user by running 'php xcat createAdmin'."
}

do_install_sspanel
