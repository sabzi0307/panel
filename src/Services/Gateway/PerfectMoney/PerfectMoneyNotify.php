<?php

declare(strict_types=1);

namespace App\Services\Gateway\PerfectMoney;

use function is_null;

final class PerfectMoneyNotify
{
    private array $perfectmoney_config;

    public function __construct($perfectmoney_config)
    {
        $this->perfectmoney_config = $perfectmoney_config;
    }

    public static function verify($para, $passphrase): bool
    {
        $hashed_passphrase = strtoupper(md5($passphrase));
        $fields = $para['PAYMENT_ID'] . ':' . $para['PAYEE_ACCOUNT'] . ':' . $para['PAYMENT_AMOUNT'] . ':' . $para['PAYMENT_UNITS'] . ':' . $para['PAYMENT_BATCH_NUM'] . ':' . $para['PAYER_ACCOUNT'] . ':' . $hashed_passphrase . ':' . $para['TIMESTAMPGMT'];

        $correct_sgin = strtoupper(md5($fields));
        return $correct_sgin === $para['V2_HASH'];
    }

    public function verifyNotify(): bool
    {
        if (is_null($_GET)) {//Determine whether the array from POST is empty
            return false;
        }
        //Generate signature results
        return self::verify($_GET, $this->perfectmoney_config['alter_pass_Phrase']);;
    }
}
