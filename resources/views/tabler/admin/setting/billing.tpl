{include file='admin/tabler_header.tpl'}

<div class="page-wrapper">
    <div class="container-xl">
        <div class="page-header d-print-none text-white">
            <div class="row align-items-center">
                <div class="col">
                    <h2 class="page-title">
                        <span class="home-title">تنظیمات مالی</span>
                    </h2>
                    <div class="page-pretitle my-3">
                        <span class="home-subtitle">سیستم مالی سایت خود را راه اندازی کنید</span>
                    </div>
                </div>
                <div class="col-auto ms-auto d-print-none">
                    <div class="btn-list">
                        <a id="save-setting" href="#" class="btn btn-primary">
                            <i class="icon ti ti-device-floppy"></i>
                            ذخیره
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div class="page-body">
        <div class="container-xl">
            <div class="row row-deck row-cards">
                <div class="col-md-12">
                    <div class="card">
                    <div class="card-header">
                    <ul class="nav nav-tabs card-header-tabs" data-bs-toggle="tabs">
                        <li class="nav-item">
                            <a href="#gateway" class="nav-link active" data-bs-toggle="tab">انتخاب درگاه پرداخت</a>
                        </li>
                        <li class="nav-item">
                            <a href="#f2f" class="nav-link" data-bs-toggle="tab">پرداخت حضوری Alipay</a>
                        </li>
                        <li class="nav-item">
                            <a href="#stripe" class="nav-link" data-bs-toggle="tab">Stripe</a>
                        </li>
                        <li class="nav-item">
                            <a href="#epay" class="nav-link" data-bs-toggle="tab">EPay</a>
                        </li>
                        <li class="nav-item">
                            <a href="#paypal" class="nav-link" data-bs-toggle="tab">PayPal</a>
                        </li>
                    </ul>
                </div>
                <div class="card-body">
                    <div class="tab-content">
                        <div class="tab-pane active show" id="gateway">
                            {foreach $payment_gateways as $key => $value}
                            <div class="form-group mb-3 row">
                                <div class="row align-items-center">
                                    <label class="form-label col-3 col-form-label">{$key}</label>
                                    <label class="col-auto ms-auto form-check form-check-single form-switch">
                                        <input id="{$value}_enable" class="form-check-input" type="checkbox"
                                        {if in_array($value, $active_payment_gateway)}checked="" {/if}>
                                    </label>
                                </div>
                            </div>
                            {/foreach}
                        </div>
                        <div class="tab-pane" id="f2f">
                            <div class="card-body">
                                <div class="form-group mb-3 row">
                                    <label class="form-label col-3 col-form-label">App ID</label>
                                    <div class="col">
                                        <input id="f2f_pay_app_id" type="text" class="form-control" value="{$settings['f2f_pay_app_id']}">
                                    </div>
                                </div>
                                <div class="form-group mb-3 row">
                                    <label class="form-label col-3 col-form-label">PID</label>
                                    <div class="col">
                                        <input id="f2f_pay_pid" type="text" class="form-control" value="{$settings['f2f_pay_pid']}">
                                    </div>
                                </div>
                                <div class="form-group mb-3 row">
                                    <label class="form-label col-3 col-form-label">کلید عمومی Alipay</label>
                                    <div class="col">
                                        <input id="f2f_pay_public_key" type="text" class="form-control" value="{$settings['f2f_pay_public_key']}">
                                    </div>
                                </div>
                                <div class="form-group mb-3 row">
                                    <label class="form-label col-3 col-form-label">کلید خصوصی اپلیکیشن</label>
                                    <div class="col">
                                        <input id="f2f_pay_private_key" type="text" class="form-control" value="{$settings['f2f_pay_private_key']}">
                                    </div>
                                </div>
                                <div class="form-group mb-3 row">
                                    <label class="form-label col-3 col-form-label">Custom callback address (optional)</label>
                                    <div class="col">
                                        <input id="f2f_pay_notify_url" type="text" class="form-control" value="{$settings['f2f_pay_notify_url']}">
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="tab-pane" id="stripe">
                            <div class="card-body">
                                <div class="form-group mb-3 row">
                                    <label class="form-label col-3 col-form-label">پرداخت کارت بانکی</label>
                                    <div class="col">
                                        <select id="stripe_card" class="col form-select" value="{$settings['stripe_card']}">
                                            <option value="0">غیر فعال</option>
                                            <option value="1" {if $settings['stripe_card'] === true}selected{/if}>فعال کردن</option>
                                        </select>
                                    </div>
                                </div>
                                <div class="form-group mb-3 row">
                                    <label class="form-label col-3 col-form-label">با علی پی پرداخت کنید</label>
                                    <div class="col">
                                        <select id="stripe_alipay" class="col form-select" value="{$settings['stripe_alipay']}">
                                            <option value="0">غیر فعال</option>
                                            <option value="1" {if $settings['stripe_alipay'] === true}selected{/if}>فعال کردن</option>
                                        </select>
                                    </div>
                                </div>
                                <div class="form-group mb-3 row">
                                    <label class="form-label col-3 col-form-label">پرداخت ویچت</label>
                                    <div class="col">
                                        <select id="stripe_wechat" class="col form-select" value="{$settings['stripe_wechat']}">
                                            <option value="0">غیر فعال</option>
                                            <option value="1" {if $settings['stripe_wechat'] === true}selected{/if}>فعال کردن</option>
                                        </select>
                                    </div>
                                </div>
                                <div class="form-group mb-3 row">
                                    <label class="form-label col-3 col-form-label">ارز درگاه</label>
                                    <div class="col">
                                        <input id="stripe_currency" type="text" class="form-control" value="{$settings['stripe_currency']}">
                                    </div>
                                </div>
                                <div class="form-group mb-3 row">
                                    <label class="form-label col-3 col-form-label">حداقل محدودیت شارژ (عدد صحیح)</label>
                                    <div class="col">
                                        <input id="stripe_min_recharge" type="text" class="form-control" value="{$settings['stripe_min_recharge']}">
                                    </div>
                                </div>
                                <div class="form-group mb-3 row">
                                    <label class="form-label col-3 col-form-label">حداکثر محدودیت شارژ (عدد صحیح)</label>
                                    <div class="col">
                                        <input id="stripe_max_recharge" type="text" class="form-control" value="{$settings['stripe_max_recharge']}">
                                    </div>
                                </div>
                                <div class="form-group mb-3 row">
                                    <label class="form-label col-3 col-form-label">public key</label>
                                    <div class="col">
                                        <input id="stripe_pk" type="text" class="form-control" value="{$settings['stripe_pk']}">
                                    </div>
                                </div>
                                <div class="form-group mb-3 row">
                                    <label class="form-label col-3 col-form-label">private key</label>
                                    <div class="col">
                                        <input id="stripe_sk" type="text" class="form-control" value="{$settings['stripe_sk']}">
                                    </div>
                                </div>
                                <div class="form-group mb-3 row">
                                    <label class="form-label col-3 col-form-label">WebHookکلید</label>
                                    <div class="col">
                                        <input id="stripe_webhook_key" type="text" class="form-control" value="{$settings['stripe_webhook_key']}">
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="tab-pane" id="epay">
                            <div class="card-body">
                                <div class="form-group mb-3 row">
                                    <label class="form-label col-3 col-form-label">آدرس درگاه</label>
                                    <div class="col">
                                        <input id="epay_url" type="text" class="form-control" value="{$settings['epay_url']}">
                                    </div>
                                </div>
                                <div class="form-group mb-3 row">
                                    <label class="form-label col-3 col-form-label">Merchant ID</label>
                                    <div class="col">
                                        <input id="epay_pid" type="text" class="form-control" value="{$settings['epay_pid']}">
                                    </div>
                                </div>
                                <div class="form-group mb-3 row">
                                    <label class="form-label col-3 col-form-label">کلید</label>
                                    <div class="col">
                                        <input id="epay_key" type="text" class="form-control" value="{$settings['epay_key']}">
                                    </div>
                                </div>
                                <div class="form-group mb-3 row">
                                    <label class="form-label col-3 col-form-label">علی پی</label>
                                    <div class="col">
                                        <select id="epay_alipay" class="col form-select" value="{$settings['epay_alipay']}">
                                            <option value="0">غیر فعال</option>
                                            <option value="1" {if $settings['epay_alipay'] === true}selected{/if}>فعال کردن</option>
                                        </select>
                                    </div>
                                </div>
                                <div class="form-group mb-3 row">
                                    <label class="form-label col-3 col-form-label">پرداخت ویچت</label>
                                    <div class="col">
                                        <select id="epay_wechat" class="col form-select" value="{$settings['epay_wechat']}">
                                            <option value="0">غیر فعال</option>
                                            <option value="1" {if $settings['epay_wechat'] === true}selected{/if}>فعال کردن</option>
                                        </select>
                                    </div>
                                </div>
                                <div class="form-group mb-3 row">
                                    <label class="form-label col-3 col-form-label">کیف پول QQ</label>
                                    <div class="col">
                                        <select id="epay_qq" class="col form-select" value="{$settings['epay_qq']}">
                                            <option value="0">غیر فعال</option>
                                            <option value="1" {if $settings['epay_qq'] === true}selected{/if}>فعال کردن</option>
                                        </select>
                                    </div>
                                </div>
                                <div class="form-group mb-3 row">
                                    <label class="form-label col-3 col-form-label">USDT</label>
                                    <div class="col">
                                        <select id="epay_usdt" class="col form-select" value="{$settings['epay_usdt']}">
                                            <option value="0">غیر فعال</option>
                                            <option value="1" {if $settings['epay_usdt'] === true}selected{/if}>فعال کردن</option>
                                        </select>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="tab-pane" id="paypal">
                            <div class="card-body">
                                <div class="form-group mb-3 row">
                                    <label class="form-label col-3 col-form-label">شیوه</label>
                                    <div class="col">
                                        <select id="paypal_mode" class="col form-select" value="{$settings['paypal_mode']}">
                                            <option value="sandbox">Sandbox</option>
                                            <option value="live" {if $settings['paypal_mode'] === 'live'}selected{/if}>Live</option>
                                        </select>
                                    </div>
                                </div>
                                <div class="form-group mb-3 row">
                                    <label class="form-label col-3 col-form-label">شناسه مشتری پی پال</label>
                                    <div class="col">
                                        <input id="paypal_client_id" type="text" class="form-control" value="{$settings['paypal_client_id']}">
                                    </div>
                                </div>
                                <div class="form-group mb-3 row">
                                    <label class="form-label col-3 col-form-label">کلید مشتری پی پال</label>
                                    <div class="col">
                                        <input id="paypal_client_secret" type="text" class="form-control" value="{$settings['paypal_client_secret']}">
                                    </div>
                                </div>
                                <div class="form-group mb-3 row">
                                    <label class="form-label col-3 col-form-label">ارز پی پال</label>
                                    <div class="col">
                                        <input id="paypal_currency" type="text" class="form-control" value="{$settings['paypal_currency']}">
                                    </div>
                                </div>
                                <div class="form-group mb-3 row">
                                    <label class="form-label col-3 col-form-label">زبان پی پال</label>
                                    <div class="col">
                                        <input id="paypal_locale" type="text" class="form-control" value="{$settings['paypal_locale']}">
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
    $("#save-setting").click(function() {
        $.ajax({
            url: '/admin/setting/billing',
            type: 'POST',
            dataType: "json",
            data: {
                {foreach $update_field as $key}
                {$key}: $('#{$key}').val(),
                {/foreach}
                {foreach $payment_gateways as $key => $value}
                {$key}: $("#{$key}_enable").is(":checked"),
                {/foreach}
            },
            success: function(data) {
                if (data.ret === 1) {
                    $('#success-message').text(data.msg);
                    $('#success-dialog').modal('show');
                } else {
                    $('#fail-message').text(data.msg);
                    $('#fail-dialog').modal('show');
                }
            }
        })
    });
</script>

{include file='admin/tabler_footer.tpl'}