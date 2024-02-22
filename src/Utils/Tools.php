<?php

declare(strict_types=1);

namespace App\Utils;

use App\Models\Config;
use App\Models\Link;
use App\Models\User;
use App\Services\GeoIP2;
use DateTime;
use GeoIp2\Exception\AddressNotFoundException;
use MaxMind\Db\Reader\InvalidDatabaseException;
use Morilog\Jalali\Jalalian;
use ParagonIE\Sodium;
use function array_diff;
use function array_flip;
use function base64_encode;
use function bin2hex;
use function closedir;
use function count;
use function date;
use function explode;
use function filter_var;
use function floor;
use function hash;
use function in_array;
use function is_numeric;
use function json_decode;
use function log;
use function mb_strcut;
use function opendir;
use function openssl_random_pseudo_bytes;
use function pow;
use function range;
use function readdir;
use function round;
use function shuffle;
use function strlen;
use function strpos;
use function substr;
use const FILTER_FLAG_IPV4;
use const FILTER_FLAG_IPV6;
use const FILTER_VALIDATE_EMAIL;
use const FILTER_VALIDATE_INT;
use const FILTER_VALIDATE_IP;

final class Tools
{
    /**
     * 查询IP归属
     *
     * @param string $ip
     *
     * @return string
     */
    public static function getIpLocation(string $ip): string
    {
        $data = 'سرویس GeoIP2 پیکربندی نشده است';
        $city = null;
        $country = null;

        if ($_ENV['maxmind_license_key'] !== '') {
            try {
                $geoip = new GeoIP2();
            } catch (InvalidDatabaseException $e) {
                return $data;
            }

            try {
                $city = $geoip->getCity($ip);
            } catch (AddressNotFoundException|InvalidDatabaseException $e) {
                $city = 'شهر نامعلوم';
            }

            try {
                $country = $geoip->getCountry($ip);
            } catch (AddressNotFoundException|InvalidDatabaseException $e) {
                $country = 'کشور ناشناخته';
            }

            try {
                $asn = $geoip->getAsn($ip);
            } catch (AddressNotFoundException $e) {
                $asn = 'اپراتور ناشناخته';
            }

            $res = "";
            if ($asn !== null && $asn !== 'اپراتور ناشناخته') {
                $provider = Tools::getServerAddr($asn->autonomousSystemNumber);
                if ($provider != "") {
                    $res = $provider . ', ';
                } else {
                    $res = $asn->autonomousSystemOrganization . ', ';
                }
                // return $city . ', ' . $country;
            }

            if ($city !== null && $country !== null) {
                $data = $city . ', ' . $country;
            } else if ($city == null && $country !== null) {
                $data = $country;
            } else if ($city !== null && $country == null) {
                $data = $city;
            }
        }

        return $data;
    }

    public static function getRemainingDays($date)
    {
        // تاریخ و زمان فعلی
        $currentDate = new DateTime();

        // تاریخ مشخص شده
        $targetDate = new DateTime($date);

        // محاسبه تفاوت بین دو تاریخ
        $interval = $currentDate->diff($targetDate);

        // استخراج تعداد روزهای باقیمانده
        return $interval;

    }

    public static function getServerAddr($asn): string
    {
        $server = "";
        if (isset($_ENV['Internet_Service_Providers'])) {
            foreach ($_ENV['Internet_Service_Providers'] as $provider) {
                if (in_array($asn, $provider['AsNum'])) {
                    $server = $provider['AsName'];
                    break;
                }
            }
        }
        return $server;
    }

    /**
     * 根据流量值自动转换单位输出
     *
     * @param $size
     * @param int $precision
     *
     * @return string
     */
    public static function autoBytes($size, int $precision = 2): string
    {
        if ($size <= 0) {
            return '0B';
        }

        if ($size > 1208925819614629174706176) {
            return '∞';
        }

        $base = log((float) $size, 1024);
        $units = ['B', 'KB', 'MB', 'GB', 'TB', 'PB', 'EB', 'ZB', 'YB'];

        return round(pow(1024, $base - floor($base)), $precision) . $units[floor($base)];
    }

