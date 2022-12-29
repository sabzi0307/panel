{include file='user/tabler_header.tpl'}

<div class="page-wrapper">
    <div class="container-xl">
        <div class="page-header d-print-none text-white">
            <div class="row align-items-center">
                <div class="col">
                    <h2 class="page-title">
                        <span class="home-title">سوابق ممیزی</span>
                    </h2>
                    <div class="page-pretitle my-3">
                        <span class="home-subtitle">کلیه سوابق ممیزی در سیستم</span>
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
                                        <th>شناسه گره</th>
                                        <th>نام گره</th>
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
                                    {assign var="rule" value=$log->rule()}
                                    {if $rule != null}
                                        <tr>
                                            <td>#{$log->id}</td>
                                            <td>{$log->node_id}</td>
                                            <td>{$log->Node()->name}</td>
                                            <td>{$log->list_id}</td>
                                            <td>{$rule->name}</td>
                                            <td>{$rule->text}</td>
                                            <td>{$rule->regex}</td>
                                            {if $rule->type == 1}
                                                <td>مطابقت متن ساده بسته</td>
                                            {/if}
                                            {if $rule->type == 2}
                                                <td>بسته داده hex همخوانی داشتن</td>
                                            {/if}
                                            <td>{date('Y-m-d H:i:s',$log->datetime)}</td>
                                        </tr>
                                    {/if}
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
