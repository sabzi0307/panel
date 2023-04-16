{include file='user/tabler_header.tpl'}

<div class="page-wrapper">
    <div class="container-xl">
        <div class="page-header d-print-none text-white">
            <div class="row align-items-center">
                <div class="col">
                    <h2 class="page-title">
                        <span class="home-title my-3">صورت حساب #{$invoice->id}</span>
                    </h2>
                    <div class="page-pretitle">
                        <span class="home-subtitle">جزئیات صورتحساب</span>
                    </div>
                </div>
                <div class="col-auto ms-auto d-print-none">
                    <div class="btn-list">
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div class="page-body">
        <div class="container-xl">
            <div class="row row-cards">
                {if $invoice->status === 'unpaid'}
                <div class="col-sm-12 col-md-6 col-lg-9">
                {else}
                <div class="col-sm-12 col-md-12 col-lg-12">
                {/if}
                    <div class="card">
                        <div class="card-header">
                            <h3 class="card-title">اطلاعات پایه</h3>
                        </div>
                        <div class="card-body">
                            <div class="datagrid">
                                <div class="datagrid-item">
                                    <div class="datagrid-title">شناسه سفارش</div>
                                    <div class="datagrid-content">{$invoice->order_id}</div>
                                </div>
                                <div class="datagrid-item">
                                    <div class="datagrid-title">مبلغ سفارش</div>
                                    <div class="datagrid-content">{$invoice->price}</div>
                                </div>
                                <div class="datagrid-item">
                                    <div class="datagrid-title">وضعیت سفارش</div>
                                    <div class="datagrid-content">{$invoice->status_text}</div>
                                </div>
                                <div class="datagrid-item">
                                    <div class="datagrid-title">زمان ایجاد</div>
                                    <div class="datagrid-content">{$invoice->create_time}</div>
                                </div>
                                <div class="datagrid-item">
                                    <div class="datagrid-title">زمان به روز رسانی</div>
                                    <div class="datagrid-content">{$invoice->update_time}</div>
                                </div>
                                <div class="datagrid-item">
                                    <div class="datagrid-title">زمان پرداخت</div>
                                    <div class="datagrid-content">{$invoice->pay_time}</div>
                                </div>
                                {if $invoice->status === 'paid_gateway'}
                                <div class="datagrid-item">
                                    <div class="datagrid-title">شماره پیگیری درگاه پرداخت</div>
                                    <div class="datagrid-content">{$paylist->tradeno}</div>
                                </div>
                                {/if}   
                            </div>
                        </div>
                    </div>
                    <div class="card my-3">
                        <div class="card-header">
                            <h3 class="card-title">جزئیات صورتحساب</h3>
                        </div>
                        <div class="card-body">
                            <div class="table-responsive">
                                <table id="invoice_content_table" class="table table-vcenter card-table">
                                    <thead>
                                        <tr>
                                            <th>نام</th>
                                            <th>قیمت</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        {foreach $invoice_content as $invoice_content_detail}
                                        <tr>
                                            <td>{$invoice_content_detail->name}</td>
                                            <td>{$invoice_content_detail->price}</td>
                                        </tr>
                                        {/foreach}
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>
                {if $invoice->status === 'unpaid'}
                <div class="col-sm-12 col-md-6 col-lg-3">
                    <div class="card">
                        <div class="card-header">
                            <h3 class="card-title">پرداخت نشده</h3>
                        </div>
                        <div class="card-body">
                            <div class="mb-3">
                                موجودی حساب جاری موجود:<code>{$user->money}</code> 元
                            </div>
                        </div>
                        <div class="card-footer">
                          <div class="d-flex">
                          <button id="pay-balance" class="btn btn-blue" type="button">برای پرداخت</button>
                          </div>
                        </div>
                    </div>
                    {if count($payments) > 0}
                    <div class="card my-3">
                        <div class="card-header">
                            <h3 class="card-title">درگاه پرداخت</h3>
                        </div>
                        <div class="card-body">
                            {foreach from=$payments item=payment}
                                <div class="mb-3">
                                    {$payment_name = $payment::_name()}
                                    {include file="../../gateway/$payment_name.tpl"}
                                </div>
                            {/foreach}
                        </div>
                    </div>
                    {/if}
                </div>
                {/if}
            </div>
        </div>
    </div>

    <script>
        $("#pay-balance").click(function() {
            $.ajax({
                url: '/user/invoice/pay_balance',
                type: 'POST',
                dataType: "json",
                data: {
                    invoice_id: {$invoice->id},
                },
                success: function(data) {
                    if (data.ret === 1) {
                        $('#success-message').text(data.msg);
                        $('#success-dialog').modal('show');
                        setTimeout(function() {
                            $(location).attr('href', '/user/invoice');
                        }, 1500);
                    } else {
                        $('#fail-message').text(data.msg);
                        $('#fail-dialog').modal('show');
                    }
                }
            })
        });  
    </script>

{include file='user/tabler_footer.tpl'}