    /**
     * 根据含单位的流量值转换 B 输出
     *
     * @param $size
     *
     * @return int|null
     */
    public static function autoBytesR($size): ?int
    {
        if (is_numeric(substr($size, 0, -1))) {
            return (int) substr($size, 0, -1);
        }

        $suffix = substr($size, -2);
        $base = substr($size, 0, strlen($size) - 2);
        $units = ['B', 'KB', 'MB', 'GB', 'TB', 'PB', 'EB'];

        if ($base > 999 && $suffix === 'EB') {
            return -1;
        }

        return (int) ($base * pow(1024, array_flip($units)[$suffix]));
    }

    /**
     * 根据速率值自动转换单位输出
     *
     * @param $size
     * @param int $precision
     *
     * @return string
     */
    public static function autoMbps($size, int $precision = 2): string
    {
        if ($size <= 0) {
            return '0Bps';
        }

        if ($size > 1000000000) {
            return '∞';
        }

        $base = log((float) $size, 1000);
        $units = ['Mbps', 'Gbps', 'Tbps'];

        return round(pow(1000, $base - floor($base)), $precision) . $units[floor($base)];
    }

    /**
     * 虽然名字是toMB，但是实际上功能是from MB to B
     *
     * @param $traffic
     *
     * @return int
     */
    public static function toMB($traffic): int
    {
        return (int) $traffic * 1048576;
    }

    /**
     * 虽然名字是toGB，但是实际上功能是from GB to B
     *
     * @param $traffic
     *
     * @return int
     */
    public static function toGB($traffic): int
    {
        return (int) $traffic * 1073741824;
    }

    /**
     * @param $traffic
     *
     * @return float
     */
    public static function flowToMB($traffic): float
    {
        return round($traffic / 1048576, 2);
    }

    /**
     * @param $traffic
     *
     * @return float
     */
    public static function flowToGB($traffic): float
    {
        return round($traffic / 1073741824, 2);
    }

    public static function genSubToken(): string
    {
        $token = self::genRandomChar($_ENV['sub_token_len']);
        $is_token_used = (new Link())->where('token', $token)->first();

        if ($is_token_used === null) {
            return $token;
        }

        return "couldn't alloc token";
    }

    public static function genRandomChar(int $length = 8): string
    {
        if ($length <= 2) {
            $length = 2;
        }

        return bin2hex(openssl_random_pseudo_bytes($length / 2));
    }

    public static function genSs2022UserPk($passwd, $len): string
    {
        $passwd_hash = hash('sha256', $passwd);

        $pk = match ($len) {
            16 => mb_strcut($passwd_hash, 0, 16),
            32 => mb_strcut($passwd_hash, 0, 32),
            default => $passwd_hash,
        };

        return base64_encode($pk);
    }

    public static function toDateTime(int $time): string
    {
        if ($time !== 0) {
            // return date('Y-m-d H:i:s', $time);
            $date = Jalalian::forge($time)->format('%A, %d %B %Y-H:i:s');
            return \Morilog\Jalali\CalendarUtils::convertNumbers($date);
        }
        return "نامشخص";
    }

    public static function getSsPort(): int
    {
        $max_port = Config::obtain('max_port');
        $min_port = Config::obtain('min_port');

        if ($min_port >= 65535
            || $min_port <= 0
            || $max_port > 65535
            || $max_port <= 0
            || $min_port > $max_port
            || count(User::all()) >= $max_port - $min_port + 1
        ) {
            return 0;
        }

        $det = (new User())->pluck('port')->toArray();
        $port = array_diff(range($min_port, $max_port), $det);
        shuffle($port);

        return $port[0];
    }

    /**
     * @param $dir
     *
     * @return array
     */
    public static function getDir($dir): array
    {
        $dirArray = [];
        $handle = opendir($dir);

        if ($handle !== false) {
            $i = 0;

            while (($file = readdir($handle)) !== false) {
                if ($file !== '.' && $file !== '..' && ! strpos($file, '.')) {
                    $dirArray[$i] = $file;
                    $i++;
                }
            }

            closedir($handle);
        }

        return $dirArray;
    }

