<style>
    .offcanvas,
    .offcanvas-lg,
    .offcanvas-md,
    .offcanvas-sm,
    .offcanvas-xl,
    .offcanvas-xxl {
        --tblr-offcanvas-width: 720px;
    }
</style>
<div class="offcanvas offcanvas-end" tabindex="-1" id="offcanvasEnd" aria-labelledby="offcanvasEndLabel">
    <div class="offcanvas-header">
        <h2 class="offcanvas-title" id="offcanvasEndLabel">>آموزش کار با نرم‌افزار ShadowRocket</h2>
        <button type="button" class="btn-close text-reset" data-bs-dismiss="offcanvas" aria-label="Close"></button>
    </div>
    <div class="offcanvas-body">
        {include file='user/knowledge/SharedAccount.tpl' accounts=$SharedAccounts}
        <div class="mt-3">
            <button class="btn btn-primary" type="button" data-bs-dismiss="offcanvas">
                بستن آموزش
            </button>
        </div>
    </div>
</div>