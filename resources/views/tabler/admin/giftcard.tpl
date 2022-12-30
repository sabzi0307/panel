{include file='admin/tabler_header.tpl'}

<div class="page-wrapper">
    <div class="container-xl">
        <div class="page-header d-print-none text-white">
            <div class="row align-items-center">
                <div class="col">
                    <h2 class="page-title">
                        <span class="home-title my-3">کارت هدیه</span>
                    </h2>
                    <div class="page-pretitle">
                        <span class="home-subtitle">
                            کارت های هدیه را مشاهده و مدیریت کنید
                        </span>
                    </div>
                </div>
                <div class="col-auto ms-auto d-print-none">
                    <div class="btn-list">
                        <a href="#" class="btn btn-primary d-none d-sm-inline-block" data-bs-toggle="modal"
                            data-bs-target="#create-dialog">
                            <i class="icon ti ti-plus"></i>
                            ايجاد كردن
                        </a>
                        <a href="#" class="btn btn-primary d-sm-none btn-icon" data-bs-toggle="modal"
                            data-bs-target="#create-dialog">
                            <i class="icon ti ti-plus"></i>
                        </a>
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
                            <table id="data_table" class="table card-table table-vcenter text-nowrap datatable">
                                <thead>
                                    <tr>
                                        {foreach $details['field'] as $key => $value}
                                            <th>{$value}</th>
                                        {/foreach}
                                    </tr>
                                </thead>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="modal modal-blur fade" id="create-dialog" tabindex="-1" role="dialog" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered modal-dialog-scrollable" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">محتوای کارت هدیه</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    {foreach $details['create_dialog'] as $detail}
                        {if $detail['type'] == 'input'}
                            <div class="form-group mb-3 row">
                                <label class="form-label col-3 col-form-label">{$detail['info']}</label>
                                <div class="col">
                                    <input id="{$detail['id']}" type="text" class="form-control"
                                        placeholder="{$detail['placeholder']}">
                                </div>
                            </div>
                        {/if}
                        {if $detail['type'] == 'textarea'}
                            <div class="form-group mb-3 row">
                                <label class="form-label col-3 col-form-label">{$detail['info']}</label>
                                <textarea id="{$detail['id']}" class="col form-control" rows="{$detail['rows']}"
                                    placeholder="{$detail['placeholder']}"></textarea>
                            </div>
                        {/if}
                        {if $detail['type'] == 'select'}
                            <div class="form-group mb-3 row">
                                <label class="form-label col-3 col-form-label">{$detail['info']}</label>
                                <div class="col">
                                    <select id="{$detail['id']}" class="col form-select">
                                        {foreach $detail['select'] as $key => $value}
                                            <option value="{$key}">{$value}</option>
                                        {/foreach}
                                    </select>
                                </div>
                            </div>
                        {/if}
                    {/foreach}
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn me-auto" data-bs-dismiss="modal">لغو</button>
                    <button id="create-button" onclick="createGiftCard()"
                        type="button" class="btn btn-primary" data-bs-dismiss="modal">ايجاد كردن</button>
                </div>
            </div>
        </div>
    </div>

    <script>
        var table = $('#data_table').DataTable({
            ajax: {
                url: '/admin/giftcard/ajax',
                type: 'POST',
                dataSrc: 'giftcards'
            },
            "autoWidth":false,
            'iDisplayLength': 10,
            'scrollX': true,
            'order': [
                [1, 'desc']
            ],
            columns: [
                {foreach $details['field'] as $key => $value}
                { data: '{$key}' },
                {/foreach}
            ],
            "columnDefs":[
                { targets:[0],orderable:false }
            ],
            "dom": "<'row px-3 py-3'<'col-sm-12 col-md-6'l><'col-sm-12 col-md-6'f>>" +
                "<'row'<'col-sm-12'tr>>" +
                "<'row card-footer d-flex d-flexalign-items-center'<'col-sm-12 col-md-5'i><'col-sm-12 col-md-7'p>>",
            language: {
                "sProcessing": "در حال پردازش...",
                "sLengthMenu": "نمایش موارد _MENU_",
                "sZeroRecords": "نتایج منطبقی وجود ندارد",
                "sInfo": "نتایج _START_ تا _END_ از _TOTAL_",
                "sInfoEmpty": "نتایج 0 تا 0 از 0",
                "sInfoFiltered": "(در _MAX_ مورد پیدا کنید)",
                "sInfoPostFix": "",
                "sSearch": "<i class=\"ti ti-search\"></i> ",
                "sUrl": "",
                "sEmptyTable": "داده های جدول خالی است",
                "sLoadingRecords": "بارگذاری...",
                "sInfoThousands": ",",
                "oPaginate": {
                    "sFirst": "صفحه اول",
                    "sPrevious": "<i class=\"titi-arrow-left\"></i>",
                    "sNext": "<i class=\"ti ti-arrow-right\"><i>",
                    "sLast": "آخرین صفحه"
                },
                "oAria": {
                    "sSortAscending": ": این ستون را به ترتیب صعودی مرتب کنید",
                    "sSortDescending": ": این ستون را به ترتیب نزولی مرتب کنید"
                }
            },
        });

        function loadTable() {
            table;
        }

        function createGiftCard() {
            $.ajax({
                url: '/admin/giftcard',
                type: 'POST',
                dataType: "json",
                data: {
                    {foreach $details['create_dialog'] as $detail}
                        {$detail['id']}: $('#{$detail['id']}').val(),
                    {/foreach}
                },
                success: function(data) {
                    if (data.ret == 1) {
                        $('#success-message').text(data.msg);
                        $('#success-dialog').modal('show');
                        reloadTableAjax();
                    } else {
                        $('#fail-message').text(data.msg);
                        $('#fail-dialog').modal('show');
                    }
                }
            })
        };

        function deleteGiftCard(giftcard_id) {
            $('#notice-message').text('از حذف این کارت هدیه اطمینان دارید？');
            $('#notice-dialog').modal('show');
            $('#notice-confirm').on('click', function() {
                $.ajax({
                    url: "/admin/giftcard/" + giftcard_id,
                    type: 'DELETE',
                    dataType: "json",
                    success: function(data) {
                        if (data.ret == 1) {
                            $('#success-message').text(data.msg);
                            $('#success-dialog').modal('show');
                            reloadTableAjax();
                        } else {
                            $('#fail-message').text(data.msg);
                            $('#fail-dialog').modal('show');
                        }
                    }
                })
            });
        };

        function reloadTableAjax() {
            table.ajax.reload(null, false);
        }

        loadTable();
    </script>

{include file='admin/tabler_footer.tpl'}
