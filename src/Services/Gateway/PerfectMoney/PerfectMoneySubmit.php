<?php

declare(strict_types=1);

namespace App\Services\Gateway\PerfectMoney;

final class PerfectMoneySubmit
{
    private array $perfectmoney_config;
    private string $perfectmoney_gateway;

    public function __construct($alipay_config)
    {
        $this->perfectmoney_config = $alipay_config;
        $this->perfectmoney_gateway = $this->perfectmoney_config['apiurl'] . 'ev_create.asp';
    }


    public function buildRequestForm($para_temp, $method = 'POST', $button_name = 'پرداخت'): string
    {

        $sHtml = "<form id='perfectmoneysubmit' name='perfectmoneysubmit' action='".
            $this->perfectmoney_gateway . "' method='" . $method . "'>";

        foreach ($para_temp as $key => $val) {
            $sHtml .= "<input type='hidden' name='".$key."' value='".$val."'/>";
        }
        //Please do not include the name attribute in the submit button control.
        $sHtml .= "<input type='submit' value='".$button_name."'></form>";
        $sHtml .= "<script>document.forms['perfectmoneysubmit'].submit();</script>";

        return $sHtml;
    }
}
