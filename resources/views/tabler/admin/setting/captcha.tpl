{include file='admin/tabler_header.tpl'}

<div class="page-wrapper">
    <div class="container-xl">
        <div class="page-header d-print-none text-white">
            <div class="row align-items-center">
                <div class="col">
                    <h2 class="page-title">
                        <span class="home-title">تنظیمات CAPTCHA</span>
                    </h2>
                    <div class="page-pretitle my-3">
                        <span class="home-subtitle">کپچای سایت خود را تنظیم کنید</span>
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
                            <a href="#captcha" class="nav-link active" data-bs-toggle="tab">تنظیمات احراز هویت</a>
                        </li>
                        <li class="nav-item">
                            <a href="#turnstile" class="nav-link" data-bs-toggle="tab">Turnstile</a>
                        </li>
                        <li class="nav-item">
                            <a href="#geetest" class="nav-link" data-bs-toggle="tab">Geetest</a>
                        </li>
                    </ul>
                </div>
                <div class="card-body">
                    <div class="tab-content">
                        <div class="tab-pane active show" id="captcha">
                            <div class="card-body">
                                <div class="form-group mb-3 row">
                                    <label class="form-label col-3 col-form-label">ارائه کننده کپچا</label>
                                    <div class="col">
                                        <select id="captcha_provider" class="col form-select" value="{$settings['captcha_provider']}">
                                            <option value="turnstile" {if $settings['captcha_provider'] == "turnstile"}selected{/if}>Turnstile</option>
                                            <option value="geetest" {if $settings['captcha_provider'] == "geetest"}selected{/if}>Geetest</option>
                                        </select>
                                    </div>
                                </div>
                                <div class="form-group mb-3 row">
                                    <label class="form-label col-3 col-form-label">کد تایید ثبت نام</label>
                                    <div class="col">
                                        <select id="enable_reg_captcha" class="col form-select" value="{$settings['enable_reg_captcha']}">
                                            <option value="0" {if $settings['enable_reg_captcha'] == false}selected{/if}>غیر فعال</option>
                                            <option value="1" {if $settings['enable_reg_captcha'] == true}selected{/if}>فعال کردن</option>
                                        </select>
                                    </div>
                                </div>
                                <div class="form-group mb-3 row">
                                    <label class="form-label col-3 col-form-label">کد تایید ورود</label>
                                    <div class="col">
                                        <select id="enable_login_captcha" class="col form-select" value="{$settings['enable_login_captcha']}">
                                            <option value="0" {if $settings['enable_login_captcha'] == false}selected{/if}>غیر فعال</option>
                                            <option value="1" {if $settings['enable_login_captcha'] == true}selected{/if}>فعال کردن</option>
                                        </select>
                                    </div>
                                </div>
                                <div class="form-group mb-3 row">
                                    <label class="form-label col-3 col-form-label">کد تأیید ورود به سیستم</label>
                                    <div class="col">
                                        <select id="enable_checkin_captcha" class="col form-select" value="{$settings['enable_checkin_captcha']}">
                                            <option value="0" {if $settings['enable_checkin_captcha'] == false}selected{/if}>غیر فعال</option>
                                            <option value="1" {if $settings['enable_checkin_captcha'] == true}selected{/if}>فعال کردن</option>
                                        </select>
                                    </div>
                                </div>
                                <div class="form-group mb-3 row">
                                    <label class="form-label col-3 col-form-label">کد تأیید رمز عبور را بازنشانی کنید</label>
                                    <div class="col">
                                        <select id="enable_reset_password_captcha" class="col form-select" value="{$settings['enable_reset_password_captcha']}">
                                            <option value="0" {if $settings['enable_reset_password_captcha'] == false}selected{/if}>غیر فعال</option>
                                            <option value="1" {if $settings['enable_reset_password_captcha'] == true}selected{/if}>فعال کردن</option>
                                        </select>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="tab-pane" id="turnstile">
                            <div class="card-body">
                                <div class="form-group mb-3 row">
                                    <label class="form-label col-3 col-form-label">Turnstile Site Key</label>
                                    <div class="col">
                                        <input id="turnstile_sitekey" type="text" class="form-control" value="{$settings['turnstile_sitekey']}">
                                    </div>
                                </div>
                                <div class="form-group mb-3 row">
                                    <label class="form-label col-3 col-form-label">Turnstile Secret</label>
                                    <div class="col">
                                        <input id="turnstile_secret" type="text" class="form-control" value="{$settings['turnstile_secret']}">
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="tab-pane" id="geetest">
                            <div class="card-body">
                                <div class="form-group mb-3 row">
                                    <label class="form-label col-3 col-form-label">Geetest ID</label>
                                    <div class="col">
                                        <input id="geetest_id" type="text" class="form-control" value="{$settings['geetest_id']}">
                                    </div>
                                </div>
                                <div class="form-group mb-3 row">
                                    <label class="form-label col-3 col-form-label">Geetest Key</label>
                                    <div class="col">
                                        <input id="geetest_key" type="text" class="form-control" value="{$settings['geetest_key']}">
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
            url: '/admin/setting/captcha',
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