    /**
     * @param $type
     * @param $str
     *
     * @return bool
     */
    public static function isParamValidate($type, $str): bool
    {
        $list = self::getSsMethod($type);

        if (in_array($str, $list)) {
            return true;
        }

        return false;
    }

    public static function getSsMethod($type): array
    {
        return match ($type) {
            'ss_obfs' => [
                'simple_obfs_http',
                'simple_obfs_http_compatible',
                'simple_obfs_tls',
                'simple_obfs_tls_compatible',
            ],
            default => [
                'aes-128-gcm',
                'aes-192-gcm',
                'aes-256-gcm',
                'chacha20-ietf-poly1305',
                'xchacha20-ietf-poly1305',
            ],
        };
    }

    /**
     * @param $email
     *
     * @return array
     */
    public static function isEmailLegal($email): array
    {
        $res = [];
        $res['ret'] = 0;

        if (! self::isEmail($email)) {
            $res['msg'] = 'ایمیل استاندارد نیست';
            return $res;
        }

        $mail_suffix = explode('@', $email)[1];
        $mail_filter_list = $_ENV['mail_filter_list'];

        switch ($_ENV['mail_filter']) {
            case 1:
                // 白名单
                if (in_array($mail_suffix, $mail_filter_list)) {
                    $res['ret'] = 1;
                } else {
                    $res['msg'] = 'نام دامنه ایمیل ' . $mail_suffix . ' نامعتبر است، لطفا آدرس ایمیل را تغییر دهید';
                }

                return $res;
            case 2:
                // 黑名单
                if (! in_array($mail_suffix, $mail_filter_list)) {
                    $res['ret'] = 1;
                } else {
                    $res['msg'] = 'نام دامنه ایمیل ' . $mail_suffix . ' نامعتبر است، لطفا آدرس ایمیل را تغییر دهید';
                }

                return $res;
            default:
                $res['ret'] = 1;
                return $res;
        }
    }

    /**
     * @param $input
     *
     * @return bool
     */
    public static function isEmail($input): bool
    {
        if (!filter_var($input, FILTER_VALIDATE_EMAIL)) {
            return false;
        }

        return true;
    }

    /**
     * @param $input
     *
     * @return bool
     */
    public static function isIPv4($input): bool
    {
        if (!filter_var($input, FILTER_VALIDATE_IP, FILTER_FLAG_IPV4)) {
            return false;
        }

        return true;
    }

    /**
     * @param $input
     *
     * @return bool
     */
    public static function isIPv6($input): bool
    {
        if (!filter_var($input, FILTER_VALIDATE_IP, FILTER_FLAG_IPV6)) {
            return false;
        }

        return true;
    }

    /**
     * @param $input
     *
     * @return bool
     */
    public static function isInt($input): bool
    {
        if (!filter_var($input, FILTER_VALIDATE_INT)) {
            return false;
        }

        return true;
    }

    /**
     * 判断是否 JSON
     * TODO: Remove this function when PHP 8.3 is minimum requirement and replace it with native function
     *
     * @param string $string
     *
     * @return bool
     */
    public static function isJson(string $string): bool
    {
        if (!json_decode($string)) {
            return false;
        }

        return true;
    }


    /**
     * 判断是否 JSON
     *
     * @param string $string
     *
     * @return string
     */

    public static function check_host($url): string
    {
        $ch = curl_init();
        curl_setopt_array($ch, [
            CURLOPT_URL => $url,
            CURLOPT_RETURNTRANSFER => true,
            CURLOPT_HTTPHEADER => ["Accept: application/json"],
        ]);

        $response = curl_exec($ch);

        if (curl_errno($ch)) {
            $tcp_results = [];
        } else {
            $request_id = json_decode($response, true)["request_id"];
            sleep(5);
            $tcp_results = Tools::get_check_host_results($request_id);

        }
        curl_close($ch);

        $json_pings = json_encode($tcp_results, JSON_PRETTY_PRINT);
        return $json_pings;
    }

