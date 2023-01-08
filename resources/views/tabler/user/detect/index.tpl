{include file='user/tabler_header.tpl'}

<!-- قوانین حسابرسی برای جلوگیری از DMCA و هرزنامه استفاده می شود، نه برای ساختن دیوار برای کاربران. فکر نکنید که اگر "وب سایت های غیرقانونی" را جدا کنید و گرفتار شوید، می توانید حتی یک روز در زندان پس انداز کنید. -->
<div class="page-wrapper">
    <div class="container-xl">
        <div class="page-header d-print-none text-white">
            <div class="row align-items-center">
                <div class="col">
                    <h2 class="page-title">
                        <span class="home-title">قوانین فیلترینگ</span>
                    </h2>
                    <div class="page-pretitle my-3">
                        <span class="home-subtitle">قوانین فیلترینگ در حال حاضر در سایت استفاده می شود</span>
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
                        <div class="card-body">
                            <div class="m-0 my-2">
                                <p>به منظور جلوگیری از سوء استفاده و اطمینان از عملکرد پایدار سایت، قوانین فیلتر زیر به طور ویژه تدوین شده است، هنگامی که از سرور ها برای انجام این اقدامات استفاده می کنید، ارتباط شما رهگیری می شود.</p>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-12">
                    <div class="card">
                        <div class="table-responsive">
                            <table class="table table-vcenter card-table">
                                <thead>
                                    <tr>
                                        <th>ID</th>
                                        <th>نام</th>
                                        <th>شرح</th>
                                        <th>regular expression</th>
                                        <th>نوع</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    {foreach $rules as $rule}
                                    <tr>
                                        <td>#{$rule->id}</td>
                                        <td>{$rule->name}</td>
                                        <td>{$rule->text}</td>
                                        <td>{$rule->regex}</td>
                                        {if $rule->type == 1}
                                            <td>مطابقت متن ساده بسته</td>
                                        {/if}
                                        {if $rule->type == 2}
                                            <td>بسته داده hex همخوانی داشتن</td>
                                        {/if}
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
