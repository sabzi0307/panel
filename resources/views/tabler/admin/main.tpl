<!DOCTYPE html>
<html lang="fa-IR" dir="rtl" >
<head>
    <meta charset="UTF-8">
    <meta content="IE=edge" http-equiv="X-UA-Compatible">
    <meta content="initial-scale=1.0, maximum-scale=1.0, user-scalable=no, width=device-width" name="viewport">
    <meta name="theme-color" content="#4285f4">
    <title>{$config['appName']}</title>
    <!-- css -->
    <link href="/theme/tabler/css/base.min.css" rel="stylesheet">
    <link href="/theme/tabler/css/project.min.css" rel="stylesheet">
    <link href="//cdn.jsdelivr.net/npm/@mdi/font@latest/css/materialdesignicons.min.css" rel="stylesheet">
    <link href="//cdn.jsdelivr.net/npm/material-design-lite@1.3.0/material.min.css" rel="stylesheet">
    <link href="//cdn.datatables.net/1.12.1/css/dataTables.material.min.css" rel="stylesheet">
    <link href="/assets/font/Yekan.css" rel="stylesheet">
    <style>:root { --tblr-font-sans-serif: 'Yekan';}</style>
    <!-- js -->
    <script src="//cdn.jsdelivr.net/npm/jquery/dist/jquery.min.js"></script>
    <!-- ... -->
    <style>
        body {
            position: relative;
        }

        .table-responsive {
            background: white;
        }

        .dropdown-menu.dropdown-menu-right a {
            color: #212121;
        }

        a[href='#ui_menu'] {
            color: #212121;
        }

        #custom_config {
            height: 500px;
        }
    </style>
</head>

<body class="page-brand">
<header class="header header-red header-transparent header-waterfall ui-header">
    <ul class="nav nav-list pull-left">
        <div>
            <a data-toggle="menu" href="#ui_menu">
                <span class="mdi mdi-menu icon-lg"></span>
            </a>
        </div>
    </ul>
    <ul class="nav nav-list pull-right">
        <div class="dropdown margin-right">
            <a class="dropdown-toggle padding-left-no padding-right-no" data-toggle="dropdown">
                <span class="access-hide">{$user->user_name}</span>
                <span class="avatar avatar-sm"><img src="{$user->gravatar}"></span>
            </a>
            <ul class="dropdown-menu dropdown-menu-right">
                <li>
                    <a class="waves-attach" href="/user/logout"><span
                                class="mdi mdi-exit-to-app icon-lg margin-right"></span>خروج از سیستم</a>
                </li>
            </ul>
        </div>
    </ul>
</header>
<nav aria-hidden="true" class="menu menu-left nav-drawer nav-drawer-md" id="ui_menu" tabindex="-1">
    <div class="menu-scroll">
        <div class="menu-content">
            <a class="menu-logo" href="/">&nbsp;پنل مدیریت</a>
            <ul class="nav">
                <li>
                    <a class="waves-attach" data-toggle="collapse" href="#ui_menu_me">من</a>
                    <ul class="menu-collapse collapse in" id="ui_menu_me">
                        <li><a href="/admin"><i class="mdi mdi-eye icon-lg"></i>&nbsp;نمای کلی سیستم</a></li>
                        <li><a href="/admin/announcement"><i class="mdi mdi-bullhorn-variant icon-lg"></i>&nbsp;مدیریت اطلاعیه</a></li>
                        <li><a href="/admin/ticket"><i class="mdi mdi-comment-question icon-lg"></i>&nbsp;مدیریت دستور کار</a></li>
                    </ul>
                    <a class="waves-attach" data-toggle="collapse" href="#ui_menu_node">نود</a>
                    <ul class="menu-collapse collapse in" id="ui_menu_node">
                        <li><a href="/admin/node"><i class="mdi mdi-server icon-lg"></i>&nbsp;لیست نود ها</a></li>
                    </ul>
                    <a class="waves-attach" data-toggle="collapse" href="#ui_menu_user">کاربر</a>
                    <ul class="menu-collapse collapse in" id="ui_menu_user">
                        <li><a href="/admin/user"><i class="mdi mdi-account-group icon-lg"></i>&nbsp;فهرست کاربران</a></li>
                        <li><a href="/admin/invite"><i class="mdi mdi-account-multiple-plus icon-lg"></i>&nbsp;دعوت و تخفیف</a></li>
                        <li><a href="/admin/subscribe"><i class="mdi mdi-file-find icon-lg"></i>&nbsp;تاریخچه اشتراک</a></li>
                        <li><a href="/admin/login"><i class="mdi mdi-text-account icon-lg"></i>&nbsp;تاریخچه ثبت نام</a></li>
                        <li><a href="/admin/trafficlog"><i class="mdi mdi-swap-vertical icon-lg"></i>&nbsp;تاریخچه ترافیک</a></li>
                        <li><a href="/admin/alive"><i class="mdi mdi-account-badge icon-lg"></i>&nbsp;IP آنلاین</a></li>
                    </ul>
                    <a class="waves-attach" data-toggle="collapse" href="#ui_menu_config">تنظیمات</a>
                    <ul class="menu-collapse collapse in" id="ui_menu_config">
                        <li><a href="/admin/setting"><i class="mdi mdi-cog icon-lg"></i>&nbsp;مرکز تنظیم</a></li>
                    </ul>
                    <a class="waves-attach" data-toggle="collapse" href="#ui_menu_detect">فیلترینگ</a>
                    <ul class="menu-collapse collapse in" id="ui_menu_detect">
                        <li><a href="/admin/detect"><i class="mdi mdi-account-filter icon-lg"></i>&nbsp;قوانین فیلترینگ</a></li>
                        <li><a href="/admin/detect/log"><i class="mdi mdi-calendar-filter icon-lg"></i>&nbsp;سوابق فیلترینگ</a></li>
                        <li><a href="/admin/detect/ban"><i class="mdi mdi-account-cancel icon-lg"></i>&nbsp;ممنوعیت های فیلترینگ</a></li>
                    </ul>
                    <a class="waves-attach" data-toggle="collapse" href="#ui_menu_trade">امور مالی</a>
                    <ul class="menu-collapse collapse in" id="ui_menu_trade">
                        <li><a href="/admin/code">
                                <i class="mdi mdi-currency-usd icon-lg"></i>
                                &nbsp;تاریخچه شارژ مجدد</a>
                        </li>
                        <li><a href="/admin/shop"><i class="mdi mdi-shopping icon-lg"></i>&nbsp;فروشگاه</a></li>
                        <li><a href="/admin/coupon"><i class="mdi mdi-code-tags icon-lg"></i>&nbsp;کد تخفیف</a></li>
                        <li><a href="/admin/bought"><i class="mdi mdi-shopping-search icon-lg"></i>&nbsp;تاریخچه خرید</a></li>
                    </ul>
                <li><a href="/user"><i class="mdi mdi-account icon-lg"></i>&nbsp;پنل کاربر</a></li>
            </ul>
        </div>
    </div>
</nav>
