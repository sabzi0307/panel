<script src="https://cdn.jsdelivr.net/npm/jalaali-js/dist/jalaali.min.js"></script>
<div class="offcanvas offcanvas-end" tabindex="-1" id="offcanvasEndSharedAccount" aria-labelledby="offcanvasEndLabel">
    <div class="offcanvas-header">
        <h2 class="offcanvas-title" id="offcanvasEndLabel">>آموزش استفاده از اکانت های اشتراکی</h2>
        <button type="button" class="btn-close text-reset" data-bs-dismiss="offcanvas" aria-label="Close"></button>
    </div>
    <div class="offcanvas-body">
        <div>
            {if $accounts != null}
                {foreach $accounts as $account}
                    {if $account['status'] == 1}
                        <div class="col-lg">
                            <div class="card" style="--tblr-card-border-color: green;">
                                <div class="card-body">
                                    <div class="row row-cards">
                                        <div class="row align-items-center" style="margin: 10px;">
                                            <div class="col-auto">
                                                <i class="ti ti-user-check icon" style="color: green;"></i>
                                            </div>
                                            <div class="col" style="padding-inline-start: unset">
                                                <div class="font-weight-medium">
                                                    نام کاربری
                                                </div>
                                                <div class="text-secondary">
                                                    <strong>{$account['account']}</strong>
                                                </div>
                                            </div>
                                            <div class="col-auto" style="margin-left: 12px;">
                                                <a data-bs-toggle="tooltip" data-bs-placement="right" title="کپی در کلیپ بورد"
                                                    data-clipboard-text="{$account['account']}"
                                                    class="btn btn-primary btn-icon copy">
                                                    <i class="ti ti-copy icon" style="margin: unset;"></i>
                                                </a>
                                            </div>
                                        </div>
                                        <div class="row align-items-center" style="margin: 10px;">
                                            <div class="col-auto">
                                                <i class="ti ti-key icon" style="color: green;"></i>
                                            </div>
                                            <div class="col" style="padding-inline-start: unset;">
                                                <div class="font-weight-medium">
                                                    گذرواژه
                                                </div>
                                                <div class="text-secondary">
                                                    {$account['password']}
                                                </div>
                                            </div>
                                            <div class="col-auto" style="margin-left: 12px;">
                                                <a data-bs-toggle="tooltip" data-bs-placement="right" title="کپی در کلیپ بورد"
                                                    data-clipboard-text="{$account['password']}"
                                                    class="btn btn-primary btn-icon copy">
                                                    <i class="ti ti-copy icon" style="margin: unset;"></i>
                                                </a>
                                            </div>
                                        </div>
                                        <div class="row align-items-center" style="margin: 10px;">
                                            <div class="col-auto">
                                                <i class="ti ti-lock-open icon" style="color: green;"></i>
                                            </div>
                                            <div class="col" style="padding-inline-start: unset;">
                                                <div class="font-weight-medium">
                                                    وضعیت
                                                </div>
                                                <div class="text-secondary">
                                                    {* {$user->money} *}
                                                    نرمال
                                                </div>
                                            </div>
                                            <div class="col-auto">
                                                <i class="ti ti-language icon" style="color: green;"></i>
                                            </div>
                                            <div class="col" style="padding-inline-start: unset;">
                                                <div class="font-weight-medium">
                                                    کشور
                                                </div>
                                                <div class="text-secondary">
                                                    {$account['country']}
                                                </div>
                                            </div>
                                        </div>
                                        <div class="row align-items-center" style="margin: 10px;">
                                            <div class="col-auto">
                                                <i class="ti ti-refresh icon" style="color: green;"></i>
                                            </div>

                                            <div class="col" style="padding-inline-start: unset; margin-left: 8px;">
                                                <div class="font-weight-medium">
                                                    زمان به روز رسانی
                                                </div>
                                                <div class="text-secondary">
                                                    {$account['updated_at']}
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    {else}
                        <div class="col-lg">
                            <div class="card" style="--tblr-card-border-color: darkred;">
                                <div class="card-body">
                                    <div class="row row-cards">
                                        <div class="row align-items-center" style="margin: 10px;">
                                            <div class="col-auto">
                                                <i class="ti ti-user-check icon" style="color: darkred;"></i>
                                            </div>
                                            <div class="col" style="padding-inline-start: unset">
                                                <div class="font-weight-medium">
                                                    نام کاربری
                                                </div>
                                                <div class="text-secondary">
                                                    <strong>{$account['account']}</strong>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="row align-items-center" style="margin: 10px;">
                                            <div class="col-auto">
                                                <i class="ti ti-key icon" style="color: darkred;"></i>
                                            </div>
                                            <div class="col" style="padding-inline-start: unset;">
                                                <div class="font-weight-medium">
                                                    گذرواژه
                                                </div>
                                                <div class="text-secondary">
                                                    {$account['password']}
                                                </div>
                                            </div>
                                        </div>
                                        <div class="row align-items-center" style="margin: 10px;">
                                            <div class="col-auto">
                                                <i class="ti ti-lock icon" style="color: darkred;"></i>
                                            </div>
                                            <div class="col" style="padding-inline-start: unset;">
                                                <div class="font-weight-medium">
                                                    وضعیت
                                                </div>
                                                <div class="text-secondary">
                                                    غیرقابل استفاده
                                                </div>
                                            </div>
                                            <div class="col-auto">
                                                <i class="ti ti-language icon" style="color: darkred;"></i>
                                            </div>
                                            <div class="col" style="padding-inline-start: unset;">
                                                <div class="font-weight-medium">
                                                    کشور
                                                </div>
                                                <div class="text-secondary">
                                                    {$account['country']}
                                                </div>
                                            </div>
                                        </div>
                                        <div class="row align-items-center" style="margin: 10px;">
                                            <div class="col-auto">
                                                <i class="ti ti-refresh icon" style="color: darkred;"></i>
                                            </div>

                                            <div class="col" style="padding-inline-start: unset; margin-left: 8px;">
                                                <div class="font-weight-medium">
                                                    زمان به روز رسانی
                                                </div>
                                                <div class="text-secondary">
                                                    {$account['updated_at']}
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    {/if}
                {/foreach}
            {else}
                <p>در حال حاضر اطلاعاتی داده ای موجود نیست.</p>
            {/if}
        </div>
        <div class="mt-3">
            <button class="btn btn-primary" type="button" data-bs-dismiss="offcanvas">
                بستن آموزش
            </button>
        </div>
    </div>
</div>