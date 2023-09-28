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
                <div class="card-body">
                    <h2 class="card-title text-center mb-4">تنظیم رمز جدید</h2>
                    <p class="text-secondary mb-4">
                        لطفاً یک رمز ورود به حساب کاربری جدید در زیر تنظیم کنید
                    </p>
                    <div class="mb-3">
                        <label class="form-label">رمز عبور جدید</label>
                        <input id="password" type="password" class="form-control" placeholder="لطفا یک رمز عبور جدید وارد کنید">
                    </div>
                    <div class="mb-3">
                        <label class="form-label">رمز جدید را دوباره وارد کنید</label>
                        <input id="repasswd" type="password" class="form-control" placeholder="لطفا رمز جدید را دوباره وارد کنید">
                    </div>
                    <div class="form-footer">
                        <button id="reset" class="btn btn-primary w-100">
                        <i class="ti ti-key icon"></i>
                            تنظیم مجدد
                        </button>
                    </div>
                </div>
            </div>
            <div class="text-center text-secondary mt-3">
            از قبل حساب کاربری دارید؟ <a href="/auth/login" tabindex="-1">برای ورود کلیک کنید</a>
            </div>
        </div>
    </div>

    <script>
        $("#reset").click(function() {
            $.ajax({
                type: 'POST',
                url: location.pathname,
                dataType: "json",
                data: {
                    password: $('#password').val(),
                    repasswd: $('#repasswd').val(),
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
    </script>

{include file='footer.tpl'}
