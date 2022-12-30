{include file='admin/main.tpl'}

<main class="content">
    <div class="content-header ui-content-header">
        <div class="container">
            <h1 class="content-heading">مرکز تنظیمات</h1>
        </div>
    </div>

    <div class="container">
        <div class="col-xx-12 col-sm-12">
            <div class="card quickadd">
                <div class="card-main">
                    <div class="card-inner">
                        <nav class="tab-nav margin-top-no">
                            <ul class="nav nav-list">
                                <li class="active">
                                    <a data-toggle="tab" href="#payment_settings"><i class="mdi mdi-credit-card-outline icon-lg"></i>&nbsp;پرداخت</a>
                                </li>
                                <li>
                                    <a data-toggle="tab" href="#mail_settings"><i class="mdi mdi-email icon-lg"></i>&nbsp;پست الکترونیکی</a>
                                </li>
                                <li>
                                    <a data-toggle="tab" href="#customer_service_system_settings"><i class="mdi mdi-face-agent icon-lg"></i>&nbsp;امور مشتریان</a>
                                </li>
                                <li>
                                    <a data-toggle="tab" href="#verification_code_settings"><i class="mdi mdi-shield-check icon-lg"></i>&nbsp;کد تایید</a>
                                </li>
                                <li>
                                    <a data-toggle="tab" href="#registration_settings"><i class="mdi mdi-account-plus icon-lg"></i>&nbsp;ثبت نام</a>
                                </li>
                                <li>
                                    <a data-toggle="tab" href="#invitation_settings"><i class="mdi mdi-account-multiple-plus icon-lg"></i>&nbsp;دعوت</a>
                                </li>
                                <li>
                                    <a data-toggle="tab" href="#telegram_settings"><i class="mdi mdi-send-circle icon-lg"></i>&nbsp;تلگرام</a>
                                </li>
                            </ul>
                        </nav>
                                
                        <div class="card-inner">
                           <div class="tab-content">
                                <div class="tab-pane fade" id="mail_settings">
                                    <nav class="tab-nav margin-top-no">
                                        <ul class="nav nav-list">
                                            <li class="active">
                                                <a data-toggle="tab" href="#email_auth_settings">&nbsp;راه اندازی</a>
                                            </li>
                                            <li>
                                                <a data-toggle="tab" href="#smtp">&nbsp;smtp</a>
                                            </li>
                                            <li>
                                                <a data-toggle="tab" href="#sendgrid">&nbsp;sendgrid</a>
                                            </li>
                                            <li>
                                                <a data-toggle="tab" href="#mailgun">&nbsp;mailgun</a>
                                            </li>
                                            <li>
                                                <a data-toggle="tab" href="#ses">&nbsp;ses</a>
                                            </li>
                                        </ul>
                                    </nav>
                                            
                                    <div class="tab-pane fade active in" id="email_auth_settings">
                                        <!-- mail_driver -->
                                        <div class="form-group form-group-label">
                                            <label class="floating-label">سرویس پستی</label>
                                            <select id="mail_driver" class="form-control maxwidth-edit">
                                                <option value="none" {if $settings['mail_driver'] == "none"}selected{/if}>none</option>
                                                <option value="mailgun" {if $settings['mail_driver'] == "mailgun"}selected{/if}>mailgun</option>
                                                <option value="sendgrid" {if $settings['mail_driver'] == "sendgrid"}selected{/if}>sendgrid</option>
                                                <option value="ses" {if $settings['mail_driver'] == "ses"}selected{/if}>ses</option>
                                                <option value="smtp" {if $settings['mail_driver'] == "smtp"}selected{/if}>smtp</option>
                                            </select>
                                        </div>

                                        <button id="submit_mail" type="submit" class="btn  btn-brand btn-dense">ثبت</button>

                                        <!-- smtp_test_recipient -->
                                        <div class="form-group form-group-label">
                                            <label class="floating-label">دریافت کننده نامه آزمایشی</label>
                                            <input class="form-control maxwidth-edit" id="testing_email_recipients">
                                            <p class="form-control-guide"><i class="mdi mdi-information"></i>پس از ذخیره پیکربندی ایمیل، در صورت نیاز به بررسی وجود آن، می توانید یک آدرس ایمیل معتبر در بالا وارد کنید و سیستم یک ایمیل آزمایشی به آدرس ایمیل ارسال می کند. اگر بتوان آن را به طور معمول دریافت کرد، پیکربندی در دسترس است</p>
                                            {if $settings['mail_driver'] == "none"}
                                            <p class="form-control-guide"><i class="mdi mdi-information"></i>اگر می‌خواهید از تابع تست ارسال استفاده کنید، لطفاً یک روش ارسال را در بالا انتخاب کنید و پارامترهای مرتبط معتبر را پیکربندی کنید</p>
                                            {/if}
                                        </div>
                                        
                                        <button id="submit_email_test" type="submit" class="btn btn-brand btn-dense" {if $settings['mail_driver'] == "none"}disabled{/if}>تست</button>
                                    </div>
                                    <div class="tab-pane fade" id="smtp">
                                        <!-- smtp_host -->
                                        <div class="form-group form-group-label">
                                            <label class="floating-label">آدرس میزبان SMTP</label>
                                            <input class="form-control maxwidth-edit" id="smtp_host" value="{$settings['smtp_host']}">
                                            <p class="form-control-guide"><i class="mdi mdi-information"></i>به عنوان مثال：smtpdm-ap-southeast-1.aliyun.com</p>
                                        </div>
                                        <!-- smtp_username -->
                                        <div class="form-group form-group-label">
                                            <label class="floating-label">نام حساب SMTP</label>
                                            <input class="form-control maxwidth-edit" id="smtp_username" value="{$settings['smtp_username']}">
                                            <p class="form-control-guide"><i class="mdi mdi-information"></i>به عنوان مثال：no-reply@airport.com</p>
                                        </div>
                                        <!-- smtp_password -->
                                        <div class="form-group form-group-label">
                                            <label class="floating-label">رمز عبور حساب SMTP</label>
                                            <input class="form-control maxwidth-edit" id="smtp_password" value="{$settings['smtp_password']}">
                                            <p class="form-control-guide"><i class="mdi mdi-information"></i>اگر از صندوق پستی QQ یا صندوق پستی 163 استفاده می کنید، باید یک کد مجوز جداگانه را در اینجا پر کنید</p>
                                        </div>
                                        <!-- smtp_port -->
                                        <div class="form-group form-group-label">
                                            <label class="floating-label">پورت SMTP</label>
                                            <select id="smtp_port" class="form-control maxwidth-edit">
                                                <option value="465" {if $settings['smtp_port'] == "465"}selected{/if}>465</option>
                                                <option value="587" {if $settings['smtp_port'] == "587"}selected{/if}>587</option>
                                                <option value="2525" {if $settings['smtp_port'] == "2525"}selected{/if}>2525</option>
                                                <option value="25" {if $settings['smtp_port'] == "25"}selected{/if}>25</option>
                                            </select>
                                            <p class="form-control-guide"><i class="mdi mdi-information"></i>پورت های رایج عموما این ها هستند</p>
                                        </div>
                                        <!-- smtp_name -->
                                        <div class="form-group form-group-label">
                                            <label class="floating-label">نام ارسال SMTP</label>
                                            <input class="form-control maxwidth-edit" id="smtp_name" value="{$settings['smtp_name']}">
                                            <p class="form-control-guide"><i class="mdi mdi-information"></i>تنظیمات اینجا در لیست پستی صندوق پستی قابل مشاهده است. می توانید آن را به عنوان نام وب سایت تنظیم کنید</p>
                                        </div>
                                        <!-- smtp_sender -->
                                        <div class="form-group form-group-label">
                                            <label class="floating-label">آدرس ارسال حساب SMTP</label>
                                            <input class="form-control maxwidth-edit" id="smtp_sender" value="{$settings['smtp_sender']}">
                                            <p class="form-control-guide"><i class="mdi mdi-information"></i>اگر نمی دانید چه چیزی را باید پر کنید، لطفاً با این مورد مطابقت داشته باشید: نام حساب SMTP</p>
                                        </div>
                                        <!-- smtp_ssl -->
                                        <div class="form-group form-group-label">
                                            <label class="floating-label">آیا از TLS/SSL برای ارسال نامه استفاده شود یا خیر</label>
                                            <select id="smtp_ssl" class="form-control maxwidth-edit">
                                                <option value="1" {if $settings['smtp_ssl'] == true}selected{/if}>روشن شود</option>
                                                <option value="0" {if $settings['smtp_ssl'] == false}selected{/if}>استفاده نشود</option>
                                            </select>
                                        </div>
                                        <!-- smtp_bbc -->
                                        <div class="form-group form-group-label">
                                            <label class="floating-label">ایمیل‌های ارسال شده به کاربران برای پشتیبان‌گیری به صندوق پستی تعیین شده ارسال می‌شود</label>
                                            <input class="form-control maxwidth-edit" id="smtp_bbc" value="{$settings['smtp_bbc']}">
                                            <p class="form-control-guide"><i class="mdi mdi-information"></i>اگر نمی خواهید از این ویژگی استفاده کنید، لطفا آن را خالی بگذارید</p>
                                        </div>

                                        <button id="submit_smtp" type="submit" class="btn  btn-brand btn-dense">ثبت</button>
                                    </div>
                                    <div class="tab-pane fade" id="sendgrid">
                                        <!-- sendgrid_key -->
                                        <div class="form-group form-group-label">
                                            <label class="floating-label">Sendgrid کلید</label>
                                            <input class="form-control maxwidth-edit" id="sendgrid_key" value="{$settings['sendgrid_key']}">
                                        </div>
                                        <!-- sendgrid_sender -->
                                        <div class="form-group form-group-label">
                                            <label class="floating-label">Sendgrid ارسال ایمیل</label>
                                            <input class="form-control maxwidth-edit" id="sendgrid_sender" value="{$settings['sendgrid_sender']}">
                                        </div>
                                        <!-- sendgrid_name -->
                                        <div class="form-group form-group-label">
                                            <label class="floating-label">Sendgrid نام فرستنده</label>
                                            <input class="form-control maxwidth-edit" id="sendgrid_name" value="{$settings['sendgrid_name']}">
                                        </div>

                                        <button id="submit_sendgrid" type="submit" class="btn btn-brand btn-dense">ثبت</button>
                                    </div>
                                    <div class="tab-pane fade" id="mailgun">
                                        <!-- mailgun_key -->
                                        <div class="form-group form-group-label">
                                            <label class="floating-label">Mailgun کلید</label>
                                            <input class="form-control maxwidth-edit" id="mailgun_key" value="{$settings['mailgun_key']}">
                                        </div>
                                        <!-- mailgun_domain -->
                                        <div class="form-group form-group-label">
                                            <label class="floating-label">Mailgun نام دامنه</label>
                                            <input class="form-control maxwidth-edit" id="mailgun_domain" value="{$settings['mailgun_domain']}">
                                        </div>
                                        <!-- mailgun_sender -->
                                        <div class="form-group form-group-label">
                                            <label class="floating-label">Mailgun فرستنده</label>
                                            <input class="form-control maxwidth-edit" id="mailgun_sender" value="{$settings['mailgun_sender']}">
                                        </div>

                                        <button id="submit_mailgun" type="submit" class="btn btn-brand btn-dense">ثبت</button>
                                    </div>
                                    <div class="tab-pane fade" id="ses">
                                        <!-- aws_access_key_id -->
                                        <div class="form-group form-group-label">
                                            <label class="floating-label">شناسه کلید AWS</label>
                                            <input class="form-control maxwidth-edit" id="aws_access_key_id" value="{$settings['aws_access_key_id']}">
                                        </div>
                                        <!-- aws_secret_access_key -->
                                        <div class="form-group form-group-label">
                                            <label class="floating-label">کلید AWS</label>
                                            <input class="form-control maxwidth-edit" id="aws_secret_access_key" value="{$settings['aws_secret_access_key']}">
                                        </div>
                                        <!-- aws_region -->
                                        <div class="form-group form-group-label">
                                            <label class="floating-label">منطقه AWS</label>
                                            <input class="form-control maxwidth-edit" id="aws_region" value="{$settings['aws_region']}">
                                        </div>
                                        <!-- aws_ses_sender -->
                                        <div class="form-group form-group-label">
                                            <label class="floating-label">فرستنده AWS SES</label>
                                            <input class="form-control maxwidth-edit" id="aws_ses_sender" value="{$settings['aws_ses_sender']}">
                                        </div>

                                        <button id="submit_ses" type="submit" class="btn btn-brand btn-dense">ثبت</button>
                                    </div>
                                </div>

                                <div class="tab-pane fade active in" id="payment_settings">
                                    <nav class="tab-nav margin-top-no">
                                        <ul class="nav nav-list">
                                            <li class="active">
                                                <a data-toggle="tab" href="#public_payment_settings">&nbsp;راه اندازی</a>
                                            </li>
                                            {foreach $payment_gateways as $key => $value}
                                            <li>
                                                <a data-toggle="tab" href="#{$value}">{$key}</a>
                                            </li>
                                            {/foreach}
                                        </ul>
                                    </nav>
                                            
                                    <div class="tab-pane fade active in" id="public_payment_settings">
                                        <div class="form-group form-group-label">
                                        {foreach $payment_gateways as $key => $value}
                                            <div class="checkbox switch">
                                                <label for="{$value}_switch">
                                                    <input class="access-hide" type="checkbox" id="{$value}_switch" name="{$value}_switch"
                                                    {if in_array($value, $active_payment_gateway)}
                                                    checked
                                                    {/if}
                                                    ><span class="switch-toggle"></span>{$key}
                                                </label>
                                            </div>
                                        {/foreach}
                                        </div>

                                        <button id="submit_payment" type="submit" class="btn btn-block btn-brand">ثبت</button>
                                    </div>

                                    <div class="tab-pane fade" id="payjs">
                                        <p class="form-control-guide"><i class="mdi mdi-information"></i>اینجا درخواست دهید： <a href="https://payjs.cn" target="view_window">https://payjs.cn</a></p>
                                        <!-- payjs_url -->
                                        <div class="form-group form-group-label">
                                            <label class="floating-label">payjs_url</label>
                                            <input class="form-control maxwidth-edit" id="payjs_url" value="{$settings['payjs_url']}">
                                        </div>
                                        <!-- payjs_mchid -->
                                        <div class="form-group form-group-label">
                                            <label class="floating-label">payjs_mchid</label>
                                            <input class="form-control maxwidth-edit" id="payjs_mchid" value="{$settings['payjs_mchid']}">
                                        </div>
                                        <!-- payjs_key -->
                                        <div class="form-group form-group-label">
                                            <label class="floating-label">payjs_key</label>
                                            <input class="form-control maxwidth-edit" id="payjs_key" value="{$settings['payjs_key']}">
                                        </div>

                                        <button id="submit_payjs_pay" type="submit" class="btn btn-block btn-brand">ثبت</button>
                                    </div>

                                    <div class="tab-pane fade" id="paymentwall">
                                        <p class="form-control-guide"><i class="mdi mdi-information"></i>اینجا درخواست دهید： <a href="https://www.paymentwall.com" target="view_window">https://www.paymentwall.com</a></p>
                                        <!-- pmw_publickey -->
                                        <div class="form-group form-group-label">
                                            <label class="floating-label">pmw کلید عمومی</label>
                                            <textarea class="form-control maxwidth-edit" id="pmw_publickey" rows="5">{$settings['pmw_publickey']}</textarea>
                                        </div>
                                        <!-- pmw_privatekey -->
                                        <div class="form-group form-group-label">
                                            <label class="floating-label">pmw کلید خصوصی</label>
                                            <textarea class="form-control maxwidth-edit" id="pmw_privatekey" rows="7">{$settings['pmw_privatekey']}</textarea>
                                        </div>
                                        <!-- pmw_widget -->
                                        <div class="form-group form-group-label">
                                            <label class="floating-label">pmw_widget</label>
                                            <input class="form-control maxwidth-edit" id="pmw_widget" value="{$settings['pmw_widget']}">
                                        </div>
                                        <!-- pmw_height -->
                                        <div class="form-group form-group-label">
                                            <label class="floating-label">pmw_height</label>
                                            <input class="form-control maxwidth-edit" id="pmw_height" value="{$settings['pmw_height']}">
                                        </div>

                                        <button id="submit_paymentwall" type="submit" class="btn btn-block btn-brand">ثبت</button>
                                    </div>
                                    
                                    <div class="tab-pane fade" id="theadpay">
                                        <p class="form-control-guide"><i class="mdi mdi-information"></i>اینجا درخواست دهید：<a href="https://theadpay.com" target="view_window">https://theadpay.com</a></p>
                                        <!-- theadpay_url -->
                                        <div class="form-group form-group-label">
                                            <label class="floating-label">theadpay_url</label>
                                            <input class="form-control maxwidth-edit" id="theadpay_url" value="{$settings['theadpay_url']}">
                                        </div>
                                        <!-- theadpay_mchid -->
                                        <div class="form-group form-group-label">
                                            <label class="floating-label">theadpay_mchid</label>
                                            <input class="form-control maxwidth-edit" id="theadpay_mchid" value="{$settings['theadpay_mchid']}">
                                        </div>
                                        <!-- theadpay_key -->
                                        <div class="form-group form-group-label">
                                            <label class="floating-label">theadpay_key</label>
                                            <input class="form-control maxwidth-edit" id="theadpay_key" value="{$settings['theadpay_key']}">
                                        </div>

                                        <button id="submit_theadpay" type="submit" class="btn btn-block btn-brand">ثبت</button>
                                    </div>

                                    <div class="tab-pane fade" id="stripe_card">
                                        <p class="form-control-guide"><i class="mdi mdi-alert"></i>ارائه خدمات شبکه خصوصی مجازی مطابق با قرارداد کاربر Stripe است، اما ممکن است با توافق کاربر برخی از کانال های پرداخت (مانند Alipay، WeChat) که توسط Stripe ارائه می شود مطابقت نداشته باشد و کانال های پرداخت مربوطه ممکن است در معرض خطر قرار گیرند. بسته</p>
                                        <h5>کانال پرداخت</h5>
                                        <!-- stripe_card_select -->
                                        <div class="form-group form-group-label">
                                            <label class="floating-label">پرداخت کارت بانکی</label>
                                            <select id="stripe_card_select" class="form-control maxwidth-edit">
                                                <option value="0">غیر فعال</option>
                                                <option value="1" {if $settings['stripe_card'] == true}selected{/if}>
                                                    فعال کردن
                                                </option>
                                            </select>
                                        </div>
                                        <h5>تنظیمات پرداخت</h5>
                                        <!-- stripe_currency -->
                                        <div class="form-group form-group-label">
                                            <label class="floating-label">واحد پول</label>
                                            <input class="form-control maxwidth-edit" id="stripe_currency" value="{$settings['stripe_currency']}">
                                        </div>
                                        <!-- stripe_min_recharge -->
                                        <div class="form-group form-group-label">
                                            <label class="floating-label">حداقل محدودیت شارژ (عدد صحیح)</label>
                                            <input class="form-control maxwidth-edit" id="stripe_min_recharge" value="{$settings['stripe_min_recharge']}">
                                        </div>
                                        <!-- stripe_max_recharge -->
                                        <div class="form-group form-group-label">
                                            <label class="floating-label">حداکثر محدودیت شارژ (عدد صحیح)</label>
                                            <input class="form-control maxwidth-edit" id="stripe_max_recharge" value="{$settings['stripe_max_recharge']}">
                                        </div>
                                        <!-- stripe_pk -->
                                        <div class="form-group form-group-label">
                                            <label class="floating-label">stripe_pk</label>
                                            <input class="form-control maxwidth-edit" id="stripe_pk" value="{$settings['stripe_pk']}">
                                        </div>
                                        <!-- stripe_sk -->
                                        <div class="form-group form-group-label">
                                            <label class="floating-label">stripe_sk</label>
                                            <input class="form-control maxwidth-edit" id="stripe_sk" value="{$settings['stripe_sk']}">
                                        </div>
                                        <!-- stripe_webhook_key -->
                                        <div class="form-group form-group-label">
                                            <label class="floating-label">WebHook کلید</label>
                                            <input class="form-control maxwidth-edit" id="stripe_webhook_key" value="{$settings['stripe_webhook_key']}">
                                        </div>

                                        <button id="submit_stripe" type="submit" class="btn btn-block btn-brand">ثبت</button>
                                    </div>
                                    
                                    <div class="tab-pane fade" id="vmqpay">
                                        <p class="form-control-guide"><i class="mdi mdi-information"></i>این روش پرداخت نیاز به ساخت دروازه خاص خود و پیکربندی پارامترهای مختلف دارد. دسترسی <a href="https://github.com/szvone/vmqphp" target="view_window">https://github.com/szvone/vmqphp</a> بیشتر بدانید</p>
                                        <p class="form-control-guide"><i class="mdi mdi-information"></i>شنونده متن باز Android (توصیه می شود)：<a href="https://gitee.com/yuniks/VMQAPK" target="view_window">https://gitee.com/yuniks/VMQAPK</a></p>
                                        <p class="form-control-guide"><i class="mdi mdi-information"></i>شنونده ویندوز غیر منبع باز (توصیه نمی شود)：<a href="https://toscode.gitee.com/pmhw/Vpay" target="view_window">https://toscode.gitee.com/pmhw/Vpay</a></p>
                                        <!-- vmq_gateway -->
                                        <div class="form-group form-group-label">
                                            <label class="floating-label">Vدرگاه بدون ویزا</label>
                                            <input class="form-control maxwidth-edit" id="vmq_gateway" value="{$settings['vmq_gateway']}">
                                            <p class="form-control-guide"><i class="mdi mdi-information"></i>به شکل：https://pay.com</p>
                                        </div>
                                        <!-- vmq_key -->
                                        <div class="form-group form-group-label">
                                            <label class="floating-label">Vکلید بدون امضا</label>
                                            <input class="form-control maxwidth-edit" id="vmq_key" value="{$settings['vmq_key']}">
                                        </div>
                                        
                                        <button id="submit_vmq_pay" type="submit" class="btn btn-block btn-brand">ثبت</button>
                                    </div>
                                    
                                    <div class="tab-pane fade" id="f2fpay">
                                        <p class="form-control-guide"><i class="mdi mdi-information"></i>اینجا درخواست دهید： <a href="https://b.alipay.com/signing/productDetailV2.htm?productId=I1011000290000001003" target="view_window">https://b.alipay.com/signing/productDetailV2.htm?productId=I1011000290000001003</a></p>
                                        <!-- f2f_pay_app_id -->
                                        <div class="form-group form-group-label">
                                            <label class="floating-label">App ID</label>
                                            <input class="form-control maxwidth-edit" id="f2f_pay_app_id" value="{$settings['f2f_pay_app_id']}">
                                        </div>
                                        <!-- f2f_pay_pid -->
                                        <div class="form-group form-group-label">
                                            <label class="floating-label">PID</label>
                                            <input class="form-control maxwidth-edit" id="f2f_pay_pid" value="{$settings['f2f_pay_pid']}">
                                            <p class="form-control-guide"><i class="mdi mdi-information"></i>این مورد را می توان خالی گذاشت، تأثیری بر استفاده نخواهد داشت</p>
                                        </div>
                                        <!-- f2f_pay_public_key -->
                                        <div class="form-group form-group-label">
                                            <label class="floating-label">کلید عمومی</label>
                                            <textarea class="form-control maxwidth-edit" id="f2f_pay_public_key" rows="4">{$settings['f2f_pay_public_key']}</textarea>
                                        </div>
                                        <!-- f2f_pay_private_key -->
                                        <div class="form-group form-group-label">
                                            <label class="floating-label">کلید خصوصی</label>
                                            <textarea class="form-control maxwidth-edit" id="f2f_pay_private_key" rows="12">{$settings['f2f_pay_private_key']}</textarea>
                                        </div>
                                        <!-- f2f_pay_notify_url -->
                                        <div class="form-group form-group-label">
                                            <label class="floating-label">آدرس برگشت به تماس سفارشی</label>
                                            <input class="form-control maxwidth-edit" id="f2f_pay_notify_url" value="{$settings['f2f_pay_notify_url']}">
                                            <p class="form-control-guide"><i class="mdi mdi-information"></i>این مورد را می توان خالی گذاشت، تأثیری بر استفاده نخواهد داشت</p>
                                        </div>
                                        
                                        <button id="submit_f2f_pay" type="submit" class="btn btn-block btn-brand">ثبت</button>
                                    </div>
								
								<div class="tab-pane fade" id="epay">
                                        <!-- epay_url -->
                                        <div class="form-group form-group-label">
                                            <label class="floating-label">URL پرداخت آسان</label>
                                            <input class="form-control maxwidth-edit" id="epay_url" value="{$settings['epay_url']}">
											<p class="form-control-guide"><i class="mdi mdi-information"></i>پسوندهای مختلف آدرس اینترنتی Ypay متفاوت هستند، 1: نام دامنه با / 2: نام دامنه با submit.php/</p>
                                        </div>
                                        <!-- epay_pid -->
                                        <div class="form-group form-group-label">
                                            <label class="floating-label">شناسه فروشنده</label>
                                            <input class="form-control maxwidth-edit" id="epay_pid" value="{$settings['epay_pid']}">
                                            <p class="form-control-guide"><i class="mdi mdi-information"></i>ضروری</p>
                                        </div>
                                        <!-- epay_key -->
                                        <div class="form-group form-group-label">
                                            <label class="floating-label">کلید فروشنده</label>
											<input class="form-control maxwidth-edit" id="epay_key" value="{$settings['epay_key']}">
                                        
											<p class="form-control-guide"><i class="mdi mdi-information"></i>ضروری</p>
                                        </div>
                                        <!-- epay_alipay -->
                                        <div class="form-group form-group-label">
                                            <label class="floating-label">Alipay</label>
                                            <select id="epay_alipay" class="form-control maxwidth-edit">
                                                <option value="0">غیر فعال</option>
                                                <option value="1" {if $settings['epay_alipay'] == true}selected{/if}>
                                                    فعال کردن
                                                </option>
                                            </select>
                                        </div>
                                        <!-- epay_wechat -->
                                        <div class="form-group form-group-label">
                                            <label class="floating-label">پرداخت ویچت</label>
                                            <select id="epay_wechat" class="form-control maxwidth-edit">
                                                <option value="0">غیر فعال</option>
                                                <option value="1" {if $settings['epay_wechat'] == true}selected{/if}>
                                                    فعال کردن
                                                </option>
                                            </select>
                                        </div>
                                        <!-- epay_qq -->
                                        <div class="form-group form-group-label">
                                            <label class="floating-label">کیف پول QQ</label>
                                            <select id="epay_qq" class="form-control maxwidth-edit">
                                                <option value="0">غیر فعال</option>
                                                <option value="1" {if $settings['epay_qq'] == true}selected{/if}>
                                                    فعال کردن
                                                </option>
                                            </select>
                                        </div>
                                        <!-- epay_usdt -->
                                        <div class="form-group form-group-label">
                                            <label class="floating-label">USDT</label>
                                            <select id="epay_usdt" class="form-control maxwidth-edit">
                                                <option value="0">غیر فعال</option>
                                                <option value="1" {if $settings['epay_usdt'] == true}selected{/if}>
                                                    فعال کردن
                                                </option>
                                            </select>
                                        </div>
                                        <button id="submit_e_pay" type="submit" class="btn btn-block btn-brand">ثبت</button>
                                     </div>
                                </div>

                                <div class="tab-pane fade" id="customer_service_system_settings">
                                    <nav class="tab-nav margin-top-no">
                                        <ul class="nav nav-list">
                                            <li class="active">
                                                <a data-toggle="tab" href="#web_customer_service_system">&nbsp;امورمشتریان تحت وب</a>
                                            </li>
                                            <li>
                                                <a data-toggle="tab" href="#admin_contact">&nbsp;با مدیر وب سایت تماس بگیرید</a>
                                            </li>
                                        </ul>
                                    </nav>
                                    <div class="tab-pane fade active in" id="web_customer_service_system">
                                        <!-- live_chat -->
                                        <div class="form-group form-group-label">
                                            <label class="floating-label">سیستم امور مشتریان تحت وب</label>
                                            <select id="live_chat" class="form-control maxwidth-edit">
                                                <option value="none" {if $settings['live_chat'] == "none"}selected{/if}>غیر فعال</option>
                                                <option value="tawk" {if $settings['live_chat'] == "tawk"}selected{/if}>Tawk</option>
                                                <option value="crisp" {if $settings['live_chat'] == "crisp"}selected{/if}>Crisp</option>
                                                <option value="livechat" {if $settings['live_chat'] == "livechat"}selected{/if}>LiveChat</option>
                                                <option value="mylivechat" {if $settings['live_chat'] == "mylivechat"}selected{/if}>MyLiveChat</option>
                                            </select>
                                            <p class="form-control-guide"><i class="mdi mdi-information"></i>در حال حاضر، فقط Crisp و LiveChat از انتقال برخی از اطلاعات حساب کاربری (مانند موجودی حساب، زمان انقضا، ترافیک استفاده شده و ترافیک باقیمانده و غیره) پشتیبانی می کنند.</p>
                                        </div>
                                        <!-- tawk_id -->
                                        <div class="form-group form-group-label">
                                            <label class="floating-label">Tawk</label>
                                            <input class="form-control maxwidth-edit" id="tawk_id" value="{$settings['tawk_id']}">
                                            <p class="form-control-guide"><i class="mdi mdi-information"></i>وجود داشته باشد <a href="https://tawk.to" target="view_window">https://tawk.to</a> برنامه، این باید 24 کاراکتر باشد</p>
                                        </div>
                                        <!-- crisp_id -->
                                        <div class="form-group form-group-label">
                                            <label class="floating-label">Crisp</label>
                                            <input class="form-control maxwidth-edit" id="crisp_id" value="{$settings['crisp_id']}">
                                            <p class="form-control-guide"><i class="mdi mdi-information"></i>وجود داشته باشد <a href="https://crisp.chat/en" target="view_window">https://crisp.chat/en</a> برنامه، این باید یک UUID باشد</p>
                                        </div>
                                        <!-- livechat_id -->
                                        <div class="form-group form-group-label">
                                            <label class="floating-label">LiveChat</label>
                                            <input class="form-control maxwidth-edit" id="livechat_id" value="{$settings['livechat_id']}">
                                            <p class="form-control-guide"><i class="mdi mdi-information"></i>وجود داشته باشد <a href="https://www.livechat.com/cn" target="view_window">https://www.livechat.com/cn</a> برنامه، این باید یک عدد 8 رقمی باشد</p>
                                        </div>
                                        <!-- mylivechat_id -->
                                        <div class="form-group form-group-label">
                                            <label class="floating-label">MyLiveChat</label>
                                            <input class="form-control maxwidth-edit" id="mylivechat_id" value="{$settings['mylivechat_id']}">
                                            <p class="form-control-guide"><i class="mdi mdi-information"></i>وجود داشته باشد <a href="https://www.mylivechat.com" target="view_window">https://www.mylivechat.com</a> درخواست بده، من در این مورد اطلاعی ندارم</p>
                                        </div>

                                        <button id="submit_web_customer_service_system" type="submit" class="btn btn-block btn-brand">ثبت</button>
                                    </div>
                                    <div class="tab-pane fade" id="admin_contact">
                                        <p class="form-control-guide"><i class="mdi mdi-information"></i>توجه: اطلاعات تماس خالی نمایش داده نخواهد شد</p>
                                        <p class="form-control-guide"><i class="mdi mdi-information"></i>از استفاده از تگ های HTML پشتیبانی می شود. می‌توانید تگ a را پیکربندی کنید تا به اثری دست یابد که پنجره جلسه برنامه مربوطه را می‌توان با کلیک کردن برانگیخت.</p>
                                        <p class="form-control-guide"><i class="mdi mdi-information"></i>اگر این عملکرد فعال باشد، اطلاعات تماس نمایش داده شده در این صفحه نمایش داده می شود：</p>
                                        <p class="form-control-guide"><i class="mdi mdi-information"></i>1. در صفحه ثبت نام یا بازنشانی رمز عبور، روی دکمه [عدم دریافت کد تأیید] کلیک کنید</p>
                                        <p class="form-control-guide"><i class="mdi mdi-information"></i>2. حساب کاربری به صفحه غیر فعال اطلاع داده می شود</p>
                                        <p class="form-control-guide"><i class="mdi mdi-information"></i>3. صفحه شارژ به کاربرانی که شارژ آنها نرسیده است، اطلاع می دهد</p>
                                        <p class="form-control-guide"><i class="mdi mdi-information"></i>4. در زیر تابلوی اعلانات در صفحه اصلی مرکز کاربران</p>
                                        <!-- enable_admin_contact -->
                                        <div class="form-group form-group-label">
                                            <label class="floating-label">آیا اطلاعات تماس مدیر وب سایت نمایش داده شود</label>
                                            <select id="enable_admin_contact" class="form-control maxwidth-edit">
                                                <option value="0" {if $settings['enable_admin_contact'] == false}selected{/if}>عدم نمایش</option>
                                                <option value="1" {if $settings['enable_admin_contact'] == true}selected{/if}>روشن شود</option>
                                            </select>
                                        </div>
                                        <!-- admin_contact1 -->
                                        <div class="form-group form-group-label">
                                            <label class="floating-label">اطلاعات تماس مدیر وب سایت یک</label>
                                            <input class="form-control maxwidth-edit" id="admin_contact1" value="{htmlspecialchars($settings['admin_contact1'])}">
                                        </div>
                                        <!-- admin_contact2 -->
                                        <div class="form-group form-group-label">
                                            <label class="floating-label">اطلاعات تماس با مدیر وب سایت دو</label>
                                            <input class="form-control maxwidth-edit" id="admin_contact2" value="{htmlspecialchars($settings['admin_contact2'])}">
                                        </div>
                                        <!-- admin_contact3 -->
                                        <div class="form-group form-group-label">
                                            <label class="floating-label">اطلاعات تماس با مدیر وب سایت سه</label>
                                            <input class="form-control maxwidth-edit" id="admin_contact3" value="{htmlspecialchars($settings['admin_contact3'])}">
                                        </div>

                                        <button id="submit_admin_contact" type="submit" class="btn btn-block btn-brand">ثبت</button>
                                    </div>
                                </div>

                                <div class="tab-pane fade" id="verification_code_settings">
                                    <nav class="tab-nav margin-top-no">
                                        <ul class="nav nav-list">
                                            <li class="active">
                                                <a data-toggle="tab" href="#verification_code_public_settings">&nbsp;راه اندازی</a>
                                            </li>
                                            <li>
                                                <a data-toggle="tab" href="#turnstile">&nbsp;Turnstile</a>
                                            </li>
                                            <li>
                                                <a data-toggle="tab" href="#geetest">&nbsp;Geetest</a>
                                            </li>
                                        </ul>
                                    </nav>
                                            
                                    <div class="tab-pane fade active in" id="verification_code_public_settings">
                                        <!-- captcha_provider -->
                                        <div class="form-group form-group-label">
                                            <label class="floating-label">ارائه دهنده کپچا</label>
                                            <select id="captcha_provider" class="form-control maxwidth-edit">
                                                <option value="turnstile" {if $settings['captcha_provider'] == "turnstile"}selected{/if}>Turnstile</option>
                                                <option value="geetest" {if $settings['captcha_provider'] == "geetest"}selected{/if}>Geetest</option>
                                            </select>
                                        </div>
                                        <!-- enable_reg_captcha -->
                                        <div class="form-group form-group-label">
                                            <label class="floating-label">کد تایید ثبت نام</label>
                                            <select id="enable_reg_captcha" class="form-control maxwidth-edit">
                                                <option value="0" {if $settings['enable_reg_captcha'] == false}selected{/if}>غیرفعال</option>
                                                <option value="1" {if $settings['enable_reg_captcha'] == true}selected{/if}>فعال</option>
                                            </select>
                                        </div>
                                        <!-- enable_login_captcha -->
                                        <div class="form-group form-group-label">
                                            <label class="floating-label">کد تایید ورود</label>
                                            <select id="enable_login_captcha" class="form-control maxwidth-edit">
                                                <option value="0" {if $settings['enable_login_captcha'] == false}selected{/if}>غیرفعال</option>
                                                <option value="1" {if $settings['enable_login_captcha'] == true}selected{/if}>فعال</option>
                                            </select>
                                        </div>
                                        <!-- enable_checkin_captcha -->
                                        <div class="form-group form-group-label">
                                            <label class="floating-label">کد تأیید ورود به سیستم</label>
                                            <select id="enable_checkin_captcha" class="form-control maxwidth-edit">
                                                <option value="0" {if $settings['enable_checkin_captcha'] == false}selected{/if}>غیرفعال</option>
                                                <option value="1" {if $settings['enable_checkin_captcha'] == true}selected{/if}>فعال</option>
                                            </select>
                                        </div>
                                        <!-- enable_reset_password_captcha -->
                                        <div class="form-group form-group-label">
                                            <label class="floating-label">کد تأیید رمز عبور را بازنشانی کنید</label>
                                            <select id="enable_reset_password_captcha" class="form-control maxwidth-edit">
                                                <option value="0" {if $settings['enable_reset_password_captcha'] == false}selected{/if}>غیرفعال</option>
                                                <option value="1" {if $settings['enable_reset_password_captcha'] == true}selected{/if}>فعال</option>
                                            </select>
                                        </div>

                                        <button id="submit_verify_code" type="submit" class="btn btn-block btn-brand">ثبت</button>
                                    </div>
                                    <div class="tab-pane fade" id="turnstile">
                                        <p class="form-control-guide"><i class="mdi mdi-information"></i>وجود داشته باشد <a href="https://developers.cloudflare.com/turnstile/get-started/#sitekey-and-secret-key" target="view_window">https://developers.cloudflare.com/turnstile/get-started/#sitekey-and-secret-key</a> برنامه</p>
                                        <!-- turnstile_sitekey -->
                                        <div class="form-group form-group-label">
                                            <label class="floating-label">Turnstile Site Key</label>
                                            <input class="form-control maxwidth-edit" id="turnstile_sitekey" value="{$settings['turnstile_sitekey']}">
                                        </div>
                                        <!-- turnstile_secret -->
                                        <div class="form-group form-group-label">
                                            <label class="floating-label">Turnstile Secret</label>
                                            <input class="form-control maxwidth-edit" id="turnstile_secret" value="{$settings['turnstile_secret']}">
                                        </div>

                                        <button id="submit_turnstile" type="submit" class="btn btn-block btn-brand">ثبت</button>
                                    </div>
                                    <div class="tab-pane fade" id="geetest">
                                        <p class="form-control-guide"><i class="mdi mdi-information"></i>وجود داشته باشد <a href="https://gtaccount.geetest.com/sensebot/overview" target="view_window">https://gtaccount.geetest.com/sensebot/overview</a> برنامه</p>
                                        <!-- geetest_id -->
                                        <div class="form-group form-group-label">
                                            <label class="floating-label">Geetest ID</label>
                                            <input class="form-control maxwidth-edit" id="geetest_id" value="{$settings['geetest_id']}">
                                        </div>
                                        <!-- geetest_key -->
                                        <div class="form-group form-group-label">
                                            <label class="floating-label">Geetest Key</label>
                                            <input class="form-control maxwidth-edit" id="geetest_key" value="{$settings['geetest_key']}">
                                        </div>

                                        <button id="submit_geetest" type="submit" class="btn btn-block btn-brand">ثبت</button>
                                    </div>
                                </div>

                                <div class="tab-pane fade" id="registration_settings">
                                    <nav class="tab-nav margin-top-no">
                                        <ul class="nav nav-list">
                                            <li class="active">
                                                <a data-toggle="tab" href="#reg_mode_and_verify">&nbsp;حالت ثبت نام و احراز هویت</a>
                                            </li>
                                            <li>
                                                <a data-toggle="tab" href="#register_default_value">&nbsp;پیش فرض ها</a>
                                            </li>
                                        </ul>
                                    </nav>
                                            
                                    <div class="tab-pane fade active in" id="reg_mode_and_verify">
                                        <!-- reg_mode -->
                                        <div class="form-group form-group-label">
                                            <label class="floating-label">تنظیمات حالت ثبت نام</label>
                                            <select id="reg_mode" class="form-control maxwidth-edit">
                                                <option value="close" {if $settings['reg_mode'] == 'close'}selected{/if}>بستن ثبت عمومی</option>
                                                <option value="open" {if $settings['reg_mode'] == 'open'}selected{/if}>باز کردن ثبت نام عمومی</option>
                                                <option value="invite" {if $settings['reg_mode'] == 'invite'}selected{/if}>ثبت نام کاربر فقط با دعوت کاربران</option>
                                            </select>
                                        </div>
                                        <!-- reg_email_verify -->
                                        <div class="form-group form-group-label">
                                            <label class="floating-label">ثبت نام تأیید کد تأیید ایمیل</label>
                                            <select id="reg_email_verify" class="form-control maxwidth-edit">
                                                <option value="0" {if $settings['reg_email_verify'] == false}selected{/if}>غیرفعال</option>
                                                <option value="1" {if $settings['reg_email_verify'] == true}selected{/if}>فعال</option>
                                            </select>
                                        </div>
                                        <!-- email_verify_ttl -->
                                        <div class="form-group form-group-label">
                                            <label class="floating-label">مدت اعتبار کد تایید ایمیل ثبت نام (واحد: ثانیه)</label>
                                            <input class="form-control maxwidth-edit" id="email_verify_ttl" value="{$settings['email_verify_ttl']}">
                                        </div>
                                        <!-- email_verify_ip_limit -->
                                        <div class="form-group form-group-label">
                                            <label class="floating-label">تعداد دفعاتی که یک آی پی می تواند در مدت اعتبار کد تایید درخواست ارسال کند</label>
                                            <input class="form-control maxwidth-edit" id="email_verify_ip_limit" value="{$settings['email_verify_ip_limit']}">
                                        </div>

                                        <button type="submit" class="btn btn-block btn-brand submit_register_settings">ثبت</button>
                                    </div>

                                    <div class="tab-pane fade" id="register_default_value">
                                        <h5>ثبت پیش فرض</h5>
                                        <!-- random_group -->
                                        <div class="form-group form-group-label">
                                            <label class="floating-label">گروه هایی که به طور تصادفی در هنگام ثبت نام اختصاص داده می شوند، چندین گروه باید با کاما از هم جدا شوند</label>
                                            <input class="form-control maxwidth-edit" id="random_group" value="{$settings['random_group']}">
                                        </div>
                                        <!-- min_port -->
                                        <div class="form-group form-group-label">
                                            <label class="floating-label">حداقل مقدار پورت کاربر، 0 به این معنی است که هنگام ثبت نام به کاربر پورت چند کاربر اختصاص داده نمی شود.</label>
                                            <input class="form-control maxwidth-edit" id="min_port" value="{$settings['min_port']}">
                                        </div>
                                        <!-- max_port -->
                                        <div class="form-group form-group-label">
                                            <label class="floating-label">حداکثر مقدار مجموعه پورت کاربر، 0 به این معنی است که هنگام ثبت نام به کاربر یک پورت چند کاربر اختصاص داده نمی شود.</label>
                                            <input class="form-control maxwidth-edit" id="max_port" value="{$settings['max_port']}">
                                        </div>
                                        <!-- sign_up_for_free_traffic -->
                                        <div class="form-group form-group-label">
                                            <label class="floating-label">ترافیک رایگان هنگام ثبت نام (واحد: گیگابایت)</label>
                                            <input class="form-control maxwidth-edit" id="sign_up_for_free_traffic" value="{$settings['sign_up_for_free_traffic']}">
                                        </div>
                                        <!-- free_user_reset_day -->
                                        <div class="form-group form-group-label">
                                            <label class="floating-label">تاریخ ریست ترافیک برای کاربران رایگان، 0 به معنای عدم تنظیم مجدد است</label>
                                            <input class="form-control maxwidth-edit" id="free_user_reset_day" value="{$settings['free_user_reset_day']}">
                                        </div>
                                        <!-- free_user_reset_bandwidth -->
                                        <div class="form-group form-group-label">
                                            <label class="floating-label">ترافیک رایگان که نیاز به تنظیم مجدد دارد، 0 به معنای عدم تنظیم مجدد است</label>
                                            <input class="form-control maxwidth-edit" id="free_user_reset_bandwidth" value="{$settings['free_user_reset_bandwidth']}">
                                        </div>
                                        <!-- sign_up_for_free_time -->
                                        <div class="form-group form-group-label">
                                            <label class="floating-label">مدت زمان هدیه هنگام ثبت نام (واحد: روز)</label>
                                            <input class="form-control maxwidth-edit" id="sign_up_for_free_time" value="{$settings['sign_up_for_free_time']}">
                                        </div>
                                        <!-- sign_up_for_class -->
                                        <div class="form-group form-group-label">
                                            <label class="floating-label">سطح تعیین شده در هنگام ثبت نام</label>
                                            <input class="form-control maxwidth-edit" id="sign_up_for_class" value="{$settings['sign_up_for_class']}">
                                        </div>
                                        <!-- sign_up_for_class_time -->
                                        <div class="form-group form-group-label">
                                            <label class="floating-label">زمان انقضای سطح تعیین شده در هنگام ثبت نام (واحد: روز)</label>
                                            <input class="form-control maxwidth-edit" id="sign_up_for_class_time" value="{$settings['sign_up_for_class_time']}">
                                        </div>
                                        <h5>محدودیت ثبت نام</h5>
                                        <!-- sign_up_for_invitation_codes -->
                                        <div class="form-group form-group-label">
                                            <label class="floating-label">محدودیت در تعداد دفعاتی که می توان از لینک ثبت دعوت اولیه استفاده کرد</label>
                                            <input class="form-control maxwidth-edit" id="sign_up_for_invitation_codes" value="{$settings['sign_up_for_invitation_codes']}">
                                        </div>
                                        <!-- connection_device_limit -->
                                        <div class="form-group form-group-label">
                                            <label class="floating-label">محدودیت های دستگاه متصل</label>
                                            <input class="form-control maxwidth-edit" id="connection_device_limit" value="{$settings['connection_device_limit']}">
                                        </div>
                                        <!-- connection_rate_limit -->
                                        <div class="form-group form-group-label">
                                            <label class="floating-label">استفاده از محدودیت نرخ</label>
                                            <input class="form-control maxwidth-edit" id="connection_rate_limit" value="{$settings['connection_rate_limit']}">
                                        </div>
                                        <h5>Shadowsocks 设置</h5>
                                        <!-- sign_up_for_method -->
                                        <div class="form-group form-group-label">
                                            <label class="floating-label">رمزگذاری به صورت پیش فرض</label>
                                            <input class="form-control maxwidth-edit" id="sign_up_for_method" value="{$settings['sign_up_for_method']}">
                                        </div>
                                        <h5>其他</h5>
                                        <!-- reg_forbidden_ip -->
                                        <div class="form-group form-group-label">
                                            <label class="floating-label">دسترسی به لیست IP به طور پیش فرض هنگام ثبت نام ممنوع است</label>
                                            <input class="form-control maxwidth-edit" id="reg_forbidden_ip" value="{$settings['reg_forbidden_ip']}">
                                        </div>
                                        <!-- reg_forbidden_port -->
                                        <div class="form-group form-group-label">
                                            <label class="floating-label">دسترسی به لیست PORT به طور پیش فرض هنگام ثبت نام ممنوع است</label>
                                            <input class="form-control maxwidth-edit" id="reg_forbidden_port" value="{$settings['reg_forbidden_port']}">
                                        </div>
                                        <!-- sign_up_for_daily_report -->
                                        <div class="form-group form-group-label">
                                            <label class="floating-label">اینکه آیا پس از ثبت نام به طور پیش فرض ایمیل مصرف روزانه را دریافت کنید یا خیر</label>
                                            <select id="sign_up_for_daily_report" class="form-control maxwidth-edit">
                                                <option value="0" {if $settings['sign_up_for_daily_report'] == false}selected{/if}>غیرفعال</option>
                                                <option value="1" {if $settings['sign_up_for_daily_report'] == true}selected{/if}>فعال</option>
                                            </select>
                                        </div>
                                        <!-- enable_reg_im -->
                                        <div class="form-group form-group-label">
                                            <label class="floating-label">اینکه آیا کاربران باید هنگام ثبت نام اطلاعات تماس IM را وارد کنند</label>
                                            <select id="enable_reg_im" class="form-control maxwidth-edit">
                                                <option value="0" {if $settings['enable_reg_im'] == false}selected{/if}>غیرفعال</option>
                                                <option value="1" {if $settings['enable_reg_im'] == true}selected{/if}>فعال</option>
                                            </select>
                                        </div>

                                        <button type="submit" class="btn btn-block btn-brand submit_register_settings">ثبت</button>
                                    </div>
                                </div>

                                <div class="tab-pane fade" id="invitation_settings">
                                    <nav class="tab-nav margin-top-no">
                                        <ul class="nav nav-list">
                                            <li class="active">
                                                <a data-toggle="tab" href="#invite_gernal_settings">&nbsp;راه اندازی</a>
                                            </li>
                                            <li>
                                                <a data-toggle="tab" href="#rebate_mode">&nbsp;مدل</a>
                                            </li>
                                        </ul>
                                    </nav>

                                    <div class="tab-pane fade active in" id="invite_gernal_settings">
                                        <!-- invitation_to_register_balance_reward -->
                                        <div class="form-group form-group-label">
                                            <label class="floating-label">اگر شخصی با پیوند دعوت یک کاربر موجود ثبت نام کند، پاداش موجودی که دعوت شده می تواند دریافت کند (واحد: تومان)</label>
                                            <input class="form-control maxwidth-edit" id="invitation_to_register_balance_reward" value="{$settings['invitation_to_register_balance_reward']}">
                                        </div>
                                        <!-- invitation_to_register_traffic_reward -->
                                        <div class="form-group form-group-label">
                                            <label class="floating-label">اگر شخصی با پیوند دعوت یک کاربر موجود ثبت نام کند، پاداش ترافیکی که دعوت کننده می تواند دریافت کند (واحد: گیگابایت)</label>
                                            <input class="form-control maxwidth-edit" id="invitation_to_register_traffic_reward" value="{$settings['invitation_to_register_traffic_reward']}">
                                        </div>
                                        <!-- invite_price -->
                                        <div class="form-group form-group-label">
                                            <label class="floating-label">قیمت مورد نیاز کاربر برای خرید کد دعوت نامه وقتی قیمت کمتر از 0 باشد برای خرید باز تلقی نمی شود</label>
                                            <input class="form-control maxwidth-edit" id="invite_price" value="{$settings['invite_price']}">
                                        </div>
                                        <!-- custom_invite_price -->
                                        <div class="form-group form-group-label">
                                            <label class="floating-label">قیمت مورد نیاز کاربر برای سفارشی کردن کد دعوت. وقتی قیمت کمتر از 0 باشد، برای خرید باز نیست.</label>
                                            <input class="form-control maxwidth-edit" id="custom_invite_price" value="{$settings['custom_invite_price']}">
                                        </div>

                                        <br/>
                                        
                                        <button type="submit" class="btn btn-block btn-brand submit_invite_settings">ثبت</button>
                                    </div>
                                            
                                    <div class="tab-pane fade" id="rebate_mode">
                                        <!-- invitation_mode -->
                                        <div class="form-group form-group-label">
                                            <label class="floating-label">حالت دعوت کردن</label>
                                            <select id="invitation_mode" class="form-control maxwidth-edit">
                                                <option value="registration_only" {if $settings['invitation_mode'] == 'registration_only'}selected{/if}>
                                                فقط از تابع ثبت دعوت استفاده کنید، بدون تخفیف</option>
                                                <option value="after_recharge" {if $settings['invitation_mode'] == 'after_recharge'}selected{/if}>
                                                از عملکرد ثبت دعوت استفاده کنید و در هنگام شارژ کاربران دعوت شده تخفیف دریافت کنید</option>
                                                <option value="after_purchase" {if $settings['invitation_mode'] == 'after_purchase'}selected{/if}>
                                                از عملکرد ثبت دعوت استفاده کنید و در هنگام خرید کاربران دعوت شده تخفیف دریافت کنید</option>
                                            </select>
                                        </div>
                                        <!-- invite_rebate_mode -->
                                        <div class="form-group form-group-label">
                                            <label class="floating-label">حالت تخفیف</label>
                                            <select id="invite_rebate_mode" class="form-control maxwidth-edit">
                                                <option value="continued" {if $settings['invite_rebate_mode'] == 'continued'}selected{/if}>
                                                تخفیف مستمر</option>
                                                <option value="limit_frequency" {if $settings['invite_rebate_mode'] == 'limit_frequency'}selected{/if}>
                                                تعداد کل تخفیف هایی را که دعوت کننده می تواند از دعوت شونده دریافت کند محدود کنید</option>
                                                <option value="limit_amount" {if $settings['invite_rebate_mode'] == 'limit_amount'}selected{/if}>
                                                مقدار کل تخفیفی را که دعوت کننده می تواند از دعوت شونده دریافت کند محدود کنید</option>
                                                <option value="limit_time_range" {if $settings['invite_rebate_mode'] == 'limit_time_range'}selected{/if}>
                                                محدوده زمانی را که دعوت کننده می تواند از دعوت شونده تخفیف دریافت کند، محدود کنید</option>
                                            </select>
                                        </div>
                                        <!-- rebate_ratio -->
                                        <div class="form-group form-group-label">
                                            <label class="floating-label">نرخ تخفیف. اگر از کالای 10 تومانی به 2 تومان برگردانده شد، 0.2 را پر کنید</label>
                                            <input class="form-control maxwidth-edit" id="rebate_ratio" value="{$settings['rebate_ratio']}">
                                        </div>
                                        <h5>حالت محدود تخفیف</h5>
                                        <p class="form-control-guide"><i class="mdi mdi-information"></i>موارد تنظیم زیر فقط زمانی اعمال می شوند که حالت محدودیت تخفیف مربوطه انتخاب شده باشد</p>
                                        <!-- rebate_time_range_limit -->
                                        <div class="form-group form-group-label">
                                            <label class="floating-label">محدودیت زمانی تخفیف (واحد: روز)</label>
                                            <input class="form-control maxwidth-edit" id="rebate_time_range_limit" value="{$settings['rebate_time_range_limit']}">
                                        </div>
                                        <!-- rebate_frequency_limit -->
                                        <div class="form-group form-group-label">
                                            <label class="floating-label">محدودیت کل تخفیف</label>
                                            <input class="form-control maxwidth-edit" id="rebate_frequency_limit" value="{$settings['rebate_frequency_limit']}">
                                        </div>
                                        <p class="form-control-guide"><i class="mdi mdi-information"></i>به عنوان مثال: وقتی روی 3 تنظیم شود، اگر کاربر دعوت شده محصولاتی را با قیمت های 10، 20، 50 و 100 به صورت متوالی خریداری کند، فقط سه سفارش اول تخفیف دریافت می کنند (با فرض اینکه در هنگام خرید تخفیف داده شده است)</p>
                                        <!-- rebate_amount_limit -->
                                        <div class="form-group form-group-label">
                                            <label class="floating-label">محدودیت مبلغ کل تخفیف</label>
                                            <input class="form-control maxwidth-edit" id="rebate_amount_limit" value="{$settings['rebate_amount_limit']}">
                                        </div>
                                        <p class="form-control-guide"><i class="mdi mdi-information"></i>به عنوان مثال: وقتی روی 10 تنظیم شده است، کاربر دعوت شده به طور متوالی محصولاتی را با قیمت های 10، 20، 50 و 100 خریداری کرده است. اگر تخفیف روی 20٪ تنظیم شود، تخفیف برای خرید اول 2 است، بار دوم: 4؛ سه بار 4 است؛ برای خرید چهارم و بعدی، تخفیفی که دعوت کننده می تواند دریافت کند 0 است (با فرض اینکه در زمان خرید تخفیف داده شود)</p>
                                        <p class="form-control-guide"><i class="mdi mdi-information"></i>هنگام انجام محاسبه تخفیف سوم، طبق تنظیمات، تخفیف باید 20% مبلغ سفارش باشد که 10 تومان می باشد. با این حال، از آنجایی که تخفیف تاریخی 6 تومان به دست آمده است، تنها تفاوت بین سقف مبلغ تخفیف کل و تخفیف تاریخی را می توان به دست آورد.</p>
                                        
                                        <br/>
                                        
                                        <button type="submit" class="btn btn-block btn-brand submit_invite_settings">ثبت</button>
                                    </div>
                                </div>

                                <div class="tab-pane fade" id="telegram_settings">
                                    <nav class="tab-nav margin-top-no">
                                        <ul class="nav nav-list">
                                            <li class="active">
                                                <a data-toggle="tab" href="#telegram_gernal_settings">&nbsp;راه اندازی</a>
                                            </li>
                                        </ul>
                                    </nav>
                                    <div class="tab-pane fade active in" id="telegram_gernal_settings">
                                        <!-- telegram_add_node -->
                                        <div class="form-group form-group-label">
                                            <label class="floating-label">افزودن اطلاعیه گره</label>
                                            <select id="telegram_add_node" class="form-control maxwidth-edit">
                                                <option value="0" {if $settings['telegram_add_node'] == false}selected{/if}>غیرفعال</option>
                                                <option value="1" {if $settings['telegram_add_node'] == true}selected{/if}>فعال</option>
                                            </select>
                                        </div>
                                        <!-- telegram_add_node_text -->
                                        <div class="form-group form-group-label">
                                            <label class="floating-label">متن اطلاع رسانی اضافه شدن  گره</label>
                                            <input class="form-control maxwidth-edit" id="telegram_add_node_text" value="{$settings['telegram_add_node_text']}">
                                        </div>
                                        <!-- telegram_update_node -->
                                        <div class="form-group form-group-label">
                                            <label class="floating-label">تغییر اعلان گره</label>
                                            <select id="telegram_update_node" class="form-control maxwidth-edit">
                                                <option value="0" {if $settings['telegram_update_node'] == false}selected{/if}>غیرفعال</option>
                                                <option value="1" {if $settings['telegram_update_node'] == true}selected{/if}>فعال</option>
                                            </select>
                                        </div>
                                        <!-- telegram_update_node_text -->
                                        <div class="form-group form-group-label">
                                            <label class="floating-label">متن اطلاع رسانی تغییرات در گره</label>
                                            <input class="form-control maxwidth-edit" id="telegram_update_node_text" value="{$settings['telegram_update_node_text']}">
                                        </div>
                                        <!-- telegram_delete_node -->
                                        <div class="form-group form-group-label">
                                            <label class="floating-label">اعلان حذف گره</label>
                                            <select id="telegram_delete_node" class="form-control maxwidth-edit">
                                                <option value="0" {if $settings['telegram_delete_node'] == false}selected{/if}>غیرفعال</option>
                                                <option value="1" {if $settings['telegram_delete_node'] == true}selected{/if}>فعال</option>
                                            </select>
                                        </div>
                                        <!-- telegram_delete_node_text -->
                                        <div class="form-group form-group-label">
                                            <label class="floating-label">متن اعلان حذف گره</label>
                                            <input class="form-control maxwidth-edit" id="telegram_delete_node_text" value="{$settings['telegram_delete_node_text']}">
                                        </div>
                                        <!-- telegram_node_gfwed -->
                                        <div class="form-group form-group-label">
                                            <label class="floating-label">اعلان مسدود شدن گره توسط GFW</label>
                                            <select id="telegram_node_gfwed" class="form-control maxwidth-edit">
                                                <option value="0" {if $settings['telegram_node_gfwed'] == false}selected{/if}>غیرفعال</option>
                                                <option value="1" {if $settings['telegram_node_gfwed'] == true}selected{/if}>فعال</option>
                                            </select>
                                        </div>
                                        <!-- telegram_node_gfwed_text -->
                                        <div class="form-group form-group-label">
                                            <label class="floating-label">متن اعلان مسدود شدن گره توسط GFW</label>
                                            <input class="form-control maxwidth-edit" id="telegram_node_gfwed_text" value="{$settings['telegram_node_gfwed_text']}">
                                        </div>
                                        <!-- telegram_node_ungfwed -->
                                        <div class="form-group form-group-label">
                                            <label class="floating-label">اعلان رفع مسدودی گره از GFW</label>
                                            <select id="telegram_node_ungfwed" class="form-control maxwidth-edit">
                                                <option value="0" {if $settings['telegram_node_ungfwed'] == false}selected{/if}>غیرفعال</option>
                                                <option value="1" {if $settings['telegram_node_ungfwed'] == true}selected{/if}>فعال</option>
                                            </select>
                                        </div>
                                        <!-- telegram_node_ungfwed_text -->
                                        <div class="form-group form-group-label">
                                            <label class="floating-label">متن اعلان رفع مسدودی گره از GFW</label>
                                            <input class="form-control maxwidth-edit" id="telegram_node_ungfwed_text" value="{$settings['telegram_node_ungfwed_text']}">
                                        </div>
                                        <!-- telegram_node_online -->
                                        <div class="form-group form-group-label">
                                            <label class="floating-label">اعلان بازگشت گره به حالت آنلاین</label>
                                            <select id="telegram_node_online" class="form-control maxwidth-edit">
                                                <option value="0" {if $settings['telegram_node_online'] == false}selected{/if}>غیرفعال</option>
                                                <option value="1" {if $settings['telegram_node_online'] == true}selected{/if}>فعال</option>
                                            </select>
                                        </div>
                                        <!-- telegram_node_online_text -->
                                        <div class="form-group form-group-label">
                                            <label class="floating-label">متن اعلان بازگشت گره به حالت آنلاین</label>
                                            <input class="form-control maxwidth-edit" id="telegram_node_online_text" value="{$settings['telegram_node_online_text']}">
                                        </div>
                                        <!-- telegram_node_offline -->
                                        <div class="form-group form-group-label">
                                            <label class="floating-label">اعلان آفلاین شدن گره</label>
                                            <select id="telegram_node_offline" class="form-control maxwidth-edit">
                                                <option value="0" {if $settings['telegram_node_offline'] == false}selected{/if}>غیرفعال</option>
                                                <option value="1" {if $settings['telegram_node_offline'] == true}selected{/if}>فعال</option>
                                            </select>
                                        </div>
                                        <!-- telegram_node_offline_text -->
                                        <div class="form-group form-group-label">
                                            <label class="floating-label">متن اعلان آفلاین شدن گره</label>
                                            <input class="form-control maxwidth-edit" id="telegram_node_offline_text" value="{$settings['telegram_node_offline_text']}">
                                        </div>
                                        <!-- telegram_daily_job -->
                                        <div class="form-group form-group-label">
                                            <label class="floating-label">اعلان تلاش روزانه</label>
                                            <select id="telegram_daily_job" class="form-control maxwidth-edit">
                                                <option value="0" {if $settings['telegram_daily_job'] == false}selected{/if}>غیرفعال</option>
                                                <option value="1" {if $settings['telegram_daily_job'] == true}selected{/if}>فعال</option>
                                            </select>
                                        </div>
                                        <!-- telegram_daily_job_text -->
                                        <div class="form-group form-group-label">
                                            <label class="floating-label">متن اعلان تلاش روزانه</label>
                                            <input class="form-control maxwidth-edit" id="telegram_daily_job_text" value="{$settings['telegram_daily_job_text']}">
                                        </div>
                                        <!-- telegram_diary -->
                                        <div class="form-group form-group-label">
                                            <label class="floating-label">اعلان‌های سلامت سیستم</label>
                                            <select id="telegram_diary" class="form-control maxwidth-edit">
                                                <option value="0" {if $settings['telegram_diary'] == false}selected{/if}>غیرفعال</option>
                                                <option value="1" {if $settings['telegram_diary'] == true}selected{/if}>فعال</option>
                                            </select>
                                        </div>
                                        <!-- telegram_diary_text -->
                                        <div class="form-group form-group-label">
                                            <label class="floating-label">متن اعلان سلامت سیستم</label>
                                            <input class="form-control maxwidth-edit" id="telegram_diary_text" value="{$settings['telegram_diary_text']}">
                                        </div>
                                        <!-- telegram_unbind_kick_member -->
                                        <div class="form-group form-group-label">
                                            <label class="floating-label">پس از باز کردن اکانت تلگرام، گروه را به صورت خودکار بیرون کنید</label>
                                            <select id="telegram_unbind_kick_member" class="form-control maxwidth-edit">
                                                <option value="0" {if $settings['telegram_unbind_kick_member'] == false}selected{/if}>غیرفعال</option>
                                                <option value="1" {if $settings['telegram_unbind_kick_member'] == true}selected{/if}>فعال</option>
                                            </select>
                                        </div>
                                        <!-- telegram_group_bound_user -->
                                        <div class="form-group form-group-label">
                                            <label class="floating-label">فقط به کاربرانی که اکانت تلگرام محدود شده دارند اجازه عضویت در گروه را بدهید</label>
                                            <select id="telegram_group_bound_user" class="form-control maxwidth-edit">
                                                <option value="0" {if $settings['telegram_group_bound_user'] == false}selected{/if}>غیرفعال</option>
                                                <option value="1" {if $settings['telegram_group_bound_user'] == true}selected{/if}>فعال</option>
                                            </select>
                                        </div>
                                        <!-- telegram_show_group_link -->
                                        <div class="form-group form-group-label">
                                            <label class="floating-label">فعال کردن ربات تلگرامی که لینک های گروه کاربری را نشان می دهد</label>
                                            <select id="telegram_show_group_link" class="form-control maxwidth-edit">
                                                <option value="0" {if $settings['telegram_show_group_link'] == false}selected{/if}>غیرفعال</option>
                                                <option value="1" {if $settings['telegram_show_group_link'] == true}selected{/if}>فعال</option>
                                            </select>
                                        </div>
                                        <!-- telegram_group_link -->
                                        <div class="form-group form-group-label">
                                            <label class="floating-label">لینک گروه کاربری</label>
                                            <input class="form-control maxwidth-edit" id="telegram_group_link" value="{$settings['telegram_group_link']}">
                                        </div>

                                        <button id="submit_telegram_gernal_settings" type="submit" class="btn btn-block btn-brand">ثبت</button>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        {include file='dialog.tpl'}
    </div>
