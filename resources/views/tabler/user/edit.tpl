{include file='user/header.tpl'}

<script src="//{$config['jsdelivr_url']}/npm/jquery/dist/jquery.min.js"></script>

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
            <div class="row row-deck row-cards">
                <div class="col-12">
                    <div class="card">
                        <ul class="nav nav-tabs nav-fill" data-bs-toggle="tabs" role="tablist">
                            <li class="nav-item" role="presentation">
                                <a href="#personal_information" class="nav-link active" data-bs-toggle="tab"
                                   aria-selected="true" role="tab">
                                    <i class="ti ti-chart-candle icon"></i>&nbsp;
                                    اطلاعات کاربری
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
                                    اشتراک
                                </a>
                            </li>
                            <li class="nav-item" role="presentation">
                                <a href="#other_settings" class="nav-link" data-bs-toggle="tab" aria-selected="false"
                                   tabindex="-1" role="tab">
                                    <i class="ti ti-settings icon"></i>&nbsp;
                                    سایر
                                </a>
                            </li>
                        </ul>
                        <div class="card-body">
                            <div class="tab-content">
                                <div class="tab-pane active show" id="personal_information" role="tabpanel">
                                    <div class="row row-deck row-cards">
                                        <div class="col-sm-12 col-md-6">
                                            <div class="card">
                                                <div class="card-body">
                                                    <h3 class="card-title">ایمیل ورود به حساب</h3>
                                                    <p>ایمیل فعلی：<code id="email">{$user->email}</code></p>
                                                    <div class="mb-3">
                                                        <input id="new-email" type="email" class="form-control"
                                                               placeholder="ایمیل جدید"
                                                               {if ! $config['enable_change_email']}disabled=""{/if}>
                                                    </div>
                                                    {if $public_setting['reg_email_verify'] && $config['enable_change_email']}
                                                        <div class="mb-3">
                                                            <input id="email-code" type="text" class="form-control"
                                                                   placeholder="کد تایید">
                                                        </div>
                                                    {/if}
                                                </div>
                                                <div class="card-footer">
                                                    <div class="d-flex">
                                                        {if $public_setting['reg_email_verify'] && $config['enable_change_email']}
                                                            <button id="email-verify" class="btn btn-link"
                                                                    hx-post="/user/send" hx-swap="none"
                                                                    hx-vals='js:{ email: document.getElementById("newemail").value }'>
                                                                    دریافت کد تایید
                                                            </button>
                                                            <button id="modify-email" class="btn btn-primary ms-auto"
                                                                    hx-post="/user/email" hx-swap="none"
                                                                    hx-vals='js:{
                                                                        newemail: document.getElementById("new-email").value,
                                                                        emailcode: document.getElementById("email-code").value
                                                                    }'>
                                                                ویرایش
                                                            </button>
                                                        {elseif $config['enable_change_email']}
                                                            <button id="modify-email" class="btn btn-primary ms-auto"
                                                                    hx-post="/user/email" hx-swap="none"
                                                                    hx-vals='js:{ newemail: document.getElementById("new-email").value }'>
                                                                ویرایش
                                                            </button>
                                                        {else}
                                                            <button id="modify-email" class="btn btn-primary ms-auto"
                                                                    disabled>تغییر مجاز نیست
                                                            </button>
                                                        {/if}
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="col-sm-12 col-md-6">
                                            <div class="card">
                                                <div class="card-body">
                                                    <h3 class="card-title">نام کاربری</h3>
                                                    <p>نام کاربری فعلی: <code id="username">{$user->user_name}</code></p>
                                                    <div class="mb-3">
                                                        <input id="new-username" type="text" class="form-control"
                                                               placeholder="نام کاربری جدید" autocomplete="off">
                                                    </div>
                                                </div>
                                                <div class="card-footer">
                                                    <div class="d-flex">
                                                        <button id="modify-username" class="btn btn-primary ms-auto"
                                                           hx-post="/user/username" hx-swap="none"
                                                           hx-vals='js:{ newusername: document.getElementById("new-username").value }'>
                                                            ویرایش
                                                        </button>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="col-sm-12 col-md-6">
                                            <div class="card">
                                                <div class="card-body">
                                                    <h3 class="card-title">IM الزام در گرفتن حساب</h3>
                                                    <div class="mb-3">
                                                        <select id="imtype" class="form-select"
                                                                {if $user->im_type !== 0 && $user->im_value !== ''}disabled=""{/if}>
                                                            <option value="0" {if $user->im_type === 0}selected{/if}>
                                                                Not bound
                                                            </option>
                                                            <option value="1" {if $user->im_type === 1}selected{/if}>
                                                                Slack
                                                            </option>
                                                            <option value="2" {if $user->im_type === 2}selected{/if}>
                                                                Discord
                                                            </option>
                                                            <option value="4" {if $user->im_type === 4}selected{/if}>
                                                                Telegram
                                                            </option>
                                                        </select>
                                                    </div>
                                                    <div class="mb-3">
                                                        <input id="imvalue" type="text" class="form-control"
                                                               disabled="" value="{$user->im_value}">
                                                    </div>
                                                </div>
                                                <div class="card-footer">
                                                    <div class="d-flex btn-list justify-content-end"
                                                         id="oauth-provider"></div>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="col-sm-12 col-md-6">
                                            <div class="card">
                                                <div class="card-body">
                                                    <h3 class="card-title">لغو پیوند حساب IM</h3>
                                                    {if $user->im_type === 0}
                                                        <p>حساب شما در حال حاضر به هیچ سرویس پیام فوری متصل نیست</p>
                                                    {else}
                                                        <p>
                                                            سرویس IM در حال حاضر محدود شده است：{$user->imType()}
                                                            <br>
                                                            شناسه حساب：<code>{$user->im_value}</code>
                                                        </p>
                                                    {/if}
                                                </div>
                                                {if $user->im_type !== 0}
                                                    <div class="card-footer">
                                                        <div class="d-flex">
                                                            <button id="unbind-im" class="btn btn-red ms-auto"
                                                                    hx-post="/user/unbind_im" hx-swap="none">
                                                                باز کردن
                                                            </button>
                                                        </div>
                                                    </div>
                                                {/if}
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="tab-pane" id="login_security" role="tabpanel">
                                    <div class="row row-deck row-cards">
                                        <div class="col-sm-12 col-md-6">
                                            <div class="card">
                                                <div class="card-body">
                                                    <h3 class="card-title">احراز هویت چند عاملی</h3>
                                                    <div class="col-md-12">
                                                        <div class="col-sm-6 col-md-6">
                                                            <i class="ti ti-brand-apple"></i>
                                                            <a target="view_window"
                                                               href="https://apps.apple.com/us/app/google-authenticator/id388497605">مشتری iOS
                                                               
                                                            </a>
                                                            &nbsp;&nbsp;&nbsp;
                                                            <i class="ti ti-brand-android"></i>
                                                            <a target="view_window"
                                                               href="https://play.google.com/store/apps/details?id=com.google.android.apps.authenticator2">Android
                                                                مشتری
                                                            </a>
                                                        </div>
                                                    </div>
                                                    <br>
                                                    <div class="row">
                                                        <div class="col-md-3">
                                                            <p id="qrcode"></p>
                                                        </div>
                                                        <div class="col-md-9">
                                                            <div class="mb-3">
                                                                <select id="ga-enable" class="form-select">
                                                                    <option value="0">استفاده نشود</option>
                                                                    <option value="1"
                                                                            {if $user->ga_enable === '1'}selected{/if}>
                                                                        با احراز هویت دو مرحله ای وارد شوید
                                                                    </option>
                                                                </select>
                                                            </div>
                                                            <div class="mb-3">
                                                                <input id="ga-test-code" type="text"
                                                                       class="form-control"
                                                                       placeholder="کد تأیید احراز هویت 2 مرحله ای را آزمایش کنید">
                                                            </div>
                                                            <div class="col-md-12">
                                                                <p>کلید：
                                                                    <code id="ga-token">
                                                                        {$user->ga_token}
                                                                    </code>
                                                                </p>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                                <div class="card-footer">
                                                    <div class="d-flex">
                                                        <button id="reset-2fa" class="btn btn-link"
                                                                hx-post="/user/ga_reset" hx-swap="none" >
                                                                تنظیم مجدد
                                                        </button>
                                                        <button id="test-2fa" class="btn btn-link"
                                                                hx-post="/user/ga_check" hx-swap="none"
                                                                hx-vals='js:{ code: document.getElementById("ga-test-code").value }'>
                                                                تست
                                                        </button>
                                                        <button id="save-2fa" class="btn btn-primary ms-auto"
                                                                hx-post="/user/ga_set" hx-swap="none"
                                                                hx-vals='js:{ enable: document.getElementById("ga-enable").value }'>
                                                            ذخیره
                                                        </button>
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
                                                            <input id="repeat-new-password" type="password"
                                                                   class="form-control" placeholder="رمز جدید را دوباره وارد کنید"
                                                                   autocomplete="off">
                                                        </form>
                                                    </div>
                                                </div>
                                                <div class="card-footer">
                                                    <div class="d-flex">
                                                        <button id="modify-login-passwd" class="btn btn-primary ms-auto"
                                                                hx-post="/user/password" hx-swap="none"
                                                                hx-vals='js:{
                                                                    pwd: document.getElementById("new-password").value,
                                                                    repwd: document.getElementById("repeat-new-password").value,
                                                                    oldpwd: document.getElementById("password").value
                                                                }'>
                                                            ویرایش
                                                        </button>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="tab-pane" id="use_safety" role="tabpanel">
                                    <div class="row row-deck row-cards">
                                        <div class="col-sm-12 col-md-6">
                                            <div class="card">
                                                <div class="card-body">
                                                    <h3 class="card-title">تغییر روش رمزگذاری</h3>
                                                    <p>
                                                    کلاینت های مختلف ممکن است از روش های رمزگذاری متفاوتی پشتیبانی کنند. لطفاً برای تنظیمات به لیست پشتیبانی کلاینت مراجعه کنید.</p>
                                                    <div class="mb-3">
                                                        <select id="user-method" class="form-select">
                                                            {foreach $methods as $method}
                                                                <option value="{$method}"
                                                                        {if $user->method === $method}selected{/if}>
                                                                    {$method}
                                                                </option>
                                                            {/foreach}
                                                        </select>
                                                    </div>
                                                </div>
                                                <div class="card-footer">
                                                    <div class="d-flex">
                                                        <button id="modify-user-method" class="btn btn-primary ms-auto"
                                                                hx-post="/user/method" hx-swap="none"
                                                                hx-vals='js:{ method: document.getElementById("user-method").value }'>
                                                            ویرایش
                                                        </button>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="col-sm-12 col-md-6">
                                            <div class="card">
                                                <div class="card-body">
                                                    <h3 class="card-title">تغییر آدرس اشتراک</h3>
                                                    <p>پس از تغییر آدرس اشتراک، آدرس اشتراک قدیمی قادر به دریافت پیکربندی نخواهد بود، اما همچنان می توان از پیکربندی سرور استفاده کرد.
                                                     اگر می‌خواهید پیکربندی سرور قدیمی غیرقابل استفاده باشد، لطفاً رمز عبور را تغییر دهید.</p>
                                                </div>
                                                <div class="card-footer">
                                                    <div class="d-flex">
                                                        <button id="reset-sub-url" class="btn btn-primary ms-auto bg-red"
                                                                hx-post="/user/url_reset" hx-swap="none">
                                                                تنظیم مجدد
                                                        </button>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="col-sm-12 col-md-6">
                                            <div class="card">
                                                <div class="card-body">
                                                    <h3 class="card-title">بازنشانی رمز عبور اتصال</h3>
                                                    <p>رمز عبور اتصال و UUID را بازنشانی کنید. پس از بازنشانی، برای ادامه استفاده باید اشتراک را به‌روزرسانی کنید</p>
                                                    <p>رمز عبور اتصال فعلی：<code id="passwd">{$user->passwd}</code></p>
                                                    <p>UUID فعلی：<code id="uuid">{$user->uuid}</code></p>
                                                </div>
                                                <div class="card-footer">
                                                    <div class="d-flex">
                                                        <button id="reset-passwd" class="btn btn-primary ms-auto bg-red"
                                                                hx-post="/user/passwd_reset" hx-swap="none">
                                                                تنظیم مجدد
                                                        </button>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                 <div class="tab-pane" id="other_settings" role="tabpanel">
                                    <div class="row row-deck row-cards">
                                        <div class="col-sm-12 col-md-6">
                                            <div class="card">
                                                <div class="card-body">
                                                    <h3 class="card-title">گزارش مصرف روزانه</h3>
                                                    <div class="mb-3">
                                                        <select id="daily-mail" class="form-select">
                                                            <option value="0"
                                                                    {if $user->daily_mail_enable === 0}selected{/if}>
                                                                ارسال نشود
                                                            </option>
                                                            <option value="1"
                                                                    {if $user->daily_mail_enable === 1}selected{/if}>
                                                                ارسال به ایمیل
                                                            </option>
                                                            <option value="2"
                                                                    {if $user->daily_mail_enable === 2}selected{/if}>
                                                                دریافت IM
                                                            </option>
                                                        </select>
                                                    </div>
                                                </div>
                                                <div class="card-footer">
                                                    <div class="d-flex">
                                                        <button id="modify-daily-mail" class="btn btn-primary ms-auto"
                                                                hx-post="/user/daily_mail" hx-swap="none"
                                                                hx-vals='js:{ mail: document.getElementById("daily-mail").value }'>
                                                            ویرایش
                                                        </button>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="col-sm-12 col-md-6">
                                            <div class="card">
                                                <div class="card-body">
                                                    <h3 class="card-title">روش تماس ترجیحی</h3>
                                                    <p>وقتی IM محدود نشده باشد، سایت همچنان اطلاعات اعلان را به صندوق پستی حساب ارسال می کند</p>
                                                    <div class="mb-3">
                                                        <select id="contact-method" class="form-select">
                                                            <option value="1"
                                                                    {if $user->contact_method === 1}selected{/if}>
                                                                پست الکترونیکی
                                                            </option>
                                                            <option value="2"
                                                                    {if $user->contact_method === 2}selected{/if}>
                                                                IM
                                                            </option>
                                                        </select>
                                                    </div>
                                                </div>
                                                <div class="card-footer">
                                                    <div class="d-flex">
                                                        <button id="modify-contact-method" class="btn btn-primary ms-auto"
                                                                hx-post="/user/contact_method" hx-swap="none"
                                                                hx-vals='js:{ contact: document.getElementById("contact-method").value }'>
                                                            ویرایش
                                                        </button>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="col-sm-12 col-md-6">
                                            <div class="card">
                                                <div class="card-body">
                                                    <h3 class="card-title">پوسته سایت را تغییر دهید</h3>
                                                    <div class="mb-3">
                                                        <select id="user-theme" class="form-select">
                                                            {foreach $themes as $theme}
                                                                <option value="{$theme}"
                                                                        {if $user->theme === $theme}selected{/if}>{$theme}
                                                                </option>
                                                            {/foreach}
                                                        </select>
                                                    </div>
                                                </div>
                                                <div class="card-footer">
                                                    <div class="d-flex">
                                                        <button id="modify-user-theme" class="btn btn-primary ms-auto"
                                                                hx-post="/user/theme" hx-swap="none"
                                                                hx-vals='js:{ theme: document.getElementById("user-theme").value }'>
                                                            ویرایش
                                                        </button>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        {if $config['enable_kill']}
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
                                                        <button class="btn btn-red" data-bs-toggle="modal"
                                                           data-bs-target="#destroy-account">
                                                            <i class="ti ti-trash icon"></i>
                                                            تایید حذف
                                                        </button>
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

    {if $config['enable_kill']}
        <div class="modal modal-blur fade" id="destroy-account" tabindex="-1" role="dialog" aria-hidden="true">
            <div class="modal-dialog modal-sm modal-dialog-centered" role="document">
                <div class="modal-content">
                    <button class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    <div class="modal-status bg-danger"></div>
                    <div class="modal-body text-center py-4">
                        <i class="ti ti-alert-circle icon mb-2 text-danger icon-lg" style="font-size:3.5rem;"></i>
                        <h3>حذف تاییدیه</h3>
                        <div class="text-secondary">
                        لطفاً تأیید کنید که آیا واقعاً می خواهید حساب خود را حذف کنید یا خیر. این عملیات قابل بازگشت نیست و تمام داده های حساب شما به طور کامل از سرور حذف می شود.
                        </div>
                        <div class="py-3">
                            <form>
                                <input id="confirm-passwd" type="password" class="form-control"
                                       placeholder="رمز ورود را وارد کنید" autocomplete="off">
                            </form>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <div class="w-100">
                            <div class="row">
                                <div class="col">
                                    <button class="btn w-100" data-bs-dismiss="modal">
                                    لغو
                                    </button>
                                </div>
                                <div class="col">
                                    <button href="#" id="confirm-kill" class="btn btn-danger w-100" data-bs-dismiss="modal"
                                            hx-post="/user/kill" hx-swap="none"
                                            hx-vals='js:{ passwd: document.getElementById("confirm-passwd").value }'>
                                            تایید
                                    </button>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    {/if}

    <script>
        let qrcode = new QRCode('qrcode', {
            text: "{$ga_url}",
            width: 128,
            height: 128,
            colorDark: '#000000',
            colorLight: '#ffffff',
            correctLevel: QRCode.CorrectLevel.H
        });

        {if $user->im_type === 0 && $user->im_value === ''}
        let oauthProvider = $('#oauth-provider');

        $("#imtype").on('change', function () {
            if ($(this).val() === '0') {
                oauthProvider.empty();
            } else if ($(this).val() === '1') {
                oauthProvider.empty();
                oauthProvider.append(
                    "<a id='bind-slack' class='btn btn-azure ms-auto'>برای اتصال Slack</a>"
                );
            } else if ($(this).val() === '2') {
                oauthProvider.empty();
                oauthProvider.append(
                    "<a id='bind-discord' class='btn btn-indigo ms-auto'>برای اتصال Discord</a>"
                );
            } else if ($(this).val() === '4') {
                oauthProvider.empty();
                oauthProvider.append(
                    '<script async src=\"https://telegram.org/js/telegram-widget.js?22\"' +
                    ' data-telegram-login=\"' + "{$public_setting['telegram_bot']}" +
                    '\" data-size=\"large" data-onauth=\"onTelegramAuth(user)\"' +
                    ' data-request-access=\"write\"><\/script>'
                );
            }
        });

        oauthProvider.on('click', '#bind-slack', function () {
            $.ajax({
                type: "POST",
                url: "/oauth/slack",
                dataType: "json",
                success: function (data) {
                    handleOauthResult(data, 'slack')
                }
            })
        });

        oauthProvider.on('click', '#bind-discord', function () {
            $.ajax({
                type: "POST",
                url: "/oauth/discord",
                dataType: "json",
                success: function (data) {
                    handleOauthResult(data, 'discord')
                }
            })
        });

        function onTelegramAuth(user) {
            $.ajax({
                type: "POST",
                url: "/oauth/telegram",
                dataType: "json",
                data: {
                    user: JSON.stringify(user),
                },
                success: function (data) {
                    handleOauthResult(data, 'telegram')
                }
            })
        }

        function handleOauthResult(data, type = 'telegram') {
            if (data.ret === 1) {
                if (type === 'telegram') {
                    $('#success-message').text(data.msg);
                    $('#success-dialog').modal('show');
                } else {
                    window.location.replace(data.redir);
                }
            } else {
                $('#error-message').text(data.msg);
                $('#fail-dialog').modal('show');
            }
        }
        {/if}
    </script>

    {include file='user/footer.tpl'}
