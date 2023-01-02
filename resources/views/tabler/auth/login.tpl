{include file='tabler_header.tpl'}

<body class="border-top-wide border-primary d-flex flex-column">
    <div class="page page-center">
        <div class="container-tight py-4">
            <div class="text-center mb-4">
                <a href="#" class="navbar-brand navbar-brand-autodark">
                    <img src="/images/uim-logo-round.png" height="64" alt="">
                </a>
            </div>
            <div class="card card-md">
                <div class="card-body">
                    <h2 class="card-title text-center mb-4">وارد مرکز کاربر شوید</h2>
                    <div class="mb-3">
                        <label class="form-label">ثبت نام ایمیل</label>
                        <input id="email" type="email" class="form-control">
                    </div>
                    <div class="mb-2">
                        <label class="form-label">
                            <span style="padding-left:6px">
                            رمز عبور ورود
                            </span>
                            <span class="form-label-description">
                                <a href="/password/reset">رمز عبور را فراموش کرده اید</a>
                            </span>
                        </label>
                        <div class="input-group input-group-flat">
                            <input id="passwd" type="password" class="form-control" autocomplete="off">
                        </div>
                    </div>
                    <div class="mb-2">
                        <label class="form-label">احراز هویت دو مرحله ای</label>
                        <input id="code" type="email" class="form-control" placeholder="اگر احراز هویت دو مرحله ای تنظیم نشده باشد، می توان آن را خالی گذاشت">
                    </div>
                    <div class="mb-2">
                        <label class="form-check">
                            <input id="remember_me" type="checkbox" class="form-check-input" />
                            <span class="form-check-label">این دستگاه را به خاطر بسپار</span>
                        </label>
                    </div>
                    {if $config['enable_login_captcha'] === true && $config['captcha_provider'] === 'turnstile'}
                    <div class="mb-2">
                        <div class="input-group mb-2">
                            <div class="cf-turnstile" data-sitekey="{$captcha['turnstile_sitekey']}" data-theme="light"></div>
                        </div>
                    </div>
                    {/if}
                    {if $config['enable_login_captcha'] === true && $config['captcha_provider'] === 'geetest'}
                    <div class="mb-2">
                        <div class="input-group mb-2">
                            <div id="geetest"></div>
                        </div>
                    </div>
                    {/if}
                    <div class="form-footer">
                        <button id="login-dashboard" class="btn btn-primary w-100">ورود</button>
                    </div>
                </div>
            </div>
            <div class="text-center text-muted mt-3">
                حساب کاربری ندارید؟ <a href="/auth/register" tabindex="-1">برای ثبت نام کلیک کنید</a>
            </div>
        </div>
    </div>

    <script>
        $("#login-dashboard").click(function() {
            $.ajax({
                type: 'POST',
                url: '/auth/login',
                dataType: "json",
                data: {
                    code: $('#code').val(),
                    email: $('#email').val(),
                    passwd: $('#passwd').val(),
                    remember_me: $('#remember_me').val(),
                    {if $config['enable_login_captcha'] === true && $config['captcha_provider'] === 'turnstile'}
                    turnstile: turnstile.getResponse(),
                    {/if}
                    {if $config['enable_login_captcha'] === true && $config['captcha_provider'] === 'geetest'}
                    geetest: geetest.getValidate(),
                    {/if}
                },
                success: function(data) {
                    if (data.ret == 1) {
                        $('#success-message').text(data.msg);
                        $('#success-dialog').modal('show');
                        setTimeout("window.location.href = '/user'", 1200);
                    } else {
                        $('#fail-message').text(data.msg);
                        $('#fail-dialog').modal('show');
                    }
                }
            })
        });
    </script>

    {if $config['enable_login_captcha'] === true && $config['captcha_provider'] === 'turnstile'}
    <script src="https://challenges.cloudflare.com/turnstile/v0/api.js?compat=recaptcha" async defer></script>
    {/if}
    {if $config['enable_login_captcha'] === true && $config['captcha_provider'] === 'geetest'}
        <script src="http://static.geetest.com/v4/gt4.js"></script>
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
{include file='tabler_footer.tpl'}