</main>

{include file='admin/footer.tpl'}

<script>
    window.addEventListener('load', () => {
        $$.getElementById('submit_f2f_pay').addEventListener('click', () => {
            $.ajax({
                type: "POST",
                url: "/admin/setting",
                dataType: "json",
                data: {
                    class: 'f2f_pay',
                    f2f_pay_app_id: $$getValue('f2f_pay_app_id'),
                    f2f_pay_pid: $$getValue('f2f_pay_pid'),
                    f2f_pay_public_key: $$getValue('f2f_pay_public_key'),
                    f2f_pay_private_key: $$getValue('f2f_pay_private_key'),
                    f2f_pay_notify_url: $$getValue('f2f_pay_notify_url')
                },
                success: data => {
                    $("#result").modal();
                    $$.getElementById('msg').innerHTML = data.msg;
                    if (data.ret) {
                        window.setTimeout("location.href='/admin/setting'", {$config['jump_delay']});
                    }
                },
                error: jqXHR => {
                    alert(`خطایی رخ داده：${
                            jqXHR.status
                            }`);
                }
            })
        })
    })
</script>
<script>
    window.addEventListener('load', () => {
        $$.getElementById('submit_e_pay').addEventListener('click', () => {
            $.ajax({
                type: "POST",
                url: "/admin/setting",
                dataType: "json",
                data: {
                    class: 'e_pay',
                    epay_url: $$getValue('epay_url'),
                    epay_pid: $$getValue('epay_pid'),
                    epay_key: $$getValue('epay_key'),
                    epay_alipay: $$getValue('epay_alipay'),
                    epay_wechat: $$getValue('epay_wechat'),
                    epay_qq: $$getValue('epay_qq'),
                    epay_usdt: $$getValue('epay_usdt')
                    
                },
                success: data => {
                    $("#result").modal();
                    $$.getElementById('msg').innerHTML = data.msg;
                    if (data.ret) {
                        window.setTimeout("location.href='/admin/setting'", {$config['jump_delay']});
                    }
                },
                error: jqXHR => {
                    alert(`خطایی رخ داده：${
                            jqXHR.status
                            }`);
                }
            })
        })
    })