    /**
     * 判断是否 JSON
     *
     * @param string $string
     *
     * @return string
     */
    public static function get_check_host_results($request_id): array
    {
        $json_pings = "خطا";
        $url = "https://check-host.net/check-result/" . $request_id;

        $ch = curl_init();
        curl_setopt_array($ch, [
            CURLOPT_URL => $url,
            CURLOPT_RETURNTRANSFER => true,
            CURLOPT_HTTPHEADER => ["Accept: application/json"],
        ]);

        $response = curl_exec($ch);


        if (curl_errno($ch)) {
            echo "cURL error: " . curl_error($ch);
        } else {
            $decoded_response = json_decode($response, true);

            $Tehran_ping = $Shiraz_ping = $Esfahan_ping = $Karaj_ping = 0;
            $Pings = [];

            if (!empty($decoded_response["ir1.node.check-host.net"])) {
                $count = 0;
                foreach ($decoded_response["ir1.node.check-host.net"][0] as $value) {
                    if (@$value[0] == "OK") {
                        $count++;
                        $Tehran_ping += $value[1];
                    }
                }
                if ($count !== 0) {
                    $Tehran_ping = (@$Tehran_ping / $count) * 1000;
                }

            }

            if (!empty($decoded_response["ir3.node.check-host.net"])) {
                $count = 0;
                foreach ($decoded_response["ir3.node.check-host.net"][0] as $value) {
                    if (@$value[0] == "OK") {
                        $count++;
                        $Shiraz_ping += $value[1];
                    }
                }
                if ($count !== 0) {
                    $Shiraz_ping = (@$Shiraz_ping / $count) * 1000;
                }


            }

            if (!empty($decoded_response["ir5.node.check-host.net"])) {
                $count = 0;
                foreach ($decoded_response["ir5.node.check-host.net"][0] as $value) {
                    if (@$value[0] == "OK") {
                        $count++;
                        $Esfahan_ping += $value[1];
                    }
                }
                if ($count !== 0) {
                    $Esfahan_ping = (@$Esfahan_ping / $count) * 1000;
                }

            }

            if (!empty($decoded_response["ir6.node.check-host.net"])) {
                $count = 0;
                foreach ($decoded_response["ir6.node.check-host.net"][0] as $value) {
                    if (@$value[0] == "OK") {
                        $count++;
                        $Karaj_ping += $value[1];
                    }
                }
                if ($count !== 0) {
                    $Karaj_ping = (@$Karaj_ping / $count) * 1000;
                }

            }

            $Pings = [
                "Tehran" => $Tehran_ping,
                "Esfahan" => $Esfahan_ping,
                "Shiraz" => $Shiraz_ping,
                "Karaj" => $Karaj_ping,
            ];

        }

        curl_close($ch);
        return $Pings;
    }


    /**
     * Generate a X25519 key pair for Diffie-Hellman key exchange.
     *
     * @param string|null $privateKey Optional private key in Base64 format.
     * @return array|false The generated key pair or false on error.
     */
    public static function x25519(?string $privateKey = null): array|false
    {
        if ($privateKey !== null) {
            $privateKeyBytes = sodium_base642bin($privateKey, SODIUM_BASE64_VARIANT_ORIGINAL_NO_PADDING);

            // Verify the private key
            if (strlen($privateKeyBytes) !== SODIUM_CRYPTO_BOX_SECRETKEYBYTES) {
                return false;
            }
        } else {
            $privateKeyBytes = random_bytes(SODIUM_CRYPTO_BOX_SECRETKEYBYTES);
        }
        
        // Modify random bytes using algorithm described at:
        // https://cr.yp.to/ecdh.html.
        $privateKeyBytes = unpack('C*', $privateKeyBytes);
        $privateKeyBytes[1] &= 248;
        $privateKeyBytes[SODIUM_CRYPTO_BOX_SECRETKEYBYTES] &= 127;
        $privateKeyBytes[SODIUM_CRYPTO_BOX_SECRETKEYBYTES] |= 64;
        $privateKey = pack('C*', ...$privateKeyBytes);


        $publicKey = sodium_crypto_scalarmult_base($privateKey);

        if ($publicKey === false) {
            return false;
        }

        $privateKeyBase64 = sodium_bin2base64($privateKey, SODIUM_BASE64_VARIANT_ORIGINAL_NO_PADDING);
        $publicKeyBase64 = sodium_bin2base64($publicKey, SODIUM_BASE64_VARIANT_ORIGINAL_NO_PADDING);

        $output = [
            'private_key' => $privateKeyBase64,
            'public_key' => $publicKeyBase64
        ];

        return $output;
    }

