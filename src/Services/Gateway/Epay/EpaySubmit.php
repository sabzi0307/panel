<?php

declare(strict_types=1);

namespace App\Services\Gateway\Epay;

final class EpaySubmit
{
    private array $epay_config;
    private string $epay_gateway;

    public function __construct($epay_config)
    {
        $this->epay_config = $epay_config;
        $this->epay_gateway = $this->epay_config['apiurl'] . 'submit.php?';
    }

    public function buildRequestMysign($para_sort): string
    {
        //Concatenate all elements of the array into a string using the "&" character according to the pattern of "parameter = parameter value"
        $prestr = EpayTool::createLinkstring($para_sort);

        return EpayTool::sign($prestr, $this->epay_config['key']);
    }

    public function buildRequestPara($para_temp)
    {
        //Remove null values and signature parameters in the parameter array to be signed
        $para_filter = EpayTool::paraFilter($para_temp);
        //Sort array of parameters to be signed
        $para_sort = EpayTool::argSort($para_filter);
        //Generate signature results
        $mysign = $this->buildRequestMysign($para_sort);
        //The signature result and signature method are added to the request submission parameter group.
        $para_sort['sign'] = $mysign;
        $para_sort['sign_type'] = strtoupper(trim($this->epay_config['sign_type']));

        return $para_sort;
    }

    public function buildRequestForm($para_temp, $method = 'POST', $button_name = 'پرداخت'): string
    {
        //Array of parameters to be requested
        $para = $this->buildRequestPara($para_temp);
        $html = "<form id='alipaysubmit' name='alipaysubmit' action='".
            $this->epay_gateway . "' method='" . $method . "'>";

        foreach ($para as $key => $val) {
            $html .= "<input type='hidden' name='".$key."' value='".$val."'/>";
        }
        //Please do not include the name attribute in the submit button control.
        $html .= "<input type='submit' value='".$button_name."'></form>";
        $html .= "<script>document.forms['alipaysubmit'].submit();</script>";

        return $html;
    }
}
