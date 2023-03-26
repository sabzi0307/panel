{include file='admin/tabler_header.tpl'}

<div class="page-wrapper">
    <div class="container-xl">
        <div class="page-header d-print-none text-white">
            <div class="row align-items-center">
                <div class="col">
                    <h2 class="page-title">
                        <span class="home-title">لیست تیکت ها</span>
                    </h2>
                    <div class="page-pretitle my-3">
                        <span class="home-subtitle">تیکت های کاربر را مشاهده کرده و به آنها پاسخ دهید</span>
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

    <script>
        var table = $('#data_table').DataTable({
            ajax: {
                url: '/admin/ticket/ajax',
                type: 'POST',
                dataSrc: 'tickets'
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
                "sInfoFiltered": "(به دنبال _MAX_ مورد بگردید)",
                "sInfoPostFix": "",
                "sSearch": "<i class=\"ti ti-search\"></i> ",
                "sUrl": "",
                "sEmptyTable": "هیچ داده ای یافت نشد",
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

        function closeTicket(ticket_id) {
            $('#notice-message').text('باشه برای بستن این تیکت？');
            $('#notice-dialog').modal('show');
            $('#notice-confirm').on('click', function () {
                $.ajax({
                    url: "/admin/ticket/" + ticket_id + '/close',
                    type: 'PUT',
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
                });
            });
        }

        function deleteTicket(ticket_id) {
            $('#notice-message').text('آیا مطمئن هستید که می خواهید این تیکت را حذف کنید؟');
            $('#notice-dialog').modal('show');
            $('#notice-confirm').on('click', function() {
                $.ajax({
                    url: "/admin/ticket/" + ticket_id,
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
        }

        function reloadTableAjax() {
            table.ajax.reload(null, false);
        }

        loadTable();
    </script>

{include file='admin/tabler_footer.tpl'}