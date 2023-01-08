{include file='user/main.tpl'}

<main class="content">
    <div class="content-header ui-content-header">
        <div class="container">
            <h1 class="content-heading">خرید بسته</h1>
        </div>
    </div>
    <div class="container">
        <div class="col-lg-12 col-sm-12">
            <section class="content-inner margin-top-no">
                <div class="card">
                    <div class="card-main">
                        <div class="card-inner">
                            <p>کالاها را نمی توان روی هم قرار داد و کالاهای تازه خریداری شده اثرات کالاهای قدیمی را بازنویسی می کنند.</p>
                            <p>در هنگام خرید بسته جدید، در صورتی که تمدید خودکار بسته قدیمی خاموش نشود، تمدید خودکار بسته قدیمی همچنان برقرار است.</p>
                            <p><i class="mdi mdi-currency-usd icon-lg"></i>موجودی فعلی：<font color="#399AF2" size="5">{$user->money}</font> تومان</p>
                        </div>
                    </div>
                </div>
                <div class="ui-switch">
                    <div class="card">
                        <div class="card-main">
                            <div class="card-inner ui-switch-inner">
                                <div class="switch-btn" id="switch-cards">
                                    <a href="#" onclick="return false">
                                        <i class="mdi mdi-apps"></i>
                                    </a>
                                </div>
                                <div class="switch-btn" id="switch-table">
                                    <a href="#" onclick="return false">
                                        <i class="mdi mdi-format-list-bulleted"></i>
                                    </a>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="card">
                        <div class="card-main">
                            <div class="dropdown btn-group">
                                <a href="javascript:void(0);" type="button" class="btn btn-dropdown-toggle dropdown-toggle" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                                  نوع سرویس را انتخاب کنید <span class="caret"></span>
                                </a>
                                <ul class="dropdown-menu">
                                  <li class="order-type"><a href="javascript:void(0)" id="orders">خرید بسته</a></li>
                                  <li class="order-type"><a href="javascript:void(0)" id="traffice-packages">بسته ترافیک اضافه</a></li>
                                </ul>
                            </div>
                        </div>
                    </div>
                </div>
            <div data-areatype="orders">
                <div class="shop-flex">
                    {foreach $shops as $shop}
                    {if $shop->trafficPackage() == 0}
                        <div class="card">
                            <div class="card-main">
                                <div class="shop-name">{$shop->name}</div>
                                <div class="shop-price">{$shop->price}</div>
                                <div class="shop-tat">
                                    <span>{$shop->bandwidth()}</span> / <span>{$shop->classExpire()}</span>
                                </div>
                                <div class="shop-cube">
                                    <div>
                                        <div class="cube-detail">
                                            <span>Lv.</span>{$shop->userClass()}
                                        </div>
                                        <div class="cube-title">
                                            VIP
                                        </div>
                                    </div>
                                    <div>
                                        <div class="cube-detail">
                                            {if {$shop->connector()} == '0' }نامحدود{else}{$shop->connector()}
                                                <span> 个</span>
                                            {/if}
                                        </div>
                                        <div class="cube-title">
                                            تعداد مشتریان
                                        </div>
                                    </div>
                                    <div>
                                        <div class="cube-detail">
                                            {if {$shop->speedlimit()} == '0' }نامحدود{else}{$shop->speedlimit()}
                                                <span> Mbps</span>
                                            {/if}
                                        </div>
                                        <div class="cube-title">
                                            سرعت پورت
                                        </div>
                                    </div>
                                </div>
                                <div class="shop-content">
                                    <div class="shop-content-left">مدت اعتبار حساب:</div>
                                    <div class="shop-content-right">{$shop->expire()}<span>天</span></div>
                                    <div class="shop-content-left">چرخه تنظیم مجدد:</div>
                                    <div class="shop-content-right">{if {$shop->reset()} == '0' }N / A{else}{$shop->resetExp()}
                                            <span>天</span>
                                        {/if}</div>
                                    <div class="shop-content-left">تنظیم مجدد همواره:</div>
                                    <div class="shop-content-right">{if {$shop->reset()} == '0' }N / A{else}{$shop->resetValue()}
                                            <span>G</span>
                                            / {$shop->reset()}
                                            <span>天</span>
                                        {/if}</div>
                                </div>
                                <div class="shop-content-extra">
                                    {foreach $shop->contentExtra() as $service}
                                        <div><span class="mdi mdi-{$service[0]}"></span> {$service[1]}</div>
                                    {/foreach}
                                </div>
                                <a class="btn btn-brand-accent shop-btn" href="javascript:void(0);"
                                   onClick="buy('{$shop->id}',{$shop->auto_renew})">خرید</a>
                            </div>
                        </div>
                    {/if}
                    {/foreach}
                    <div class="flex-fix3"></div>
                    <div class="flex-fix4"></div>
                </div>
                <div class="shop-table">
                    {foreach $shops as $shop}
                    {if $shop->trafficPackage() == 0}
                        <div class="shop-gridarea">
                            <div class="card">
                                <div>
                                    <div class="shop-name"><span>{$shop->name}</span></div>
                                    <div class="card-tag tag-gold">VIP {$shop->userClass()}</div>
                                    <div class="card-tag tag-orange">¥ {$shop->price}</div>
                                    <div class="card-tag tag-cyan">{$shop->bandwidth()} G</div>
                                    <div class="card-tag tag-blue">{$shop->classExpire()} روز</div>
                                </div>
                                <div>
                                    <i class="mdi mdi-chevron-down"></i>
                                </div>
                            </div>
                            <a class="btn btn-brand-accent shop-btn" href="javascript:void(0);"
                               onClick="buy('{$shop->id}',{$shop->auto_renew})">خرید</a>
                            <div class="shop-drop dropdown-area">
                                <div class="card-tag tag-black">مدت اعتبار حساب</div>
                                <div class="card-tag tag-blue">{$shop->expire()} روز</div>
                                {if {$shop->reset()} == '0' }
                                    <div class="card-tag tag-black">چرخه تنظیم مجدد</div>
                                    <div class="card-tag tag-blue">N/A</div>
                                {else}
                                    <div class="card-tag tag-black">چرخه تنظیم مجدد</div>
                                    <div class="card-tag tag-blue">{$shop->resetExp()} 天</div>
                                    <div class="card-tag tag-black">تنظیم مجدد همواره</div>
                                    <div class="card-tag tag-blue">{$shop->resetValue()}G/{$shop->reset()}天</div>
                                {/if}
                                {if {$shop->speedlimit()} == '0' }
                                    <div class="card-tag tag-black">سرعت پورت</div>
                                    <div class="card-tag tag-blue">نامحدود</div>
                                {else}
                                    <div class="card-tag tag-black">محدودیت سرعت پورت</div>
                                    <div class="card-tag tag-blue">{$shop->speedlimit()} Mbps</div>
                                {/if}
                                {if {$shop->connector()} == '0' }
                                    <div class="card-tag tag-black">تعداد کاربر</div>
                                    <div class="card-tag tag-blue">نامحدود</div>
                                {else}
                                    <div class="card-tag tag-black">محدودیت کاربر</div>
                                    <div class="card-tag tag-blue">{$shop->connector()} 个</div>
                                {/if}
                            </div>
                        </div>
                    {/if}
                    {/foreach}
                </div>
            </div>
            <div style="display: none;" data-areatype="trafficePackages">
                <div class="shop-table" style="display: flex">
                    {foreach $shops as $shop}
                    {if $shop->trafficPackage() != 0}
                    <div class="shop-gridarea">
                        <div class="card">
                            <div>
                                <div class="shop-name"><span>{$shop->name}</span></div>
                                <div class="card-tag tag-orange">¥ {$shop->price}</div>
                                <div class="card-tag tag-cyan">{$shop->bandwidth()} G</div>
                            </div>
                            <div>
                                <i class="mdi mdi-chevron-down"></i>
                            </div>
                        </div>
                        <a class="btn btn-brand-accent shop-btn" href="javascript:void(0);"
                        onClick="buyTraffic('{$shop->id}')">خرید</a>
                        <div class="shop-drop dropdown-area">
                            <div class="card-tag tag-black">بسته ترافیک</div>
                            <div class="card-tag tag-blue">{$shop->bandwidth()} G</div>
                        </div>
                    </div>
                {/if}
                {/foreach}
                </div>
            </div>
                <div aria-hidden="true" class="modal modal-va-middle fade" id="coupon_modal" role="dialog"
                     tabindex="-1">
                    <div class="modal-dialog modal-xs">
                        <div class="modal-content">
                            <div class="modal-heading">
                                <a class="modal-close" data-dismiss="modal">×</a>
                                <h2 class="modal-title">آیا کوپن دارید？</h2>
                            </div>
                            <div class="modal-inner">
                                <div class="form-group form-group-label">
                                    <label class="floating-label" for="coupon">اگر چنین است، لطفاً آن را در اینجا وارد کنید</label>
                                    <input class="form-control maxwidth-edit" id="coupon" type="text">
                                </div>
                            </div>
                            <div class="modal-footer">
                                <p class="text-right">
                                    <button class="btn btn-flat btn-brand waves-attach" data-dismiss="modal"
                                            id="coupon_input" type="button">حتما
                                    </button>
                                </p>
                            </div>
                        </div>
                    </div>
                </div>
                <div aria-hidden="true" class="modal modal-va-middle fade" id="traffic_package_modal" role="dialog"
                     tabindex="-1">
                    <div class="modal-dialog modal-xs">
                        <div class="modal-content">
                            <div class="modal-heading">
                                <a class="modal-close" data-dismiss="modal">×</a>
                                <h2 class="modal-title">آیا مطمئن هستید که بسته ترافیک را خریداری می کنید؟</h2>
                            </div>
                            <div class="modal-footer">
                                <p class="text-right">
                                    <button class="btn btn-flat btn-brand waves-attach" data-dismiss="modal"
                                            id="traffic_package_confirm" type="button">مطمئن
                                    </button>
                                </p>
                            </div>
                        </div>
                    </div>
                </div>
                <div aria-hidden="true" class="modal modal-va-middle fade" id="order_modal" role="dialog" tabindex="-1">
                    <div class="modal-dialog modal-xs">
                        <div class="modal-content">
                            <div class="modal-heading">
                                <a class="modal-close" data-dismiss="modal">×</a>
                                <h2 class="modal-title">تایید سفارش</h2>
                            </div>
                            <div class="modal-inner">
                                <p id="name">نام سرویس:</p>
                                <p id="credit">مبلغ تخفیف:</p>
                                <p id="total">مبلغ کل:</p>
                                <div class="checkbox switch">
                                    <label for="disableothers">
                                        <input checked class="access-hide" id="disableothers" type="checkbox">
                                        <span class="switch-toggle"></span>تمدید خودکار بسته های قدیمی را خاموش کنید
                                    </label>
                                </div>
                                <br/>
                                <div class="checkbox switch" id="autor">
                                    <label for="autorenew">
                                        <input checked class="access-hide" id="autorenew" type="checkbox">
                                        <span class="switch-toggle"></span>به صورت خودکار پس از انقضا تمدید می شود
                                    </label>
                                </div>

                            </div>
                            <div class="modal-footer">
                                <p class="text-right">
                                    <button class="btn btn-flat btn-brand waves-attach" data-dismiss="modal"
                                            id="order_input" type="button">مطمئن
                                    </button>
                                </p>
                            </div>
                        </div>
                    </div>
                </div>
                {include file='dialog.tpl'}
        </div>
    </div>
