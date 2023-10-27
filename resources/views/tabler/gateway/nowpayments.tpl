<div class="card-inner">
    <h4>
        شارژ آنلاین NowPayments
    </h4>
    <p class="card-heading"></p>
    <form class="nowpayments" name="nowpayments" action="/user/payment/purchase/nowpayments" method="post">
        <input hidden id="price" name="price" value="{$invoice->price}">
        <input hidden id="invoice_id" name="invoice_id" value="{$invoice->id}">
        {* {if $public_setting['nowpayments']} *}
            <button class="btn btn-flat waves-attach" id="btnSubmit" type="submit">
                <img src="/images/nowpayments.png" height="50px" />
            </button>
            <br>
            <br>
            <div id="nowpayments-qrcode"></div>
            <button class="btn btn-flat waves-attach" id="nowpayments-qr-button" type="button" onclick="qrpay();">
                ایجادQR Code
            </button>
        {* {/if} *}
    </form>
</div>

<script>
    var pid = 0;

    function qrpay() {
        $.ajax({
            type: "POST",
            url: "/user/payment/purchase/nowpayments",
            dataType: "json",
            data: {
                price: $('#price').val(),
                invoice_id: $('#invoice_id').val(),
                qr: 1,
            },
            success: (data) => {
                if (data.ret === 1) {
                    $('#nowpayments-qr-button').remove();
                    pid = data.pid;
                    $('#nowpayments-qrcode').append('<div class="text-center"><p>پرداخت با QR</p></div>');
                    new QRCode("nowpayments-qrcode", {
                        text: data.qrcode,
                        width: 200,
                        height: 200,
                        colorDark: '#000000',
                        colorLight: '#ffffff',
                        correctLevel: QRCode.CorrectLevel.H,
                    });
                    $('#nowpayments-qrcode').append('<div class="text-center my-3"><p>لطفاً پس از پرداخت موفقیت آمیز، صفحه را به صورت دستی بازخوانی کنید</p></div>');
                    $('#nowpayments-qrcode').attr('href', data.qrcode);
                } else {
                    $('#fail-message').text(data.msg);
                    $('#fail-dialog').modal('show');
                }
            }
        })
    }
</script>