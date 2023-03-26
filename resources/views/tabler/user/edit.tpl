{include file='user/tabler_header.tpl'}

<div class="page-wrapper">
    <div class="container-xl">
        <div class="page-header d-print-none text-white">
            <div class="row align-items-center">
                <div class="col">
                    <h2 class="page-title">
                        <span class="home-title">اصلاح داده ها</span>
                    </h2>
                    <div class="page-pretitle my-3">
                        <span class="home-subtitle">برخی از اطلاعات حساب را تغییر دهید</span>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div class="page-body">
        <div class="container-xl">
            <div class="row row-cards">
                <div class="col-12">
                    <div class="card">
                        <ul class="nav nav-tabs nav-fill" data-bs-toggle="tabs" role="tablist">
                            <li class="nav-item" role="presentation">
                                <a href="#personal_information" class="nav-link active" data-bs-toggle="tab"
                                    aria-selected="true" role="tab">
                                    <i class="ti ti-chart-candle icon"></i>&nbsp;
                                    اطلاعات
                                </a>
                            </li>
                            <li class="nav-item" role="presentation">
                                <a href="#login_security" class="nav-link" data-bs-toggle="tab" aria-selected="true"
                                    role="tab">
                                    <i class="ti ti-shield-lock icon"></i>&nbsp;
                                    ورود
                                </a>
                            </li>
                            <li class="nav-item" role="presentation">
                                <a href="#use_safety" class="nav-link" data-bs-toggle="tab" aria-selected="false"
                                    tabindex="-1" role="tab">
                                    <i class="ti ti-brand-telegram icon"></i>&nbsp;
                                    استفاده
                                </a>
                            </li>
                            <li class="nav-item" role="presentation">
                                <a href="#other_settings" class="nav-link" data-bs-toggle="tab" aria-selected="false"
                                    tabindex="-1" role="tab">
                                    <i class="ti ti-settings icon"></i>&nbsp;
                                    دیگر
                                </a>
                            </li>
                        </ul>
                        <div class="card-body">
                            <div class="tab-content">
                                <div class="tab-pane active show" id="personal_information" role="tabpanel">
                                    <div class="row row-cards">
                                        <div class="col-sm-12 col-md-6">
                                            <div class="card">
                                                <div class="card-body">
                                                    <h3 class="card-title">ورود به ایمیل</h3>
                                                    <p>ایمیل فعلی：<code>{$user->email}</code></p>
                                                    <div class="mb-3">
                                                        <input id="new-email" type="email" class="form-control"
                                                            placeholder="ایمیل جدید" {if $config['enable_change_email'] == false}disabled=""{/if}>
                                                    </div>
                                                    {if $public_setting['reg_email_verify'] == true && $config['enable_change_email'] == true}
                                                    <div class="mb-3">
                                                        <input id="email-code" type="text" class="form-control"
                                                            placeholder="کد تایید">
                                                    </div>
                                                    {/if}
                                                </div>
                                                <div class="card-footer">
                                                    <div class="d-flex">
                                                        {if $public_setting['reg_email_verify'] == true && $config['enable_change_email'] == true}
                                                        <a id="email-verify" class="btn btn-link">دریافت کد تایید</a>
                                                        <button id="modify-email"
                                                            class="btn btn-primary ms-auto">تجدید نظر کنید</button>
                                                        {elseif $config['enable_change_email'] == true}
                                                        <button id="modify-email"
                                                            class="btn btn-primary ms-auto">تجدید نظر کنید</button>
                                                        {else}
                                                        <button id="modify-email" class="btn btn-primary ms-auto"
                                                            disabled>تغییر مجاز نیست</button>
                                                        {/if}
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="col-sm-12 col-md-6">
                                            <div class="card">
                                                <div class="card-body">
                                                    <h3 class="card-title">اطلاعات تماس</h3>
                                                    <div class="mb-3">
                                                        <select id="imtype" class="form-select">
                                                            <option value="1" {if $user->im_type == '1'}selected{/if}>
                                                                WeChat</option>
                                                            <option value="2" {if $user->im_type == '2'}selected{/if}>
                                                                QQ</option>
                                                            <option value="3" {if $user->im_type == '3'}selected{/if}>
                                                                Facebook</option>
                                                            <option value="4" {if $user->im_type == '4'}selected{/if}>
                                                                Telegram</option>
                                                            <option value="5" {if $user->im_type == '5'}selected{/if}>
                                                                Discord</option>
                                                        </select>
                                                    </div>
                                                    <div class="mb-3">
                                                        <input id="wechat" type="text" class="form-control"
                                                            value="{$user->im_value}" placeholder="حساب کاربری اجتماعی">
                                                    </div>
                                                </div>
                                                <div class="card-footer">
                                                    <div class="d-flex">
                                                        <a id="modify-im" class="btn btn-primary ms-auto">تجدید نظر کنید</a>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="col-sm-12 col-md-6">
                                            <div class="card">
                                                <div class="card-body">
                                                    <h3 class="card-title">شناسه کاربری</h3>
                                                    <p>شناسه کاربری فعلی：<code>{$user->user_name}</code></p>
                                                    <div class="mb-3">
                                                        <input id="new-nickname" type="text" class="form-control"
                                                        placeholder="شناسه کاربری جدید" autocomplete="off">
                                                    </div>
                                                </div>
                                                <div class="card-footer">
                                                    <div class="d-flex">
                                                        <a id="modify-username" class="btn btn-primary ms-auto">تجدید نظر کنید</a>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        {if $config['enable_telegram'] == true}
                                        <div class="col-sm-12 col-md-6">
                                            {if $user->telegram_id != 0}
                                            <div class="card">
                                                <div class="card-body">
                                                    <h3 class="card-title">باز کردن Telegram</h3>
                                                    <p>اکانت تلگرام در حال حاضر محدود شده است：
                                                        {if $user->im_value === "نام کاربری تنظیم نشده است"}
                                                        <code>{$user->telegram_id}</code>
                                                        {else}
                                                        <a href="https://t.me/{$user->im_value}">@{$user->im_value}</a>
                                                        {/if}
                                                    </p>
                                                </div>
                                                <div class="card-footer">
                                                    <div class="d-flex">
                                                        <a href="/user/telegram_reset"
                                                            class="btn btn-red ms-auto">باز کردن</a>
                                                    </div>
                                                </div>
                                            </div>
                                            {else}
                                            <div class="card">
                                                <div class="card-body">
                                                    <h3 class="card-title">به تلگرام متصل شوید</h3>
                                                    <div class="row">
                                                        <div class="col-6 col-sm-2 col-md-2 col-xl mb-3">
                                                            اگر تلگرام را روی گوشی، کامپیوتر، تبلت و ... خود نصب کرده اید، می توانید کلیک کنید
                                                        </div>
                                                        <div class="col-6 col-sm-2 col-md-2 col-sm mb-3">
                                                            <a href="https://t.me/{$telegram_bot}?start={$bind_token}"
                                                                class="btn btn-primary w-100">
                                                                اتصال یک کلید
                                                            </a>
                                                        </div>
                                                    </div>
                                                    <div class="row">
                                                        <div class="col-6 col-sm-2 col-md-2 col-xl mb-3">
                                                            به ربات <a
                                                                href="https://t.me/{$telegram_bot}">@{$telegram_bot}</a>
                                                                ارسال کد تأیید
                                                        </div>
                                                        <div class="col-6 col-sm-2 col-md-2 col-sm mb-3">
                                                            <button data-clipboard-text="{$bind_token}"
                                                                class="copy btn btn-primary w-100">
                                                                کد تایید را کپی کنید
                                                            </button>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                            {/if}
                                        </div>
                                        {/if}
                                    </div>
                                </div>
                                <div class="tab-pane" id="login_security" role="tabpanel">
                                    <div class="row row-cards">
                                        <div class="col-sm-12 col-md-6">
                                            <div class="card">
                                                <div class="card-body">
                                                    <h3 class="card-title">احراز هویت دو مرحله ای</h3>
                                                    <div class="col-md-12">
                                                        <div class="col-sm-6 col-md-6">
                                                            <p>
                                                                <i class="ti ti-brand-apple"></i>
                                                                <a target="view_window"
                                                                    href="https://apps.apple.com/us/app/google-authenticator/id388497605">کلاینت اپل
                                                                </a>
                                                                &nbsp;&nbsp;&nbsp;
                                                                <i class="ti ti-brand-android"></i>
                                                                <a target="view_window"
                                                                    href="https://play.google.com/store/apps/details?id=com.google.android.apps.authenticator2&hl=zh&gl=US">کلاینت اندروید
                                                                </a>
                                                            </p>
                                                        </div>
                                                    </div>
                                                    <div class="row">
                                                        <div class="col-md-3">
                                                            <p id="qrcode"></p>
                                                        </div>
                                                        <div class="col-md-9">
                                                            <div class="mb-3">
                                                                <select id="ga-enable" class="form-select">
                                                                    <option value="0">استفاده نشود</option>
                                                                    <option value="1"
                                                                        {if $user->ga_enable == '1'}selected{/if}>
                                                                        با احراز هویت دو مرحله ای وارد شوید
                                                                    </option>
                                                                </select>
                                                            </div>
                                                            <div class="mb-3">
                                                                <input id="2fa-test-code" type="text"
                                                                    class="form-control" placeholder="کد تأیید احراز هویت 2 مرحله ای را آزمایش کنید">
                                                            </div>
                                                            <div class="col-md-12">
                                                                <p>کلید：<code>{$user->ga_token}</code></p>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                                <div class="card-footer">
                                                    <div class="d-flex">
                                                        <a id="reset-2fa" class="btn btn-link">تنظیم مجدد</a>
                                                        <a id="test-2fa" class="btn btn-link">تست</a>
                                                        <a id="save-2fa" class="btn btn-primary ms-auto">نصب</a>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="col-sm-12 col-md-6">
                                            <div class="card">
                                                <div class="card-body">
                                                    <h3 class="card-title">رمز ورود را تغییر دهید</h3>
                                                    <div class="mb-3">
                                                        <form>
                                                            <input id="password" type="password" class="form-control"
                                                                placeholder="رمز ورود فعلی" autocomplete="off">
                                                        </form>
                                                    </div>
                                                    <div class="mb-3">
                                                        <form>
                                                            <input id="new-password" type="password"
                                                                class="form-control" placeholder="یک رمز جدید وارد کنید"
                                                                autocomplete="off">
                                                        </form>
                                                    </div>
                                                    <div class="mb-3">
                                                        <form>
                                                            <input id="again-new-password" type="password"
                                                                class="form-control" placeholder="رمز جدید را دوباره وارد کنید"
                                                                autocomplete="off">
                                                        </form>
                                                    </div>
                                                </div>
                                                <div class="card-footer">
                                                    <div class="d-flex">
                                                        <a id="modify-login-passwd"
                                                            class="btn btn-primary ms-auto">تجدید نظر کنید</a>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="tab-pane" id="use_safety" role="tabpanel">
                                    <div class="row row-cards">
                                        <div class="col-sm-12 col-md-6">
                                            <div class="card">
                                                <div class="card-body">
                                                    <h3 class="card-title">تغییر روش رمزگذاری</h3>
                                                    <p>روش‌های رمزگذاری پشتیبانی‌شده توسط کلاینت‌های مختلف ممکن است متفاوت باشد، لطفاً برای تنظیم به فهرست پشتیبانی مشتری مراجعه کنید</p>
                                                    <div class="mb-3">
                                                        <select id="user-method" class="form-select">
                                                            {foreach $methods as $method}
                                                            <option value="{$method}"
                                                                {if $user->method == $method}selected{/if}
                                                            >{$method}
                                                            </option>
                                                            {/foreach}
                                                        </select>
                                                    </div>
                                                </div>
                                                <div class="card-footer">
                                                    <div class="d-flex">
                                                        <a id="modify-user-method" class="btn btn-primary ms-auto">تجدید نظر کنید</a>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="col-sm-12 col-md-6">
                                            <div class="card">
                                                <div class="card-body">
                                                    <h3 class="card-title">تغییر آدرس اشتراک</h3>
                                                    <p>پس از تغییر آدرس اشتراک، آدرس اشتراک قدیمی قادر به دریافت پیکربندی نخواهد بود، اما همچنان می توان از پیکربندی سرور استفاده کرد. اگر می‌خواهید پیکربندی سرور قدیمی غیرقابل استفاده باشد، لطفاً رمز عبور را تغییر دهید.</p>
                                                </div>
                                                <div class="card-footer">
                                                    <div class="d-flex">
                                                        <a id="reset-sub-url"
                                                            class="btn btn-primary ms-auto bg-red">جایگزین کردن</a>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="col-sm-12 col-md-6">
                                            <div class="card">
                                                <div class="card-body">
                                                    <h3 class="card-title">پورت اتصال را تغییر دهید</h3>
                                                    <p>به طور تصادفی یک پورت اتصال اختصاص دهید، این پورت برای کلاینت های SS/SSR استفاده خواهد شد</p>
                                                    <p>پورت فعلی است：<code>{$user->port}</code></p>
                                                </div>
                                                <div class="card-footer">
                                                    <div class="d-flex">
                                                        <a id="reset-client-port" class="btn btn-red ms-auto">جایگزین کردن</a>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="col-sm-12 col-md-6">
                                            <div class="card">
                                                <div class="card-body">
                                                    <h3 class="card-title">بازنشانی رمز عبور اتصال</h3>
                                                    <p>رمز عبور اتصال و UUID را بازنشانی کنید. پس از بازنشانی، برای ادامه استفاده باید اشتراک را به‌روزرسانی کنید</p>
                                                    <p>رمز عبور اتصال فعلی：<code>{$user->passwd}</code></p>
                                                    <p>UUID فعلی：<code>{$user->uuid}</code></p>
                                                </div>
                                                <div class="card-footer">
                                                    <div class="d-flex">
                                                        <a id="reset-passwd"
                                                            class="btn btn-primary ms-auto bg-red">تنظیم مجدد</a>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="tab-pane" id="other_settings" role="tabpanel">
                                    <div class="row row-cards">
                                        <div class="col-sm-12 col-md-6">
                                            <div class="card">
                                                <div class="card-body">
                                                    <h3 class="card-title">فشار مصرف روزانه</h3>
                                                    <div class="mb-3">
                                                        <select id="daily-report" class="form-select">
                                                            <option value="0"
                                                                {if $user->sendDailyMail == '0'}selected{/if}>نفرست
                                                            </option>
                                                            <option value="1"
                                                                {if $user->sendDailyMail == '1'}selected{/if}>دریافت پستی
                                                            </option>
                                                            <option value="2"
                                                                {if $user->sendDailyMail == '2'}selected{/if}>Telegram
                                                                Bot به عهده گرفتن
                                                            </option>
                                                        </select>
                                                    </div>
                                                </div>
                                                <div class="card-footer">
                                                    <div class="d-flex">
                                                        <a id="modify-daily-report"
                                                            class="btn btn-primary ms-auto">تجدید نظر کنید</a>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="col-sm-12 col-md-6">
                                            <div class="card">
                                                <div class="card-body">
                                                    <h3 class="card-title">تم را تغییر دهید</h3>
                                                    <div class="mb-3">
                                                        <select id="user-theme" class="form-select">
                                                            {foreach $themes as $theme}
                                                                <option value="{$theme}"
                                                                    {if $user->theme == $theme}selected{/if}>{$theme}
                                                                </option>
                                                            {/foreach}
                                                        </select>
                                                    </div>
                                                </div>
                                                <div class="card-footer">
                                                    <div class="d-flex">
                                                        <a id="modify-user-theme" class="btn btn-primary ms-auto">تجدید نظر کنید</a>
                                                    </div>
                                                </div>
                                            </div>   
                                        </div>
                                        {if $config['enable_kill'] == true}
                                        <div class="col-sm-12 col-md-6">
                                            <div class="card">
                                                <div class="card-stamp">
                                                    <div class="card-stamp-icon bg-red">
                                                        <i class="ti ti-circle-x"></i>
                                                    </div>
                                                </div>
                                                <div class="card-body">
                                                    <h3 class="card-title">حذف اطلاعات حساب</h3>
                                                </div>    
                                                <div class="card-footer">
                                                    <a href="#" class="btn btn-red d-none d-sm-inline-block" data-bs-toggle="modal"
                                                        data-bs-target="#destroy-account">
                                                        <i class="ti ti-trash icon"></i>
                                                        تایید حذف
                                                    </a>
                                                </div>
                                            </div>  
                                        </div>
                                        {/if}
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    {if $config['enable_kill'] == true}
    <div class="modal modal-blur fade" id="destroy-account" tabindex="-1" role="dialog" aria-hidden="true">
        <div class="modal-dialog modal-sm modal-dialog-centered" role="document">
            <div class="modal-content">
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                <div class="modal-status bg-danger"></div>
                <div class="modal-body text-center py-4">
                    <i class="ti ti-alert-circle icon mb-2 text-danger icon-lg" style="font-size:3.5rem;"></i>
                    <h3>حذف تاییدیه</h3>
                    <div class="text-muted">لطفاً تأیید کنید که آیا واقعاً می خواهید حساب خود را حذف کنید، این عملیات قابل واگرد نیست و تمام اطلاعات حساب شما به طور کامل از سرور حذف خواهد شد.</div>
                    <div class="py-3">
                        <form>
                            <input id="confirm-passwd" type="password" class="form-control" placeholder="输入登录密码"
                                autocomplete="off">
                        </form>
                    </div>
                </div>
                <div class="modal-footer">
                    <div class="w-100">
                        <div class="row">
                            <div class="col">
                                <a href="#" class="btn w-100" data-bs-dismiss="modal">
                                    لغو
                                </a>
                            </div>
                            <div class="col">
                                <a href="#" id="confirm-destroy" class="btn btn-danger w-100" data-bs-dismiss="modal">
                                    تایید
                                </a>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="modal modal-blur fade" id="destroy-account-success" tabindex="-1" role="dialog" aria-hidden="true">
        <div class="modal-dialog modal-sm modal-dialog-centered" role="document">
            <div class="modal-content">
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                <div class="modal-status bg-success"></div>
                <div class="modal-body text-center py-4">
                    <i class="ti ti-circle-check icon mb-2 text-green icon-lg" style="font-size:3.5rem;"></i>
                    <h3>با موفقیت حذف شد</h3>
                    <p id="success-message" class="text-muted">با موفقیت حذف شد</p>
                </div>
                <div class="modal-footer">
                    <div class="w-100">
                        <div class="row">
                            <div class="col">
                                <a href="#" class="btn w-100" data-bs-dismiss="modal">
                                    این خوبه
                                </a>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="modal modal-blur fade" id="destroy-account-fail" tabindex="-1" role="dialog" aria-hidden="true">
        <div class="modal-dialog modal-sm modal-dialog-centered" role="document">
            <div class="modal-content">
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                <div class="modal-status bg-danger"></div>
                <div class="modal-body text-center py-4">
                    <i class="ti ti-circle-x icon mb-2 text-danger icon-lg" style="font-size:3.5rem;"></i>
                    <h3>حذف نشد</h3>
                    <p id="error-message" class="text-muted">حذف نشد</p>
                </div>
                <div class="modal-footer">
                    <div class="w-100">
                        <div class="row">
                            <div class="col">
                                <a href="#" class="btn btn-danger w-100" data-bs-dismiss="modal">
                                    تایید
                                </a>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    {/if}

    <script>
        var qrcode = new QRCode('qrcode', {
            text: "{$gaurl}",
            width: 128,
            height: 128,
            colorDark: '#000000',
            colorLight: '#ffffff',
            correctLevel: QRCode.CorrectLevel.H
        });

        var clipboard = new ClipboardJS('.copy');
        clipboard.on('success', function(e) {
            $('#success-message').text('در کلیپ بورد کپی شد');
            $('#success-dialog').modal('show');
        });

        $("#modify-email").click(function() {
            $.ajax({
                type: "POST",
                url: "/user/email",
                dataType: "json",
                data: {
                    {if $public_setting['reg_email_verify'] == true}
                        emailcode: $('#email-code').val(),
                    {/if}
                    newemail: $('#new-email').val()
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

        $("#email-verify").click(function() {
            $.ajax({
                type: "POST",
                url: "/user/send",
                dataType: "json",
                data: {
                    email: $('#new-email').val()
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

        $("#modify-username").click(function() {
            $.ajax({
                type: "POST",
                url: "/user/username",
                dataType: "json",
                data: {
                    newusername: $('#new-nickname').val()
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

        $("#modify-user-method").click(function() {
            $.ajax({
                type: "POST",
                url: "/user/method",
                dataType: "json",
                data: {
                    method: $('#user-method').val()
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

        $("#reset-sub-url").click(function() {
            $.ajax({
                type: "POST",
                url: "/user/url_reset",
                dataType: "json",
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

        $("#modify-user-theme").click(function() {
            $.ajax({
                type: "POST",
                url: "/user/theme",
                dataType: "json",
                data: {
                    theme: $('#user-theme').val()
                },
                success: function(data) {
                    if (data.ret == 1) {
                        $('#success-message').text(data.msg);
                        $('#success-dialog').modal('show');
                        window.setTimeout("location.reload()", {$config['jump_delay']});
                    } else {
                        $('#fail-message').text(data.msg);
                        $('#fail-dialog').modal('show');
                    }
                }
            })
        });

        $("#modify-daily-report").click(function() {
            $.ajax({
                type: "POST",
                url: "/user/mail",
                dataType: "json",
                data: {
                    mail: $('#daily-report').val()
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

        $("#reset-client-port").click(function() {
            $.ajax({
                type: "POST",
                url: "/user/port",
                dataType: "json",
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

        $("#reset-passwd").click(function() {
            $.ajax({
                type: "POST",
                url: "/user/sspwd",
                dataType: "json",
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

        $("#modify-login-passwd").click(function() {
            $.ajax({
                type: "POST",
                url: "/user/password",
                dataType: "json",
                data: {
                    pwd: $('#new-password').val(),
                    repwd: $('#again-new-password').val(),
                    oldpwd: $('#password').val()
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

        $("#modify-im").click(function() {
            $.ajax({
                type: "POST",
                url: "/user/contact_update",
                dataType: "json",
                data: {
                    imtype: $('#imtype').val(),
                    imvalue: $('#imvalue').val()
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

        $("#reset-2fa").click(function() {
            $.ajax({
                type: "POST",
                url: "/user/ga_reset",
                dataType: "json",
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

        $("#test-2fa").click(function() {
            $.ajax({
                type: "POST",
                url: "/user/ga_check",
                dataType: "json",
                data: {
                    code: $('#2fa-test-code').val()
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

        $("#save-2fa").click(function() {
            $.ajax({
                type: "POST",
                url: "/user/ga_set",
                dataType: "json",
                data: {
                    enable: $('#ga-enable').val()
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
        
        {if $config['enable_kill'] == true}
        $("#confirm-destroy").click(function() {
            $.ajax({
                type: "POST",
                url: "/user/kill",
                dataType: "json",
                data: {
                    passwd: $('#confirm-passwd').val(),
                },
                success: function(data) {
                    if (data.ret == 1) {
                        $('#success-message').text(data.msg);
                        $('#destroy-account-success').modal('show');
                    } else {
                        $('#error-message').text(data.msg);
                        $('#destroy-account-fail').modal('show');
                    }
                }
            })
        });
        {/if}
    </script>
    
{include file='user/tabler_footer.tpl'}