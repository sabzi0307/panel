{include file='admin/header.tpl'}

<div class="page-wrapper">
    <div class="container-xl">
        <div class="page-header d-print-none text-white">
            <div class="row align-items-center">
                <div class="col">
                    <h2 class="page-title">
                        <span class="home-title">فهرست کاربران</span>
                    </h2>
                    <div class="page-pretitle my-3">
                        <span class="home-subtitle">
                            لیست تمامی کاربران سیستم
                        </span>
                    </div>
                </div>
                <div class="col-auto">
                    <div class="btn-list">
                        <button href="#" class="btn btn-primary" data-bs-toggle="modal"
                            data-bs-target="#create-dialog">
                            <i class="icon ti ti-plus"></i>
                            افزودن
                        </button>
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
                    <h5 class="modal-title"> افزودن کاربر جدید</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    {foreach $details['create_dialog'] as $from}
                        {if $from['type'] === 'input'}
                            <div class="form-group mb-3 row">
                                <label class="form-label col-3 col-form-label">{$from['info']}</label>
                                <div class="col">
                                    <input id="{$from['id']}" type="text" class="form-control"
                                        placeholder="{$from['placeholder']}">
                                </div>
                            </div>
                        {/if}
                        {if $from['type'] === 'textarea'}
                            <div class="form-group mb-3 row">
                                <label class="form-label col-3 col-form-label">{$from['info']}</label>
                                <textarea id="{$from['id']}" class="col form-control" rows="{$from['rows']}"
                                    placeholder="{$from['placeholder']}"></textarea>
                            </div>
                        {/if}
                        {if $from['type'] === 'select'}
                            <div class="form-group mb-3 row">
                                <label class="form-label col-3 col-form-label">{$from['info']}</label>
                                <div class="col">
                                    <select id="{$from['id']}" class="col form-select">
                                        {foreach $from['select'] as $key => $value}
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
                    <button id="create-button" type="button" class="btn btn-primary" data-bs-dismiss="modal">افزودن کاربر</button>
                </div>
            </div>
        </div>
    </div>

    <script>
        var table = $('#data_table').DataTable({
            ajax: {
                url: '/admin/user/ajax',
                type: 'POST',
                dataSrc: 'users'
            },
            "autoWidth":false,
            'iDisplayLength': 10,
            'scrollX': true,
            'order': [
                [1, 'asc']
            ],
            columns: [
                {foreach $details['field'] as $key => $value}
                { data: '{$key}' },
                {/foreach}
            ],
            "columnDefs":[
                { targets:[0],orderable:false },
            ],
            "dom": "<'row px-3 py-3'<'col-sm-12 col-md-6'l><'col-sm-12 col-md-6'f>>" +
                "<'row'<'col-sm-12'tr>>" +
                "<'row card-footer d-flex align-items-center'<'col-sm-12 col-md-5'i><'col-sm-12 col-md-7'p>>",
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
                "sEmptyTable": "هیچ داده ای یافت نشد",
                "sLoadingRecords": "بارگذاری...",
                "sInfoThousands": ",",
                "oPaginate": {
                    "sFirst": "صفحه اول",
                    "sPrevious": "<i class=\"ti ti-arrow-left\"></i>",
                    "sNext": "<i class=\"ti ti-arrow-right\"></i>",
                    "sLast": "آخرین صفحه"
                },
                "oAria": {
                    "sSortAscending": ": این ستون را به ترتیب صعودی مرتب کنید",
                    "sSortDescending": ": این ستون را به ترتیب نزولی مرتب کنید"
                }
            }
        });

        function loadTable() {
            table;
        }

        $("#create-button").click(function() {
            $.ajax({
                type: "POST",
                url: "/admin/user/create",
                dataType: "json",
                data: {
                    {foreach $details['create_dialog'] as $from}
                        {$from['id']}: $('#{$from['id']}').val(),
                    {/foreach}
                },
                success: function(data) {
                    if (data.ret === 1) {
                        $('#success-noreload-message').text(data.msg);
                        $('#success-noreload-dialog').modal('show');
                        reloadTableAjax();
                    } else {
                        $('#fail-message').text(data.msg);
                        $('#fail-dialog').modal('show');
                    }
                }
            })
        });

        function deleteUser(user_id) {
            $('#notice-message').text('حذف این کاربر را تأیید میکنید？');
            $('#notice-dialog').modal('show');
            $('#notice-confirm').off('click').on('click', function() {
                $.ajax({
                    url: "/admin/user/" + user_id,
                    type: 'DELETE',
                    dataType: "json",
                    success: function(data) {
                        if (data.ret === 1) {
                            $('#success-noreload-message').text(data.msg);
                            $('#success-noreload-dialog').modal('show');
                            reloadTableAjax();
                        } else {
                            $('#fail-message').text(data.msg);
                            $('#fail-dialog').modal('show');
                        }
                    }
                })
            });
        }

        function reloadTableAjax() {
            table.ajax.reload(null, false);
        }

        loadTable();
    </script>

{include file='admin/footer.tpl'}