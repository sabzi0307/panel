{include file='user/tabler_header.tpl'}

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
                                                <i class="ti ti-star icon"></i>
                                            </span>
                                        </div>
                                        <div class="col">
                                            <div class="font-weight-medium">
                                                سطح حساب
                                            </div>
                                            <div class="text-muted">
                                                LV. {$user->class}
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
                                            <div class="text-muted">
                                                {$user->money}
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
                                            <span class="bg-twitter text-white avatar">
                                                <i class="ti ti-devices-pc icon"></i>
                                            </span>
                                        </div>
                                        <div class="col">
                                            <div class="font-weight-medium">
                                                محدودیت IP اتصال همزمان
                                            </div>
                                            <div class="text-muted">
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
                                            <div class="text-muted">
                                                {if $user->node_speedlimit !== 0.0}
                                                    {$user->node_speedlimit}</code> Mbps
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
                <div class="col-lg-6">
                    <div class="row row-cards">
                        <div class="col-12">
                            <div class="card">
                                <ul class="nav nav-tabs nav-fill" data-bs-toggle="tabs">
                                    <li class="nav-item">
                                        <a href="#sub" class="nav-link active" data-bs-toggle="tab">
                                            <i class="ti ti-rss icon"></i>
                                            &nbsp;Universal Subscription
                                        </a>
                                    </li>
                                    <li class="nav-item">
                                        <a href="#traditional-sub" class="nav-link" data-bs-toggle="tab">
                                            <i class="ti ti-rss icon"></i>
                                            &nbsp;traditional subscription
                                        </a>
                                    </li>
                                    <li class="nav-item">
                                        <a href="#windows" class="nav-link" data-bs-toggle="tab">
                                            <i class="ti ti-brand-windows icon"></i>
                                            &nbsp;Windows
                                        </a>
                                    </li>
                                    <li class="nav-item">
                                        <a href="#macos" class="nav-link" data-bs-toggle="tab">
                                            <i class="ti ti-brand-finder icon"></i>
                                            &nbsp;Macos
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
                                            &nbsp;IOS
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
                                                    Universal Subscription（json）：<code>{$getUniversalSub}/json</code>
                                                </p>
                                                <p>
                                                    Universal Subscription（clash）：<code>{$getUniversalSub}/clash</code>
                                                </p>
                                                <div class="btn-list justify-content-start">
                                                    <a data-clipboard-text="{$getUniversalSub}/json"
                                                        class="copy btn btn-primary">
                                                        Copy Universal Subscription（json）
                                                    </a>
                                                    <a data-clipboard-text="{$getUniversalSub}/clash"
                                                        class="copy btn btn-primary">
                                                        Copy Universal Subscription（clash）
                                                    </a>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="tab-pane show" id="traditional-sub">
                                            <div>
                                                <p>
                                                    اشتراک سنتی（Shadowsocks）：<code>{$getTraditionalSub}?ss=1</code>
                                                </p>
                                                <p>
                                                    اشتراک سنتی（Shadowsocks SIP002）：<code>{$getTraditionalSub}?sip002=1</code>
                                                </p>
                                                <p>
                                                    اشتراک سنتی（V2Ray）：<code>{$getTraditionalSub}?v2ray=1</code>
                                                </p>
                                                <p>
                                                    اشتراک سنتی（Trojan）：<code>{$getTraditionalSub}?trojan=1</code>
                                                </p>
                                                <div class="btn-list justify-content-start">
                                                    <a data-clipboard-text="{$getTraditionalSub}?ss=1"
                                                        class="copy btn btn-primary">
                                                        کپی اشتراک سنتی（Shadowsocks）
                                                    </a>
                                                    <a data-clipboard-text="{$getTraditionalSub}?sip002=1"
                                                        class="copy btn btn-primary">
                                                        کپی اشتراک سنتی（Shadowsocks SIP002）
                                                    </a>
                                                    <a data-clipboard-text="{$getTraditionalSub}?v2ray=1"
                                                        class="copy btn btn-primary">
                                                        کپی اشتراک سنتی（V2Ray）
                                                    </a>
                                                    <a data-clipboard-text="{$getTraditionalSub}?trojan=1"
                                                        class="copy btn btn-primary">
                                                        کپی اشتراک سنتی（Trojan）
                                                    </a>
                                                    <a href="/clients/v2rayN-Core.zip"
                                                        class="btn btn-primary">
                                                        Download v2rayN（Windows）
                                                    </a>
                                                    <a href="/clients/v2rayNG.apk"
                                                        class="btn btn-primary">
                                                        Download v2rayNG（Android）
                                                    </a>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="tab-pane" id="windows">
                                            <div>
                                                <p>
                                                    اشتراک برای کلش：<code>{$getUniversalSub}/clash</code>
                                                </p>
                                                <div class="btn-list justify-content-start">
                                                    <a data-clipboard-text="{$getUniversalSub}/clash"
                                                        class="copy btn btn-primary">
                                                        Copy  Clash
                                                    </a>
                                                    <a href="/clients/Clash-Windows.exe"
                                                        class="btn btn-primary">
                                                        Download Clash for Windows
                                                    </a>
                                                    <a href="clash://install-config?url={$getUniversalSub}/clash&name={$config['appName']}"
                                                        class="btn btn-primary">
                                                        وارد کردن به کلش
                                                    </a>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="tab-pane" id="macos">
                                            <p>
                                                اشتراک برای کلش：<code>{$getUniversalSub}/clash</code>
                                            </p>
                                            <div class="btn-list justify-content-start">
                                                <a data-clipboard-text="{$getUniversalSub}/clash"
                                                    class="copy btn btn-primary">
                                                    Copy  Clash
                                                </a>
                                                <a href="/clients/Clash-Windows.dmg"
                                                    class="btn btn-primary">
                                                    Download Clash for Windows
                                                </a>
                                                <a href="clash://install-config?url={$getUniversalSub}/clash&name={$config['appName']}"
                                                    class="btn btn-primary">
                                                    وارد کردن به کلش
                                                </a>
                                            </div>
                                        </div>
                                        <div class="tab-pane" id="android">
                                            <p>
                                                اشتراک برای کلش：<code>{$getUniversalSub}/clash</code>
                                            </p>
                                            <div class="btn-list justify-content-start">
                                                <a data-clipboard-text="{$getUniversalSub}/clash"
                                                    class="copy btn btn-primary">
                                                    Copy  Clash
                                                </a>
                                                <a href="/clients/Clash-Android.apk"
                                                    class="btn btn-primary">
                                                    Download Clash for Android
                                                </a>
                                                <a href="clash://install-config?url={$getUniversalSub}/clash&name={$config['appName']}"
                                                    class="btn btn-primary">
                                                    وارد کردن به کلش
                                                </a>
                                            </div>
                                        </div>
                                        <div class="tab-pane" id="ios">
                                            <p>
                                                اشتراک برای نرم افزارهای سازگار با کلش：<code>{$getUniversalSub}/clash</code>
                                            </p>
                                            <p>
                                                پس از خرید و نصب کلاینت سازگار با کلش، روی دکمه کپی کلش کلیک کنید، سپس کلاینت سازگار با کلش را برای وارد کردن باز کنید.。
                                            </p>
                                            <div class="btn-list justify-content-start">
                                                <a data-clipboard-text="{$getUniversalSub}/clash"
                                                    class="copy btn btn-primary">
                                                    کپی کلش
                                                </a>
                                            </div>
                                        </div>
                                        <div class="tab-pane" id="linux">
                                            <p>
                                                اشتراک برای کلش：<code>{$getUniversalSub}/clash</code>
                                            </p>
                                            <div class="btn-list justify-content-start">
                                                <a data-clipboard-text="{$getUniversalSub}/clash"
                                                    class="copy btn btn-primary">
                                                    Copy  Clash
                                                </a>
                                                <a href="/clients/Clash-Windows.tar.gz"
                                                    class="btn btn-primary">
                                                    Download Clash for Windows
                                                </a>
                                                <a href="clash://install-config?url={$getUniversalSub}/clash&name={$config['appName']}"
                                                    class="btn btn-primary">
                                                    وارد کردن به کلش
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
                                        style="width: {$user->TodayusedTrafficPercent()}%"></div>
                                {/if}
                            </div>
                            <div class="row">
                                <div class="col-auto d-flex align-items-center pe-2">
                                    <span class="legend me-2 bg-primary"></span>
                                    <span>میزان مصرف گذشته {$user->LastusedTraffic()}</span>
                                </div>
                                <div class="col-auto d-flex align-items-center px-2">
                                    <span class="legend me-2 bg-success"></span>
                                    <span>میزان مصرفی امروز {$user->TodayusedTraffic()}</span>
                                </div>
                                <div class="col-auto d-flex align-items-center ps-2">
                                    <span class="legend me-2"></span>
                                    <span>ترافیک باقی ماده {$user->unusedTraffic()}</span>
                                </div>
                            </div>
                            <p class="my-3">
                                {if time() > strtotime($user->class_expire)}
                                    بسته شما منقضی شده است، لطفا جهت خرید بسته به  
                                    <a href="/user/shop">فروشگاه</a>
                                    مراجعه نمایید.
                                {else}
                                    {$diff = round((strtotime($user->class_expire) - time()) / 86400)}
                                    من LV. {$user->class} وجود دارد در مورد {$diff} روزهای یاقی مانده（{$user->class_expire}）
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
                            <h3 class="card-title">آخرین اطلاعیه 
                            {if $ann !== null}
                            <span class="card-subtitle">{$ann->date}</span>
                            {/if}
                            </h3>
                            <p class="text-muted">
                            {if $ann !== null}
                                {$ann->content}
                            {else}
                                هنوز اطلاعیه ای وجود ندارد
                            {/if}
                            </p>
                        </div>
                    </div>
                </div>
                {if $config['enable_checkin'] == true}
                    <div class="col-lg-6 col-sm-12">
                        <div class="card">
                            <div class="card-stamp">
                                <div class="card-stamp-icon bg-green">
                                    <i class="ti ti-check"></i>
                                </div>
                            </div>
                            <div class="card-body">
                                <h3 class="card-title">ترافیک هدیه ورود روزانه</h3>
                                <p class="text-muted">
                                    جهت دریافت حجم هدیه بین 
                                    {if $config['checkinMin'] !== $config['checkinMax']}
                                        &nbsp;<code>{$config['checkinMin']} MB</code> تا <code>{$config['checkinMax']} MB</code>
                                        دکمه بررسی را بفشارید.
                                    {else}
                                        <code>{$config['checkinMin']} MB</code>
                                    {/if}
                                </p>
                                <p class="text-muted">
                                    آخرین زمان استفاده：
                                    <code style="font-family: Yekan;">{$user->lastCheckInTime()}</code>
                                </p>
                            </div>
                            <div class="card-footer">
                                <div class="d-flex">
                                    {if !$user->isAbleToCheckin()}
                                    <button id="check-in" class="btn btn-primary ms-auto" disabled>وارد شدن</button>
                                    {else}
                                    {if $public_setting['enable_checkin_captcha'] === true && $public_setting['captcha_provider'] === 'turnstile'}
                                    <div class="cf-turnstile" data-sitekey="{$captcha['turnstile_sitekey']}" data-theme="light"></div>
                                    {/if}
                                    {if $public_setting['enable_checkin_captcha'] === true && $public_setting['captcha_provider'] === 'geetest'}
                                    <div id="geetest"></div>
                                    {/if} 
                                    <button id="check-in" class="btn btn-primary ms-auto">بررسی</button>
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
            $('#success-message').text('已Copy 到剪切板');
            $('#success-dialog').modal('show');
        });

        $("#check-in").click(function() {
            $.ajax({
                type: "POST",
                url: "/user/checkin",
                dataType: "json",              
                data: {
                    {if $public_setting['enable_checkin_captcha'] === true && $public_setting['captcha_provider'] === 'turnstile'}
                    turnstile: turnstile.getResponse(),
                    {/if}
                    {if $public_setting['enable_checkin_captcha'] === true && $public_setting['captcha_provider'] === 'geetest'}
                    geetest: geetest_result,
                    {/if}
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

    {if $public_setting['enable_checkin_captcha'] === true && $public_setting['captcha_provider'] === 'turnstile'}
    <script src="https://challenges.cloudflare.com/turnstile/v0/api.js?compat=recaptcha" async defer></script>
    {/if}
    {if $public_setting['enable_checkin_captcha'] === true && $public_setting['captcha_provider'] === 'geetest'}
    <script src="http://static.geetest.com/v4/gt4.js"></script>
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
{include file='user/tabler_footer.tpl'}
