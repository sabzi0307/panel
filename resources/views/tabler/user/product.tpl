{include file='user/header.tpl'}

<div class="page-wrapper">
    <div class="container-xl">
        <div class="page-header d-print-none text-white">
            <div class="row align-items-center">
                <div class="col">
                    <h2 class="page-title">
                        <span class="home-title">لیست سرویس ها</span>
                    </h2>
                    <div class="page-pretitle my-3">
                        <span class="home-subtitle">محصولات مورد نیاز خود را مرور کنید</span>
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
                                    <p>موجودی فعلی حساب <code>{$user->money}</code> تومان، ترافیک باقی مانده <code>{$user->unusedTraffic()}</code>
                                        {if time() > strtotime($user->expire_in)}
                                            ，حساب شما منقضی شده است
                                        {else}
                                            {$diff = round((strtotime($user->expire_in) - time()) / 86400)}
                                            ，سطح Lv.{$user->class}，اعتبار باقی مانده است <code>{$diff}</code> روز
                                        {/if}
                                    </p>
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
                        <div class="card-body">
                            <div class="tab-content">
                                <div class="row">
                                    {foreach $products as $product}
                                    <div class="col-md-3 col-sm-12 my-3">
                                        <div class="card card-md">
                                            {if $product->type === 'tabp'}
                                            <div class="ribbon bg-blue">بسته ترافیک مدت دار</div>
                                            {elseif $product->type === 'time'}
                                            <div class="ribbon bg-blue">بسته مدت دار</div>
                                            {else}
                                            <div class="ribbon bg-blue">بسته ترافیک</div>
                                            {/if}
                                            <div class="card-body text-center">
                                                <div id="product-{$product->id}-name"
                                                    class="text-uppercase text-secondary font-weight-medium">
                                                    {$product->name}</div>
                                                <div id="product-{$product->id}-price"
                                                    class="display-6 my-3"><p class="fw-bold">{$product->price}</p> <i class="ti ti-currency-yuan"></i>
                                                </div>
                                                <div class="list-group list-group-flush">
                                                    <div class="list-group-item">
                                                        <div class="row align-items-center">
                                                            <div class="col text-truncate">
                                                                <div class="text-reset d-block">Lv. {$product->content->class}</div>
                                                                <div class="d-block text-secondary text-truncate mt-n1">سطح</div>
                                                            </div>
                                                        </div>
                                                    </div>
                                                    <div class="list-group-item">
                                                        <div class="row align-items-center">
                                                            <div class="col text-truncate">
                                                                <div class="text-reset d-block">{$product->content->class_time} 天</div>
                                                                <div class="d-block text-secondary text-truncate mt-n1">مدت زمان سطح</div>
                                                            </div>
                                                        </div>
                                                    </div>
                                                    <div class="list-group-item">
                                                        <div class="row align-items-center">
                                                            <div class="col text-truncate">
                                                                <div class="text-reset d-block">{$product->content->bandwidth} GB</div>
                                                                <div class="d-block text-secondary text-truncate mt-n1">ترافیک موجود</div>
                                                            </div>
                                                        </div>
                                                    </div>
                                                    <div class="list-group-item">
                                                        <div class="row align-items-center">
                                                            <div class="col text-truncate">
                                                                {if $product->content->speed_limit === '0'}
                                                                <div class="text-reset d-block">بدون محدودیت</div>  
                                                                {else}
                                                                <div class="text-reset d-block">{$product->content->speed_limit} Mbps</div>
                                                                {/if}
                                                                <div class="d-block text-secondary text-truncate mt-n1">سرعت اتصال</div>
                                                            </div>
                                                        </div>
                                                    </div>
                                                    <div class="list-group-item">
                                                        <div class="row align-items-center">
                                                            <div class="col text-truncate">
                                                                {if $product->content->ip_limit === '0'}
                                                                <div class="text-reset d-block">بدون محدودیت</div>
                                                                {else}
                                                                <div class="text-reset d-block">{$product->content->ip_limit}</div>
                                                                {/if}
                                                                <div class="d-block text-secondary text-truncate mt-n1">آی پی های متصل به طور همزمان</div>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                                <div class="row g-2">
                                                    {if $product->stock === -1 || $product->stock > 0}
                                                    <div class="col">
                                                        <a href="/user/order/create?product_id={$product->id}"
                                                            class="btn btn-primary w-100 my-3">بخرید</a>
                                                    </div>
                                                    {else}
                                                    <div class="col">
                                                        <a href="" class="btn btn-primary w-100 my-3"
                                                            disabled>فروخته شده</a>
                                                    </div>
                                                    {/if}
                                                </div>
                                            </div>
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
    </div>
    
{include file='user/footer.tpl'}