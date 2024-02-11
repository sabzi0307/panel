{include file='admin/header.tpl'}

<div class="page-wrapper">
    <div class="container-xl">
        <div class="page-header d-print-none text-white">
            <div class="row align-items-center">
                <div class="col">
                    <h2 class="page-title">
                        <span class="home-title">تنظیمات ثبت‌نام</span>
                    </h2>
                    <div class="page-pretitle my-3">
                        <span class="home-subtitle">مدیریت تنظیمات ثبت‌نام در سایت</span>
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
                                    <a href="#reg" class="nav-link active" data-bs-toggle="tab">تنظیمات ثبت‌نام</a>
                                </li>
                                <li class="nav-item">
                                    <a href="#default_value" class="nav-link" data-bs-toggle="tab">مقادیر پیش‌فرض</a>
                                </li>
                                <li class="nav-item">
                                    <a href="#limit" class="nav-link" data-bs-toggle="tab">محدودیت‌های حساب</a>
                                </li>
                            </ul>
                        </div>
                        <div class="card-body">
                            <div class="tab-content">
                                <div class="tab-pane active show" id="reg">
                                    <div class="card-body">
                                        <div class="form-group mb-3 row">
                                            <label class="form-label col-3 col-form-label">حالت ثبت‌نام</label>
                                            <div class="col">
                                                <select id="reg_mode" class="col form-select"
                                                        value="{$settings['reg_mode']}">
                                                    <option value="close"
                                                            {if $settings['reg_mode'] === 'close'}selected{/if}>بسته
                                                        شد
                                                    </option>
                                                    <option value="open"
                                                            {if $settings['reg_mode'] === 'open'}selected{/if}>باز
                                                        شد
                                                    </option>
                                                    <option value="invite"
                                                            {if $settings['reg_mode'] === 'invite'}selected{/if}>
                                                        فقط با دعوت کاربران
                                                    </option>
                                                </select>
                                            </div>
                                        </div>
                                        <div class="form-group mb-3 row">
                                            <label class="form-label col-3 col-form-label">تأیید ایمیل</label>
                                            <div class="col">
                                                <select id="reg_email_verify" class="col form-select"
                                                        value="{$settings['reg_email_verify']}">
                                                    <option value="0" {if ! $settings['reg_email_verify']}selected{/if}>
                                                        بسته
                                                    </option>
                                                    <option value="1" {if $settings['reg_email_verify']}selected{/if}>
                                                        باز
                                                    </option>
                                                </select>
                                            </div>
                                        </div>
                                        <div class="form-group mb-3 row">
                                            <label class="form-label col-3 col-form-label">دریافت خودکار ایمیل مصرف روزانه</label>
                                            <div class="col">
                                                <select id="reg_daily_report" class="col form-select"
                                                        value="{$settings['reg_daily_report']}">
                                                    <option value="0"
                                                            {if ! $settings['reg_daily_report']}selected{/if}>بسته
                                                    </option>
                                                    <option value="1"
                                                            {if $settings['reg_daily_report']}selected{/if}>باز
                                                    </option>
                                                </select>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="tab-pane" id="default_value">
                                    <div class="card-body">
                                        <div class="form-group mb-3 row">
                                            <label class="form-label col-3 col-form-label">گروه‌های تصادفی در زمان ثبت‌نام، چندین گروه با استفاده از ویرگول انگلیسی</label>
                                            <div class="col">
                                                <input id="random_group" type="text" class="form-control"
                                                       value="{$settings['random_group']}">
                                            </div>
                                        </div>
                                        <div class="form-group mb-3 row">
                                            <label class="form-label col-3 col-form-label">کمترین مقدار پورت‌های کاربران، با تنظیم به 0 کاربران به پورت تخصیص نمی‌یابند</label>
                                            <div class="col">
                                                <input id="min_port" type="text" class="form-control"
                                                       value="{$settings['min_port']}">
                                            </div>
                                        </div>
                                        <div class="form-group mb-3 row">
                                            <label class="form-label col-3 col-form-label">بیشترین مقدار پورت‌های کاربران، با تنظیم به 0 کاربران به پورت تخصیص نمی‌یابند</label>
                                            <div class="col">
                                                <input id="max_port" type="text" class="form-control"
                                                       value="{$settings['max_port']}">
                                            </div>
                                        </div>
                                        <div class="form-group mb-3 row">
                                            <label class="form-label col-3 col-form-label">مصرف رایگان معرفی در زمان ثبت‌نام (GB)</label>
                                            <div class="col">
                                                <input id="reg_traffic" type="text" class="form-control"
                                                       value="{$settings['reg_traffic']}">
                                            </div>
                                        </div>
                                        <div class="form-group mb-3 row">
                                            <label class="form-label col-3 col-form-label">روز تنظیم مجدد مصرف رایگان کاربران، با تنظیم به 0 مجدد سازی انجام نمی‌شود</label>
                                            <div class="col">
                                                <input id="free_user_reset_day" type="text" class="form-control"
                                                       value="{$settings['free_user_reset_day']}">
                                            </div>
                                        </div>
                                        <div class="form-group mb-3 row">
                                            <label class="form-label col-3 col-form-label">مصرف رایگان مجدد، با تنظیم به 0 مجدد سازی انجام نمی‌شود</label>
                                            <div class="col">
                                                <input id="free_user_reset_bandwidth" type="text" class="form-control"
                                                       value="{$settings['free_user_reset_bandwidth']}">
                                            </div>
                                        </div>
                                        <div class="form-group mb-3 row">
                                            <label class="form-label col-3 col-form-label">رتبه ثبت‌نام</label>
                                            <div class="col">
                                                <input id="reg_class" type="text" class="form-control"
                                                       value="{$settings['reg_class']}">
                                            </div>
                                        </div>
                                        <div class="form-group mb-3 row">
                                            <label class="form-label col-3 col-form-label">زمان انقضای رتبه ثبت‌نام (روز)</label>
                                            <div class="col">
                                                <input id="reg_class_time" type="text" class="form-control"
                                                       value="{$settings['reg_class_time']}">
                                            </div>
                                        </div>
                                        <div class="form-group mb-3 row">
                                            <label class="form-label col-3 col-form-label">رمزگذاری پیش‌فرض</label>
                                            <div class="col">
                                                <input id="reg_method" type="text" class="form-control"
                                                       value="{$settings['reg_method']}">
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="tab-pane" id="limit">
                                    <div class="card-body">
                                        <div class="form-group mb-3 row">
                                            <label class="form-label col-3 col-form-label">محدودیت آی‌پی اتصال</label>
                                            <div class="col">
                                                <input id="reg_ip_limit" type="text" class="form-control"
                                                       value="{$settings['reg_ip_limit']}">
                                            </div>
                                        </div>
                                        <div class="form-group mb-3 row">
                                            <label class="form-label col-3 col-form-label">محدودیت سرعت استفاده</label>
                                            <div class="col">
                                                <input id="reg_speed_limit" type="text" class="form-control"
                                                       value="{$settings['reg_speed_limit']}">
                                            </div>
                                        </div>
                                        <div class="form-group mb-3 row">
                                            <label class="form-label col-3 col-form-label">فهرست آی‌پی‌های ممنوعه</label>
                                            <div class="col">
                                                <input id="reg_forbidden_ip" type="text" class="form-control"
                                                       value="{$settings['reg_forbidden_ip']}">
                                            </div>
                                        </div>
                                        <div class="form-group mb-3 row">
                                            <label class="form-label col-3 col-form-label">فهرست پورت‌های ممنوعه</label>
                                            <div class="col">
                                                <input id="reg_forbidden_port" type="text" class="form-control"
                                                       value="{$settings['reg_forbidden_port']}">
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
                    url: '/admin/setting/reg',
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
