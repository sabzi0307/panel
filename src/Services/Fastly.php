<?php

declare(strict_types=1);

namespace App\Services;

use Fastly\Configuration;
use Fastly\Api\ServiceApi;
use Fastly\Api\BackendApi;
use Fastly\Api\PackageApi;
use Fastly\Api\VersionApi;
use GuzzleHttp\Client;
use GuzzleHttp\Exception\RequestException;
use Exception;

final class Fastly
{
    public static function ServiceInit(): ServiceApi
    {
        // Authorize the client with a Fastly API token.
        $config = Configuration::getDefaultConfiguration()->setApiToken($_ENV['fastly_api_token']);
        return new ServiceApi(null, $config);
    }

    /**
     * Operation listServices
     *
     * List services
     *
     * Note: the input parameter is an associative array with the keys listed as the parameter name below
     *
     * This operation contains host(s) defined in the OpenAP spec. Use 'hostIndex' to select the host.
     * URL: https://api.fastly.com
     *
     * @param  int $page Current page. (optional)
     * @param  int $per_page Number of records per page. (optional, default to 20)
     * @param  string $sort Field on which to sort. (optional, default to 'created')
     * @param  string $direction Direction in which to sort results. (optional, default to 'ascend')
     *
     * @throws \Fastly\ApiException on non-2xx response
     * @throws \InvalidArgumentException
     * @return \Fastly\Model\ServiceListResponse[]
     */
    public static function ServicesList()
    {
        $apiInstance = self::ServiceInit();
        $options = [
            'direction' => 'ascend',
            'page' => 1,
            'per_page' => 20,
            'sort' => 'created',
          ];
          try {
            $result = $apiInstance->listServices($options);
          } catch (Exception $e) {
              echo 'Exception when calling ServiceApi->listServices: ', $e->getMessage(), PHP_EOL;
          }
          return $result;

    }

    /**
     * Operation createService
     *
     * Create a service
     *
     * Note: the input parameter is an associative array with the keys listed as the parameter name below
     *
     * This operation contains host(s) defined in the OpenAP spec. Use 'hostIndex' to select the host.
     * URL: https://api.fastly.com
     *
     * @param  string $comment A freeform descriptive note. (optional)
     * @param  string $name The name of the service. (optional)
     * @param  string $customer_id Alphanumeric string identifying the customer. (optional)
     * @param  string $type The type of this service. (optional)
     *
     * @throws \Fastly\ApiException on non-2xx response
     * @throws \InvalidArgumentException
     * @return \Fastly\Model\ServiceResponse
     */
    public static function ServicesCreate($name)
    {
        $apiInstance = self::ServiceInit();
        $options = [
            'name' => $name,
        ];
        try {
            $result = $apiInstance->createService($options);
        } catch (Exception $e) {
            echo 'Exception when calling ServiceApi->createService: ', $e->getMessage(), PHP_EOL;
        }
        return $result;
    }

    /**
     * Operation getServiceDetail
     *
     * Get service details
     *
     * Note: the input parameter is an associative array with the keys listed as the parameter name below
     *
     * This operation contains host(s) defined in the OpenAP spec. Use 'hostIndex' to select the host.
     * URL: https://api.fastly.com
     *
     * @param  string $service_id Alphanumeric string identifying the service. (required)
     * @param  int $version Number identifying a version of the service. (optional)
     *
     * @throws \Fastly\ApiException on non-2xx response
     * @throws \InvalidArgumentException
     * @return \Fastly\Model\ServiceDetail
     */
    public static function ServiceGetDetails($id, $version)
    {
        $apiInstance = self::ServiceInit();
        $options = [
            'service_id' => $id,
            'version' => $version,
          ];
          try {
            $result = $apiInstance->getServiceDetail($options);
          } catch (Exception $e) {
              echo 'Exception when calling ServiceApi->getServiceDetail: ', $e->getMessage(), PHP_EOL;
          }
          return $result;

    }

    /**
     * Operation searchService
     *
     * Search for a service by name
     *
     * Note: the input parameter is an associative array with the keys listed as the parameter name below
     *
     * This operation contains host(s) defined in the OpenAP spec. Use 'hostIndex' to select the host.
     * URL: https://api.fastly.com
     *
     * @param  string $name The name of the service. (required)
     *
     * @throws \Fastly\ApiException on non-2xx response
     * @throws \InvalidArgumentException
     * @return \Fastly\Model\ServiceResponse
     */
    public static function ServiceGetByName($name)
    {
        $apiInstance = self::ServiceInit();
        $options = [
            'name' => $name,
          ];
          try {
            $result = $apiInstance->searchService($options);
          } catch (Exception $e) {
              echo 'Exception when calling ServiceApi->searchService: ', $e->getMessage(), PHP_EOL;
          }
          return $result;

    }

