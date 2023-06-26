<style>
    .offcanvas,
    .offcanvas-lg,
    .offcanvas-md,
    .offcanvas-sm,
    .offcanvas-xl,
    .offcanvas-xxl {
        --tblr-offcanvas-width: 720px;
    }
</style>
<div class="offcanvas offcanvas-end" tabindex="-1" id="offcanvasEnd" aria-labelledby="offcanvasEndLabel">
    <div class="offcanvas-header">
        <h2 class="offcanvas-title" id="offcanvasEndLabel">>آموزش کار با نرم‌افزار shadowrocket</h2>
        <button type="button" class="btn-close text-reset" data-bs-dismiss="offcanvas" aria-label="Close"></button>
    </div>
    <div class="offcanvas-body">
        <div>
            <h2>آموزش کار با نرم‌افزار ShadowRocket</h2>
            <p style="text-align: justify;"><strong>ShadowRocket</strong> یکی از بهترین نرم افزارهای غیررایگان برای
                اتصال به پراکسی های مبتنی بر Xray برای کاربران ios می باشد .
            </p>
            <div class="note" style="text-align: justify;">
                <i class="ti ti-message-2" style="color: green;"></i> در اینجا نیاز است با مفهومی به اسم <strong>پروفایل
                    (Profile)</strong>
                آشنا شوید.
                <strong>پروفایل (Profile)</strong> یک فایل متنی با پسوند <strong>yaml</strong> شامل تمامی تنظیمات و
                کانکشن‌های مورد نیاز نرم افزار های
                مبتنی بر کلش (متا) می باشد.
            </div>

            <div class="tab-pane active show" id="shadowrocket">

                <div class="accordion-item">
                    <div class="accordion" id="shadowrocket-accordion">
                        <h2 class="accordion-header" id="shadowrocket-heading-1">
                            <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse"
                                data-bs-target="#shadowrocket-collapse-1" aria-expanded="false">
                                دانلود و نصب نرم افزار
                            </button>
                        </h2>
                        <div id="shadowrocket-collapse-1" class="accordion-collapse collapse"
                            data-bs-parent="#shadowrocket-accordion" style="margin:  20px;">
                            <p style="text-align: justify;"> ابتدا نرم افزار shadowrocket را از لینک های
                                زیر
                                دانلود
                                کنید.</p>


                            <div class="btn-list justify-content-start">
                                <a href="/clients/Clash-Android.apk" class="btn btn-primary">

                                    <i class="ti ti-brand-android icon"></i>
                                    &nbsp;دانلود shadowrocket برای اندروید
                                </a>
                            </div>
                            <div>
                                <br>
                                <h3>نصب نرم افزار</h3>
                                <div style="margin: 15px;">
                                    <h4>نصب در ویندوز</h4>
                                    <p style="text-align: justify;">برای نصب برنامه فایل دانلود شده را اجرا کنید. ممکن
                                        است خطای ناشناخته بودن منبع فایل را بدهد که می‌توانید آن را تایید کنید تا فایل
                                        نصب گردد.</p>
                                </div>
                            </div>

                            </p>

                        </div>
                    </div>
                </div>
                <div class="accordion-item">
                    <h2 class="accordion-header" id="shadowrocket-heading-2">
                        <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse"
                            data-bs-target="#shadowrocket-collapse-2" aria-expanded="false">
                            افزودن پروفایل به نرم‌افزار (Profile)
                        </button>
                    </h2>
                    <div id="shadowrocket-collapse-2" class="accordion-collapse collapse"
                        data-bs-parent="#shadowrocket-accordion">
                        <div class="accordion-body pt-0">
                            <strong>جهت افزودن پروفایل می توانید از یکی از روش های زیر استفاده کنید.</strong>
                            <br>
                            <br>
                            <div class="tab-pane active show" id="shadowrocket-ins">
                                <div class="accordion-item">
                                    <div class="accordion" id="shadowrocket-ins-accordion">
                                        <h2 class="accordion-header" id="shadowrocket-ins-heading-1">
                                            <button class="accordion-button collapsed" type="button"
                                                data-bs-toggle="collapse" data-bs-target="#shadowrocket-ins-collapse-1"
                                                aria-expanded="false">
                                                نصب خودکار (پیشنهادی)
                                            </button>
                                        </h2>
                                        <div id="shadowrocket-ins-collapse-1" class="accordion-collapse collapse"
                                            style="margin: 20px;" data-bs-parent="#shadowrocket-ins-accordion">
                                            <p style="text-align: justify;">جهت نصب به صورت <strong>خودکار</strong> فقط
                                                کافیست تا بر روی دکمه زیر
                                                کلیک کنید تا پروفایل (Profile) به صورت خودکار به نرم افزار افزوده شود .
                                            </p>
                                            <a href="shadowrocket://config/add/{$UniversalSub}/clash&name={$config['appName']}"
                                                class="btn btn-primary">
                                                جهت نصب خودکار کلیک کنید
                                            </a>
                                        </div>
                                    </div>
                                </div>
                                <div class="accordion-item">
                                    <div class="accordion" id="shadowrocket-ins-accordion-2">
                                        <h2 class="accordion-header" id="shadowrocket-ins-heading-2">
                                            <button class="accordion-button collapsed" type="button"
                                                data-bs-toggle="collapse" data-bs-target="#shadowrocket-ins-collapse-2"
                                                aria-expanded="false">
                                                نصب دستی
                                            </button>
                                        </h2>
                                        <div id="shadowrocket-ins-collapse-2" class="accordion-collapse collapse"
                                            data-bs-parent="#shadowrocket-ins-accordion">
                                            <div class="accordion-body pt-0">
                                                <div style="margin: 15px;">
                                                    <p style="text-align: justify;">در زیر بر روی دکمه
                                                        کپی لینک اشتراک کلیک کنید و پس از کپی کردن لینک ، وارد برنامه
                                                        شدوراکت شوید و از گوشه سمت راست بالا، دکمه `+` را بزنید.
                                                    </p>
                                                    <div class="accordion-body pt-0">
                                                        <p>
                                                            <br>
                                                            <code>{$UniversalSub}/clash</code>
                                                        </p>
                                                        <a data-clipboard-text="{$UniversalSub}/clash"
                                                            class="copy btn btn-primary">
                                                            کپی لینک اشتراک
                                                        </a>
                                                    </div>
                                                    <div align=center>
                                                        <img width=30%
                                                            src="https://github.com/hiddify/hiddify-config/assets/125398461/d116347f-31bc-4ca9-a1fc-bdb9364e5e74" />
                                                    </div>
                                                    <p>سپس در صفحه باز شده‌ `Type` را روی `Subscribe` قرار دهید و سپس
                                                        لینک را در قسمت `URL` کپی کنید و `Save` را بزنید. با ذخیره این
                                                        لینک، تمامی کانکشن‌ها در برنامه بارگذاری می‌شوند.</p>
                                                    <div align=center>
                                                        <img width=30%
                                                            src="https://github.com/hiddify/hiddify-config/assets/125398461/c087970e-aebc-479d-8b8a-bc54a78cc7f8" />
                                                    </div>
                                                </div>
                                            </div>

                                            </p>
                                        </div>
                                    </div>
                                </div>
                                <div class="accordion-item">
                                    <div class="accordion" id="shadowrocket-ins-accordion-3">
                                        <h2 class="accordion-header" id="shadowrocket-ins-heading-3">
                                            <button class="accordion-button collapsed" type="button"
                                                data-bs-toggle="collapse" data-bs-target="#shadowrocket-ins-collapse-3"
                                                aria-expanded="false">
                                                اضافه کردن لینک با استفاده از QR code
                                            </button>
                                        </h2>
                                        <div id="shadowrocket-ins-collapse-3" class="accordion-collapse collapse"
                                            data-bs-parent="#shadowrocket-ins-accordion">
                                            <div class="accordion-body pt-0">
                                                <div style="margin: 15px;">
                                                    <p style="text-align: justify;">برای این کار در صفحه اصلی روی دکمه
                                                        اسکنر مثل شکل زیر کلیک کنید.
                                                    </p>
                                                    <div align=center>
                                                        <img width=30%
                                                            src="https://github.com/hiddify/hiddify-config/assets/125398461/cee3abfe-db05-4e2c-925d-fa57010d3465" />
                                                    </div>
                                                    <p style="text-align: justify;">QR code مورد نظر را اسکن کنید تا پروفایل به برنامه اضافه گردد.
                                                    </p>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="accordion-item">
                    <h2 class="accordion-header" id="shadowrocket-heading-3">
                        <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse"
                            data-bs-target="#shadowrocket-collapse-3" aria-expanded="false">
                            تست کانکشن‌ها
                        </button>
                    </h2>
                    <div id="shadowrocket-collapse-3" class="accordion-collapse collapse"
                        data-bs-parent="#shadowrocket-accordion">
                        <div class="accordion-body pt-0">
                            <div style="margin: 15px;">
                                <p style="text-align: justify;">برای تست کانکشن‌ها کافیه در صفحه اصلی برنامه روی
                                    `Connectivity Test` کلیک کنید.</p>
                                <div align=center>

                                    <img width=30%
                                        src="https://github.com/hiddify/hiddify-config/assets/125398461/49a37a3c-b1f7-48ba-91e2-0a4ac7dc3e5f" />
                                </div>
                                <p style="text-align: justify;">اگر می‌خواهید تست کانفیگ‌ها واقعی‌تر باشد، در منوهای
                                    پایین وارد `Settings` شوید و سپس `Test Method` را روی `Connect` قرار دهید. حالا اگه
                                    تست بگیرید نتایج واقعی‌تری نشان داده خواهد شد.</p>
                                <div align=center>

                                    <img width=30%
                                        src="https://github.com/hiddify/hiddify-config/assets/125398461/8760fd19-9056-4c0c-a4a0-aeebd728656f" />
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="accordion-item">
                    <h2 class="accordion-header" id="shadowrocket-heading-4">
                        <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse"
                            data-bs-target="#shadowrocket-collapse-4" aria-expanded="false">
                            آپدیت پروفایل
                        </button>
                    </h2>
                    <div id="shadowrocket-collapse-4" class="accordion-collapse collapse"
                        data-bs-parent="#shadowrocket-accordion">
                        <div class="accordion-body pt-0">
                            <div style="margin: 15px;">
                                <p style="text-align: justify;">جبرای این کار کافیه روی علام آپدیت بالای کانفیگ‌های مربو
                                    به هر لینک تپ کنید. لینک‌ها و کانفیگ‌ها بر اساس آخرین اطلاعات روی سرور آپدیت خواهند
                                    شد.</p>
                                <div align=center>

                                    <img width=30%
                                        src="https://github.com/hiddify/hiddify-config/assets/125398461/0878e805-a24e-4f19-831a-f526b475db4a" />
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="accordion-item">
                    <h2 class="accordion-header" id="shadowrocket-heading-5">
                        <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse"
                            data-bs-target="#shadowrocket-collapse-5" aria-expanded="false">
                            سایر تنظیمات
                        </button>
                    </h2>
                    <div id="shadowrocket-collapse-5" class="accordion-collapse collapse"
                        data-bs-parent="#shadowrocket-accordion">
                        <div class="accordion-body pt-0">
                            <div style="margin: 15px;">
                                <div class="tab-pane active show" id="shadowrocket-settings">
                                    <div class="accordion-item">
                                        <div class="accordion" id="shadowrocket-settings-accordion">
                                            <h2 class="accordion-header" id="shadowrocket-settings-heading-1">
                                                <button class="accordion-button collapsed" type="button"
                                                    data-bs-toggle="collapse"
                                                    data-bs-target="#shadowrocket-settings-collapse-1"
                                                    aria-expanded="false">
                                                    تنظیمات سابسکرایب برنامه
                                                </button>
                                            </h2>
                                            <div id="shadowrocket-settings-collapse-1"
                                                class="accordion-collapse collapse" style="margin: 20px;"
                                                data-bs-parent="#shadowrocket-settings-accordion">
                                                <div class="accordion-body pt-0">
                                                    <div style="margin: 15px;">
                                                        <p style="text-align: justify;">در منوی `Settings` در قسمت پایین
                                                            گزینه `Subscribe` را
                                                            انتخاب نمایید.</p>
                                                        <div class="tab-pane active show" id="shadowrocket-prof">
                                                            <div class="accordion-item">
                                                                <div class="accordion" id="shadowrocket-prof-accordion">
                                                                    <h2 class="accordion-header"
                                                                        id="shadowrocket-prof-heading-1">
                                                                        <button class="accordion-button collapsed"
                                                                            type="button" data-bs-toggle="collapse"
                                                                            data-bs-target="#shadowrocket-prof-collapse-1"
                                                                            aria-expanded="false">
                                                                            آپدیت شدن خودکار هنام باز شدن برنامه
                                                                        </button>
                                                                    </h2>
                                                                    <div id="shadowrocket-prof-collapse-1"
                                                                        class="accordion-collapse collapse"
                                                                        style="margin: 20px;"
                                                                        data-bs-parent="#shadowrocket-prof-accordion">
                                                                        <p style="text-align: justify;">برای این کار در
                                                                            `Subscribe` گزینه
                                                                            `Update on Open` را انتخاب نمایید.
                                                                        </p>
                                                                        <div align=center>
                                                                            <img width=30%
                                                                                src="https://github.com/hiddify/hiddify-config/assets/125398461/aeb08d16-20d3-424e-8c6d-7d13f06aeb8d" />
                                                                        </div>

                                                                    </div>
                                                                </div>
                                                            </div>
                                                            <div class="accordion-item">
                                                                <div class="accordion"
                                                                    id="shadowrocket-prof-accordion-2">
                                                                    <h2 class="accordion-header"
                                                                        id="shadowrocket-prof-heading-2">
                                                                        <button class="accordion-button collapsed"
                                                                            type="button" data-bs-toggle="collapse"
                                                                            data-bs-target="#shadowrocket-prof-collapse-2"
                                                                            aria-expanded="false">
                                                                            آپدیت خودکار
                                                                        </button>
                                                                    </h2>
                                                                    <div id="shadowrocket-prof-collapse-2"
                                                                        class="accordion-collapse collapse"
                                                                        data-bs-parent="#shadowrocket-prof-accordion">
                                                                        <div class="accordion-body pt-0">
                                                                            <div style="margin: 15px;">
                                                                                <p style="text-align: justify;">برای
                                                                                    آپدیت خودکار لینک‌ها در
                                                                                    بازه‌های زمانی مشخص گزینه `Auto
                                                                                    Background Update` را روشن
                                                                                    نمایید.
                                                                                </p>


                                                                                <div align=center>
                                                                                    <img width=30%
                                                                                        src="https://github.com/hiddify/hiddify-config/assets/125398461/97540ef0-399f-4260-85a1-af0c0594533b" />
                                                                                </div>
                                                                            </div>
                                                                        </div>

                                                                        </p>
                                                                    </div>
                                                                </div>
                                                            </div>
                                                            <div class="accordion-item">
                                                                <div class="accordion"
                                                                    id="shadowrocket-prof-accordion-3">
                                                                    <h2 class="accordion-header"
                                                                        id="shadowrocket-prof-heading-3">
                                                                        <button class="accordion-button collapsed"
                                                                            type="button" data-bs-toggle="collapse"
                                                                            data-bs-target="#shadowrocket-prof-collapse-3"
                                                                            aria-expanded="false">
                                                                            مرتب‌سازی بر اساس پینگ
                                                                        </button>
                                                                    </h2>
                                                                    <div id="shadowrocket-prof-collapse-3"
                                                                        class="accordion-collapse collapse"
                                                                        data-bs-parent="#shadowrocket-prof-accordion">
                                                                        <div class="accordion-body pt-0">
                                                                            <div style="margin: 15px;">
                                                                                <p style="text-align: justify;">اگر
                                                                                    بخواهید بر اساس نتیجه تست
                                                                                    پینگ کانفیگ‌ها مرتب شوند گزینه `Sort
                                                                                    by ping` را انتخاب
                                                                                    نمایید.
                                                                                </p>
                                                                                <div align=center>
                                                                                    <img width=30%
                                                                                        src="https://github.com/hiddify/hiddify-config/assets/125398461/afeb9a4d-a12f-49f1-aca7-f5eae5c6bed2" />
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
                                        </div>
                                    </div>
                                    <div class="accordion-item">
                                        <div class="accordion" id="shadowrocket-settings-accordion-2">
                                            <h2 class="accordion-header" id="shadowrocket-settings-heading-2">
                                                <button class="accordion-button collapsed" type="button"
                                                    data-bs-toggle="collapse"
                                                    data-bs-target="#shadowrocket-settings-collapse-2"
                                                    aria-expanded="false">
                                                    جلوگیری از نشتی آیپی
                                                </button>
                                            </h2>
                                            <div id="shadowrocket-settings-collapse-2"
                                                class="accordion-collapse collapse"
                                                data-bs-parent="#shadowrocket-settings-accordion">
                                                <div class="accordion-body pt-0">
                                                    <div style="margin: 15px;">
                                                        <p style="text-align: justify;">برای این کار در `Settings` و در
                                                            بخش `UDP` گزینه `Disable
                                                            STUN` را فعال نمایید.
                                                        </p>
                                                        <div align=center>

                                                            <img width=30%
                                                                src="https://github.com/hiddify/hiddify-config/assets/125398461/3bd81556-4119-4659-8db7-0826bbdbd6ee" />
                                                        </div>

                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="accordion-item">
                                        <div class="accordion" id="shadowrocket-settings-accordion-3">
                                            <h2 class="accordion-header" id="shadowrocket-settings-heading-3">
                                                <button class="accordion-button collapsed" type="button"
                                                    data-bs-toggle="collapse"
                                                    data-bs-target="#shadowrocket-settings-collapse-3"
                                                    aria-expanded="false">
                                                    رفع مشکل صدا در برخی برنامه‌ها
                                                </button>
                                            </h2>
                                            <div id="shadowrocket-settings-collapse-3"
                                                class="accordion-collapse collapse"
                                                data-bs-parent="#shadowrocket-settings-accordion">
                                                <div class="accordion-body pt-0">
                                                    <div style="margin: 15px;">
                                                        <p style="text-align: justify;">بعضی وقت‌ها ممکنه برای شما اتفاق
                                                            افتاده باشه که در بعضی
                                                            برنامه‌ها مثل Club House صدا پخش نمی‌شود. برای رفع این مشکل
                                                            می‌توانید از `Setting`
                                                            وارد `TCP` شوید و سپس `Fingerprint` خود را تغییر دهید.
                                                        </p>
                                                        <div align=center>

                                                            <img width=30%
                                                                src="https://github.com/hiddify/hiddify-config/assets/125398461/fe7a7a27-016c-45b9-92b5-2e9427ba165a" />
                                                        </div>

                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="accordion-item">
                                        <div class="accordion" id="shadowrocket-settings-accordion-4">
                                            <h2 class="accordion-header" id="shadowrocket-settings-heading-4">
                                                <button class="accordion-button collapsed" type="button"
                                                    data-bs-toggle="collapse"
                                                    data-bs-target="#shadowrocket-settings-collapse-4"
                                                    aria-expanded="false">
                                                    فعال‌سازی شورت‌کات
                                                </button>
                                            </h2>
                                            <div id="shadowrocket-settings-collapse-4"
                                                class="accordion-collapse collapse"
                                                data-bs-parent="#shadowrocket-settings-accordion">
                                                <div class="accordion-body pt-0">
                                                    <div style="margin: 15px;">
                                                        <p style="text-align: justify;">باز `Settings` وارد بخش
                                                            `Shortcuts` شوید. در اینجا شما می‌توانید برای کاربردهای
                                                            مختلف یک فرمان صوتی تعیین کنید که با استفاده از آن فرمان
                                                            صوتی، فانکشن مورد نظر اجرا ردد مثلا برنامه اجرا گردد و
                                                            مواردی از این دست.
                                                        </p>
                                                        <div align=center>

                                                            <img width=30%
                                                                src="https://github.com/hiddify/hiddify-config/assets/125398461/af641742-dc91-468e-9135-78de911e6703" />
                                                        </div>

                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="accordion-item">
                                        <div class="accordion" id="shadowrocket-settings-accordion-5">
                                            <h2 class="accordion-header" id="shadowrocket-settings-heading-5">
                                                <button class="accordion-button collapsed" type="button"
                                                    data-bs-toggle="collapse"
                                                    data-bs-target="#shadowrocket-settings-collapse-5"
                                                    aria-expanded="false">
                                                    Killer Switch
                                                </button>
                                            </h2>
                                            <div id="shadowrocket-settings-collapse-5"
                                                class="accordion-collapse collapse"
                                                data-bs-parent="#shadowrocket-settings-accordion">
                                                <div class="accordion-body pt-0">
                                                    <div style="margin: 15px;">
                                                        <p style="text-align: justify;">برای این کار در `Settings` وارد بخش `On Demand` شوید.
                                                        </p>
                                                        <div style="margin: 15px;">
                                                            <p ><strong>Always On</strong></p>
                                                            <p style="text-align: justify;">با روشن کردن این گزینه، همیشه VPN شما روشن خواهد بود.
                                                            </p>
                                                            <br>
                                                            <br>
                                                            <p ><strong>On Demand</strong></p>
                                                            <p style="text-align: justify;">با روشن شدن این گزینه وقتی اینترنت شما قطع می‌شود، شدوراکت کل اینترنت شما را قطع می‌کنه تا از لو رفتن آیپی اصلی شما جلوگیری کنه.
                                                            </p>
                                                            <br>
                                                            <br>
                                                            <p ><strong>Disconnect on Sleep</strong></p>
                                                            <p style="text-align: justify;">اگر این گزینه را فعال نمایید، پس از اینکه گوشی به حالت Sleep رفت، VPN قطع می‌شود.
                                                            </p>
                                                            

                                                        </div>

                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="accordion-item">
                                        <div class="accordion" id="shadowrocket-settings-accordion-6">
                                            <h2 class="accordion-header" id="shadowrocket-settings-heading-6">
                                                <button class="accordion-button collapsed" type="button"
                                                    data-bs-toggle="collapse"
                                                    data-bs-target="#shadowrocket-settings-collapse-6"
                                                    aria-expanded="false">
                                                    اشتراک‌گذاری کانکشن با سایر دستگاه‌ها
                                                </button>
                                            </h2>
                                            <div id="shadowrocket-settings-collapse-6"
                                                class="accordion-collapse collapse"
                                                data-bs-parent="#shadowrocket-settings-accordion">
                                                <div class="accordion-body pt-0">
                                                    <div style="margin: 15px;">
                                                        <p style="text-align: justify;">فرض کنید دستگاهی دارید که امکان نصب VPN را ندارد و نیاز است به اینترنت آزاد متصل گردد. برای این کار می‌توانید از گزینه به اشتراک‌گذاری کانکشن در شدوراکت استفاده کر. در منوی `Settings` وارد بخش `Proxy` شوید و `Proxy Share` را انتخاب نمایید. اگر گزینه `Enable Share` را فعال کنید روی آیپی و پورت مشخص شده VPN شما به اشتراک گذاشته می‌شود.
                                                        </p>
                                                        <br>
                                                        <div align=center>

                                                            <img width=30%
                                                            src="https://github.com/hiddify/hiddify-config/assets/125398461/d764b726-6ddd-4a5a-aa76-f9ad8165e4f1" />
                                                        </div>
                                                        <br>
                                                        <p style="text-align: justify;">برای استفاده در دستگاه دیگر که در یک شبکه مشترک با گوشی شما قرار دارند، می‌توانید وارد تنظیمات پروکسی آن شوید و آیپی و پورت را وارد کنید. بدون نصب هیچ VPNی این دستگاه به اینترنت آزاد متصل خواهد شد.
                                                        </p>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="accordion-item">
                                        <div class="accordion" id="shadowrocket-settings-accordion-6">
                                            <h2 class="accordion-header" id="shadowrocket-settings-heading-6">
                                                <button class="accordion-button collapsed" type="button"
                                                    data-bs-toggle="collapse"
                                                    data-bs-target="#shadowrocket-settings-collapse-6"
                                                    aria-expanded="false">
                                                    ایجاد لودبالانس
                                                </button>
                                            </h2>
                                            <div id="shadowrocket-settings-collapse-6"
                                                class="accordion-collapse collapse"
                                                data-bs-parent="#shadowrocket-settings-accordion">
                                                <div class="accordion-body pt-0">
                                                    <div style="margin: 15px;">
                                                        <p style="text-align: justify;">با نگه داشتن انگشت روی صفحه اصلی و کشیدن به سمت پایین منوی مخفی برنامه باز می‌شود. 
                                                        </p>
                                                        <br>
                                                        <div align=center>

                                                            <img width=30%
                                                            src="https://github.com/hiddify/hiddify-config/assets/125398461/59872f56-e9ff-4c50-85a0-65ccd488e704" />
                                                        </div>
                                                        <br>
                                                        <p style="text-align: justify;">برای ایجاد لودبالانس دکمه `+` را بزنید. 
                                                        </p>
                                                        <br>
                                                        <div align=center>

                                                            <img width=30%
                                                            src="https://github.com/hiddify/hiddify-config/assets/125398461/b67bc883-e643-465c-85dc-e6eeb719723c" />
                                                        </div>
                                                        <br>
                                                        <p style="text-align: justify;">یک نام دلخواه بدهید و `Type` را روی `load-balance` قرار دهید. سپس از قسمت `Policy` کانفیگ‌هایی که پینگ بهتری دارند یا حتی همه کانفیگ‌ها را انتخاب نمایید. در قسمت `Interval` می‌توانید مدت زمان بین تست‌های کانکشن لودبالانس را مشخص نمایید. در قسمت `Timeout` نیز می‌توانید مدت زمانی که یک کانکشن قطع می‌ماند و همچنان معتبر در نظر گرفته شود را مشخص کنید. ولی می توانید اگر بار اول است که این قسمت را تنظیم می‌نمایید، تنظیمات تایمرها را فعلا به صورت دیفالت قرار دهید. در نهایت ذخیره نمایید. 
                                                        </p>
                                                        <br>
                                                        <div align=center>

                                                            <img width=30%
                                                            src="https://github.com/hiddify/hiddify-config/assets/125398461/be6e132b-d9d4-45ff-ab8a-94b72d764139" />
                                                        </div>
                                                        <br>
                                                        <p style="text-align: justify;">حالا روی لودبالانس ساخته شده بزنید و Test را تپ کنید. با این کار هم تست لودبالانس انجام می‌شود و هم اتصال آن برقرار می‌گردد. با روشن یا خاموش کردن شدوراکت، لودبالانس نیز روشن یا خاموش می‌گردد. 
                                                        </p>
                                                        <br>
                                                        <div align=center>

                                                            <img width=30%
                                                            src="https://github.com/hiddify/hiddify-config/assets/125398461/819da751-8a46-4ab3-88e2-00a5e0b3f724" />
                                                        </div>
                                                        <br>
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
            </div>
        </div>
        <div class="mt-3">
            <button class="btn btn-primary" type="button" data-bs-dismiss="offcanvas">
                بستن آموزش
            </button>
        </div>
    </div>
</div>