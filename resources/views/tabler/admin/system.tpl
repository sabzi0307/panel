{include file='admin/header.tpl'}

<div class="page-wrapper">
    <div class="container-xl">
        <div class="page-header d-print-none text-white">
            <div class="row align-items-center">
                <div class="col">
                    <h2 class="page-title">
                        <span class="home-title">وضعیت سیستم</span>
                    </h2>
                    <div class="page-pretitle my-3">
                        <span class="home-subtitle">وضعیت کارکرد سیستم را بررسی کنید</span>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div class="page-body">
        <div class="container-xl">
            <div class="row row-deck row-cards">
                <div class="col-sm-12 col-lg-12">
                    <div class="card">
                        <div class="card-body">
                            <table class="table table-transparent table-responsive">
                                <tr>
                                    <td>نسخه پنل</td>
                                    <td class="text-end" id="version"><a href="#" id="version_check">{$version} </a>
                                    </td>
                                </tr>
                                <tr>
                                    <td>نسخه پایگاه داده</td>
                                    <td class="text-end">{$db_version}</td>
                                </tr>
                                <tr>
                                    <td>آخرین زمان اجرای کار روزانه</td>
                                    <td class="text-end">{$last_daily_job_time}</td>
                                </tr>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script>
        $('#version_check').click(function () {
            $.ajax({
                url: '/admin/system/check_update',
                type: 'POST',
                dataType: "json",
                success: function (data) {
                    if (data.is_upto_date === true) {
                        $('.badge').remove();
                        $('#version').append('<span class="badge bg-green">در حال حاضر آخرین نسخه</span>');
                    } else {
                        $('.badge').remove();
                        $('#version').append('<span class="badge bg-red">نسخه جدید در دسترس است ' + data.latest_version + ' در دسترس</span>');
                    }
                }
            })
        });
    </script>

    {include file='admin/footer.tpl'}
