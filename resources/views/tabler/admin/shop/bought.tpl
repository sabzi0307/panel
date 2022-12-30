{include file='admin/main.tpl'}

<main class="content">
    <div class="content-header ui-content-header">
        <div class="container">
            <h1 class="content-heading">سابقه خرید</h1>
        </div>
    </div>
    <div class="container">
        <div class="col-lg-12 col-sm-12">
            <section class="content-inner margin-top-no">
                <div class="card">
                    <div class="card-main">
                        <div class="card-inner">
                            <p>کلیه سوابق خرید در سیستم.</p>
                            <p>نمایش ورودی ها:
                                {include file='table/checkbox.tpl'}
                            </p>
                        </div>
                    </div>
                </div>
                <div class="table-responsive">
                    {include file='table/table.tpl'}
                </div>
                <div aria-hidden="true" class="modal modal-va-middle fade" id="delete_modal" role="dialog"
                     tabindex="-1">
                    <div class="modal-dialog modal-xs">
                        <div class="modal-content">
                            <div class="modal-heading">
                                <a class="modal-close" data-dismiss="modal">×</a>
                                <h2 class="modal-title">آیا مطمئن هستید که می خواهید اشتراک خود را لغو کنید؟</h2>
                            </div>
                            <div class="modal-inner">
                                <p>لطفا تایید کنید.</p>
                            </div>
                            <div class="modal-footer">
                                <p class="text-right">
                                    <button class="btn btn-flat btn-brand-accent waves-attach waves-effect"
                                            data-dismiss="modal" type="button">لغو کنید
                                    </button>
                                    <button class="btn btn-flat btn-brand-accent waves-attach" data-dismiss="modal"
                                            id="delete_input" type="button">مطمئن
                                    </button>
                                </p>
                            </div>
                        </div>
                    </div>
                </div>
                {include file='dialog.tpl'}
        </div>
    </div>
</main>

{include file='admin/footer.tpl'}

<script>
    function delete_modal_show(id) {
        deleteid = id;
        $("#delete_modal").modal();
    }
    {include file='table/js_1.tpl'}
    window.addEventListener('load', () => {
        {include file='table/js_2.tpl'}
        function delete_id() {
            $.ajax({
                type: "DELETE",
                url: "/admin/bought",
                dataType: "json",
                data: {
                    id: deleteid
                },
                success: data => {
                    if (data.ret) {
                        $("#result").modal();
                        $$.getElementById('msg').innerHTML = data.msg;
                        $$.getElementById(`row_delete_${ldelim}deleteid{rdelim}`).setAttribute('disabled', 'true')
                    } else {
                        $("#result").modal();
                        $$.getElementById('msg').innerHTML = data.msg;
                    }
                },
                error: jqXHR => {
                    $("#result").modal();
                    $$.getElementById('msg').innerHTML = `${ldelim}data.msg{rdelim} مشکلی پیش آمده`;
                }
            });
        }
        $$.getElementById('delete_input').addEventListener('click', delete_id);
    })
</script>
