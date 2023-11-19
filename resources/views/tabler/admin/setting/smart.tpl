{include file='admin/header.tpl'}

<div class="page-wrapper">
    <div class="container-xl">
        <div class="page-header d-print-none text-white">
            <div class="row align-items-center">
                <div class="col">
                    <h2 class="page-title">
                        <span class="home-title">تنظیمات ویژگی ها</span>
                    </h2>
                    <div class="page-pretitle my-3">
                        <span class="home-subtitle">ویژگی ها و نمایش سایت را تنظیم کنید</span>
                    </div>
                </div>
                <div class="col-auto ms-auto d-print-none">
                    <div class="btn-list">
                        <a id="save-setting" href="#" class="btn btn-primary">
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
                <div class="col-md-12">
                    <div class="card">
                        <div class="card-header">
                            <a>اسمارت دی ان اس</a>
                        </div>
                        <div class="card-body">
                            <div class="form-group mb-3 row">
                                <label class="form-label col-3 col-form-label">فعال بودن اسمارت دی ان اس</label>
                                <div class="col">
                                    <select id="smart_dns" class="col form-select" value="{$settings['smart_dns']}">
                                        <option value="0" {if ! $settings['smart_dns']}selected{/if}>
                                            غیرفعال</option>
                                        <option value="1" {if $settings['smart_dns']}selected{/if}>فعال
                                        </option>
                                    </select>
                                </div>
                            </div>
                            <div class="form-group mb-3 row">
                                <label class="form-label col-3 col-form-label">آدرس تست موفق</label>
                                <div class="col">
                                    <input id="smart_dns_check_url" type="text" class="form-control"
                                        value="{$settings['smart_dns_check_url']}">
                                </div>
                            </div>
                            <div class="form-group mb-3 row">
                                <label class="form-label col-3 col-form-label">آدرس تست خطا</label>
                                <div class="col">
                                    <input id="smart_dns_fail_url" type="text" class="form-control"
                                        value="{$settings['smart_dns_fail_url']}">
                                </div>
                            </div>
                            <div class="form-group mb-3 row">
                                <label class="form-label col-3 col-form-label">Plain DNS</label>
                                <div class="col">
                                    <select id="smart_dns_plain" class="col form-select" value="{$settings['smart_dns_plain']}">
                                        <option value="0" {if ! $settings['smart_dns_plain']}selected{/if}>
                                            غیرفعال</option>
                                        <option value="1" {if $settings['smart_dns_plain']}selected{/if}>فعال
                                        </option>
                                    </select>
                                </div>
                            </div>
                            <div class="form-group mb-3 row">
                                <label class="form-label col-3 col-form-label">آدرس Plain DNS 1</label>
                                <div class="col">
                                    <input id="smart_dns_plain_url_1" type="text" class="form-control"
                                        value="{$settings['smart_dns_plain_url_1']}">
                                </div>
                            </div>
                            <div class="form-group mb-3 row">
                                <label class="form-label col-3 col-form-label">آدرس Plain DNS 2</label>
                                <div class="col">
                                    <input id="smart_dns_plain_url_2" type="text" class="form-control"
                                        value="{$settings['smart_dns_plain_url_2']}">
                                </div>
                            </div>
                            <div class="form-group mb-3 row">
                                <label class="form-label col-3 col-form-label">DNS-over-TLS</label>
                                <div class="col">
                                    <select id="smart_dns_dot" class="col form-select" value="{$settings['smart_dns_dot']}">
                                        <option value="0" {if ! $settings['smart_dns_dot']}selected{/if}>
                                            غیرفعال</option>
                                        <option value="1" {if $settings['smart_dns_dot']}selected{/if}>فعال
                                        </option>
                                    </select>
                                </div>
                            </div>
                            <div class="form-group mb-3 row">
                                <label class="form-label col-3 col-form-label">آدرس DNS-over-TLS</label>
                                <div class="col">
                                    <input id="smart_dns_dot_url" type="text" class="form-control"
                                        value="{$settings['smart_dns_dot_url']}">
                                </div>
                            </div>
                            <div class="form-group mb-3 row">
                                <label class="form-label col-3 col-form-label">DNS-over-HTTPS</label>
                                <div class="col">
                                    <select id="smart_dns_doh" class="col form-select" value="{$settings['smart_dns_doh']}">
                                        <option value="0" {if ! $settings['smart_dns_doh']}selected{/if}>
                                            غیرفعال</option>
                                        <option value="1" {if $settings['smart_dns_doh']}selected{/if}>فعال
                                        </option>
                                    </select>
                                </div>
                            </div>
                            <div class="form-group mb-3 row">
                                <label class="form-label col-3 col-form-label">آدرس DNS-over-HTTPS</label>
                                <div class="col">
                                    <input id="smart_dns_doh_url" type="text" class="form-control"
                                        value="{$settings['smart_dns_doh_url']}">
                                </div>
                            </div>
                            <div class="form-group mb-3 row">
                                <label class="form-label col-3 col-form-label">DNS-over-DTLS</label>
                                <div class="col">
                                    <select id="smart_dns_dodtls" class="col form-select" value="{$settings['smart_dns_dodtls']}">
                                        <option value="0" {if ! $settings['smart_dns_dodtls']}selected{/if}>
                                            غیرفعال</option>
                                        <option value="1" {if $settings['smart_dns_dodtls']}selected{/if}>فعال
                                        </option>
                                    </select>
                                </div>
                            </div>
                            <div class="form-group mb-3 row">
                                <label class="form-label col-3 col-form-label">آدرس DNS-over-DTLS</label>
                                <div class="col">
                                    <input id="smart_dns_dodtls_url" type="text" class="form-control"
                                        value="{$settings['smart_dns_dodtls_url']}">
                                </div>
                            </div>
                            <div class="form-group mb-3 row">
                                <label class="form-label col-3 col-form-label">DNS-over-QUIC</label>
                                <div class="col">
                                    <select id="smart_dns_doq" class="col form-select" value="{$settings['smart_dns_doq']}">
                                        <option value="0" {if ! $settings['smart_dns_doq']}selected{/if}>
                                            غیرفعال</option>
                                        <option value="1" {if $settings['smart_dns_doq']}selected{/if}>فعال
                                        </option>
                                    </select>
                                </div>
                            </div>
                            <div class="form-group mb-3 row">
                                <label class="form-label col-3 col-form-label">آدرس DNS-over-QUIC</label>
                                <div class="col">
                                    <input id="smart_dns_doq_url" type="text" class="form-control"
                                        value="{$settings['smart_dns_doq_url']}">
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <script>
            $("#save-setting").click(function() {
                $.ajax({
                    url: '/admin/setting/smart',
                    type: 'POST',
                    dataType: "json",
                    data: {
                        {foreach $update_field as $key}
                            {$key}: $('#{$key}').val(),
                        {/foreach}
                    },
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

{include file='admin/footer.tpl'}