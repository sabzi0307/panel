{include file='admin/tabler_header.tpl'}

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
                <div class="col-auto ms-auto d-print-none">
                    <div class="btn-list">
                        <a href="/admin/user/{$order->user_id}/edit" targer="_blank" class="btn btn-primary d-none d-sm-inline-block">
                            <i class="icon ti ti-user"></i>
                            مشاهده کاربران مرتبط
                        </a>
                        <a href="/admin/user/{$order->user_id}/edit" targer="_blank" class="btn btn-primary d-sm-none btn-icon">
                            <i class="icon ti ti-user"></i>
                        </a>
                        <a href="/admin/invoice/{$invoice->id}/view" targer="_blank" class="btn btn-primary d-none d-sm-inline-block">
                            <i class="icon ti ti-file-dollar"></i>
                            صورتحساب های مرتبط را مشاهده کنید
                        </a>
                        <a href="/admin/invoice/{$invoice->id}/view" targer="_blank" class="btn btn-primary d-sm-none btn-icon">
                            <i class="icon ti ti-file-dollar"></i>
                        </a>
                        {if $order->status !== 'cancelled' && $order->status !== 'activated'}
                        <button href="#" class="btn btn-red d-none d-sm-inline-block" data-bs-toggle="modal"
                            data-bs-target="#cancel_order_confirm_dialog">
                            <i class="icon ti ti-x"></i>
                            لغو سفارش
                        </button>
                        <button href="#" class="btn btn-red d-sm-none btn-icon" data-bs-toggle="modal"
                            data-bs-target="#cancel_order_confirm_dialog">
                            <i class="icon ti ti-x"></i>
                        </button>
                        {/if}
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
                            <div class="datagrid-title">کاربر</div>
                            <div class="datagrid-content">{$order->user_id}</div>
                        </div>
                        <div class="datagrid-item">
                            <div class="datagrid-title">شناسه محصول</div>
                            <div class="datagrid-content">{$order->product_id}</div>
                        </div>
                        <div class="datagrid-item">
                            <div class="datagrid-title">نوع سرویس</div>
                            <div class="datagrid-content">{$order->product_type}</div>
                        </div>
                        <div class="datagrid-item">
                            <div class="datagrid-title">نام سرویس</div>
                            <div class="datagrid-content">{$order->product_name}</div>
                        </div>
                        <div class="datagrid-item">
                            <div class="datagrid-title">کدتخفیف سفارش</div>
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
                    <h3 class="card-title">商品内容</h3>
                </div>
                <div class="card-body">
                    <div class="datagrid">
                        <div class="datagrid-item">
                            <div class="datagrid-title">مدت زمان سرویس (روز)</div>
                            <div class="datagrid-content">{$product_content['time']}</div>
                        </div>
                        <div class="datagrid-item">
                            <div class="datagrid-title"> پهنای باند موجود (GB)</div>
                            <div class="datagrid-content">{$product_content['bandwidth']}</div>
                        </div>
                        <div class="datagrid-item">
                            <div class="datagrid-title">سطح</div>
                            <div class="datagrid-content">{$product_content['class']}</div>
                        </div>
                        <div class="datagrid-item">
                            <div class="datagrid-title">مدت زمان سطح (روز)</div>
                            <div class="datagrid-content">{$product_content['class_time']}</div>
                        </div>
                        <div class="datagrid-item">
                            <div class="datagrid-title">گروه کاربران</div>
                            <div class="datagrid-content">{$product_content['node_group']}</div>
                        </div>
                        <div class="datagrid-item">
                            <div class="datagrid-title">محدودیت سرعت (Mbps)</div>
                            <div class="datagrid-content">{$product_content['speed_limit']}</div>
                        </div>
                        <div class="datagrid-item">
                            <div class="datagrid-title">محدودیت اتصال همزمان IP</div>
                            <div class="datagrid-content">
                            {if $product_content['ip_limit'] === '-1'}
                            بدون محدودیت
                            {else}
                            {$product_content['ip_limit']}
                            {/if}
                            </div>
                        </div>
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
                            <div class="datagrid-title">شرح صورت حساب</div>
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
                                            {foreach $invoice_content as $invoice_content_detail}
                                            <tr>
                                                <td>{$invoice_content_detail['name']}</td>
                                                <td>{$invoice_content_detail['price']}</td>
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

    <div class="modal modal-blur fade" id="cancel_order_confirm_dialog" tabindex="-1" role="dialog" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered modal-dialog-scrollable" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">لغو سفارش</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <div class="mb-3">
                        <p>
                            لغو این سفارش را تأیید می کنید؟
                        <p>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn me-auto" data-bs-dismiss="modal">خیر</button>
                    <button id="confirm_cancel" type="button" class="btn btn-primary" data-bs-dismiss="modal">تایید</button>
                </div>
            </div>
        </div>
    </div>

    <script>
        $("#confirm_cancel").click(function() {
            $.ajax({
                url: "/admin/order/{$order->id}/cancel",
                type: 'POST',
                dataType: "json",
                success: function(data) {
                    if (data.ret == 1) {
                        $('#success-message').text(data.msg);
                        $('#success-dialog').modal('show');
                    } else {
                        $('#fail-message').text(data.msg);
                        $('#fail-dialog').modal('show');
                    }
                }
            })
        });

        $("#success-confirm").click(function() {
            location.reload();
        });
    </script>

{include file='admin/tabler_footer.tpl'}