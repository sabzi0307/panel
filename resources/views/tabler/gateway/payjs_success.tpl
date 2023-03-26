<main class="content">
    <div class="content-header ui-content-header">
        <div class="container">
            <h1 class="content-heading">نتیجه شارژ</h1>
        </div>
    </div>
    <div class="container">
        <section class="content-inner margin-top-no">
            <div class="col-lg-12 col-md-12">
                <div class="card margin-bottom-no">
                    <div class="card-main">
                        <div class="card-inner">
                            {if ($success == 1)}
                                <p>با موفقیت شارژ شد {$money} تومان! لطفا وارد کنید <a href="/user/shop">خرید بسته</a> صفحه ای برای خرید بسته خود.</p>
                            {else}
                                <p>پرداخت شما در حال پردازش است، لطفاً یک لحظه صبر کنید. این صفحه به طور خودکار بازخوانی می شود، یا می توانید انتخاب کنید که این صفحه ببندید و موجودی به طور خودکار واریز می شود</p>
                                <script>
                                    setTimeout('window.location.reload()', 5000);
                                </script>
                            {/if}
                        </div>
                    </div>
                </div>
            </div>
        </section>
    </div>
</main>