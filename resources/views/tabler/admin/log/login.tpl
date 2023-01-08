{include file='admin/tabler_header.tpl'}

<div class="page-wrapper">
    <div class="container-xl">
        <div class="page-header d-print-none text-white">
            <div class="row align-items-center">
                <div class="col">
                    <h2 class="page-title">
                        <span class="home-title">IP ورود</span>
                    </h2>
                    <div class="page-pretitle my-3">
                        <span class="home-subtitle">مشاهده سابقه ورود به حساب کاربری</span>
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
            "serverSide": true,
            "searching": false,
            "ordering": false,
            ajax: {
                url: '/admin/login/ajax',
                type: 'POST',
                dataSrc: 'logins.data'
            },
            "autoWidth":false,
            'iDisplayLength': 10,
            'scrollX': true,
            'order': [
                [0, 'desc']
            ],
            columns: [
                {foreach $details['field'] as $key => $value}
                { data: '{$key}' },
                {/foreach}
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

        loadTable();
    </script>

{include file='admin/tabler_footer.tpl'}
