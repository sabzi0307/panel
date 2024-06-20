{include file='admin/header.tpl'}

<div class="page-wrapper">
    <div class="container-xl">
        <div class="page-header d-print-none text-white">
            <div class="row align-items-center">
                <div class="col">
                    <h2 class="page-title">
                        <span class="home-title">نمای کلی سیستم</span>
                    </h2>
                    <div class="page-pretitle my-3">
                        <span class="home-subtitle">نشانگرهای مختلف عملکرد سیستم را در اینجا مشاهده کنید</span>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div class="page-body">
        <div class="container-xl">
            <div class="row row-deck row-cards">
                <div class="col-12">
                    <div class="row row-cards">
                        <div class="col-sm-6 col-lg-3">
                            <div class="card card-sm">
                                <div class="card-body">
                                    <div class="row align-items-center">
                                        <div class="col-auto">
                                            <span class="bg-info text-white avatar">
                                                <i class="ti ti-calendar-event icon"></i>
                                            </span>
                                        </div>
                                        <div class="col">
                                            <div class="font-weight-medium">
                                                {$today_income} {$currency}
                                            </div>
                                            <div class="text-secondary">
                                                گردش مالی امروز
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="col-sm-6 col-lg-3">
                            <div class="card card-sm">
                                <div class="card-body">
                                    <div class="row align-items-center">
                                        <div class="col-auto">
                                            <span class="bg-blue text-white avatar">
                                                <i class="ti ti-calendar-minus icon"></i>
                                            </span>
                                        </div>
                                        <div class="col">
                                            <div class="font-weight-medium">
                                                {$yesterday_income} {$currency}
                                            </div>
                                            <div class="text-secondary">
                                                گردش مالی دیروز
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="col-sm-6 col-lg-3">
                            <div class="card card-sm">
                                <div class="card-body">
                                    <div class="row align-items-center">
                                        <div class="col-auto">
                                            <span class="bg-warning text-white avatar">
                                                <i class="ti ti-calendar-stats icon"></i>
                                            </span>
                                        </div>
                                        <div class="col">
                                            <div class="font-weight-medium">
                                                {$this_month_income} {$currency}
                                            </div>
                                            <div class="text-secondary">
                                                گردش مالی این ماه
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="col-sm-6 col-lg-3">
                            <div class="card card-sm">
                                <div class="card-body">
                                    <div class="row align-items-center">
                                        <div class="col-auto">
                                            <span class="bg-danger text-white avatar">
                                                <i class="ti ti-calendar-plus icon"></i>
                                            </span>
                                        </div>
                                        <div class="col">
                                            <div class="font-weight-medium">
                                                {$total_income} {$currency}
                                            </div>
                                            <div class="text-secondary">
                                                گردش مالی کل
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-sm-12 col-md-6">
                    <div class="card">
                        <div class="card-header">
                            <h3 class="card-title">{$total_user} اعلام حضور کاربران</h3>
                        </div>
                        <div class="card-body">
                            <div id="check-in"></div>
                        </div>
                    </div>
                </div>
                <div class="col-sm-12 col-md-6">
                    <div class="card">
                        <div class="card-header">
                            <h3 class="card-title">{$total_node} وضعیت آنلاین بودن سرورها</h3>
                        </div>
                        <div class="card-body">
                            <div id="node-online"></div>
                        </div>
                    </div>
                </div>
                <div class="col-sm-12 col-md-6">
                    <div class="card">
                        <div class="card-header">
                            <h3 class="card-title">کاربر آنلاین</h3>
                        </div>
                        <div class="card-body">
                            <div id="user-inactive"></div>
                        </div>
                    </div>
                </div>
                <div class="col-sm-12 col-md-6">
                    <div class="card">
                        <div class="card-header">
                            <h3 class="card-title">مصرف ترافیک</h3>
                        </div>
                        <div class="card-body">
                            <div id="traffic-usage"></div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script>
        document.addEventListener("DOMContentLoaded", function () {
            window.ApexCharts && (new ApexCharts(document.getElementById('check-in'), {
                chart: {
                    type: "donut",
                    fontFamily: 'inherit',
                    height: 300,
                    sparkline: {
                        enabled: true
                    },
                    animations: {
                        enabled: false
                    },
                },
                fill: {
                    opacity: 1,
                },
                series: [{$total_user-$checkin_user}, {$checkin_user-$today_checkin_user}, {$today_checkin_user}],
                labels: ["بدون ورود", "قبلا وارد شده", "امروز وارد شده"],
                grid: {
                    strokeDashArray: 3,
                },
                colors: [tabler.getColor("azure"), tabler.getColor("cyan"), tabler.getColor("orange")],
                legend: {
                    show: true,
                    position: 'bottom',
                    offsetY: 12,
                    markers: {
                        width: 10,
                        height: 10,
                        radius: 100,
                    },
                    itemMargin: {
                        horizontal: 8,
                        vertical: 8
                    },
                },
                tooltip: {
                    fillSeriesColor: false
                },
            })).render();

            window.ApexCharts && (new ApexCharts(document.getElementById('node-online'), {
                chart: {
                    type: "donut",
                    fontFamily: 'inherit',
                    height: 300,
                    sparkline: {
                        enabled: true
                    },
                    animations: {
                        enabled: false
                    },
                },
                fill: {
                    opacity: 1,
                },
                series: [{$alive_node}, {$total_node-$alive_node}],
                labels: ["آنلاین", "آفلاین"],
                grid: {
                    strokeDashArray: 2,
                },
                colors: [tabler.getColor("lime"), tabler.getColor("red")],
                legend: {
                    show: true,
                    position: 'bottom',
                    offsetY: 12,
                    markers: {
                        width: 10,
                        height: 10,
                        radius: 100,
                    },
                    itemMargin: {
                        horizontal: 8,
                        vertical: 8
                    },
                },
                tooltip: {
                    fillSeriesColor: false
                },
            })).render();

            window.ApexCharts && (new ApexCharts(document.getElementById('user-inactive'), {
                chart: {
                    type: "donut",
                    fontFamily: 'inherit',
                    height: 300,
                    sparkline: {
                        enabled: true
                    },
                    animations: {
                        enabled: false
                    },
                },
                fill: {
                    opacity: 1,
                },
                series: [{$inactive_user}, {$active_user}],
                labels: ["حساب غیرفعال", "حساب فعال"],
                grid: {
                    strokeDashArray: 4,
                },
                colors: [tabler.getColor("yellow"), tabler.getColor("lime")],
                legend: {
                    show: true,
                    position: 'bottom',
                    offsetY: 12,
                    markers: {
                        width: 10,
                        height: 10,
                        radius: 100,
                    },
                    itemMargin: {
                        horizontal: 8,
                        vertical: 8
                    },
                },
                tooltip: {
                    fillSeriesColor: false
                },
            })).render();

            window.ApexCharts && (new ApexCharts(document.getElementById('traffic-usage'), {
                chart: {
                    type: "donut",
                    fontFamily: 'inherit',
                    height: 300,
                    sparkline: {
                        enabled: true
                    },
                    animations: {
                        enabled: false
                    },
                },
                fill: {
                    opacity: 1,
                },
                series: [{$raw_today_traffic}, {$raw_last_traffic}, {$raw_unused_traffic}],
                labels: ["امروز استفاده شده({$today_traffic})", "در گذشته استفاده شده({$last_traffic})", "ترافیک باقیمانده({$unused_traffic})"],
                grid: {
                    strokeDashArray: 3,
                },
                colors: [tabler.getColor("green"), tabler.getColor("lime"), tabler.getColor("yellow")],
                legend: {
                    show: true,
                    position: 'bottom',
                    offsetY: 12,
                    markers: {
                        width: 10,
                        height: 10,
                        radius: 100,
                    },
                    itemMargin: {
                        horizontal: 8,
                        vertical: 8
                    },
                },
                tooltip: {
                    fillSeriesColor: false
                },
            })).render();
        });
    </script>

    <script src="//{$config['jsdelivr_url']}/npm/@tabler/core@latest/dist/libs/apexcharts/dist/apexcharts.min.js"></script>

    {include file='admin/footer.tpl'}