    public static function x25519Back(): array|false 
    {
        $privateKeyBytes = random_bytes(SODIUM_CRYPTO_BOX_SECRETKEYBYTES);

        // Modify random bytes using algorithm described at:
        // https://cr.yp.to/ecdh.html.
        $privateKeyBytes = unpack('C*', $privateKeyBytes);
        $privateKeyBytes[1] &= 248;
        $privateKeyBytes[SODIUM_CRYPTO_BOX_SECRETKEYBYTES] &= 127;
        $privateKeyBytes[SODIUM_CRYPTO_BOX_SECRETKEYBYTES] |= 64;
        $privateKey = pack('C*', ...$privateKeyBytes);

        $publicKey = sodium_crypto_scalarmult_base($privateKey);

        if ($publicKey === false) {
            return false;
        }

        $privateKeyBase64 = sodium_bin2base64($privateKey, SODIUM_BASE64_VARIANT_ORIGINAL_NO_PADDING);
        $publicKeyBase64 = sodium_bin2base64($publicKey, SODIUM_BASE64_VARIANT_ORIGINAL_NO_PADDING);

        $output = [
            'private_key' => $privateKeyBase64,
            'public_key' => $publicKeyBase64
        ];

        return $output;
    }

    /**
     * Verify the validity of a X25519 key pair.
     *
     * @param string $privateKey The private key in Base64 format.
     * @param string $publicKey The public key in Base64 format.
     * @return bool True if the key pair is valid, false otherwise.
     */
    public static function verifyX25519KeyPair(string $privateKey, string $publicKey): bool
    {
        $privateKeyBytes = sodium_base642bin($privateKey, SODIUM_BASE64_VARIANT_ORIGINAL_NO_PADDING);
        $publicKeyBytes = sodium_base642bin($publicKey, SODIUM_BASE64_VARIANT_ORIGINAL_NO_PADDING);

        // Check key sizes
        if (strlen($privateKeyBytes) !== SODIUM_CRYPTO_BOX_SECRETKEYBYTES || strlen($publicKeyBytes) !== SODIUM_CRYPTO_BOX_PUBLICKEYBYTES) {
            return false;
        }

        // Verify the public key using the private key
        $computedPublicKey = sodium_crypto_scalarmult_base($privateKeyBytes);
        if ($computedPublicKey === false || $publicKeyBytes !== $computedPublicKey) {
            return false;
        }

        return true;
    }

    /**
     * Generate a random short ID.
     *
     * @return array An array of 24 random hexadecimal strings.
     */
    public static function randomShortId(): array
    {
        $shortIds = array_fill(0, 24, '');

        for ($ii = 0; $ii < 24; $ii++) {
            $hexString = '';
            while (strlen($hexString) < 16) {
                $randomNum = self::randomInt(256);
                $hexString .= sprintf('%02x', $randomNum);
            }
            $shortIds[$ii] = substr($hexString, 0, 16);
        }

        return $shortIds;
    }

    /**
     * Generate a random integer between 0 and $max (exclusive).
     *
     * @param int $max The maximum value (exclusive).
     * @return int A random integer.
     */
    private static function randomInt(int $max): int
    {
        return mt_rand(0, $max - 1);
    }

}
