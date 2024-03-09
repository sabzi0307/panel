<?php

declare(strict_types=1);

namespace App\Services;
use App\Utils\Tools;
use Fastly\Configuration;
use Fastly\Api\ServiceApi;
use Fastly\Api\DomainApi;
use Fastly\Api\BackendApi;
use Fastly\Api\PackageApi;
use Fastly\Api\VersionApi;
use Fastly\Api\TokensApi;
use Fastly\Api\SudoApi;
use Faker\Factory;
use SplFileObject;
use Phar;
use PharData;
use GuzzleHttp\Client;
use GuzzleHttp\Exception\ClientException;
use GuzzleHttp\Exception\RequestException;
use Exception;

final class Fastly
{

    private string $token;
    private string $username;
    private string $password;

    public static function DomainInit($token): DomainApi
    {
        // Authorize the client with a Fastly API token.
        $config = Configuration::getDefaultConfiguration()->setApiToken($token);
                return new DomainApi(null, $config);
    }

    public static function addDomainToService($token, $Service_id, $version_id, $name, $max_retries = 3, $retry_delay = 2)
    {
        $doaminName = empty($name) ? self::newDomainName() : $name; 

        $apiInstance = self::DomainInit($token);
        $retries = 0;

        while ($retries <= $max_retries) {
            try {
                $result = $apiInstance->createDomain([
                    'service_id' => $Service_id,
                    'version_id' => $version_id,
                    'name' => $doaminName,
                ]);
                return [$result, null];
            } catch (Exception $e) {
                if ($e->getCode() == 400 && $retries < $max_retries) {
                    $doaminName = self::newDomainName(); 
                    $retries++;
                    sleep($retry_delay); // Add a delay before retrying
                    continue;
                }
                return [null, $e->getMessage()];
            }
        }

        // If we reach this point, it means we exhausted all retries
        return [null, 'Maximum retries exceeded'];
    }

    public static function listServiceDomains($token, $Service_id, $version_id)
    {
        $apiInstance = self::DomainInit($token);

            try {
                $result = $apiInstance->listDomains([
                    'service_id' => $Service_id,
                    'version_id' => $version_id,
                ]);
                return [$result, null];
            } catch (Exception $e) {
                return [null, $e->getMessage()];
            }

    }

    public static function getServiceDomain($token, $Service_id, $version_id)
    {
        [$domains, $error] = self::listServiceDomains($token, $Service_id, $version_id);
        if ($error) {
            return [null, false, $error];
        }
        // Assuming $response is the result returned from the function
        if (is_array($domains) && isset($domains[0]) && is_array($domains[0])) {
            return [$domains[0], true, null];
        } else {
            return [null, false, null];
        }

    }

