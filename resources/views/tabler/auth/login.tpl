{include file='header.tpl'}
<script src="https://telegram.org/js/telegram-web-app.js"></script>
<body class="border-top-wide border-primary d-flex flex-column">
<div class="page page-center">
    <div class="container-tight my-auto">
        <div class="text-center mb-4">
            <a href="#" class="navbar-brand navbar-brand-autodark" tabindex="-1">
                <img src="/images/uim-logo-round_96x96.png" height="64" alt="SSPanel-UIM Logo">
            </a>
        </div>
        <div class="card card-md">
            <div class="card-body">
                <h2 class="card-title text-center mb-4">ورود به پنل کاربری</h2>
                <div class="mb-3">
                    <label class="form-label">ایمیل</label>
                    <input id="email" type="email" class="form-control" tabindex="1" autofocus>
                </div>
                <div class="mb-2">
                    <label class="form-label" style="display: block; !important">
                        کلمه عبور
                        <span class="form-label-description">
                            <a href="/password/reset" tabindex="-1">آپدیت کلمه عبور</a>
                        </span>
                    </label>
                    <div class="input-group input-group-flat">
                        <input id="password" type="password" class="form-control" autocomplete="off" tabindex="2">
                    </div>
                    
                </div>
                <div class="mb-2">
                    <label class="form-label">احراز هویت دو مرحله ای</label>
                    <input style="direction: rtl;" id="mfa_code" type="email" class="form-control" placeholder="اگر تنظیم نشده، می تواند خالی باشد" tabindex="3">
                </div>
                <div class="mb-2">
                    <label class="form-check">
                        <input id="remember_me" type="checkbox" class="form-check-input" tabindex="4"/>
                        <span class="form-check-label">این دستگاه را به خاطر بسپار</span>
                    </label>
                </div>
                <div class="mb-3">
                    <div class="input-group mb-3">
                    {if $public_setting['enable_login_captcha']}
                        {include file='captcha/div.tpl'}
                    {/if}
                    </div>
                </div>
                <div class="form-footer">
                <input id="t_i" type="hidden" >
                    <button class="btn btn-primary w-100"
                            hx-post="/auth/login" hx-swap="none" hx-vals='js:{
                                {if $public_setting['enable_login_captcha']}
                                    {include file='captcha/ajax.tpl'}
                                {/if}
                                email: document.getElementById("email").value,
                                password: document.getElementById("password").value,
                                mfa_code: document.getElementById("mfa_code").value,
                                remember_me: document.getElementById("remember_me").checked,
                                tu: document.getElementById("t_i").value,
                             }' tabindex="5">
                        ورود
                    </button>
                </div>
            </div>
        </div>
        <div class="text-center text-secondary mt-3">
            حساب کاربری ندارید؟ <a href="/auth/register" tabindex="-1">برای ثبت نام کلیک کنید</a>
        </div>
    </div>
</div>
<!-- <script>
document.getElementById("passwd").addEventListener("keydown", function (event) {
    if (event.key === "Enter") {
        // اجرای عملیات ورود
        event.preventDefault(); // جلوگیری از ارسال فرم
        document.getElementById("login").click(); // تابعی که عملیات ورود را انجام می‌دهد
    }
});
</script> -->
{if $public_setting['enable_login_captcha']}
    {include file='captcha/js.tpl'}
{/if}

{include file='footer.tpl'}
<script>
    if (window.Telegram && window.Telegram.WebApp && Telegram.WebApp.initDataUnsafe && Telegram.WebApp.initDataUnsafe.user) {
        // صفحه از طریق تلگرام Mini-App فراخوانی شده است
        Telegram.WebApp.ready();
        Telegram.WebApp.expand();
         var t = {
                   "user":Telegram.WebApp.initDataUnsafe.user,
                   "webAppQueryId": Telegram.WebApp.initDataUnsafe.query_id
                 }
        document.getElementById('t_i').value =JSON.stringify(t); 
        document.getElementById('name').value =t.user.username; 
        
     
    } else {
        // صفحه از طریق مرورگر فراخوانی شده است
        console.log('Page opened in a regular browser');
    }

    document.body.addEventListener('htmx:afterRequest', function(event) {
    //todo: handle error     
       Telegram.WebApp.close();
    });
</script>