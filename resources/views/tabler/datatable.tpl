<link href="//cdn.datatables.net/v/bs5/dt-2.0.3/datatables.min.css" rel="stylesheet"/>
<script src="//cdn.datatables.net/v/bs5/dt-2.0.3/datatables.min.js"></script>

<script>
    let tableConfig = {
        autoWidth: false,
        iDisplayLength: 10,
        scrollX: true,
        columns: [
            {foreach $details['field'] as $key => $value}
            {
                data: '{$key}'
            },
            {/foreach}
        ],
        initComplete: function () {
            let tableHeader = $('div.dt-length').parent().parent()
            let tableBody = $('div.dt-scroll').parent().parent()
            let tableFooter = $('div.dt-info').parent().parent()
            let length = $('div.dt-length').parent()
            let search = $('div.dt-search').parent()
            let info = $('div.dt-info').parent()
            let paging = $('div.dt-paging').parent()

            tableHeader.removeClass('mt-2').addClass('row px-3 py-3')
            tableBody.removeClass('mt-2')
            tableFooter.removeClass('mt-2').addClass('row card-footer')
            length.removeClass('col-md-auto me-auto').addClass('col-auto')
            search.removeClass('col-md-auto me-auto ms-auto').addClass('col-auto')
            info.removeClass('col-md-auto me-auto').addClass('col')
            paging.removeClass('col-md-auto me-auto ms-auto').addClass('col-auto')

            $('div.dt-scroll-body').css('border-bottom-style', 'none')
        },
        language: {
            "sProcessing": "در حال پردازش...",
            "sLengthMenu": "نمایش موارد _MENU_",
            "sZeroRecords": "نتایج منطبقی وجود ندارد",
            "sInfo": "نتایج _START_ تا _END_ از _TOTAL_ هیچ نتیجه مطابقی ندارد",
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
                "sPrevious": "<i class=\"ti ti-arrow-left\"></i>",
                "sNext": "<i class=\"ti ti-arrow-right\"></i>",
                "sLast": "آخرین صفحه"
            },
            "oAria": {
                "sSortAscending": ": این ستون را به ترتیب صعودی مرتب کنید",
                "sSortDescending": ": این ستون را به ترتیب نزولی مرتب کنید"
            }
        }
    };
</script>
