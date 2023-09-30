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
                                <a href="#sub" data-bs-toggle="tab" {if $os eq "Unknown"} class="nav-link active" 
                                {else}
                                    class="nav-link" {/if}>
                                    <i class="ti ti-rss icon"></i>
                                    &nbsp;پروفایل ها
                                </a>
                            </li>
                            {if $public_setting['enable_traditional_sub']}
                                <li class="nav-item">
                                    <a href="#traditional-sub" class="nav-link" data-bs-toggle="tab">
                                        <i class="ti ti-rss icon"></i>
                                        &nbsp;پراکسی ها
                                    </a>
                                </li>
                            {/if}
                            <li class="nav-item">
                                <a href="#windows" {if $os eq "Windows"} class="nav-link active" 
                                {else} class="nav-link"
                                    {/if} data-bs-toggle="tab">
                                    <i class="ti ti-brand-windows icon"></i>
                                    &nbsp;ویندوز
                                </a>
                            </li>
                            <li class="nav-item">
                                <a href="#macos" {if $os eq "Mac"} class="nav-link active" {else} class="nav-link" {/if}
                                    data-bs-toggle="tab">
                                    <i class="ti ti-brand-finder icon"></i>
                                    &nbsp;مکینتاش
                                </a>
                            </li>
                            <li class="nav-item">
                                <a href="#android" {if $os eq "Droid"} class="nav-link active" 
                                {else} class="nav-link"
                                    {/if} data-bs-toggle="tab">
                                    <i class="ti ti-brand-android icon"></i>
                                    &nbsp;اندروید
                                </a>
                            </li>
                            <li class="nav-item">
                                <a href="#ios" {if $os eq "iPhone"} class="nav-link active" 
                                {else} class="nav-link"
                                    {/if} data-bs-toggle="tab">
                                    <i class="ti ti-brand-apple icon"></i>
                                    &nbsp;آی او اس
                                </a>
                            </li>
                            <li class="nav-item">
                                <a href="#linux" {if $os eq "Linux"} class="nav-link active" 
                                {else} class="nav-link"
                                    {/if} data-bs-toggle="tab">
                                    <i class="ti ti-brand-redhat icon"></i>
                                    &nbsp;لینوکس
                                </a>
                            </li>
                            <li class="nav-item">
                                <a href="#config" {if $os eq "Unix"} class="nav-link active" 
                                {else} class="nav-link"
                                    {/if} data-bs-toggle="tab">
                                    <i class="ti ti-file-text icon"></i>
                                    &nbsp;تنظیمات
                                </a>
                            </li>
                        </ul>
                        <div class="card-body">
                            <div class="tab-content">

                                <div {if $os eq "Unknown"} class="tab-pane active show" {else} class="tab-pane" {{/if}}
                                    id="sub">
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
                                {if $public_setting['enable_traditional_sub']}
                                    <div class="tab-pane show" id="traditional-sub">
                                        <div style="direction: ltr;">
                                            {if $public_setting['enable_ss_sub']}
                                                <p>
                                                    Shadowsocks: <code class="copy btn-icon"
                                                        data-clipboard-text="{$TraditionalSub}?ss=1">{$TraditionalSub}?ss=1</code>
                                                    <a style="font-size: 90%;" class="copy btn-icon"
                                                        data-clipboard-text="{$TraditionalSub}?ss=1">
                                                        <i class="ti ti-copy"></i>
                                                        کپی
                                                    </a>
                                                </p>
                                                <p>
                                                    Shadowsocks SIP002: <code class="copy btn-icon"
                                                        data-clipboard-text="{$TraditionalSub}?sip002=1">{$TraditionalSub}?sip002=1</code>
                                                    <a style="font-size: 90%;" class="copy btn-icon"
                                                        data-clipboard-text="{$TraditionalSub}?sip002=1">
                                                        <i class="ti ti-copy"></i>
                                                        کپی
                                                    </a>
                                                </p>
                                            {/if}
                                            {if $public_setting['enable_v2_sub']}
                                                <p>
                                                    V2Ray: <code class="copy btn-icon"
                                                        data-clipboard-text="{$TraditionalSub}?v2ray=1">{$TraditionalSub}?v2ray=1</code>
                                                    <a style="font-size: 90%;" class="copy btn-icon"
                                                        data-clipboard-text="{$TraditionalSub}?v2ray=1">
                                                        <i class="ti ti-copy"></i>
                                                        کپی
                                                    </a>
                                                </p>
                                            {/if}
                                            {if $public_setting['enable_trojan_sub']}
                                                <p>
                                                    Trojan: <code class="copy btn-icon"
                                                        data-clipboard-text="{$TraditionalSub}?trojan=1">{$TraditionalSub}?trojan=1</code>
                                                    <a style="font-size: 90%;" class="copy btn-icon"
                                                        data-clipboard-text="{$TraditionalSub}?trojan=1">
                                                        <i class="ti ti-copy"></i>
                                                        کپی
                                                    </a>
                                                </p>
                                            {/if}
                                        </div>
                                    </div>
                                {/if}
                                <div {if $os eq "Windows"} class="tab-pane active show" {else} class="tab-pane" {{/if}}
                                    id="windows">
                                    <div class="accordion-item">
                                        <div class="accordion" id="windows-accordion">
                                            <h2 class="accordion-header" id="heading-1">
                                                <button class="accordion-button collapsed" type="button"
                                                    data-bs-toggle="collapse" data-bs-target="#win-1"
                                                    aria-expanded="false">
                                                    CLASH (پیشنهادی)
                                                </button>
                                            </h2>
                                            <div id="win-1" class="accordion-collapse collapse"
                                                data-bs-parent="#windows-accordion">
                                                <div class="accordion-body pt-0">


                                                    <a class="btn btn-primary" data-bs-toggle="offcanvas"
                                                        href="#offcanvasEnd" role="button" aria-controls="offcanvasEnd"
                                                        style="background-color: green">
                                                        آموزش نصب و استفاده از iClash
                                                    </a>
                                                    {include file='user/knowledge/iClash.tpl' ros="all"}
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
                                                    <div style="margin-top: 5px;"
                                                        class="btn-list justify-content-start">
                                                        <a {if $config['enable_r2_client_download']}
                                                            href="/user/clients/Clash.Verge.exe" {else}
                                                            href="/clients/Clash.Verge.exe" {/if} class="btn btn-azure">
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
                                    <div class="accordion-item">
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
                                                    {include file='user/knowledge/i2RayN.tpl'}

                                                    <a class="btn btn-primary" data-bs-toggle="offcanvas"
                                                        href="#offcanvasEnd" role="button" aria-controls="offcanvasEnd"
                                                        style="background-color: green;">
                                                        آموزش نصب و استفاده از iClash
                                                    </a>
                                                    {include file='user/knowledge/iClash.tpl' ros="all"}
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
                                                    <div style="margin-top: 5px;"
                                                        class="btn-list justify-content-start">
                                                        <a {if $config['enable_r2_client_download']}
                                                            href="/user/clients/Clash.Verge_x64.dmg" {else}
                                                            href="/clients/Clash.Verge_x64.dmg" {/if}
                                                            class="btn btn-azure">
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
                                    </div>
                                </div>
                                <div {if $os eq "Mac"} class="tab-pane active show" {else} class="tab-pane" {{/if}}
                                    id="macos">
                                    <div class="accordion-item">
                                        <div class="accordion" id="mac-accordion">
                                            <h2 class="accordion-header" id="heading-2">
                                                <button class="accordion-button collapsed" type="button"
                                                    data-bs-toggle="collapse" data-bs-target="#mac-2"
                                                    aria-expanded="false">
                                                    SingBox (پیشنهادی)
                                                </button>
                                            </h2>
                                            <div id="mac-2" class="accordion-collapse collapse"
                                                data-bs-parent="#mac-accordion">
                                                <div class="accordion-body pt-0">
                                                    <a class="btn btn-primary" data-bs-toggle="offcanvas"
                                                        href="#offcanvasEnd" role="button" aria-controls="offcanvasEnd"
                                                        style="background-color: green;">
                                                        آموزش نصب و استفاده از SingBox
                                                    </a>
                                                    {include file='user/knowledge/iClash.tpl' ros="all"}
                                                    <br><br>
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
                                                            href="/user/clients/SFM.zip" {else} href="/clients/SFM.zip"
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
                                    </div>
                                    <div class="accordion-item">
                                        <div class="accordion" id="mac-accordion">
                                            <h2 class="accordion-header" id="heading-1">
                                                <button class="accordion-button collapsed" type="button"
                                                    data-bs-toggle="collapse" data-bs-target="#mac-1"
                                                    aria-expanded="false">
                                                    CLASH
                                                </button>
                                            </h2>
                                            <div id="mac-1" class="accordion-collapse collapse">
                                                <a class="btn btn-primary" data-bs-toggle="offcanvas"
                                                    href="#offcanvasEnd" role="button" aria-controls="offcanvasEnd"
                                                    style="background-color: green;">
                                                    آموزش نصب و استفاده از iClash
                                                </a>
                                                {include file='user/knowledge/iClash.tpl' ros="all"}
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
                                                        href="/clients/Clash.Verge_x64.dmg" {/if} class="btn btn-azure">
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
                                <div {if $os eq "Droid"} class="tab-pane active show" {else} class="tab-pane" {{/if}}
                                    id="android">
                                    <div class="accordion-item">
                                        <div class="accordion" id="droid-accordion">
                                            <h2 class="accordion-header" id="heading-1">
                                                <button class="accordion-button collapsed" type="button"
                                                    data-bs-toggle="collapse" data-bs-target="#droid-1"
                                                    aria-expanded="false">
                                                    SingBox (پیشنهادی)
                                                </button>
                                            </h2>
                                            <div id="droid-1" class="accordion-collapse collapse"
                                                data-bs-parent="#droid-accordion">
                                                <div class="accordion-body pt-0">
                                                    <a class="btn btn-primary" data-bs-toggle="offcanvas"
                                                        href="#offcanvasEnd" role="button" aria-controls="offcanvasEnd"
                                                        style="background-color: green;">
                                                        آموزش نصب و استفاده از SingBox
                                                    </a>
                                                    {include file='user/knowledge/iClash.tpl' ros="all"}
                                                    <br><br>
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
                                                            href="/user/clients/SFA.apk" {else} href="/clients/SFA.apk"
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
                                                <a class="btn btn-primary" data-bs-toggle="offcanvas"
                                                    href="#offcanvasEnd" role="button" aria-controls="offcanvasEnd"
                                                    style="background-color: green;">
                                                    آموزش نصب و استفاده از iClash
                                                </a>
                                                {include file='user/knowledge/iClash.tpl' ros="all"}
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
                                                        href="/user/clients/Clash-Android.apk" {else}
                                                        href="/clients/Clash-Android.apk" {/if} class="btn btn-azure">
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
                                <div {if $os eq "iPhone"} class="tab-pane active show" {else} class="tab-pane" {{/if}}
                                    id="ios">
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
                                                    <a class="btn btn-primary" data-bs-toggle="offcanvas"
                                                        href="#offcanvasEnd" role="button" aria-controls="offcanvasEnd"
                                                        style="background-color: green;">
                                                        آموزش نصب و استفاده از SingBox
                                                    </a>
                                                    {include file='user/knowledge/iClash.tpl' ros="all"}
                                                    <br><br>
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
                                                    href="#offcanvasEndShadowrocket" role="button"
                                                    aria-controls="offcanvasEndShadowrocket"
                                                    style="background-color: green;">
                                                    آموزش نصب و استفاده از ShadowRocket
                                                </a>
                                                {include file='user/knowledge/shadowRocket.tpl' ros="all"}
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
                                                <a class="btn btn-primary" data-bs-toggle="offcanvas"
                                                    href="#offcanvasEndStash" role="button"
                                                    aria-controls="offcanvasEndStash" style="background-color: green;">
                                                    آموزش نصب و استفاده از Stash
                                                </a>
                                                {include file='user/knowledge/stash.tpl' ros="all"}
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
                                <div {if $os eq "Linux"} class="tab-pane active show" {else} class="tab-pane" {{/if}}
                                    id="linux">
                                    <a class="btn btn-primary" data-bs-toggle="offcanvas"
                                                    href="#offcanvasEnd" role="button" aria-controls="offcanvasEnd"
                                                    style="background-color: green;">
                                                    آموزش نصب و استفاده از iClash
                                                </a>
                                                {include file='user/knowledge/iClash.tpl' ros="all"}
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
                                                    href="/user/clients/Clash.Verge.AppImage.tar.gz" {else}
                                                    href="/clients/Clash.Verge.AppImage.tar.gz" {/if} class="btn btn-azure">
                                                    دانلود Clash Verge
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
                                <div {if $os eq "Unix"} class="tab-pane active show" {else} class="tab-pane" {{/if}}
                                    id="config">
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
                                    بسته شما منقضی شده است . لطفا جهت خرید بسته به <a href="/user/product">فروشگاه</a>
                                    مراجعه فرمایید.
                                {else}
                                    LV شما حساب {$user->class} در {$class_expire_days} روز دیگر منقضی می‌شود
                                    ({$user->class_expire})
                                {/if}
                            </p>
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
                                    جهت دریافت حجم هدیه کلیک کنید
                                    {if $config['checkinMin'] !== $config['checkinMax']}
                                        در محدوده
                                        &nbsp;<code>{$config['checkinMin']} MB</code> تا <code>{$config['checkinMax']} MB</code>
                                    {else}
                                        <code>{$config['checkinMin']} MB</code>
                                    {/if}
                                </p>
                                <p>
                                    آخرین زمان استفاده：<code style="font-family: Yekan;">{$user->lastCheckInTime()}</code>
                                </p>
                            </div>
                            <div class="card-footer">
                                <div class="d-flex">
                                    {if ! $user->isAbleToCheckin()}
                                        <button id="check-in" class="btn btn-primary ms-auto" disabled>بررسی</button>
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