</script>
<script>
    window.addEventListener('load', () => {
        $$.getElementById('submit_payment').addEventListener('click', () => {
            {foreach $payment_gateways as $key => $value}
            if ($$.getElementById("{$value}_switch").checked) {
                var {$value} = 1;
            } else {
                var {$value} = 0;
            }
            {/foreach}
            
            $.ajax({
                type: "POST",
                url: "/admin/setting/payment",
                dataType: "json",
                data: {
                    {foreach $payment_gateways as $key => $value}
                    {$value},
                    {/foreach}
                    class: 'payment'
                },
                success: data => {
                    $("#result").modal();
                    $$.getElementById('msg').innerHTML = data.msg;
                    if (data.ret) {
                        window.setTimeout("location.href='/admin/setting'", {$config['jump_delay']});
                    }
                },
                error: jqXHR => {
                    alert(`خطایی رخ داده：${
                            jqXHR.status
                            }`);
                }
            })
        })
    })
</script>

<script>
    window.addEventListener('load', () => {
        $$.getElementById('submit_vmq_pay').addEventListener('click', () => {
            $.ajax({
                type: "POST",
                url: "/admin/setting",
                dataType: "json",
                data: {
                    class: 'vmq_pay',
                    vmq_gateway: $$getValue('vmq_gateway'),
                    vmq_key: $$getValue('vmq_key')
                },
                success: data => {
                    $("#result").modal();
                    $$.getElementById('msg').innerHTML = data.msg;
                    if (data.ret) {
                        window.setTimeout("location.href='/admin/setting'", {$config['jump_delay']});
                    }
                },
                error: jqXHR => {
                    alert(`خطایی رخ داده：${
                            jqXHR.status
                            }`);
                }
            })
        })
    })
