<div class="card-inner">
    <div class="row">
        <div class="col-lg-6 col-md-6">
            <p class="card-heading">شارژ آنلاین Alipay/WeChat</p>
            <div class="form-group form-group-label">
                <label class="floating-label" for="amount-theadpay">مقدار</label>
                <input class="form-control" id="amount-theadpay" type="text">
            </div>
        </div>
        <div class="col-lg-6 col-md-6">
            <div class="h5 margin-top-sm text-black-hint" id="qrarea"></div>
        </div>
    </div>
</div>
<a class="btn btn-flat waves-attach" id="theadpay" onclick="theadpay();"><span class="mdi mdi-check"></span>&nbsp;اکنون شارژ کنید</a>
<script>
    var pid = 0;
    var flag = false;
    function theadpay() {
        $("#readytopay").modal('show');
        $.ajax({
            type: "POST",
            url: "/user/payment/purchase/theadpay",
            dataType: "json",
            data: {
                amount: $$getValue('amount-theadpay')
            },
            success: (data) => {
                if (data.ret) {
                    //console.log(data);
                    pid = data.pid;
                    $$.getElementById('qrarea').innerHTML = '<div class="text-center"><p>خواهش می کنم استفاده کنید<b>Alipay</b>یا<b>وی چت</b>برای پرداخت، کد QR را اسکن کنید</p><a id="qrcode" style="padding-top:10px;display:inline-block"></a><p>تلفن همراه می تواند برای پرداخت سریع روی کد QR کلیک کند</p></div>'
                    $("#readytopay").modal('hide');
                    new QRCode("qrcode", {
                        render: "canvas",
                        width: 200,
                        height: 200,
                        text: encodeURI(data.qrcode)
                    });
                    $$.getElementById('qrcode').setAttribute('href', data.qrcode);
                    if(flag == false){
                        setTimeout(fthead, 1000);
                        flag = true;
                    }else{
                        return 0;
                    }
                } else {
                    $("#result").modal();
                    $$.getElementById('msg').innerHTML = data.msg;
                }
            },
            error: (jqXHR) => {
                //console.log(jqXHR);
                $("#readytopay").modal('hide');
                $("#result").modal();
                $$.getElementById('msg').innerHTML = `${
                        jqXHR
                        } چیزی اشتباه شد`;
            }
        })
    }
    function fthead() {
        $.ajax({
            type: "POST",
            url: "/payment/status/theadpay",
            dataType: "json",
            data: {
                pid: pid
            },
            success: (data) => {
                if (data.result) {
                    //console.log(data);
                    $("#alipay").modal('hide');
                    $("#result").modal();
                    $$.getElementById('msg').innerHTML = 'شارژ مجدد با موفقیت انجام شد';
                    window.setTimeout("location.href=window.location.href", {$config['jump_delay']});
                }
            },
            error: (jqXHR) => {
                //console.log(jqXHR);
            }
        });
        tid = setTimeout(f, 1000); //循环调用触发setTimeout
    }
</script>
