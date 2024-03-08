{include file='header.tpl'}

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
                    {if $public_setting['reg_mode'] !== 'close' }
                        <div class="mb-3">
                            <div class="input-group input-group-flat">
                                <input id="invite_code" type="text" class="form-control"
                                       placeholder="کد دعوتنامه ثبت نام{if $public_setting['reg_mode'] === 'open'}（اختیاری）{else}（ضروری）{/if}"
                                       value="{$invite_code}">
                            </div>
                        </div>
                    {/if}
                    {if $public_setting['reg_email_verify']}
                        <div class="mb-3">
                            <div class="input-group mb-2">
                                <input id="emailcode" type="text" class="form-control" placeholder="کد تایید ایمیل">
                                <button id="send-verify-email" class="btn text-blue" type="button"
                                        hx-post="/auth/send" hx-swap="none"
                                        hx-vals='js:{ email: document.getElementById("email").value }'>
                                    دریافت کد
                                </button>
                            </div>
                        </div>
                    {/if}
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
                            {include file='captcha_div.tpl'}
                        {/if}
                        </div>
                    </div>
                    <div class="form-footer">
                        <button class="btn btn-primary w-100"
                                hx-post="/auth/register" hx-swap="none" hx-vals='js:{
                                    {if $public_setting['reg_email_verify']}
                                        emailcode: document.getElementById("emailcode").value,
                                    {/if}
                                    {if $public_setting['enable_reg_captcha']}
                                        {if $public_setting['captcha_provider'] === 'turnstile'}
                                            turnstile: document.querySelector("[name=cf-turnstile-response]").value,
                                        {/if}
                                        {if $public_setting['captcha_provider'] === 'geetest'}
                                            geetest: geetest_result,
                                        {/if}
                                    {/if}
                                    name: document.getElementById("name").value,
                                    email: document.getElementById("email").value,
                                    password: document.getElementById("password").value,
                                    confirm_password: document.getElementById("confirm_password").value,
                                    invite_code: document.getElementById("invite_code").value,
                                    tos: document.getElementById("tos").checked,
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
    {include file='captcha_js.tpl'}
{/if}

{include file='footer.tpl'}
