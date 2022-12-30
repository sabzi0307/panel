{include file='admin/main.tpl'}

<main class="content">
    <div class="content-header ui-content-header">
        <div class="container">
            <h1 class="content-heading">مدیریت کد شارژ</h1>
        </div>
    </div>
    <div class="container">
        <div class="col-lg-12 col-md-12">
            <section class="content-inner margin-top-no">
                <div class="card">
                    <div class="card-main">
                        <div class="card-inner">
                            <p>سوابق انتقال مبلغ در سیستم.</p>
                            <p>
                                گردش امروز：${$user->calIncome("today")}<br/>
                                گردش دیروز：${$user->calIncome("yesterday")}<br/>
                                گردش این ماه：${$user->calIncome("this month")}<br/>
                                گردش ماه گذشته：${$user->calIncome("last month")}<br/>
                                کل گردش مالی：${$user->calIncome("total")}
                            </p>
                            <p>نمایش ورودی ها:
                                {include file='table/checkbox.tpl'}
                            </p>
                        </div>
                    </div>
                </div>
                <div class="table-responsive">
                    {include file='table/table.tpl'}
                </div>
                <div class="fbtn-container">
                    <div class="fbtn-inner">
                        <a class="fbtn fbtn-lg fbtn-brand-accent waves-attach waves-circle waves-light"
                           href="/admin/code/create">+</a>
                    </div>
                </div>
                <div class="fbtn-container">
                    <div class="fbtn-inner">
                        <a class="fbtn fbtn-lg fbtn-brand-accent waves-attach waves-circle waves-light"
                           data-toggle="dropdown"><span class="fbtn-ori mdi mdi-plus"></span><span class="fbtn-sub mdi mdi-close"></span></a>
                        <div class="fbtn-dropup">
                            <a class="fbtn fbtn-brand waves-attach waves-circle waves-light"
                               href="/admin/code/create"><span class="fbtn-text fbtn-text-left">کد شارژ</span><span
                                        class="mdi mdi-code-tags"></span></a>
                        </div>
                    </div>
                </div>
            </section>
        </div>
    </div>
</main>

{include file='admin/footer.tpl'}

<script>
    {include file='table/js_1.tpl'}
    $(document).ready(function () {
        {include file='table/js_2.tpl'}
    });
</script>