{include file='user/tabler_header.tpl'}

<div class="page-wrapper">
    <div class="container-xl">
        <div class="page-header d-print-none text-white">
            <div class="row align-items-center">
                <div class="col">
                    <h2 class="page-title">
                        <span class="home-title">سوابق فیلترینگ</span>
                    </h2>
                    <div class="page-pretitle my-3">
                        <span class="home-subtitle">کلیه سوابق فیلترینگ در سیستم</span>
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
                                        <th>شناسه سرور</th>
                                        <th>نام سرور</th>
                                        <th>شناسه قانون</th>
                                        <th>نام</th>
                                        <th>شرح</th>
                                        <th>regular expression</th>
                                        <th>انواع</th>
                                        <th>زمان</th>
                                    </tr>
                                </thead>
                                <tbody>
                                {foreach $logs as $log}
                                <tr>
                                    <td>#{$log->id}</td>
                                    <td>{$log->node_id}</td>
                                    <td>{$log->node_name}</td>
                                    <td>{$log->list_id}</td>
                                    <td>{$log->rule->name}</td>
                                    <td>{$log->rule->text}</td>
                                    <td>{$log->rule->regex}</td>
                                    <td>{$log->rule->type}</td>
                                    <td>{$log->datetime}</td>
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
