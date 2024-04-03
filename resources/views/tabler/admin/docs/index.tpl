{include file='admin/header.tpl'}

<div class="page-wrapper">
    <div class="container-xl">
        <div class="page-header d-print-none text-white">
            <div class="row align-items-center">
                <div class="col">
                    <h2 class="page-title">
                        <span class="home-title">مدیریت دانشنامه</span>
                    </h2>
                    <div class="page-pretitle my-3">
                        <span class="home-subtitle">مطالب را مشاهده و مدیریت کنید</span>
                    </div>
                </div>
                <div class="col-auto ms-auto d-print-none">
                    <div class="btn-list">
                        <a href="/admin/docs/create" class="btn btn-primary">
                            <i class="icon ti ti-plus"></i>
                            ايجاد كردن
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

    {include file='datatable.tpl'}

    <script>
        tableConfig.ajax = {
            url: '/admin/docs/ajax',
            type: 'POST',
            dataSrc: 'docs'
        };
        tableConfig.order = [
            [1, 'asc']
        ];
        tableConfig.columnDefs = [
            {
                targets: [0],
                orderable: false
            }
        ];

        let table = new DataTable('#data-table', tableConfig);

        function loadTable() {
            table;
        }

        function deleteDoc(doc_id) {
            $('#notice-message').text('آیا مطمئنید که می‌خواهید این سند را حذف کنید؟');
            $('#notice-dialog').modal('show');
            $('#notice-confirm').off('click').on('click', function () {
                $.ajax({
                    url: "/admin/docs/" + doc_id,
                    type: 'DELETE',
                    dataType: "json",
                    success: function (data) {
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
