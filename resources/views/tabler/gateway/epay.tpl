<div class="card-inner">
    <h4>
        شارژ آنلاین epay
    <h4>
    <p class="card-heading"></p>
    <form class="epay" name="epay" action="/user/payment/purchase/epay" method="post">
        <input class="form-control maxwidth-edit" id="price" name="price" placeholder="مبلغ را وارد کرده و کانال پرداخت را در زیر انتخاب کنید"
            autofocus="autofocus" type="number" min="0.01" max="1000" step="0.01" required="required">
        <br />
        {if $config['epay_alipay'] == true}
        <button class="btn btn-flat waves-attach" id="btnSubmit" type="submit" name="type" value="alipay">
            <img src="/images/alipay.png" height="50px" />
        </button>
        {/if}
        {if $config['epay_wechat'] == true}
        <button class="btn btn-flat waves-attach" id="btnSubmit" type="submit" name="type" value="wxpay">
            <img src="/images/wechat.png" height="50px" />
        </button>
        {/if}
        {if $config['epay_qq'] == true}
        <button class="btn btn-flat waves-attach" id="btnSubmit" type="submit" name="type" value="qqpay">
            <img src="/images/qqpay.png" height="50px" />
        </button>
        {/if}
        {if $config['epay_usdt'] == true}
        <button class="btn btn-flat waves-attach" id="btnSubmit" type="submit" name="type" value=usdt">
            <img src="/images/usdt.png" height="50px" />
        </button>
        {/if}
    </form>
</div>