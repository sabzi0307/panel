{include file='admin/header.tpl'}

<div class="page-wrapper">
    <div class="container-xl">
        <div class="page-header d-print-none text-white">
            <div class="row align-items-center">
                <div class="col">
                    <h2 class="page-title">
                        <span class="home-title">کاربر #{$edit_user->id}</span>
                    </h2>
                    <div class="page-pretitle my-3">
                        <span class="home-subtitle">ویرایش کاربر</span>
                    </div>
                </div>
                <div class="col-auto">
                    <div class="btn-list">
                        <a id="save_changes" href="#" class="btn btn-primary">
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
                <div class="col-md-4 col-sm-12">
                    <div class="card">
                        <div class="card-header card-header-light">
                            <h3 class="card-title">اطلاعات اولیه</h3>
                        </div>
                        <div class="card-body">
                            <div class="form-group mb-3 row">
                                <label class="form-label col-3 col-form-label">ثبت نام ایمیل</label>
                                <div class="col">
                                    <input id="email" type="email" class="form-control" value="{$edit_user->email}">
                                </div>
                            </div>
                            <div class="form-group mb-3 row">
                                <label class="form-label col-3 col-form-label">نام کاربری</label>
                                <div class="col">
                                    <input id="user_name" type="text" class="form-control"
                                        value="{$edit_user->user_name}">
                                </div>
                            </div>
                            <div class="form-group mb-3 row">
                                <label class="form-label col-3 col-form-label">ریمارک</label>
                                <div class="col">
                                    <input id="remark" type="text" class="form-control" value="{$edit_user->remark}"
                                        placeholder="فقط برای مدیران قابل مشاهده است">
                                </div>
                            </div>
                            <div class="form-group mb-3 row">
                                <label class="form-label col-3 col-form-label">رمز عبور حساب کاربری</label>
                                <div class="col">
                                    <input id="pass" type="text" class="form-control"
                                        placeholder="برای بازنشانی رمز عبور این کاربر، این قسمت را پر کنید">
                                </div>
                            </div>
                            <div class="form-group mb-3 row">
                                <label class="form-label col-3 col-form-label">موجودی حساب</label>
                                <div class="col">
                                    <input id="money" type="number" step="0.1" class="form-control"
                                        value="{$edit_user->money}">
                                </div>
                            </div>
                            <div class="hr-text">
                                <span>تعیین زمان</span>
                            </div>
                            <div class="form-group mb-3 row">
                                <label class="form-label col-4 col-form-label">زمان انقضای سطح</label>
                                <div class="col">
                                    <input id="class_expire" type="text" class="form-control"
                                        value="{$edit_user->class_expire}">
                                </div>
                            </div>
                            <div class="form-group mb-3 row">
                                <label class="form-label col-4 col-form-label">روز ریست ترافیک رایگان کاربر</label>
                                <div class="col">
                                    <input id="auto_reset_day" type="text" class="form-control"
                                        value="{$edit_user->auto_reset_day}">
                                </div>
                            </div>
                            <div class="form-group mb-3 row">
                                <label class="form-label col-4 col-form-label">
                                ریست ترافیک رایگان(GB)
                                </label>
                                <div class="col">
                                    <input id="auto_reset_bandwidth" type="text" class="form-control"
                                        value="{$edit_user->auto_reset_bandwidth}">
                                </div>
                            </div>
                            <div class="hr-text">
                                <span>گزینه های پیشرفته</span>
                            </div>
                            <div class="form-group mb-3 row">
                                <span class="col">مدیر</span>
                                <span class="col-auto">
                                    <label class="form-check form-check-single form-switch">
                                        <input id="is_admin" class="form-check-input" type="checkbox"
                                            {if $edit_user->is_admin}checked="" {/if}>
                                    </label>
                                </span>
                            </div>
                            <div class="form-group mb-3 row">
                                <span class="col">احراز هویت دو مرحله ای</span>
                                <span class="col-auto">
                                    <label class="form-check form-check-single form-switch">
                                        <input id="ga_enable" class="form-check-input" type="checkbox"
                                            {if $edit_user->ga_enable}checked="" {/if}>
                                    </label>
                                </span>
                            </div>
                            <div class="form-group mb-3 row">
                                <span class="col">وضعیت غیر عادی حساب</span>
                                <span class="col-auto form-check-single form-switch">
                                    <input id="is_shadow_banned" class="form-check-input" type="checkbox"
                                            {if $edit_user->is_shadow_banned}checked=""{/if}>
                                </span>
                            </div>
                            <div class="form-group mb-3 row">
                                <span class="col">ممنوع کردن کاربر</span>
                                <span class="col-auto">
                                    <label class="form-check form-check-single form-switch">
                                        <input id="is_banned" class="form-check-input" type="checkbox"
                                            {if $edit_user->is_banned}checked=""{/if}>
                                    </label>
                                </span>
                            </div>
                            <div class="form-group mb-3 row">
                                <span class="col">علت ممنوعیت دستی</span>
                                <span class="col-auto">
                                    <input id="banned_reason" type="text" class="form-control"
                                        value="{$edit_user->banned_reason}">
                                </span>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-md-4 col-sm-12">
                    <div class="card">
                        <div class="card-header card-header-light">
                            <h3 class="card-title">سایر اطلاعات</h3>
                        </div>
                        <div class="card-body">
                            <div class="form-group mb-3 row">
                                <label class="form-label col-4 col-form-label">محدودیت های ترافیکی</label>
                                <div class="col">
                                    <input id="transfer_enable" type="text" class="form-control"
                                        value="{$edit_user->enableTraffic()}">
                                </div>
                            </div>
                            <div class="form-group mb-3 row">
                                <label class="form-label col-4 col-form-label">مصرف کنونی</label>
                                <div class="col">
                                    <input id="usedTraffic" type="text" class="form-control"
                                        value="{$edit_user->usedTraffic()}" disabled />
                                </div>
                            </div>
                            <div class="form-group mb-3 row">
                                <label class="form-label col-4 col-form-label">استفاده کل</label>
                                <div class="col">
                                    <input id="usedTraffic" type="text" class="form-control"
                                           value="{$edit_user->totalTraffic()}" disabled />
                                </div>
                            </div>
                            <div class="hr-text">
                                <span>دعوت به ثبت نام</span>
                            </div>
                            <div class="form-group mb-3 row">
                                <label class="form-label col-4 col-form-label">تعداد دعوت نامه های موجود</label>
                                <div class="col">
                                    <input id="invite_num" type="text" class="form-control"
                                        value="{$edit_user->invite_num}">
                                </div>
                            </div>
                            <div class="form-group mb-3 row">
                                <label class="form-label col-4 col-form-label">افراد را دعوت کنید</label>
                                <div class="col">
                                    <input id="ref_by" type="text" class="form-control" value="{$edit_user->ref_by}">
                                </div>
                            </div>
                            <div class="hr-text">
                                <span>محدودیت های تخصیص و استفاده</span>
                            </div>
                            <div class="form-group mb-3 col-12">
                                    <label class="form-label col-12 col-form-label">گروه سرور</label>
                                    <div class="col">
                                        <input id="node_group" type="text" class="form-control"
                                            value="{$edit_user->node_group}">
                                    </div>
                                </div>
                                <div class="form-group mb-3 col-12">
                                    <label class="form-label col-12 col-form-label">سطح حساب</label>
                                    <div class="col">
                                        <input id="class" type="text" class="form-control" value="{$edit_user->class}">
                                    </div>
                                </div>
                                <div class="form-group mb-3 col-12">
                                    <label class="form-label col-12 col-form-label">محدودیت سرعت (Mbps)</label>
                                    <div class="col">
                                        <input id="node_speedlimit" type="text" class="form-control"
                                            value="{$edit_user->node_speedlimit}">
                                    </div>
                                </div>
                                <div class="form-group mb-3 col-12">
                                    <label class="form-label col-12 col-form-label">محدودیت اتصال همزمان IP</label>
                                    <div class="col">
                                        <input id="node_iplimit" type="text" class="form-control"
                                            value="{$edit_user->node_iplimit}">
                                    </div>
                                </div>
                        </div>
                    </div>
                </div>
                <div class="col-md-4 col-sm-12">
                    <div class="card">
                        <div class="card-header card-header-light">
                            <h3 class="card-title">تنظیمات اتصال</h3>
                        </div>
                        <div class="card-body">
                            <div class="form-group mb-3 row">
                                <label class="form-label col-3 col-form-label">پورت</label>
                                <div class="col">
                                    <input id="port" type="text" class="form-control" value="{$edit_user->port}">
                                </div>
                            </div>
                            <div class="form-group mb-3 row">
                                <label class="form-label col-3 col-form-label">کلمه عبور</label>
                                <div class="col">
                                    <input id="passwd" type="text" class="form-control" value="{$edit_user->passwd}">
                                </div>
                            </div>
                            <div class="form-group mb-3 row">
                                <label class="form-label col-3 col-form-label">رمزگذاری</label>
                                <div class="col">
                                    <input id="method" type="text" class="form-control" value="{$edit_user->method}">
                                </div>
                            </div>
                            <div class="hr-text">
                                <span>محدودیت بازدید</span>
                            </div>
                            <div class="form-group mb-3 row">
                                <label class="form-label col-3 col-form-label">IP / CIDR</label>
                                <div class="col">
                                    <textarea id="forbidden_ip" class="col form-control"
                                        rows="2">{$edit_user->forbidden_ip}</textarea>
                                </div>
                            </div>
                            <div class="form-group mb-3 row">
                                <label class="form-label col-3 col-form-label">PORT</label>
                                <div class="col">
                                    <textarea id="forbidden_port" class="col form-control"
                                        rows="2">{$edit_user->forbidden_port}</textarea>
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
    $("#save_changes").click(function() {
        $.ajax({
            url: '/admin/user/{$edit_user->id}',
            type: 'PUT',
            dataType: "json",
            data: {
                {foreach $update_field as $key}
                {$key}: $('#{$key}').val(),
                {/foreach}
                is_admin: $("#is_admin").is(":checked"),
                is_banned: $("#is_banned").is(":checked"),
                ga_enable: $("#ga_enable").is(":checked"),
                is_shadow_banned: $("#is_shadow_banned").is(":checked"),
            },
            success: function(data) {
                if (data.ret === 1) {
                    $('#success-message').text(data.msg);
                    $('#success-dialog').modal('show');
                    window.setTimeout("location.href=top.document.referrer", {$config['jump_delay']});
                } else {
                    $('#fail-message').text(data.msg);
                    $('#fail-dialog').modal('show');
                }
            }
        })
    });
</script>

{include file='admin/footer.tpl'}
