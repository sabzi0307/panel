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
            <div class="row row-cards">
                <div class="col-12">
                    <div class="row row-deck row-cards">
                        <div class="col-sm-12 col-lg-6">
                            <div class="card">
                                <div class="card-body">
                                    <h3 class="card-title">قوانین دعوت</h3>
                                    <ul>
                                        <li>پس از تایید صورت حساب توسط کاربران دعوت شده برای ثبت نام، می توانید مبلغ قبض را دریافت کنید <code>{$public_setting['rebate_ratio'] * 100} %</code>
                                            به عنوان تخفیف</li>
                                        <li>لطفاً اطلاعیه را برای قوانین خاص تخفیف دعوت بررسی کنید یا از طریق سیستم دستور کار از مدیر سؤال کنید</li>
                                        <li>نسبت تخفیف برخی از سرویس ها ممکن است از نسبت فوق پیروی نکند</li>
                                    </ul>
                                    <p>مجموع تخفیفی که در حال حاضر با دعوت از دوستان دریافت می کنید، می باشد <code>{$paybacks_sum}</code> تومان</p>
                                </div>
                            </div>
                        </div>
                        <div class="col-sm-12 col-lg-6">
                            <div class="card">
                                <div class="card-body">
                                    <h3 class="card-title">لینک دعوت</h3>
                                    {if $user->invite_num >= 0}
                                        <p>زمان‌ باقی مانده لینک دعوت：<code>{$user->invite_num}</code></p>
                                    {/if}
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
                        {if $paybacks->count() !== 0}
                            <div class="table-responsive">
                                <table class="table card-table table-vcenter text-nowrap datatable">
                                    <thead>
                                        <tr>
                                            <th>#</th>
                                            <th>شناسه کاربری کاربر دعوت شده</th>
                                            <th>نام مستعار کاربر دعوت شده</th>
                                            <th>مقدار تخفیف</th>
                                            <th>زمان تخفیف</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        {foreach $paybacks as $payback}
                                            <tr>
                                                <td>{$payback->id}</td>
                                                <td>{$payback->userid}</td>
                                                {if $payback->user()!=null}
                                                    <td>{$payback->user()->user_name}</td>
                                                {else}
                                                    <td>از سیستم خارج شده است</td>
                                                {/if}
                                                <td>{$payback->ref_get} تومان</td>
                                                <td>{$payback->datetime}</td>
                                            </tr>
                                        {/foreach}
                                    </tbody>
                                </table>
                            </div>
                        {else}
                            <div class="card-body">
                                <p>هیچ سابقه ای پیدا نشد</p>
                            </div>
                        {/if}
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
                type: "PUT",
                url: "/user/invite",
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