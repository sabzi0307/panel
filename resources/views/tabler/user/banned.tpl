{include file='user/header.tpl'}

<div class="page-wrapper">
    <div class="container-xl">
        <div class="page-header d-print-none text-white">
            <div class="row align-items-center">
                <div class="col">
                    <h2 class="page-title">
                        <span class="home-title">حساب کاربری مسدود شده است</span>
                    </h2>
                    <div class="page-pretitle my-3">
                        <span class="home-subtitle">عملکرد حساب شما غیرفعال شده است و دسترسی به مرکز کاربر ممنوع است</span>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div class="page-body">
        <div class="container-xl">
            <div class="row row-deck row-cards">
                <div class="col-sm-12 col-lg-12">
                    <div class="card">
                        <div class="empty">
                            <div class="empty-img">
                                <i class="ti ti-circle-x icon mb-2 text-danger icon-lg" style="font-size:3.5rem;"></i>
                            </div>
                            {if $banned_reason === 'DetectBan'}
                            <p class="empty-title">ممنوعیت فیلترینگ</p>
                            <p class="empty-subtitle text-secondary">حساب شما به‌طور خودکار توسط سیستم مسدود می‌شود، زیرا شامل قوانین فیلترینگ شده اید.</p>
                            {else}
                            <p class="empty-title">این دلیل ممنوعیت شماست</p>
                            <p class="empty-subtitle text-secondary">{$banned_reason}</p>
                            {/if}
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
{include file='user/footer.tpl'}