</script>

<script>
    window.addEventListener('load', () => {
        $$.getElementById('submit_mail').addEventListener('click', () => {
            $.ajax({
                type: "POST",
                url: "/admin/setting",
                dataType: "json",
                data: {
                    class: 'mail',
                    mail_driver: $$getValue('mail_driver')
                },
                success: data => {
                    $("#result").modal();
                    $$.getElementById('msg').innerHTML = data.msg;
                    if (data.ret) {
                        window.setTimeout("location.href='/admin/setting'", {$config['jump_delay']});
                    }
                },
                error: jqXHR => {
                    alert(`خطایی رخ داده：${
                            jqXHR.status
                            }`);
                }
            })
        })
    })
</script>

<script>
    window.addEventListener('load', () => {
        $$.getElementById('submit_smtp').addEventListener('click', () => {
            $.ajax({
                type: "POST",
                url: "/admin/setting",
                dataType: "json",
                data: {
                    class: 'smtp',
                    smtp_host: $$getValue('smtp_host'),
                    smtp_username: $$getValue('smtp_username'),
                    smtp_password: $$getValue('smtp_password'),
                    smtp_port: $$getValue('smtp_port'),
                    smtp_name: $$getValue('smtp_name'),
                    smtp_sender: $$getValue('smtp_sender'),
                    smtp_ssl: $$getValue('smtp_ssl'),
                    smtp_bbc: $$getValue('smtp_bbc')
                },
                success: data => {
                    $("#result").modal();
                    $$.getElementById('msg').innerHTML = data.msg;
                    if (data.ret) {
                        window.setTimeout("location.href='/admin/setting'", {$config['jump_delay']});
                    }
                },
                error: jqXHR => {
                    alert(`خطایی رخ داده：${
                            jqXHR.status
                            }`);
                }
            })
        })
    })
