{include file="user/tabler_header.tpl"}

<div class="page-wrapper">
    <div class="container-xl">
        <div class="page-header d-print-none text-white">
            <div class="row align-items-center">
                <div class="col">
                    <h2 class="page-title">
                        <span class="home-title">لیست سرور ها</span>
                    </h2>
                    <div class="page-pretitle my-3">
                        <span class="home-subtitle">وضعیت آنلاین سرور را بررسی کنید</span>
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
                            <div class="m-0 my-2">
                                <p>توضیحات به ترتیب به صورت زیر بیان می شود: تعداد کاربران آنلاین این سرور، ضریب ترافیک این سرور و نوع این سرور.</p>
                                <p>چراغ سبز نشان دهنده عملکرد عادی است، نشانگر زرد نشان می دهد که ترافیک ماه جاری تمام شده است، نشانگر نارنجی نشان می دهد که پیکربندی موفقیت آمیز نیست، نشانگر قرمز نشان می دهد که آفلاین است و نمی توان از آن استفاده کرد.</p>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-12">
                    <div class="card">
                        <div class="card-body">
                            <div class="tab-content">
                                <div class="row row-cards">
                                    {foreach $servers as $server}
                                        <div class="col-lg-4 col-md-6 col-sm-12">
                                            <div class="card">
                                                {if $server["class"] == 0}
                                                <div class="ribbon bg-red">رایگان</div>
                                                {else}
                                                <div class="ribbon bg-red">LV. {$server["class"]}</div>
                                                {/if}
                                                <div class="card-body">
                                                    <div class="row g-3 align-items-center" style="direction: ltr;">
                                                        <div class="col-auto">
                                                            <span
                                                                class="status-indicator
                                                                {if $server["traffic_limit"] != '0' && $server["traffic_used"] >= $server["traffic_limit"]}
                                                                status-yellow 
                                                                {elseif $server["online"] == "1"}
                                                                status-green 
                                                                {elseif $server["online"] == "0"}
                                                                status-orange 
                                                                {else}
                                                                status-red 
                                                                {/if}
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
                                                                    {if $server["traffic_limit"] == "0"}
                                                                        {round($server["traffic_used"])} GB /
                                                                        نامحدود
                                                                    {else}
                                                                        {round($server["traffic_used"])} GB /
                                                                        {round($server["traffic_limit"])} GB
                                                                    {/if}
                                                                </span>
                                                            </h2>
                                                            <div class="text-muted">
                                                                <ul class="list-inline list-inline-dots mb-0">
                                                                    <li class="list-inline-item">
                                                                        <i class="ti ti-users"></i>&nbsp;
                                                                        {$server["online_user"]}
                                                                    </li>
                                                                    <li class="list-inline-item">
                                                                        <i class="ti ti-rocket"></i>&nbsp;
                                                                        {$server["traffic_rate"]} 倍
                                                                    </li>
                                                                    <li class="list-inline-item">
                                                                        <i class="ti ti-server-2"></i>&nbsp;
                                                                        {if $server['sort'] == 0}
                                                                        Shadowsocks
                                                                        {elseif $server['sort'] == 9}
                                                                        Shadowsocksr
                                                                        {elseif $server['sort'] == 11}
                                                                        V2ray
                                                                        {elseif $server['sort'] == 14}
                                                                        Trojan
                                                                        {/if}
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
                                                    <p class="text-muted">
                                                        <i class="ti ti-info-circle icon text-blue"></i>
                                                        سطح حساب فعلی شما کمتر از سطح سرور است، بنابراین نمی توان از آن استفاده کرد. می تواند به <a
                                                            href="/user/shop">فروشگاه</a> بسته سطح مربوطه را سفارش دهید
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

    <script>
        var clipboard = new ClipboardJS(".ti-copy");
        clipboard.on("success", function(e) {
            $("#success-message").text("در کلیپ بورد کپی شد");
            $("#success-dialog").modal("show");
        });
    </script>
    
{include file="user/tabler_footer.tpl"}