    /**
     * Operation getService
     *
     * Get a service
     *
     * Note: the input parameter is an associative array with the keys listed as the parameter name below
     *
     * This operation contains host(s) defined in the OpenAP spec. Use 'hostIndex' to select the host.
     * URL: https://api.fastly.com
     *
     * @param  string $service_id Alphanumeric string identifying the service. (required)
     *
     * @throws \Fastly\ApiException on non-2xx response
     * @throws \InvalidArgumentException
     * @return \Fastly\Model\ServiceResponse
     */
    public static function ServiceGetById($id)
    {
        $apiInstance = self::ServiceInit();
        $options = [
            'service_id' => $id,
          ];
          try {
            $result = $apiInstance->getService($options);
          } catch (Exception $e) {
              echo 'Exception when calling ServiceApi->getService: ', $e->getMessage(), PHP_EOL;
          }
          return $result;

    }

    /**
     * Operation deleteService
     *
     * Delete a service
     *
     * Note: the input parameter is an associative array with the keys listed as the parameter name below
     *
     * This operation contains host(s) defined in the OpenAP spec. Use 'hostIndex' to select the host.
     * URL: https://api.fastly.com
     *
     * @param  string $service_id Alphanumeric string identifying the service. (required)
     *
     * @throws \Fastly\ApiException on non-2xx response
     * @throws \InvalidArgumentException
     * @return \Fastly\Model\InlineResponse200
     */
    public static function ServiceDelete($id)
    {
        $apiInstance = self::ServiceInit();
        $options = [
            'service_id' => $id,
          ];
          try {
            $result = $apiInstance->deleteService($options);
          } catch (Exception $e) {
              echo 'Exception when calling ServiceApi->deleteService: ', $e->getMessage(), PHP_EOL;
          }
          return $result;

    }

    /**
     * Operation listServiceDomains
     *
     * List the domains within a service
     *
     * Note: the input parameter is an associative array with the keys listed as the parameter name below
     *
     * This operation contains host(s) defined in the OpenAP spec. Use 'hostIndex' to select the host.
     * URL: https://api.fastly.com
     *
     * @param  string $service_id Alphanumeric string identifying the service. (required)
     *
     * @throws \Fastly\ApiException on non-2xx response
     * @throws \InvalidArgumentException
     * @return \Fastly\Model\DomainResponse[]
     */
     public static function ServiceListDomains($id)
    {
        $apiInstance = self::ServiceInit();
        $options = [
            'service_id' => $id,
          ];
          try {
            $result = $apiInstance->listServiceDomains($options);
            } catch (Exception $e) {
                echo 'Exception when calling ServiceApi->listServiceDomains: ', $e->getMessage(), PHP_EOL;
            }
            return $result;

    }

    /**
     * Operation putPackage
     *
     * Upload a Compute package.
     *
     * Note: the input parameter is an associative array with the keys listed as the parameter name below
     *
     * This operation contains host(s) defined in the OpenAP spec. Use 'hostIndex' to select the host.
     * URL: https://api.fastly.com
     *
     * @param  string $service_id Alphanumeric string identifying the service. (required)
     * @param  int $version_id Integer identifying a service version. (required)
     * @param  string $expect We recommend using the Expect header because it may identify issues with the request based upon the headers alone instead of requiring you to wait until the entire binary package upload has completed. (optional)
     * @param  \SplFileObject $package The content of the Wasm binary package. (optional)
     *
     * @throws \Fastly\ApiException on non-2xx response
     * @throws \InvalidArgumentException
     * @return \Fastly\Model\PackageResponse
     */
     public static function PackageUpload($id, $version, $package)
    {
        $config = Configuration::getDefaultConfiguration()->setApiToken($_ENV['fastly_api_token']);
        $apiInstance = new PackageApi(null, $config);
        $options = [
            'service_id' => $id,
            'version_id' => $version,
            'package' => $package,
          ];
          try {
            $result = $apiInstance->putPackage($options);
            print_r($result);
        } catch (Exception $e) {
            echo 'Exception when calling PackageApi->putPackage: ', $e->getMessage(), PHP_EOL;
        }
            return $result;

    }