</main>

{include file='user/footer.tpl'}

<script>
    function buy(id, auto) {
        if (auto == 0) {
            document.getElementById('autor').style.display = "none";
        } else {
            document.getElementById('autor').style.display = "";
        }
        shop = id;
        $("#coupon_modal").modal();
    }
    let trafficPackageId;
    function buyTraffic(id) {
        trafficPackageId = id
        $("#traffic_package_modal").modal();
    }
    $('#traffic_package_confirm').click(function() {
        $.ajax({
            type: "POST",
            url: "buy_traffic_package",
            dataType: "json",
            data: {
                shop: trafficPackageId
            },
            success: (data) => {
                if (data.ret) {
                    $("#result").modal();
                    $$.getElementById('msg').innerHTML = data.msg;
                    window.setTimeout("location.href='/user/shop'", {$config['jump_delay']});
                } else {
                    $("#result").modal();
                    $$.getElementById('msg').innerHTML = data.msg;
                }
            },
            error: (jqXHR) => {
                $("#result").modal();
                $$.getElementById('msg').innerHTML = `${
                        data.msg
                        } خطایی رخ داد`;
            }
        })
    })
    ;(function () {
        //UI切换
        let elShopCard = $$.querySelectorAll(".shop-flex");
        let elShopTable = $$.querySelectorAll("[data-areatype=orders] .shop-table");
        let switchToCard = new UIswitch('switch-cards', elShopTable, elShopCard, 'flex', 'tempshop');
        switchToCard.listenSwitch();
        let switchToTable = new UIswitch('switch-table', elShopCard, elShopTable, 'flex', 'tempshop');
        switchToTable.listenSwitch();
        switchToCard.setDefault();
        switchToTable.setDefault();
        //手风琴
        let dropDownButton = $$.querySelectorAll('.shop-table .card');
        let dropDownArea = $$.querySelectorAll('.dropdown-area');
        let arrows = $$.querySelectorAll('.shop-table .card i');
        for (let i = 0; i < dropDownButton.length; i++) {
            rotatrArrow(dropDownButton[i], arrows[i]);
            custDropdown(dropDownButton[i], dropDownArea[i]);
        }
        //商品类型
        let orderType = "orders"
        let orders = $$.querySelectorAll('[data-areatype=orders]')
        let trafficePackages = $$.querySelectorAll('[data-areatype=trafficePackages]')
        let switchToOrders = new UIswitch('orders', trafficePackages, orders, 'flex', 'tempordertype');
        switchToOrders.listenSwitch();
        let switchToTrafficePackages = new UIswitch('traffice-packages', orders, trafficePackages, 'flex', 'tempordertype');
        switchToTrafficePackages.listenSwitch();
        switchToOrders.setDefault();
        switchToTrafficePackages.setDefault();
    })();
    $("#coupon_input").click(function () {
        $.ajax({
            type: "POST",
            url: "coupon_check",
            dataType: "json",
            data: {
                coupon: $$getValue('coupon'),
                shop
            },
            success: (data) => {
                if (data.ret) {
                    $$.getElementById('name').innerHTML = `نام سرویس:${
                            data.name
                            }`;
                    $$.getElementById('credit').innerHTML = `مبلغ تخفیف:${
                            data.credit
                            }`;
                    $$.getElementById('total').innerHTML = `مبلغ کل:${
                            data.total
                            }`;
                    $("#order_modal").modal();
                } else {
                    $("#result").modal();
                    $$.getElementById('msg').innerHTML = data.msg;
                }
            },
            error: (jqXHR) => {
                $("#result").modal();
                $$.getElementById('msg').innerHTML = `${
                        data.msg
                        } خطایی رخ داده`;
            }
        })
    });
    $("#order_input").click(function () {
        if (document.getElementById('autorenew').checked) {
            var autorenew = 1;
        } else {
            var autorenew = 0;
        }
        if (document.getElementById('disableothers').checked) {
            var disableothers = 1;
        } else {
            var disableothers = 0;
        }
        $.ajax({
            type: "POST",
            url: "buy",
            dataType: "json",
            data: {
                coupon: $$getValue('coupon'),
                shop,
                autorenew,
                disableothers
            },
            success: (data) => {
                if (data.ret) {
                    $("#result").modal();
                    $$.getElementById('msg').innerHTML = data.msg;
                    window.setTimeout("location.href='/user/shop'", {$config['jump_delay']});
                } else {
                    $("#result").modal();
                    $$.getElementById('msg').innerHTML = data.msg;
                }
            },
            error: (jqXHR) => {
                $("#result").modal();
                $$.getElementById('msg').innerHTML = `${
                        data.msg
                        } خطایی رخ داده`;
            }
        })
    });
</script>
