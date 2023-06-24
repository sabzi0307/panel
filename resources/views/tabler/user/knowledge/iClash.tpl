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
        <h2 class="offcanvas-title" id="offcanvasEndLabel">>آموزش کار با نرم‌افزار iClash</h2>
        <button type="button" class="btn-close text-reset" data-bs-dismiss="offcanvas" aria-label="Close"></button>
    </div>
    <div class="offcanvas-body">
        <div>
            <h2>آموزش کار با نرم‌افزار iClash</h2>
            <p style="text-align: justify;"><strong>iClash</strong> نرم افزاری <a href="/staff"
                    class="link-secondary">متن باز</a>است که بر پایه <a href="/staff"
                    class="link-secondary">ClashVerge</a> توسعه و بومی سازی شده و امکانات متعددی از جمله
                امکان افزودن خودکار پروفایل به نرم افزار به آن افزوده شده است.</p>
            <div class="note" style="text-align: justify;">
                <i class="ti ti-message-2" style="color: green;"></i> در اینجا نیاز است با مفهومی به اسم <strong>پروفایل
                    (Profile)</strong>
                آشنا شوید.
                <strong>پروفایل (Profile)</strong> یک فایل متنی با پسوند <strong>yaml</strong> شامل تمامی تنظیمات و
                کانکشن‌های مورد نیاز نرم افزار های
                مبتنی بر کلش (متا) می باشد.
            </div>


            <div class="tab-pane active show" id="iclash">

                <div class="accordion-item">
                    <div class="accordion" id="iclash-accordion">
                        <h2 class="accordion-header" id="iclash-heading-1">
                            <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse"
                                data-bs-target="#iclash-collapse-1" aria-expanded="false">
                                دانلود و نصب نرم افزار
                            </button>
                        </h2>
                        <div id="iclash-collapse-1" class="accordion-collapse collapse"
                            data-bs-parent="#iclash-accordion" style="margin:  20px;">
                            <h3>دانلود نرم افزار</h3>
                            <p style="text-align: justify;"> ابتدا نرم افزار iClash را از لینک های
                                زیر
                                دانلود
                                کنید.</p>

                            {if $ros eq "windows"}
                                <div class="btn-list justify-content-start">
                                    <a href="/clients/Clash.Verge.msi" class="btn btn-primary">

                                        <i class="ti ti-brand-windows icon"></i>
                                        &nbsp;دانلود برای ویندوز
                                    </a>
                                </div>
                                <div>
                                    <br>
                                    <h3>نصب نرم افزار</h3>
                                    <div style="margin: 15px;">
                                        <h4>نصب در ویندوز</h4>
                                        <p style="text-align: justify;">نصب نرم افزار بسیار ساده است و با چند next به انتها
                                            می رسد.</p>
                                    </div>
                                </div>
                            {elseif $ros eq "Mac"}
                                <div class="btn-list justify-content-start">
                                    <a href="/clients/Clash.Verge_x64.dmg" class="btn btn-primary">

                                        <i class="ti ti-brand-finder icon"></i>
                                        &nbsp;دانلود برای مک (x86_64)
                                    </a>
                                    <a href="/clients/Clash.Verge_aarch64.dmg" class="btn btn-primary">

                                        <i class="ti ti-brand-finder icon"></i>
                                        &nbsp;دانلود برای مک (aarch64)
                                    </a>
                                </div>
                                <br>
                                <h3>نصب نرم افزار</h3>
                                <div style="margin: 15px;">
                                    <h4>نصب در مکینتاش</h4>
                                    <p style="text-align: justify;">برای مک نیز باید برنامه را در بخش privacy تایید نمایید.
                                    </p>
                                </div>
                            {elseif $ros eq "Linux"}
                                <a href="/clients/Clash.Verge.AppImage.tar.gz" class="btn btn-primary">
                                    <i class="ti ti-brand-redhat icon"></i>
                                    &nbsp;دانلود برای لینوکس
                                </a>
                                <br>
                                <br>
                                <h3>نصب نرم افزار</h3>
                                <div style="margin: 15px;">
                                    <h4>نصب در لینوکس</h4>
                                    <p style="text-align: justify;">برای لینوکس می‌بایست تنها به فایل AppImage دانلود شده
                                        دسترسی اجرایی
                                        بدهید و آن را اجرا کنید.</p>
                                </div>
                            {else}
                                <div class="btn-list justify-content-start">
                                    <a href="/clients/Clash.Verge.msi" class="btn btn-primary">
                                        <i class="ti ti-brand-windows icon"></i>
                                        &nbsp;دانلود برای ویندوز
                                    </a>
                                    <a href="/clients/Clash.Verge.AppImage.tar.gz" class="btn btn-primary">
                                        <i class="ti ti-brand-redhat icon"></i>
                                        &nbsp;دانلود برای لینوکس
                                    </a>
                                    <a href="/clients/Clash.Verge_x64.dmg" class="btn btn-primary">

                                        <i class="ti ti-brand-finder icon"></i>
                                        &nbsp;دانلود برای مک (x86_64)
                                    </a>
                                    <a href="/clients/Clash.Verge_aarch64.dmg" class="btn btn-primary">

                                        <i class="ti ti-brand-finder icon"></i>
                                        &nbsp;دانلود برای مک (aarch64)
                                    </a>
                                </div>
                                <br>
                                <h3>نصب نرم افزار</h3>
                                <div style="margin: 15px;">
                                    <h4>نصب در ویندوز</h4>
                                    <p style="text-align: justify;">نصب برنامه بسیار ساده است و با چند next به انتها می رسد.
                                    </p>
                                </div>
                                <div style="margin: 15px;">
                                    <h4>نصب در مکینتاش</h4>
                                    <p style="text-align: justify;">برای مک می بایست برنامه را در بخش privacy تایید نمایید.
                                    </p>
                                </div>
                                <div style="margin: 15px;">
                                    <h4>نصب در لینوکس</h4>
                                    <p style="text-align: justify;">برای لینوکس می‌بایست تنها به فایل AppImage دانلود شده
                                        دسترسی اجرایی
                                        بدهید و آن را اجرا کنید.</p>
                                </div>

                            {{/if}}
                            </p>
                        </div>
                    </div>
                </div>
                <div class="accordion-item">
                    <h2 class="accordion-header" id="iclash-heading-2">
                        <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse"
                            data-bs-target="#iclash-collapse-2" aria-expanded="false">
                            افزودن پروفایل به نرم‌افزار (Profile)
                        </button>
                    </h2>
                    <div id="iclash-collapse-2" class="accordion-collapse collapse" data-bs-parent="#iclash-accordion">
                        <div class="accordion-body pt-0">
                            <strong>جهت افزودن پروفایل می توانید از یکی از روش های زیر استفاده کنید.</strong>
                            <br>
                            <br>
                            <div class="tab-pane active show" id="iclash-ins">
                                <div class="accordion-item">
                                    <div class="accordion" id="iclash-ins-accordion">
                                        <h2 class="accordion-header" id="iclash-ins-heading-1">
                                            <button class="accordion-button collapsed" type="button"
                                                data-bs-toggle="collapse" data-bs-target="#iclash-ins-collapse-1"
                                                aria-expanded="false">
                                                نصب خودکار (پیشنهادی)
                                            </button>
                                        </h2>
                                        <div id="iclash-ins-collapse-1" class="accordion-collapse collapse"
                                            style="margin: 20px;" data-bs-parent="#iclash-ins-accordion">
                                            <p style="text-align: justify;">جهت نصب به صورت
                                                <strong>خودکار</strong> فقط کافیست تا بر روی دکمه
                                                زیر
                                                کلیک کنید تا پروفایل (Profile) به صورت خودکار به نرم افزار
                                                افزوده شود .
                                            </p>
                                            <a href="clash://install-config?url={$UniversalSub}/clash&name={$config['appName']}"
                                                class="btn btn-primary">
                                                جهت نصب خودکار کلیک کنید
                                            </a>
                                        </div>
                                    </div>
                                </div>
                                <div class="accordion-item">
                                    <div class="accordion" id="iclash-ins-accordion-2">
                                        <h2 class="accordion-header" id="iclash-ins-heading-2">
                                            <button class="accordion-button collapsed" type="button"
                                                data-bs-toggle="collapse" data-bs-target="#iclash-ins-collapse-2"
                                                aria-expanded="false">
                                                نصب دستی
                                            </button>
                                        </h2>
                                        <div id="iclash-ins-collapse-2" class="accordion-collapse collapse"
                                            data-bs-parent="#iclash-ins-accordion">
                                            <div class="accordion-body pt-0">
                                                <div style="margin: 15px;">
                                                    <p style="text-align: justify;">همچنین می‌توانید در زیر بر روی دکمه
                                                        کپی لینک اشتراک کلیک کنید و لینک
                                                        کپی
                                                        شده را در بخش پروفایل به صورت دستی در بخش ۱ وارد کنید.
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
                                                            src="https://github.com/hiddify/hiddify-config/assets/125398461/3217c5b9-3e18-4bf1-be22-64742e785bbc" />
                                                    </div>
                                                    <br>
                                                    <p>در بخش شماره ۲ اطلاعات مربوط به پروفایل ایمپورت شده شامل تاریخ
                                                        انقضا و حجم ترافیک کلی و حجم
                                                        ترافیک
                                                        مصرف شده را می‌توان مشاهده کرد.</p>
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
                    <h2 class="accordion-header" id="iclash-heading-3">
                        <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse"
                            data-bs-target="#iclash-collapse-3" aria-expanded="false">
                            فعال سازی
                        </button>
                    </h2>
                    <div id="iclash-collapse-3" class="accordion-collapse collapse" data-bs-parent="#iclash-accordion">
                        <div class="accordion-body pt-0">
                            <div style="margin: 15px;">
                                <p style="text-align: justify;">در این منو می‌توانید با دکمه `Enable anti-censorship`
                                    فیلترشکن را
                                    فعال
                                    یا غیرفعال کنید.</p>
                                <div align=center>

                                    <img width=100%
                                        src="https://github.com/hiddify/hiddify-config/assets/125398461/966d10ee-efca-4c33-b15c-cd33fa9f50e1" />
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="accordion-item">
                    <h2 class="accordion-header" id="iclash-heading-4">
                        <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse"
                            data-bs-target="#iclash-collapse-4" aria-expanded="false">
                            منوی Proxy
                        </button>
                    </h2>
                    <div id="iclash-collapse-4" class="accordion-collapse collapse" data-bs-parent="#iclash-accordion">
                        <div class="accordion-body pt-0">
                            <strong>در این منو شما می‌توانید نحوه اجرای پروکسی‌ها (کانفیگ‌ها) را مشخص
                                کنید
                                که شامل ۳ بخش اصلی است.</strong>
                            <br>
                            <br>
                            <div align=center>

                                <img width=80%
                                    src="https://github.com/hiddify/hiddify-config/assets/125398461/10db0fa5-9b7a-4ffc-81af-79d8a6448bca" />
                            </div>
                            <div class="tab-pane active show" id="iclash-proxy">

                                <br>
                                <div class="card-header">
                                    <ul class="nav nav-tabs card-header-tabs" data-bs-toggle="tabs">
                                        <li class="nav-item">
                                            <a href="#tabs-rule-1" class="nav-link active" data-bs-toggle="tab">Rule</a>
                                        </li>
                                        <li class="nav-item">
                                            <a href="#tabs-global-1" class="nav-link" data-bs-toggle="tab">Global</a>
                                        </li>
                                        <li class="nav-item">
                                            <a href="#tabs-direct-1" class="nav-link" data-bs-toggle="tab">Direct</a>
                                        </li>
                                    </ul>
                                </div>
                                <div class="card-body">
                                    <div class="tab-content">
                                        <div class="tab-pane active show" id="tabs-rule-1">
                                            <div style="margin: 15px;">
                                                <p style="text-align: justify;">این حالت پروکسی‌ها را بر اساس Ruleهای
                                                    موجود در پروفایل ایمپورت
                                                    شده
                                                    اجرا می‌کند که خود شامل چندین بخش است.</p>
                                                <strong>PROXY</strong>
                                                <p style="text-align: justify;">این زیر بخش پروکسی‌های موجود در پروفایل
                                                    را اجرا کرده و به اولین
                                                    کانفیگی که پینگ می‌دهد متصل می‌شود.</p>
                                                <strong>automatic</strong>
                                                <p style="text-align: justify;">در این حالت به بهترین کانفیگ که پینگ
                                                    کمتری دارد متصل می‌شود.</p>
                                                <strong>sequential</strong>
                                                <p style="text-align: justify;">در این حالت پروکسی‌ها به صورت نوبتی متصل
                                                    می‌شوند یعنی به نوعی
                                                    تقسیم
                                                    بار انجام می‌شود اما تفاوت اصلی با Load-balance این است که در
                                                    Load-balance به صورت همزمان به
                                                    چند
                                                    کانفیگ مصتل می‌شود ولی در این حالت در لحظه به یک کانفیگ وصل می‌شود.
                                                </p>
                                                <h5>مرتب‌سازی بر اساس لوکیشن</h5>
                                                <p style="text-align: justify;">با استفاده از دکمه شماره ۱ می‌توانید بر
                                                    اساس لوکیشن کانفیگ‌ها را
                                                    مرتب کنید.</p>

                                                <h5>تست کانکشن‌ها</h5>
                                                <p style="text-align: justify;">با استفاده از دکمه شماره ۲ می‌توانید تست
                                                    کانکشن‌ها را بگیرید.
                                                </p>
                                                <div align=center>
                                                    <img width=80%
                                                        src="https://github.com/hiddify/hiddify-config/assets/125398461/0ecb441a-4270-415e-a09d-3c419f066e48" />
                                                </div>


                                            </div>
                                        </div>
                                        <div class="tab-pane" id="tabs-global-1">
                                            <div style="margin: 15px;">
                                                <p style="text-align: justify;">این حالت برای انتخاب کانفیگ به صورت دستی
                                                    است و برای زمانی مفید
                                                    است
                                                    که می‌خواهید از یک کانفیگ خاص استفاده نمایید.</p>

                                                <h5>مرتب‌سازی بر اساس لوکیشن</h5>
                                                <p style="text-align: justify;">با استفاده از دکمه شماره ۱ می‌توانید بر
                                                    اساس لوکیشن کانفیگ‌ها را
                                                    مرتب کنید.</p>

                                                <h5>تست کانکشن‌ها</h5>
                                                <p style="text-align: justify;">با استفاده از دکمه شماره ۲ می‌توانید تست
                                                    کانکشن‌ها را بگیرید.
                                                </p>
                                                <div align=center>

                                                    <img width=100%
                                                        src="https://github.com/hiddify/hiddify-config/assets/125398461/d63a2662-2a02-4141-9a3f-e5befc51aa3b" />
                                                </div>

                                            </div>
                                        </div>
                                        <div class="tab-pane" id="tabs-direct-1">
                                            <div style="margin: 15px;">
                                                <p style="text-align: justify;">با انتخاب این حالت ترافیک
                                                    به صورت مستقیم به اینترنت ارسال می شود و از فیلترشکن عبور نمی‌کند.
                                                </p>

                                                <div align=center>

                                                    <img width=100%
                                                        src="https://github.com/hiddify/hiddify-config/assets/125398461/8c96c53e-a95c-4af5-bab7-572c0d09c88c" />
                                                </div>
                                                <br>
                                                <br>
                                            </div>

                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="accordion-item">
                    <h2 class="accordion-header" id="iclash-heading-5">
                        <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse"
                            data-bs-target="#iclash-collapse-5" aria-expanded="false">
                            منوی Settings
                        </button>
                    </h2>
                    <div id="iclash-collapse-5" class="accordion-collapse collapse" data-bs-parent="#iclash-accordion">
                        <div class="accordion-body pt-0">
                            <div style="margin: 15px;">
                                <div style="margin: 15px;">
                                    <p style="text-align: justify;">در این منو تنظیمات کلی نرم‌افزار انجام می‌شود.
                                    </p>
                                    <div align=center>

                                        <img width=100%
                                            src="https://github.com/hiddify/hiddify-config/assets/125398461/6ab482c8-41fb-4ad0-b37f-6cd88f9426cb" />
                                    </div>
                                    <br>
                                    <br>
                                    <i class="ti ti-rosette-number-1" style="color: red;"></i>
                                    &nbsp;دکمه شماره ۱ یا TUN Mode برای تانل کردن کل ترافیک سیستم است.
                                    <div style="margin: 20px; text-align: justify;">
                                        <i class="ti ti-message-2" style="color: green;"></i>
                                        &nbsp;توجه: برای فعال‌سازی این دکمه باید حتما نرم‌افزار با دسترسی admin در
                                        ویندوز یعنی Run as
                                        Administrator اجرا شود. همچنین در مک و لینوکس هم با دسترسی ادمین یا روت باید
                                        اجرا گردد.
                                    </div>

                                    <i class="ti ti-rosette-number-2" style="color: red;"></i>
                                    &nbsp;دکمه شماره ۲ سیستم پروکسی را فعال می‌کند و برای نرم‌افزارهایی که قابلیت پروکسی
                                    دارند کاربرد
                                    دارد.
                                    یعنی پس از فعال‌سازی این دکمه، باید در نرم‌افزارها در قسمت پروکسی روی آیپی ۱۲۷.۰.۰.۱
                                    و پورت برنامه
                                    که
                                    دیفالت آن ۷۸۹۰ است، می‌توانید به فیلترشکن متصل شوید.
                                    <div style="margin: 20px; text-align: justify;">
                                        <i class="ti ti-message-2" style="color: green;"></i>
                                        &nbsp;این حالت برای زمانی مفید است که <strong>نمی‌خواهید</strong> همه ترافیک خود
                                        را از فیلترشکن
                                        عبور
                                        دهید.
                                    </div>

                                    <i class="ti ti-rosette-number-3" style="color: red;"></i>
                                    &nbsp;دکمه شماره ۳ یا Auto Launch نرم‌افزار را بعد از بالا آمدن سیستم به صورت خودکار
                                    اجرا می‌کند.
                                    <br>
                                    <br>
                                    <i class="ti ti-rosette-number-4" style="color: red;"></i>
                                    &nbsp;دکمه شماره ۴ یا Silent Start باعث می‌شود نرم‌افزار به صورت نامحسوس اجرا گرددو
                                    در نوار وظیفه
                                    آیکون
                                    آن نمایش داده می‌شود.
                                    <br>
                                    <br>
                                    <i class="ti ti-rosette-number-5" style="color: red;"></i>
                                    &nbsp;می‌توان با استفاده از دکمه شماره ۵ آیپی ورژن ۶ را خاموش کرد.
                                    <br>
                                    <br>
                                    <i class="ti ti-rosette-number-6" style="color: red;"></i>
                                    &nbsp;در بخش ۶ می‌توان پورت نرم‌افزار را که دیفالت آن ۷۸۹۰ است، تعیین نمود.
                                    <br>
                                    <br>
                                    <i class="ti ti-rosette-number-7" style="color: red;"></i>
                                    &nbsp;در بخش ۷ می‌توان هسته نرم‌افزار را تعیین کرد که دیفالت آن Clash Meta است.
                                    <br>
                                    <br>
                                    <div align=center>

                                        <img width=100%
                                            src="https://github.com/hiddify/hiddify-config/assets/125398461/3aedd085-b755-4cbb-a61a-301829b69912" />
                                    </div>
                                    <br>
                                    <br>
                                    <i class="ti ti-rosette-number-8" style="color: red;"></i>
                                    &nbsp;در بخش شماره ۸ می‌توان زبان را تعیین نمود.
                                    <br>
                                    <br>
                                    <i class="ti ti-rosette-number-9" style="color: red;"></i>
                                    &nbsp;در بخش شماره ۹ می‌توان تم مربوط به نرم‌افزار را تغییر داد.
                                    <br>
                                    <br>
                                    <i class="ti ti-rosette-number-1" style="color: red;"></i>
                                    <i class="ti ti-rosette-number-0" style="color: red;"></i>
                                    &nbsp;در بخش ۱۰ نیز ورژن نرم‌افزار قابل مشاهده است.
                                    <br>
                                    <br>

                                </div>

                            </div>
                        </div>
                    </div>
                </div>
                <div class="accordion-item">
                    <h2 class="accordion-header" id="iclash-heading-6">
                        <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse"
                            data-bs-target="#iclash-collapse-6" aria-expanded="false">
                            منوی Connections
                        </button>
                    </h2>
                    <div id="iclash-collapse-6" class="accordion-collapse collapse" data-bs-parent="#iclash-accordion">
                        <div class="accordion-body pt-0">


                            <div style="margin: 15px;">
                                <p style="text-align: justify;">در این بخش کانکشن‌هایی که در نرم‌افزار برقرار می‌شود
                                    نمایش داده
                                    می‌شود.
                                    یعنی اگر برنامه ای از فیلترشکن استفاده می‌کند در این بخش نمایش داده می‌شود که این
                                    بخش برای
                                    عیب‌یابی
                                    بسیار مفید است.</p>
                                <div align=center>

                                    <img width=100%
                                        src="https://github.com/hiddify/hiddify-config/assets/125398461/1700bfe0-9a4e-4f4b-ae11-25654d29273b" />
                                </div>
                                <br>
                                <br>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="accordion-item">
                    <h2 class="accordion-header" id="iclash-heading-7">
                        <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse"
                            data-bs-target="#iclash-collapse-7" aria-expanded="false">
                            منوی Rules
                        </button>
                    </h2>
                    <div id="iclash-collapse-7" class="accordion-collapse collapse" data-bs-parent="#iclash-accordion">
                        <div class="accordion-body pt-0">


                            <div style="margin: 15px;">
                                <p style="text-align: justify;">این منو مربوط به Ruleهای موجود در پروفایل ایمپورت شده
                                    است که می‌توان
                                    مشاهده کرد چه مواردی در این فایل تعیین شده است.</p>
                                <div align=center>

                                    <img width=100%
                                        src="https://github.com/hiddify/hiddify-config/assets/125398461/72b8c5e1-fca5-4f0a-bad0-2e4738975f24" />
                                </div>
                                <br>
                                <br>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="accordion-item">
                    <h2 class="accordion-header" id="iclash-heading-8">
                        <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse"
                            data-bs-target="#iclash-collapse-8" aria-expanded="false">
                            منوی Logs
                        </button>
                    </h2>
                    <div id="iclash-collapse-8" class="accordion-collapse collapse" data-bs-parent="#iclash-accordion">
                        <div class="accordion-body pt-0">


                            <div style="margin: 15px;">
                                <p style="text-align: justify;">در این بخش لاگ مربوط به نرم‌افزار قابل مشاهده است که
                                    هنگام عیب یابی
                                    بسیار کاربرد دارد.</p>
                                <div align=center>

                                    <img width=100%
                                        src="https://github.com/hiddify/hiddify-config/assets/125398461/deed841f-24f9-452f-b9fb-84301437223a" />
                                </div>
                                <br>
                                <br>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="accordion-item">
                    <h2 class="accordion-header" id="iclash-heading-9">
                        <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse"
                            data-bs-target="#iclash-collapse-9" aria-expanded="false">
                            گراف ترافیک
                        </button>
                    </h2>
                    <div id="iclash-collapse-9" class="accordion-collapse collapse" data-bs-parent="#iclash-accordion">
                        <div class="accordion-body pt-0">


                            <div style="margin: 15px;">
                                <p style="text-align: justify;">در بخش مشخص شده زیر نیز گرافیک مربوط به ترافیک عبوری از
                                    فیلترشکن
                                    نمایش
                                    داده می‌شود.</p>
                                <div align=center>

                                    <img width=100%
                                        src="https://github.com/hiddify/hiddify-config/assets/125398461/2754c9b1-4072-45d7-8326-c1b86c173686" />
                                </div>
                                <br>
                                <br>
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