</script>

<script>
    window.addEventListener('load', () => {
        $$.getElementById('submit_email_test').addEventListener('click', () => {
            $.ajax({
                type: "POST",
                url: "/admin/setting/email",
                dataType: "json",
                data: {
                    recipient: $$getValue('testing_email_recipients')
                },
                success: data => {
                    $("#result").modal();
                    $$.getElementById('msg').innerHTML = data.msg;
                    if (data.ret) {
                        window.setTimeout("location.href='/admin/setting'", {$config['jump_delay']});
                    }
                },
                error: jqXHR => {
                    alert(`خطایی رخ داده：${
                            jqXHR.status
                            }`);
                }
            })
        })
    })
</script>

<script>
    window.addEventListener('load', () => {
        $$.getElementById('submit_verify_code').addEventListener('click', () => {
            $.ajax({
                type: "POST",
                url: "/admin/setting",
                dataType: "json",
                data: {
                    class: 'verify_code',
                    captcha_provider: $$getValue('captcha_provider'),
                    enable_reg_captcha: $$getValue('enable_reg_captcha'),
                    enable_login_captcha: $$getValue('enable_login_captcha'),
                    enable_checkin_captcha: $$getValue('enable_checkin_captcha'),
                    enable_reset_password_captcha: $$getValue('enable_reset_password_captcha')
                },
                success: data => {
                    $("#result").modal();
                    $$.getElementById('msg').innerHTML = data.msg;
                    if (data.ret) {
                        window.setTimeout("location.href='/admin/setting'", {$config['jump_delay']});
                    }
                },
                error: jqXHR => {
                    alert(`خطایی رخ داده：${
                            jqXHR.status
                            }`);
                }
            })
        })
    })
