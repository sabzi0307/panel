{include file='user/tabler_header.tpl'}

<div class="page-wrapper">
    <div class="container-xl">  
        <div class="page-header d-print-none text-white">
            <div class="row align-items-center">
                <div class="col">                    
                    <h2 class="page-title">
                        <span class="home-title">سابقه اشتراک</span>
                    </h2>
                    <div class="page-pretitle my-3">
                        <span class="home-subtitle">به تازگی {$config['subscribeLog_keep_days']} تمام سوابق اشتراک در روز</span>
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
                                        <th>ID</th>
                                        <th>انواع</th>
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
                                        <td>{$log->subscribe_type}</td>
                                        <td>{$log->request_ip}</td>
                                        <td>{Tools::getIpInfo($log->request_ip)}</td>
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

{include file='user/tabler_footer.tpl'}