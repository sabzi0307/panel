{include file='admin/main.tpl'}

<main class="content">
    <div class="content-header ui-content-header">
        <div class="container">
            <h1 class="content-heading">ویرایش آیتم</h1>
        </div>
    </div>
    <div class="container">
        <div class="col-lg-12 col-sm-12">
            <section class="content-inner margin-top-no">
                <div class="card">
                    <div class="card-main">
                        <div class="card-inner">
                            <div class="form-group form-group-label">
                                <label class="floating-label" for="name">نام</label>
                                <input class="form-control maxwidth-edit" id="name" type="text" value="{$shop->name}">
                            </div>
                            <div class="form-group form-group-label">
                                <label class="floating-label" for="price">قیمت</label>
                                <input class="form-control maxwidth-edit" id="price" type="text" value="{$shop->price}">
                            </div>
                            <div class="form-group form-group-label">
                                <label class="floating-label" for="auto_renew">روزهای تمدید خودکار</label>
                                <input class="form-control maxwidth-edit" id="auto_renew" type="text"
                                       value="{$shop->auto_renew}">
                                <p class="form-control-guide"><i class="mdi mdi-information"></i>0 به این معنی است که تمدید خودکار مجاز نیست و دیگر به این معنی است که پس از گذشت چند روز، پول به طور خودکار از حساب کاربر کسر می شود.
                                </p>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="card">
                    <div class="card-main">
                        <div class="card-inner">
                            <div class="form-group form-group-label">
                                <label class="floating-label" for="bandwidth">ترافیک（GB）</label>
                                <input class="form-control maxwidth-edit" id="bandwidth" type="text"
                                       value="{$shop->bandwidth()}">
                            </div>
                            <div class="form-group form-group-label">
                                <div class="checkbox switch">
                                    <label for="auto_reset_bandwidth">
                                        <input {if $shop->auto_reset_bandwidth==1}checked{/if} class="access-hide"
                                               id="auto_reset_bandwidth" type="checkbox"><span
                                                class="switch-toggle"></span>هنگام تمدید، ترافیک کاربر را به مقدار ترافیک بالا ریست کنید
                                    </label>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="card">
                    <div class="card-main">
                        <div class="card-inner">
                            <div class="form-group form-group-label">
                                <label class="floating-label" for="traffic-package-min">حداقل سطح کاربر قابل خرید</label>
                                <input class="form-control maxwidth-edit" id="traffic-package-min" type="text"
                                value="{if $shop->trafficPackage()}{$shop->content['traffic_package']['class']['min']}{else}0{/if}">
                            </div>
                            <div class="form-group form-group-label">
                                <label class="floating-label" for="traffic-package-max">حداکثر سطح کاربر قابل خرید</label>
                                <input class="form-control maxwidth-edit" id="traffic-package-max" type="text"
                                value="{if $shop->trafficPackage()}{$shop->content['traffic_package']['class']['max']}{else}0{/if}">
                            </div>
                            <div class="form-group form-group-label">
                                <div class="checkbox switch">
                                    <label for="traffic-package-enable">
                                        <input {if $shop->trafficPackage()}checked{/if} class="access-hide" id="traffic-package-enable" type="checkbox">
                                        <span class="switch-toggle"></span>تنظیم این محصول به عنوان بسته ترافیک اضافه
                                    </label>
                                    <p class="form-control-guide">
                                        <i class="mdi mdi-information"></i>
                                        پس از تنظیم به عنوان بسته ترافیک اضافه، تنظیماتی غیر از ترافیک بدست آمده در زمان خرید نامعتبر است
                                    </p>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="card">
                    <div class="card-main">
                        <div class="card-inner">
                            <div class="form-group form-group-label">
                                <label class="floating-label" for="expire">روزهای اعتبار حساب</label>
                                <input class="form-control maxwidth-edit" id="expire" type="text"
                                       value="{$shop->expire()}">
                            </div>
                        </div>
                    </div>
                </div>
                <div class="card">
                    <div class="card-main">
                        <div class="card-inner">
                            <div class="form-group form-group-label">
                                <label class="floating-label" for="class">سطح</label>
                                <input class="form-control maxwidth-edit" id="class" type="text"
                                       value="{$shop->userClass()}">
                            </div>
                            <div class="form-group form-group-label">
                                <label class="floating-label" for="class_expire">روزهای اعتبار سطح</label>
                                <input class="form-control maxwidth-edit" id="class_expire" type="text"
                                       value="{$shop->classExpire()}">
                            </div>
                            <p class="form-control-guide"><i class="mdi mdi-information"></i>در صورت نیاز به استفاده از تابع سطح، لطفاً دو مورد [سطح] و [دوره اعتبار سطح] را همزمان پر کنید.</p>
                        </div>
                    </div>
                </div>
                <div class="card">
                    <div class="card-main">
                        <div class="card-inner">
                            <div class="form-group form-group-label">
                                <label class="floating-label" for="reset_exp">در چند روز</label>
                                <input class="form-control maxwidth-edit" id="reset_exp" type="number"
                                       value="{$shop->resetExp()}">
                            </div>
                            <div class="form-group form-group-label">
                                <label class="floating-label" for="reset">چند روز</label>
                                <input class="form-control maxwidth-edit" id="reset" type="number"
                                       value="{$shop->reset()}">
                            </div>
                            <div class="form-group form-group-label">
                                <label class="floating-label" for="reset_value">ترافیک تنظیم مجدد چقدر GB است</label>
                                <input class="form-control maxwidth-edit" id="reset_value" type="number"
                                       value="{$shop->resetValue()}">
                            </div>
                        </div>
                    </div>
                </div>
                <div class="card">
                    <div class="card-main">
                        <div class="card-inner">
                            <div class="form-group form-group-label">
                                <label class="floating-label" for="speedlimit">محدودیت سرعت پورت</label>
                                <input class="form-control maxwidth-edit" id="speedlimit" type="number"
                                       value="{$shop->speedlimit()}">
                            </div>
                            <div class="form-group form-group-label">
                                <label class="floating-label" for="connector">محدودیت های IP</label>
                                <input class="form-control maxwidth-edit" id="connector" type="number"
                                       value="{$shop->connector()}">
                            </div>
                        </div>
                    </div>
                </div>
                <div class="card">
                    <div class="card-main">
                        <div class="card-inner">
                            <div class="form-group form-group-label">
                                <label class="floating-label" for="content_extra">پشتیبانی خدمات</label>
                                <input class="form-control maxwidth-edit" id="content_extra" type="text"
                                       value="{foreach $shop->contentExtra() as $service}{$service[0]}-{$service[1]}{if $service@last}{else};{/if}{/foreach}">
                                <p class="form-control-guide"><i class="mdi mdi-information"></i>مثال：<code>check-توزیع جهانی گره;clear-پاسخ سریع خدمات مشتری</code>，سمت چپ علامت منهای کد لوگو و سمت راست متن است که با ;
                                </p>
                                <p class="form-control-guide">کد نماد مراجعه کنید：<a
                                            href="https://materialdesignicons.com/">Material Design Icons</a>
                                </p>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="card">
                    <div class="card-main">
                        <div class="card-inner">

                            <div class="form-group">
                                <div class="row">
                                    <div class="col-md-10 col-md-push-1">
                                        <button id="submit" type="submit"
                                                class="btn btn-block btn-brand waves-attach waves-light">保存
                                        </button>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                {include file='dialog.tpl'}
        </div>
    </div>
