{include file="user/header.tpl"}

<div class="page-wrapper">
    <div class="container-xl">
        <div class="page-header d-print-none text-white">
            <div class="row align-items-center">
                <div class="col">
                    <h2 class="page-title">
                        <span class="home-title">لیست نود ها</span>
                    </h2>
                    <div class="page-pretitle my-3">
                        <span class="home-subtitle">وضعیت برخط نودها را بررسی کنید</span>
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
                            <div class="tab-content">
                                <div class="row row-cards">
                                    {foreach $servers as $server}
                                        <div class="col-lg-4 col-md-6 col-sm-12">
                                            <div class="card">
                                                {if $server["class"] === 0}
                                                    <div class="ribbon bg-blue">رایگان</div>
                                                {else}
                                                    <div class="ribbon bg-blue">LV. {$server["class"]}</div>
                                                {/if}
                                                <div class="card-body">
                                                    <div class="row g-3 align-items-center" style="direction: ltr;">
                                                        <div class="col-auto">
                                                            <span
                                                                    class="status-indicator status-{$server["color"]}
                                                                 status-indicator-animated">
                                                                <span class="status-indicator-circle"></span>
                                                                <span class="status-indicator-circle"></span>
                                                                <span class="status-indicator-circle"></span>
                                                            </span>
                                                        </div>
                                                        <div class="col">
                                                            <h2 class="page-title" style="font-size: 16px;">
                                                                {$server["name"]}&nbsp;
                                                                <span class="card-subtitle my-2"
                                                                      style="font-size: 10px;">
                                                                    {$server["node_bandwidth"]} /
                                                                    {$server["node_bandwidth_limit"]}
                                                                </span>
                                                            </h2>
                                                            <div class="text-secondary">
                                                                <ul class="list-inline list-inline-dots mb-0">
                                                                    <li class="list-inline-item">
                                                                        <i class="ti ti-users"></i>&nbsp;
                                                                        {$server["online_user"]}
                                                                    </li>
                                                                    <li class="list-inline-item">
                                                                        <i class="ti ti-rocket"></i>&nbsp;
                                                                        {if $server["is_dynamic_rate"]}
                                                                            dynamic ratio
                                                                        {else}
                                                                            {$server["traffic_rate"]} ضریب
                                                                        {/if}
                                                                    </li>
                                                                    <li class="list-inline-item">
                                                                        <i class="ti ti-server-2"></i>&nbsp;
                                                                        {$server['sort']}
                                                                    </li>
                                                                </ul>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                            {if $user->class < $server["class"]}
                                                <div class="card bg-primary-lt">
                                                    <div class="card-body">
                                                        <p class="text-secondary">
                                                            <i class="ti ti-info-circle icon text-blue"></i>
                                                            سطح حساب فعلی شما پایین‌تر از سطح گره است، بنابراین نمی‌توان از آن استفاده کرد. می تواند به <a
                                                                    href="/user/product">صفحه محصول</a> پکیج ترافیک زمانی را سفارش دهید
                                                        </p>
                                                    </div>
                                                </div>
                                            {/if}
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

    {include file="user/footer.tpl"}
