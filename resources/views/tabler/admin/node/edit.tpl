{include file='admin/header.tpl'}

<script src="//{$config['jsdelivr_url']}/npm/jsoneditor@latest/dist/jsoneditor.min.js"></script>
<link href="//{$config['jsdelivr_url']}/npm/jsoneditor@latest/dist/jsoneditor.min.css" rel="stylesheet" type="text/css">

<div class="page-wrapper">
    <div class="container-xl">
        <div class="page-header d-print-none text-white">
            <div class="row align-items-center">
                <div class="col">
                    <h2 class="page-title">
                        <span class="home-title">سرور #{$node->id}</span>
                    </h2>
                    <div class="page-pretitle my-3">
                        <span class="home-subtitle">ویرایش اطلاعات سرور</span>
                    </div>
                </div>
                <div class="col-auto ms-auto d-print-none">
                    <div class="btn-list">
                        <a id="save-node" href="#" class="btn btn-primary">
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
                                <label class="form-label col-3 col-form-label">نام</label>
                                <div class="col">
                                    <input id="name" type="text" class="form-control" value="{$node->name}">
                                </div>
                            </div>
                            <div class="form-group mb-3 row">
                                <label class="form-label col-3 col-form-label">آدرس اتصال</label>
                                <div class="col">
                                    <input id="server" type="text" class="form-control" value="{$node->server}">
                                </div>
                            </div>
                            <div class="form-group mb-3 row">
                                <label class="form-label col-3 col-form-label">آی پی سرور</label>
                                <div class="col">
                                    <input id="node_ip" type="text" class="form-control" value="{$node->node_ip}" disabled>
                                </div>
                            </div>
                            <div class="form-group mb-3 row">
                                <label class="form-label col-3 col-form-label">سرعت جریان</label>
                                <div class="col">
                                    <input id="traffic_rate" type="text" class="form-control"
                                        value="{$node->traffic_rate}">
                                </div>
                            </div>
                            <div class="form-group mb-3 row">
                                <label class="form-label col-3 col-form-label">نوع دسترسی</label>
                                <div class="col">
                                    <select id="sort" class="col form-select" value="{$node->sort}">
                                        <option value="14" {if $node->sort === 14}selected{/if}>Trojan</option>
                                        <option value="11" {if $node->sort === 11}selected{/if}>V2Ray</option>
                                        <option value="3" {if $node->sort === 3}selected{/if}>Http</option>
                                        <option value="2" {if $node->sort === 2}selected{/if}>TUIC</option>
                                        <option value="1" {if $node->sort === 1}selected{/if}>Shadowsocks2022</option>
                                        <option value="0" {if $node->sort === 0}selected{/if}>Shadowsocks</option>
                                    </select>
                                </div>
                            </div>
                            <div class="form-group mb-3 row">
                                <label class="form-label col-3 col-form-label">پیکربندی سفارشی</label>
                                <div id="custom_config"></div>
                                <label class="form-label col-form-label">
                                    مراجعه فرمایید
                                    <a href="//wiki.sspanel.org/#/custom-config"
                                        target="_blank">
                                        wiki.sspanel.org/#/custom-config
                                    </a>
                                    پیکربندی سفارشی سرور را تغییر دهید
                                </label>
                            </div>
                            <div class="form-group mb-3 row">
                                <span class="col">نمایش نود</span>
                                <span class="col-auto">
                                    <label class="form-check form-check-single form-switch">
                                        <input id="type" class="form-check-input" type="checkbox" {if $node->type}checked="" {/if}>
                                    </label>
                                </span>
                            </div>
                            <div class="hr-text">
                                <span>dynamic ratio</span>
                            </div>
                            <div class="form-group mb-3 row">
                                <span class="col">فعال کردن ضریب ترافیک پویا</span>
                                <span class="col-auto">
                                    <label class="form-check form-check-single form-switch">
                                        <input id="is_dynamic_rate" class="form-check-input" type="checkbox" {if $node->is_dynamic_rate}checked="" {/if}>
                                    </label>
                                </span>
                            </div>
                            <div class="form-group mb-3 row">
                                <label class="form-label col-3 col-form-label">Maximum ratio</label>
                                <div class="col">
                                    <input id="max_rate" type="text" class="form-control" value="{$node->max_rate}">
                                </div>
                            </div>
                            <div class="form-group mb-3 row">
                                <label class="form-label col-3 col-form-label">Maximum override time (hours)</label>
                                <div class="col">
                                    <input id="max_rate_time" type="text" class="form-control"
                                        value="{$node->max_rate_time}">
                                </div>
                            </div>
                            <div class="form-group mb-3 row">
                                <label class="form-label col-3 col-form-label">Minimum ratio</label>
                                <div class="col">
                                    <input id="min_rate" type="text" class="form-control" value="{$node->min_rate}">
                                </div>
                            </div>
                            <div class="form-group mb-3 row">
                                <label class="form-label col-3 col-form-label">Minimum override time (hours)</label>
                                <div class="col">
                                    <input id="min_rate_time" type="text" class="form-control"
                                        value="{$node->min_rate_time}">
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
                            <h3 class="card-title">اطلاعات دیگر</h3>
                        </div>
                        <div class="card-body">
                            <div class="form-group mb-3 row">
                                <label class="form-label col-3 col-form-label">سطح</label>
                                <div class="col">
                                    <input id="node_class" type="text" class="form-control" value="{$node->node_class}">
                                </div>
                            </div>
                            <div class="form-group mb-3 row">
                                <label class="form-label col-3 col-form-label">گروه</label>
                                <div class="col">
                                    <input id="node_group" type="text" class="form-control" value="{$node->node_group}">
                                </div>
                            </div>
                            <div class="hr-text">
                                <span>تنظیمات ترافیک</span>
                            </div>
                            <div class="form-group mb-3 row">
                                <label class="form-label col-3 col-form-label">ترافیک استفاده شده (GB)</label>
                                <div class="col">
                                    <input id="node_bandwidth" type="text" class="form-control"
                                        value="{$node->node_bandwidth}" disabled="">
                                </div>
                            </div>
                            <div class="form-group mb-3 row">
                                <label class="form-label col-3 col-form-label">ترافیک موجود (GB)</label>
                                <div class="col">
                                    <input id="node_bandwidth_limit" type="text" class="form-control"
                                        value="{$node->node_bandwidth_limit}">
                                </div>
                            </div>
                            <div class="form-group mb-3 row">
                                <label class="form-label col-3 col-form-label">تاریخ تنظیم مجدد ترافیک</label>
                                <div class="col">
                                    <input id="bandwidthlimit_resetday" type="text" class="form-control"
                                        value="{$node->bandwidthlimit_resetday}">
                                </div>
                            </div>
                            <div class="form-group mb-3 row">
                                <label class="form-label col-3 col-form-label">محدودیت نرخ داده (Mbps)</label>
                                <div class="col">
                                    <input id="node_speedlimit" type="text" class="form-control"
                                        value="{$node->node_speedlimit}">
                                </div>
                            </div>
                            <div class="form-group mb-3 row" id="routedns" {if $node->is_route_dns}style="display: block;" {else}style="display: none;"{/if}>
                                <label class="hr-text">Route Dns</label>
                                <div class="form-group mb-3 row">
                                    <span class="col">فعال کردن RouteDns</span>
                                    <span class="col-auto">
                                        <label class="form-check form-check-single form-switch">
                                            <input id="is_route_dns" class="form-check-input" type="checkbox" {if $node->is_route_dns}checked="" {/if}>
                                        </label>
                                    </span>
                                </div>
                                <div id="routedns_container" {if $node->is_route_dns}style="display: block;" {else}style="display: none;"{/if}>
                                    <span class="col">پیکربندی</span>

                                    <label class="form-label col-form-label">
                                        جهت افزودن پیکربندی سفارشی به
                                        <a href="//wiki.sspanel.org/#/custom-config"
                                            target="_blank">wiki.sspanel.org/#/custom-config</a>
                                        مراجعه فرمایید
                                    </label>
                                    <div id="routedns_config" style="min-height: 200px;"></div>
                                </div>
                            </div>
                            <div class="hr-text">
                                <span>گزینه های پیشرفته</span>
                            </div>
                            <div class="form-group mb-3 row">
                                <label class="form-label col-3 col-form-label">کلید ارتباطی سرور</label>
                                <input type="text" class="form-control" id="password" value="{$node->password}"
                                    disabled="">
                                <div class="row my-3">
                                    <div class="col">
                                        <button id="reset-node-password" class="btn btn-red">تنظیم مجدد</button>
                                        <button id="copy-password" class="copy btn btn-primary"
                                            data-clipboard-text="{$node->password}">
                                            کپی
                                        </button>
                                    </div>
                                </div>
                                <label class="form-label col-form-label">
                                    کلید ارتباطی برای احراز هویت gRPC API استفاده می شود، در صورت نیاز به تغییر آن،
                                    لطفاً روی Reset کلیک کنید.
                                </label>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script src="https://cdnjs.cloudflare.com/ajax/libs/ace/1.31.0/ace.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/ace/1.31.0/mode-toml.min.js"></script>
