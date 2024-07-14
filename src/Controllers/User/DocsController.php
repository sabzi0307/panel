<?php

declare(strict_types=1);

namespace App\Controllers\User;

use App\Controllers\BaseController;
use App\Models\Config;
use App\Models\Docs;
use App\Utils\Tools;
use DOMDocument;
use DOMXPath;
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
     * Fetch the markdown content from a URL.
     *
     * @param string $url
     * @return string
     * @throws Exception
     */
    private function fetchMarkdownFromUrl(string $url): string
    {
        // Check if the URL is a GitHub Wiki URL
        if (preg_match("/^https:\/\/github.com\/(.+)\/wiki\/(.+)/", $url, $matches)) {
            return $this->fetchGithubWikiMarkdown($url);
        }

        // For other URLs, fetch the content directly
        $content = file_get_contents($url);
        if ($content === false) {
            throw new Exception("Unable to fetch content from URL: $url");
        }

        return $content;
    }

    /**
     * Fetch markdown content from a GitHub Wiki page.
     *
     * @param string $url
     * @return string
     * @throws Exception
     */
    private function fetchGithubWikiMarkdown(string $url): string
    {
        // Encode the URL properly
        $encodedUrl = $this->encodeGithubWikiUrl($url);

        // Fetch the HTML content
        $htmlContent = file_get_contents($encodedUrl);
        if ($htmlContent === false) {
            throw new Exception("Unable to fetch content from GitHub Wiki URL: $url");
        }

        // Extract the main content from the HTML
        $doc = new \DOMDocument();
        @$doc->loadHTML($htmlContent);
        $xpath = new \DOMXPath($doc);

        // Extract the content inside the 'wiki-body' div, excluding 'wiki-footer'
        $nodeList = $xpath->query("//div[@id='wiki-body']");
        if ($nodeList->length === 0) {
            throw new Exception("Unable to find wiki content in GitHub Wiki URL: $url");
        }

        // Get the content of 'wiki-body'
        $contentDiv = $nodeList->item(0);

        // Remove 'wiki-footer' if it exists
        $footerNode = $xpath->query(".//div[contains(@class, 'wiki-footer')]", $contentDiv)->item(0);
        if ($footerNode) {
            $footerNode->parentNode->removeChild($footerNode);
        }

        // Get the remaining HTML content
        $markdownContent = $doc->saveHTML($contentDiv);
        // Remove the closing </div> tag if it exists
        $markdownContent = preg_replace('/<\/div>\s*$/', '', $markdownContent);

        return $markdownContent;
    }

    /**
     * Encode GitHub Wiki URL.
     *
     * @param string $url
     * @return string
     */
    function encodeGithubWikiUrl(string $url): string
    {
        // Extract the base URL and page title
        if (preg_match("/^(https:\/\/github.com\/.+\/wiki\/)(.+)$/", $url, $matches)) {
            $baseUrl = $matches[1];
            $pageTitle = $matches[2];

            // Decode the page title before encoding to avoid double encoding
            $decodedTitle = rawurldecode($pageTitle);
            $encodedTitle = rawurlencode($decodedTitle);

            return $baseUrl . $encodedTitle;
        }

        return $url;
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
