{include file='user/header.tpl'}

<div class="page-wrapper">
    <div class="container-xl">
        <div class="page-header d-print-none text-white">
            <div class="row align-items-center">
                <div class="col">
                    <h2 class="page-title">
                        <span class="home-title">استریم های مسدود</span>
                    </h2>
                    <div class="page-pretitle my-3">
                        <span class="home-subtitle">در اینجا می توانید رفع انسداد جریان سرور را بررسی کنید</span>
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
                        
                    </div>
                </div>
            </div>
        </div>
    </div>
    <script>
                                                    var jqxhrc = jQuery.ajax("https://check.shecan.ir/?" + Math.random()).done(function() {
                                                        jQuery('#message').html('<i class="fas fa-check-circle fa-fw"></i> تبریک! شما در حال استفاده از شکن هستید').addClass('shecan-result success');
                                                        var jqxhrf = jQuery.ajax("https://fail.shecan.ir/?" + Math.random()).done(function() {
                                                            jQuery('#message').html('<i class="fas fa-info-circle fa-fw"></i>هشدار! شما علاوه بر شکن، از DNS دیگه‌ای استفاده می‌کنید که ممکنه مشکل‌ساز بشه!').addClass('shecan-result warning').removeClass('success');
                                                        }).fail(function() {}).always(function() {});
                                                    }).fail(function() {
                                                        jQuery('#message').html('<i class="fas fa-exclamation-circle fa-fw"></i>شکن برای شما فعال نیست! اگر تنظیمات را انجام داده‌اید، بخش <a href="https://shecan.ir/faq/">پرسش‌های پرتکرار</a> را به دقت مطالعه کنید').addClass('shecan-result warning').removeClass('success');
                                                    }).always(function() {});
                                                </script>
    
{include file='user/footer.tpl'}