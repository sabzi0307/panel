{include file='user/tabler_header.tpl'}

<div class="page-wrapper">
    <div class="container-xl">
        <div class="page-header d-print-none text-white">
            <div class="row align-items-center">
                <div class="col">
                    <h2 class="page-title">
                        <span class="home-title">لیست سرویس ها</span>
                    </h2>
                    <div class="page-pretitle my-3">
                        <span class="home-subtitle">سرویس ها را در اینجا مشاهده کنید و در صورت تمایل سفارش دهید</span>
                    </div>
                </div>
                <div class="col-auto ms-auto d-print-none">
                    <div class="btn-list">
                        <a href="#" class="btn btn-primary d-none d-sm-inline-block" data-bs-toggle="modal"
                            data-bs-target="#account-recharge">
                            <svg xmlns="http://www.w3.org/2000/svg" class="icon icon-tabler icon-tabler-coin" width="24"
                                height="24" viewBox="0 0 24 24" stroke-width="2" stroke="currentColor" fill="none"
                                stroke-linecap="round" stroke-linejoin="round">
                                <path stroke="none" d="M0 0h24v24H0z" fill="none"></path>
                                <circle cx="12" cy="12" r="9"></circle>
                                <path
                                    d="M14.8 9a2 2 0 0 0 -1.8 -1h-2a2 2 0 0 0 0 4h2a2 2 0 0 1 0 4h-2a2 2 0 0 1 -1.8 -1">
                                </path>
                                <path d="M12 6v2m0 8v2"></path>
                            </svg>
                            موجودی شارژ مجدد
                        </a>
                        <a href="#" class="btn btn-primary d-sm-none btn-icon" data-bs-toggle="modal"
                            data-bs-target="#account-recharge">
                            <svg xmlns="http://www.w3.org/2000/svg" class="icon icon-tabler icon-tabler-coin" width="24"
                                height="24" viewBox="0 0 24 24" stroke-width="2" stroke="currentColor" fill="none"
                                stroke-linecap="round" stroke-linejoin="round">
                                <path stroke="none" d="M0 0h24v24H0z" fill="none"></path>
                                <circle cx="12" cy="12" r="9"></circle>
                                <path
                                    d="M14.8 9a2 2 0 0 0 -1.8 -1h-2a2 2 0 0 0 0 4h2a2 2 0 0 1 0 4h-2a2 2 0 0 1 -1.8 -1">
                                </path>
                                <path d="M12 6v2m0 8v2"></path>
                            </svg>
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div class="page-body">
        <div class="container-xl">
            <div class="row row-deck row-cards">
                <div class="col-12">
                    <div class="card">
                        <div class="card-body">
                            <div class="m-0 my-2">
                                <div>
                                    <p>موجودی حساب：<code>{$user->money}</code> تومان，ترافیک باقی مانده：<code>{$user->unusedTraffic()}</code>
                                        {if time() > strtotime($user->expire_in)}
                                            ，حساب شما منقضی شده است
                                        {else}
                                            {$diff = round((strtotime($user->expire_in) - time()) / 86400)}
                                            ，میزان <code>{$diff}</code> روزهای سررسید
                                        {/if}
                                    </p>
                                    {if $config['user_product_page_custom'] == true}
                                        {$config['user_product_page_custom_text']}
                                    {/if}
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div class="page-body">
        <div class="container-xl">
            <div class="row row-cards">
                <div class="col-12">
                    <div class="card">
                        <ul class="nav nav-tabs nav-fill" data-bs-toggle="tabs">
                            {foreach $product_tab_lists as $product_tab}
                                <li class="nav-item">
                                    <a href="#product-{$product_tab['type']}"
                                        class="nav-link {if $product_tab['type'] == 'tatp'}active{/if}"
                                        data-bs-toggle="tab">
                                        <i class="ti ti-{$product_tab['icon']}"></i>&nbsp;{$product_tab['name']}
                                    </a>
                                </li>
                            {/foreach}
                        </ul>
                        <div class="card-body">
                            <div class="tab-content">
                                {foreach $product_lists as $key => $value}
                                    <div class="tab-pane show {if $key == 'tatp'}active{/if}" id="product-{$key}">
                                        <div class="row">
                                            {if $count[$key] != '0'}
                                                {foreach $products as $product}
                                                    {if $product->type == $key}

                                                        <div class="col-md-3 col-sm-12 my-3">
                                                            <div class="card card-md">
                                                                <div class="card-body text-center">
                                                                    <div id="product-{$product->id}-name"
                                                                        class="text-uppercase text-muted font-weight-medium">
                                                                        {$product->name}</div>
                                                                    <div id="product-{$product->id}-price"
                                                                        class="display-6 fw-bold my-3">{$product->price / 100}
                                                                    </div>
                                                                    <ul class="list-unstyled lh-lg">
                                                                        {$product->html}
                                                                    </ul>
                                                                    <div class="row g-2">
                                                                        {if $product->stock - $product->sales > '0'}
                                                                            <div class="col">
                                                                                <button onclick="buy('{$product->id}')" href="#"
                                                                                    class="btn btn-primary w-100">بخرید</button>
                                                                            </div>
                                                                        {else}
                                                                            <div class="col">
                                                                                <button href="#" class="btn btn-primary w-100"
                                                                                    disabled>فروخته شده</button>
                                                                            </div>
                                                                        {/if}
                                                                        <div class="col-auto align-self-center">
                                                                            <span class="pop form-help" data-bs-toggle="popover"
                                                                                data-bs-placement="top"
                                                                                data-bs-content="{$product->translate}"
                                                                                data-bs-html="true">?</span>
                                                                        </div>
                                                                    </div>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    {/if}
                                                {/foreach}
                                            {else}
                                                <div class="card-body">
                                                    <p>در این دسته بندی هیچ سرویسی وجود ندارد</p>
                                                </div>
                                            {/if}
                                        </div>
                                    </div>
                                {/foreach}
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="modal modal-blur fade" id="product-buy-dialog" tabindex="-1" role="dialog" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered modal-dialog-scrollable" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">تایید سفارش</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <div class="mb-3">
                        <span>نام سرویس：</span>
                        <span id="product-buy-name" style="float: right"></span>
                    </div>
                    <div class="mb-3">
                        <span>قیمت：</span>
                        <span id="product-buy-price" style="float: right"></span>
                    </div>
                    <div class="mb-3">
                        <span>تخفیف：</span>
                        <span id="product-buy-discount" style="float: right">0.00</span>
                    </div>
                    <hr />
                    <div class="mb-3">
                        <span>مجموع：</span>
                        <span id="product-buy-total" style="float: right">0</span>
                    </div>
                    <div class="mb-3">
                        <div class="input-group mb-2">
                            <input id="coupon" type="text" class="form-control" placeholder="کد تخفیف را وارد کنید، لطفا خالی بگذارید">
                            <button id="verify-coupon" class="btn" type="button">تایید</button>
                        </div>
                    </div>
                    <p id="valid-msg"></p>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn me-auto" data-bs-dismiss="modal">لغو</button>
                    <button id="create-order" type="button" class="btn btn-primary"
                        data-bs-dismiss="modal">سفارش</button>
                </div>
            </div>
        </div>
    </div>

    <div class="modal modal-blur fade" id="notice-dialog" tabindex="-1" role="dialog" aria-hidden="true">
        <div class="modal-dialog modal-sm modal-dialog-centered" role="document">
            <div class="modal-content">
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                <div class="modal-status bg-yellow"></div>
                <div class="modal-body text-center py-4">
                    <svg xmlns="http://www.w3.org/2000/svg" class="icon mb-2 text-yellow icon-lg" width="24" height="24"
                        viewBox="0 0 24 24" stroke-width="2" stroke="currentColor" fill="none" stroke-linecap="round"
                        stroke-linejoin="round">
                        <path stroke="none" d="M0 0h24v24H0z" fill="none"></path>
                        <circle cx="12" cy="12" r="9"></circle>
                        <line x1="12" y1="17" x2="12" y2="17.01"></line>
                        <path d="M12 13.5a1.5 1.5 0 0 1 1 -1.5a2.6 2.6 0 1 0 -3 -4"></path>
                    </svg>
                    <p id="notice-message" class="text-muted">注意</p>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn me-auto" data-bs-dismiss="modal">لغو</button>
                    <button id="notice-confirm" type="button" class="btn btn-yellow" data-bs-dismiss="modal">تایید</button>
                </div>
            </div>
        </div>
    </div>

    <div class="modal modal-blur fade" id="account-recharge" tabindex="-1" role="dialog" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered modal-dialog-scrollable" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">شارژ اکانت</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <p style="color: red;">یادآوری: سیستم فروشگاه جدید در حال حاضر از اسکن مستقیم سفارش و پرداخت پشتیبانی می کند، بدون نیاز به شارژ مجدد قبل از خرید. این عملکرد برای کاربرانی ارائه می شود که هنگام پرداخت صورتحساب با قبوض زیر سقف پرداخت مواجه می شوند</p>
                    <div class="form-group mb-3 row">
                        <label class="form-label col-2 col-form-label">تعداد</label>
                        <div class="col">
                            <input id="recharge_amount" type="text" class="form-control" placeholder="لطفا مبلغ شارژ را وارد کنید">
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn me-auto" data-bs-dismiss="modal">لغو</button>
                    <button id="create-recharge-order" type="button" class="btn btn-primary"
                        data-bs-dismiss="modal">ارسال</button>
                </div>
            </div>
        </div>
    </div>

    <script>
        function buy(product_id) {
            order_product_id = product_id;
            product_buy_name = $('#product-' + product_id + '-name').text();
            product_buy_price = $('#product-' + product_id + '-price').text();

            $('#product-buy-dialog').modal('show');
            $('#product-buy-name').text(product_buy_name);
            $('#product-buy-price').text((product_buy_price * 1).toFixed(2));
            $('#product-buy-total').text((product_buy_price * 1).toFixed(2));
        }

        $("#verify-coupon").click(function() {
            $.ajax({
                url: '/user/coupon_check',
                type: 'POST',
                dataType: "json",
                data: {
                    coupon: $('#coupon').val(),
                    product_id: order_product_id
                },
                success: function(data) {
                    if (data.ret == 1) {
                        $('#product-buy-discount').text('-' + ((1 - data.discount) *
                            product_buy_price).toFixed(2));
                        $('#product-buy-total').text((data.discount * product_buy_price).toFixed(
                            2));
                    } else {
                        $('#fail-message').text(data.msg);
                        $('#product-buy-dialog').modal('hide');
                        $('#fail-dialog').modal('show');
                    }
                }
            })
        });

        $("#create-order").click(function() {
            $.ajax({
                url: '/user/order',
                type: 'POST',
                dataType: "json",
                data: {
                    coupon: $('#coupon').val(),
                    product_id: order_product_id
                },
                success: function(data) {
                    if (data.ret == 1) {
                        $('#success-message').text('سفارش شما در حال آماده سازی است');
                        $('#success-dialog').modal('show');
                        setTimeout(function() {
                            $(location).attr('href', '/user/order/' + data.order_id);
                        }, 1500);
                    } else {
                        $('#fail-message').text(data.msg);
                        $('#product-buy-dialog').modal('hide');
                        $('#fail-dialog').modal('show');
                    }
                }
            })
        });

        $("#create-recharge-order").click(function() {
            $.ajax({
                url: '/user/charge',
                type: 'POST',
                dataType: "json",
                data: {
                    recharge_amount: $('#recharge_amount').val(),
                },
                success: function(data) {
                    if (data.ret == 1) {
                        $('#success-message').text('سفارش شما در حال آماده سازی است');
                        $('#success-dialog').modal('show');
                        setTimeout(function() {
                            $(location).attr('href', '/user/order/' + data.order_id);
                        }, 1500);
                    } else {
                        $('#fail-message').text(data.msg);
                        $('#product-buy-dialog').modal('hide');
                        $('#fail-dialog').modal('show');
                    }
                }
            })
        });

        {literal}                     
            // https://zablog.me/2015/10/25/Popover/ خیلی ممنونم
            $(document).ready(
                function() {
                    $(".pop").popover({placement:'left', trigger:'manual', delay: {show: 100, hide: 100}, html: true,
                    title: function() {
                        return $("#data-original-title").html();
                    },
                    content: function() {
                        return $("#data-content").html(); // تغییر محتوا به html
                    }
                });
            $('body').click(function(event) {
                var target = $(event.target); // مشخص کنید که در حال حاضر روی چه چیزی کلیک می کنید
                if (!target.hasClass('popover') &&
                    !target.hasClass('pop') &&
                    !target.hasClass('popover-content') &&
                    !target.hasClass('popover-title') &&
                    !target.hasClass('arrow')) {
                    $('.pop').popover('hide'); // 当点击body的非弹出框相关的内容的时候，غیرفعال所有popover
                }
            });
            $(".pop").click(function(event) {
            $('.pop').popover('hide'); // 当点击一个按钮的时候把其他的所有内容先غیرفعال
            });
            }
            );
        {/literal}
    </script>
    
{include file='user/tabler_footer.tpl'}