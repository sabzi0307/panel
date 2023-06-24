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
        <h2 class="offcanvas-title" id="offcanvasEndLabel">>آموزش کار با نرم‌افزار iClashX</h2>
        <button type="button" class="btn-close text-reset" data-bs-dismiss="offcanvas" aria-label="Close"></button>
    </div>
    <div class="offcanvas-body">
        <div>
            <h2>آموزش کار با نرم‌افزار iClashX</h2>
            <p style="text-align: justify;"><strong>iClashX</strong> نرم افزاری <a href="/staff"
                    class="link-secondary">متن باز</a>است که بر پایه <a href="/staff"
                    class="link-secondary">ClashAndroid</a> توسعه و بومی سازی شده و امکانات متعددی به آن افزوده شده است.
            </p>
            <div class="note" style="text-align: justify;">
                <i class="ti ti-message-2" style="color: green;"></i> در اینجا نیاز است با مفهومی به اسم <strong>پروفایل
                    (Profile)</strong>
                آشنا شوید.
                <strong>پروفایل (Profile)</strong> یک فایل متنی با پسوند <strong>yaml</strong> شامل تمامی تنظیمات و
                کانکشن‌های مورد نیاز نرم افزار های
                مبتنی بر کلش (متا) می باشد.
            </div>

            <div class="tab-pane active show" id="iclashx">

                <div class="accordion-item">
                    <div class="accordion" id="iclashx-accordion">
                        <h2 class="accordion-header" id="iclashx-heading-1">
                            <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse"
                                data-bs-target="#iclashx-collapse-1" aria-expanded="false">
                                دانلود و نصب نرم افزار
                            </button>
                        </h2>
                        <div id="iclashx-collapse-1" class="accordion-collapse collapse"
                            data-bs-parent="#iclashx-accordion" style="margin:  20px;">
                            <p style="text-align: justify;"> ابتدا نرم افزار iClashX را از لینک های
                                زیر
                                دانلود
                                کنید.</p>


                            <div class="btn-list justify-content-start">
                                <a href="/clients/Clash-Android.apk" class="btn btn-primary">

                                    <i class="ti ti-brand-android icon"></i>
                                    &nbsp;دانلود iClashX برای اندروید
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
                    <h2 class="accordion-header" id="iclashx-heading-2">
                        <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse"
                            data-bs-target="#iclashx-collapse-2" aria-expanded="false">
                            افزودن پروفایل به نرم‌افزار (Profile)
                        </button>
                    </h2>
                    <div id="iclashx-collapse-2" class="accordion-collapse collapse"
                        data-bs-parent="#iclashx-accordion">
                        <div class="accordion-body pt-0">
                            <strong>جهت افزودن پروفایل می توانید از یکی از روش های زیر استفاده کنید.</strong>
                            <br>
                            <br>
                            <div class="tab-pane active show" id="iclashx-ins">
                                <div class="accordion-item">
                                    <div class="accordion" id="iclashx-ins-accordion">
                                        <h2 class="accordion-header" id="iclashx-ins-heading-1">
                                            <button class="accordion-button collapsed" type="button"
                                                data-bs-toggle="collapse" data-bs-target="#iclashx-ins-collapse-1"
                                                aria-expanded="false">
                                                نصب خودکار (پیشنهادی)
                                            </button>
                                        </h2>
                                        <div id="iclashx-ins-collapse-1" class="accordion-collapse collapse"
                                            style="margin: 20px;" data-bs-parent="#iclashx-ins-accordion">
                                            <p style="text-align: justify;">جهت نصب به صورت <strong>خودکار</strong> فقط
                                                کافیست تا بر روی دکمه زیر
                                                کلیک کنید تا پروفایل (Profile) به صورت خودکار به نرم افزار افزوده شود .
                                            </p>
                                            <a href="clash://install-config?url={$UniversalSub}/clash&name={$config['appName']}"
                                                class="btn btn-primary">
                                                جهت نصب خودکار کلیک کنید
                                            </a>
                                        </div>
                                    </div>
                                </div>
                                <div class="accordion-item">
                                    <div class="accordion" id="iclashx-ins-accordion-2">
                                        <h2 class="accordion-header" id="iclashx-ins-heading-2">
                                            <button class="accordion-button collapsed" type="button"
                                                data-bs-toggle="collapse" data-bs-target="#iclashx-ins-collapse-2"
                                                aria-expanded="false">
                                                نصب دستی
                                            </button>
                                        </h2>
                                        <div id="iclashx-ins-collapse-2" class="accordion-collapse collapse"
                                            data-bs-parent="#iclashx-ins-accordion">
                                            <div class="accordion-body pt-0">
                                                <div style="margin: 15px;">
                                                    <p style="text-align: justify;">همچنین می‌توانید در زیر بر روی دکمه
                                                        کپی لینک اشتراک کلیک کنید و سپس در
                                                        اپ iClashX در اندروید روی `Profile`‌ بزنید.
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
                                                        <img width=100%
                                                            src="https://github.com/hiddify/hiddify-config/assets/125398461/18a7595d-fe50-4c6b-96cd-871f96c10be9" />
                                                    </div>
                                                    <p>و در صفحه‌ای که باز می‌شود، دکمه + را تپ کنید.</p>
                                                    <div align=center>
                                                        <img width=100%
                                                            src="https://github.com/hiddify/hiddify-config/assets/125398461/19501548-8bb9-45f4-bf93-a2a45bf4b052" />
                                                    </div>
                                                    <p>در این صفحه در قسمت `URL` بروید.</p>
                                                    <div align=center>
                                                        <img width=100%
                                                            src="https://github.com/hiddify/hiddify-config/assets/125398461/f628a291-fb82-4092-bcc6-7c3afcb05247" />
                                                    </div>
                                                    <p>و لینک پروفایل کپی شده را در url قرار دهید و ذخیره نمایید.</p>
                                                    <div align=center>
                                                        <img width=100%
                                                            src="https://github.com/hiddify/hiddify-config/assets/125398461/c2719915-f59e-4d7b-989e-6af89be167c9" />
                                                    </div>
                                                    <p>پروفایل مورد نظر به برنامه افزوده می‌گردد.</p>
                                                </div>
                                            </div>

                                            </p>
                                        </div>
                                    </div>
                                </div>


                            </div>

                        </div>
                    </div>
                </div>
                <div class="accordion-item">
                    <h2 class="accordion-header" id="iclashx-heading-3">
                        <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse"
                            data-bs-target="#iclashx-collapse-3" aria-expanded="false">
                            اتصال به فیلترشکن
                        </button>
                    </h2>
                    <div id="iclashx-collapse-3" class="accordion-collapse collapse"
                        data-bs-parent="#iclashx-accordion">
                        <div class="accordion-body pt-0">
                            <div style="margin: 15px;">
                                <p style="text-align: justify;">برای اتصال نیز روی دکمه مشخص شده بزنید.</p>
                                <div align=center>

                                    <img width=100%
                                        src="https://github.com/hiddify/hiddify-config/assets/125398461/4c041134-3f97-4126-999b-7507a6207cc9" />
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="accordion-item">
                    <h2 class="accordion-header" id="iclashx-heading-4">
                        <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse"
                            data-bs-target="#iclashx-collapse-4" aria-expanded="false">
                            آپدیت پروفایل
                        </button>
                    </h2>
                    <div id="iclashx-collapse-4" class="accordion-collapse collapse"
                        data-bs-parent="#iclashx-accordion">
                        <div class="accordion-body pt-0">
                            <div style="margin: 15px;">
                                <p style="text-align: justify;">جهت آپدیت پروفایل و کانفیگ‌ها روی پروفایل بزنید و در
                                    صفحه باز شده روی
                                    علامت آپدیت بزنید تا پروفایل مطابق با آخرین تغییرات سرور آپدیت گردد.</p>
                                <div align=center>

                                    <img width=80%
                                        src="https://github.com/hiddify/hiddify-config/assets/125398461/114d34de-9eab-40c6-9f97-b92eca3e24a6" />
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