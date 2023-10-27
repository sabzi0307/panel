<?php

declare(strict_types=1);

namespace App\Services\Gateway\PerfectMoney;

final class PerfectMoneyTool
{

    public static function verify($para, $passphrase): bool
    {
        $hashed_passphrase = strtoupper(md5($passphrase));
        $fields = $para['PAYMENT_ID'] . ':' . $para['PAYEE_ACCOUNT'] . ':' . $para['PAYMENT_AMOUNT'] . ':' . $para['PAYMENT_UNITS'] . ':' . $para['PAYMENT_BATCH_NUM'] . ':' . $para['PAYER_ACCOUNT'] . ':' . $hashed_passphrase . ':' . $para['TIMESTAMPGMT'];

        $correct_sgin = strtoupper(md5($fields));
        return $correct_sgin === $para['V2_HASH'];
    }
}