    public static function BackendInit(): BackendApi
    {
        // Authorize the client with a Fastly API token.
        $config = Configuration::getDefaultConfiguration()->setApiToken($_ENV['fastly_api_token']);
        return new BackendApi(null, $config);
    }

    /**
     * Operation listBackends
     *
     * List backends
     *
     * Note: the input parameter is an associative array with the keys listed as the parameter name below
     *
     * This operation contains host(s) defined in the OpenAP spec. Use 'hostIndex' to select the host.
     * URL: https://api.fastly.com
     *
     * @param  string $service_id Alphanumeric string identifying the service. (required)
     * @param  int $version_id Integer identifying a service version. (required)
     *
     * @throws \Fastly\ApiException on non-2xx response
     * @throws \InvalidArgumentException
     * @return \Fastly\Model\BackendResponse[]
     */
    public static function BackendsList($options)
    {
        $apiInstance = self::BackendInit();
        try {
            $result = $apiInstance->listBackends($options);
        } catch (Exception $e) {
            echo 'Exception when calling BackendApi->listBackends: ', $e->getMessage(), PHP_EOL;
        }
        return $result;
    }

    /**
     * Operation createBackend
     *
     * Create a backend
     *
     * Note: the input parameter is an associative array with the keys listed as the parameter name below
     *
     * This operation contains host(s) defined in the OpenAP spec. Use 'hostIndex' to select the host.
     * URL: https://api.fastly.com
     *
     * @param  string $service_id Alphanumeric string identifying the service. (required)
     * @param  int $version_id Integer identifying a service version. (required)
     * @param  string $address A hostname, IPv4, or IPv6 address for the backend. This is the preferred way to specify the location of your backend. (optional)
     * @param  bool $auto_loadbalance Whether or not this backend should be automatically load balanced. If true, all backends with this setting that don&#39;t have a &#x60;request_condition&#x60; will be selected based on their &#x60;weight&#x60;. (optional)
     * @param  int $between_bytes_timeout Maximum duration in milliseconds that Fastly will wait while receiving no data on a download from a backend. If exceeded, the response received so far will be considered complete and the fetch will end. May be set at runtime using &#x60;bereq.between_bytes_timeout&#x60;. (optional)
     * @param  string $client_cert Unused. (optional)
     * @param  string $comment A freeform descriptive note. (optional)
     * @param  int $connect_timeout Maximum duration in milliseconds to wait for a connection to this backend to be established. If exceeded, the connection is aborted and a synthethic &#x60;503&#x60; response will be presented instead. May be set at runtime using &#x60;bereq.connect_timeout&#x60;. (optional)
     * @param  int $first_byte_timeout Maximum duration in milliseconds to wait for the server response to begin after a TCP connection is established and the request has been sent. If exceeded, the connection is aborted and a synthethic &#x60;503&#x60; response will be presented instead. May be set at runtime using &#x60;bereq.first_byte_timeout&#x60;. (optional)
     * @param  string $healthcheck The name of the healthcheck to use with this backend. (optional)
     * @param  string $hostname The hostname of the backend. May be used as an alternative to &#x60;address&#x60; to set the backend location. (optional)
     * @param  string $ipv4 IPv4 address of the backend. May be used as an alternative to &#x60;address&#x60; to set the backend location. (optional)
     * @param  string $ipv6 IPv6 address of the backend. May be used as an alternative to &#x60;address&#x60; to set the backend location. (optional)
     * @param  int $keepalive_time How long in seconds to keep a persistent connection to the backend between requests. (optional)
     * @param  int $max_conn Maximum number of concurrent connections this backend will accept. (optional)
     * @param  string $max_tls_version Maximum allowed TLS version on SSL connections to this backend. If your backend server is not able to negotiate a connection meeting this constraint, a synthetic &#x60;503&#x60; error response will be generated. (optional)
     * @param  string $min_tls_version Minimum allowed TLS version on SSL connections to this backend. If your backend server is not able to negotiate a connection meeting this constraint, a synthetic &#x60;503&#x60; error response will be generated. (optional)
     * @param  string $name The name of the backend. (optional)
     * @param  string $override_host If set, will replace the client-supplied HTTP &#x60;Host&#x60; header on connections to this backend. Applied after VCL has been processed, so this setting will take precedence over changing &#x60;bereq.http.Host&#x60; in VCL. (optional)
     * @param  int $port Port on which the backend server is listening for connections from Fastly. Setting &#x60;port&#x60; to 80 or 443 will also set &#x60;use_ssl&#x60; automatically (to false and true respectively), unless explicitly overridden by setting &#x60;use_ssl&#x60; in the same request. (optional)
     * @param  string $request_condition Name of a Condition, which if satisfied, will select this backend during a request. If set, will override any &#x60;auto_loadbalance&#x60; setting. By default, the first backend added to a service is selected for all requests. (optional)
     * @param  string $share_key Value that when shared across backends will enable those backends to share the same health check. (optional)
     * @param  string $shield Identifier of the POP to use as a [shield](https://docs.fastly.com/en/guides/shielding). (optional)
     * @param  string $ssl_ca_cert CA certificate attached to origin. (optional)
     * @param  string $ssl_cert_hostname Overrides &#x60;ssl_hostname&#x60;, but only for cert verification. Does not affect SNI at all. (optional)
     * @param  bool $ssl_check_cert Be strict on checking SSL certs. (optional, default to true)
     * @param  string $ssl_ciphers List of [OpenSSL ciphers](https://www.openssl.org/docs/manmaster/man1/ciphers.html) to support for connections to this origin. If your backend server is not able to negotiate a connection meeting this constraint, a synthetic &#x60;503&#x60; error response will be generated. (optional)
     * @param  string $ssl_client_cert Client certificate attached to origin. (optional)
     * @param  string $ssl_client_key Client key attached to origin. (optional)
     * @param  string $ssl_hostname Use &#x60;ssl_cert_hostname&#x60; and &#x60;ssl_sni_hostname&#x60; to configure certificate validation. (optional)
     * @param  string $ssl_sni_hostname Overrides &#x60;ssl_hostname&#x60;, but only for SNI in the handshake. Does not affect cert validation at all. (optional)
     * @param  bool $use_ssl Whether or not to require TLS for connections to this backend. (optional)
     * @param  int $weight Weight used to load balance this backend against others. May be any positive integer. If &#x60;auto_loadbalance&#x60; is true, the chance of this backend being selected is equal to its own weight over the sum of all weights for backends that have &#x60;auto_loadbalance&#x60; set to true. (optional)
     *
     * @throws \Fastly\ApiException on non-2xx response
     * @throws \InvalidArgumentException
     * @return \Fastly\Model\BackendResponse
     */
    public static function BackendCreate($options)
    {
        $apiInstance = self::BackendInit();
          try {
              $result = $apiInstance->createBackend($options);
              print_r($result);
          } catch (Exception $e) {
              echo 'Exception when calling BackendApi->createBackend: ', $e->getMessage(), PHP_EOL;
          }
        return $result;
    }

