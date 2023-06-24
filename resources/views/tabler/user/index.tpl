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
                                                محدودیت IP اتصال همزمان
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
                                {if $os eq "Droid"}<a href="#android" class="nav-link active" data-bs-toggle="tab">{else}<a href="#android" class="nav-link" data-bs-toggle="tab">{/if}
                                    <i class="ti ti-brand-android icon"></i>
                                    &nbsp;اندروید
                                </a>
                            </li>
                            <li class="nav-item">
                                {if $os eq "iPhone" or $os eq "iPad"}<a href="#ios" class="nav-link active" data-bs-toggle="tab">{else}<a href="#ios" class="nav-link" data-bs-toggle="tab">{/if}
                                    <i class="ti ti-brand-apple icon"></i>
                                    &nbsp;آی او اس
                                </a>
                            </li>
                            <li class="nav-item">
                                {if $os eq "Windows"}<a href="#windows" class="nav-link active" data-bs-toggle="tab">{else}<a href="#windows" class="nav-link" data-bs-toggle="tab">{/if}
                                    <i class="ti ti-brand-windows icon"></i>
                                    &nbsp;ویندوز
                                </a>
                            </li>
                            <li class="nav-item">
                                {if $os eq "Mac"}<a href="#macos" class="nav-link active" data-bs-toggle="tab">{else}<a href="#macos" class="nav-link" data-bs-toggle="tab">{/if}
                                    <i class="ti ti-brand-finder icon"></i>
                                    &nbsp;مک
                                </a>
                            </li>
                            <li class="nav-item">
                                {if $os eq "Linux"}<a href="#linux" class="nav-link active" data-bs-toggle="tab">{else}<a href="#linux" class="nav-link" data-bs-toggle="tab">{/if}
                                    <i class="ti ti-brand-redhat icon"></i>
                                    &nbsp;لینوکس
                                </a>
                            </li>
                            <li class="nav-item">
                                {if $os eq "Unknown"}<a href="#sub" class="nav-link active" data-bs-toggle="tab">{else}<a href="#sub" class="nav-link" data-bs-toggle="tab">{/if}
                                    <i class="ti ti-rss icon"></i>
                                    &nbsp;تمامی کانفیگ ها
                                </a>
                            </li>
                            <li class="nav-item">
                                {if $os eq "Unix"}<a href="#config" class="nav-link active" data-bs-toggle="tab">{else}<a href="#config" class="nav-link" data-bs-toggle="tab">{/if}
                                    <i class="ti ti-file-text icon"></i>
                                    &nbsp;اطلاعات اتصال
                                </a>
                            </li>
                        </ul>
                        <div class="card-body">
                            <div class="tab-content">
                                {if $os eq "Unknown"}<div class="tab-pane active show" id="sub">{else}<div class="tab-pane" id="sub">{/if}
                                    <div class="page-body">
                                        <div class="container-xl">
                                            <div class="card">
                                                <div class="card-body">
                                                    <div class="accordion" id="config-accordion">
                                                        <div class="accordion-item">
                                                            <h2 class="accordion-header" id="heading-1">
                                                                <button class="accordion-button " type="button"
                                                                    data-bs-toggle="collapse"
                                                                    data-bs-target="#collapse-1" aria-expanded="true">
                                                                    CLASH (هوشمند)
                                                                </button>
                                                            </h2>
                                                            <div id="collapse-1"
                                                                class="accordion-collapse collapse show"
                                                                data-bs-parent="#config-accordion">
                                                                <div class="accordion-body pt-0">
                                                                    <strong>لینک اشتراک هوشمند شما برای تمامی کلاینت های
                                                                        سازگار با کلش متا:</strong>

                                                                    <p>
                                                                        <br>
                                                                        <code>{$UniversalSub}/clash</code>
                                                                    </p>
                                                                    <a data-clipboard-text="{$UniversalSub}/clash"
                                                                        class="copy btn btn-primary">
                                                                        کپی لینک اشتراک
                                                                    </a>
                                                                </div>
                                                            </div>
                                                        </div>
                                                        <div class="accordion-item">
                                                            <h2 class="accordion-header" id="heading-2">
                                                                <button class="accordion-button collapsed" type="button"
                                                                    data-bs-toggle="collapse"
                                                                    data-bs-target="#collapse-2" aria-expanded="false">
                                                                    JSON (هوشمند)
                                                                </button>
                                                            </h2>
                                                            <div id="collapse-2" class="accordion-collapse collapse"
                                                                data-bs-parent="#config-accordion">
                                                                <div class="accordion-body pt-0">
                                                                    <strong>لینک اشتراک هوشمند شما برای تمامی کلاینت های
                                                                        سازگار با JSON: </strong>
                                                                    <p>
                                                                        <br>
                                                                        <code>{$UniversalSub}/json</code>
                                                                    </p>
                                                                    <a data-clipboard-text="{$UniversalSub}/json"
                                                                        class="copy btn btn-primary">
                                                                        کپی لینک اشتراک
                                                                    </a>
                                                                </div>
                                                            </div>
                                                        </div>
                                                        {if $public_setting['enable_ss_sub']}
                                                            <div class="accordion-item">
                                                                <h2 class="accordion-header" id="heading-3">
                                                                    <button class="accordion-button collapsed" type="button"
                                                                        data-bs-toggle="collapse"
                                                                        data-bs-target="#collapse-3" aria-expanded="false">
                                                                        SIP008 (هوشمند)
                                                                    </button>
                                                                </h2>
                                                                <div id="collapse-3" class="accordion-collapse collapse"
                                                                    data-bs-parent="#config-accordion">
                                                                    <div class="accordion-body pt-0">
                                                                        <strong>لینک اشتراک هوشمند شما برای تمامی کلاینت های
                                                                            سازگار با SIP008:</strong>
                                                                        <p>
                                                                            <br>
                                                                            <code>{$UniversalSub}/sip008</code>
                                                                        </p>

                                                                        <a data-clipboard-text="{$UniversalSub}/sip008"
                                                                            class="copy btn btn-primary">
                                                                            کپی لینک اشتراک
                                                                        </a>


                                                                    </div>
                                                                </div>
                                                            </div>
                                                        {/if}
                                                        {if $public_setting['enable_traditional_sub']}
                                                            {if $public_setting['enable_v2_sub']}<p>
                                                                <div class="accordion-item">
                                                                    <h2 class="accordion-header" id="heading-4">
                                                                        <button class="accordion-button collapsed" type="button"
                                                                            data-bs-toggle="collapse"
                                                                            data-bs-target="#collapse-4" aria-expanded="false">
                                                                            V2Ray (سنتی)
                                                                        </button>
                                                                    </h2>
                                                                    <div id="collapse-4" class="accordion-collapse collapse"
                                                                        data-bs-parent="#config-accordion">
                                                                        <div class="accordion-body pt-0">
                                                                            <strong>لینک اشتراک هوشمند شما برای تمامی کلاینت های
                                                                                سازگار با V2Ray: </strong>
                                                                            <p>
                                                                                <br>
                                                                                <code>{$TraditionalSub}?v2ray=1</code>
                                                                            </p>
                                                                            <a data-clipboard-text="{$TraditionalSub}?v2ray=1"
                                                                                class="copy btn btn-primary">
                                                                                کپی لینک اشتراک
                                                                            </a>
                                                                        </div>
                                                                    </div>
                                                                </div>
                                                            {/if}
                                                            {if $public_setting['enable_trojan_sub']}<p>
                                                                <div class="accordion-item">
                                                                    <h2 class="accordion-header" id="heading-5">
                                                                        <button class="accordion-button collapsed" type="button"
                                                                            data-bs-toggle="collapse"
                                                                            data-bs-target="#collapse-5" aria-expanded="false">
                                                                            Trojan (سنتی)
                                                                        </button>
                                                                    </h2>
                                                                    <div id="collapse-5" class="accordion-collapse collapse"
                                                                        data-bs-parent="#config-accordion">
                                                                        <div class="accordion-body pt-0">
                                                                            <strong>لینک اشتراک هوشمند شما برای تمامی کلاینت های
                                                                                سازگار با Trojan: </strong>
                                                                            <p>
                                                                                <br>
                                                                                <code>{$TraditionalSub}?trojan=1</code>
                                                                            </p>
                                                                            <a data-clipboard-text="{$TraditionalSub}?trojan=1"
                                                                                class="copy btn btn-primary">
                                                                                کپی لینک اشتراک
                                                                            </a>
                                                                        </div>
                                                                    </div>
                                                                </div>
                                                            {/if}
                                                            {if $public_setting['enable_ss_sub']}<p>
                                                                <div class="accordion-item">
                                                                    <h2 class="accordion-header" id="heading-6">
                                                                        <button class="accordion-button collapsed" type="button"
                                                                            data-bs-toggle="collapse"
                                                                            data-bs-target="#collapse-6" aria-expanded="false">
                                                                            Shadowsocks (سنتی)
                                                                        </button>
                                                                    </h2>
                                                                    <div id="collapse-6" class="accordion-collapse collapse"
                                                                        data-bs-parent="#config-accordion">
                                                                        <div class="accordion-body pt-0">
                                                                            <strong>لینک اشتراک هوشمند شما برای تمامی کلاینت های
                                                                                سازگار با Shadowsocks: </strong>
                                                                            <p>
                                                                                <br>
                                                                                <code>{$TraditionalSub}?ss=1</code>
                                                                            </p>
                                                                            <a data-clipboard-text="{$TraditionalSub}?ss=1"
                                                                                class="copy btn btn-primary">
                                                                                Shadowsocks کپی لینک اشتراک
                                                                            </a>
                                                                        </div>
                                                                        <div class="accordion-body pt-0">
                                                                            <strong>لینک اشتراک هوشمند شما برای تمامی کلاینت های
                                                                                سازگار با Shadowsocks SIP002: </strong>
                                                                            <p>
                                                                                <br>
                                                                                <code>{$TraditionalSub}?sip002=1</code>
                                                                            </p>
                                                                            <a data-clipboard-text="{$TraditionalSub}?sip002=1"
                                                                                class="copy btn btn-primary">
                                                                                Shadowsocks SIP002 کپی لینک اشتراک
                                                                            </a>
                                                                        </div>
                                                                    </div>
                                                                </div>
                                                            {/if}

                                                        {/if}
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                {if $os eq "Windows"}<div class="tab-pane active show" id="windows">{else}<div class="tab-pane" id="windows">{/if}
                                    <div class="accordion-item">
                                        <div class="accordion" id="windows-accordion">
                                            <h2 class="accordion-header" id="heading-1">
                                                <button class="accordion-button collapsed" type="button"
                                                    data-bs-toggle="collapse" data-bs-target="#collapse-1"
                                                    aria-expanded="false">
                                                    CLASH (پیشنهادی)
                                                </button>
                                            </h2>
                                            <div id="collapse-1" class="accordion-collapse collapse"
                                                data-bs-parent="#windows-accordion">
                                                <div class="accordion-body pt-0">
                                                    <strong>لینک اشتراک هوشمند شما برای تمامی کلاینت های
                                                        سازگار با کلش متا:</strong>
                                                    <br>
                                                    ابتدا نرم افزار Clash Verge را با توجه به نوع سیستم عامل از لینک های
                                                    زیر
                                                    دانلود
                                                    کنید.


                                                    <div class="btn-list justify-content-start">
                                                        <a href="/clients/Clash.Verge.msi" class="btn btn-primary">
                                                            دانلود
                                                        </a>
                                                    </div>

                                                    <br>
                                                    <p>
                                                        حال کافیست تا بر روی دکمه زیر کلیک کنید و با مشاهده پنجره باز
                                                        شده در
                                                        مرورگر
                                                        بر
                                                        روی گزینه Open کلیک کنید تا لینک سرور به صورت خودکار به نرم
                                                        افزار Clash
                                                        Verge
                                                        افزوده شود.

                                                    <div class="btn-list justify-content-start">
                                                        <a href="clash://install-config?url={$UniversalSub}/clash&name={$config['appName']}"
                                                            class="btn btn-primary">
                                                            افزودن خودکار به Clash Verge
                                                        </a>
                                                        <a class="btn" data-bs-toggle="offcanvas" href="#offcanvasEnd" role="button" aria-controls="offcanvasEnd">
                                                            آموزش استفاده از iClash
                                                        </a>

                                                        {include file='user/knowledge/shadowRocket.tpl' results=$SharedAccounts}
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="accordion-item">
                                        <div class="accordion" id="windows-accordion">
                                            <h2 class="accordion-header" id="heading-2">
                                                <button class="accordion-button collapsed" type="button"
                                                    data-bs-toggle="collapse" data-bs-target="#collapse-2"
                                                    aria-expanded="false">
                                                    V2rayN
                                                </button>
                                            </h2>
                                            <div id="collapse-2" class="accordion-collapse collapse"
                                                data-bs-parent="#windows-accordion">
                                                <div class="accordion-body pt-0">
                                                    <strong>جهت استفاده در کلاینت v2rayN:</strong>
                                                    <br>
                                                    <br>
                                                    ابتدا نرم افزار v2rayN را با توجه به نوع سیستم عامل از لینک های
                                                    زیر
                                                    دانلود
                                                    کنید.


                                                    <div class="btn-list justify-content-start">
                                                        <a href="/clients/v2rayN-Core.zip" class="btn btn-primary">
                                                            دانلود v2rayN（Windows）
                                                        </a>
                                                    </div>
                                                    <br>
                                                    <p>

                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                {if $os eq "Mac"}<div class="tab-pane active show" id="macos">{else}<div class="tab-pane" id="macos">{/if}
                                    <p>
                                        ابتدا نرم افزار Clash Verge را با توجه به نوع سیستم عامل از لینک های زیر دانلود
                                        کنید.
                                    </p>
                                    <div class="btn-list justify-content-start">
                                        <a href="/clients/Clash.Verge_x64.dmg" class="btn btn-primary">
                                            دانلود (x86_64)
                                        </a>
                                        <a href="/clients/Clash.Verge_aarch64.dmg" class="btn btn-primary">
                                            دانلود (aarch64)
                                        </a>
                                    </div>
                                    <br>
                                    <p>
                                        حال کافیست تا بر روی دکمه زیر کلیک کنید و با مشاهده پنجره باز شده در مرورگر بر
                                        روی گزینه Open کلیک کنید تا لینک سرور به صورت خودکار به نرم افزار Clash Verge
                                        افزوده شود.

                                    <div class="btn-list justify-content-start">


                                        <a href="clash://install-config?url={$UniversalSub}/clash&name={$config['appName']}"
                                            class="btn btn-primary">
                                            افزودن به Clash Verge
                                        </a>
                                    </div>
                                    </p>
                                    <p>
                                        لینک اشتراک کلش：<code>{$UniversalSub}/clash</code>
                                    </p>
                                    <div class="btn-list justify-content-start">
                                        <a data-clipboard-text="{$UniversalSub}/clash" class="copy btn btn-primary">
                                            کپی لینک اشتراک کلش
                                        </a>
                                    </div>
                                </div>
                                {if $os eq "Droid"}<div class="tab-pane active show" id="android">{else}<div class="tab-pane" id="android">{/if}
                                    <div class="btn-list justify-content-start">
                                        <a data-clipboard-text="{$UniversalSub}/clash" class="copy btn btn-primary">
                                            کپی لینک اشتراک کلش
                                        </a>
                                        <a href="/clients/Clash-Android.apk" class="btn btn-primary">
                                            دانلود Clash for Android
                                        </a>
                                        <a href="clash://install-config?url={$UniversalSub}/clash&name={$config['appName']}"
                                            class="btn btn-primary">
                                            افزودن به کلش
                                        </a>
                                        <a href="/clients/v2rayNG.apk" class="btn btn-primary">
                                            دانلود v2rayNG（Android）
                                        </a>
                                    </div>
                                </div>
                                {if $os eq "iPhone" or $os eq "iPad"}<div class="tab-pane active show" id="ios">{else}<div class="tab-pane" id="ios">{/if}
                                    <p>
                                        اشتراک برای کلاینت های سازگار با کلش：<code>{$UniversalSub}/clash</code>
                                    </p>
                                    <p>
                                        پس از خرید و نصب یک کلاینت سازگار با Clash مانند Stash، روی<code>کپی لینک اشتراک
                                            کلش</code>را فشار دهید و سپس کلاینت سازگار با کلش را برای افزودن باز کنید.
                                    </p>
                                    <div class="btn-list justify-content-start">
                                        <a href="https://apps.apple.com/app/stash/id1596063349" target="_blank"
                                            class="btn btn-primary">
                                            Stash را بخرید
                                        </a>
                                        <a data-clipboard-text="{$UniversalSub}/clash" class="copy btn btn-primary">
                                            کپی لینک اشتراک کلش
                                        </a>
                                        <a href="stash://install-config?url={$UniversalSub}/clash&name={$config['appName']}"
                                            class="btn btn-primary">
                                            افزودن به stash
                                        </a>
                                    </div>
                                </div>
                                {if $os eq "Linux"}<div class="tab-pane active show" id="linux">{else}<div class="tab-pane" id="linux">{/if}
                                    <p>
                                        لینک اشتراک کلش：<code>{$UniversalSub}/clash</code>
                                    </p>
                                    <div class="btn-list justify-content-start">
                                        <a data-clipboard-text="{$UniversalSub}/clash" class="copy btn btn-primary">
                                            کپی لینک اشتراک کلش
                                        </a>
                                        <a href="/clients/Clash.Verge.AppImage.tar.gz" class="btn btn-primary">
                                            دانلود Clash Verge
                                        </a>
                                        <a href="clash://install-config?url={$UniversalSub}/clash&name={$config['appName']}"
                                            class="btn btn-primary">
                                            افزودن به کلش
                                        </a>
                                    </div>
                                </div>
                                {if $os eq "Unix"}<div class="tab-pane active show" id="config">{else}<div class="tab-pane" id="config">{/if}
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
                                                    <td><strong>رمزنگاری سفارشی</strong></td>
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
                                    <span>ترافیک باقی مانده {$user->unusedTraffic()}</span>
                                </div>
                            </div>
                            <p class="my-3">
                                {if time() > strtotime($user->class_expire)}
                                    بسته شما منقضی شده است، لطفا جهت خرید بسته به
                                    <a href="/user/product">فروشگاه</a>
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
                                <h3 class="card-title">ترافیک هدیه ورود روزانه</h3>
                                <p>
                                    جهت دریافت حجم هدیه بین
                                    {if $config['checkinMin'] !== $config['checkinMax']}
                                        &nbsp;<code>{$config['checkinMin']} MB</code> تا <code>{$config['checkinMax']} MB</code>
                                        ترافیک در محدوده
                                    {else}
                                        <code>{$config['checkinMin']} MB</code>
                                    {/if}
                                </p>
                                <p>
                                    آخرین زمان استفاده：
                                    <code style="font-family: Yekan;">{$user->lastCheckInTime()}</code>
                                </p>
                            </div>
                            <div class="card-footer">
                                <div class="d-flex">
                                    {if ! $user->isAbleToCheckin()}
                                        <button id="check-in" class="btn btn-primary ms-auto" disabled>وارد شدن</button>
                                    {else}
                                        {if $public_setting['enable_checkin_captcha']}
                                            {if $public_setting['captcha_provider'] === 'turnstile'}
                                                <div id="cf-turnstile" class="cf-turnstile"
                                                    data-sitekey="{$captcha['turnstile_sitekey']}" {if $user->is_dark_mode}
                                                    data-theme="dark" {else} data-theme="light" 
                                                    {/if}></div>
                                            {/if}
                                            {if $public_setting['captcha_provider'] === 'geetest'}
                                                <div id="geetest"></div>
                                            {/if}
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
                    riskType: 'slide'
                }, function(geetest) {
                    geetest.appendTo("#geetest");
                    geetest.onSuccess(function() {
                        geetest_result = geetest.getValidate();
                    });
                });
            </script>
        {/if}
    {/if}
{include file='user/footer.tpl'}