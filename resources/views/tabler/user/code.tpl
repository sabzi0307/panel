{include file='user/main.tpl'}

<main class="content">
    <div class="content-header ui-content-header">
        <div class="container">
            <h1 class="content-heading">شارژ مجدد</h1>
        </div>
    </div>
    <div class="container">
        <section class="content-inner margin-top-no">
            <div class="row">
                <div class="col-lg-12 col-md-12">
                    <div class="card margin-bottom-no">
                        <div class="card-main">
                            <div class="card-inner">
                                <div class="card-inner">
                                    <p class="card-heading">موارد احتیاط</p>
                                    <p>پس از تکمیل شارژ، باید صفحه وب را به‌روزرسانی کنید تا تعادل را بررسی کنید، معمولاً در عرض یک دقیقه. اگر تمدید خودکار به دلیل موجودی ناکافی انجام نشود، در صورت کافی بودن موجودی، هزینه تمدید به طور خودکار کسر می شود.</p>
                                    {if $public_setting['enable_admin_contact'] == true}
                                        <p class="card-heading">در صورت عدم دریافت شارژ لطفا تماس بگیرید：</p>
                                        {if $public_setting['admin_contact1'] != ''}
                                            <li>{$public_setting['admin_contact1']}</li>
                                        {/if}
                                        {if $public_setting['admin_contact2'] != ''}
                                            <li>{$public_setting['admin_contact2']}</li>
                                        {/if}
                                        {if $public_setting['admin_contact3'] != ''}
                                            <li>{$public_setting['admin_contact3']}</li>
                                        {/if}
                                    {/if}
                                    <br/>
                                    <p><i class="mdi mdi-currency-usd icon-lg"></i>موجودی فعلی：<font color="#399AF2" size="5">{$user->money}</font> تومان</p>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                {if count($payments) > 0}
                    {foreach from=$payments item=payment}
                        <div class="col-lg-12 col-md-12">
                            <div class="card margin-bottom-no">
                                <div class="card-main" id="card-{$payment::_name()}">
                                    <div class="card-inner">
                                        {$payment::getPurchaseHTML()}
                                    </div>
                                </div>
                            </div>
                        </div>
                    {/foreach}
                {/if}
                <div class="col-lg-12 col-md-12">
                    <div class="card margin-bottom-no">
                        <div class="card-main">
                            <div class="card-inner">
                                <div class="card-inner">
                                    <div class="cardbtn-edit">
                                        <div class="card-heading">کد شارژ</div>
                                        <button class="btn btn-flat" id="code-update">
                                            <span class="mdi mdi-check"></span>
                                        </button>
                                    </div>
                                    <div class="form-group form-group-label">
                                        <label class="floating-label" for="code">کد شارژ</label>
                                        <input class="form-control maxwidth-edit" id="code" type="text">
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-lg-12 col-md-12">
                    <div class="card margin-bottom-no">
                        <div class="card-main">
                            <div class="card-inner">
                                <div class="card-table">
                                    <div class="table-responsive table-user">
                                        {$render}
                                        <table class="table table-hover">
                                            <tr>
                                                <!--<th>ID</th> -->
                                                <th>کد</th>
                                                <th>انواع</th>
                                                <th>عمل کنند</th>
                                                <th>زمان استفاده</th>
                                            </tr>
                                            {foreach $codes as $code}
                                                {if $code->type!=-2}
                                                    <tr>
                                                        <!--	<td>#{$code->id}</td>  -->
                                                        <td>{$code->code}</td>
                                                        {if $code->type==-1}
                                                            <td>شارژ مجدد مبلغ</td>
                                                        {/if}
                                                        {if $code->type==10001}
                                                            <td>شارژ ترافیک</td>
                                                        {/if}
                                                        {if $code->type==10002}
                                                            <td>تمدید کاربر</td>
                                                        {/if}
                                                        {if $code->type>=1&&$code->type<=10000}
                                                            <td>تمدید درجه - درجه{$code->type}</td>
                                                        {/if}
                                                        {if $code->type==-1}
                                                            <td>شارژ مجدد {$code->number} تومان</td>
                                                        {/if}
                                                        {if $code->type==10001}
                                                            <td>شارژ مجدد {$code->number} GB ترافیک</td>
                                                        {/if}
                                                        {if $code->type==10002}
                                                            <td>تمدید مدت اعتبار حساب {$code->number} روز</td>
                                                        {/if}
                                                        {if $code->type>=1&&$code->type<=10000}
                                                            <td>اعتبار رتبه بندی تمدید شده {$code->number} 天</td>
                                                        {/if}
                                                        <td>{$code->usedatetime}</td>
                                                    </tr>
                                                {/if}
                                            {/foreach}
                                        </table>
                                        {$render}
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div aria-hidden="true" class="modal modal-va-middle fade" id="readytopay" role="dialog" tabindex="-1">
                    <div class="modal-dialog modal-xs">
                        <div class="modal-content">
                            <div class="modal-heading">
                                <a class="modal-close" data-dismiss="modal">×</a>
                                <h2 class="modal-title">اتصال به درگاه پرداخت</h2>
                            </div>
                            <div class="modal-inner">
                                <p id="title">با تشکر از حمایت شما، لطفا صبور باشید</p>
                            </div>
                        </div>
                    </div>
                </div>
                {include file='dialog.tpl'}
            </div>
        </section>
    </div>
</main>
<script>
    $(document).ready(function () {
        $("#code-update").click(function () {
            $.ajax({
                type: "POST",
                url: "code",
                dataType: "json",
                data: {
                    code: $$getValue('code')
                },
                success: (data) => {
                    if (data.ret) {
                        $("#result").modal();
                        $$.getElementById('msg').innerHTML = data.msg;
                        window.setTimeout("location.href=window.location.href", {$config['jump_delay']});
                    } else {
                        $("#result").modal();
                        $$.getElementById('msg').innerHTML = data.msg;
                        window.setTimeout("location.href=window.location.href", {$config['jump_delay']});
                    }
                },
                error: (jqXHR) => {
                    $("#result").modal();
{literal}
                    $$.getElementById('msg').innerHTML = `خطایی رخ داده：${jqXHR.status}`;
{/literal}
                }
            })
        })
    })
</script>

{include file='user/footer.tpl'}