    /**
     * Operation getBackend
     *
     * Describe a backend
     *
     * Note: the input parameter is an associative array with the keys listed as the parameter name below
     *
     * This operation contains host(s) defined in the OpenAP spec. Use 'hostIndex' to select the host.
     * URL: https://api.fastly.com
     *
     * @param  string $service_id Alphanumeric string identifying the service. (required)
     * @param  int $version_id Integer identifying a service version. (required)
     * @param  string $backend_name The name of the backend. (required)
     *
     * @throws \Fastly\ApiException on non-2xx response
     * @throws \InvalidArgumentException
     * @return \Fastly\Model\BackendResponse
     */
    public static function BackendDescribe($options)
    {
        $apiInstance = self::BackendInit();
        try {
            $result = $apiInstance->getBackend($options);
        } catch (Exception $e) {
            echo 'Exception when calling BackendApi->getBackend: ', $e->getMessage(), PHP_EOL;
        }
        return $result;
    }

    /**
     * Operation updateBackend
     *
     * Update a backend
     *
     * Note: the input parameter is an associative array with the keys listed as the parameter name below
     *
     * This operation contains host(s) defined in the OpenAP spec. Use 'hostIndex' to select the host.
     * URL: https://api.fastly.com
     *
     * @param  string $service_id Alphanumeric string identifying the service. (required)
     * @param  int $version_id Integer identifying a service version. (required)
     * @param  string $backend_name The name of the backend. (required)
     * @param  string $address A hostname, IPv4, or IPv6 address for the backend. This is the preferred way to specify the location of your backend. (optional)
     * @param  bool $auto_loadbalance Whether or not this backend should be automatically load balanced. If true, all backends with this setting that don&#39;t have a &#x60;request_condition&#x60; will be selected based on their &#x60;weight&#x60;. (optional)
     * @param  int $between_bytes_timeout Maximum duration in milliseconds that Fastly will wait while receiving no data on a download from a backend. If exceeded, the response received so far will be considered complete and the fetch will end. May be set at runtime using &#x60;bereq.between_bytes_timeout&#x60;. (optional)
     * @param  string $client_cert Unused. (optional)
     * @param  string $comment A freeform descriptive note. (optional)
     * @param  int $connect_timeout Maximum duration in milliseconds to wait for a connection to this backend to be established. If exceeded, the connection is aborted and a synthethic &#x60;503&#x60; response will be presented instead. May be set at runtime using &#x60;bereq.connect_timeout&#x60;. (optional)
     * @param  int $first_byte_timeout Maximum duration in milliseconds to wait for the server response to begin after a TCP connection is established and the request has been sent. If exceeded, the connection is aborted and a synthethic &#x60;503&#x60; response will be presented instead. May be set at runtime using &#x60;bereq.first_byte_timeout&#x60;. (optional)
     * @param  string $healthcheck The name of the healthcheck to use with this backend. (optional)
     * @param  string $hostname The hostname of the backend. May be used as an alternative to &#x60;address&#x60; to set the backend location. (optional)
     * @param  string $ipv4 IPv4 address of the backend. May be used as an alternative to &#x60;address&#x60; to set the backend location. (optional)
     * @param  string $ipv6 IPv6 address of the backend. May be used as an alternative to &#x60;address&#x60; to set the backend location. (optional)
     * @param  int $keepalive_time How long in seconds to keep a persistent connection to the backend between requests. (optional)
     * @param  int $max_conn Maximum number of concurrent connections this backend will accept. (optional)
     * @param  string $max_tls_version Maximum allowed TLS version on SSL connections to this backend. If your backend server is not able to negotiate a connection meeting this constraint, a synthetic &#x60;503&#x60; error response will be generated. (optional)
     * @param  string $min_tls_version Minimum allowed TLS version on SSL connections to this backend. If your backend server is not able to negotiate a connection meeting this constraint, a synthetic &#x60;503&#x60; error response will be generated. (optional)
     * @param  string $name The name of the backend. (optional)
     * @param  string $override_host If set, will replace the client-supplied HTTP &#x60;Host&#x60; header on connections to this backend. Applied after VCL has been processed, so this setting will take precedence over changing &#x60;bereq.http.Host&#x60; in VCL. (optional)
     * @param  int $port Port on which the backend server is listening for connections from Fastly. Setting &#x60;port&#x60; to 80 or 443 will also set &#x60;use_ssl&#x60; automatically (to false and true respectively), unless explicitly overridden by setting &#x60;use_ssl&#x60; in the same request. (optional)
     * @param  string $request_condition Name of a Condition, which if satisfied, will select this backend during a request. If set, will override any &#x60;auto_loadbalance&#x60; setting. By default, the first backend added to a service is selected for all requests. (optional)
     * @param  string $share_key Value that when shared across backends will enable those backends to share the same health check. (optional)
     * @param  string $shield Identifier of the POP to use as a [shield](https://docs.fastly.com/en/guides/shielding). (optional)
     * @param  string $ssl_ca_cert CA certificate attached to origin. (optional)
     * @param  string $ssl_cert_hostname Overrides &#x60;ssl_hostname&#x60;, but only for cert verification. Does not affect SNI at all. (optional)
     * @param  bool $ssl_check_cert Be strict on checking SSL certs. (optional, default to true)
     * @param  string $ssl_ciphers List of [OpenSSL ciphers](https://www.openssl.org/docs/manmaster/man1/ciphers.html) to support for connections to this origin. If your backend server is not able to negotiate a connection meeting this constraint, a synthetic &#x60;503&#x60; error response will be generated. (optional)
     * @param  string $ssl_client_cert Client certificate attached to origin. (optional)
     * @param  string $ssl_client_key Client key attached to origin. (optional)
     * @param  string $ssl_hostname Use &#x60;ssl_cert_hostname&#x60; and &#x60;ssl_sni_hostname&#x60; to configure certificate validation. (optional)
     * @param  string $ssl_sni_hostname Overrides &#x60;ssl_hostname&#x60;, but only for SNI in the handshake. Does not affect cert validation at all. (optional)
     * @param  bool $use_ssl Whether or not to require TLS for connections to this backend. (optional)
     * @param  int $weight Weight used to load balance this backend against others. May be any positive integer. If &#x60;auto_loadbalance&#x60; is true, the chance of this backend being selected is equal to its own weight over the sum of all weights for backends that have &#x60;auto_loadbalance&#x60; set to true. (optional)
     *
     * @throws \Fastly\ApiException on non-2xx response
     * @throws \InvalidArgumentException
     * @return \Fastly\Model\BackendResponse
     */
    public static function BackendUpdate($options)
    {
        $apiInstance = self::BackendInit();
        try {
            $result = $apiInstance->updateBackend($options);
        } catch (Exception $e) {
            echo 'Exception when calling BackendApi->updateBackend: ', $e->getMessage(), PHP_EOL;
        }
        return $result;
    }

