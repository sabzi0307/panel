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
                                            <span class="bg-azure text-white avatar">
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
                                            <span class="bg-indigo text-white avatar">
                                                <i class="ti ti-rocket icon"></i>
                                            </span>
                                        </div>
                                        <div class="col">
                                            <div class="font-weight-medium">
                                                محدودیت سرعت
                                            </div>
                                            <div class="text-secondary">
                                                {if $user->node_speedlimit !== 0.0}
                                                    <code>{$user->node_speedlimit}</code>
                                                    Mbps
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
                                <a href="#sub" data-bs-toggle="tab" {if $osFamily eq "Unknown"} class="nav-link active"
                                    {else} class="nav-link" 
                                    {/if}>
                                    <i class="ti ti-rss icon"></i>
                                    &nbsp;پروفایل ها
                                </a>
                            </li>
                            <li class="nav-item">
                                <a href="#client-sub" class="nav-link" data-bs-toggle="tab">
                                    <i class="ti ti-rss icon"></i>
                                    &nbsp;پراکسی ها
                                </a>
                            </li>
                            <li class="nav-item">
                                <a href="#windows" {if $osFamily eq "Windows"} class="nav-link active" 
                                {else}
                                    class="nav-link" {/if} data-bs-toggle="tab">
                                    <i class="ti ti-brand-windows icon"></i>
                                    &nbsp;ویندوز
                                </a>
                            </li>
                            <li class="nav-item">
                                <a href="#macos" {if $osFamily eq "Mac"} class="nav-link active" 
                                {else} class="nav-link"
                                    {/if} data-bs-toggle="tab">
                                    <i class="ti ti-brand-finder icon"></i>
                                    &nbsp;مکینتاش
                                </a>
                            </li>
                            <li class="nav-item">
                                <a href="#android" {if $osFamily eq "Droid"} class="nav-link active" 
                                {else}
                                    class="nav-link" {/if} data-bs-toggle="tab">
                                    <i class="ti ti-brand-android icon"></i>
                                    &nbsp;اندروید
                                </a>
                            </li>
                            <li class="nav-item">
                                <a href="#ios" {if $osFamily eq "iPhone"} class="nav-link active" 
                                {else}
                                    class="nav-link" {/if} data-bs-toggle="tab">
                                    <i class="ti ti-brand-apple icon"></i>
                                    &nbsp;آی او اس
                                </a>
                            </li>
                            <li class="nav-item">
                                <a href="#linux" {if $osFamily eq "Linux"} class="nav-link active" 
                                {else}
                                    class="nav-link" {/if} data-bs-toggle="tab">
                                    <i class="ti ti-brand-redhat icon"></i>
                                    &nbsp;لینوکس
                                </a>
                            </li>
                            <li class="nav-item">
                                <a href="#config" {if $osFamily eq "Unix"} class="nav-link active" 
                                {else}
                                    class="nav-link" {/if} data-bs-toggle="tab">
                                    <i class="ti ti-file-text icon"></i>
                                    &nbsp;تنظیمات
                                </a>
                            </li>
                            {{if $public_setting['smart_dns']}}
                                <li class="nav-item">
                                    <a href="#dns" {if $osFamily eq "TV"} class="nav-link active" 
                                    {else} class="nav-link"
                                        {/if} data-bs-toggle="tab">
                                        <i class="ti ti-device-tv-old icon"></i>
                                        &nbsp;SmartDNS
                                    </a>
                                </li>
                            {{/if}}
                        </ul>
                        <div class="card-body">
                            <div class="tab-content">
                                <div {if $osFamily eq "Unknown"} class="tab-pane active show" 
                                {else} class="tab-pane"
                                    {{/if}} id="sub">
                                    <div style="direction: ltr;">
                                        <p>
                                            JSON: <code class="copy btn-icon"
                                                data-clipboard-text="{$UniversalSub}/json">{$UniversalSub}/json</code>
                                            <a style="font-size: 90%;" class="copy btn-icon"
                                                data-clipboard-text="{$UniversalSub}/json">
                                                <i class="ti ti-copy"></i>
                                                کپی
                                            </a>
                                        </p>
                                        <p>
                                            Clash: <code class="copy btn-icon"
                                                data-clipboard-text="{$UniversalSub}/clash">{$UniversalSub}/clash</code>
                                            <a style="font-size: 90%;" class="copy btn-icon"
                                                data-clipboard-text="{$UniversalSub}/clash">
                                                <i class="ti ti-copy"></i>
                                                کپی
                                            </a>
                                        </p>
                                        <p>
                                            SingBox: <code class="copy btn-icon"
                                                data-clipboard-text="{$UniversalSub}/singbox">{$UniversalSub}/singbox</code>
                                            <a style="font-size: 90%;" class="copy btn-icon"
                                                data-clipboard-text="{$UniversalSub}/singbox">
                                                <i class="ti ti-copy"></i>
                                                کپی
                                            </a>
                                        </p>
                                        <p>
                                            V2Ray JSON: <code class="copy btn-icon"
                                                data-clipboard-text="{$UniversalSub}/v2rayjson">{$UniversalSub}/v2rayjson</code>
                                            <a style="font-size: 90%;" class="copy btn-icon"
                                                data-clipboard-text="{$UniversalSub}/v2rayjson">
                                                <i class="ti ti-copy"></i>
                                                کپی
                                            </a>
                                        </p>
                                        {if $public_setting['enable_ss_sub']}
                                            <p>
                                                SIP008: <code class="copy btn-icon"
                                                    data-clipboard-text="{$UniversalSub}/sip008">{$UniversalSub}/sip008</code>
                                                <a style="font-size: 90%;" class="copy btn-icon"
                                                    data-clipboard-text="{$UniversalSub}/sip008">
                                                    <i class="ti ti-copy"></i>
                                                    کپی
                                                </a>
                                            </p>
                                        {/if}
                                    </div>
                                </div>
                                <div class="tab-pane" id="client-sub">
                                    <div style="direction: ltr;">
                                        {if $public_setting['enable_ss_sub']}
                                            <p>
                                                Shadowsocks: <code class="copy btn-icon"
                                                    data-clipboard-text="{$UniversalSub}/ss">{$UniversalSub}/ss</code>
                                                <a style="font-size: 90%;" class="copy btn-icon"
                                                    data-clipboard-text="{$UniversalSub}/ss">
                                                    <i class="ti ti-copy"></i>
                                                    کپی
                                                </a>
                                            </p>
                                            <p>
                                                Shadowsocks SIP002: <code class="copy btn-icon"
                                                    data-clipboard-text="{$UniversalSub}/sip002">{$UniversalSub}/sip002</code>
                                                <a style="font-size: 90%;" class="copy btn-icon"
                                                    data-clipboard-text="{$UniversalSub}/sip002">
                                                    <i class="ti ti-copy"></i>
                                                    کپی
                                                </a>
                                            </p>
                                        {/if}
                                        {if $public_setting['enable_v2_sub']}
                                            <p>
                                                V2Ray: <code class="copy btn-icon"
                                                    data-clipboard-text="{$UniversalSub}/v2ray">{$UniversalSub}/v2ray</code>
                                                <a style="font-size: 90%;" class="copy btn-icon"
                                                    data-clipboard-text="{$UniversalSub}/v2ray">
                                                    <i class="ti ti-copy"></i>
                                                    کپی
                                                </a>
                                            </p>
                                        {/if}
                                        {if $public_setting['enable_trojan_sub']}
                                            <p>
                                                Trojan: <code class="copy btn-icon"
                                                    data-clipboard-text="{$UniversalSub}/trojan">{$UniversalSub}/trojan</code>
                                                <a style="font-size: 90%;" class="copy btn-icon"
                                                    data-clipboard-text="{$UniversalSub}/trojan">
                                                    <i class="ti ti-copy"></i>
                                                    کپی
                                                </a>
                                            </p>
                                        {/if}
                                    </div>
                                </div>
                                <div {if $osFamily eq "Windows"} class="tab-pane active show" 
                                {else} class="tab-pane"
                                    {{/if}} id="windows">
                                    <div class="accordion-item">
                                        <div class="accordion" id="windows-accordion">
                                            <h2 class="accordion-header" id="heading-3">
                                                <button class="accordion-button collapsed" type="button"
                                                    data-bs-toggle="collapse" data-bs-target="#windows-3"
                                                    aria-expanded="false">
                                                    هیدیفای نکست 
                                                </button>
                                            </h2>
                                            <div id="windows-3" class="accordion-collapse collapse"
                                                data-bs-parent="#windows-accordion">
                                                <div class="accordion-body pt-0">
                                                    <a><strong>لینک اشتراک هوشمند شما
                                                            سازگار با هیدیفای نکست:</strong></a><br>
                                                    <p>
                                                        <code class="copy btn-icon"
                                                            data-clipboard-text="{$UniversalSub}/clash">{$UniversalSub}/clash</code>
                                                        <a style="font-size: 90%;" class="copy btn-icon"
                                                            data-clipboard-text="{$UniversalSub}/clash">
                                                            کپی
                                                            <i class="ti ti-copy"></i>
                                                        </a>
                                                    </p>
                                                    <a>ابتدا نرم افزار هیدیفای نکست را از
                                                        لینک های
                                                        زیر
                                                        دانلود
                                                        کنید.</a>
                                                    <br>
                                                    <div style="margin-top: 5px;"
                                                        class="btn-list justify-content-start">
                                                        <a {if $config['enable_r2_client_download']}
                                                            href="/user/clients/hiddify-windows-x64-setup.zip" {else}
                                                            href="https://app.hiddify.com/win" target="_blank" rel="noopener noreferrer"{/if}
                                                            class="btn btn-azure">
                                                            دانلود هیدیفای نکست
                                                        </a>
                                                    </div>
                                                    <br>
                                                    <a>سپس کافیست تا بر روی دکمه <strong>افزودن خودکار</strong> کلیک
                                                        کنید و با
                                                        مشاهده
                                                        پنجره باز
                                                        شده در
                                                        مرورگر
                                                        بر
                                                        روی گزینه Open کلیک کنید تا لینک سرور به صورت خودکار به
                                                        نرم
                                                        افزار هیدیفای نکست
                                                        افزوده شود.</a>
                                                    <br>
                                                    <a style="margin-top: 5px;"
                                                        href="hiddify://install-config?url={$UniversalSub}/clash"
                                                        class="btn btn-primary">
                                                        افزودن خودکار به هیدیفای نکست
                                                    </a>

                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="accordion-item">
                                        <div class="accordion" id="windows-accordion">
                                            <h2 class="accordion-header" id="heading-1">
                                                <button class="accordion-button collapsed" type="button"
                                                    data-bs-toggle="collapse" data-bs-target="#win-1"
                                                    aria-expanded="false">
                                                    CLASH
                                                </button>
                                            </h2>
                                            <div id="win-1" class="accordion-collapse collapse"
                                                data-bs-parent="#windows-accordion">
                                                <div class="accordion-body pt-0">
                                                    <a><strong>لینک اشتراک هوشمند شما برای تمامی کلاینت های
                                                            سازگار با کلش متا:</strong></a><br>
                                                    <p>
                                                        <code class="copy btn-icon"
                                                            data-clipboard-text="{$UniversalSub}/clash">{$UniversalSub}/clash</code>
                                                        <a style="font-size: 90%;" class="copy btn-icon"
                                                            data-clipboard-text="{$UniversalSub}/clash">
                                                            کپی
                                                            <i class="ti ti-copy"></i>
                                                        </a>
                                                    </p>
                                                    <a>ابتدا نرم افزار Clash Verge را با توجه به نوع سیستم عامل از
                                                        لینک های
                                                        زیر
                                                        دانلود
                                                        کنید.</a>
                                                    <br>
                                                    <div style="margin-top: 5px;"
                                                        class="btn-list justify-content-start">
                                                        <a {if $config['enable_r2_client_download']}
                                                            href="/user/clients/Clash.Verge.exe" {else}
                                                            href="https://github.com/zzzgydi/clash-verge/releases/download/v1.3.8/Clash.Verge_1.3.8_x64-setup.exe" target="_blank" rel="noopener noreferrer" {/if} class="btn btn-azure">
                                                            دانلود Clash Verge
                                                        </a>
                                                    </div>
                                                    <br>
                                                    <a>سپس کافیست تا بر روی دکمه <strong>افزودن خودکار</strong> کلیک
                                                        کنید و
                                                        با
                                                        مشاهده
                                                        پنجره باز
                                                        شده در
                                                        مرورگر
                                                        بر
                                                        روی گزینه Open کلیک کنید تا لینک سرور به صورت خودکار به
                                                        نرم
                                                        افزار Clash
                                                        افزوده شود.</a>
                                                    <br>
                                                    <a style="margin-top: 5px;"
                                                        href="clash://install-config?url={$UniversalSub}/clash&name={$config['appName']}"
                                                        class="btn btn-primary">
                                                        افزودن خودکار به Clash
                                                    </a>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <!-- <div class="accordion-item">
                                        <div class="accordion" id="windows-accordion">
                                            <h2 class="accordion-header" id="heading-2">
                                                <button class="accordion-button collapsed" type="button"
                                                    data-bs-toggle="collapse" data-bs-target="#win-2"
                                                    aria-expanded="false">
                                                    V2rayN
                                                </button>
                                            </h2>
                                            <div id="win-2" class="accordion-collapse collapse"
                                                data-bs-parent="#windows-accordion">
                                                <div class="accordion-body pt-0">
                                                    <a><strong>لینک اشتراک هوشمند شما برای تمامی کلاینت های
                                                            سازگار با کلش متا:</strong></a><br>
                                                    <p>
                                                        <code class="copy btn-icon"
                                                            data-clipboard-text="{$UniversalSub}/clash">{$UniversalSub}/clash</code>
                                                        <a style="font-size: 90%;" class="copy btn-icon"
                                                            data-clipboard-text="{$UniversalSub}/clash">
                                                            کپی
                                                            <i class="ti ti-copy"></i>
                                                        </a>
                                                    </p>
                                                    <a>ابتدا نرم افزار Clash Verge را با توجه به نوع سیستم عامل از
                                                        لینک های
                                                        زیر
                                                        دانلود
                                                        کنید.</a>
                                                    <br>
                                                    <div style="margin-top: 5px;"
                                                        class="btn-list justify-content-start">
                                                        <a {if $config['enable_r2_client_download']}
                                                            href="/user/clients/Clash.Verge.exe" {else}
                                                            href="/clients/Clash.Verge.exe" {/if} class="btn btn-azure">
                                                            دانلود (x86_64)
                                                        </a>
                                                        <a {if $config['enable_r2_client_download']}
                                                            href="/user/clients/Clash.Verge_aarch64.dmg" {else}
                                                            href="/clients/Clash.Verge_aarch64.dmg" {/if}
                                                            class="btn btn-azure">
                                                            دانلود (aarch64)
                                                        </a>
                                                    </div>
                                                    <br>
                                                    <a>سپس کافیست تا بر روی دکمه <strong>افزودن خودکار</strong> کلیک
                                                        کنید و
                                                        با
                                                        مشاهده
                                                        پنجره باز
                                                        شده در
                                                        مرورگر
                                                        بر
                                                        روی گزینه Open کلیک کنید تا لینک سرور به صورت خودکار به
                                                        نرم
                                                        افزار Clash
                                                        افزوده شود.</a>
                                                    <br>
                                                    <a style="margin-top: 5px;"
                                                        href="clash://install-config?url={$UniversalSub}/clash&name={$config['appName']}"
                                                        class="btn btn-primary">
                                                        افزودن خودکار به Clash
                                                    </a>
                                                </div>
                                            </div>
                                        </div>
                                    </div> -->
                                </div>
                                <div {if $osFamily eq "Droid"} class="tab-pane active show" 
                                {else} class="tab-pane"
                                    {{/if}} id="android">
                                    <div class="accordion-item">
                                        <div class="accordion" id="droid-accordion">
                                            <h2 class="accordion-header" id="heading-3">
                                                <button class="accordion-button collapsed" type="button"
                                                    data-bs-toggle="collapse" data-bs-target="#droid-3"
                                                    aria-expanded="false">
                                                    هیدیفای نکست 
                                                </button>
                                            </h2>
                                            <div id="droid-3" class="accordion-collapse collapse"
                                                data-bs-parent="#droid-accordion">
                                                <div class="accordion-body pt-0">
                                                    <a><strong>لینک اشتراک هوشمند شما
                                                            سازگار با هیدیفای نکست:</strong></a><br>
                                                    <p>
                                                        <code class="copy btn-icon"
                                                            data-clipboard-text="{$UniversalSub}/clash">{$UniversalSub}/clash</code>
                                                        <a style="font-size: 90%;" class="copy btn-icon"
                                                            data-clipboard-text="{$UniversalSub}/clash">
                                                            کپی
                                                            <i class="ti ti-copy"></i>
                                                        </a>
                                                    </p>
                                                    <a>ابتدا نرم افزار هیدیفای نکست را از
                                                        لینک های
                                                        زیر
                                                        دانلود
                                                        کنید.</a>
                                                    <br>
                                                    <div style="margin-top: 5px;"
                                                        class="btn-list justify-content-start">
                                                        <a {if $config['enable_r2_client_download']}
                                                            href="/user/clients/hiddify-android-universal.apk" {else}
                                                            href="https://play.google.com/store/apps/details?id=app.hiddify.com" target="_blank" rel="noopener noreferrer"{/if}
                                                            class="btn btn-azure">
                                                            دانلود هیدیفای نکست
                                                        </a>
                                                    </div>
                                                    <br>
                                                    <a>سپس کافیست تا بر روی دکمه <strong>افزودن خودکار</strong> کلیک
                                                        کنید و با
                                                        مشاهده
                                                        پنجره باز
                                                        شده در
                                                        مرورگر
                                                        بر
                                                        روی گزینه Open کلیک کنید تا لینک سرور به صورت خودکار به
                                                        نرم
                                                        افزار هیدیفای نکست
                                                        افزوده شود.</a>
                                                    <br>
                                                    <a style="margin-top: 5px;"
                                                        href="hiddify://install-config?url={$UniversalSub}/clash"
                                                        class="btn btn-primary">
                                                        افزودن خودکار به هیدیفای نکست
                                                    </a>

                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="accordion-item">
                                        <div class="accordion" id="droid-accordion">
                                            <h2 class="accordion-header" id="heading-1">
                                                <button class="accordion-button collapsed" type="button"
                                                    data-bs-toggle="collapse" data-bs-target="#droid-1"
                                                    aria-expanded="false">
                                                    SingBox
                                                </button>
                                            </h2>
                                            <div id="droid-1" class="accordion-collapse collapse"
                                                data-bs-parent="#droid-accordion">
                                                <div class="accordion-body pt-0">
                                                    <a><strong>لینک اشتراک هوشمند شما برای تمامی کلاینت های
                                                            سازگار با SingBox:</strong></a><br>
                                                    <p>
                                                        <code class="copy btn-icon"
                                                            data-clipboard-text="{$UniversalSub}/singbox">{$UniversalSub}/singbox</code>
                                                        <a style="font-size: 90%;" class="copy btn-icon"
                                                            data-clipboard-text="{$UniversalSub}/singbox">
                                                            کپی
                                                            <i class="ti ti-copy"></i>
                                                        </a>
                                                    </p>
                                                    <a>ابتدا نرم افزار SingBox را از
                                                        لینک های
                                                        زیر
                                                        دانلود
                                                        کنید.</a>
                                                    <br>
                                                    <div style="margin-top: 5px;"
                                                        class="btn-list justify-content-start">
                                                        <a {if $config['enable_r2_client_download']}
                                                            href="/user/clients/SFA.apk" {else}
                                                             href="https://github.com/SagerNet/sing-box/releases/download/v1.10.0-alpha.28/SFA-1.10.0-alpha.28-universal.apk"
                                                             target="_blank" rel="noopener noreferrer"
                                                             {/if} class="btn btn-azure">
                                                            SFA دانلود
                                                        </a>
                                                    </div>
                                                    <br>
                                                    <a>سپس کافیست تا بر روی دکمه <strong>افزودن خودکار</strong> کلیک
                                                        کنید و با
                                                        مشاهده
                                                        پنجره باز
                                                        شده در
                                                        مرورگر
                                                        بر
                                                        روی گزینه Open کلیک کنید تا لینک سرور به صورت خودکار به
                                                        نرم
                                                        افزار SingBox
                                                        افزوده شود.</a>
                                                    <br>
                                                    <a style="margin-top: 5px;"
                                                        href="sing-box://import-remote-profile?url={$UniversalSub}/singbox#{$config['appName']}"
                                                        class="btn btn-primary">
                                                        افزودن خودکار به SingBox
                                                    </a>

                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="accordion-item">
                                        <div class="accordion" id="mac-accordion">
                                            <h2 class="accordion-header" id="heading-2">
                                                <button class="accordion-button collapsed" type="button"
                                                    data-bs-toggle="collapse" data-bs-target="#droid-2"
                                                    aria-expanded="false">
                                                    CLASH
                                                </button>
                                            </h2>
                                            <div id="droid-2" class="accordion-collapse collapse">
                                                <a><strong>لینک اشتراک هوشمند شما برای تمامی کلاینت های
                                                        سازگار با کلش متا:</strong></a><br>
                                                <p>
                                                    <code class="copy btn-icon"
                                                        data-clipboard-text="{$UniversalSub}/clash">{$UniversalSub}/clash</code>
                                                    <a style="font-size: 90%;" class="copy btn-icon"
                                                        data-clipboard-text="{$UniversalSub}/clash">
                                                        کپی
                                                        <i class="ti ti-copy"></i>
                                                    </a>
                                                </p>
                                                <a>ابتدا نرم افزار Clash Verge را با توجه به نوع سیستم عامل از
                                                    لینک های
                                                    زیر
                                                    دانلود
                                                    کنید.</a>
                                                <br>
                                                <div style="margin-top: 5px;" class="btn-list justify-content-start">
                                                    <a {if $config['enable_r2_client_download']}
                                                        href="/user/clients/CMFA.apk" {else}
                                                        href="/clients/CMFA.apk" {/if} class="btn btn-azure">
                                                        دانلود کلش برای اندروید
                                                    </a>
                                                </div>
                                                <br>
                                                <a>سپس کافیست تا بر روی دکمه <strong>افزودن خودکار</strong> کلیک کنید و
                                                    با
                                                    مشاهده
                                                    پنجره باز
                                                    شده در
                                                    مرورگر
                                                    بر
                                                    روی گزینه Open کلیک کنید تا لینک سرور به صورت خودکار به
                                                    نرم
                                                    افزار Clash
                                                    افزوده شود.</a>
                                                <br>
                                                <a style="margin-top: 5px;"
                                                    href="clash://install-config?url={$UniversalSub}/clash&name={$config['appName']}"
                                                    class="btn btn-primary">
                                                    افزودن خودکار به Clash
                                                </a>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div {if $osFamily eq "iPhone"} class="tab-pane active show" 
                                {else} class="tab-pane"
                                    {{/if}} id="ios">
                                    <div class="accordion-item">
                                        <div class="accordion" id="ios-accordion">
                                            <h2 class="accordion-header" id="heading-1">
                                                <button class="accordion-button collapsed" type="button"
                                                    data-bs-toggle="collapse" data-bs-target="#ios-1"
                                                    aria-expanded="false">
                                                    SingBox (پیشنهادی)
                                                </button>
                                            </h2>
                                            <div id="ios-1" class="accordion-collapse collapse"
                                                data-bs-parent="#ios-accordion">
                                                <div class="accordion-body pt-0">
                                                    <a><strong>لینک اشتراک هوشمند شما برای تمامی کلاینت های
                                                            سازگار با SingBox:</strong></a><br>
                                                    <p>
                                                        <code class="copy btn-icon"
                                                            data-clipboard-text="{$UniversalSub}/singbox">{$UniversalSub}/singbox</code>
                                                        <a style="font-size: 90%;" class="copy btn-icon"
                                                            data-clipboard-text="{$UniversalSub}/singbox">
                                                            کپی
                                                            <i class="ti ti-copy"></i>
                                                        </a>
                                                    </p>
                                                    <a>ابتدا نرم افزار SingBox را از
                                                        AppStore نصب
                                                        کنید.</a>
                                                    <br>
                                                    <div style="margin-top: 5px;"
                                                        class="btn-list justify-content-start">
                                                        <a href="https://apps.apple.com/app/sing-box/id6451272673"
                                                            target="_blank" class="btn btn-azure">
                                                            Sing-Box در AppStore
                                                        </a>
                                                    </div>
                                                    <br>
                                                    <a>سپس کافیست تا بر روی دکمه <strong>افزودن خودکار</strong> کلیک
                                                        کنید و با
                                                        مشاهده
                                                        پنجره باز
                                                        شده در
                                                        مرورگر
                                                        بر
                                                        روی گزینه Open کلیک کنید تا لینک سرور به صورت خودکار به
                                                        نرم
                                                        افزار SingBox
                                                        افزوده شود.</a>
                                                    <br>
                                                    <a style="margin-top: 5px;"
                                                        href="sing-box://import-remote-profile?url={$UniversalSub}/singbox#{$config['appName']}"
                                                        class="btn btn-primary">
                                                        افزودن خودکار به SingBox
                                                    </a>

                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="accordion-item">
                                        <div class="accordion" id="ios-accordion">
                                            <h2 class="accordion-header" id="heading-2">
                                                <button class="accordion-button collapsed" type="button"
                                                    data-bs-toggle="collapse" data-bs-target="#ios-2"
                                                    aria-expanded="false">
                                                    ShadowRocket (حرفه ای + اکانت اشتراکی)
                                                </button>
                                            </h2>
                                            <div id="ios-2" class="accordion-collapse collapse">
                                                <a class="btn btn-primary" data-bs-toggle="offcanvas"
                                                    href="#offcanvasEndSharedAccount" role="button"
                                                    aria-controls="offcanvasEndSharedAccount"
                                                    style="background-color: green;">
                                                    آموزش استفاده از اکانت اشتراکی
                                                </a>
                                                {include file='user/knowledge/SharedAccount.tpl' accounts=$SharedAccounts}
                                                <br><br>
                                                <a><strong>لینک اشتراک هوشمند شما برای تمامی کلاینت های
                                                        سازگار با کلش متا:</strong></a><br>
                                                <p>
                                                    <code class="copy btn-icon"
                                                        data-clipboard-text="{$UniversalSub}/clash">{$UniversalSub}/clash</code>
                                                    <a style="font-size: 90%;" class="copy btn-icon"
                                                        data-clipboard-text="{$UniversalSub}/clash">
                                                        کپی
                                                        <i class="ti ti-copy"></i>
                                                    </a>
                                                </p>
                                                <a>ابتدا نرم افزار ShadowRocket را از
                                                    AppStore نصب
                                                    کنید.</a>
                                                <br>
                                                <div style="margin-top: 5px;" class="btn-list justify-content-start">
                                                    <a href="https://apps.apple.com/app/shadowrocket/id932747118"
                                                        target="_blank" class="btn btn-azure">
                                                        ShadowRocket در AppStore
                                                    </a>
                                                </div>
                                                <br>
                                                <a>سپس کافیست تا بر روی دکمه <strong>افزودن خودکار</strong> کلیک کنید و
                                                    با
                                                    مشاهده
                                                    پنجره باز
                                                    شده در
                                                    مرورگر
                                                    بر
                                                    روی گزینه Open کلیک کنید تا لینک سرور به صورت خودکار به
                                                    نرم
                                                    افزار Clash
                                                    افزوده شود.</a>
                                                <br>
                                                <a style="margin-top: 5px;"
                                                    href="shadowrocket://config/add/{$UniversalSub}/clash&name={$config['appName']}"
                                                    class="btn btn-primary">
                                                    افزودن خودکار به ShadowRocket
                                                </a>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="accordion-item">
                                        <div class="accordion" id="ios-accordion">
                                            <h2 class="accordion-header" id="heading-3">
                                                <button class="accordion-button collapsed" type="button"
                                                    data-bs-toggle="collapse" data-bs-target="#ios-3"
                                                    aria-expanded="false">
                                                    Stash
                                                </button>
                                            </h2>
                                            <div id="ios-3" class="accordion-collapse collapse">
                                                <a><strong>لینک اشتراک هوشمند شما برای تمامی کلاینت های
                                                        سازگار با کلش متا:</strong></a><br>
                                                <p>
                                                    <code class="copy btn-icon"
                                                        data-clipboard-text="{$UniversalSub}/clash">{$UniversalSub}/clash</code>
                                                    <a style="font-size: 90%;" class="copy btn-icon"
                                                        data-clipboard-text="{$UniversalSub}/clash">
                                                        کپی
                                                        <i class="ti ti-copy"></i>
                                                    </a>
                                                </p>
                                                <a>ابتدا نرم افزار Stash را از
                                                    AppStore نصب
                                                    کنید.</a>
                                                <br>
                                                <div style="margin-top: 5px;" class="btn-list justify-content-start">
                                                    <a href="https://apps.apple.com/app/stash/id1596063349"
                                                        target="_blank" class="btn btn-azure">
                                                        Stash در AppStore
                                                    </a>
                                                </div>
                                                <br>
                                                <a>سپس کافیست تا بر روی دکمه <strong>افزودن خودکار</strong> کلیک کنید و
                                                    با
                                                    مشاهده
                                                    پنجره باز
                                                    شده در
                                                    مرورگر
                                                    بر
                                                    روی گزینه Open کلیک کنید تا لینک سرور به صورت خودکار به
                                                    نرم
                                                    افزار Stash
                                                    افزوده شود.</a>
                                                <br>
                                                <a style="margin-top: 5px;"
                                                    href="stash://install-config?url={$UniversalSub}/clash&name={$config['appName']}"
                                                    class="btn btn-primary">
                                                    افزودن خودکار به Stash
                                                </a>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div {if $osFamily eq "Linux"} class="tab-pane active show" 
                                {else} class="tab-pane"
                                    {{/if}} id="linux">
                                    <div class="accordion-item">
                                        <div class="accordion" id="linux-accordion">
                                            <h2 class="accordion-header" id="heading-3">
                                                <button class="accordion-button collapsed" type="button"
                                                    data-bs-toggle="collapse" data-bs-target="#linux-3"
                                                    aria-expanded="false">
                                                    هیدیفای نکست 
                                                </button>
                                            </h2>
                                            <div id="linux-3" class="accordion-collapse collapse"
                                                data-bs-parent="#linux-accordion">
                                                <div class="accordion-body pt-0">
                                                    <a><strong>لینک اشتراک هوشمند شما
                                                            سازگار با هیدیفای نکست:</strong></a><br>
                                                    <p>
                                                        <code class="copy btn-icon"
                                                            data-clipboard-text="{$UniversalSub}/clash">{$UniversalSub}/clash</code>
                                                        <a style="font-size: 90%;" class="copy btn-icon"
                                                            data-clipboard-text="{$UniversalSub}/clash">
                                                            کپی
                                                            <i class="ti ti-copy"></i>
                                                        </a>
                                                    </p>
                                                    <a>ابتدا نرم افزار هیدیفای نکست را از
                                                        لینک های
                                                        زیر
                                                        دانلود
                                                        کنید.</a>
                                                    <br>
                                                    <div style="margin-top: 5px;"
                                                        class="btn-list justify-content-start">
                                                        <a {if $config['enable_r2_client_download']}
                                                            href="/user/clients/hiddify-linux-x64.zip" {else}
                                                            href="https://github.com/hiddify/hiddify-next/releases/download/v2.1.5/Hiddify-Linux-x64.AppImage" target="_blank" rel="noopener noreferrer"{/if}
                                                            class="btn btn-azure">
                                                            دانلود هیدیفای نکست
                                                        </a>
                                                    </div>
                                                    <br>
                                                    <a>سپس کافیست تا بر روی دکمه <strong>افزودن خودکار</strong> کلیک
                                                        کنید و با
                                                        مشاهده
                                                        پنجره باز
                                                        شده در
                                                        مرورگر
                                                        بر
                                                        روی گزینه Open کلیک کنید تا لینک سرور به صورت خودکار به
                                                        نرم
                                                        افزار هیدیفای نکست
                                                        افزوده شود.</a>
                                                    <br>
                                                    <a style="margin-top: 5px;"
                                                        href="hiddify://install-config?url={$UniversalSub}/clash"
                                                        class="btn btn-primary">
                                                        افزودن خودکار به هیدیفای نکست
                                                    </a>

                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="accordion-item">
                                        <div class="accordion" id="linux-accordion">
                                            <h2 class="accordion-header" id="heading-1">
                                                <button class="accordion-button collapsed" type="button"
                                                    data-bs-toggle="collapse" data-bs-target="#linux-1"
                                                    aria-expanded="false">
                                                    CLASH (پیشنهادی)
                                                </button>
                                            </h2>
                                            <div id="linux-1" class="accordion-collapse collapse"
                                                data-bs-parent="#linux-accordion">
                                                <div class="accordion-body pt-0">
                                                    <a><strong>لینک اشتراک هوشمند شما برای تمامی کلاینت های
                                                            سازگار با کلش متا:</strong></a><br>
                                                    <p>
                                                        <code class="copy btn-icon"
                                                            data-clipboard-text="{$UniversalSub}/clash">{$UniversalSub}/clash</code>
                                                        <a style="font-size: 90%;" class="copy btn-icon"
                                                            data-clipboard-text="{$UniversalSub}/clash">
                                                            کپی
                                                            <i class="ti ti-copy"></i>
                                                        </a>
                                                    </p>
                                                    <a>ابتدا نرم افزار Clash Verge را با توجه به نوع سیستم عامل از
                                                        لینک های
                                                        زیر
                                                        دانلود
                                                        کنید.</a>
                                                    <br>
                                                    <div style="margin-top: 5px;"
                                                        class="btn-list justify-content-start">
                                                        <a {if $config['enable_r2_client_download']}
                                                            href="/user/clients/Clash.Verge.AppImage.tar.gz" {else}
                                                            href="https://github.com/zzzgydi/clash-verge/releases/download/v1.3.8/clash-verge_1.3.8_amd64.AppImage" target="_blank" rel=""noopener noreferrer"{/if} class="btn btn-azure">
                                                            دانلود Clash Verge
                                                        </a>
                                                    </div>
                                                    <br>
                                                    <a>سپس کافیست تا بر روی دکمه <strong>افزودن خودکار</strong> کلیک
                                                        کنید و
                                                        با
                                                        مشاهده
                                                        پنجره باز
                                                        شده در
                                                        مرورگر
                                                        بر
                                                        روی گزینه Open کلیک کنید تا لینک سرور به صورت خودکار به
                                                        نرم
                                                        افزار Clash
                                                        افزوده شود.</a>
                                                    <br>
                                                    <a style="margin-top: 5px;"
                                                        href="clash://install-config?url={$UniversalSub}/clash&name={$config['appName']}"
                                                        class="btn btn-primary">
                                                        افزودن خودکار به Clash
                                                    </a>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div {if $osFamily eq "Unix"} class="tab-pane active show" 
                                {else} class="tab-pane"
                                    {{/if}} id="config">
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
                                <div {if $osFamily eq "Mac"} class="tab-pane active show" 
                                {else} class="tab-pane"
                                    {{/if}} id="macos">
                                    <div class="accordion-item">
                                        <div class="accordion" id="mac-accordion">
                                            <h2 class="accordion-header" id="heading-3">
                                                <button class="accordion-button collapsed" type="button"
                                                    data-bs-toggle="collapse" data-bs-target="#mac-3"
                                                    aria-expanded="false">
                                                    هیدیفای نکست
                                                </button>
                                            </h2>
                                            <div id="mac-3" class="accordion-collapse collapse"
                                                data-bs-parent="#mac-accordion">
                                                <div class="accordion-body pt-0">
                                                    <a><strong>لینک اشتراک هوشمند شما
                                                            سازگار با هیدیفای نکست:</strong></a><br>
                                                    <p>
                                                        <code class="copy btn-icon"
                                                            data-clipboard-text="{$UniversalSub}/clash">{$UniversalSub}/clash</code>
                                                        <a style="font-size: 90%;" class="copy btn-icon"
                                                            data-clipboard-text="{$UniversalSub}/clash">
                                                            کپی
                                                            <i class="ti ti-copy"></i>
                                                        </a>
                                                    </p>
                                                    <a>ابتدا نرم افزار هیدیفای نکست را از
                                                        لینک های
                                                        زیر
                                                        دانلود
                                                        کنید.</a>
                                                    <br>
                                                    <div style="margin-top: 5px;"
                                                        class="btn-list justify-content-start">
                                                        <a {if $config['enable_r2_client_download']}
                                                            href="/user/clients/hiddify-macos-universal.zip" {else}
                                                            href="https://github.com/hiddify/hiddify-next/releases/download/v2.1.5/Hiddify-MacOS.dmg" target="_blank" rel="noopener noreferrer"{/if}
                                                            class="btn btn-azure">
                                                            دانلود هیدیفای نکست
                                                        </a>
                                                    </div>
                                                    <br>
                                                    <a>سپس کافیست تا بر روی دکمه <strong>افزودن خودکار</strong> کلیک
                                                        کنید و با
                                                        مشاهده
                                                        پنجره باز
                                                        شده در
                                                        مرورگر
                                                        بر
                                                        روی گزینه Open کلیک کنید تا لینک سرور به صورت خودکار به
                                                        نرم
                                                        افزار هیدیفای نکست
                                                        افزوده شود.</a>
                                                    <br>
                                                    <a style="margin-top: 5px;"
                                                        href="hiddify://install-config?url={$UniversalSub}/clash"
                                                        class="btn btn-primary">
                                                        افزودن خودکار به هیدیفای نکست
                                                    </a>

                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <!--<div class="accordion-item">
                                        <div class="accordion" id="mac-accordion">
                                            <h2 class="accordion-header" id="heading-2">
                                                <button class="accordion-button collapsed" type="button"
                                                    data-bs-toggle="collapse" data-bs-target="#mac-2"
                                                    aria-expanded="false">
                                                    SingBox
                                                </button>
                                            </h2>
                                            <div id="mac-2" class="accordion-collapse collapse"
                                                data-bs-parent="#mac-accordion">
                                                <div class="accordion-body pt-0">
                                                    <a><strong>لینک اشتراک هوشمند شما برای تمامی کلاینت های
                                                            سازگار با SingBox:</strong></a><br>
                                                    <p>
                                                        <code class="copy btn-icon"
                                                            data-clipboard-text="{$UniversalSub}/singbox">{$UniversalSub}/singbox</code>
                                                        <a style="font-size: 90%;" class="copy btn-icon"
                                                            data-clipboard-text="{$UniversalSub}/singbox">
                                                            کپی
                                                            <i class="ti ti-copy"></i>
                                                        </a>
                                                    </p>
                                                    <a>ابتدا نرم افزار SingBox را از
                                                        لینک های
                                                        زیر
                                                        دانلود
                                                        کنید.</a>
                                                    <br>
                                                    <div style="margin-top: 5px;"
                                                        class="btn-list justify-content-start">
                                                        <a {if $config['enable_r2_client_download']}
                                                            href="/user/clients/SFM.zip" {else} 
                                                            href="/clients/SFM.zip"
                                                            {/if} class="btn btn-azure">
                                                            دانلود SFM
                                                        </a>
                                                    </div>
                                                    <br>
                                                    <a>سپس کافیست تا بر روی دکمه <strong>افزودن خودکار</strong> کلیک
                                                        کنید و با
                                                        مشاهده
                                                        پنجره باز
                                                        شده در
                                                        مرورگر
                                                        بر
                                                        روی گزینه Open کلیک کنید تا لینک سرور به صورت خودکار به
                                                        نرم
                                                        افزار SingBox
                                                        افزوده شود.</a>
                                                    <br>
                                                    <a style="margin-top: 5px;"
                                                        href="sing-box://import-remote-profile?url={$UniversalSub}/singbox#{$config['appName']}"
                                                        class="btn btn-primary">
                                                        افزودن خودکار به SingBox
                                                    </a>

                                                </div>
                                            </div>
                                        </div>
                                    </div>-->
                                    <div class="accordion-item">
                                        <div class="accordion" id="mac-accordion">
                                            <h2 class="accordion-header" id="heading-1">
                                                <button class="accordion-button collapsed" type="button"
                                                    data-bs-toggle="collapse" data-bs-target="#mac-clash"
                                                    aria-expanded="false">
                                                    CLASH
                                                </button>
                                            </h2>
                                            <div id="mac-clash" class="accordion-collapse collapse">
                                                <br><br>
                                                <a><strong>لینک اشتراک هوشمند شما برای تمامی کلاینت های
                                                        سازگار با کلش متا:</strong></a><br>
                                                <p>
                                                    <code class="copy btn-icon"
                                                        data-clipboard-text="{$UniversalSub}/clash">{$UniversalSub}/clash</code>
                                                    <a style="font-size: 90%;" class="copy btn-icon"
                                                        data-clipboard-text="{$UniversalSub}/clash">
                                                        کپی
                                                        <i class="ti ti-copy"></i>
                                                    </a>
                                                </p>
                                                <a>ابتدا نرم افزار Clash Verge را با توجه به نوع سیستم عامل از
                                                    لینک های
                                                    زیر
                                                    دانلود
                                                    کنید.</a>
                                                <br>
                                                <div style="margin-top: 5px;" class="btn-list justify-content-start">
                                                    <a {if $config['enable_r2_client_download']}
                                                        href="/user/clients/Clash.Verge_x64.dmg" {else}
                                                        href="https://github.com/zzzgydi/clash-verge/releases/download/v1.3.8/Clash.Verge_1.3.8_x64.dmg" target="_blank" rel="noopener noreferrer" {/if} class="btn btn-azure">
                                                        دانلود (x86_64)
                                                    </a>
                                                    <a {if $config['enable_r2_client_download']}
                                                        href="/user/clients/Clash.Verge_aarch64.dmg" {else}
                                                        href="https://github.com/zzzgydi/clash-verge/releases/download/v1.3.8/Clash.Verge_1.3.8_aarch64.dmg" target="_blank" rel="noopener noreferrer"{/if}
                                                        class="btn btn-azure">
                                                        دانلود (aarch64)
                                                    </a>
                                                </div>
                                                <br>
                                                <a>سپس کافیست تا بر روی دکمه <strong>افزودن خودکار</strong> کلیک کنید و
                                                    با
                                                    مشاهده
                                                    پنجره باز
                                                    شده در
                                                    مرورگر
                                                    بر
                                                    روی گزینه Open کلیک کنید تا لینک سرور به صورت خودکار به
                                                    نرم
                                                    افزار Clash
                                                    افزوده شود.</a>
                                                <br>
                                                <a style="margin-top: 5px;"
                                                    href="clash://install-config?url={$UniversalSub}/clash&name={$config['appName']}"
                                                    class="btn btn-primary">
                                                    افزودن خودکار به Clash
                                                </a>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                {{if $public_setting['smart_dns']}}
                                    <div {if $osFamily eq "TV"} class="tab-pane active show" {else} class="tab-pane" {{/if}}
                                        id="dns">
                                        <div class="card">
                                            <div class="card-header" style="display: block;">
                                                <div style="text-align: center;">
                                                    <strong>برای استفاده از بشکن کافیه DNS رو تنظیم کنید</strong>
                                                    <br>
                                                    <div style="direction: ltr;">
                                                        {{if $public_setting['smart_dns_plain']}}
                                                            <p>
                                                                Plain DNS-1: <code class="copy btn-icon"
                                                                    data-clipboard-text="{$public_setting['smart_dns_plain_url_1']}">"{$public_setting['smart_dns_plain_url_1']}"</code>
                                                                <a style="font-size: 90%;" class="copy btn-icon"
                                                                    data-clipboard-text="{$public_setting['smart_dns_plain_url_1']}">
                                                                    <i class="ti ti-copy"></i>
                                                                    کپی
                                                                </a>
                                                            </p>
                                                            <p>
                                                                Plain DNS-2: <code class="copy btn-icon"
                                                                    data-clipboard-text="{$public_setting['smart_dns_plain_url_2']}">"{$public_setting['smart_dns_plain_url_2']}"</code>
                                                                <a style="font-size: 90%;" class="copy btn-icon"
                                                                    data-clipboard-text="{$public_setting['smart_dns_plain_url_2']}">
                                                                    <i class="ti ti-copy"></i>
                                                                    کپی
                                                                </a>
                                                            </p>
                                                        {{/if}}
                                                        {{if $public_setting['smart_dns_dot']}}
                                                            <p>
                                                                DNS-over-TLS: <code class="copy btn-icon"
                                                                    data-clipboard-text="{$public_setting['smart_dns_dot_url']}">"{$public_setting['smart_dns_dot_url']}"</code>
                                                                <a style="font-size: 90%;" class="copy btn-icon"
                                                                    data-clipboard-text="{$public_setting['smart_dns_dot_url']}">
                                                                    <i class="ti ti-copy"></i>
                                                                    کپی
                                                                </a>
                                                            </p>
                                                        {{/if}}
                                                        {{if $public_setting['smart_dns_doh']}}
                                                            <p>
                                                                DNS-over-Https: <code class="copy btn-icon"
                                                                    data-clipboard-text="{$public_setting['smart_dns_doh_url']}">{$public_setting['smart_dns_doh_url']}</code>
                                                                <a style="font-size: 90%;" class="copy btn-icon"
                                                                    data-clipboard-text="{$public_setting['smart_dns_doh_url']}">
                                                                    <i class="ti ti-copy"></i>
                                                                    کپی
                                                                </a>
                                                            </p>
                                                        {{/if}}
                                                        {{if $public_setting['smart_dns_dodtls']}}
                                                            <p>
                                                                DNS-over-DTLS: <code class="copy btn-icon"
                                                                    data-clipboard-text="{$public_setting['smart_dns_dodtls_url']}">{$public_setting['smart_dns_dodtls_url']}</code>
                                                                <a style="font-size: 90%;" class="copy btn-icon"
                                                                    data-clipboard-text="{$public_setting['smart_dns_dodtls_url']}">
                                                                    <i class="ti ti-copy"></i>
                                                                    کپی
                                                                </a>
                                                            </p>
                                                        {{/if}}
                                                        {{if $public_setting['smart_dns_doq']}}
                                                            <p>
                                                                DNS-over-DTLS: <code class="copy btn-icon"
                                                                    data-clipboard-text="{$public_setting['smart_dns_doq_url']}">{$public_setting['smart_dns_doq_url']}</code>
                                                                <a style="font-size: 90%;" class="copy btn-icon"
                                                                    data-clipboard-text="{$public_setting['smart_dns_doq_url']}">
                                                                    <i class="ti ti-copy"></i>
                                                                    کپی
                                                                </a>
                                                            </p>
                                                        {{/if}}
                                                    </div>
                                                </div>
                                                <div id="message" class="beshecan-result"></div>
                                            </div>
                                            <div class="card-body p-0">
                                                <div class="table-responsive">
                                                    <table id="data_table" class="table table-vcenter card-table"
                                                        width="100%">
                                                        <thead>
                                                            <tr>
                                                                <th style="width: unset;">آدرس IP</th>
                                                                <th style="width: unset;">سرور</th>
                                                                <th style="width: unset;">عملیات</th>
                                                            </tr>
                                                        </thead>
                                                    </table>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                {{/if}}
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
                                    <span>مصرف امروز {$user->TodayusedTraffic()}</span>
                                </div>
                                <div class="col-auto d-flex align-items-center ps-2">
                                    <span class="legend me-2"></span>
                                    <span>ترافیک باقی مانده {$user->unusedTraffic()}</span>
                                </div>
                            </div>
                            <p class="my-3">
                                {if $user->class === 0}
                                    بسته شما منقضی شده است . لطفا جهت خرید بسته به
                                    <a href="/user/product">فروشگاه</a>

                                    مراجعه فرمایید.
                                {else}
                                    سطح حساب شما {$user->class} و تا {$class_expire_days} روز دیگر معتبر است.
                                {/if}
                            </p>
                        </div>
                        <div class="card-body">

                        <div style="
                                display: flex;
                                flex-direction: row;
                                flex-wrap: nowrap;
                                align-content: center;
                                justify-content: flex-start;
                                align-items: baseline;
                            ">
                            <i class="ti ti-friends"></i>&nbsp;
                            <a class="card-title" href="/user/invite">دعوت از دوستان</a>
                        </div>

                            <div style="
                                display: flex;
                                flex-direction: row-reverse;
                                flex-wrap: nowrap;
                                align-content: center;
                                justify-content: space-between;
                            ">
                        <code class="copy btn-icon"
                        data-clipboard-text="{$invite_url}">{$invite_url}</code>
                                <a style="font-size: 90%;" class="copy btn-icon"
                                    data-clipboard-text="{$invite_url}">
                                    <i class="ti ti-copy"></i>
                                    کپی لینک
                                </a>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-lg-6 col-sm-12">
                    <div class="card">
                        <div class="ribbon ribbon-top bg-yellow">
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
                                    شما اطلاعیه خوانده نشده ندارید
                                {/if}
                            </p>
                        </div>
                    </div>
                </div>
                {if $public_setting['enable_checkin']}
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
                                    جهت دریافت حجم هدیه کلیک کنید
                                    {if $public_setting['checkin_min'] !== $public_setting['checkin_max']}
                                        در محدوده
                                        &nbsp;<code>{$public_setting['checkin_min']} MB</code> تا <code>{$public_setting['checkin_max']} MB</code>
                                    {else}
                                        <code>{$public_setting['checkin_min']} MB</code>
                                    {/if}
                                </p>
                                <p>
                                آخرین زمان دریافت:<code style="font-family: Yekan;" id="last-checkin-time">{$user->lastCheckInTime()}</code>
                                </p>
                            </div>
                            <div class="card-footer">
                                <div class="d-flex">
                                    {if ! $user->isAbleToCheckin()}
                                        <button id="check-in" class="btn btn-primary ms-auto" disabled>امروز استفاده
                                            شده</button>
                                    {else}
                                        {if $public_setting['enable_checkin_captcha']}
                                            {include file='captcha/div.tpl'}
                                        {/if}
                                        <button id="check-in" class="btn btn-primary ms-auto" hx-post="/user/checkin" hx-swap="none" hx-vals='js:{
                                                {if $public_setting['enable_checkin_captcha']}
                                                    {include file='captcha/ajax.tpl'}
                                                {/if}
                                                }'>
                                                بررسی
                                        </button>
                                    {/if}
                                </div>
                            </div>
                        </div>
                    </div>
                {{/if}}
            </div>
        </div>
    </div>

    {{if $public_setting['smart_dns_plain'] }}
        <script>
            var jqxhrc = jQuery.ajax("{$public_setting['smart_dns_check_url']}")
            .done(function() {
                    var jqxhrf = jQuery.ajax("https://block.panel.com?" + Math.random())
                        .done(function() {
                            jQuery('#message').html(
                                '<i class="ti ti-alert-circle icon"></i>هشدار! شما علاوه بر بشکن، از DNS دیگه‌ای هم استفاده می‌کنید که ممکنه مشکل‌ساز بشه!'
                            ).addClass('warning').removeClass('success');
                        })
                        .fail(function() {
                            jQuery('#message').html(
                                '<i class="ti ti-check-circle icon"></i> تبریک! شما در حال استفاده از بشکن هستید'
                            ).addClass('success');
                        })
                        .always(function() {});
                })
                .fail(function() {
                    var jqxhrf = jQuery.ajax("{$public_setting['smart_dns_fail_url']}")
                    .done(function() {
                            jQuery('#message').html(
                                '<i class="ti ti-info-circle icon"></i>هشدار! شما تنظیمات DNS را انجام داده اید اما IP شما احراز هویت نشده است . '
                            ).addClass('warning').removeClass('success');
                        })
                        .fail(function() {
                            jQuery('#message').html(
                                '<i class="ti ti-exclamation-circle icon"></i>بشکن برای شما فعال نیست! اگر تنظیمات را انجام داده‌اید، بخش <a href="https://bebeshcan.ir/faq/">پرسش‌های پرتکرار</a> را به دقت مطالعه کنید'
                            ).addClass('warning').removeClass('success');
                        })
                        .always(function() {});
                })
                .always(function() {});

            $.fn.dataTable.ext.errMode = 'none';
            var editor = new $.fn.dataTable.Editor({
                ajax: {
                    create: {
                        type: 'POST',
                        url: '/user/dns'
                    },
                    edit: {
                        type: 'PUT',
                        url: '/user/dns/_id_'
                    },
                    remove: {
                        type: 'DELETE',
                        url: '/user/dns/_id_'
                    }
                },
                table: '#data_table',
                idSrc: 'id',
                fields: [
                    { label: 'آدرس IP', name: 'ip' },
                    {
                        label: 'سرور انتخابی',
                        name: 'node.id',
                        type: 'select',
                        options: {$smarts} 
                    }
                ],
                i18n: {
                    create: {
                        button: "افزودن",
                        title: "افزودن IP جدید",
                        submit: "ثبت"
                    },
                    edit: {
                        button: "ویرایش",
                        title: "ویرایش آدرس IP",
                        submit: "ثبت"
                    },
                    remove: {
                        button: "حذف",
                        title: "حذف IP",
                        submit: "حذف",
                        confirm: {
                            _: "شما در حال حذف %d گزینه هستید. آیا تایید میفرمایید؟",
                            1: "شما در حال حذف یک گزینه هستید. آیا تایید میفرمایید؟",
                        }
                    },
                    error: {
                        system: "خطا در سرور! لطفا با پشتیبانی مطرح فرمایید."
                    },
                }
            });

            var table = $('#data_table')
                .DataTable({
                    ajax: {
                        url: "/user/dns/ajax",
                        type: "POST",
                        contentType: "application/json",
                        dataType: "json",
                        error: function(xhr, error, thrown) {
                            if (xhr.responseJSON.ret !== null && xhr.responseJSON.ret === 0) {
                                if (xhr.responseJSON.msg !== "") {
                                    alert("خطا " + xhr.status + " :" + xhr.responseJSON.msg);
                                } else {
                                    alert("خطا " + xhr.status + " :" + thrown);
                                }
                            } else {
                                alert(error + xhr.status + " : " + thrown);
                            }
                        }
                    },
                    columnDefs: [
                        { targets: "_all", defaultContent: "<b>بدون داده</b>" },
                    ],
                    dom: 'Brtip',
                    // data: ,
                    serverSide: false,
                    processing: false,
                    paging: false,
                    scrollCollapse: true,
                    columns: [
                        { data: 'ip', className: 'dt-body-right', orderable: false },
                        {
                            data: 'node.name',
                            className: 'dt-body-right',
                            orderable: false,
                            editField: "node.id",
                        },
                        {
                            data: null,
                            className: 'dt-body-right',
                            defaultContent: '<a href="" class="editor_remove">حذف</a>'
                        }
                    ],
                    select: false,
                    buttons: [
                        { extend: 'create', editor: editor },
                        // { extend: 'edit', editor: editor },
                        // {
                        //     extend: 'selectedSingle',
                        //     text: 'تغییر به IP فعلی',
                        //     action: function(e, dt, node, config) {
                        //         editor
                        //             .edit(table.row({ selected: true }).index(), false)
                        //             .set('ip', "127.0.0.1")
                        //             .submit();
                        //     }
                        // },
                        // { extend: 'remove', editor: editor },
                    ],
                });

            $('#data_table')
                .on('click', 'td:not(:last-child)', function() {
                    editor.bubble(this, ['ip', 'node.id'], {
                        buttons: [{
                                label: 'ثبت',
                                fn: function() {
                                    editor.submit();
                                }
                            },
                            {
                                text: 'ثبت آدرس ‌IP فعلی',
                                action: function() {
                                    editor
                                        .set('ip', "{$ip}")
                                        .submit();
                                }
                            },
                        ]
                    });
                })
                // Delete a record
                .on('click', 'a.editor_remove', function(e) {
                    e.preventDefault();

                    editor
                        .title('حذف گزینه')
                        .message('آیا از حذف این گزینه اطمینان دارید ؟')
                        .buttons({
                            label: 'حذف',
                            fn: function() {
                                editor.submit();
                            }
                        })
                        .remove($(this).closest('tr'));
                })
                .on('error.dt', function(e, settings, techNote, message) {
                    alert('خطا: ' + settings.jqXHR.responseJSON.error);
                    console.log('خطا: ' + settings.jqXHR.responseJSON.error);
                })
                .DataTable();

            var openVals;
            editor
                .on('open', function(e, type) {
                    openVals = JSON.stringify(editor.get());
                })
                .on('preBlur', function(e) {
                    if (openVals !== JSON.stringify(editor.get())) {
                        return confirm('شما یک تغییر ذخیره نشده دارید! آیا از خروج اطمینان دارید؟');
                    }
                })
                .on('submitSuccess', function() {
                    table.ajax.reload();
                    alert('تغییرات با موفقیت ذخیره شد.');
                })
                .on('submitError', function() {
                    alert('متاسفانه خطایی رخ داده! لطفا مجددا تلاش کنید و یا به پشتیبانی گزارش دهید.');
                    table.ajax.reload();
                });
        </script>
    {{/if}}

    {if $public_setting['enable_checkin_captcha'] && $user->isAbleToCheckin()}
        {include file='captcha/js.tpl'}
    {/if}


{include file='user/footer.tpl'}