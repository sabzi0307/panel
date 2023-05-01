<?php

declare(strict_types=1);

namespace App\Command;

use App\Models\Paylist;
use App\Models\User;
use App\Utils\Tools;
use function count;

final class FinanceMail extends Command
{
    public string $description = <<<EOL
├─=: php xcat FinanceMail [options]
│ ├─ day                     - daily
│ ├─ week                    - weekly
│ ├─ month                   - monthly report
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
        $today = strtotime('00:00:00');
        $paylists = Paylist::where('status', 1)->whereBetween('datetime', [strtotime('-1 day', $today), $today])->get();
        $text_html = '<table border=1><tr><td>مقدار</td><td>شناسه کاربر</td><td>نام کاربری</td><td>زمان شارژ مجدد</td>';

        foreach ($paylists as $paylist) {
            $text_html .= '<tr>';
            $text_html .= '<td>' . $paylist->total . '</td>';
            $text_html .= '<td>' . $paylist->userid . '</td>';
            $text_html .= '<td>' . User::find($paylist->userid)->user_name . '</td>';
            $text_html .= '<td>' . Tools::toDateTime((int) $paylist->datetime) . '</td>';
            $text_html .= '</tr>';
        }

        $text_html .= '</table>';
        $text_html .= '<br>کل درآمد دیروز：' . count($paylists) . '<br>کل درآمد دیروز：' . $paylists->sum('total');
        $adminUser = User::where('is_admin', '=', '1')->get();

        foreach ($adminUser as $user) {
            echo 'Sending email to admin user: ' . $user->id . PHP_EOL;
            $user->sendMail(
                $_ENV['appName'] . '-مالی روزانه',
                'finance.tpl',
                [
                    'title' => 'مالی روزانه',
                    'text' => $text_html,
                ],
                []
            );
        }
    }

    public function week(): void
    {
        $today = strtotime('00:00:00');
        $paylists = Paylist::where('status', 1)->whereBetween('datetime', [strtotime('-1 week', $today), $today])->get();

        $text_html = '<br>کل درآمد هفته گذشته：' . count($paylists) . '<br>کل درآمد هفته گذشته：' . $paylists->sum('total');
        $adminUser = User::where('is_admin', '=', '1')->get();

        foreach ($adminUser as $user) {
            echo 'Sending email to admin user: ' . $user->id . PHP_EOL;
            $user->sendMail(
                $_ENV['appName'] . '-گزارش مالی هفتگی',
                'finance.tpl',
                [
                    'title' => 'هفته نامه مالی',
                    'text' => $text_html,
                ],
                []
            );
        }
    }

    public function month(): void
    {
        $today = strtotime('00:00:00');
        $paylists = Paylist::where('status', 1)->whereBetween('datetime', [strtotime('-1 month', $today), $today])->get();

        $text_html = '<br>total income of last month:' . count($paylists) . '<br>total income of last month:' . $paylists->sum('total');
        $adminUser = User::where('is_admin', '=', '1')->get();

        foreach ($adminUser as $user) {
            echo 'Sending email to admin user: ' . $user->id . PHP_EOL;
            $user->sendMail(
                $_ENV['appName'] . '-گزارش مالی ماهانه',
                'finance.tpl',
                [
                    'title' => 'گزارش مالی ماهانه',
                    'text' => $text_html,
                ],
                []
            );
        }
    }
}
