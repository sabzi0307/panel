<?php

declare(strict_types=1);

namespace App\Services;

use GuzzleHttp\Client;
use GuzzleHttp\Exception\GuzzleException;
use RedisException;
use function json_decode;
use function round;

final class Exchange
{
    /**
     * @throws GuzzleException
     * @throws RedisException
     */
    public static function exchange(float $amount, string $from, string $to): float
    {
        return round($amount * self::getExchangeRate($from, $to), 2);
    }

    /**
     * @throws GuzzleException
     * @throws RedisException
     */
    public static function getExchangeRate(string $from, string $to): float
    {
        $redis = Cache::initRedis();
        $rate = $redis->get('exchange_rate:' . $from . '_' . $to);

        if (! $rate) {
            $client = new Client();
            $response = $client->get('https://cdn.moneyconvert.net/api/latest.json');
            $data = json_decode($response->getBody()->getContents(), true);
            $fromVal = $data['rates'][strtoupper($from)];
            $toVal = $data['rates'][strtoupper($to)];

            if (empty($fromVal) || strtoupper($from) == "IRR") {
                if (strtoupper($from) == "IRR") {
                    $from = "USDT";
                };
                $response = $client->get('https://api.bitpin.ir/v1/mkt/currencies/');
                $data = json_decode($response->getBody()->getContents(), true);
                foreach ($data['results'] as $item) {
                    if ($item['code'] == strtoupper($from)) {
                        $fromVal = $item['price_info']['price'];
                        break;
                    }
                }
            }

            if (empty($toVal) || strtoupper($to) == "IRR") {
                if (strtoupper($to) == "IRR") {
                    $to = "USDT";
                };
                $response = $client->get('https://api.bitpin.ir/v1/mkt/currencies/');
                $data = json_decode($response->getBody()->getContents(), true);
                foreach ($data as $item) {
                    if ($item['code'] == strtoupper($to)) {
                        $toVal = $item['price_info']['price'];
                        break;
                    }
                }
            }

            $rate = $toVal / $fromVal;
            $redis->setex('exchange_rate:' . $from . '_' . $to, 3600, $rate);
        }

        return (float) $rate;
    }
}
