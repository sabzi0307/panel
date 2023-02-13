<?php

declare(strict_types=1);

namespace App\Controllers\Admin;

use App\Controllers\BaseController;
use App\Models\Ticket;
use App\Models\User;
use App\Utils\Tools;
use Slim\Http\Response;
use Slim\Http\ServerRequest;
use voku\helper\AntiXSS;

final class TicketController extends BaseController
{
    public static $details =
    [
        'field' => [
            'op' => 'شرح عملیات',
            'id' => 'شناسه بلیت',
            'title' => 'موضوع',
            'status' => 'وضعیت تیکت',
            'type' => 'نوع تیکت',
            'userid' => 'ارسال کاربر',
            'datetime' => 'زمان ایجاد',
        ],
    ];

    /**
     * 后台工单页面
     *
     * @param array     $args
     */
    public function index(ServerRequest $request, Response $response, array $args)
    {
        return $response->write(
            $this->view()
                ->assign('details', self::$details)
                ->fetch('admin/ticket/index.tpl')
        );
    }

    /**
     * 后台更新工单内容
     *
     * @param array     $args
     */
    public function update(ServerRequest $request, Response $response, array $args)
    {
        $id = $args['id'];
        $comment = $request->getParam('comment');

        if ($comment === '') {
            return $response->withJson([
                'ret' => 0,
                'msg' => 'ورود غیرمجاز',
            ]);
        }

        $ticket = Ticket::where('id', $id)->first();

        if ($ticket === null) {
            return $response->withStatus(302)->withHeader('Location', '/admin/ticket');
        }

        $antiXss = new AntiXSS();

        $content_old = \json_decode($ticket->content, true);
        $content_new = [
            [
                'comment_id' => $content_old[count($content_old) - 1]['comment_id'] + 1,
                'commenter_name' => 'Admin',
                'comment' => $antiXss->xss_clean($comment),
                'datetime' => \time(),
            ],
        ];

        $user = User::find($ticket->userid);
        $user->sendMail(
            $_ENV['appName'] . '-تیکت پاسخ داده شد',
            'news/warn.tpl',
            [
                'text' => 'سلام یکی جواب داد<a href="' . $_ENV['baseUrl'] . '/user/ticket/' . $ticket->id . '/view">دستور کار</a>，لطفا آن را بررسی کنید.',
            ],
            []
        );

        $ticket->content = \json_encode(\array_merge($content_old, $content_new));
        $ticket->status = 'open_wait_user';
        $ticket->save();

        return $response->withJson([
            'ret' => 1,
            'msg' => 'با موفقیت ذخیره شد',
        ]);
    }

    /**
     * 后台查看指定工单
     *
     * @param array     $args
     */
    public function ticketView(ServerRequest $request, Response $response, array $args)
    {
        $id = $args['id'];
        $ticket = Ticket::where('id', '=', $id)->first();
        $comments = \json_decode($ticket->content, true);

        if ($ticket === null) {
            return $response->withStatus(302)->withHeader('Location', '/user/ticket');
        }

        return $response->write(
            $this->view()
                ->assign('ticket', $ticket)
                ->assign('comments', $comments)
                ->registerClass('Tools', Tools::class)
                ->fetch('admin/ticket/view.tpl')
        );
    }

    /**
     * 后台关闭工单
     *
     * @param array     $args
     */
    public function close(ServerRequest $request, Response $response, array $args)
    {
        $id = $args['id'];
        $ticket = Ticket::where('id', '=', $id)->first();

        if ($ticket->status === 'closed') {
            return $response->withJson([
                'ret' => 0,
                'msg' => 'تیکت بسته است',
            ]);
        }

        $user = User::find($ticket->userid);
        $user->sendMail(
            $_ENV['appName'] . '-تیکت بسته است',
            'news/warn.tpl',
            [
                'text' => 'سلام تیکت شما #'. $ticket->id .' بسته شده است، اگر همچنان مشکل دارید، خوشحال می شویم یک تیکت جدید ارسال کنید.',
            ],
            []
        );

        $ticket->status = 'closed';
        $ticket->save();

        return $response->withJson([
            'ret' => 1,
            'msg' => 'با موفقیت بسته شد',
        ]);
    }

    /**
     * 后台删除工单
     *
     * @param array     $args
     */
    public function delete(ServerRequest $request, Response $response, array $args)
    {
        $id = $args['id'];
        Ticket::where('id', '=', $id)->delete();

        return $response->withJson([
            'ret' => 1,
            'msg' => 'با موفقیت حذف شد',
        ]);
    }

    /**
     * 后台工单页面 Ajax
     *
     * @param array     $args
     */
    public function ajax(ServerRequest $request, Response $response, array $args)
    {
        $tickets = Ticket::orderBy('id', 'desc')->get();

        foreach ($tickets as $ticket) {
            $ticket->op = '<button type="button" class="btn btn-red" id="delete-ticket" 
            onclick="deleteTicket(' . $ticket->id . ')">حذف</button>
            <button type="button" class="btn btn-orange" id="close-ticket" 
            onclick="closeTicket(' . $ticket->id . ')">بستن</button>
            <a class="btn btn-blue" href="/admin/ticket/' . $ticket->id . '/view">بررسی</a>';
            $ticket->status = Tools::getTicketStatus($ticket);
            $ticket->type = Tools::getTicketType($ticket);
            $ticket->datetime = Tools::toDateTime((int) $ticket->datetime);
        }

        return $response->withJson([
            'tickets' => $tickets,
        ]);
    }
}
