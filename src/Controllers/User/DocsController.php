<?php

declare(strict_types=1);

namespace App\Controllers\User;

use App\Controllers\BaseController;
use App\Models\Config;
use App\Models\Docs;
use App\Utils\Tools;
use Exception;
use Psr\Http\Message\ResponseInterface;
use Slim\Http\Response;
use Slim\Http\ServerRequest;

final class DocsController extends BaseController
{
    /**
     * @throws Exception
     */
    public function index(ServerRequest $request, Response $response, array $args): Response|ResponseInterface
    {
        if (!Config::obtain('display_docs') ||
            (Config::obtain('display_docs_only_for_paid_user') && $this->user->class === 0)) {
            return $response->withRedirect('/user');
        }

        $docs = (new Docs())->orderBy('id', 'desc')->get();
        foreach ($docs as $doc) {
            $doc->date = Tools::toDateTime($doc->date);
        }

        return $response->write(
            $this->view()
                ->assign('docs', $docs)
                ->fetch('user/docs/index.tpl')
        );
    }

    /**
     * 解析并获取URL内容
     */
    private function fetchMarkdownFromUrl(string $url): string
    {
        $content = file_get_contents($url);
        if ($content === false) {
            throw new Exception("Unable to fetch content from URL: $url");
        }

        return $content;
    }

    /**
     * 文档详情页面
     *
     * @throws Exception
     */
    public function detail(ServerRequest $request, Response $response, array $args): Response|ResponseInterface
    {
        $doc = (new Docs())->find($args['id']);
        if ($doc->url !== '') {
            try {
                $doc->content = $this->fetchMarkdownFromUrl($doc->url);
                
                if ($doc->content !== '') {

                    $doc->isMarkdown = 1;
                }
            } catch (Exception $e) {
                return $response->withJson([
                    'ret' => 0,
                    'msg' => 'خطا در دریافت محتوا از URL: ' . $e->getMessage(),
                ]);
            }
        }

        return $response->write(
            $this->view()
                ->assign('doc', $doc)
                ->fetch('user/docs/view.tpl')
        );
    }
}