    /**
     * Operation deleteBackend
     *
     * Delete a backend
     *
     * Note: the input parameter is an associative array with the keys listed as the parameter name below
     *
     * This operation contains host(s) defined in the OpenAP spec. Use 'hostIndex' to select the host.
     * URL: https://api.fastly.com
     *
     * @param  string $service_id Alphanumeric string identifying the service. (required)
     * @param  int $version_id Integer identifying a service version. (required)
     * @param  string $backend_name The name of the backend. (required)
     *
     * @throws \Fastly\ApiException on non-2xx response
     * @throws \InvalidArgumentException
     * @return \Fastly\Model\InlineResponse200
     */
    public static function BackendDelete($options)
    {
        $apiInstance = self::BackendInit();
        try {
            $result = $apiInstance->deleteBackend($options);
            print_r($result);
        } catch (Exception $e) {
            echo 'Exception when calling BackendApi->deleteBackend: ', $e->getMessage(), PHP_EOL;
        }
        return $result;
    }

    public static function VersionInit(): VersionApi
    {
        // Authorize the client with a Fastly API token.
        $config = Configuration::getDefaultConfiguration()->setApiToken($_ENV['fastly_api_token']);
        return new VersionApi(null, $config);
    }

    /**
     * Operation listServiceVersions
     *
     * List versions of a service
     *
     * Note: the input parameter is an associative array with the keys listed as the parameter name below
     *
     * This operation contains host(s) defined in the OpenAP spec. Use 'hostIndex' to select the host.
     * URL: https://api.fastly.com
     *
     * @param  string $service_id Alphanumeric string identifying the service. (required)
     *
     * @throws \Fastly\ApiException on non-2xx response
     * @throws \InvalidArgumentException
     * @return \Fastly\Model\VersionResponse[]
     */
    public static function ListServiceVersions($options)
    {
        $apiInstance = self::VersionInit();
        try {
            $result = $apiInstance->listServiceVersions($options);
            print_r($result);
        } catch (Exception $e) {
            echo 'Exception when calling VersionApi->listServiceVersions: ', $e->getMessage(), PHP_EOL;
        }
        return $result;
    }
    
