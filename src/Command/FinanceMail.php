<?php

declare(strict_types=1);

namespace App\Command;

use App\Models\User;
use App\Utils\DatatablesHelper;
use App\Utils\Telegram;
use Ozdemir\Datatables\Datatables;

final class FinanceMail extends Command
{
    public $description = <<<EOL
├─=: php xcat FinanceMail [options]
│ ├─ day                     - daily
│ ├─ week                    - weekly
│ ├─ month                   - monthly report
EOL;

    public function boot(): void
    {
        if (count($this->argv) === 2) {
            echo $this->description;
        } else {
            $methodName = $this->argv[2];
            if (method_exists($this, $methodName)) {
                $this->$methodName();
            } else {
                echo 'Method does not exist.' . PHP_EOL;
            }
        }
    }

    public function day(): void
    {
        $datatables = new Datatables(new DatatablesHelper());
        $datatables->query(
            'select code.number, code.userid, code.usedatetime from code
		where TO_DAYS(NOW()) - TO_DAYS(code.usedatetime) = 1 and code.type = -1 and code.isused= 1'
        );
        $text_json = $datatables->generate();
        $text_array = \json_decode($text_json, true);
        $codes = $text_array['data'];
        $text_html = '<table border=1><tr><td>مقدار</td><td>شناسه کاربر</td><td>نام کاربری</td><td>زمان شارژ مجدد</td>';
        $income_count = 0;
        $income_total = 0.00;
        foreach ($codes as $code) {
            $text_html .= '<tr>';
            $text_html .= '<td>' . $code['number'] . '</td>';
            $text_html .= '<td>' . $code['userid'] . '</td>';
            $user = User::find($code['userid']);
            $text_html .= '<td>' . $user->user_name . '</td>';
            $text_html .= '<td>' . $code['usedatetime'] . '</td>';
            $text_html .= '</tr>';
            ++$income_count;
            $income_total += $code['number'];
        }

        $text_html .= '</table>';
        $text_html .= '<br>کل درآمد دیروز：' . $income_count . '<br>کل درآمد دیروز：' . $income_total;

        $adminUser = User::where('is_admin', '=', '1')->get();
        foreach ($adminUser as $user) {
            echo 'Send offline mail to user: ' . $user->id;
            $user->sendMail(
                $_ENV['appName'] . '-مالی روزانه',
                'news/finance.tpl',
                [
                    'title' => 'مالی روزانه',
                    'text' => $text_html,
                ],
                []
            );
        }

        if ($_ENV['finance_public']) {
            Telegram::send(
                'مالی تازه منتشر شده روزانه~' . PHP_EOL .
                'کل درآمد دیروز:' . $income_count . PHP_EOL .
                'کل درآمد دیروز:' . $income_total . PHP_EOL .
                'کار سخت در صبح زود~'
            );
        }
    }

    public function week(): void
    {
        $datatables = new Datatables(new DatatablesHelper());
        $datatables->query(
            'SELECT code.number FROM code
		WHERE DATEDIFF(NOW(),code.usedatetime) <=7 AND DATEDIFF(NOW(),code.usedatetime) >=1 AND code.isused = 1'
        );
        //每周的第一天是周日，因此统计周日～周六的七天
        $text_json = $datatables->generate();
        $text_array = \json_decode($text_json, true);
        $codes = $text_array['data'];
        $text_html = '';
        $income_count = 0;
        $income_total = 0.00;
        foreach ($codes as $code) {
            ++$income_count;
            $income_total += $code['number'];
        }

        $text_html .= '<br>کل درآمد هفته گذشته：' . $income_count . '<br>کل درآمد هفته گذشته：' . $income_total;

        $adminUser = User::where('is_admin', '=', '1')->get();
        foreach ($adminUser as $user) {
            echo 'Send offline mail to user: ' . $user->id;
            $user->sendMail(
                $_ENV['appName'] . '-گزارش مالی هفتگی',
                'news/finance.tpl',
                [
                    'title' => 'هفته نامه مالی',
                    'text' => $text_html,
                ],
                []
            );
        }

        if ($_ENV['finance_public']) {
            Telegram::send(
                'گزارش مالی هفتگی تازه منتشر شده~' . PHP_EOL .
                'کل درآمد هفته گذشته:' . $income_count . PHP_EOL .
                'کل درآمد هفته گذشته:' . $income_total . PHP_EOL .
                'آخر هفته ها سخت کار کنید~'
            );
        }
    }

    public function month(): void
    {
        $datatables = new Datatables(new DatatablesHelper());
        $datatables->query(
            'select code.number from code
		where date_format(code.usedatetime,\'%Y-%m\')=date_format(date_sub(curdate(), interval 1 month),\'%Y-%m\') and code.type = -1 and code.isused= 1'
        );
        $text_json = $datatables->generate();
        $text_array = \json_decode($text_json, true);
        $codes = $text_array['data'];
        $text_html = '';
        $income_count = 0;
        $income_total = 0.00;
        foreach ($codes as $code) {
            ++$income_count;
            $income_total += $code['number'];
        }
        $text_html .= '<br>کل درآمد ماه گذشته：' . $income_count . '<br>مقدار کل درآمد در ماه گذشته：' . $income_total;

        $adminUser = User::where('is_admin', '=', '1')->get();
        foreach ($adminUser as $user) {
            echo 'Send offline mail to user: ' . $user->id;
            $user->sendMail(
                $_ENV['appName'] . '-گزارش مالی ماهانه',
                'news/finance.tpl',
                [
                    'title' => 'گزارش مالی ماهانه',
                    'text' => $text_html,
                ],
                []
            );
        }

        if ($_ENV['finance_public']) {
            Telegram::send(
                'گزارش مالی ماهانه تازه منتشر شده~' . PHP_EOL .
                'کل درآمد ماه گذشته:' . $income_count . PHP_EOL .
                'مقدار کل درآمد در ماه گذشته:' . $income_total . PHP_EOL .
                'همچنین در ابتدای ماه سخت کار می کنیم~'
            );
        }
    }
}
