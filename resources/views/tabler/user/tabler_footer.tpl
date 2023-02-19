<div class="modal modal-blur fade" id="success-dialog" tabindex="-1" role="dialog" aria-hidden="true">
    <div class="modal-dialog modal-sm modal-dialog-centered" role="document">
        <div class="modal-content">
            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            <div class="modal-status bg-success"></div>
            <div class="modal-body text-center py-4">
                <i class="ti ti-circle-check icon mb-2 text-green icon-lg" style="font-size:3.5rem;"></i>
                <p id="success-message" class="text-muted">موفقیت</p>
            </div>
            <div class="modal-footer">
                <div class="w-100">
                    <div class="row">
                        <div class="col">
                            <a id="success-confirm" href="" class="btn w-100" data-bs-dismiss="modal">
                                好
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<div class="modal modal-blur fade" id="fail-dialog" tabindex="-1" role="dialog" aria-hidden="true">
    <div class="modal-dialog modal-sm modal-dialog-centered" role="document">
        <div class="modal-content">
            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            <div class="modal-status bg-danger"></div>
            <div class="modal-body text-center py-4">
                <i class="ti ti-circle-x icon mb-2 text-danger icon-lg" style="font-size:3.5rem;"></i>
                <p id="fail-message" class="text-muted">شکست</p>
            </div>
            <div class="modal-footer">
                <div class="w-100">
                    <div class="row">
                        <div class="col">
                            <a href="" class="btn btn-danger w-100" data-bs-dismiss="modal">
                                تایید
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<footer class="footer footer-transparent d-print-none">
    <div class="container-xl">
        <div class="row text-center align-items-center flex-row-reverse">
            <div class="col-lg-auto ms-lg-auto">
                <ul class="list-inline list-inline-dots mb-0">
                    <li class="list-inline-item">
                        <a href="/staff" class="link-secondary">Powered by SSPanel-UIM</a>
                        <!-- حذف کارکنان یک عمل بی احترامی برای هر توسعه دهنده است -->
                    </li>
                </ul>
            </div>
        </div>
    </div>
</footer>
</div>
</div>
<!-- js -->
<script>
    $("#switch_theme_mode").click(function() {
        $.ajax({
            type: "POST",
            url: "/user/switch_theme_mode",
            dataType: "json",
            success: function(data) {
                if (data.ret == 1) {
                    $('#success-message').text(data.msg);
                    $('#success-dialog').modal('show');
                    window.setTimeout("location.reload()", {$config['jump_delay']});
                } else {
                    $('#fail-message').text(data.msg);
                    $('#fail-dialog').modal('show');
                }
            }
        })
    });
</script>
<script src="//cdn.jsdelivr.net/npm/@tabler/core@latest/dist/js/tabler.min.js"></script>
<script>console.table([['استعلام پایگاه داده', 'زمان اجرا'], ['{count($queryLog)} درجه دوم', '{$optTime} ms']])</script>

{include file='live_chat.tpl'}

</body>

</html>