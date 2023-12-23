{include file='user/header.tpl'}

<div class="page-wrapper">
    <div class="container-xl">
        <div class="page-header d-print-none text-white">
            <div class="row align-items-center">
                <div class="col">
                    <h2 class="page-title">
                        <span class="home-title">سابقه اشتراک</span>
                    </h2>
                    <div class="page-pretitle my-3">
                        <span class="home-subtitle">اخیراً {$subscribe_log_retention_days} تمام سوابق اشتراک در روز</span>
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
                        <div class="table-responsive">
                            <table class="table table-vcenter card-table">
                                <thead>
                                <tr>
                                    <th>شناسه رویداد</th>
                                    <th>نوع</th>
                                    <th>IP</th>
                                    <th>انتساب</th>
                                    <th>زمان</th>
                                    <th>لوگو</th>
                                </tr>
                                </thead>
                                <tbody>
                                {foreach $logs as $log}
                                    <tr>
                                        <td>#{$log->id}</td>
                                        <td>{$log->type}</td>
                                        <td>{$log->request_ip}</td>
                                        <td>{$log->location}</td>
                                        <td>{$log->request_time}</td>
                                        <td>{$log->request_user_agent}</td>
                                    </tr>
                                {/foreach}
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

{include file='user/footer.tpl'}