    /**
     * Operation createServiceVersion
     *
     * Create a service version
     *
     * Note: the input parameter is an associative array with the keys listed as the parameter name below
     *
     * This operation contains host(s) defined in the OpenAP spec. Use 'hostIndex' to select the host.
     * URL: https://api.fastly.com
     *
     * @param  string $service_id Alphanumeric string identifying the service. (required)
     *
     * @throws \Fastly\ApiException on non-2xx response
     * @throws \InvalidArgumentException
     * @return \Fastly\Model\VersionCreateResponse
     */
    public static function CreateServiceVersion($service_id)
    {
        $apiInstance = self::VersionInit();
        $options = [
            'service_id' => $service_id,
          ];
          try {
              $result = $apiInstance->createServiceVersion($options);
          } catch (Exception $e) {
              echo 'Exception when calling VersionApi->createServiceVersion: ', $e->getMessage(), PHP_EOL;
          }
        return $result;
    }
    
    public static function Login($username, $password)
    {
        $client = new Client();

        try {
            $response = $client->post('https://api.fastly.com/oauth/access_token', [
                'headers' => [
                    'Accept' => 'application/vnd.api+json;q=1.0,application/json;q=0.9',
                    'Content-Type' => 'application/x-www-form-urlencoded; charset=UTF-8',
                    'Origin' => 'https://manage.fastly.com',
                    'Referer' => 'https://manage.fastly.com/'
                ],
                'form_params' => [
                    'client_id' => 'fastly-ui',
                    'grant_type' => 'password',
                    'password' => $password,
                    'username' => $username
                ]
            ]);

            $body = $response->getBody();
            return json_decode($body, true);
        } catch (RequestException $e) {
            if ($e->hasResponse()) {
                echo "Error: " . $e->getResponse()->getBody();
            } else {
                echo "Error: " . $e->getMessage();
            }
        }

    }

}