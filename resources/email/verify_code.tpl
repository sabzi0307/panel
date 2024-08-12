{include file='header.tpl'}

<body style="background-color:#EEEEEE;">
<div style="text-align: center">
    <div border="0" cellpadding="0" cellspacing="0" width="100%"
         style="padding-top:30px;table-layout:fixed;background-color:#EEEEEE;" id="bodyTable">
        <div align="center" valign="top" style="padding-right:10px;padding-left:10px;" id="bodyCell">
            <div border="0" cellpadding="0" cellspacing="0"
                 style="background-color:#FFFFFF;max-width:600px;text-align: center" width="100%" class="wrapperTable">
                <div align="center" valign="top">
                    <div border="0" cellpadding="0" cellspacing="0" width="100%" class="logoTable">
                        <div align="center" valign="middle" style="padding-top:60px;padding-bottom:60px">
                            <h2 class="bigTitle">
                                تایید ایمیل
                            </h2>
                        </div>
                    </div>
                </div>
            </div>
            <div border="0" cellpadding="0" cellspacing="0" style="max-width:600px;text-align: center" width="100%"
                 class="wrapperTable">
                <div align="center" valign="top">
                    <div border="0" cellpadding="0" cellspacing="0" style="background-color:#FFFFFF" width="100%"
                         class="oneColumn">
                        <!-- <div align="center" valign="top"
                             style="padding-bottom:60px;padding-left:20px;padding-right:20px;" class="description">
                            <p class="midText">
                               <span> کد تأیید ایمیلی که درخواست کردید:</span> <span> <b style="color:#505050">{$code}</b><span> <br>
                               <br>
                               <br>
                                این کد تأیید تا {$expire} معتبر است.<br>
                                <br>
                                اگر این کد تأیید توسط خودتان درخواست نشده است، لطفاً آن را نادیده بگیرید.<br>
                            </p>
                        </div> -->


                             <div align="center" valign="top" style="padding: 20px; background-color: #f7f7f7; border-radius: 10px; font-family: Arial, sans-serif; color: #333;">
                                  <h2 style="color: #2c3e50;">تایید ایمیل</h2>
                                 <p style="font-size: 16px; line-height: 1.5;">
                                    <span>کد تأیید ایمیل شما:</span> 
                                     <span style="font-weight: bold; color:#505050; font-size: 18px;">{$code}</span>
                                </p>
                                 <p style="font-size: 14px; color: #555; line-height: 1.5;">
                                     این کد تأیید تا تاریخ <span style="color:#e74c3c;">{$expire}</span> معتبر است.
                                 </p>
                                 <p style="font-size: 14px; color: #555; line-height: 1.5;">
                                      اگر شما این درخواست را نکرده‌اید، لطفاً این ایمیل را نادیده بگیرید.
                               </p>
                                 <hr style="border: none; border-top: 1px solid #eee; margin: 20px 0;">
                                  <p style="font-size: 12px; color: #888; line-height: 1.5;">
                                      اگر سؤالی دارید یا به کمک نیاز دارید، لطفاً با پشتیبانی ما تماس بگیرید.
                                   <br>
                                 <a href="https://magicx.one" style="color: #3498db; text-decoration: none;">magicx.one</a>
    </p>
</div>
                    </div>
                </div>
            </div>

            {include file='footer.tpl'}
