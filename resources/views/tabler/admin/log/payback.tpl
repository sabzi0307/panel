{include file='admin/header.tpl'}

<div class="page-wrapper">
    <div class="container-xl">
        <div class="page-header d-print-none text-white">
            <div class="row align-items-center">
                <div class="col">
                    <h2 class="page-title">
                        <span class="home-title">سابقه بازپرداخت</span>
                    </h2>
                    <div class="page-pretitle my-3">
                        <span class="home-subtitle">مشاهده سابقه بازپرداخت کاربران</span>
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
                            <table id="data-table" class="table card-table table-vcenter text-nowrap datatable">
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
        let table = new DataTable('#data-table', {
            ajax: {
                url: '/admin/payback/ajax',
                type: 'POST',
                dataSrc: 'paybacks'
            },
            "autoWidth": false,
            'iDisplayLength': 10,
            'scrollX': true,
            'order': [
                [0, 'desc']
            ],
            columns: [
                {foreach $details['field'] as $key => $value}
                {
                    data: '{$key}'
                },
                {/foreach}
            ],
            "dom": "<'row px-3 py-3'<'col-sm-12 col-md-6'l><'col-sm-12 col-md-6'f>>" +
                "<'row'<'col-sm-12'tr>>" +
                "<'row card-footer d-flex align-items-center'<'col-sm-12 col-md-5'i><'col-sm-12 col-md-7'p>>",
            language: {
                "sProcessing": "در حال پردازش...",
                "sLengthMenu": "نمایش _MENU_ ردیف",
                "sZeroRecords": "رکوردی با این مشخصات پیدا نشد",
                "sInfo": "نمایش _START_ تا _END_ از _TOTAL_ رکورد",
                "sInfoEmpty": "نمایش 0 تا 0 از 0 رکورد",
                "sInfoFiltered": "(فیلتر شده از مجموع _MAX_ رکورد)",
                "sInfoPostFix": "",
                "sSearch": "<i class=\"ti ti-search\"></i> ",
                "sUrl": "",
                "sEmptyTable": "جدول خالی است",
                "sLoadingRecords": "در حال بارگذاری...",
                "sInfoThousands": ",",
                "oPaginate": {
                    "sFirst": "ابتدا",
                    "sPrevious": "<i class=\"ti ti-arrow-left\"></i>",
                    "sNext": "<i class=\"ti ti-arrow-right\"></i>",
                    "sLast": "انتها"
                },
                "oAria": {
                    "sSortAscending": ": فعال سازی مرتب سازی صعودی",
                    "sSortDescending": ": فعال سازی مرتب سازی نزولی"
                }
            }
        });

        function loadTable() {
            table;
        }

        loadTable();
    </script>

    {include file='admin/footer.tpl'}
