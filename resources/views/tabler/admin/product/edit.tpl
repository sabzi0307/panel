{include file='admin/header.tpl'}

<div class="page-wrapper">
    <div class="container-xl">
        <div class="page-header d-print-none text-white">
            <div class="row align-items-center">
                <div class="col">
                    <h2 class="page-title">
                        <span class="home-title">سرویس #{$product->id}</span>
                    </h2>
                    <div class="page-pretitle my-3">
                        <span class="home-subtitle">اطلاعات سرویس را ویرایش کنید</span>
                    </div>
                </div>
                <div class="col-auto ms-auto d-print-none">
                    <div class="btn-list">
                        <a id="save-product" href="#" class="btn btn-primary">
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
                            <h3 class="card-title">اطلاعات پایه</h3>
                        </div>
                        <div class="card-body">
                            <div class="form-group mb-3 row">
                                <label class="form-label col-3 col-form-label required">نام</label>
                                <div class="col">
                                    <input id="name" type="text" class="form-control"
                                        value="{$product->name}">
                                </div>
                            </div>
                            <div class="form-group mb-3 row">
                                <label class="form-label col-3 col-form-label required">قیمت</label>
                                <div class="col">
                                    <input id="price" type="text" class="form-control"
                                        value="{$product->price}">
                                </div>
                            </div>
                            <div class="form-group mb-3 row">
                                <label class="form-label col-3 col-form-label required">موجودی (نامحدود زمانی که کمتر از 0 باشد)</label>
                                <div class="col">
                                    <input id="stock" type="text" class="form-control"
                                        value="{$product->stock}">
                                </div>
                            </div>
                            <div class="form-group mb-3 row">
                                <label class="form-label col-3 col-form-label">وضعیت فروش</label>
                                <div class="col">
                                    <select id="status" class="col form-select">
                                        <option value="1" {if $product->status === 1}selected{/if}>فعال</option>
                                        <option value="0" {if $product->status === 0}selected{/if}>غیرفعال</option>
                                    </select>
                                </div>
                            </div>
                            <div class="form-group mb-3 row">
                                <label class="form-label col-3 col-form-label">نوع</label>
                                <div class="col">
                                    <select id="type" class="col form-select">
                                        <option value="tabp" {if $product->type === "tabp"}selected{/if}>ترافیک زمان دار</option>
                                        <option value="time" {if $product->type === "time"}selected{/if}>بسته زمانی</option>
                                        <option value="bandwidth" {if $product->type === "bandwidth"}selected{/if}>ترافیک</option>
                                    </select>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-md-6 col-sm-12">
                    <div class="card">
                        <div class="card-header card-header-light">
                            <h3 class="card-title">عنوان سرویس</h3>
                        </div>
                        <div class="card-body">
                            <div id="time_option" class="form-group mb-3 row">
                                <label class="form-label col-3 col-form-label required">مدت زمان سرویس (روز)</label>
                                <div class="col">
                                    <input id="time" type="text" class="form-control"
                                        value="{$content->time}">
                                </div>
                            </div>
                            <div id="class_option" class="form-group mb-3 row">
                                <label class="form-label col-3 col-form-label required">سطح</label>
                                <div class="col">
                                    <input id="class" type="text" class="form-control"
                                        value="{$content->class}">
                                </div>
                            </div>
                            <div id="class_time_option" class="form-group mb-3 row">
                                <label class="form-label col-3 col-form-label required">مدت زمان سطح (روز)</label>
                                <div class="col">
                                    <input id="class_time" type="text" class="form-control"
                                        value="{$content->class_time}">
                                </div>
                            </div>
                            <div id="bandwidth_option" class="form-group mb-3 row">
                                <label class="form-label col-3 col-form-label required">ترافیک موجود (GB)</label>
                                <div class="col">
                                    <input id="bandwidth" type="text" class="form-control"
                                        value="{$content->bandwidth}">
                                </div>
                            </div>
                            <div id="node_group_option" class="form-group mb-3 row">
                                <label class="form-label col-3 col-form-label required">گروه کاربران</label>
                                <div class="col">
                                    <input id="node_group" type="text" class="form-control"
                                        value="{$content->node_group}">
                                </div>
                            </div>
                            <div id="speed_limit_option" class="form-group mb-3 row">
                                <label class="form-label col-3 col-form-label required">محدودیت سرعت (Mbps)</label>
                                <div class="col">
                                    <input id="speed_limit" type="text" class="form-control"
                                        value="{$content->speed_limit}">
                                </div>
                            </div>
                            <div id="ip_limit_option" class="form-group mb-3 row">
                                <label class="form-label col-3 col-form-label required">محدودیت اتصال همزمان IP</label>
                                <div class="col">
                                    <input id="ip_limit" type="text" class="form-control"
                                        value="{$content->ip_limit}">
                                </div>
                            </div>
                            <div class="hr-text">
                                <span>محدودیت خرید</span>
                            </div>
                            <div class="form-group mb-3 row">
                                <label class="form-label col-3 col-form-label">نیازهای سطح کاربر</label>
                                <div class="col">
                                    <input id="class_required" type="text" class="form-control"
                                        value="{$limit->class_required}">
                                </div>
                            </div>
                            <div class="form-group mb-3 row">
                                <label class="form-label col-3 col-form-label">گروه سروری که کاربر در آن قرار دارد</label>
                                <div class="col">
                                    <input id="node_group_required" type="text" class="form-control"
                                        value="{$limit->node_group_required}">
                                </div>
                            </div>
                            <div class="mb-3">
                                <label class="row">
                                    <span class="col">فقط کاربران جدید</span>
                                    <span class="col-auto">
                                        <label class="form-check form-check-single form-switch">
                                            <input id="new_user_requried" class="form-check-input" type="checkbox"
                                                {if $limit->new_user_required === 1}checked="" {/if}>
                                        </label>
                                    </span>
                                </label>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
    $(function () {
        $("#type").change();
    });

    $("#type").on("change", function() {
        if (this.value === "bandwidth")
        {
            $("#time_option").hide();
            $("#class_option").hide();
            $("#class_time_option").hide();
            $("#bandwidth_option").show();
            $("#node_group_option").hide();
            $("#speed_limit_option").hide();
            $("#ip_limit_option").hide();
            $("#time").prop("required",false);
            $("#class").prop("required",false);
            $("#class_time").prop("required",false);
            $("#bandwidth").prop("required",true);
            $("#node_group").prop("required",false);
            $("#speed_limit").prop("required",false);
            $("#ip_limit").prop("required",false);
        }
        else if (this.value === "time")
        {
            $("#time_option").show();
            $("#class_option").show();
            $("#class_time_option").show();
            $("#bandwidth_option").hide();
            $("#node_group_option").show();
            $("#speed_limit_option").show();
            $("#ip_limit_option").show();
            $("#time").prop("required",true);
            $("#class").prop("required",true);
            $("#class_time").prop("required",true);
            $("#bandwidth").prop("required",false);
            $("#node_group").prop("required",true);
            $("#speed_limit").prop("required",true);
            $("#ip_limit").prop("required",true);
        }
        else
        {
            $("#time_option").show();
            $("#class_option").show();
            $("#class_time_option").show();
            $("#bandwidth_option").show();
            $("#node_group_option").show();
            $("#speed_limit_option").show();
            $("#ip_limit_option").show();
            $("#time").prop("required",true);
            $("#class").prop("required",true);
            $("#class_time").prop("required",true);
            $("#bandwidth").prop("required",true);
            $("#node_group").prop("required",true);
            $("#speed_limit").prop("required",true);
            $("#ip_limit").prop("required",true);
        }
    });

    $("#save-product").click(function() {
        var emptyFields = $('input[required]').filter(function() {
            return $(this).val() === '';
        });

        if (emptyFields.length > 0) {
            $("#fail-message").text("لطفا همه قسمت های لازم را تکمیل کنید");
            $("#fail-dialog").modal("show");
        } else {
            $.ajax({
                url: '/admin/product/{$product->id}',
                type: 'PUT',
                dataType: "json",
                data: {
                    {foreach $update_field as $key}
                    {$key}: $('#{$key}').val(),
                    {/foreach}
                    new_user_required: $("#new_user_required").is(":checked"),
                },
                success: function (data) {
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
        }
    });
</script>

{include file='admin/footer.tpl'}
