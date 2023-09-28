{include file='user/header.tpl'}

<link href="//cdn.datatables.net/v/bs5/dt-1.13.5/datatables.min.css" rel="stylesheet" />
<script src="//cdn.datatables.net/v/bs5/dt-1.13.5/datatables.min.js"></script>

<div class="page-wrapper">
    <div class="container-xl">       
        <div class="page-header d-print-none text-white">
            <div class="row align-items-center">
                <div class="col">                   
                    <h2 class="page-title">
                        <span class="home-title my-3">لیست صورت حساب ها</span>
                    </h2>
                    <div class="page-pretitle">
                        <span class="home-subtitle">لیست صورتحساب ها را اینجا ببینید</span>
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
                url: '/user/invoice/ajax',
                type: 'POST',
                dataSrc: 'invoices'
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
                "sLengthMenu": "نمایش ورودی های _MENU_",
                "sZeroRecords": "هیچ نتیجه منطبقی وجود ندارد",
                "sInfo": "نتایج _START_ تا _END_ از _TOTAL_",
                "sInfoEmpty": "نتایج 0 تا 0 از 0",
                "sInfoFiltered": "(به دنبال _MAX_ مورد بگردید)",
                "sInfoPostFix": "",
                "sSearch": "<i class=\"ti ti-search\"></i> ",
                "sUrl": "",
                "sEmptyTable": "اطلاعات جدول خالی است",
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

        function reloadTableAjax() {
            table.ajax.reload(null, false);
        }

        loadTable();
    </script>

{include file='user/footer.tpl'}