{include file='admin/header.tpl'}

<div class="page-wrapper">
    <div class="container-xl">
        <div class="page-header d-print-none text-white">
            <div class="row align-items-center">
                <div class="col">
                    <h2 class="page-title">
                        <span class="home-title">تنظیمات ثبت نام</span>
                    </h2>
                    <div class="page-pretitle my-3">
                        <span class="home-subtitle">مدیریت تنظیمات ثبت نام در سایت</span>
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
                            <a href="#reg" class="nav-link active" data-bs-toggle="tab">تنظیمات ثبت نام</a>
                        </li>
                        <li class="nav-item">
                            <a href="#default_value" class="nav-link" data-bs-toggle="tab">پیش فرض ها</a>
                        </li>
                        <li class="nav-item">
                            <a href="#limit" class="nav-link" data-bs-toggle="tab">محدودیت حساب</a>
                        </li>
                    </ul>
                </div>
                <div class="card-body">
                    <div class="tab-content">
                        <div class="tab-pane active show" id="reg">
                            <div class="card-body">
                                <div class="form-group mb-3 row">
                                    <label class="form-label col-3 col-form-label">حالت ثبت نام</label>
                                    <div class="col">
                                        <select id="reg_mode" class="col form-select" value="{$settings['reg_mode']}">
                                            <option value="close" {if $settings['reg_mode'] === 'close'}selected{/if}>ثبت نام غیر فعال</option>
                                            <option value="open" {if $settings['reg_mode'] === 'open'}selected{/if}>فعال بودن گزینه ثبت نام</option>
                                            <option value="invite" {if $settings['reg_mode'] === 'invite'}selected{/if}>ثبت نام فقط با دعوت کاربران</option>
                                        </select>
                                    </div>
                                </div>
                                <div class="form-group mb-3 row">
                                    <label class="form-label col-3 col-form-label">الزام به تایید ایمیل</label>
                                    <div class="col">
                                        <select id="reg_email_verify" class="col form-select" value="{$settings['reg_email_verify']}">
                                            <option value="0" {if $settings['reg_email_verify'] === false}selected{/if}>غیرفعال</option>
                                            <option value="1" {if $settings['reg_email_verify']}selected{/if}>فعال</option>
                                        </select>
                                    </div>
                                </div>
                                <div class="form-group mb-3 row">
                                    <label class="form-label col-3 col-form-label">مدت اعتبار کد تأیید ایمیل (ثانیه)</label>
                                    <div class="col">
                                        <input id="email_verify_ttl" type="text" class="form-control" value="{$settings['email_verify_ttl']}">
                                    </div>
                                </div>
                                <div class="form-group mb-3 row">
                                    <label class="form-label col-3 col-form-label">تعداد دفعاتی که یک IP می تواند در مدت اعتبار کد تأیید درخواست کند</label>
                                    <div class="col">
                                        <input id="email_verify_ip_limit" type="text" class="form-control" value="{$settings['email_verify_ip_limit']}">
                                    </div>
                                </div>
                                <div class="form-group mb-3 row">
                                    <label class="form-label col-3 col-form-label">تعداد دفعاتی که یک آدرس ایمیل می تواند در مدت اعتبار کد تأیید درخواست کند</label>
                                    <div class="col">
                                        <input id="email_verify_email_limit" type="text" class="form-control" value="{$settings['email_verify_email_limit']}">
                                    </div>
                                </div>
                                <div class="form-group mb-3 row">
                                    <label class="form-label col-3 col-form-label">به طور پیش‌ فرض، ایمیل مصرف روزانه را دریافت کنید</label>
                                    <div class="col">
                                        <select id="sign_up_for_daily_report" class="col form-select" value="{$settings['sign_up_for_daily_report']}">
                                            <option value="0" {if $settings['sign_up_for_daily_report'] === false}selected{/if}>غیرفعال</option>
                                            <option value="1" {if $settings['sign_up_for_daily_report']}selected{/if}>فعال</option>
                                        </select>
                                    </div>
                                </div>
                                <div class="form-group mb-3 row">
                                    <label class="form-label col-3 col-form-label">این که آیا کاربر باید یک مخاطب IM را وارد کند یا خیر</label>
                                    <div class="col">
                                        <select id="enable_reg_im" class="col form-select" value="{$settings['enable_reg_im']}">
                                            <option value="0" {if $settings['enable_reg_im'] === false}selected{/if}>غیرفعال</option>
                                            <option value="1" {if $settings['enable_reg_im']}selected{/if}>فعال</option>
                                        </select>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="tab-pane" id="default_value">
                            <div class="card-body">
                                <div class="form-group mb-3 row">
                                    <label class="form-label col-3 col-form-label">گروه هایی که به طور تصادفی در هنگام ثبت نام اختصاص داده می شوند، چندین گروه باید با کاما از هم جدا شوند</label>
                                    <div class="col">
                                        <input id="random_group" type="text" class="form-control" value="{$settings['random_group']}">
                                    </div>
                                </div>
                                <div class="form-group mb-3 row">
                                    <label class="form-label col-3 col-form-label">حداقل مقدار پورت کاربر، وقتی روی 0 تنظیم شود، به کاربر پورتی اختصاص داده نخواهد شد</label>
                                    <div class="col">
                                        <input id="min_port" type="text" class="form-control" value="{$settings['min_port']}">
                                    </div>
                                </div>
                                <div class="form-group mb-3 row">
                                    <label class="form-label col-3 col-form-label">حداکثر مقدار مجموعه پورت کاربر، وقتی روی 0 تنظیم شود، به کاربر یک پورت اختصاص داده نخواهد شد</label>
                                    <div class="col">
                                        <input id="max_port" type="text" class="form-control" value="{$settings['max_port']}">
                                    </div>
                                </div>
                                <div class="form-group mb-3 row">
                                    <label class="form-label col-3 col-form-label">حجم رایگان در هنگام ثبت نام (GB)</label>
                                    <div class="col">
                                        <input id="sign_up_for_free_traffic" type="text" class="form-control" value="{$settings['sign_up_for_free_traffic']}">
                                    </div>
                                </div>
                                <div class="form-group mb-3 row">
                                    <label class="form-label col-3 col-form-label">تاریخ ریست ترافیک برای کاربران رایگان، بدون تنظیم زمانی که روی 0 تنظیم شود</label>
                                    <div class="col">
                                        <input id="free_user_reset_day" type="text" class="form-control" value="{$settings['free_user_reset_day']}">
                                    </div>
                                </div>
                                <div class="form-group mb-3 row">
                                    <label class="form-label col-3 col-form-label">ترافیک رایگانی که باید ریست شود، وقتی روی 0 تنظیم شود ریست نمی شود</label>
                                    <div class="col">
                                        <input id="free_user_reset_bandwidth" type="text" class="form-control" value="{$settings['free_user_reset_bandwidth']}">
                                    </div>
                                </div>
                                <div class="form-group mb-3 row">
                                    <label class="form-label col-3 col-form-label">مدت اعتبار حساب تعیین شده در زمان ثبت نام (روزها)</label>
                                    <div class="col">
                                        <input id="sign_up_for_free_time" type="text" class="form-control" value="{$settings['sign_up_for_free_time']}">
                                    </div>
                                </div>
                                <div class="form-group mb-3 row">
                                    <label class="form-label col-3 col-form-label">سطح تعیین شده در هنگام ثبت نام</label>
                                    <div class="col">
                                        <input id="sign_up_for_class" type="text" class="form-control" value="{$settings['sign_up_for_class']}">
                                    </div>
                                </div>
                                <div class="form-group mb-3 row">
                                    <label class="form-label col-3 col-form-label">زمان انقضای سطح تعیین شده در هنگام ثبت نام (روزها)</label>
                                    <div class="col">
                                        <input id="sign_up_for_class_time" type="text" class="form-control" value="{$settings['sign_up_for_class_time']}">
                                    </div>
                                </div>
                                <div class="form-group mb-3 row">
                                    <label class="form-label col-3 col-form-label">رمزگذاری به صورت پیش فرض</label>
                                    <div class="col">
                                        <input id="sign_up_for_method" type="text" class="form-control" value="{$settings['sign_up_for_method']}">
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="tab-pane" id="limit">
                            <div class="card-body">
                                <div class="form-group mb-3 row">
                                    <label class="form-label col-3 col-form-label">محدودیت استفاده از لینک دعوت</label>
                                    <div class="col">
                                        <input id="sign_up_for_invitation_codes" type="text" class="form-control" value="{$settings['sign_up_for_invitation_codes']}">
                                    </div>
                                </div>
                                <div class="form-group mb-3 row">
                                    <label class="form-label col-3 col-form-label">محدودیت IP اتصال</label>
                                    <div class="col">
                                        <input id="connection_ip_limit" type="text" class="form-control" value="{$settings['connection_ip_limit']}">
                                    </div>
                                </div>
                                <div class="form-group mb-3 row">
                                    <label class="form-label col-3 col-form-label">استفاده از محدودیت نرخ</label>
                                    <div class="col">
                                        <input id="connection_rate_limit" type="text" class="form-control" value="{$settings['connection_rate_limit']}">
                                    </div>
                                </div>
                                <div class="form-group mb-3 row">
                                    <label class="form-label col-3 col-form-label">لیست IP های ممنوعه</label>
                                    <div class="col">
                                        <input id="reg_forbidden_ip" type="text" class="form-control" value="{$settings['reg_forbidden_ip']}">
                                    </div>
                                </div>
                                <div class="form-group mb-3 row">
                                    <label class="form-label col-3 col-form-label">لیست پورت های ممنوعه</label>
                                    <div class="col">
                                        <input id="reg_forbidden_port" type="text" class="form-control" value="{$settings['reg_forbidden_port']}">
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
            url: '/admin/setting/reg',
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