{include file='user/header.tpl'}

<div class="page-wrapper">
    <div class="container-xl">       
        <div class="page-header d-print-none text-white">
            <div class="row align-items-center">
                <div class="col">
                    <h2 class="page-title">
                        <span class="home-title">سابقه موجودی</span>
                    </h2>
                    <div class="page-pretitle my-3">
                        <span class="home-subtitle">مشاهده سوابق تغییر موجودی حساب</span>
                    </div>
                </div>
                <div class="col-auto">
                    <div class="btn-list">
                        <a href="#" class="btn btn-primary" data-bs-toggle="modal"
                           data-bs-target="#apply-giftcard-dialog">
                            <i class="icon ti ti-cash-banknote"></i>
                            از کارت هدیه استفاده کنید
                        </a>
                    </div>
                    {if $perfectMoney}
                    <div class="btn-list">
                        <a href="#" class="btn btn-primary" data-bs-toggle="modal"
                           data-bs-target="#active-perfectvoucher-dialog">
                            <i class="icon ti ti-cash-banknote"></i>
                            استفاده از وچر پرفکت مانی
                        </a>
                    </div>
                    {/if}
                </div>
            </div>
        </div>
    </div>
    <div class="page-body">
        <div class="container-xl">
            <div class="row row-deck">
                <div class="col-sm-12 col-lg-12">
                    <div class="card">
                            <div class="table-responsive">
                                <table class="table card-table table-vcenter text-nowrap datatable">
                                    <thead>
                                    <tr>
                                        <th>شناسه رویداد</th>
                                        <th>موجودی قبل از تغییر</th>
                                        <th>موجودی پس از تغییر</th>
                                        <th>میزان تغییر</th>
                                        <th>ریمارک</th>
                                        <th>زمان تغییر</th>
                                    </tr>
                                    </thead>
                                    <tbody>
                                    {foreach $moneylogs as $moneylog}
                                        <tr>
                                            <td>{$moneylog->id}</td>
                                            <td>{$moneylog->before}</td>
                                            <td>{$moneylog->after}</td>
                                            <td>{$moneylog->amount}</td>
                                            <td>{$moneylog->remark}</td>
                                            <td>{$moneylog->create_time}</td>
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

    <div class="modal modal-blur fade" id="apply-giftcard-dialog" tabindex="-1" role="dialog" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered modal-dialog-scrollable" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">از کارت هدیه استفاده کنید</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <div class="form-group mb-3 row">
                        <div class="col">
                            <input id="giftcard" type="text" class="form-control" placeholder="شماره کارت هدیه را وارد کنید و روی اعمال کلیک کنید">
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn me-auto" data-bs-dismiss="modal">لغو</button>
                    <button id="apply-giftcard"
                            type="button" class="btn btn-primary" data-bs-dismiss="modal">اعمال</button>
                </div>
            </div>
        </div>
    </div>

    <div class="modal modal-blur fade" id="active-perfectvoucher-dialog" tabindex="-1" role="dialog" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered modal-dialog-scrollable" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">استفاده از وچر پرفکت مانی</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <div class="form-group mb-3 row">
                        <a>"کد وچر و کد فعال ساز را وارد و روی اعمال کلیک کنید"</a>
                        <div class="col">
                            <input id="ev_number" type="text" class="form-control" placeholder="کد وچر را وارد کنید">
                            <input id="ev_code" type="text" class="form-control" placeholder=" کد فعال ساز را وارد کنید">
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn me-auto" data-bs-dismiss="modal">لغو</button>
                    <button id="active-voucher"
                            type="button" class="btn btn-primary" data-bs-dismiss="modal">اعمال</button>
                </div>
            </div>
        </div>
    </div>

    <script>
        $("#apply-giftcard").click(function() {
            $.ajax({
                url: '/user/giftcard',
                type: 'POST',
                dataType: "json",
                data: {
                    giftcard: $('#giftcard').val(),
                },
                success: function(data) {
                    if (data.ret === 1) {
                        $('#success-message').text(data.msg);
                        $('#success-dialog').modal('show');
                    } else {
                        $('#fail-message').text(data.msg);
                        $('#fail-dialog').modal('show');
                    }
                }
            })
        });
        $("#active-voucher").click(function() {
            $.ajax({
                url: '/user/perfectvoucher',
                type: 'POST',
                dataType: "json",
                data: {
                    giftcard: $('#ev_number').val(),
                    giftcard: $('#ev_code').val(),
                },
                success: function(data) {
                    if (data.ret === 1) {
                        $('#success-message').text(data.msg);
                        $('#success-dialog').modal('show');
                    } else {
                        $('#fail-message').text(data.msg);
                        $('#fail-dialog').modal('show');
                    }
                }
            })
        });
    </script>

{include file='user/footer.tpl'}