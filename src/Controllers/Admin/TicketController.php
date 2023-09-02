<?php

declare(strict_types=1);

namespace App\Controllers\Admin;

use App\Controllers\BaseController;
use App\Models\Ticket;
use App\Models\User;
use App\Services\LLM;
use App\Services\Notification;
use App\Utils\Tools;
use Exception;
use GuzzleHttp\Exception\GuzzleException;
use Psr\Http\Client\ClientExceptionInterface;
use Psr\Http\Message\ResponseInterface;
use Slim\Http\Response;
use Slim\Http\ServerRequest;
use Telegram\Bot\Exceptions\TelegramSDKException;
use function array_merge;
use function count;
use function json_decode;
use function json_encode;
use function time;

final class TicketController extends BaseController
{
    public static array $details =
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
     * @throws Exception
     */
    public function index(ServerRequest $request, Response $response, array $args): Response|ResponseInterface
    {
        return $response->write(
            $this->view()
                ->assign('details', self::$details)
                ->fetch('admin/ticket/index.tpl')
        );
    }

    /**
     * @throws TelegramSDKException
     * @throws GuzzleException
     * @throws ClientExceptionInterface
     */
    public function update(ServerRequest $request, Response $response, array $args): Response|ResponseInterface
    {
        $id = $args['id'];
        $comment = $request->getParam('comment') ?? '';

        if ($comment === '') {
            return $response->withJson([
                'ret' => 0,
                'msg' => 'پاسخ تیکت نمی تواند خالی باشد',
            ]);
        }

        $ticket = Ticket::where('id', $id)->first();

        if ($ticket === null) {
            return $response->withJson([
                'ret' => 0,
                'msg' => 'تیکت وجود ندارد',
            ]);
        }

        $content_old = json_decode($ticket->content, true);
        $content_new = [
            [
                'comment_id' => $content_old[count($content_old) - 1]['comment_id'] + 1,
                'commenter_name' => 'Admin',
                'comment' => $comment,
                'datetime' => time(),
            ],
        ];

        $user = User::find($ticket->userid);

        Notification::notifyUser(
            $user,
            $_ENV['appName'] . '-بلیت پاسخ داده شده است',
            'سلام، یکی پاسخ داد<a href="' . $_ENV['baseUrl'] . '/user/ticket/' . $ticket->id . '/view">دستور کار</a>，لطفا آن را بررسی کنید.'
        );

        $ticket->content = json_encode(array_merge($content_old, $content_new));
        $ticket->status = 'open_wait_user';
        $ticket->save();

        return $response->withJson([
            'ret' => 1,
            'msg' => 'با موفقیت ثبت شد',
        ]);
    }

    /**
     * @throws GuzzleException
     * @throws TelegramSDKException
     * @throws ClientExceptionInterface
     */
    public function updateAI(ServerRequest $request, Response $response, array $args): Response|ResponseInterface
    {
        $id = $args['id'];

        $ticket = Ticket::where('id', $id)->first();

        if ($ticket === null) {
            return $response->withJson([
                'ret' => 0,
                'msg' => 'تیکت وجود ندارد',
            ]);
        }

        $content_old = json_decode($ticket->content, true);
        // 获取用户的第一个问题，作为 LLM 的输入
        $ai_reply = LLM::genTextResponse($content_old[0]['comment']);
        $content_new = [
            [
                'comment_id' => $content_old[count($content_old) - 1]['comment_id'] + 1,
                'commenter_name' => 'AI Admin',
                'comment' => $ai_reply,
                'datetime' => time(),
            ],
        ];

        $user = User::find($ticket->userid);

        Notification::notifyUser(
            $user,
            $_ENV['appName'] . '-تیکت پاسخ داده شده است',
            'سلام，هوش مصنوعی پاسخ داد<a href="' . $_ENV['baseUrl'] . '/user/ticket/' . $ticket->id . '/view">دستور کار</a>，لطفا آن را بررسی کنید.'
        );

        $ticket->content = json_encode(array_merge($content_old, $content_new));
        $ticket->status = 'open_wait_user';
        $ticket->save();

        return $response->withJson([
            'ret' => 1,
            'msg' => 'با موفقیت ثبت شد',
        ]);
    }

    /**
     * 后台查看指定工单
     *
     * @throws Exception
     */
    public function ticketView(ServerRequest $request, Response $response, array $args): Response|ResponseInterface
    {
        $id = $args['id'];
        $ticket = Ticket::where('id', '=', $id)->first();

        if ($ticket === null) {
            return $response->withRedirect('/admin/ticket');
        }

        $comments = json_decode($ticket->content);

        foreach ($comments as $comment) {
            $comment->datetime = Tools::toDateTime((int) $comment->datetime);
        }

        return $response->write(
            $this->view()
                ->assign('ticket', $ticket)
                ->assign('comments', $comments)
                ->fetch('admin/ticket/view.tpl')
        );
    }

    /**
     * 后台关闭工单
     */
    public function close(ServerRequest $request, Response $response, array $args): Response|ResponseInterface
    {
        $id = $args['id'];
        $ticket = Ticket::where('id', '=', $id)->first();

        if ($ticket === null) {
            return $response->withJson([
                'ret' => 0,
                'msg' => 'تیکت وجود ندارد',
            ]);
        }

        if ($ticket->status === 'closed') {
            return $response->withJson([
                'ret' => 0,
                'msg' => 'عملیات شکست خورد، تیکت بسته شد',
            ]);
        }

        $ticket->status = 'closed';
        $ticket->save();

        return $response->withJson([
            'ret' => 1,
            'msg' => 'با موفقیت بسته شد',
        ]);
    }

    /**
     * 后台删除工单
     */
    public function delete(ServerRequest $request, Response $response, array $args): Response|ResponseInterface
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
     */
    public function ajax(ServerRequest $request, Response $response, array $args): Response|ResponseInterface
    {
        $tickets = Ticket::orderBy('id', 'desc')->get();

        foreach ($tickets as $ticket) {
            $ticket->op = '<button type="button" class="btn btn-red" id="delete-ticket" 
            onclick="deleteTicket(' . $ticket->id . ')">حذف</button>';

            if ($ticket->status !== 'closed') {
                $ticket->op .= '
                <button type="button" class="btn btn-orange" id="close-ticket" 
                onclick="closeTicket(' . $ticket->id . ')">بستن</button>';
            }

            $ticket->op .= '
            <a class="btn btn-blue" href="/admin/ticket/' . $ticket->id . '/view">بررسی</a>';
            $ticket->status = $ticket->status();
            $ticket->type = $ticket->type();
            $ticket->datetime = Tools::toDateTime((int) $ticket->datetime);
        }

        return $response->withJson([
            'tickets' => $tickets,
        ]);
    }
}
