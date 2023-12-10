{include file='admin/header.tpl'}

<div class="page-wrapper">
    <div class="container-xl">
        <div class="page-header d-print-none text-white">
            <div class="row align-items-center">
                <div class="col">
                    <h2 class="page-title">
                        <span class="home-title">تنظیمات ویژگی ها</span>
                    </h2>
                    <div class="page-pretitle my-3">
                        <span class="home-subtitle">ویژگی ها و نمایش سایت را تنظیم کنید</span>
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
                                    <a href="#display" class="nav-link active" data-bs-toggle="tab">نمایش عملکرد</a>
                                </li>
                                <li class="nav-item">
                                    <a href="#log" class="nav-link" data-bs-toggle="tab">گزارش کاربر</a>
                                </li>
                            </ul>
                        </div>
                        <div class="card-body">
                            <div class="tab-content">
                                <div class="tab-pane active show" id="display">
                                    <div class="card-body">
                                        <div class="form-group mb-3 row">
                                            <label class="form-label col-3 col-form-label">نمایش سوابق اشتراک
                                                کاربر</label>
                                            <div class="col">
                                                <select id="display_detect_log" class="col form-select"
                                                    value="{$settings['display_detect_log']}">
                                                    <option value="0"
                                                        {if ! $settings['display_detect_log']}selected{/if}>غیرفعال
                                                    </option>
                                                    <option value="1" {if $settings['display_detect_log']}selected{/if}>
                                                        فعال</option>
                                                </select>
                                            </div>
                                        </div>
                                        <div class="form-group mb-3 row">
                                            <label class="form-label col-3 col-form-label">نمایش منوی ممیزی
                                                کاربران</label>
                                            <div class="col">
                                                <select id="display_detect" class="col form-select"
                                                    value="{$settings['display_detect']}">
                                                    <option value="0" {if ! $settings['display_detect']}selected{/if}>
                                                        غیرفعال</option>
                                                    <option value="1" {if $settings['display_detect']}selected{/if}>فعال
                                                    </option>
                                                </select>
                                            </div>
                                        </div>
                                        <div class="form-group mb-3 row">
                                            <label class="form-label col-3 col-form-label">نمایش سوابق ممیزی
                                                کاربران</label>
                                            <div class="col">
                                                <select id="display_detect_log" class="col form-select"
                                                    value="{$settings['display_detect_log']}">
                                                    <option value="0" {if ! $settings['display_detect_log']}selected{/if}>
                                                        غیرفعال</option>
                                                    <option value="1" {if $settings['display_detect_log']}selected{/if}>فعال
                                                    </option>
                                                </select>
                                            </div>
                                        </div>
                                        <div class="form-group mb-3 row">
                                            <label class="form-label col-3 col-form-label">دانشنامه فقط برای کاربران پولی
                                                قابل مشاهده باشد</label>
                                            <div class="col">
                                                <select id="display_docs_only_for_paid_user" class="col form-select"
                                                    value="{$settings['display_docs_only_for_paid_user']}">
                                                    <option value="0"
                                                        {if ! $settings['display_docs_only_for_paid_user']}selected{/if}>
                                                        غیرفعال</option>
                                                    <option value="1"
                                                        {if $settings['display_docs_only_for_paid_user']}selected{/if}>
                                                        فعال</option>
                                                </select>
                                            </div>
                                        </div>
                                        <div class="form-group mb-3 row">
                                            <label class="form-label col-3 col-form-label">نمایش استریم های
                                                مسدود</label>
                                            <div class="col">
                                                <select id="display_media" class="col form-select"
                                                    value="{$settings['display_media']}">
                                                    <option value="0" {if ! $settings['display_media']}selected{/if}>
                                                        غیرفعال</option>
                                                    <option value="1" {if $settings['display_media']}selected{/if}>فعال
                                                    </option>
                                                </select>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="tab-pane" id="log">
                                    <div class="card-body">
                                        <div class="form-group mb-3 row">
                                            <label class="form-label col-3 col-form-label">گزارش‌های استفاده ساعتی را
                                                فعال کنید</label>
                                            <div class="col">
                                                <select id="traffic_log" class="col form-select"
                                                    value="{$settings['traffic_log']}">
                                                    <option value="0" {if ! $settings['traffic_log']}selected{/if}>
                                                        غیرفعال</option>
                                                    <option value="1" {if $settings['traffic_log']}selected{/if}>فعال
                                                    </option>
                                                </select>
                                            </div>
                                        </div>
                                        <div class="form-group mb-3 row">
                                            <label class="form-label col-3 col-form-label">روزهای نگهداری گزارش
                                                ترافیک</label>
                                            <div class="col">
                                                <input id="traffic_log_retention_days" type="text" class="form-control"
                                                    value="{$settings['traffic_log_retention_days']}">
                                            </div>
                                        </div>
                                        <div class="form-group mb-3 row">
                                            <label class="form-label col-3 col-form-label">فعال کردن ثبت اشتراک</label>
                                            <div class="col">
                                                <select id="subscribe_log" class="col form-select"
                                                    value="{$settings['subscribe_log']}">
                                                    <option value="0" {if ! $settings['subscribe_log']}selected{/if}>
                                                        غیرفعال</option>
                                                    <option value="1" {if $settings['subscribe_log']}selected{/if}>فعال
                                                    </option>
                                                </select>
                                            </div>
                                        </div>
                                        <div class="form-group mb-3 row">
                                            <label class="form-label col-3 col-form-label">تعداد روزهای نگهداری گزارش
                                                های اشتراک</label>
                                            <div class="col">
                                                <input id="subscribe_log_retention_days" type="text"
                                                    class="form-control"
                                                    value="{$settings['subscribe_log_retention_days']}">
                                            </div>
                                        </div>
                                        <div class="form-group mb-3 row">
                                            <label class="form-label col-3 col-form-label">کاربران را از اشتراک IP های
                                                جدید مطلع کنید</label>
                                            <div class="col">
                                                <select id="notify_new_subscribe" class="col form-select"
                                                    value="{$settings['notify_new_subscribe']}">
                                                    <option value="0"
                                                        {if ! $settings['notify_new_subscribe']}selected{/if}>غیرفعال
                                                    </option>
                                                    <option value="1"
                                                        {if $settings['notify_new_subscribe']}selected{/if}>فعال
                                                    </option>
                                                </select>
                                            </div>
                                        </div>
                                        <div class="form-group mb-3 row">
                                            <label class="form-label col-3 col-form-label">فعال کردن گزارش ورود به
                                                سیستم</label>
                                            <div class="col">
                                                <select id="login_log" class="col form-select"
                                                    value="{$settings['login_log']}">
                                                    <option value="0" {if ! $settings['login_log']}selected{/if}>غیرفعال
                                                    </option>
                                                    <option value="1" {if $settings['login_log']}selected{/if}>فعال
                                                    </option>
                                                </select>
                                            </div>
                                        </div>
                                        <div class="form-group mb-3 row">
                                            <label class="form-label col-3 col-form-label">آگاه کردن کاربر از ورود با
                                                آدرس جدید</label>
                                            <div class="col">
                                                <select id="notify_new_login" class="col form-select"
                                                    value="{$settings['notify_new_login']}">
                                                    <option value="0" {if ! $settings['notify_new_login']}selected{/if}>
                                                        غیرفعال</option>
                                                    <option value="1" {if $settings['notify_new_login']}selected{/if}>
                                                        فعال</option>
                                                </select>
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
                    url: '/admin/setting/feature',
                    type: 'POST',
                    dataType: "json",
                    data: {
                        {foreach $update_field as $key}
                            {$key}: $('#{$key}').val(),
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

{include file='admin/footer.tpl'}