{include file='user/header.tpl'}

<div class="page-wrapper">
    <div class="container-xl">
        <div class="page-header d-print-none text-white">
            <div class="row align-items-center">
                <div class="col">
                    <h2 class="page-title">
                        <span class="home-title">پنل کاربر</span>
                    </h2>
                    <div class="page-pretitle my-3">
                        <span class="home-subtitle">اطلاعات حساب و آخرین اطلاعیه ها را اینجا ببینید</span>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div class="page-body">
        <div class="container-xl">
            <div class="row row-deck row-cards">
                <div class="col-12">
                    <div class="row row-cards">
                        <div class="col-sm-6 col-lg-3">
                            <div class="card card-sm">
                                <div class="card-body">
                                    <div class="row align-items-center">
                                        <div class="col-auto">
                                            <span class="bg-blue text-white avatar">
                                                <i class="ti ti-vip icon"></i>
                                            </span>
                                        </div>
                                        <div class="col">
                                            <div class="font-weight-medium">
                                                سطح حساب
                                            </div>
                                            <div class="text-secondary">
                                                {if $user->class === 0}
                                                    رایگان
                                                {else}
                                                    Lv. {$user->class}
                                                {/if}
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="col-sm-6 col-lg-3">
                            <div class="card card-sm">
                                <div class="card-body">
                                    <div class="row align-items-center">
                                        <div class="col-auto">
                                            <span class="bg-green text-white avatar">
                                                <i class="ti ti-coin icon"></i>
                                            </span>
                                        </div>
                                        <div class="col">
                                            <div class="font-weight-medium">
                                                موجودی حساب
                                            </div>
                                            <div class="text-secondary">
                                                {$user->money}
                                            </div>
                                        </div>
                                        <div class="col-auto">
                                            <a href="/user/money" class="btn btn-primary btn-icon">
                                                <i class="ti ti-plus icon"></i>
                                            </a>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="col-sm-6 col-lg-3">
                            <div class="card card-sm">
                                <div class="card-body">
                                    <div class="row align-items-center">
                                        <div class="col-auto">
                                            <span class="bg-twitter text-white avatar">
                                                <i class="ti ti-devices-pc icon"></i>
                                            </span>
                                        </div>
                                        <div class="col">
                                            <div class="font-weight-medium">
                                                محدودیت اتصال همزمان IP
                                            </div>
                                            <div class="text-secondary">
                                                {if $user->node_iplimit !== 0}
                                                    {$user->node_iplimit}
                                                {else}
                                                    بدون محدودیت
                                                {/if}
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="col-sm-6 col-lg-3">
                            <div class="card card-sm">
                                <div class="card-body">
                                    <div class="row align-items-center">
                                        <div class="col-auto">
                                            <span class="bg-facebook text-white avatar">
                                                <i class="ti ti-rocket icon"></i>
                                            </span>
                                        </div>
                                        <div class="col">
                                            <div class="font-weight-medium">
                                                محدودیت سرعت
                                            </div>
                                            <div class="text-secondary">
                                                {if $user->node_speedlimit !== 0.0}
                                                    <code>{$user->node_speedlimit}</code> Mbps
                                                {else}
                                                    بدون محدودیت
                                                {/if}
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-lg-6 col-sm-12">
                    <div class="card">
                        <ul class="nav nav-tabs nav-fill" data-bs-toggle="tabs">
                            <li class="nav-item">
                                <a href="#sub" class="nav-link active" data-bs-toggle="tab">
                                    <i class="ti ti-rss icon"></i>
                                    &nbsp;اشتراک جهانی
                                </a>
                            </li>
                            {if $public_setting['enable_traditional_sub']}
                                <li class="nav-item">
                                    <a href="#traditional-sub" class="nav-link" data-bs-toggle="tab">
                                        <i class="ti ti-rss icon"></i>
                                        &nbsp;اشتراک سنتی
                                    </a>
                                </li>
                            {/if}
                            <li class="nav-item">
                                <a href="#windows" class="nav-link" data-bs-toggle="tab">
                                    <i class="ti ti-brand-windows icon"></i>
                                    &nbsp;Windows
                                </a>
                            </li>
                            <li class="nav-item">
                                <a href="#macos" class="nav-link" data-bs-toggle="tab">
                                    <i class="ti ti-brand-finder icon"></i>
                                    &nbsp;MacOS
                                </a>
                            </li>
                            <li class="nav-item">
                                <a href="#android" class="nav-link" data-bs-toggle="tab">
                                    <i class="ti ti-brand-android icon"></i>
                                    &nbsp;Android
                                </a>
                            </li>
                            <li class="nav-item">
                                <a href="#ios" class="nav-link" data-bs-toggle="tab">
                                    <i class="ti ti-brand-apple icon"></i>
                                    &nbsp;iOS
                                </a>
                            </li>
                            <li class="nav-item">
                                <a href="#linux" class="nav-link" data-bs-toggle="tab">
                                    <i class="ti ti-brand-redhat icon"></i>
                                    &nbsp;Linux
                                </a>
                            </li>
                            <li class="nav-item">
                                <a href="#config" class="nav-link" data-bs-toggle="tab">
                                    <i class="ti ti-file-text icon"></i>
                                    &nbsp;Config
                                </a>
                            </li>
                        </ul>
                        <div class="card-body">
                            <div class="tab-content">
                                <div class="tab-pane active show" id="sub">
                                    <div>
                                        <p>
                                            اشتراک جهانی（json）：<code>{$UniversalSub}/json</code>
                                        </p>
                                        <p>
                                            اشتراک جهانی（clash）：<code>{$UniversalSub}/clash</code>
                                        </p>
                                        {if $public_setting['enable_ss_sub']}
                                            <p>
                                                اشتراک جهانی（sip008）：<code>{$UniversalSub}/sip008</code>
                                            </p>
                                        {/if}
                                        <div class="btn-list justify-content-start">
                                            <a data-clipboard-text="{$UniversalSub}/json"
                                               class="copy btn btn-primary">
                                                کپی اشتراک جهانی（json）
                                            </a>
                                            <a data-clipboard-text="{$UniversalSub}/clash"
                                               class="copy btn btn-primary">
                                                کپی اشتراک جهانی（clash）
                                            </a>
                                            {if $public_setting['enable_ss_sub']}
                                                <a data-clipboard-text="{$UniversalSub}/sip008"
                                                   class="copy btn btn-primary">
                                                    کپی اشتراک جهانی（sip008）
                                                </a>
                                            {/if}
                                        </div>
                                    </div>
                                </div>
                                {if $public_setting['enable_traditional_sub']}
                                    <div class="tab-pane show" id="traditional-sub">
                                        <div>
                                            {if $public_setting['enable_ss_sub']}
                                            <p>
                                                اشتراک سنتی（Shadowsocks）：<code>{$TraditionalSub}?ss=1</code></p><p>
                                                اشتراک سنتی（Shadowsocks SIP002）：<code>{$TraditionalSub}?sip002=1</code>
                                            </p>
                                            {/if}
                                            {if $public_setting['enable_v2_sub']}<p>
                                                اشتراک سنتی（V2Ray）：<code>{$TraditionalSub}?v2ray=1</code></p>
                                            {/if}
                                            {if $public_setting['enable_trojan_sub']}<p>
                                                اشتراک سنتی（Trojan）：<code>{$TraditionalSub}?trojan=1</code></p>
                                            {/if}
                                            <div class="btn-list justify-content-start">
                                                {if $public_setting['enable_ss_sub']}
                                                <a data-clipboard-text="{$TraditionalSub}?ss=1"class="copy btn btn-primary">
                                                    کپی اشتراک سنتی（Shadowsocks）
                                                </a>
                                                <a data-clipboard-text="{$TraditionalSub}?sip002=1" class="copy btn btn-primary">
                                                    کپی اشتراک سنتی（Shadowsocks SIP002）
                                                </a>
                                                {/if}
                                                {if $public_setting['enable_v2_sub']}
                                                    <a data-clipboard-text="{$TraditionalSub}?v2ray=1"class="copy btn btn-primary">کپی اشتراک سنتی（V2Ray）</a>
                                                {/if}
                                                {if $public_setting['enable_trojan_sub']}
                                                    <a data-clipboard-text="{$TraditionalSub}?trojan=1"class="copy btn btn-primary">کپی اشتراک سنتی（Trojan）</a>
                                                {/if}
                                                <a {if $config['enable_r2_client_download']}
                                                        href="/user/clients/v2rayN-Core.zip"
                                                    {else}
                                                        href="/clients/v2rayN-Core.zip"
                                                    {/if}
                                                   class="btn btn-primary">
                                                    دانلود v2rayN（Windows）
                                                </a>
                                                <a {if $config['enable_r2_client_download']}
                                                        href="/user/clients/v2rayNG.apk"
                                                    {else}
                                                        href="/clients/v2rayNG.apk"
                                                    {/if}
                                                   class="btn btn-primary">
                                                    دانلود v2rayNG（Android）
                                                </a>
                                            </div>
                                        </div>
                                    </div>
                                {/if}
                                <div class="tab-pane" id="windows">
                                    <div>
                                        <p>
                                            اشتراک برای کلش：<code>{$UniversalSub}/clash</code>
                                        </p>
                                        <div class="btn-list justify-content-start">
                                            <a data-clipboard-text="{$UniversalSub}/clash"
                                               class="copy btn btn-primary">
                                                لینک اشتراک کلش را کپی کنید
                                            </a>
                                            <a
                                               {if $config['enable_r2_client_download']}
                                                    href="/user/clients/Clash.Verge.exe"
                                               {else}
                                                    href="/clients/Clash.Verge.exe"
                                               {/if}
                                               class="btn btn-primary">
                                                دانلود Clash Verge
                                            </a>
                                            <a href="clash://install-config?url={$UniversalSub}/clash&name={$config['appName']}"
                                               class="btn btn-primary">
                                                افزودن به Clash
                                            </a>
                                        </div>
                                    </div>
                                </div>
                                <div class="tab-pane" id="macos">
                                    <p>
                                        اشتراک برای کلش：<code>{$UniversalSub}/clash</code>
                                    </p>
                                    <div class="btn-list justify-content-start">
                                        <a data-clipboard-text="{$UniversalSub}/clash"
                                           class="copy btn btn-primary">
                                            لینک اشتراک کلش را کپی کنید
                                        </a>
                                        <a {if $config['enable_r2_client_download']}
                                                href="/user/clients/Clash.Verge_aarch64.dmg"
                                            {else}
                                                href="/clients/Clash.Verge_aarch64.dmg"
                                            {/if}
                                           class="btn btn-primary">
                                            دانلود Clash Verge (aarch64)
                                        </a>
                                        <a {if $config['enable_r2_client_download']}
                                                href="/user/clients/Clash.Verge_x64.dmg"
                                            {else}
                                                href="/clients/Clash.Verge_x64.dmg"
                                            {/if}
                                           class="btn btn-primary">
                                            دانلود Clash Verge (x86_64)
                                        </a>
                                        <a href="clash://install-config?url={$UniversalSub}/clash&name={$config['appName']}"
                                           class="btn btn-primary">
                                            افزودن به Clash
                                        </a>
                                    </div>
                                </div>
                                <div class="tab-pane" id="android">
                                    <p>
                                        اشتراک برای کلش：<code>{$UniversalSub}/clash</code>
                                    </p>
                                    <div class="btn-list justify-content-start">
                                        <a data-clipboard-text="{$UniversalSub}/clash"
                                           class="copy btn btn-primary">
                                            لینک اشتراک کلش را کپی کنید
                                        </a>
                                        <a {if $config['enable_r2_client_download']}
                                                href="/user/clients/Clash-Android.apk"
                                            {else}
                                                href="/clients/Clash-Android.apk"
                                            {/if}
                                           class="btn btn-primary">
                                            دانلود Clash for Android
                                        </a>
                                        <a href="clash://install-config?url={$UniversalSub}/clash&name={$config['appName']}"
                                           class="btn btn-primary">
                                            افزودن به Clash
                                        </a>
                                    </div>
                                </div>
                                <div class="tab-pane" id="ios">
                                    <p>
                                        اشتراک برای کلاینت های سازگار با کلش：<code>{$UniversalSub}/clash</code>
                                    </p>
                                    <p>
                                        پس از خرید و نصب یک کلاینت سازگار با Clash (مانند Stash)، روی دکمه <code>Copy Subscription Link</code> کلیک کنید و سپس کلاینت سازگار با Clash را باز کنید افزودن به。
                                    </p>
                                    <div class="btn-list justify-content-start">
                                        <a href="https://apps.apple.com/app/stash/id1596063349" target="_blank"
                                           class="btn btn-primary">
                                            购买 Stash
                                        </a>
                                        <a data-clipboard-text="{$UniversalSub}/clash"
                                           class="copy btn btn-primary">
                                            لینک اشتراک کلش را کپی کنید
                                        </a>
                                        <a href="stash://install-config?url={$UniversalSub}/clash&name={$config['appName']}"
                                           class="btn btn-primary">
                                            افزودن به Stash
                                        </a>
                                    </div>
                                </div>
                                <div class="tab-pane" id="linux">
                                    <p>
                                        اشتراک برای کلش：<code>{$UniversalSub}/clash</code>
                                    </p>
                                    <div class="btn-list justify-content-start">
                                        <a data-clipboard-text="{$UniversalSub}/clash"
                                           class="copy btn btn-primary">
                                            لینک اشتراک کلش را کپی کنید
                                        </a>
                                        <a {if $config['enable_r2_client_download']}
                                                href="/user/clients/Clash.Verge.AppImage.tar.gz"
                                            {else}
                                                href="/clients/Clash.Verge.AppImage.tar.gz"
                                            {/if}
                                           class="btn btn-primary">
                                            دانلود Clash Verge
                                        </a>
                                        <a href="clash://install-config?url={$UniversalSub}/clash&name={$config['appName']}"
                                           class="btn btn-primary">
                                            افزودن به Clash
                                        </a>
                                    </div>
                                </div>
                                <div class="tab-pane" id="config">
                                    <p>اطلاعات اتصال شما：</p>
                                    <div class="table-responsive">
                                        <table class="table table-vcenter card-table">
                                            <tbody>
                                            <tr>
                                                <td><strong>پورت</strong></td>
                                                <td>{$user->port}</td>
                                            </tr>
                                            <tr>
                                                <td><strong>رمز اتصال</strong></td>
                                                <td>{$user->passwd}</td>
                                            </tr>
                                            <tr>
                                                <td><strong>UUID</strong></td>
                                                <td>{$user->uuid}</td>
                                            </tr>
                                            <tr>
                                                <td><strong>رمزگذاری سفارشی</strong></td>
                                                <td>{$user->method}</td>
                                            </tr>
                                            </tbody>
                                        </table>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-lg-6 col-sm-12">
                    <div class="card">
                        <div class="card-body">
                            <h3 class="card-title">مصرف ترافیک</h3>
                            <div class="progress progress-separated mb-3">
                                {if $user->LastusedTrafficPercent() < '1'}
                                    <div class="progress-bar bg-primary" role="progressbar" style="width: 1%"></div>
                                {else}
                                    <div class="progress-bar bg-primary" role="progressbar"
                                        style="width: {$user->LastusedTrafficPercent()}%">
                                    </div>
                                {/if}
                                {if $user->TodayusedTrafficPercent() < '1'}
                                    <div class="progress-bar bg-success" role="progressbar" style="width: 1%"></div>
                                {else}
                                    <div class="progress-bar bg-success" role="progressbar"
                                        style="width: {$user->TodayusedTrafficPercent()}%">
                                    </div>
                                {/if}
                            </div>
                            <div class="row">
                                <div class="col-auto d-flex align-items-center pe-2">
                                    <span class="legend me-2 bg-primary"></span>
                                    <span>میزان مصرف گذشته {$user->LastusedTraffic()}</span>
                                </div>
                                <div class="col-auto d-flex align-items-center px-2">
                                    <span class="legend me-2 bg-success"></span>
                                    <span>میزان مصرفی امروز
                                        {$user->TodayusedTraffic()}</span>
                                </div>
                                <div class="col-auto d-flex align-items-center ps-2">
                                    <span class="legend me-2"></span>
                                    <span>ترافیک باقی مانده {$user->unusedTraffic()}</span>
                                </div>
                            </div>
                            <p class="my-3">
                                {if $user->class === 0}
                                    برای خرید بسته به <a href="/user/product">فروشگاه</a> بروید
                                {else}
                                    LV شما. حساب {$user->class} {$class_expire_days} روز دیگر منقضی می‌شود ({$user->class_expire})
                                {/if}
                            </p>
                        </div>
                    </div>
                </div>
                <div class="col-lg-6 col-sm-12">
                    <div class="card">
                        <div class="ribbon ribbon-top ribbon-start bg-yellow">
                            <i class="ti ti-bell-ringing icon"></i>
                        </div>
                        <div class="card-body">
                            <h3 class="card-title">
                                آخرین اطلاعیه
                                {if $ann !== null}
                                <span class="card-subtitle">{$ann->date}</span>
                                {/if}
                            </h3>
                            <p class="text-secondary">
                            {if $ann !== null}
                                {$ann->content}
                            {else}
                                هنوز اطلاعیه ای وجود ندارد
                            {/if}
                            </p>
                        </div>
                    </div>
                </div>
                {if $config['enable_checkin']}
                <div class="col-lg-6 col-sm-12">
                    <div class="card">
                        <div class="card-stamp">
                            <div class="card-stamp-icon bg-green">
                                <i class="ti ti-check"></i>
                            </div>
                        </div>
                        <div class="card-body">
                            <h3 class="card-title">ورود روزانه</h3>
                            <p>
                                برای دریافت وارد شوید
                                {if $config['checkinMin'] !== $config['checkinMax']}
                                    &nbsp;<code>{$config['checkinMin']} MB</code> 至 <code>{$config['checkinMax']} MB</code>
                                    ترافیک در محدوده
                                {else}
                                    <code>{$config['checkinMin']} MB</code>
                                {/if}
                            </p>
                            <p>
                                آخرین زمان استفاده：<code>{$user->lastCheckInTime()}</code>
                            </p>
                        </div>
                        <div class="card-footer">
                            <div class="d-flex">
                                {if ! $user->isAbleToCheckin()}
                                <button id="check-in" class="btn btn-primary ms-auto" disabled>signed in</button>
                                {else}
                                {if $public_setting['enable_checkin_captcha']}
                                    {if $public_setting['captcha_provider'] === 'turnstile'}
                                        <div id="cf-turnstile" class="cf-turnstile" data-sitekey="{$captcha['turnstile_sitekey']}"
                                        {if $user->is_dark_mode}
                                             data-theme="dark"
                                        {else}
                                             data-theme="light"
                                        {/if}
                                        ></div>
                                    {/if}
                                    {if $public_setting['captcha_provider'] === 'geetest'}
                                        <div id="geetest"></div>
                                    {/if}
                                {/if}
                                <button id="check-in" class="btn btn-primary ms-auto">to sign in</button>
                                {/if}
                            </div>
                        </div>
                    </div>
                </div>
                {/if}
            </div>
        </div>
    </div>

    <script>
        var clipboard = new ClipboardJS('.copy');
        clipboard.on('success', function(e) {
            $('#success-noreload-message').text('در کلیپ بورد کپی شد');
            $('#success-noreload-dialog').modal('show');
        });

        $("#check-in").click(function() {
            $.ajax({
                type: "POST",
                url: "/user/checkin",
                dataType: "json",
                data: {
                    {if $public_setting['enable_checkin_captcha'] && $user->isAbleToCheckin()}
                        {if $public_setting['captcha_provider'] === 'turnstile'}
                            turnstile: $('input[name=cf-turnstile-response]').val(),
                        {/if}
                        {if $public_setting['captcha_provider'] === 'geetest'}
                            geetest: geetest_result,
                        {/if}
                    {/if}
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

    {if $public_setting['enable_checkin_captcha'] && $user->isAbleToCheckin()}
        {if $public_setting['captcha_provider'] === 'turnstile'}
            <script src="https://challenges.cloudflare.com/turnstile/v0/api.js" async defer></script>
        {/if}
        {if $public_setting['captcha_provider'] === 'geetest'}
            <script src="https://static.geetest.com/v4/gt4.js"></script>
            <script>
                var geetest_result = '';
                initGeetest4({
                    captchaId: '{$captcha['geetest_id']}',
                    product: 'float',
                    language: "zho",
                    riskType:'slide'
                }, function (geetest) {
                    geetest.appendTo("#geetest");
                    geetest.onSuccess(function() {
                        geetest_result = geetest.getValidate();
                    });
                });
            </script>
        {/if}
    {/if}
{include file='user/footer.tpl'}
