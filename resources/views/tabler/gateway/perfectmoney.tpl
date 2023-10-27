<div class="card-inner">
    <h4>
        شارژ آنلاین پرفکت مانی 
    </h4>
    <p class="card-heading"></p>
    <form class="perfectmoney" name="perfectmoney" action="/user/payment/purchase/perfectmoney" method="post">
        <input hidden id="price" name="price" value="{$invoice->price}">
        <input hidden id="invoice_id" name="invoice_id" value="{$invoice->id}">
        {if $public_setting['perfectmoney']}
        <button class="btn btn-flat waves-attach" id="btnSubmit" type="submit">
            <img src="/images/perfectmoney.png" height="50px" />
        </button>
        {/if}
    </form>
</div>