</main>

{include file='admin/footer.tpl'}

<script>
    window.addEventListener('load', () => {
        function submit() {
            if ($$.getElementById('auto_reset_bandwidth').checked) {
                var auto_reset_bandwidth = 1;
            } else {
                var auto_reset_bandwidth = 0;
            }
            let contentExtra = $$getValue('content_extra');
            if (contentExtra === '' || contentExtra === '-') {
                contentExtra = 'check-توزیع جهانی گره;check-پاسخ سریع خدمات مشتری;check-کلاینت پلتفرم کامل';
            }
            let data = {
                name: $$getValue('name'),
                auto_reset_bandwidth,
                price: $$getValue('price'),
                auto_renew: $$getValue('auto_renew'),
                bandwidth: $$getValue('bandwidth'),
                speedlimit: $$getValue('speedlimit'),
                connector: $$getValue('connector'),
                expire: $$getValue('expire'),
                class: $$getValue('class'),
                class_expire: $$getValue('class_expire'),
                reset: $$getValue('reset'),
                reset_value: $$getValue('reset_value'),
                reset_exp: $$getValue('reset_exp'),
                content_extra: contentExtra,
            }
            if ($$.getElementById('traffic-package-enable').checked) {
                data.traffic_package = {
                    class: {
                        min: $$getValue('traffic-package-min'),
                        max: $$getValue('traffic-package-max')
                    }
                }
            }
            $.ajax({
                type: "PUT",
                url: "/admin/shop/{$shop->id}",
                dataType: "json",
                data,
                success: data => {
                    if (data.ret) {
                        $("#result").modal();
                        $$.getElementById('msg').innerHTML = data.msg;
                        window.setTimeout("location.href='/admin/shop'", {$config['jump_delay']});
                    } else {
                        $("#result").modal();
                        $$.getElementById('msg').innerHTML = data.msg;
                    }
                },
                error: jqXHR => {
                    $("#result").modal();
                    $$.getElementById('msg').innerHTML = `خطایی رخ داده：${
                            jqXHR.status
                            }`;
                }
            });
        }
        $("html").keydown(event => {
            if (event.keyCode === 13) {
                login();
            }
        });
        $$.getElementById('submit').addEventListener('click', submit);
    })
</script>
