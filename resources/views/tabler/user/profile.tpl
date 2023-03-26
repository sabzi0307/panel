{include file='user/tabler_header.tpl'}

<div class="page-wrapper">
    <div class="container-xl">  
        <div class="page-header d-print-none text-white">
            <div class="row align-items-center">
                <div class="col">     
                    <h2 class="page-title">
                        <span class="home-title">اطلاعات حساب</span>
                    </h2>
                    <div class="page-pretitle my-3">
                        <span class="home-subtitle">آخرین سوابق ورود و استفاده را مرور کنید</span>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div class="page-body">
        <div class="container-xl">
            <div class="row row-deck">
                <div class="col-sm-6 col-lg-3">
                    <div class="card">
                        <div class="card-body">
                            <div class="d-flex align-items-center">
                                <div class="subheader">حساب ایمیل</div>
                            </div>
                            <div class="h1 mb-3">{$user->email}</div>
                        </div>
                    </div>
                </div>
                <div class="col-sm-6 col-lg-3">
                    <div class="card">
                        <div class="card-body">
                            <div class="d-flex align-items-center">
                                <div class="subheader">نام کاربری حساب</div>
                            </div>
                            <div class="h1 mb-3">{$user->user_name}</div>
                        </div>
                    </div>
                </div>
                <div class="col-sm-6 col-lg-3">
                    <div class="card">
                        <div class="card-body">
                            <div class="d-flex align-items-center">
                                <div class="subheader">زمان ثبت حساب</div>
                            </div>
                            <div class="h1 mb-3">{$user->reg_date}</div>
                        </div>
                    </div>
                </div>
                <div class="col-sm-6 col-lg-3">
                    <div class="card">
                        <div class="card-body">
                            <div class="d-flex align-items-center">
                                <div class="subheader">مصرف ترافیک باقی مانده حساب</div>
                            </div>
                            <div class="h1 mb-3">{round($user->transfer_total / 1073741824,2)} GB</div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="row row-deck my-3">
                <div class="col-md-6 com-sm-12">
                    <div class="card">
                        <div class="card-header">
                            <h3 class="card-title">سابقه ورود اخیر</h3>
                        </div>
                        <div class="table-responsive">
                            <table class="table table-vcenter text-nowrap card-table">
                                <thead>
                                    <tr>
                                        <th>IP</th>
                                        <th>زمان</th>
                                        <th>مشخصات</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    {foreach $logins as $login}
                                    <tr>
                                        <td>{$login->ip}</td>
                                        <td>{$login->datetime}</td>
                                        <td>{$login->location}</td>
                                    </tr>
                                    {/foreach}
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
{include file='user/tabler_footer.tpl'}