</script>

<script>
    window.addEventListener('load', () => {
        $$.getElementById('submit_geetest').addEventListener('click', () => {
            $.ajax({
                type: "POST",
                url: "/admin/setting",
                dataType: "json",
                data: {
                    class: 'verify_code_geetest',
                    geetest_id: $$getValue('geetest_id'),
                    geetest_key: $$getValue('geetest_key')
                },
                success: data => {
                    $("#result").modal();
                    $$.getElementById('msg').innerHTML = data.msg;
                    if (data.ret) {
                        window.setTimeout("location.href='/admin/setting'", {$config['jump_delay']});
                    }
                },
                error: jqXHR => {
                    alert(`خطایی رخ داده：${
                            jqXHR.status
                            }`);
                }
            })
        })
    })
</script>

<script>
    window.addEventListener('load', () => {
        $$.getElementById('submit_turnstile').addEventListener('click', () => {
            $.ajax({
                type: "POST",
                url: "/admin/setting",
                dataType: "json",
                data: {
                    class: 'verify_code_turnstile',
                    turnstile_sitekey: $$getValue('turnstile_sitekey'),
                    turnstile_secret: $$getValue('turnstile_secret')
                },
                success: data => {
                    $("#result").modal();
                    $$.getElementById('msg').innerHTML = data.msg;
                    if (data.ret) {
                        window.setTimeout("location.href='/admin/setting'", {$config['jump_delay']});
                    }
                },
                error: jqXHR => {
                    alert(`خطایی رخ داده：${
                            jqXHR.status
                            }`);
                }
            })
        })
    })
