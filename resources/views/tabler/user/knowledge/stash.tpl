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
        <h2 class="offcanvas-title" id="offcanvasEndLabel">>آموزش کار با نرم‌افزار Stash</h2>
        <button type="button" class="btn-close text-reset" data-bs-dismiss="offcanvas" aria-label="Close"></button>
    </div>
    <div class="offcanvas-body">
        <div>
            <h2>آموزش کار با نرم‌افزار Stash</h2>
            <p style="text-align: justify;"><strong>Stash</strong> برنامه بر پایه کلش برای iOS نوشته شده و برای استفاده
                از آن باید خریداری شود.
            </p>
            <div class="note" style="text-align: justify;">
                <i class="ti ti-message-2" style="color: green;"></i> در اینجا نیاز است با مفهومی به اسم <strong>پروفایل
                    (Profile)</strong>
                آشنا شوید.
                <strong>پروفایل (Profile)</strong> یک فایل متنی با پسوند <strong>yaml</strong> شامل تمامی تنظیمات و
                کانکشن‌های مورد نیاز نرم افزار های
                مبتنی بر کلش (متا) می باشد.
            </div>

            <div class="tab-pane active show" id="stash">

                <div class="accordion-item">
                    <div class="accordion" id="stash-accordion">
                        <h2 class="accordion-header" id="stash-heading-1">
                            <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse"
                                data-bs-target="#stash-collapse-1" aria-expanded="false">
                                دانلود و نصب نرم افزار
                            </button>
                        </h2>
                        <div id="stash-collapse-1" class="accordion-collapse collapse" data-bs-parent="#stash-accordion"
                            style="margin:  20px;">
                            <p style="text-align: justify;">ابتدا نرم افزار را از لینک زیر خریداری کنید</p>

                            <div class="btn-list justify-content-start">
                                <a href="https://apps.apple.com/app/stash/id1596063349" target="_blank"
                                    class="btn btn-primary">
                                    Stash را بخرید
                                </a>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="accordion-item">
                    <h2 class="accordion-header" id="stash-heading-2">
                        <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse"
                            data-bs-target="#stash-collapse-2" aria-expanded="false">
                            افزودن پروفایل به نرم‌افزار (Profile)
                        </button>
                    </h2>
                    <div id="stash-collapse-2" class="accordion-collapse collapse" data-bs-parent="#stash-accordion">
                        <div class="accordion-body pt-0">
                            <strong>جهت افزودن پروفایل می توانید از یکی از روش های زیر استفاده کنید.</strong>
                            <br>
                            <br>
                            <div class="tab-pane active show" id="stash-ins">
                                <div class="accordion-item">
                                    <div class="accordion" id="stash-ins-accordion">
                                        <h2 class="accordion-header" id="stash-ins-heading-1">
                                            <button class="accordion-button collapsed" type="button"
                                                data-bs-toggle="collapse" data-bs-target="#stash-ins-collapse-1"
                                                aria-expanded="false">
                                                نصب خودکار (پیشنهادی)
                                            </button>
                                        </h2>
                                        <div id="stash-ins-collapse-1" class="accordion-collapse collapse"
                                            style="margin: 20px;" data-bs-parent="#stash-ins-accordion">
                                            <p style="text-align: justify;">جهت نصب به صورت <strong>خودکار</strong> فقط
                                                کافیست تا بر روی دکمه زیر
                                                کلیک کنید تا پروفایل (Profile) به صورت خودکار به نرم افزار افزوده شود .
                                            </p>
                                            <a href="stash://install-config?url={$UniversalSub}/clash&name={$config['appName']}"
                                                class="btn btn-primary">
                                                جهت نصب خودکار کلیک کنید
                                            </a>
                                        </div>
                                    </div>
                                </div>
                                <div class="accordion-item">
                                    <div class="accordion" id="stash-ins-accordion-2">
                                        <h2 class="accordion-header" id="stash-ins-heading-2">
                                            <button class="accordion-button collapsed" type="button"
                                                data-bs-toggle="collapse" data-bs-target="#stash-ins-collapse-2"
                                                aria-expanded="false">
                                                نصب دستی
                                            </button>
                                        </h2>
                                        <div id="stash-ins-collapse-2" class="accordion-collapse collapse"
                                            data-bs-parent="#stash-ins-accordion">
                                            <div class="accordion-body pt-0">
                                                <div style="margin: 15px;">
                                                    <p style="text-align: justify;">در زیر بر روی دکمه
                                                        کپی لینک اشتراک کلیک کنید و پس از کپی کردن لینک ، وارد برنامه
                                                        Stash شوید، در صفحه `Settings` قسمت `Config File` را انتخاب
                                                        کنید.
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
                                                    <p style="text-align: justify;">گزینه `Download from URL` را انتخاب
                                                        کنید.</p>
                                                    <div align=center>
                                                        <img width=30%
                                                            src="https://github.com/hiddify/hiddify-config/assets/125398461/ffbbd7a4-96aa-4331-9987-09f13f46edc8" />
                                                    </div>
                                                    <p>لینک کپی شده را وارد کنید و `Download` را بزنید. با انجام این کار
                                                        پروفایل مورد نظر به برنامه اضافه می‌شود.</p>
                                                    <div align=center>
                                                        <img width=30%
                                                            src="https://github.com/hiddify/hiddify-config/assets/125398461/84e1e1da-2d09-4b59-ac88-91412746e4ee" />
                                                    </div>
                                                </div>
                                            </div>

                                            </p>
                                        </div>
                                    </div>
                                </div>
                                <div class="accordion-item">
                                    <div class="accordion" id="stash-ins-accordion-3">
                                        <h2 class="accordion-header" id="stash-ins-heading-3">
                                            <button class="accordion-button collapsed" type="button"
                                                data-bs-toggle="collapse" data-bs-target="#stash-ins-collapse-3"
                                                aria-expanded="false">
                                                اضافه کردن لینک با استفاده از QR code
                                            </button>
                                        </h2>
                                        <div id="stash-ins-collapse-3" class="accordion-collapse collapse"
                                            data-bs-parent="#stash-ins-accordion">
                                            <div class="accordion-body pt-0">
                                                <div style="margin: 15px;">
                                                    <p style="text-align: justify;">
                                                        کپی لینک اشتراک کلیک کنید وارد برنامه Stash شوید، در صفحه
                                                        `Settings` قسمت `Config File` را انتخاب کنید.
                                                    </p>
                                                    <p style="text-align: justify;">گزینه `Download from QRcode` را
                                                        انتخاب کنید.</p>
                                                    <div align=center>
                                                        <img width=30%
                                                            src="https://github.com/hiddify/hiddify-config/assets/125398461/02ca1ecf-3552-4c8e-9a2f-625be8c8b7ac" />
                                                    </div>
                                                    <p style="text-align: justify;">QR code مورد نظر را اسکن کنید تا
                                                        پروفایل به برنامه اضافه گردد.
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
                    <h2 class="accordion-header" id="stash-heading-3">
                        <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse"
                            data-bs-target="#stash-collapse-3" aria-expanded="false">
                            منوی ‌Policy و تست کانکشن ها
                        </button>
                    </h2>
                    <div id="stash-collapse-3" class="accordion-collapse collapse" data-bs-parent="#stash-accordion">
                        <div class="accordion-body pt-0">
                            <div style="margin: 15px;">
                                <p style="text-align: justify;">در این منو پالیسی‌ها یا همان کانفیگ‌های موود در
                                    پروفایل‌های ایمپورت شده به برنامه بازگذاری می‌شوند و نمایش داده می‌شوند.</p>
                                <div align=center>

                                    <img width=30%
                                        src="https://github.com/hiddify/hiddify-config/assets/125398461/7fd169ea-18b4-4f7f-85b4-ee2073b8c25f" />
                                </div>
                                <br>
                                <p style="text-align: justify;">این حالت‌های مختلف در منوی Policy وابسته به حالت‌های
                                    مختلف Outbound است که در ادامه توضیح داده خواهند شد.</p>
                                <br>
                                <strong>sequential</strong>
                                <p style="text-align: justify;">ددر این حالت نرم‌افزار به صورت ترتیبی از بین کانفیگ‌های
                                    مختلف انتخاب می‌کند. یعنی به صورت دوره‌ای یکی از کانفیگ‌ها را متصل می :ند. این حالت
                                    باعث پخش بار غیر همزمان می‌شود ولی با حالت لودبالانس که به صورت همزمان از کانفیگ‌ها
                                    استفاده می‌کند متفاوت است. این مورد مرتبط با حالت `Rule` در `Outbound` است.
                                </p>
                                <strong>automatic</strong>
                                <p style="text-align: justify;">دمربوط به حالت انتخاب خودکار کانفیگ برای `automatic`
                                    است.</p>
                                <strong>Load-Balance</strong>
                                <p style="text-align: justify;">ادر این حالت امکان استفاده از چند کانکشن به صورت همزمان
                                    وجود دارد که باعث پخش بار روی چندین کانکشن می‌شود و برای زمان هایی که آیپی کثیف شده
                                    و کانکشن‌های تکی خوب عمل نمی‌کنند می‌تواند مفید باشد. این مورد نیز مرتبط با حالت
                                    `Rule` در `Outbound` است.</p>
                                <br>
                                <strong>تست کانکشن‌ها</strong>
                                <p style="text-align: justify;">برای این کار روی آیکون رعد و برق کلیک کنید تا تست کانکشن
                                    انجام شود.</p>
                                <br>
                                <div align=center>

                                    <img width=30%
                                        src="https://github.com/hiddify/hiddify-config/assets/125398461/7bdb1519-7179-4c6e-a6e9-ee00c3bc06db" />
                                </div>
                                <br>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="accordion-item">
                    <h2 class="accordion-header" id="stash-heading-4">
                        <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse"
                            data-bs-target="#stash-collapse-4" aria-expanded="false">
                            آپدیت پروفایل
                        </button>
                    </h2>
                    <div id="stash-collapse-4" class="accordion-collapse collapse" data-bs-parent="#stash-accordion">
                        <div class="accordion-body pt-0">
                            <div style="margin: 15px;">

                                <strong>جهت افزودن پروفایل می توانید از یکی از روش های زیر استفاده کنید.</strong>
                                <br>
                                <br>
                                <div class="tab-pane active show" id="stash-update">
                                    <div class="accordion-item">
                                        <div class="accordion" id="stash-update-accordion">
                                            <h2 class="accordion-header" id="stash-update-heading-1">
                                                <button class="accordion-button collapsed" type="button"
                                                    data-bs-toggle="collapse" data-bs-target="#stash-update-collapse-1"
                                                    aria-expanded="false">
                                                    آپدیت خودکار (پیشنهادی)
                                                </button>
                                            </h2>
                                            <div id="stash-update-collapse-1" class="accordion-collapse collapse"
                                                style="margin: 20px;" data-bs-parent="#stash-update-accordion">
                                                <p style="text-align: justify;">برای این کار در Settings گزینه More
                                                    Settings را انتخاب نمایید.
                                                </p>

                                                <div align=center>

                                                    <img width=30%
                                                        src="https://github.com/hiddify/hiddify-config/assets/125398461/ab8222a0-b24b-487b-bb62-4c5509d27806" />
                                                </div>
                                                <p style="text-align: justify;">در قسمت `CONFIG FILE` فیلد `Update
                                                    Interval` می‌توانید مدت زمان بین آپدیت‌های خودکار را مشخص کنید.
                                                </p>
                                                <p style="text-align: justify;">با فعال‌سازی Auto Update این قابلیت فعال
                                                    می‌گردد
                                                </p>
                                                <p style="text-align: justify;">همچنین هر بار که برنامه Stash را باز
                                                    می‌کنید پروفایل‌ها آپدیت می‌شوند.
                                                </p>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="accordion-item">
                                        <div class="accordion" id="stash-update-accordion-2">
                                            <h2 class="accordion-header" id="stash-update-heading-2">
                                                <button class="accordion-button collapsed" type="button"
                                                    data-bs-toggle="collapse" data-bs-target="#stash-update-collapse-2"
                                                    aria-expanded="false">
                                                    آپدیت دستی
                                                </button>
                                            </h2>
                                            <div id="stash-update-collapse-2" class="accordion-collapse collapse"
                                                data-bs-parent="#stash-update-accordion">
                                                <div class="accordion-body pt-0">
                                                    <div style="margin: 15px;">
                                                        <p style="text-align: justify;">برای این کار منوی `Settings`
                                                            وارد `Config File‌` شوید و انگشت خود را روی یکی از
                                                            پروفایل‌ها نگه دارید. در منوی ظاهر شده، گزینه Update Now را
                                                            بزنید.</p>
                                                        <div align=center>

                                                            <img width=30%
                                                                src="https://github.com/hiddify/hiddify-config/assets/125398461/3ecb0ab1-40b9-40e5-8f93-5a37f9b0a1dd" />
                                                        </div>
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
                </div>
                <div class="accordion-item">
                    <h2 class="accordion-header" id="stash-heading-5">
                        <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse"
                            data-bs-target="#stash-collapse-5" aria-expanded="false">
                            انتخاب حالت در بخش Outbound
                        </button>
                    </h2>
                    <div id="stash-collapse-5" class="accordion-collapse collapse" data-bs-parent="#stash-accordion">
                        <div class="accordion-body pt-0">
                            <div style="margin: 15px;">

                                <strong>در صفحه `Home` برنامه و در بخش `Outbound` می‌توانید سه حالت را انتخاب
                                    کنید.</strong>
                                <br>
                                <div align=center>
                                    <img width=30%
                                        src="https://github.com/hiddify/hiddify-config/assets/125398461/51b861c7-2e12-4541-a214-84311270cb8d" />
                                </div>
                                <br>
                                <div class="card-header">
                                    <ul class="nav nav-tabs card-header-tabs" data-bs-toggle="tabs">
                                        <li class="nav-item">
                                            <a href="#tabs-rule-1" class="nav-link active" data-bs-toggle="tab">Rule
                                                mode</a>
                                        </li>
                                        <li class="nav-item">
                                            <a href="#tabs-global-1" class="nav-link" data-bs-toggle="tab">Global
                                                mode</a>
                                        </li>
                                        <li class="nav-item">
                                            <a href="#tabs-direct-1" class="nav-link" data-bs-toggle="tab">Direct
                                                mode</a>
                                        </li>
                                    </ul>
                                </div>
                                <div class="card-body">
                                    <div class="tab-content">
                                        <div class="tab-pane active show" id="tabs-rule-1">
                                            <div>بکه پالیسی‌ها را بر اساس رول‌های موجود در پروفایل استفاده می‌کند یعنی
                                                اگر مثلا پروفایل Lite در حال استفاده باشد، با استفاده از این حالت ترافیک
                                                سایت‌های ایرانی به صورت خودکار از فیلترشکن عبور نمی‌کند.</div>
                                            <br>
                                        </div>
                                        <div class="tab-pane" id="tabs-global-1">
                                            <div>کحالتی است که رول‌ها دیگر اجرا نمی‌شود و می توانید در منوی Policy روی
                                                حالت Proxy یکی از کانفیگ‌ها را انتخاب کنید تا همه ترافیک گوشی شما از آن
                                                کانفیگ عبور کند. این حالت برای زمانی‌ مفید است که می‌خواهید یک کانفیگ
                                                خاص را استفاده کنید.</div>
                                            <br>
                                        </div>
                                        <div class="tab-pane" id="tabs-direct-1">
                                            <div>در این حالت ترافیک از فیلترشکن عبور داده نمی‌شود مثل این است که
                                                فیلترشکن را خاموش کرده باشید.</div>
                                            <br>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="accordion-item">
                    <h2 class="accordion-header" id="stash-heading-6">
                        <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse"
                            data-bs-target="#stash-collapse-6" aria-expanded="false">
                            سایر تنظیمات
                        </button>
                    </h2>
                    <div id="stash-collapse-6" class="accordion-collapse collapse" data-bs-parent="#stash-accordion">
                        <div class="accordion-body pt-0">
                            <div style="margin: 15px;">                                
                                <div class="card-header">
                                    <ul class="nav nav-tabs card-header-tabs" data-bs-toggle="tabs">
                                        <li class="nav-item">
                                            <a href="#tabs-ondemand-1" class="nav-link active"
                                                data-bs-toggle="tab">قابلیت On Demand</a>
                                        </li>
                                        <li class="nav-item">
                                            <a href="#tabs-debuge-1" class="nav-link" data-bs-toggle="tab">عیب‌یابی
                                                کانکشن‌ها</a>
                                        </li>
                                    </ul>
                                </div>
                                <div class="card-body">
                                    <div class="tab-content">
                                        <div class="tab-pane active show" id="tabs-ondemand-1">
                                            <img width=30%
                                                src="https://github.com/hiddify/hiddify-config/assets/125398461/0854f4f3-3628-41a3-a8b4-3a3a08474370" />
                                            <br>
                                            <br>
                                            <p><strong>Always On</strong></p>
                                            <p>
                                                اگر این گزینه را فعال نمایید، همیشه فیلترشکن شما فعال خواهد بود.</p>
                                            <br>
                                            <br>
                                            <p><strong>On Demand</strong></p>
                                            <p>
                                                اگر این گزینه را فعال کنید، فیلترشکن تنها زمانی که صفحه گوشی قفل نشده
                                                است فعال خواهد بود و در سایر مواقع خاموش می‌شود.</p>
                                            <br>
                                            <br>
                                        </div>
                                        <div class="tab-pane" id="tabs-debuge-1">
                                            <div>در صورت نیاز به چک کردن جزییات بیشتر از اتصالات می‌توانید در منوی
                                                `Utilities` وارد بخش `Network Diagnosis` شوید. در اینا لاگ مربو به تمامی
                                                کانکشن‌ها نمایش داده می‌شود که می‌تواند برای عیب‌یابی مفید باشد. این بخش
                                                شامل چندین زیربخش است که از جمله `Connectivity` و `Proxy` مفید هستند.
                                            </div>
                                            <br>
                                            <div align=center>
                                                <img width=30%
                                                    src="https://github.com/hiddify/hiddify-config/assets/125398461/3685baf2-5d0f-4305-a151-12bcc761ab23" />
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