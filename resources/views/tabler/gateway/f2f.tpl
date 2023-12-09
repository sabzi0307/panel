<div class="card-inner">
    <h4>
        پرداخت حضوری Alipay
    </h4>
    <p class="card-heading"></p>
    <input hidden id="amount-f2fpay" name="amount-f2fpay" value="{$invoice->price}">
    <input hidden id="invoice_id" name="invoice_id" value="{$invoice->id}">
    <div id="f2f-qrcode"></div>
    <button class="btn btn-flat waves-attach" id="f2fpay-button" type="button" onclick="f2fpay();">
        ایجادQR Code
    </button>
</div>

<script>
    let pid = 0;

    function f2fpay() {
        $.ajax({
            type: "POST",
            url: "/user/payment/purchase/f2f",
            dataType: "json",
            data: {
                amount: $('#amount-f2fpay').val(),
                invoice_id: $('#invoice_id').val(),
            },
            success: (data) => {
                if (data.ret === 1) {
                    $('#f2fpay-button').remove();
                    pid = data.pid;
                    $('#f2f-qrcode').append('<div class="text-center"><p>پرداخت اسکن موبایل Alipay</p></div>');
                    new QRCode("f2f-qrcode", {
                        text: data.qrcode,
                        width: 200,
                        height: 200,
                        colorDark: '#000000',
                        colorLight: '#ffffff',
                        correctLevel: QRCode.CorrectLevel.H,
                    });
                    $('#f2f-qrcode').append('<div class="text-center my-3"><p>لطفاً پس از پرداخت موفقیت آمیز، صفحه را به صورت دستی بازخوانی کنید</p></div>');
                    $('#f2f-qrcode').attr('href', data.qrcode);
                } else {
                    $('#fail-message').text(data.msg);
                    $('#fail-dialog').modal('show');
                }
            }
        })
    }
</script>