</script>

<script>
    window.addEventListener('load', () => {
        $$.getElementById('submit_mailgun').addEventListener('click', () => {
            $.ajax({
                type: "POST",
                url: "/admin/setting",
                dataType: "json",
                data: {
                    class: 'mailgun',
                    mailgun_key: $$getValue('mailgun_key'),
                    mailgun_domain: $$getValue('mailgun_domain'),
                    mailgun_sender: $$getValue('mailgun_sender')
                },
                success: data => {
                    $("#result").modal();
                    $$.getElementById('msg').innerHTML = data.msg;
                    if (data.ret) {
                        window.setTimeout("location.href='/admin/setting'", {$config['jump_delay']});
                    }
                },
                error: jqXHR => {
                    alert(`خطایی رخ داده：${
                            jqXHR.status
                            }`);
                }
            })
        })
    })
</script>

<script>
    window.addEventListener('load', () => {
        $$.getElementById('submit_sendgrid').addEventListener('click', () => {
            $.ajax({
                type: "POST",
                url: "/admin/setting",
                dataType: "json",
                data: {
                    class: 'sendgrid',
                    sendgrid_key: $$getValue('sendgrid_key'),
                    sendgrid_sender: $$getValue('sendgrid_sender'),
                    sendgrid_name: $$getValue('sendgrid_name')
                },
                success: data => {
                    $("#result").modal();
                    $$.getElementById('msg').innerHTML = data.msg;
                    if (data.ret) {
                        window.setTimeout("location.href='/admin/setting'", {$config['jump_delay']});
                    }
                },
                error: jqXHR => {
                    alert(`خطایی رخ داده：${
                            jqXHR.status
                            }`);
                }
            })
        })
    })
</script>

<script>
    window.addEventListener('load', () => {
        $$.getElementById('submit_ses').addEventListener('click', () => {
            $.ajax({
                type: "POST",
                url: "/admin/setting",
                dataType: "json",
                data: {
                    class: 'ses',
                    aws_access_key_id: $$getValue('aws_access_key_id'),
                    aws_secret_access_key: $$getValue('aws_secret_access_key'),
                    aws_region: $$getValue('aws_region'),
                    aws_ses_sender: $$getValue('aws_ses_sender')
                },
                success: data => {
                    $("#result").modal();
                    $$.getElementById('msg').innerHTML = data.msg;
                    if (data.ret) {
                        window.setTimeout("location.href='/admin/setting'", {$config['jump_delay']});
                    }
                },
                error: jqXHR => {
                    alert(`خطایی رخ داده：${
                            jqXHR.status
                            }`);
                }
            })
        })
    })
