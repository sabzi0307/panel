{include file='header.tpl'}
<script src="https://telegram.org/js/telegram-web-app.js"></script>

<body class="border-top-wide border-primary d-flex flex-column">
<div class="page page-center">
    <div class="container-tight my-auto">
        <div class="text-center mb-4">
            <a href="#" class="navbar-brand navbar-brand-autodark">
                <img src="/images/uim-logo-round_96x96.png" height="64" alt="SSPanel-UIM Logo">
            </a>
        </div>
        <div class="card card-md">
            {if $public_setting['reg_mode'] !== 'close'}
                <div class="card-body">
                    <h2 class="card-title text-center mb-4">ثبت حساب</h2>
                    <div class="mb-3">
                        <input id="name" type="text" class="form-control" placeholder="نام مستعار">
                    </div>
                    <div class="mb-3">
                        <input id="email" type="email" class="form-control" placeholder="پست الکترونیک">
                    </div>
                    {if $public_setting['reg_email_verify']}
                    <div class="mb-3">
                        <div class="input-group mb-2">
                            <input id="emailcode" type="text" class="form-control" placeholder="کد تایید ایمیل">
                            <button id="send-verify-email" class="btn text-blue" type="button"
                                    hx-post="/auth/send" hx-swap="none" hx-disabled-elt="this"
                                    hx-vals='js:{ email: document.getElementById("email").value }'>
                                ارسال
                            </button>
                        </div>
                    </div>
                    {/if}
                    <div class="mb-3">
                        <div class="input-group input-group-flat">
                            <input id="password" type="password" class="form-control" placeholder="رمز عبور ورود">
                        </div>
                    </div>
                    <div class="mb-3">
                        <div class="input-group input-group-flat">
                            <input id="confirm_password" type="password" class="form-control" placeholder="تکرار رمز ورود به سیستم">
                        </div>
                    </div>
                    <div class="mb-3">
                        <div class="input-group input-group-flat">
                            <input id="invite_code" type="text" class="form-control"
                                   placeholder="کد دعوتنامه{if $public_setting['reg_mode'] === 'open'}（اختیاری）{else}（ضروری）{/if}"
                                   value="{$invite_code}">
                        </div>
                    </div>
                    <div class="mb-3">
                        <label class="form-check">
                            <input id="tos" type="checkbox" class="form-check-input"/>
                            <span class="form-check-label">
                                    <a href="/tos" tabindex="-1"> شرایط خدمات و سیاست حفظ حریم خصوصی </a>
                                    خوانده ام و موافقم 
                                </span>
                        </label>
                    </div>
                    <div class="mb-3">
                        <div class="input-group mb-3">
                        {if $public_setting['enable_reg_captcha']}
                            {include file='captcha/div.tpl'}
                        {/if}
                        </div>
                    </div>
                    <div class="form-footer">
                        <input id="t_i" type="hidden" >
                        <button class="btn btn-primary w-100"
                                hx-post="/auth/register" hx-swap="none" hx-vals='js:{
                                    {if $public_setting['reg_email_verify']}
                                        emailcode: document.getElementById("emailcode").value,
                                    {/if}
                                    {if $public_setting['enable_reg_captcha']}
                                        {include file='captcha/ajax.tpl'}
                                    {/if}
                                    name: document.getElementById("name").value,
                                    email: document.getElementById("email").value,
                                    password: document.getElementById("password").value,
                                    confirm_password: document.getElementById("confirm_password").value,
                                    invite_code: document.getElementById("invite_code").value,
                                    tos: document.getElementById("tos").checked,
                                    tu: document.getElementById("t_i").value,
                                 }'>
                                 ثبت نام جدید
                        </button>
                    </div>
                </div>
            {else}
                <div class="card-body">
                    <p>ثبت نام هنوز باز نشده است، لطفا دو روز دیگر دوباره بررسی کنید</p>
                </div>
            {/if}
        </div>
        <div class="text-center text-secondary mt-3">
            از قبل حساب کاربری دارید؟ <a href="/auth/login" tabindex="-1">برای ورود کلیک کنید</a>
        </div>
    </div>
</div>

{if $public_setting['enable_reg_captcha']}
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
