{include file='admin/header.tpl'}

<div class="page-wrapper">
    <div class="container-xl">
        <div class="page-header d-print-none text-white">
            <div class="row align-items-center">
                <div class="col">
                    <h2 class="page-title">
                        <span class="home-title">تنظیمات خدمات مشتریان</span>
                    </h2>
                    <div class="page-pretitle my-3">
                        <span class="home-subtitle">سیستم خدمات مشتریان سایت را راه اندازی کنید</span>
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
                            <a href="#support" class="nav-link active" data-bs-toggle="tab">خدمات مشتری وب</a>
                        </li>
                        <li class="nav-item">
                            <a href="#ticket" class="nav-link" data-bs-toggle="tab">تیکت</a>
                        </li>
                    </ul>
                </div>
                <div class="card-body">
                    <div class="tab-content">
                        <div class="tab-pane active show" id="support">
                            <div class="card-body">
                                <div class="form-group mb-3 row">
                                    <label class="form-label col-3 col-form-label">ارائه دهنده سیستم خدمات مشتری</label>
                                    <div class="col">
                                        <select id="live_chat" class="col form-select" value="{$settings['live_chat']}">
                                            <option value="none" {if $settings['live_chat'] === "none"}selected{/if}>هیچکدام</option>
                                            <option value="tawk" {if $settings['live_chat'] === "tawk"}selected{/if}>Tawk</option>
                                            <option value="crisp" {if $settings['live_chat'] === "crisp"}selected{/if}>Crisp</option>
                                            <option value="livechat" {if $settings['live_chat'] === "livechat"}selected{/if}>LiveChat</option>
                                            <option value="mylivechat" {if $settings['live_chat'] === "mylivechat"}selected{/if}>MyLiveChat</option>
                                        </select>
                                    </div>
                                </div>
                                <div class="form-group mb-3 row">
                                    <label class="form-label col-3 col-form-label">Tawk ID</label>
                                    <div class="col">
                                        <input id="tawk_id" type="text" class="form-control" value="{$settings['tawk_id']}">
                                    </div>
                                </div>
                                <div class="form-group mb-3 row">
                                    <label class="form-label col-3 col-form-label">Crisp ID</label>
                                    <div class="col">
                                        <input id="crisp_id" type="text" class="form-control" value="{$settings['crisp_id']}">
                                    </div>
                                </div>
                                <div class="form-group mb-3 row">
                                    <label class="form-label col-3 col-form-label">LiveChat ID</label>
                                    <div class="col">
                                        <input id="livechat_id" type="text" class="form-control" value="{$settings['livechat_id']}">
                                    </div>
                                </div>
                                <div class="form-group mb-3 row">
                                    <label class="form-label col-3 col-form-label">MyLiveChat ID</label>
                                    <div class="col">
                                        <input id="mylivechat_id" type="text" class="form-control" value="{$settings['mylivechat_id']}">
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="tab-pane" id="ticket">
                            <div class="card-body">
                                <div class="form-group mb-3 row">
                                    <label class="form-label col-3 col-form-label">فعال کردن سیستم تیکت</label>
                                    <div class="col">
                                    <select id="enable_ticket" class="col form-select" value="{$settings['enable_ticket']}">
                                        <option value="0" {if ! $settings['enable_ticket']}selected{/if}>غیرفعال</option>
                                        <option value="1" {if $settings['enable_ticket']}selected{/if}>فعال</option>
                                    </select>
                                    </div>
                                </div>
                                <div class="form-group mb-3 row">
                                    <label class="form-label col-3 col-form-label">هشدارهای ایمیل تیکت را فعال کنید</label>
                                    <div class="col">
                                        <select id="mail_ticket" class="col form-select" value="{$settings['mail_ticket']}">
                                            <option value="0" {if ! $settings['mail_ticket']}selected{/if}>غیرفعال</option>
                                            <option value="1" {if $settings['mail_ticket']}selected{/if}>فعال</option>
                                        </select>
                                    </div>
                                </div>
                                <div class="form-group mb-3 row">
                                    <label class="form-label col-3 col-form-label">سهمیه تیکت کاربر (ماهانه)</label>
                                    <div class="col">
                                        <input id="ticket_limit" type="text" class="form-control" value="{$settings['ticket_limit']}">
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
            $("#save-setting").click(function () {
                $.ajax({
                    url: '/admin/setting/support',
                    type: 'POST',
                    dataType: "json",
                    data: {
                        {foreach $update_field as $key}
                        {$key}: $('#{$key}').val(),
                        {/foreach}
                    },
                    success: function (data) {
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

        {include file='admin/footer.tpl'}