</script>

<script>
    window.addEventListener('load', () => {
        $$.getElementById('submit_payjs_pay').addEventListener('click', () => {
            $.ajax({
                type: "POST",
                url: "/admin/setting",
                dataType: "json",
                data: {
                    class: 'payjs_pay',
                    payjs_url: $$getValue('payjs_url'),
                    payjs_mchid: $$getValue('payjs_mchid'),
                    payjs_key: $$getValue('payjs_key')
                },
                success: data => {
                    $("#result").modal();
                    $$.getElementById('msg').innerHTML = data.msg;
                    if (data.ret) {
                        window.setTimeout("location.href='/admin/setting'", {$config['jump_delay']});
                    }
                },
                error: jqXHR => {
                    alert(`خطایی رخ داده：${
                            jqXHR.status
                            }`);
                }
            })
        })
    })
</script>

<script>
    window.addEventListener('load', () => {
        $$.getElementById('submit_paymentwall').addEventListener('click', () => {
            $.ajax({
                type: "POST",
                url: "/admin/setting",
                dataType: "json",
                data: {
                    class: 'paymentwall',
                    pmw_publickey: $$getValue('pmw_publickey'),
                    pmw_privatekey: $$getValue('pmw_privatekey'),
                    pmw_widget: $$getValue('pmw_widget'),
                    pmw_height: $$getValue('pmw_height')
                },
                success: data => {
                    $("#result").modal();
                    $$.getElementById('msg').innerHTML = data.msg;
                    if (data.ret) {
                        window.setTimeout("location.href='/admin/setting'", {$config['jump_delay']});
                    }
                },
                error: jqXHR => {
                    alert(`خطایی رخ داده：${
                            jqXHR.status
                            }`);
                }
            })
        })
    })
</script>

<script>
    window.addEventListener('load', () => {
        $$.getElementById('submit_admin_contact').addEventListener('click', () => {
            $.ajax({
                type: "POST",
                url: "/admin/setting",
                dataType: "json",
                data: {
                    class: 'admin_contact',
                    enable_admin_contact: $$getValue('enable_admin_contact'),
                    admin_contact1: $$getValue('admin_contact1'),
                    admin_contact2: $$getValue('admin_contact2'),
                    admin_contact3: $$getValue('admin_contact3')
                },
                success: data => {
                    $("#result").modal();
                    $$.getElementById('msg').innerHTML = data.msg;
                    if (data.ret) {
                        window.setTimeout("location.href='/admin/setting'", {$config['jump_delay']});
                    }
                },
                error: jqXHR => {
                    alert(`خطایی رخ داده：${
                            jqXHR.status
                            }`);
                }
            })
        })
    })
</script>

<script>
    window.addEventListener('load', () => {
        $$.getElementById('submit_web_customer_service_system').addEventListener('click', () => {
            $.ajax({
                type: "POST",
                url: "/admin/setting",
                dataType: "json",
                data: {
                    class: 'web_customer_service_system',
                    live_chat: $$getValue('live_chat'),
                    tawk_id: $$getValue('tawk_id'),
                    crisp_id: $$getValue('crisp_id'),
                    livechat_id: $$getValue('livechat_id'),
                    mylivechat_id: $$getValue('mylivechat_id')
                },
                success: data => {
                    $("#result").modal();
                    $$.getElementById('msg').innerHTML = data.msg;
                    if (data.ret) {
                        window.setTimeout("location.href='/admin/setting'", {$config['jump_delay']});
                    }
                },
                error: jqXHR => {
                    alert(`خطایی رخ داده：${
                            jqXHR.status
                            }`);
                }
            })
        })
    })
</script>

<script>
    window.addEventListener('load', () => {
        $$.getElementById('submit_theadpay').addEventListener('click', () => {
            $.ajax({
                type: "POST",
                url: "/admin/setting",
                dataType: "json",
                data: {
                    class: 'theadpay',
                    theadpay_url: $$getValue('theadpay_url'),
                    theadpay_mchid: $$getValue('theadpay_mchid'),
                    theadpay_key: $$getValue('theadpay_key')
                },
                success: data => {
                    $("#result").modal();
                    $$.getElementById('msg').innerHTML = data.msg;
                    if (data.ret) {
                        window.setTimeout("location.href='/admin/setting'", {$config['jump_delay']});
                    }
                },
                error: jqXHR => {
                    alert(`خطایی رخ داده：${
                            jqXHR.status
                            }`);
                }
            })
        })
    })
</script>

<script>
    window.addEventListener('load', () => {
        $$.getElementById('submit_stripe').addEventListener('click', () => {
            $.ajax({
                type: "POST",
                url: "/admin/setting",
                dataType: "json",
                data: {
                    class: 'stripe',
                    stripe_card: $$getValue('stripe_card_select'),
                    stripe_currency: $$getValue('stripe_currency'),
                    stripe_min_recharge: $$getValue('stripe_min_recharge'),
                    stripe_max_recharge: $$getValue('stripe_max_recharge'),
                    stripe_pk: $$getValue('stripe_pk'),
                    stripe_sk: $$getValue('stripe_sk'),
                    stripe_webhook_key: $$getValue('stripe_webhook_key')
                },
                success: data => {
                    $("#result").modal();
                    $$.getElementById('msg').innerHTML = data.msg;
                    if (data.ret) {
                        window.setTimeout("location.href='/admin/setting'", {$config['jump_delay']});
                    }
                },
                error: jqXHR => {
                    alert(`خطایی رخ داده：${
                            jqXHR.status
                            }`);
                }
            })
        })
    })
</script>

<script>
    window.addEventListener('load', () => {
        $('.submit_register_settings').click( () => {
            $.ajax({
                type: "POST",
                url: "/admin/setting",
                dataType: "json",
                data: {
                    class: 'register',
                    reg_mode: $$getValue('reg_mode'),
                    reg_email_verify: $$getValue('reg_email_verify'),
                    email_verify_ttl: $$getValue('email_verify_ttl'),
                    email_verify_ip_limit: $$getValue('email_verify_ip_limit'),
                    random_group: $$getValue('random_group'),
                    min_port: $$getValue('min_port'),
                    max_port: $$getValue('max_port'),
                    sign_up_for_free_traffic: $$getValue('sign_up_for_free_traffic'),
                    free_user_reset_day: $$getValue('free_user_reset_day'),
                    free_user_reset_bandwidth: $$getValue('free_user_reset_bandwidth'),
                    sign_up_for_free_time: $$getValue('sign_up_for_free_time'),
                    sign_up_for_class: $$getValue('sign_up_for_class'),
                    sign_up_for_class_time: $$getValue('sign_up_for_class_time'),
                    sign_up_for_invitation_codes: $$getValue('sign_up_for_invitation_codes'),
                    connection_device_limit: $$getValue('connection_device_limit'),
                    connection_rate_limit: $$getValue('connection_rate_limit'),
                    sign_up_for_method: $$getValue('sign_up_for_method'),
                    reg_forbidden_ip: $$getValue('reg_forbidden_ip'),
                    reg_forbidden_port: $$getValue('reg_forbidden_port'),
                    sign_up_for_daily_report: $$getValue('sign_up_for_daily_report'),
                    enable_reg_im: $$getValue('enable_reg_im')
                },
                success: data => {
                    $("#result").modal();
                    $$.getElementById('msg').innerHTML = data.msg;
                    if (data.ret) {
                        window.setTimeout("location.href='/admin/setting'", {$config['jump_delay']});
                    }
                },
                error: jqXHR => {
                    alert(`خطایی رخ داده：${
                            jqXHR.status
                            }`);
                }
            })
        })
    })
</script>

<script>
    window.addEventListener('load', () => {
        $('.submit_invite_settings').click( () => {
            $.ajax( {
                type: "POST",
                url: "/admin/setting",
                dataType: "json",
                data: {
                    class: 'invite',
                    invitation_mode: $$getValue('invitation_mode'),
                    invite_rebate_mode: $$getValue('invite_rebate_mode'),
                    rebate_ratio: $$getValue('rebate_ratio'),
                    rebate_frequency_limit: $$getValue('rebate_frequency_limit'),
                    rebate_amount_limit: $$getValue('rebate_amount_limit'),
                    rebate_time_range_limit: $$getValue('rebate_time_range_limit'),
                    invitation_to_register_balance_reward: $$getValue('invitation_to_register_balance_reward'),
                    invitation_to_register_traffic_reward: $$getValue('invitation_to_register_traffic_reward'),
                    invite_price: $$getValue('invite_price'),
                    custom_invite_price: $$getValue('custom_invite_price')
                },
                success: data => {
                    $("#result").modal();
                    $$.getElementById('msg').innerHTML = data.msg;
                    if (data.ret) {
                        window.setTimeout("location.href='/admin/setting'", {$config['jump_delay']});
                    }
                },
                error: jqXHR => {
                    alert(`خطایی رخ داده：${
                            jqXHR.status
                            }`);
                }
            } )
        } )
    } )
</script>

<script>
    window.addEventListener('load', () => {
        $$.getElementById('submit_telegram_gernal_settings').addEventListener('click', () => {
            $.ajax({
                type: "POST",
                url: "/admin/setting",
                dataType: "json",
                data: {
                    class: 'telegram',
                    telegram_add_node: $$getValue('telegram_add_node'),
                    telegram_add_node_text: $$getValue('telegram_add_node_text'),
                    telegram_update_node: $$getValue('telegram_update_node'),
                    telegram_update_node_text: $$getValue('telegram_update_node_text'),
                    telegram_delete_node: $$getValue('telegram_delete_node'),
                    telegram_delete_node_text: $$getValue('telegram_delete_node_text'),
                    telegram_node_gfwed: $$getValue('telegram_node_gfwed'),
                    telegram_node_gfwed_text: $$getValue('telegram_node_gfwed_text'),
                    telegram_node_ungfwed: $$getValue('telegram_node_ungfwed'),
                    telegram_node_ungfwed_text: $$getValue('telegram_node_ungfwed_text'),
                    telegram_node_online: $$getValue('telegram_node_online'),
                    telegram_node_online_text: $$getValue('telegram_node_online_text'),
                    telegram_node_offline: $$getValue('telegram_node_offline'),
                    telegram_node_offline_text: $$getValue('telegram_node_offline_text'),
                    telegram_daily_job: $$getValue('telegram_daily_job'),
                    telegram_daily_job_text: $$getValue('telegram_daily_job_text'),
                    telegram_diary: $$getValue('telegram_diary'),
                    telegram_diary_text: $$getValue('telegram_diary_text'),
                    telegram_unbind_kick_member: $$getValue('telegram_unbind_kick_member'),
                    telegram_group_bound_user: $$getValue('telegram_group_bound_user'),
                    telegram_show_group_link: $$getValue('telegram_show_group_link'),
                    telegram_group_link: $$getValue('telegram_group_link')
                },
                success: data => {
                    $("#result").modal();
                    $$.getElementById('msg').innerHTML = data.msg;
                    if (data.ret) {
                        window.setTimeout("location.href='/admin/setting'", {$config['jump_delay']});
                    }
                },
                error: jqXHR => {
                    alert(`خطایی رخ داده：${
                            jqXHR.status
                            }`);
                }
            })
        })
    })
</script>