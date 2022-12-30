{include file='admin/main.tpl'}

<main class="content">
    <div class="content-header ui-content-header">
        <div class="container">
            <h1 class="content-heading">دعوت</h1>
        </div>
    </div>
    <div class="container">
        <section class="content-inner margin-top-no">

            <div class="card">
                <div class="card-main">
                    <div class="card-inner">
                        <p>تابع کد دعوت عمومی منسوخ شده است. اگر می خواهید ثبت نام را باز کنید، لطفاً آیتم register_mode را تنظیم کنید تا در .config.php باز شود. </p>
                    </div>
                </div>
            </div>

            <div class="card">
				<div class="card-main">
					<div class="card-inner">
						<div class="form-group form-group-label">
							<label class="floating-label" for="userid">کاربرانی که نیاز به ویرایش دعوت کننده دارند</label>
							<input class="form-control maxwidth-edit" id="userid" type="text">
							<p class="form-control-guide"><i class="mdi mdi-information"></i>شناسه کاربر را وارد کنید</p>
						</div>
						<div class="form-group form-group-label">
							<label class="floating-label" for="refid">شناسه دعوت کننده</label>
							<input class="form-control maxwidth-edit" id="refid" type="number">
						</div>
					</div>
					<div class="card-action">
						<div class="card-action-btn pull-left">
							<a class="btn btn-flat waves-attach" id="confirm"><span class="mdi mdi-check"></span>&nbsp;تغییر</a>
						</div>
					</div>
				</div>
			</div>
            <div class="card">
                <div class="card-main">
                    <div class="card-inner">

                        <div class="form-group form-group-label">
                            <label class="floating-label" for="uid">کاربرانی که نیاز به افزایش تعداد لینک های دعوت دارند</label>
                            <input class="form-control maxwidth-edit" id="uid" type="text">
                            <p class="form-control-guide"><i class="mdi mdi-information"></i>شناسه کاربر یا آدرس ایمیل کامل کاربر را وارد کنید</p>
                        </div>
                        <div class="form-group form-group-label">
                            <label class="floating-label" for="prefix">تعداد لینک های دعوت</label>
                            <input class="form-control maxwidth-edit" id="num" type="number">
                        </div>
                    </div>
                    <div class="card-action">
                        <div class="card-action-btn pull-left">
                            <a class="btn btn-flat waves-attach" id="invite"><span class="mdi mdi-check"></span>&nbsp;افزایش</a>
                        </div>
                    </div>
                </div>
            </div>
            <div class="card margin-bottom-no">
                <div class="card-main">
                    <div class="card-inner">
                        <p class="card-heading">سابقه تخفیف</p>
                        <p>نمایش ورودی ها: {include file='table/checkbox.tpl'}
                        </p>
                        <div class="card-table">
                            <div class="table-responsive">
                                {include file='table/table.tpl'}
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            {include file='dialog.tpl'}
    </div>
</main>

{include file='admin/footer.tpl'}

<script>
    {include file='table/js_1.tpl'}
    $$.getElementById('invite').addEventListener('click', () => {
        $.ajax({
            type: "POST",
            url: "/admin/invite",
            dataType: "json",
            data: {
                prefix: $$getValue('invite'),
                uid: $$getValue('uid'),
                num: $$getValue('num'),
            },
            success: data => {
                if (data.ret) {
                    $("#result").modal();
                    $$.getElementById('msg').innerHTML = data.msg;
                    window.setTimeout("location.href='/admin/invite'", {$config['jump_delay']} );
                } else {
                    $("#result").modal();
                    $$.getElementById('msg').innerHTML = data.msg;
                }
                // window.location.reload();
            },
            error: jqXHR => {
                alert(`خطایی رخ داده：${
                        jqXHR.status
                        }`);
            }
        })
    })

    $$.getElementById('confirm').addEventListener('click', () => {
        $.ajax({
            type: "POST",
            url: "/admin/chginvite",
            dataType: "json",
            data: {
                prefix: $$.getElementById('confirm').value,
                userid: $$.getElementById('userid').value,
                refid: $$.getElementById('refid').value,
            },
            success: data => {
                if (data.ret) {
                    $("#result").modal();
                    $$.getElementById('msg').innerHTML = data.msg;
                    window.setTimeout("location.href='/admin/invite'", {$config['jump_delay']} );
                } else {
                    $("#result").modal();
                    $$.getElementById('msg').innerHTML = data.msg;
                }
                // window.location.reload();
            },
            error: jqXHR => {
                alert(`خطایی رخ داده：${ldelim}jqXHR.status{rdelim}`);
            }
        })
    })

    window.addEventListener('load', () => {
        {include file='table/js_2.tpl'}
    });
</script>