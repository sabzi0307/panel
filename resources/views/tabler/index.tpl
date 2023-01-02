<!DOCTYPE HTML>
<html lang="fa" dir="rtl" >
<head>
    <meta charset="UTF-8">
    <meta name="robots" content="noindex">
    <title>{$config['appName']}</title>
    {if $user->isLogin}
    <script>
        window.location.href = "/user"
    </script>
    {else}
    <script>
        window.location.href = "/auth/login"
    </script>
    {/if}
    <link href="/assets/font/Yekan.css" rel="stylesheet">
    <style>:root { --tblr-font-sans-serif: 'Yekan';}</style>
</head>
</html>