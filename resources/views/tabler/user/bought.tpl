{include file='user/main.tpl'}

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
                            <p>سابقه خرید شما در سیستم</p>
                        </div>
                    </div>
                </div>
                <div class="card">
                    <div class="card-main">
                        <div class="card-inner">
                            <div class="card-table">
                                <div class="table-responsive table-user">
                                    {$render}
                                    <table class="table">
                                        <tr>
                                            <th>ID</th>
                                            <th>زمان خرید</th>
                                            <th>نام محصول</th>
                                            <th>محتوا</th>
                                            <th>قیمت</th>
                                            <th>زمان تمدید</th>
                                            <th>در هنگام تمدید، ترافیک را بازنشانی کنید</th>
                                            <th>عمل کنند</th>
                                        </tr>
                                        {foreach $shops as $shop}
                                            <tr>
                                                <td>#{$shop->id}</td>
                                                <td>{$shop->datetime()}</td>
                                                <td>{$shop->shop()->name}</td>
                                                <td>{$shop->shop()->content()}</td>
                                                <td>{$shop->price} 元</td>
                                                <td>{$shop->renew()}</td>
                                                <td>{$shop->autoResetBandwidthString()}</td>
                                                <td>
                                                    <a class="btn btn-brand"
                                                       {if $shop->renew==0}disabled{else}href="javascript:void(0);" onClick="delete_modal_show('{$shop->id}')"{/if}>关闭自动续费</a>
                                                </td>
                                            </tr>
                                        {/foreach}
                                    </table>
                                    {$render}
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div aria-hidden="true" class="modal modal-va-middle fade" id="delete_modal" role="dialog"
                     tabindex="-1">
                    <div class="modal-dialog modal-xs">
                        <div class="modal-content">
                            <div class="modal-heading">
                                <a class="modal-close" data-dismiss="modal">×</a>
                                <h2 class="modal-title">آیا مطمئن هستید که می خواهید تمدید خودکار را خاموش کنید؟</h2>
                            </div>
                            <div class="modal-inner">
                                <p>لطفا تایید کنید.</p>
                            </div>
                            <div class="modal-footer">
                                <p class="text-right">
                                    <button class="btn btn-flat btn-brand-accent waves-attach waves-effect"
                                            data-dismiss="modal" type="button">
                                        لغو کنید
                                    </button>
                                    <button class="btn btn-flat btn-brand-accent waves-attach" data-dismiss="modal"
                                            id="delete_input" type="button">
                                        حتما
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

{include file='user/footer.tpl'}

<script>
    function delete_modal_show(id) {
        $("#delete_modal").modal();
        document.getElementById('delete_input').setAttribute('data-id', id);
    }
    $(document).ready(function () {
        function delete_id(id) {
            $.ajax({
                type: "DELETE",
                url: "/user/bought",
                dataType: "json",
                data: {
                    id
                },
                success: (data) => {
                    if (data.ret) {
                        $("#result").modal();
                        $$.getElementById('msg').innerHTML = data.msg;
                        window.setTimeout("location.href=window.location.href", {$config['jump_delay']});
                    } else {
                        $("#result").modal();
                        $$.getElementById('msg').innerHTML = data.msg;
                    }
                },
                error: (jqXHR) => {
                    $("#result").modal();
                    $$.getElementById('msg').innerHTML = `${
                            data.msg
                            } مشکلی پیش آمده`;
                }
            });
        }
        $$.getElementById('delete_input').addEventListener('click', () => {
            delete_id($$.getElementById('delete_input').getAttribute('data-id'));
        });
    })
</script>
