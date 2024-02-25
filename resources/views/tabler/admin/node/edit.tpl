{include file='admin/header.tpl'}

<script src="//{$config['jsdelivr_url']}/npm/jsoneditor@latest/dist/jsoneditor.min.js"></script>
<link href="//{$config['jsdelivr_url']}/npm/jsoneditor@latest/dist/jsoneditor.min.css" rel="stylesheet" type="text/css">

<div class="page-wrapper">
    <div class="container-xl">
        <div class="page-header d-print-none text-white">
            <div class="row align-items-center">
                <div class="col">
                    <h2 class="page-title">
                        <span class="home-title">گره #{$node->id}</span>
                    </h2>
                    <div class="page-pretitle my-3">
                        <span class="home-subtitle">ویرایش اطلاعات گره</span>
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
                            <div class="form-group mb-3 row" id="vless_section" {if $node->sort == 11}style="display: block;" {else}style="display: none;"{/if}>
                                <label class="hr-text">Vless</label>
                                <div class="form-group mb-3 row">
                                    <span class="col">فعال کردن Vless</span>
                                    <span class="col-auto">
                                        <label class="form-check form-check-single form-switch">
                                            <input id="enable_vless" class="form-check-input" type="checkbox" {if $node->enable_vless}checked="" {/if}>
                                        </label>
                                    </span>
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
                                <span class="col-auto">نمایش نود</span>
                                <span class="col-auto">
                                    <label class="form-check form-check-single form-switch">
                                        <input id="type" class="form-check-input" type="checkbox" {if $node->type}checked="" {/if}>
                                    </label>
                                </span>
                            </div>
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
                                <label class="form-label col-3 col-form-label">ترافیک استفاده شده</label>
                                <div class="col">
                                    <input id="node_bandwidth" type="text" class="form-control"
                                        value="{$node->node_bandwidth}" disabled="">
                                </div>
                                <div class="col-auto">
                                    <button id="reset-bandwidth" class="btn btn-red">ریست</button>
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
                                </div>
                            </div>
                            <div class="form-group mb-3 row" id="reality_section" {if $node->enable_vless}style="display: block;" {else}style="display: none;"{/if}>
                                <div class="hr-text">
                                    <span>گزینه های Reality</span>
                                </div>
                                <div class="form-group mb-3 row">
                                    <span class="col">فعال کردن Reality</span>
                                    <span class="col-auto">
                                        <label class="form-check form-check-single form-switch">
                                            <input id="enable_reality" class="form-check-input" type="checkbox" {if $node->is_reality}checked="" {/if}>
                                        </label>
                                    </span>
                                </div>
                            </div>
                            <div class="form-group mb-3 row" id="reality_extra_section" {if $node->is_reality}style="display: block;" {else}style="display: none;"{/if}>

                                <label class="form-label col-3 col-form-label">کلید خصوصی</label>
                                <input type="text" class="form-control" id="private_key" value="{$node->private_key}"
                                    disabled="">
                                <div class="row my-3">
                                    <div class="col">
                                        <button id="reset-key" class="btn btn-red">تولید مجدد</button>
                                        <button id="copy-pvk" class="copy btn btn-primary"
                                            data-clipboard-text="{$node->private_key}">
                                            کپی
                                        </button>
                                    </div>
                                </div>

                                <label class="form-label col-3 col-form-label">کلید عمومی</label>
                                <input type="text" class="form-control" id="public_key" value="{$node->public_key}"
                                    disabled="">
                                <div class="row my-3">
                                    <div class="col">
                                        <button id="copy-pbk" class="copy btn btn-primary"
                                            data-clipboard-text="{$node->public_key}">
                                            کپی
                                        </button>
                                    </div>
                                </div>
                                <textarea type="text" class="form-control" id="short_ids">"{$node->ShortIds}"</textarea>
                                <div class="row my-3">
                                    <div class="col">
                                        <button id="reset_ids" class="btn btn-red">تولید مجدد</button>
                                        <button id="copy-ids" class="copy btn btn-primary"
                                            data-clipboard-text="{$node->ShortIds}">
                                            کپی
                                        </button>
                                    </div>
                                </div>
                                <textarea type="text" class="form-control" id="server_names">"{$node->ServerNames}"</textarea>
                                <div class="row my-3">
                                    <div class="col">
                                        <button id="copy-srv-names" class="copy btn btn-primary"
                                            data-clipboard-text="{$node->ServerNames}">
                                            کپی
                                        </button>
                                    </div>
                                </div>
                            </div>
                            <div class="hr-text">
                                <span>ضریب ترافیک</span>
                            </div>
                            <div class="form-group mb-3 row">
                                <label class="form-label col-3 col-form-label">ضریب ترافیک</label>
                                <div class="col">
                                    <input id="traffic_rate" type="text" class="form-control"
                                        value="{$node->traffic_rate}">
                                </div>
                            </div>
                            <div class="form-group mb-3 row">
                                <span class="col">فعال کردن ضریب ترافیک پویا</span>
                                <span class="col-auto">
                                    <label class="form-check form-check-single form-switch">
                                        <input id="is_dynamic_rate" class="form-check-input" type="checkbox" {if $node->is_dynamic_rate}checked="" {/if}>
                                    </label>
                                </span>
                            </div>
                            <div class="form-group mb-3 row" id="dynamic_rate" style="display: none;">
                                <div class="form-group mb-3 row">
                                    <label class="form-label col-3 col-form-label">شیوه محاسبه</label>
                                    <div class="col">
                                        <select id="dynamic_rate_type" class="col form-select" value="{$node->dynamic_rate_type}">
                                            <option value="0" {if $node->dynamic_rate_type === 0}selected{/if}>Logistic</option>
                                            <option value="1" {if $node->dynamic_rate_type === 1}selected{/if}>Linear</option>
                                        </select>
                                    </div>
                                </div>
                                <div class="form-group mb-3 row">
                                    <label class="form-label col-3 col-form-label">بیشترین ضریب</label>
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
                                    <label class="form-label col-3 col-form-label">کمترین ضریب</label>
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
                            <div class="hr-text">
                                <span>گزینه های پیشرفته</span>
                            </div>
                            <div class="form-group mb-3 row">
                                <label class="form-label col-3 col-form-label">کلید ارتباطی سرور</label>
                                <input type="text" class="form-control" id="password" value="{$node->password}"
                                    disabled="">
                                <div class="row my-3">
                                    <div class="col">
                                        <button id="reset-password" class="btn btn-red">تنظیم مجدد</button>
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
    let clipboard = new ClipboardJS('.copy');
    clipboard.on('success', function(e) {
        $('#success-noreload-message').text('در کلیپ بورد کپی شد');
        $('#success-noreload-dialog').modal('show');
    });

    const container = document.getElementById('custom_config');
    let options = {
        modes: ['code', 'tree'],
    };
    const editor = new JSONEditor(container, options);
    editor.set({$node->custom_config})

    $("#reset-bandwidth").click(function () {
        $.ajax({
            url: '/admin/node/{$node->id}/reset_bandwidth',
            type: 'POST',
            dataType: "json",
            success: function (data) {
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

    $("#reset-password").click(function () {
        $.ajax({
            url: '/admin/node/{$node->id}/reset_password',
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

    $("#reset-key").click(function () {
        $.ajax({
            url: '/admin/node/{$node->id}/reset_key',
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
                enable_reality: $("#enable_reality").is(":checked"),
                enable_vless: $("#enable_vless").is(":checked"),
                short_ids: $("#short_ids").text(),
                server_names: $("#server_names").val(),
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
        
        var vlessSection = document.getElementById("vless_section");
        var realitySection = document.getElementById("reality_section");
        var routednsSection = document.getElementById("routedns");

        switch(selectedValue) {
            case "11":
                routednsSection.style.display = "none";
                vlessSection.style.display = "block";
                var routednsSection = document.getElementById("enable_vless").value;
                if (selectedValue == "true") {
                    realitySection.style.display = "block";
                } else {
                    realitySection.style.display = "none";
                }
                break;
            case "3":
                routednsSection.style.display = "block";
                vlessSection.style.display = "none";
                realitySection.style.display = "none";
                break;
            default:
                vlessSection.style.display = "none";
                routednsSection.style.display = "none";
                realitySection.style.display = "none";
        }
    });


    document.getElementById("enable_vless").addEventListener("change", function() {
        var selectedValue = this.value;

        var realitySection = document.getElementById("reality_section");
        if (this.checked) {
            realitySection.style.display = "block";
        } else {
            realitySection.style.display = "none";
        }

    });

    document.getElementById("is_dynamic_rate").addEventListener("change", function() {
        var selectedValue = this.value;

        var realitySection = document.getElementById("dynamic_rate");
        if (this.checked) {
            realitySection.style.display = "block";
        } else {
            realitySection.style.display = "none";
        }

    });

    document.getElementById("enable_reality").addEventListener("change", function() {
        var selectedValue = this.value;

        var realitySection = document.getElementById("reality_extra_section");
        if (this.checked) {
            $.ajax({
                url: '/admin/node/{$node->id}/reality',
                type: 'POST',
                dataType: "json",
                success: function(data) {
                    if (data.ret === 1) {
                        realitySection.style.display = "block";
                        $('#success-message').text(data.msg);
                        $('#success-dialog').modal('show');
                    } else {
                        $('#fail-message').text(data.msg);
                        $('#fail-dialog').modal('show');
                    }
                }
            })
        } else {
            $.ajax({
                url: '/admin/node/{$node->id}/reality',
                type: 'DELETE',
                dataType: "json",
                success: function(data) {
                    if (data.ret === 1) {
                        realitySection.style.display = "none";
                        $('#success-message').text(data.msg);
                        $('#success-dialog').modal('show');
                    } else {
                        $('#fail-message').text(data.msg);
                        $('#fail-dialog').modal('show');
                    }
                }
            })
            
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