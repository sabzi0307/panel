<?php

declare(strict_types=1);

namespace App\Controllers\Admin;

use App\Controllers\BaseController;
use App\Models\DetectRule;
use App\Services\IM\Telegram;
use Exception;
use Psr\Http\Message\ResponseInterface;
use Slim\Http\Response;
use Slim\Http\ServerRequest;
use Telegram\Bot\Exceptions\TelegramSDKException;

final class DetectRuleController extends BaseController
{
    private static array $details =
        [
            'field' => [
                'op' => 'اقدام',
                'id' => 'شناسه قانون',
                'name' => 'نام قانون',
                'text' => 'معرفی قانون',
                'regex' => 'عبارت منظم',
                'type' => 'نوع قانون',
            ],
            'add_dialog' => [
                [
                    'id' => 'name',
                    'info' => 'نام قانون',
                    'type' => 'input',
                    'placeholder' => 'نام قانون ممیزی',
                ],
                [
                    'id' => 'text',
                    'info' => 'معرفی قانون',
                    'type' => 'input',
                    'placeholder' => 'قوانین ممیزی را بطور مختصر و واضح شرح دهید',
                ],
                [
                    'id' => 'regex',
                    'info' => 'عبارت منظم',
                    'type' => 'input',
                    'placeholder' => 'بیان منظم برای مطابقت با محتوای ممیزی',
                ],
                [
                    'id' => 'type',
                    'info' => 'نوع قانون',
                    'type' => 'select',
                    'select' => [
                        '1' => 'تطبیق متن ساده بسته',
                        '0' => 'تطبیق هگزا بسته',
                    ],
                ],
            ],
        ];

    /**
     * @throws Exception
     */
    public function index(ServerRequest $request, Response $response, array $args): Response|ResponseInterface
    {
        return $response->write(
            $this->view()
                ->assign('details', self::$details)
                ->fetch('admin/detect.tpl')
        );
    }

    /**
     * @throws TelegramSDKException
     */
    public function add(ServerRequest $request, Response $response, array $args): Response|ResponseInterface
    {
        $rule = new DetectRule();
        $rule->name = $request->getParam('name');
        $rule->text = $request->getParam('text');
        $rule->regex = $request->getParam('regex');
        $rule->type = $request->getParam('type');

        if (! $rule->save()) {
            return $response->withJson([
                'ret' => 0,
                'msg' => 'افزودن ناموفق بود',
            ]);
        }

        (new Telegram())->sendMarkdown(0, 'قوانین ممیزی جدید وجود دارد:' . $rule->name);
        return $response->withJson([
            'ret' => 1,
            'msg' => 'با موفقیت اضافه شد',
        ]);
    }

    public function delete(ServerRequest $request, Response $response, array $args): Response|ResponseInterface
    {
        $id = $args['id'];
        $rule = (new DetectRule())->find($id);
        if (! $rule->delete()) {
            return $response->withJson([
                'ret' => 0,
                'msg' => 'حذف نشد',
            ]);
        }
        return $response->withJson([
            'ret' => 1,
            'msg' => 'با موفقیت حذف شد',
        ]);
    }

    public function ajax(ServerRequest $request, Response $response, array $args): Response|ResponseInterface
    {
        $rules = (new DetectRule())->orderBy('id', 'desc')->get();

        foreach ($rules as $rule) {
            $rule->op = '<button type="button" class="btn btn-red" id="delete-rule-' . $rule->id .
                '" onclick="deleteRule(' . $rule->id . ')">حذف</button>';
            $rule->type = $rule->type();
        }

        return $response->withJson([
            'rules' => $rules,
        ]);
    }
}
