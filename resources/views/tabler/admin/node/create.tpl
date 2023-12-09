{include file='admin/header.tpl'}

<script src="//{$config['jsdelivr_url']}/npm/jsoneditor@latest/dist/jsoneditor.min.js"></script>
<link href="//{$config['jsdelivr_url']}/npm/jsoneditor@latest/dist/jsoneditor.min.css" rel="stylesheet" type="text/css">

<div class="page-wrapper">
    <div class="container-xl">
        <div class="page-header d-print-none text-white">
            <div class="row align-items-center">
                <div class="col">
                    <h2 class="page-title">
                        <span class="home-title">ایجاد سرور</span>
                    </h2>
                    <div class="page-pretitle my-3">
                        <span class="home-subtitle">سرور های مختلف ایجاد کنید</span>
                    </div>
                </div>
                <div class="col-auto ms-auto d-print-none">
                    <div class="btn-list">
                        <a id="create-node" href="#" class="btn btn-primary">
                            <i class="icon ti ti-device-floppy"></i>
                            ذخیره
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div class="page-body">
        <div class="container-xl">
            <div class="row row-deck row-cards">
                <div class="col-md-6 col-sm-12">
                    <div class="card">
                        <div class="card-header card-header-light">
                            <h3 class="card-title">اطلاعات اولیه</h3>
                        </div>
                        <div class="card-body">
                            <div class="form-group mb-3 row">
                                <label class="form-label col-3 col-form-label required">نام</label>
                                <div class="col">
                                    <input id="name" type="text" class="form-control" value="">
                                </div>
                            </div>
                            <div class="form-group mb-3 row">
                                <label class="form-label col-3 col-form-label required">آدرس اتصال</label>
                                <div class="col">
                                    <input id="server" type="text" class="form-control" value="">
                                </div>
                            </div>
                            <div class="form-group mb-3 row">
                                <label class="form-label col-3 col-form-label required">سرعت ترافیک</label>
                                <div class="col">
                                    <input id="traffic_rate" type="text" class="form-control" value="">
                                </div>
                            </div>
                            <div class="form-group mb-3 row">
                                <label class="form-label col-3 col-form-label">نوع دسترسی</label>
                                <div class="col">
                                    <select id="sort" class="col form-select">
                                        <option value="14">Trojan</option>
                                        <option value="11">V2Ray</option>
                                        <option value="3">Http</option>
                                        <option value="2">TUIC</option>
                                        <option value="1">Shadowsocks2022</option>
                                        <option value="0">Shadowsocks</option>
                                    </select>
                                </div>
                            </div>
                            <div class="form-group mb-3 row">
                                <label class="form-label col-3 col-form-label">پیکربندی سفارشی</label>
                                <div id="custom_config"></div>
                                <label class="form-label col-form-label">
                                    جهت افزودن پیکربندی سفارشی به
                                   
                                    <a href="//wiki.sspanel.org/#/custom-config"
                                        target="_blank">
                                        wiki.sspanel.org/#/custom-config
                                    </a>

                                    مراجعه فرمایید
                                </label>
                            </div>
                            <div class="form-group mb-3 row">
                                <span class="col">نمایش سرور</span>
                                <span class="col-auto">
                                    <label class="form-check form-check-single form-switch">
                                        <input id="type" class="form-check-input" type="checkbox" checked="">
                                    </label>
                                </span>
                            </div>
                            <div class="hr-text">
                                <span>نسبت دینامیکی</span>
                            </div>
                            <div class="form-group mb-3 row">
                                <span class="col">فعال کردن ضریب ترافیک پویا</span>
                                <span class="col-auto">
                                    <label class="form-check form-check-single form-switch">
                                        <input id="is_dynamic_rate" class="form-check-input" type="checkbox" checked="">
                                    </label>
                                </span>
                            </div>
                                <label class="form-label col-3 col-form-label">روش محاسبه دینامیک</label>
                                <div class="col">
                                    <select id="dynamic_rate_type" class="col form-select">
                                        <option value="0">Logistic</option>
                                        <option value="1">Linear</option>
                                    </select>
                                </div>
                            </div>
                            <div class="form-group mb-3 row">
                                <label class="form-label col-3 col-form-label">Maximum ratio</label>
                                <div class="col">
                                    <input id="max_rate" type="text" class="form-control" value="">
                                </div>
                            </div>
                            <div class="form-group mb-3 row">
                                <label class="form-label col-3 col-form-label">Maximum override time (hours)</label>
                                <div class="col">
                                    <input id="max_rate_time" type="text" class="form-control" value="">
                                </div>
                            </div>
                            <div class="form-group mb-3 row">
                                <label class="form-label col-3 col-form-label">Minimum ratio</label>
                                <div class="col">
                                    <input id="min_rate" type="text" class="form-control" value="">
                                </div>
                            </div>
                            <div class="form-group mb-3 row">
                                <label class="form-label col-3 col-form-label">Minimum override time (hours)</label>
                                <div class="col">
                                    <input id="min_rate_time" type="text" class="form-control" value="">
                                </div>
                                <label class="form-label col-form-label">
                                    حداکثر زمان لغو باید بیشتر از حداقل زمان لغو باشد، در غیر این صورت اثری نخواهد داشت
                                </label>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-md-6 col-sm-12">
                    <div class="card">
                        <div class="card-header card-header-light">
                            <h3 class="card-title">سایر اطلاعات</h3>
                        </div>
                        <div class="card-body">
                            <div class="form-group mb-3 row">
                                <label class="form-label col-3 col-form-label required">سطح</label>
                                <div class="col">
                                    <input id="node_class" type="text" class="form-control" value="">
                                </div>
                            </div>
                            <div class="form-group mb-3 row">
                                <label class="form-label col-3 col-form-label required">گروه</label>
                                <div class="col">
                                    <input id="node_group" type="text" class="form-control" value="">
                                </div>
                            </div>
                            <div class="hr-text">
                                <span>تنظیمات ترافیک</span>
                            </div>
                            <div class="form-group mb-3 row">
                                <label class="form-label col-3 col-form-label required">ترافیک موجود (GB)</label>
                                <div class="col">
                                    <input id="node_bandwidth_limit" type="text" class="form-control" value="">
                                </div>
                            </div>
                            <div class="form-group mb-3 row">
                                <label class="form-label col-3 col-form-label required">تاریخ تنظیم مجدد ترافیک</label>
                                <div class="col">
                                    <input id="bandwidthlimit_resetday" type="text" class="form-control" value="">
                                </div>
                            </div>
                            <div class="form-group mb-3 row">
                                <label class="form-label col-3 col-form-label required">محدودیت نرخ داده (Mbps)</label>
                                <div class="col">
                                    <input id="node_speedlimit" type="text" class="form-control" value="">
                                </div>
                            </div>
                            <div class="form-group mb-3 row" id="routedns" style="display: none;">
                                <label class="hr-text">Route Dns</label>
                                <div class="form-group mb-3 row">
                                    <span class="col">فعال کردن RouteDns</span>
                                    <span class="col-auto">
                                        <label class="form-check form-check-single form-switch">
                                            <input id="is_route_dns" class="form-check-input" type="checkbox">
                                        </label>
                                    </span>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
    const container = document.getElementById('custom_config');
    let options = {
        modes: ['code', 'tree'],
        // ace: ace,
    };
    const editor = new JSONEditor(container, options);
    $("#create-node").click(function() {
        $.ajax({
            url: '/admin/node',
            type: 'POST',
            dataType: "json",
            data: {
                {foreach $update_field as $key}
                    {$key}: $('#{$key}').val(),
                {/foreach}
                type: $("#type").is(":checked"),
                custom_config: JSON.stringify(editor.get()),
                is_route_dns: $("#is_route_dns").is(":checked"),
            },
            success: function(data) {
                if (data.ret === 1) {
                    $('#success-message').text(data.msg);
                    $('#success-dialog').modal('show');
                    window.setTimeout("location.href=top.document.referrer", {$config['jump_delay']});
                } else {
                    $('#fail-message').text(data.msg);
                    $('#fail-dialog').modal('show');
                }
            }
        })
    });

    document.getElementById("sort").addEventListener("change", function() {
        var selectedValue = this.value;
        var hiddenSection = document.getElementById("routedns");

        if (selectedValue === "3") {
            hiddenSection.style.display = "block";
        } else {
            hiddenSection.style.display = "none";
        }
    });
</script>

{include file='admin/footer.tpl'}