<script>
    var clipboard = new ClipboardJS('.copy');
    clipboard.on('success', function(e) {
        $('#success-noreload-message').text('در کلیپ بورد کپی شد');
        $('#success-noreload-dialog').modal('show');
    });

    const container = document.getElementById('custom_config');
    var options = {
        modes: ['code', 'tree'],
    };
    const editor = new JSONEditor(container, options);
    editor.set({$node->custom_config})

    var dnseditor = ace.edit("routedns_config");
    dnseditor.setFontSize("11pt");
    dnseditor.setValue(`{$node->routedns_config}`)
    dnseditor.getSession().setMode("ace/mode/toml");

    $("#reset-node-password").click(function() {
        $.ajax({
            url: '/admin/node/{$node->id}/reset',
            type: 'POST',
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

    $("#save-node").click(function() {
        $.ajax({
            url: '/admin/node/{$node->id}',
            type: 'PUT',
            dataType: "json",
            data: {
                {foreach $update_field as $key}
                    {$key}: $('#{$key}').val(),
                {/foreach}
                type: $("#type").is(":checked"),
                is_dynamic_rate: $("#is_dynamic_rate").is(":checked"),
                custom_config: JSON.stringify(editor.get()),
                is_route_dns: $("#is_route_dns").is(":checked"),
                routedns_config: dnseditor.getValue(),
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

    document.getElementById("is_route_dns").addEventListener("change", function() {
        var routedns = document.getElementById("routedns_container");
        if (this.checked) {
            routedns.style.display = "block";
        } else {
            routedns.style.display = "none";
        }
    });

</script>

{include file='admin/footer.tpl'}