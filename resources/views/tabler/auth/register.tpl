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
                                <input id="passwd" type="password" class="form-control" placeholder="رمز عبور ورود">
                            </div>
                        </div>
                        <div class="mb-3">
                            <div class="input-group input-group-flat">
                                <input id="repasswd" type="password" class="form-control" placeholder="تکرار رمز ورود به سیستم">
                            </div>
                        </div>
                        {if $public_setting['reg_mode'] !== 'close' }
                            <div class="mb-3">
                                <div class="input-group input-group-flat">
                                    <input id="code" type="text" class="form-control" placeholder="کد دعوتنامه ثبت نام{if $public_setting['reg_mode'] === 'open'}（اختیاری）{else}（ضروری）{/if}" value="{$code}">
                                </div>
                            </div>
                        {/if}
                        {if $public_setting['reg_email_verify']}
                            <div class="mb-3">
                                <div class="input-group mb-2">
                                    <input id="emailcode" type="text" class="form-control" placeholder="کد تایید ایمیل">
                                    <button id="email-verify" class="btn text-blue" type="button">تایید ایمیل</button>
                                </div>
                            </div>
                        {/if}
                        <div class="mb-3">
                            <label class="form-check">
                                <input id="tos" type="checkbox" class="form-check-input" />
                                <span class="form-check-label">
                                    <a href="/tos" tabindex="-1"> شرایط خدمات و سیاست حفظ حریم خصوصی </a>
                                    خوانده ام و موافقم 
                                </span>
                            </label>
                        </div>
                        {if $public_setting['enable_reg_captcha']}
                            {if $public_setting['captcha_provider'] === 'turnstile'}
                                <div class="mb-3">
                                    <div class="input-group mb-3">
                                        <div id="cf-turnstile" class="cf-turnstile" data-sitekey="{$captcha['turnstile_sitekey']}" data-theme="light"></div>
                                    </div>
                                </div>
                            {/if}
                            {if $public_setting['captcha_provider'] === 'geetest'}
                                <div class="mb-3">
                                    <div class="input-group mb-3">
                                        <div id="geetest"></div>
                                    </div>
                                </div>
                            {/if}
                        {/if}
                        <div class="form-footer">
                            <button id="confirm-register" type="submit" class="btn btn-primary w-100">ثبت حساب جدید</button>
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

    <script>
        {if $public_setting['reg_email_verify']}
            $("#email-verify").click(function() {
                $.ajax({
                    type: 'POST',
                    url: '/auth/send',
                    dataType: "json",
                    data: {
                        email: $('#email').val(),
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
        {/if}

        $("#confirm-register").click(function() {
            $.ajax({
                type: 'POST',
                url: '/auth/register',
                dataType: "json",
                data: {
                    {if $public_setting['reg_email_verify']}
                        emailcode: $('#emailcode').val(),
                    {/if}
                    tos: $('#tos').prop('checked'), // true / false (string)
                    code: $('#code').val(),
                    name: $('#name').val(),
                    email: $('#email').val(),
                    passwd: $('#passwd').val(),
                    repasswd: $('#repasswd').val(),
                    {if $public_setting['enable_reg_captcha']}
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
                        window.setTimeout(location.href=data.redir, {$config['jump_delay']});
                    } else {
                        $('#fail-message').text(data.msg);
                        $('#fail-dialog').modal('show');
                    }
                }
            })
        });
    </script>

    {if $public_setting['enable_reg_captcha']}
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
                    riskType:'slide'
                }, function (geetest) {
                    geetest.appendTo("#geetest");
                    geetest.onSuccess(function() {
                        geetest_result = geetest.getValidate();
                    });
                });
            </script>
        {/if}
    {/if}
{include file='footer.tpl'}