    public static function ServiceInit($token): ServiceApi
    {
        // Authorize the client with a Fastly API token.
        $config = Configuration::getDefaultConfiguration()->setApiToken($token);
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
    public static function ServicesList($token)
    {
        $apiInstance = self::ServiceInit($token);
        $options = [
            'direction' => 'ascend',
            'page' => 1,
            'per_page' => 20,
            'sort' => 'created',
          ];
          try {
            $result = $apiInstance->listServices($options);
            return [$result, null];
        } catch (Exception $e) {
            return [null, $e->getMessage()];
          }
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
     * @return [\Fastly\Model\ServiceResponse, string]
     */
    public static function ServicesCreate($options, $token)
    {
        $apiInstance = self::ServiceInit($token);
        try {
            $result = $apiInstance->createService($options);
            return [$result, null];
        } catch (Exception $e) {
            $errorMessage = $e->getMessage();
            $errorCode = $e->getCode();
            
            // Check if the error code is 409 (Conflict)
            if ($errorCode === 409) {
                // Handle the 409 error specifically
                return self::ServiceGetByName("tunnel-passthrough", $token);
            } else {
                // Return the original error message for other errors
                return [null, $errorMessage];
            }
        }
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
     * @return array
     */
    public static function ServiceGetDetails($id, $version, $token)
    {
        $apiInstance = self::ServiceInit($token);
        $options = [
            'service_id' => $id,
            'version' => $version,
          ];
          try {
            $result = $apiInstance->getServiceDetail($options);
            return [$result, null];
        } catch (Exception $e) {
            return [null, $e->getMessage()];
          }

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
     * @return array
     */
    public static function ServiceGetByName($name, $token)
    {
        $apiInstance = self::ServiceInit($token);
        $options = [
            'name' => $name,
          ];
          try {
            $result = $apiInstance->searchService($options);
            return [$result, null];
        } catch (Exception $e) {
            return [null, $e->getMessage()];
          }

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
     * @return array
     */
    public static function ServiceGetById($id, $token)
    {
        $apiInstance = self::ServiceInit($token);
        $options = [
            'service_id' => $id,
          ];
          try {
            $result = $apiInstance->getService($options);
            return [$result, null];
        } catch (Exception $e) {
            return [null, $e->getMessage()];
          }

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
     * @return array
     */
    public static function ServiceDelete($id, $token)
    {
        $apiInstance = self::ServiceInit($token);
        $options = [
            'service_id' => $id,
          ];
          try {
            $result = $apiInstance->deleteService($options);
            return [$result, null];
        } catch (Exception $e) {
            return [null, $e->getMessage()];
          }

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
     * @return array
     */
     public static function ServiceListDomains($id, $token)
    {
        $apiInstance = self::ServiceInit($token);
        $options = [
            'service_id' => $id,
          ];
          try {
            $result = $apiInstance->listServiceDomains($options);
            return [$result, null];
          } catch (Exception $e) {
            return [null, $e->getMessage()];
            }

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
     */
     public static function PackageUpload($token, $id, $version, $package)
    {
        $config = Configuration::getDefaultConfiguration()->setApiToken($token);
        $apiInstance = new PackageApi(null, $config);
        $options = [
            'service_id' => $id,
            'version_id' => $version,
            'package' => $package,
          ];
          try {
            $result = $apiInstance->putPackage($options);
            return [$result, null];
        } catch (Exception $e) {
            return [null, $e->getMessage()];
        }
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
    
    public static function Login($username, $password): array
    {
        try {
            $client = new Client([
                'headers' => [
                    'Accept' => 'application/vnd.api+json;q=1.0,application/json;q=0.9',
                    'Accept-Language' => 'en-US,en;q=0.9',
                    'Cache-Control' => 'no-cache',
                    'Content-Type' => 'application/x-www-form-urlencoded; charset=UTF-8',
                    'Fastly-UI-Client' => 'umbrella-auth, version=4c783c22ed937f3f1dc69c469d1f973ffcf21690',
                    'Pragma' => 'no-cache',
                    'Sec-Ch-Ua' => '"Chromium";v="122", "Not(A:Brand";v="24", "Google Chrome";v="122"',
                    'Sec-Ch-Ua-Mobile' => '?0',
                    'Sec-Ch-Ua-Platform' => '"macOS"',
                    'Sec-Fetch-Dest' => 'empty',
                    'Sec-Fetch-Mode' => 'cors',
                    'Sec-Fetch-Site' => 'same-site',
                    'Referer' => 'https://manage.fastly.com/',
                    'Referrer-Policy' => 'origin-when-cross-origin',
                ],
            ]);

            $response = $client->post('https://api.fastly.com/oauth/access_token', [
                'form_params' => [
                    'client_id' => 'fastly-ui',
                    'grant_type' => 'password',
                    'password' => $password,
                    'username' => $username,
                ],
            ]);

            if ($response->getStatusCode() === 200) {
                $res = $response->getBody()->getContents();
                return [$res, null];
            } else {
                return [null, $response->getBody()];
            }
        } catch (ClientException $e) {
            return [null, $e->getMessage()];
        } catch (Exception $e) {
            return [null, $e->getMessage()];
        }

    }

    public static function addToken($loginAccess, $username, $password): array
    {

        [$sudoToken, $error] = self::sudo($loginAccess, $username, $password);
        if ($error) {
            return [null, $error];
        }

        $config = Configuration::getDefaultConfiguration()->setApiToken($loginAccess['access_token']);
        $apiInstance = new TokensApi(null, $config);
        $options = [
            'name' => 'SSPANEL',
            'scope' => 'global',
            'services' => [],
            // 'username' => $username,
            // 'password' => $password,
          ];
          try {
              $result = $apiInstance->createToken($options);
              return [$result, null];
          } catch (Exception $e) {
              return [null, $e->getMessage()];
          }

    }
    
    public static function sudo($loginAccess, $username, $password): array
    {

        $config = Configuration::getDefaultConfiguration()->setApiToken($loginAccess['access_token']);
        $apiInstance = new SudoApi(null, $config);
        $options = [
            'sudo_request' => [
              'username' => $username,
              'password' => $password,
            ],
          ];
          try {
              $result = $apiInstance->requestSudoAccess($options);
              return [$result, null];
          } catch (Exception $e) {
              return [null, $e->getMessage()];
          }

    }

    public static function getUserFromToken($access_token)
    {
        $client = new Client();

        try {
            $response = $client->get('https://api.fastly.com/current_user', [
                'headers' => [
                    'Accept' => 'application/vnd.api+json;q=1.0,application/json;q=0.9',
                    'Content-Type' => 'application/x-www-form-urlencoded; charset=UTF-8',
                    'Authority' => 'api.fastly.com',
                    'Origin' => 'https://manage.fastly.com',
                    'Referer' => 'https://manage.fastly.com/',
                    'fastly-key' => $access_token
                ]
            ]);

            $body = $response->getBody()->getContents();
            $currentUser = json_decode($body, true);
            if (! $currentUser ) {
                return [null, 'مقدار توکن صحیح نیست.'];
            }
    
            if ($currentUser["role"] !== "superuser") {
                return [null, 'این توکن دسترسی مورد نیاز را ندارد.'];
            }
            
            if ($currentUser["deleted_at"] !== null) {
                return [null, 'این اکانت حذف شده است.'];
            }
    
            if ($currentUser["locked"] !== null) {
                return [null, 'این اکانت قفل شده است.'];
            }
    
            if ($currentUser["require_new_password"] !== null) {
                return [null, 'این اکانت درخواست ویرایش رمز را ارسال کرده.'];
            }
    
            if ($currentUser["limit_services"] !== false) {
                return [null, 'این توکن محدود شده است.'];
            }
    
            if ($currentUser["two_factor_auth_enabled"] !== null) {
                return [null, 'این توکن دارای احراز هویت دو عاملی است.'];
            }
            return [$body, null];

        } catch (RequestException $e) {
            if ($e->hasResponse()) {
                return [null, $e->getResponse()->getBody()];
            } else {
                return [null, $e->getMessage()];
            }
        }

    }
    public static function isValidFanout()
    {
        $client = new Client();

        try {
            $response = $client->get('https://api.fastly.com/entitled-products/fanout', [
                'headers' => [
                    'Accept' => 'application/vnd.api+json;q=1.0,application/json;q=0.9',
                    'Content-Type' => 'application/x-www-form-urlencoded; charset=UTF-8',
                    'Authority' => 'api.fastly.com',
                    'Origin' => 'https://manage.fastly.com',
                    'Referer' => 'https://manage.fastly.com/',
                    'fastly-key' => self::$token
                ]
            ]);

            $body = $response->getBody()->getContents();
            $fanout = json_decode($body, true);

            if (! $fanout["has_access"]) {
                return [null, 'شما به سرویس Fanout دسترسی ندارید.'];
            }
    
            if (! $fanout["has_permission_to_enable"]) {
                return [null, 'شما دسترسی لازم را برای فعال سازی سرویس Fanout ندارید.'];
            }
    
            if (stripos($fanout["access_level"], 'trial') !== false) {
                $fanout_access_level = $fanout["access_level"];
                $fanout_limit = $fanout["limit"]["trial_access_expires_on"];
                $fanout_remain = Tools::getRemainingDays($fanout_limit);
                if ($fanout_remain->invert) {
                    return [null, 'سرویس Fanout آزمایشی شما در ' . $fanout_remain->days . ' روز پیش منقضی شده.'];
                }
    
                if ($fanout_remain->days < 2) {
                    return [null, 'کمتر از ' . $fanout_remain->days-1 . 'روز از زمان اعتبار سرویس Fanout باقی مانده.'];
                }
            }
            return [$fanout, null];
        } catch (RequestException $e) {
            if ($e->hasResponse()) {
                return [null, $e->getResponse()->getBody()];
            } else {
                return [null, $e->getMessage()];
            }
        }

    }

    public static function newDomainName()
    {
        $faker = Factory::create();
        $domain = '';
        for ($i = 0; $i < 3; $i++) {
            $domain .= $faker->unique($reset = true)->word();
            if ($i < 2) {
                $domain .= "-";

            }
        }
        $domain .= ".edgecompute.app";
        return $domain;
    }

    public static function isValidWebSockets($access_token)
    {
        $client = new Client();

        try {
            $response = $client->get('https://api.fastly.com/entitled-products/websockets', [
                'headers' => [
                    'Accept' => 'application/vnd.api+json;q=1.0,application/json;q=0.9',
                    'Content-Type' => 'application/x-www-form-urlencoded; charset=UTF-8',
                    'Authority' => 'api.fastly.com',
                    'Origin' => 'https://manage.fastly.com',
                    'Referer' => 'https://manage.fastly.com/',
                    'fastly-key' => $access_token
                ]
            ]);

            $body = $response->getBody()->getContents();
            $ws = json_decode($body, true);
            if (! $ws["has_access"]) {
                return [null, 'شما به سرویس WebSocket دسترسی ندارید.'];
            }
    
            if (! $ws["has_permission_to_enable"]) {
                return [null, 'شما دسترسی لازم را برای فعال سازی سرویس WebSocket ندارید.'];
            }
            
            if (stripos($ws["access_level"], 'trial') !== false) {
    
                $ws_limit = $ws["limit"]["trial_access_expires_on"];
                $ws_remain = Tools::getRemainingDays($ws_limit);
                if ($ws_remain->invert) {
                    return [null, 'سرویس WebSocket آزمایشی شما در ' . $ws_remain->days . ' روز پیش منقضی شده.'];
                }
    
                if ($ws_remain->days < 2) {
                    return [null, 'کمتر از ' . $ws_remain->days . 'روز از زمان اعتبار سرویس WebSocket باقی مانده.'];
                }
            }
            return [$body, null];
        } catch (RequestException $e) {
            if ($e->hasResponse()) {
                return [null, $e->getResponse()->getBody()];
            } else {
                return [null, $e->getMessage()];
            }
        }

    }

    public static function validateTrials($access_token)
    {
        $client = new Client();

        try {
            $response = $client->get('https://api.fastly.com/trials?include=creator_name', [
                'headers' => [
                    'Accept' => 'application/vnd.api+json;q=1.0,application/json;q=0.9',
                    'Content-Type' => 'application/x-www-form-urlencoded; charset=UTF-8',
                    'Authority' => 'api.fastly.com',
                    'Origin' => 'https://manage.fastly.com',
                    'Referer' => 'https://manage.fastly.com/',
                    'fastly-key' => $access_token
                ]
            ]);

            $body = $response->getBody()->getContents();
            return [$body, null];
        } catch (RequestException $e) {
            if ($e->hasResponse()) {
                return [null, $e->getResponse()->getBody()];
            } else {
                return [null, $e->getMessage()];
            }
        }

    }
    
    public static function getComputeWasm($serviceId, $name = "Tunnel passthrough")
    {
        $tarFilePath = BASE_PATH . '/resources/extra/fastly/Tunnel-passthrough.tar';
        $tarGzFilePath = BASE_PATH . '/resources/extra/fastly/Tunnel-passthrough.tar.gz';
        unlink($tarFilePath);
        unlink($tarGzFilePath);
        // Create a PharData instance for the tar file
        $phar = new PharData($tarFilePath);

        // Build the archive from the specified directory
        $phar->buildFromDirectory(BASE_PATH . '/resources/extra/fastly');

        // Convert TOML data to string
        $tomlString = "authors = [\"<oss@fastly.com>\"]\n";
        $tomlString .= "description = \"Tunnel passthrough.\"\n";
        $tomlString .= "language = \"rust\"\n";
        $tomlString .= "manifest_version = 3\n";
        $tomlString .= "name = \"{$name}\"\n";
        $tomlString .= "service_id = \"{$serviceId}\"\n";

        // Add or update the file with the new content
        $phar->addFromString('fastly.toml', $tomlString);

        // Compress the Phar archive
        $phar->compress(Phar::GZ);

        // Delete the temporary tar and tar.gz files
        unlink($tarFilePath);
        // unlink($tarGzFilePath);

        return $tarGzFilePath;
    }

}