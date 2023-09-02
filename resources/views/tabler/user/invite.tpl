{include file='user/header.tpl'}

<div class="page-wrapper">
    <div class="container-xl">
        <div class="page-header d-print-none text-white">
            <div class="row align-items-center">
                <div class="col">
                    <h2 class="page-title">
                        <span class="home-title">دعوتنامه برای ثبت نام</span>
                    </h2>
                    <div class="page-pretitle my-3">
                        <span class="home-subtitle">مشاهده لینک ثبت دعوتنامه و سابقه تخفیف دعوت</span>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div class="page-body">
        <div class="container-xl">
            <div class="row row-deck row-cards">
                <div class="col-12">
                    <div class="row row-deck row-cards">
                        <div class="col-sm-12 col-lg-6">
                            <div class="card">
                                <div class="card-body">
                                    <h3 class="card-title">قوانین دعوت</h3>
                                    <ul>
                                        <li>پس از تایید صورتحساب توسط کاربران دعوت شده برای ثبت نام، می توانید مبلغ قبض آنها را دریافت کنید <code>{$rebate_ratio_per} %</code>
                                            به عنوان تخفیف</li>
                                        <li>نسبت تخفیف برخی محصولات ممکن است از نسبت فوق تبعیت نکند</li>
                                    </ul>
                                    <p>مجموع تخفیفی که در حال حاضر با دعوت از دوستان دریافت می کنید است <code>{$paybacks_sum}</code> تومان</p>
                                </div>
                            </div>
                        </div>
                        <div class="col-sm-12 col-lg-6">
                            <div class="card">
                                <div class="card-body">
                                    <h3 class="card-title">لینک دعوت</h3>
                                    <input class="form-control" value="{$invite_url}" disabled />
                                </div>
                                <div class="card-footer">
                                    <div class="d-flex">
                                        <a id="reset-url" class="btn text-red btn-link">تنظیم مجدد</a>
                                        <a data-clipboard-text="{$invite_url}" class="copy btn btn-primary ms-auto">کپی</a>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-12 my-3">
                    <div class="card">
                        <div class="card-header">
                            <h3 class="card-title">سابقه تخفیف</h3>
                        </div>
                        <div class="table-responsive">
                            <table class="table card-table table-vcenter text-nowrap datatable">
                                <thead>
                                    <tr>
                                        <th>شناسه ثبت</th>
                                        <th>شناسه کاربری کاربر دعوت شده</th>
                                        <th>نام مستعار کاربر دعوت شده</th>
                                        <th>میزان تخفیف</th>
                                        <th>زمان اعمال تخفیف‍</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    {foreach $paybacks as $payback}
                                    <tr>
                                        <td>{$payback->id}</td>
                                        <td>{$payback->userid}</td>
                                        <td>{$payback->user_name}</td>
                                        <td>{$payback->ref_get} تومان</td>
                                        <td>{$payback->datetime}</td>
                                    </tr>
                                    {/foreach}
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script>
        var clipboard = new ClipboardJS('.copy');
        clipboard.on('success', function(e) {
            $('#success-noreload-message').text('در کلیپ بورد کپی شد');
            $('#success-noreload-dialog').modal('show');
        });

        $("#reset-url").click(function() {
            $.ajax({
                type: "POST",
                url: "/user/invite_reset",
                dataType: "json",
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

{include file='user/footer.tpl'}
