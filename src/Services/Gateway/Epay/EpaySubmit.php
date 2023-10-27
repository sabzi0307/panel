<?php

declare(strict_types=1);

namespace App\Services\Gateway\Epay;

final class EpaySubmit
{
    private array $alipay_config;
    private string $alipay_gateway_new;

    public function __construct($alipay_config)
    {
        $this->alipay_config = $alipay_config;
        $this->alipay_gateway_new = $this->alipay_config['apiurl'] . 'submit.php?';
    }

    public function buildRequestMysign($para_sort): string
    {
        //Concatenate all elements of the array into a string using the "&" character according to the pattern of "parameter = parameter value"
        $prestr = EpayTool::createLinkstring($para_sort);

        return EpayTool::sign($prestr, $this->alipay_config['key']);
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
        $para_sort['sign_type'] = strtoupper(trim($this->alipay_config['sign_type']));

        return $para_sort;
    }

    public function buildRequestForm($para_temp, $method = 'POST', $button_name = 'پرداخت'): string
    {
        //Array of parameters to be requested
        $para = $this->buildRequestPara($para_temp);
        $sHtml = "<form id='alipaysubmit' name='alipaysubmit' action='".
            $this->alipay_gateway_new . "' method='" . $method . "'>";

        foreach ($para as $key => $val) {
            $sHtml .= "<input type='hidden' name='".$key."' value='".$val."'/>";
        }
        //Please do not include the name attribute in the submit button control.
        $sHtml .= "<input type='submit' value='".$button_name."'></form>";
        $sHtml .= "<script>document.forms['alipaysubmit'].submit();</script>";

        return $sHtml;
    }
}
