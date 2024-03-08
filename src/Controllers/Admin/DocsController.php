<?php

declare(strict_types=1);

namespace App\Controllers\Admin;

use App\Controllers\BaseController;
use App\Models\Docs;
use App\Services\LLM;
use App\Utils\Tools;
use Exception;
use GuzzleHttp\Exception\GuzzleException;
use Psr\Http\Message\ResponseInterface;
use Slim\Http\Response;
use Slim\Http\ServerRequest;
use function time;

final class DocsController extends BaseController
{
    private static array $details =
        [
            'field' => [
                'op' => 'اقدام',
                'id' => 'ID',
                'date' => 'تاریخ',
                'title' => 'عنوان',
            ],
        ];

    /**
     * 后台文档页面
     *
     * @throws Exception
     */
    public function index(ServerRequest $request, Response $response, array $args): Response|ResponseInterface
    {
        return $response->write(
            $this->view()
                ->assign('details', self::$details)
                ->fetch('admin/docs/index.tpl')
        );
    }

    /**
     * 后台文档创建页面
     *
     * @throws Exception
     */
    public function create(ServerRequest $request, Response $response, array $args): Response|ResponseInterface
    {
        return $response->write(
            $this->view()
                ->fetch('admin/docs/create.tpl')
        );
    }

    /**
     * 后台添加文档
     */
    public function add(ServerRequest $request, Response $response, array $args): Response|ResponseInterface
    {
        $title = $request->getParam('title');
        $content = $request->getParam('content');

        if ($content === '' || $title === '') {
            return $response->withJson([
                'ret' => 0,
                'msg' => 'عنوان یا محتوای سند نمی تواند خالی باشد',
            ]);
        }

        $doc = new Docs();
        $doc->date = Tools::toDateTime(time());
        $doc->title = $title;
        $doc->content = $content;

        if (! $doc->save()) {
            return $response->withJson([
                'ret' => 0,
                'msg' => 'سند اضافه نشد',
            ]);
        }

        return $response->withJson([
            'ret' => 1,
            'msg' => 'سند با موفقیت اضافه شد',
        ]);
    }

    /**
     * 使用LLM生成文档
     *
     * @throws GuzzleException
     */
    public function generate(ServerRequest $request, Response $response, array $args): Response|ResponseInterface
    {
        $content = LLM::genTextResponse($request->getParam('question'));

        return $response->withJson([
            'ret' => 1,
            'msg' => 'سند با موفقیت ایجاد شد',
            'content' => $content,
        ]);
    }

    /**
     * 文档编辑页面
     *
     * @throws Exception
     */
    public function edit(ServerRequest $request, Response $response, array $args): Response|ResponseInterface
    {
        $doc = (new Docs())->find($args['id']);

        return $response->write(
            $this->view()
                ->assign('doc', $doc)
                ->fetch('admin/docs/edit.tpl')
        );
    }

    /**
     * 后台编辑文档提交
     */
    public function update(ServerRequest $request, Response $response, array $args): Response|ResponseInterface
    {
        $doc = (new Docs())->find($args['id']);
        $doc->title = $request->getParam('title');
        $doc->content = $request->getParam('content');
        $doc->date = Tools::toDateTime(time());

        if (! $doc->save()) {
            return $response->withJson([
                'ret' => 0,
                'msg' => 'به‌روزرسانی مطلب انجام نشد',
            ]);
        }

        return $response->withJson([
            'ret' => 1,
            'msg' => 'مطلب با موفقیت به روز شد',
        ]);
    }

    /**
     * 后台删除文档
     */
    public function delete(ServerRequest $request, Response $response, array $args): Response|ResponseInterface
    {
        $doc = (new Docs())->find($args['id']);

        if (! $doc->delete()) {
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

    /**
     * 后台文档页面 AJAX
     */
    public function ajax(ServerRequest $request, Response $response, array $args): Response|ResponseInterface
    {
        $docs = (new Docs())->orderBy('id')->get();

        foreach ($docs as $doc) {
            $doc->op = '<button type="button" class="btn btn-red" id="delete-doc-' . $doc->id . '" 
            onclick="deleteDoc(' . $doc->id . ')">حذف</button>
            <a class="btn btn-blue" href="/admin/docs/' . $doc->id . '/edit">ویرایش</a>';
        }

        return $response->withJson([
            'docs' => $docs,
        ]);
    }
}
