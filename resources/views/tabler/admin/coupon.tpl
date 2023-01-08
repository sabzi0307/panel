{include file='admin/main.tpl'}

<main class="content">
    <div class="content-header ui-content-header">
        <div class="container">
            <h1 class="content-heading">کد تخفیف</h1>
        </div>
    </div>
    <div class="container">
        <section class="content-inner margin-top-no">
            <div class="card">
                <div class="card-main">
                    <div class="card-inner">
                        <div class="form-group form-group-label">
                            <label class="floating-label" for="prefix">کد تخفیف</label>
                            <input class="form-control maxwidth-edit" id="prefix" type="text">
                            <p class="form-control-guide"><i class="mdi mdi-information"></i>برای ایجاد کد تخفیف تصادفی خالی بگذارید</p>
                        </div>
                        <div class="form-group form-group-label">
                            <label class="floating-label" for="credit">مبلغ کد کوپن</label>
                            <input class="form-control maxwidth-edit" id="credit" type="text">
                            <p class="form-control-guide"><i class="mdi mdi-information"></i>百分比，九折就填 10</p>
                        </div>
                        <div class="form-group form-group-label">
                            <label class="floating-label" for="expire">مدت اعتبار کد کوپن(h)</label>
                            <input class="form-control maxwidth-edit" id="expire" type="number" value="1">
                        </div>
                        <div class="form-group form-group-label">
                            <label class="floating-label" for="shop">شناسه سرویس موجود کد تخفیف</label>
                            <input class="form-control maxwidth-edit" id="shop" type="text">
                            <p class="form-control-guide"><i class="mdi mdi-information"></i>در صورت پر نشدن، همه سرویس ها موجود هستند. اگر چند مورد وجود دارد، آنها را با کاماهای نیم پهن انگلیسی جدا کنید.</p>
                        </div>
                        <div class="form-group form-group-label">
                            <label class="floating-label" for="shop">کد کوپن برای هر کاربر در دسترس است، -1 به معنای زمان نامحدود است</label>
                            <input class="form-control maxwidth-edit" id="count" type="number" value="1">
                        </div>
                        <div class="form-group form-group-label">
                            <label for="generate-type">
                                <label class="floating-label" for="sort">نحوه تولید را انتخاب کنید</label>
                                <select id="generate-type" class="form-control maxwidth-edit">
                                    <option value="1">شخصیت مشخص شده</option>
                                    <option value="2">شخصیت های تصادفی</option>
                                    <option value="3">کاراکتر مشخص + کاراکتر تصادفی</option>
                                </select>
                            </label>
                        </div>
                        <div class="form-group">
                            <div class="row">
                                <div class="col-md-10 col-md-push-1">
                                    <button id="coupon" type="submit"
                                            class="btn btn-block btn-brand waves-attach waves-light">کد تخفیف را ایجاد کنید
                                    </button>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="card margin-bottom-no">
                <div class="card-main">
                    <div class="card-inner">
                        <p class="card-heading">کد تخفیف</p>
                        <p>نمایش ورودی ها:
                            {include file='table/checkbox.tpl'}
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
        </section>
    </div>
</main>

{include file='admin/footer.tpl'}

<script>
    {include file='table/js_1.tpl'}
    window.addEventListener('load', () => {
        {include file='table/js_2.tpl'}

        $$.getElementById('coupon').addEventListener('click', () => {
            let couponCode = $$getValue('prefix');

            $.ajax({
                type: "POST",
                url: "/admin/coupon",
                dataType: "json",
                data: {
                    prefix: $$getValue('prefix'),
                    credit: $$getValue('credit'),
                    shop: $$getValue('shop'),
                    onetime: $$getValue('count'),
                    expire: $$getValue('expire'),
                    generate_type: $$getValue('generate-type'),
                },
                success: data => {
                    $("#result").modal();
                    $$.getElementById('msg').innerHTML = data.msg;
                    if (data.ret) {
                        window.setTimeout("location.href='/admin/coupon'", {$config['jump_delay']});
                    }
                },
                error: jqXHR => {
                    alert(`خطایی رخ داده：${
                            jqXHR.status
                            }`);
                }
            })
        })
    })
</script>