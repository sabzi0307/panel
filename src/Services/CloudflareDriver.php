<?php

declare(strict_types=1);

namespace App\Services;

use Cloudflare\API\Adapter\Guzzle;
use Cloudflare\API\Auth\APIKey;
use Cloudflare\API\Endpoints\DNS;
use Cloudflare\API\Endpoints\EndpointException;
use Cloudflare\API\Endpoints\Zones;

final class CloudflareDriver
{
    public static function modifyRecord(DNS $dns, $zoneID, $type, $recordID, $name, $content, $proxied = false): int
    {
        $details = ['type' => $type, 'name' => $name, 'content' => $content, 'proxied' => $proxied];
        if ($dns->updateRecordDetails($zoneID, $recordID, $details)->success === true) {
            return 1;
        }
        return 0;
    }

    public static function addRecord(DNS $dns, $zoneID, $type, $name, $content, $ttl = 120, $proxied = false): int
    {
        if ($dns->addRecord($zoneID, $type, $name, $content, $ttl, $proxied) === true) {
            return 1;
        }
        return 0;
    }

    /**
     * @throws EndpointException
     */
    public static function updateRecord($name, $content, $cf_mail, $cf_key, $proxied = false, $type = 'A'): void
    {
        $key = new APIKey($cf_mail, $cf_key);
        $adapter = new Guzzle($key);
        $zones = new Zones($adapter);
        $zoneID = null;

        $zoneID = $zones->getZoneID($cf_name);

        $dns = new DNS($adapter);

        $r = $dns->listRecords($zoneID, '', $name);
        $recordCount = $r->result_info->count;
        $records = $r->result;

        if ($recordCount === 0) {
            self::addRecord($dns, $zoneID, $type, $name, $content);
        } elseif ($recordCount >= 1) {
            foreach ($records as $record) {
                $recordID = $record->id;
                self::modifyRecord($dns, $zoneID, $type, $recordID, $name, $content, $proxied);
            }
        }
    }
}
