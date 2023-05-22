{include file='admin/header.tpl'}

<div class="page-wrapper">
    <div class="container-xl">
        <div class="page-header d-print-none text-white">
            <div class="row align-items-center">
                <div class="col">
                    <h2 class="page-title">
                        <span class="home-title">تنظیمات IM</span>
                    </h2>
                    <div class="page-pretitle my-3">
                        <span class="home-subtitle">تنظیمات یکپارچه سازی IM را برای سایت خود مدیریت کنید</span>
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
                            <a href="#telegram_notification" class="nav-link active" data-bs-toggle="tab">تنظیمات اعلان تلگرام</a>
                        </li>
                        <li class="nav-item">
                            <a href="#telegram_bot" class="nav-link" data-bs-toggle="tab">تنظیمات ربات تلگرام</a>
                        </li>
                    </ul>
                </div>
                <div class="card-body">
                    <div class="tab-content">
                        <div class="tab-pane active show" id="telegram_notification">
                            <div class="card-body">
                                <div class="form-group mb-3 row">
                                    <label class="form-label col-3 col-form-label">اعلان افزودن سرور</label>
                                    <div class="col">
                                        <select id="telegram_add_node" class="col form-select" value="{$settings['telegram_add_node']}">
                                            <option value="0" {if $settings['telegram_add_node'] === false}selected{/if}>غیرفعال</option>
                                            <option value="1" {if $settings['telegram_add_node']}selected{/if}>فعال</option>
                                        </select>
                                    </div>
                                </div>
                                <div class="form-group mb-3 row">
                                    <label class="form-label col-3 col-form-label">متن اعلان افزوده شدن سرور</label>
                                    <div class="col">
                                        <input id="telegram_add_node_text" type="text" class="form-control" value="{$settings['telegram_add_node_text']}">
                                    </div>
                                </div>
                                <div class="form-group mb-3 row">
                                    <label class="form-label col-3 col-form-label">اعلان تغییر در سرور</label>
                                    <div class="col">
                                        <select id="telegram_update_node" class="col form-select" value="{$settings['telegram_update_node']}">
                                            <option value="0" {if $settings['telegram_update_node'] === false}selected{/if}>غیرفعال</option>
                                            <option value="1" {if $settings['telegram_update_node']}selected{/if}>فعال</option>
                                        </select>
                                    </div>
                                </div>
                                <div class="form-group mb-3 row">
                                    <label class="form-label col-3 col-form-label">متن اعلان تغییر در سرور</label>
                                    <div class="col">
                                        <input id="telegram_update_node_text" type="text" class="form-control" value="{$settings['telegram_update_node_text']}">
                                    </div>
                                </div>
                                <div class="form-group mb-3 row">
                                    <label class="form-label col-3 col-form-label">اعلان حذف سرور</label>
                                    <div class="col">
                                        <select id="telegram_delete_node" class="col form-select" value="{$settings['telegram_delete_node']}">
                                            <option value="0" {if $settings['telegram_delete_node'] === false}selected{/if}>غیرفعال</option>
                                            <option value="1" {if $settings['telegram_delete_node']}selected{/if}>فعال</option>
                                        </select>
                                    </div>
                                </div>
                                <div class="form-group mb-3 row">
                                    <label class="form-label col-3 col-form-label">متن اعلان حذف سرور</label>
                                    <div class="col">
                                        <input id="telegram_delete_node_text" type="text" class="form-control" value="{$settings['telegram_delete_node_text']}">
                                    </div>
                                </div>
                                <div class="form-group mb-3 row">
                                    <label class="form-label col-3 col-form-label">اعلان شناسایی سرور توسط فایروال</label>
                                    <div class="col">
                                        <select id="telegram_node_gfwed" class="col form-select" value="{$settings['telegram_node_gfwed']}">
                                            <option value="0" {if $settings['telegram_node_gfwed'] === false}selected{/if}>غیرفعال</option>
                                            <option value="1" {if $settings['telegram_node_gfwed']}selected{/if}>فعال</option>
                                        </select>
                                    </div>
                                </div>
                                <div class="form-group mb-3 row">
                                    <label class="form-label col-3 col-form-label">متن اعلان شناسایی سرور توسط فایروال</label>
                                    <div class="col">
                                        <input id="telegram_node_gfwed_text" type="text" class="form-control" value="{$settings['telegram_node_gfwed_text']}">
                                    </div>
                                </div>
                                <div class="form-group mb-3 row">
                                    <label class="form-label col-3 col-form-label">اعلان رفع شناسایی توسط فایروال</label>
                                    <div class="col">
                                        <select id="telegram_node_ungfwed" class="col form-select" value="{$settings['telegram_node_ungfwed']}">
                                            <option value="0" {if $settings['telegram_node_ungfwed'] === false}selected{/if}>غیرفعال</option>
                                            <option value="1" {if $settings['telegram_node_ungfwed']}selected{/if}>فعال</option>
                                        </select>
                                    </div>
                                </div>
                                <div class="form-group mb-3 row">
                                    <label class="form-label col-3 col-form-label">متن اعلان رفع شناسایی توسط فایروال</label>
                                    <div class="col">
                                        <input id="telegram_node_ungfwed_text" type="text" class="form-control" value="{$settings['telegram_node_ungfwed_text']}">
                                    </div>
                                </div>
                                <div class="form-group mb-3 row">
                                    <label class="form-label col-3 col-form-label">اعلان آفلاین سرور</label>
                                    <div class="col">
                                        <select id="telegram_node_offline" class="col form-select" value="{$settings['telegram_node_offline']}">
                                            <option value="0" {if $settings['telegram_node_offline'] === false}selected{/if}>غیرفعال</option>
                                            <option value="1" {if $settings['telegram_node_offline']}selected{/if}>فعال</option>
                                        </select>
                                    </div>
                                </div>
                                <div class="form-group mb-3 row">
                                    <label class="form-label col-3 col-form-label">متن اعلان آفلاین سرور</label>
                                    <div class="col">
                                        <input id="telegram_node_offline_text" type="text" class="form-control" value="{$settings['telegram_node_offline_text']}">
                                    </div>
                                </div>
                                <div class="form-group mb-3 row">
                                    <label class="form-label col-3 col-form-label">اعلان آنلاین سرور</label>
                                    <div class="col">
                                        <select id="telegram_node_online" class="col form-select" value="{$settings['telegram_node_online']}">
                                            <option value="0" {if $settings['telegram_node_online'] === false}selected{/if}>غیرفعال</option>
                                            <option value="1" {if $settings['telegram_node_online']}selected{/if}>فعال</option>
                                        </select>
                                    </div>
                                </div>
                                <div class="form-group mb-3 row">
                                    <label class="form-label col-3 col-form-label">متن اعلان آنلاین سرور</label>
                                    <div class="col">
                                        <input id="telegram_node_online_text" type="text" class="form-control" value="{$settings['telegram_node_online_text']}">
                                    </div>
                                </div>
                                <div class="form-group mb-3 row">
                                    <label class="form-label col-3 col-form-label">اطلاع رسانی تلاش روزانه</label>
                                    <div class="col">
                                        <select id="telegram_daily_job" class="col form-select" value="{$settings['telegram_daily_job']}">
                                            <option value="0" {if $settings['telegram_daily_job'] === false}selected{/if}>غیرفعال</option>
                                            <option value="1" {if $settings['telegram_daily_job']}selected{/if}>فعال</option>
                                        </select>
                                    </div>
                                </div>
                                <div class="form-group mb-3 row">
                                    <label class="form-label col-3 col-form-label">متن اطلاع رسانی تلاش روزانه</label>
                                    <div class="col">
                                        <input id="telegram_daily_job_text" type="text" class="form-control" value="{$settings['telegram_daily_job_text']}">
                                    </div>
                                </div>
                                <div class="form-group mb-3 row">
                                    <label class="form-label col-3 col-form-label">اعلان‌های سلامت سیستم</label>
                                    <div class="col">
                                        <select id="telegram_diary" class="col form-select" value="{$settings['telegram_diary']}">
                                            <option value="0" {if $settings['telegram_diary'] === false}selected{/if}>غیرفعال</option>
                                            <option value="1" {if $settings['telegram_diary']}selected{/if}>فعال</option>
                                        </select>
                                    </div>
                                </div>
                                <div class="form-group mb-3 row">
                                    <label class="form-label col-3 col-form-label">متن اعلان سلامت سیستم</label>
                                    <div class="col">
                                        <input id="telegram_diary_text" type="text" class="form-control" value="{$settings['telegram_diary_text']}">
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="tab-pane" id="telegram_bot">
                            <div class="card-body">
                                <div class="form-group mb-3 row">
                                    <label class="form-label col-3 col-form-label">پس از لغو لینک اکانت تلگرام، گروه را به صورت خودکار بیرون کنید</label>
                                    <div class="col">
                                        <select id="telegram_unbind_kick_member" class="col form-select" value="{$settings['telegram_unbind_kick_member']}">
                                            <option value="0" {if $settings['telegram_unbind_kick_member'] === false}selected{/if}>غیرفعال</option>
                                            <option value="1" {if $settings['telegram_unbind_kick_member']}selected{/if}>فعال</option>
                                        </select>
                                    </div>
                                </div>
                                <div class="form-group mb-3 row">
                                    <label class="form-label col-3 col-form-label">فقط به کاربرانی که اکانت های تلگرام لینک شده دارند اجازه دهید به گروه بپیوندند</label>
                                    <div class="col">
                                        <select id="telegram_group_bound_user" class="col form-select" value="{$settings['telegram_group_bound_user']}">
                                            <option value="0" {if $settings['telegram_group_bound_user'] === false}selected{/if}>غیرفعال</option>
                                            <option value="1" {if $settings['telegram_group_bound_user']}selected{/if}>فعال</option>
                                        </select>
                                    </div>
                                </div>
                                <div class="form-group mb-3 row">
                                    <label class="form-label col-3 col-form-label">فعال کردن ربات تلگرام برای نمایش لینک های گروه کاربری</label>
                                    <div class="col">
                                        <select id="telegram_show_group_link" class="col form-select" value="{$settings['telegram_show_group_link']}">
                                            <option value="0" {if $settings['telegram_show_group_link'] === false}selected{/if}>غیرفعال</option>
                                            <option value="1" {if $settings['telegram_show_group_link']}selected{/if}>فعال</option>
                                        </select>
                                    </div>
                                </div>
                                <div class="form-group mb-3 row">
                                    <label class="form-label col-3 col-form-label">لینک گروه کاربری</label>
                                    <div class="col">
                                        <input id="telegram_group_link" type="text" class="form-control" value="{$settings['telegram_group_link']}">
                                    </div>
                                </div>
                                <div class="form-group mb-3 row">
                                    <label class="form-label col-3 col-form-label">ربات تلگرام پیام خوشامدگویی ارسال کند</label>
                                    <div class="col">
                                        <select id="enable_welcome_message" class="col form-select" value="{$settings['enable_welcome_message']}">
                                            <option value="0" {if $settings['enable_welcome_message'] === false}selected{/if}>غیرفعال</option>
                                            <option value="1" {if $settings['enable_welcome_message']}selected{/if}>فعال</option>
                                        </select>
                                    </div>
                                </div>
                                <div class="form-group mb-3 row">
                                    <label class="form-label col-3 col-form-label">پاسخ ندادن ربات تلگرام در گروه</label>
                                    <div class="col">
                                        <select id="telegram_group_quiet" class="col form-select" value="{$settings['telegram_group_quiet']}">
                                            <option value="0" {if $settings['telegram_group_quiet'] === false}selected{/if}>غیرفعال</option>
                                            <option value="1" {if $settings['telegram_group_quiet']}selected{/if}>فعال</option>
                                        </select>
                                    </div>
                                </div>
                                <div class="form-group mb-3 row">
                                    <label class="form-label col-3 col-form-label">به ربات‌ها اجازه دهید به گروه‌هایی غیر از آنهایی که در زیر پیکربندی شده‌اند بپیوندند</label>
                                    <div class="col">
                                        <select id="allow_to_join_new_groups" class="col form-select" value="{$settings['allow_to_join_new_groups']}">
                                            <option value="0" {if $settings['allow_to_join_new_groups'] === false}selected{/if}>غیرفعال</option>
                                            <option value="1" {if $settings['allow_to_join_new_groups']}selected{/if}>فعال</option>
                                        </select>
                                    </div>
                                </div>
                                <div class="form-group mb-3 row">
                                    <label class="form-label col-3 col-form-label">شناسه های گروه مجاز</label>
                                    <div class="col">
                                        <input id="group_id_allowed_to_join" type="text" class="form-control" value="{$settings['group_id_allowed_to_join']}">
                                    </div>
                                </div>
                                <div class="form-group mb-3 row">
                                    <label class="form-label col-3 col-form-label">آیدی ادمین اضافی تلگرام</label>
                                    <div class="col">
                                        <input id="telegram_admins" type="text" class="form-control" value="{$settings['telegram_admins']}">
                                    </div>
                                </div>
                                <div class="form-group mb-3 row">
                                    <label class="form-label col-3 col-form-label">Not admin replay</label>
                                    <div class="col">
                                        <select id="enable_not_admin_reply" class="col form-select" value="{$settings['enable_not_admin_reply']}">
                                            <option value="0" {if $settings['enable_not_admin_reply'] === false}selected{/if}>غیرفعال</option>
                                            <option value="1" {if $settings['enable_not_admin_reply']}selected{/if}>فعال</option>
                                        </select>
                                    </div>
                                </div>
                                <div class="form-group mb-3 row">
                                    <label class="form-label col-3 col-form-label">Not Admin Replay message</label>
                                    <div class="col">
                                        <input id="not_admin_reply_msg" type="text" class="form-control" value="{$settings['not_admin_reply_msg']}">
                                    </div>
                                </div>
                                <div class="form-group mb-3 row">
                                    <label class="form-label col-3 col-form-label">هنگامی که مدیر کار می کند، پاسخ کاربر را نمی توان یافت</label>
                                    <div class="col">
                                        <input id="no_user_found" type="text" class="form-control" value="{$settings['no_user_found']}">
                                    </div>
                                </div>
                                <div class="form-group mb-3 row">
                                    <label class="form-label col-3 col-form-label">هنگامی که مدیر کار می کند، فیلد برای تغییر داده ها یافت نمی شود.</label>
                                    <div class="col">
                                        <input id="data_method_not_found" type="text" class="form-control" value="{$settings['data_method_not_found']}">
                                    </div>
                                </div>
                                <div class="form-group mb-3 row">
                                    <label class="form-label col-3 col-form-label">به هر دستور ناشناخته ای اجازه دهید تا یک پاسخ /help را راه اندازی کند</label>
                                    <div class="col">
                                        <select id="help_any_command" class="col form-select" value="{$settings['help_any_command']}">
                                            <option value="0" {if $settings['help_any_command'] === false}selected{/if}>غیرفعال</option>
                                            <option value="1" {if $settings['help_any_command']}selected{/if}>فعال</option>
                                        </select>
                                    </div>
                                </div>
                                <div class="form-group mb-3 row">
                                    <label class="form-label col-3 col-form-label">فعال هنگام جستجوی اطلاعات کاربر در گروه، آدرس ایمیل کامل کاربر را نمایش دهید，غیرفعال محتوای موجود در وسط صندوق پستی کدگذاری خواهد شد</label>
                                    <div class="col">
                                        <select id="enable_user_email_group_show" class="col form-select" value="{$settings['enable_user_email_group_show']}">
                                            <option value="0" {if $settings['enable_user_email_group_show'] === false}selected{/if}>غیرفعال</option>
                                            <option value="1" {if $settings['enable_user_email_group_show']}selected{/if}>فعال</option>
                                        </select>
                                    </div>
                                </div>
                                <div class="form-group mb-3 row">
                                    <label class="form-label col-3 col-form-label">پاسخ از حساب غیرمجاز</label>
                                    <div class="col">
                                        <input id="user_not_bind_reply" type="text" class="form-control" value="{$settings['user_not_bind_reply']}">
                                    </div>
                                </div>
                                <div class="form-group mb-3 row">
                                    <label class="form-label col-3 col-form-label">معرفی محصولات برای گردشگران</label>
                                    <div class="col">
                                        <input id="telegram_general_pricing" type="text" class="form-control" value="{$settings['telegram_general_pricing']}">
                                    </div>
                                </div>
                                <div class="form-group mb-3 row">
                                    <label class="form-label col-3 col-form-label">شرایط خدمات برای بازدید کنندگان</label>
                                    <div class="col">
                                        <input id="telegram_general_terms" type="text" class="form-control" value="{$settings['telegram_general_terms']}">
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
            url: '/admin/setting/im',
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