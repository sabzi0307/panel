{include file='user/header.tpl'}

<div class="page-wrapper">
    <div class="container-xl">
        <div class="page-header d-print-none text-white">
            <div class="row align-items-center">
                <div class="col">
                    <h2 class="page-title">
                        <span class="home-title">سفارش #{$order->id}</span>
                    </h2>
                    <div class="page-pretitle my-3">
                        <span class="home-subtitle">جزئیات سفارش</span>
                    </div>
                </div>
                <div class="col-auto">
                    <div class="btn-list">
                        <a href="/user/invoice/{$invoice->id}/view" targer="_blank" class="btn btn-primary">
                            <i class="icon ti ti-file-dollar"></i>
                            مشاهده صورتحساب
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div class="page-body">
        <div class="container-xl">
            <div class="card">
                <div class="card-header">
                    <h3 class="card-title">اطلاعات پایه</h3>
                </div>
                <div class="card-body">
                    <div class="datagrid">
                        <div class="datagrid-item">
                            <div class="datagrid-title">نوع سرویس</div>
                            <div class="datagrid-content">{$order->product_type_text}</div>
                        </div>
                        <div class="datagrid-item">
                            <div class="datagrid-title">نام سرویس</div>
                            <div class="datagrid-content">{$order->product_name}</div>
                        </div>
                        <div class="datagrid-item">
                            <div class="datagrid-title">سفارش کد تخفیف</div>
                            <div class="datagrid-content">{$order->coupon}</div>
                        </div>
                        <div class="datagrid-item">
                            <div class="datagrid-title">مبلغ سفارش</div>
                            <div class="datagrid-content">{$order->price}</div>
                        </div>
                        <div class="datagrid-item">
                            <div class="datagrid-title">وضعیت سفارش</div>
                            <div class="datagrid-content">{$order->status}</div>
                        </div>
                        <div class="datagrid-item">
                            <div class="datagrid-title">زمان ایجاد</div>
                            <div class="datagrid-content">{$order->create_time}</div>
                        </div>
                        <div class="datagrid-item">
                            <div class="datagrid-title">زمان به روز رسانی</div>
                            <div class="datagrid-content">{$order->update_time}</div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="card my-3">
                <div class="card-header">
                    <h3 class="card-title">محتوای محصول</h3>
                </div>
                <div class="card-body">
                    <div class="datagrid">
                        {if $order->product_type === 'tabp' || $order->product_type === 'time'}
                            <div class="datagrid-item">
                                <div class="datagrid-title">مدت زمان سرویس (روز)</div>
                                <div class="datagrid-content">{$order->content->time}</div>
                            </div>
                            <div class="datagrid-item">
                                <div class="datagrid-title">مدت زمان سطح (روز)</div>
                                <div class="datagrid-content">{$order->content->class_time}</div>
                            </div>
                            <div class="datagrid-item">
                                <div class="datagrid-title">سطح کاربری</div>
                                <div class="datagrid-content">{$order->content->class}</div>
                            </div>
                        {/if}
                        {if $order->product_type === 'tabp' || $order->product_type === 'bandwidth'}
                            <div class="datagrid-item">
                                <div class="datagrid-title">ترافیک موجود (GB)</div>
                                <div class="datagrid-content">{$order->content->bandwidth}</div>
                            </div>
                        {/if}
                        {if $order->product_type === 'tabp' || $order->product_type === 'time'}
                            <div class="datagrid-item">
                                <div class="datagrid-title">محدودیت نرخ (Mbps)</div>
                                <div class="datagrid-content">
                                    {if $order->content->ip_limit === '0'}
                                        بدون محدودیت
                                    {else}
                                        {$order->content->speed_limit}
                                    {/if}
                                </div>
                            </div>
                            <div class="datagrid-item">
                                <div class="datagrid-title">محدودیت IP اتصال همزمان</div>
                                <div class="datagrid-content">
                                    {if $order->content->ip_limit === '0'}
                                        بدون محدودیت
                                    {else}
                                        {$order->content->ip_limit}
                                    {/if}
                                </div>
                            </div>
                        {/if}
                    </div>
                </div>
            </div>
            <div class="card my-3">
                <div class="card-header">
                    <h3 class="card-title">صورت حساب مرتبط</h3>
                </div>
                <div class="card-body">
                    <div class="datagrid">
                        <div class="datagrid-item">
                            <div class="datagrid-title">محتوای صورت حساب</div>
                            <div class="datagrid-content">
                                <div class="table-responsive">
                                    <table id="invoice_content_table" class="table table-vcenter card-table">
                                        <thead>
                                        <tr>
                                            <th>نام</th>
                                            <th>قیمت</th>
                                        </tr>
                                        </thead>
                                        <tbody>
                                        {foreach $invoice->content as $invoice_content}
                                            <tr>
                                                <td>{$invoice_content->name}</td>
                                                <td>{$invoice_content->price}</td>
                                            </tr>
                                        {/foreach}
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                        </div>
                        <div class="datagrid-item">
                            <div class="datagrid-title">مبلغ صورتحساب</div>
                            <div class="datagrid-content">{$invoice->price}</div>
                        </div>
                        <div class="datagrid-item">
                            <div class="datagrid-title">وضعیت صورتحساب</div>
                            <div class="datagrid-content">{$invoice->status}</div>
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
                    </div>
                </div>
            </div>
        </div>
    </div>
    {include file='user/footer.tpl'}
