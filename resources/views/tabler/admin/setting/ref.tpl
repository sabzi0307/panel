{include file='admin/tabler_header.tpl'}

<div class="page-wrapper">
    <div class="container-xl">
        <div class="page-header d-print-none text-white">
            <div class="row align-items-center">
                <div class="col">
                    <h2 class="page-title">
                        <span class="home-title">تنظیمات دعوت</span>
                    </h2>
                    <div class="page-pretitle my-3">
                        <span class="home-subtitle">مدیریت تنظیمات دعوت به سایت</span>
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
                            <a href="#invite" class="nav-link active" data-bs-toggle="tab">تنظیمات دعوت</a>
                        </li>
                        <li class="nav-item">
                            <a href="#rebate" class="nav-link" data-bs-toggle="tab">تخفیف</a>
                        </li>
                    </ul>
                </div>
                <div class="card-body">
                    <div class="tab-content">
                        <div class="tab-pane active show" id="invite">
                            <div class="card-body">
                                <div class="form-group mb-3 row">
                                    <label class="form-label col-3 col-form-label">پاداش موجودی (تومان) که با استفاده از لینک دعوت برای ثبت نام قابل دریافت است</label>
                                    <div class="col">
                                        <input id="invitation_to_register_balance_reward" type="text" class="form-control" value="{$settings['invitation_to_register_balance_reward']}">
                                    </div>
                                </div>
                                <div class="form-group mb-3 row">
                                    <label class="form-label col-3 col-form-label">پاداش ترافیک (GB) که با استفاده از لینک دعوت برای ثبت نام قابل دریافت است</label>
                                    <div class="col">
                                        <input id="invitation_to_register_traffic_reward" type="text" class="form-control" value="{$settings['invitation_to_register_traffic_reward']}">
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="tab-pane" id="rebate">
                            <div class="card-body">
                                <div class="form-group mb-3 row">
                                    <label class="form-label col-3 col-form-label">حالت دعوت کردن</label>
                                    <div class="col">
                                        <select id="invitation_mode" class="col form-select" value="{$settings['invitation_mode']}">
                                            <option value="registration_only" {if $settings['invitation_mode'] == 'registration_only'}selected{/if}>
                                            بدون تخفیف</option>
                                            <option value="after_recharge" {if $settings['invitation_mode'] == 'after_recharge'}selected{/if}>
                                            تخفیف در هنگام شارژ مجدد کاربران دعوت شده</option>
                                            <option value="after_purchase" {if $settings['invitation_mode'] == 'after_purchase'}selected{/if}>
                                            تخفیف در هنگام خرید کاربران دعوت شده</option>
                                        </select>
                                    </div>
                                </div>
                                <div class="form-group mb-3 row">
                                    <label class="form-label col-3 col-form-label">حالت دعوت</label>
                                    <div class="col">
                                        <select id="invite_rebate_mode" class="col form-select" value="{$settings['invite_rebate_mode']}">
                                            <option value="continued" {if $settings['invite_rebate_mode'] == 'continued'}selected{/if}>
                                            تخفیف مستمر</option>
                                            <option value="limit_frequency" {if $settings['invite_rebate_mode'] == 'limit_frequency'}selected{/if}>
                                            تعداد تخفیف هایی را که دعوت کننده می تواند از دعوت شونده دریافت کند محدود کنید</option>
                                            <option value="limit_amount" {if $settings['invite_rebate_mode'] == 'limit_amount'}selected{/if}>
                                            مقدار تخفیف هایی را که دعوت کننده می تواند از دعوت شونده دریافت کند محدود کنید</option>
                                            <option value="limit_time_range" {if $settings['invite_rebate_mode'] == 'limit_time_range'}selected{/if}>
                                            محدوده زمانی را که دعوت کننده می تواند از دعوت شونده تخفیف دریافت کند، محدود کنید</option>
                                        </select>
                                    </div>
                                </div>
                                <div class="form-group mb-3 row">
                                    <label class="form-label col-3 col-form-label">نرخ تخفیف، 10% پر کردن 0.1</label>
                                    <div class="col">
                                        <input id="rebate_ratio" type="text" class="form-control" value="{$settings['rebate_ratio']}">
                                    </div>
                                </div>
                                <div class="form-group mb-3 row">
                                    <label class="form-label col-3 col-form-label">محدوده زمانی تخفیف (روزها)</label>
                                    <div class="col">
                                        <input id="rebate_time_range_limit" type="text" class="form-control" value="{$settings['rebate_time_range_limit']}">
                                    </div>
                                </div>
                                <div class="form-group mb-3 row">
                                    <label class="form-label col-3 col-form-label">زمان تخفیف</label>
                                    <div class="col">
                                        <input id="rebate_frequency_limit" type="text" class="form-control" value="{$settings['rebate_frequency_limit']}">
                                    </div>
                                </div>
                                <div class="form-group mb-3 row">
                                    <label class="form-label col-3 col-form-label">محدودیت مقدار تخفیف</label>
                                    <div class="col">
                                        <input id="rebate_amount_limit" type="text" class="form-control" value="{$settings['rebate_amount_limit']}">
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
            url: '/admin/setting/ref',
            type: 'POST',
            dataType: "json",
            data: {
                {foreach $update_field as $key}
                {$key}: $('#{$key}').val(),
                {/foreach}
            },
            success: function(data) {
                if (data.ret == 1) {
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