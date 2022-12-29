<div class="card auth-tg cust-model">
    <div class="card-main">
        <nav class="tab-nav margin-top-no margin-bottom-no">
            <ul class="nav nav-justified">
                <li class="active">
                    <a class="waves-attach" data-toggle="tab" href="#number_login">با یک کلیک/ورود کد تایید</a>
                </li>
                <li>
                    <a class="waves-attach" data-toggle="tab" href="#qrcode_login">با اسکن کد وارد شوید</a>
                </li>
            </ul>
        </nav>
        <div class="tab-pane fade active in" id="number_login">
            <div class="card-header">
                <div class="card-inner">
                    <h1 class="card-heading" style=" text-align:center;font-weight:bold;">ورود به تلگرام</h1>
                </div>
            </div>
            <div class="card-inner">
                <div class="text-center">
                    <p>ورود با یک کلیک</p>
                </div>
                <p id="telegram-alert">در حال بارگذاری تلگرام، اگر برای مدت طولانی نمایش داده نشد، لطفاً صفحه را رفرش کنید یا پروکسی را بررسی کنید</p>
                <div class="text-center" id="telegram-login-box"></div>
                <p>یا یک حساب ربات اضافه کنید<a href="https://t.me/{$telegram_bot}">@{$telegram_bot}</a>，شماره زیر را برای آن ارسال کنید.
                </p>
                <div class="text-center">
                    <h2><code id="code_number">{$login_number}</code></h2>
                </div>
            </div>
        </div>
        <div class="tab-pane fade" id="qrcode_login">
            <div class="card-header">
                <div class="card-inner">
                    <h1 class="card-heading" style=" text-align:center;font-weight:bold;">ورود کد اسکن تلگرام</h1>
                </div>
            </div>
            <div class="card-inner">
                <p>اضافه کردن حساب ربات <a href="https://t.me/{$telegram_bot}">@{$telegram_bot}</a>，از کد QR زیر عکس بگیرید و آن را ارسال کنید.
                </p>
                <div class="form-group form-group-label">
                    <div class="text-center qr-center">
                        <div id="telegram-qr"></div>
                    </div>
                </div>

            </div>
        </div>
    </div>
</div>