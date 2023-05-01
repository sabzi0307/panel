<?php

declare(strict_types=1);

namespace App\Command;

use Exception;
use GuzzleHttp\Client;
use function json_decode;
use function json_encode;
use function time;

/**
 * 世界这么大，何必要让它更艰难呢？
 *
 * By GeekQuerxy
 */
final class ClientDownload extends Command
{
    public string $description = '├─=: php xcat ClientDownload - regularly update the client' . PHP_EOL;

    private $client;

    /**
     * 保存基本路径
     */
    private string $basePath = BASE_PATH . '/';

    /**
     * 下载配置
     */
    private $version;

    public function boot(): void
    {
        $this->client = new Client();
        $this->version = $this->getLocalVersions();
        $clientsPath = BASE_PATH . '/conf/clients.json';
        if (! is_file($clientsPath)) {
            echo 'clients.json does not exist, the script aborts.' . PHP_EOL;
            exit(0);
        }
        $clients = json_decode(file_get_contents($clientsPath), true);
        foreach ($clients['clients'] as $client) {
            $this->getSoft($client);
        }
    }

    /**
     * 下载远程文件
     */
    private function getSourceFile(string $fileName, string $savePath, string $url): bool
    {
        try {
            if (! file_exists($savePath)) {
                echo 'target folder ' . $savePath . ' does not exist, creating...' . PHP_EOL;
                system('mkdir ' . $savePath);
            }
            echo '- start download ' . $fileName . '...' . PHP_EOL;
            $request = $this->client->get($url);
            echo '- download ' . $fileName . ' successful, saving...' . PHP_EOL;
            $result = file_put_contents($savePath . $fileName, $request->getBody()->getContents());
            if ($result === false) {
                echo '- keep ' . $fileName . ' to ' . $savePath . ' fail.' . PHP_EOL;
            } else {
                echo '- keep ' . $fileName . ' to ' . $savePath . ' success.' . PHP_EOL;
                system('chown ' . $_ENV['php_user_group'] . ' ' . $savePath . $fileName);
            }
            return true;
        } catch (Exception $e) {
            echo '- download ' . $fileName . ' fail...' . PHP_EOL;
            echo $e->getMessage() . PHP_EOL;
            return false;
        }
    }

    /**
     * 获取 GitHub 常规 Release
     */
    private function getLatestReleaseTagName(string $repo): string
    {
        $url = 'https://api.github.com/repos/' . $repo . '/releases/latest' . ($_ENV['github_access_token'] !== '' ? '?access_token=' . $_ENV['github_access_token'] : '');
        $request = $this->client->get($url);
        return (string) json_decode(
            $request->getBody()->getContents(),
            true
        )['tag_name'];
    }

    /**
     * 获取 GitHub Pre-Release
     */
    private function getLatestPreReleaseTagName(string $repo): string
    {
        $url = 'https://api.github.com/repos/' . $repo . '/releases' . ($_ENV['github_access_token'] !== '' ? '?access_token=' . $_ENV['github_access_token'] : '');
        $request = $this->client->get($url);
        $latest = json_decode(
            $request->getBody()->getContents(),
            true
        )[0];
        return (string) $latest['tag_name'];
    }

    /**
     * 获取 Apkpure TagName
     */
    private function getApkpureTagName(string $url): string
    {
        $request = $this->client->get($url);
        preg_match('#(?<=\<span\sitemprop="version">)[^<]+#', $request->getBody()->getContents(), $tagName);
        preg_match('#[\d\.]+#', $tagName[0], $tagNum);
        return $tagNum[0];
    }

    /**
     * 判断是否 JSON
     */
    private function isJson(string $string): bool
    {
        return json_decode($string, true) !== false;
    }

    /**
     * 获取本地软体版本库
     *
     * @return array
     */
    private function getLocalVersions(): array
    {
        $fileName = 'LocalClientVersion.json';
        $filePath = BASE_PATH . '/storage/' . $fileName;
        if (! is_file($filePath)) {
            echo 'local software repository LocalClientVersion.json does not exist, create the file...' . PHP_EOL;
            $result = file_put_contents(
                $filePath,
                json_encode(
                    [
                        'createTime' => time(),
                    ]
                )
            );
            if ($result === false) {
                echo 'LocalClientVersion.json Creation failed, script aborted.' . PHP_EOL;
                exit(0);
            }
        }
        $fileContent = file_get_contents($filePath);
        if (! $this->isJson($fileContent)) {
            echo 'LocalClientVersion.json File format exception, script aborted.' . PHP_EOL;
            exit(0);
        }
        return json_decode($fileContent, true);
    }

    /**
     * 储存本地软体版本库
     */
    private function setLocalVersions(array $versions): void
    {
        $fileName = 'LocalClientVersion.json';
        $filePath = BASE_PATH . '/storage/' . $fileName;
        (bool) file_put_contents(
            $filePath,
            json_encode(
                $versions
            )
        );
    }

    private function getSoft(array $task): void
    {
        $savePath = $this->basePath . $task['savePath'];
        echo '====== ' . $task['name'] . ' start ======' . PHP_EOL;
        $tagMethod = match ($task['tagMethod']) {
            'github_pre_release' => 'getLatestPreReleaseTagName',
            'apkpure' => 'getApkpureTagName',
            default => 'getLatestReleaseTagName',
        };
        $tagName = $this->$tagMethod($task['gitRepo']);
        if (! isset($this->version[$task['name']])) {
            echo '- does not exist locally ' . $task['name'] . '，The current latest version detected is ' . $tagName . PHP_EOL;
        } else {
            if ($tagName === $this->version[$task['name']]) {
                echo '- detected current ' . $task['name'] . ' The latest version is consistent with the local version, skip this task.' . PHP_EOL;
                echo '====== ' . $task['name'] . ' End ======' . PHP_EOL;
                return;
            }
            echo '- detected current ' . $task['name'] . ' The latest version is ' . $tagName . '，The latest local version is ' . $this->version[$task['name']] . PHP_EOL;
        }
        $this->version[$task['name']] = $tagName;
        $nameFunction = static function ($name) use ($task, $tagName) {
            return str_replace(
                [
                    '%taskName%',
                    '%tagName%',
                    '%tagName1%',
                ],
                [
                    $task['name'],
                    $tagName,
                    substr($tagName, 1),
                ],
                $name
            );
        };
        foreach ($task['downloads'] as $download) {
            $fileName = $nameFunction(($download['saveName'] !== '' ? $download['saveName'] : $download['sourceName']));
            $sourceName = $nameFunction($download['sourceName']);
            $filePath = $savePath . $fileName;
            if (is_file($filePath)) {
                echo '- Deleting old versions of files...' . PHP_EOL;
                if (! unlink($filePath)) {
                    echo '- Failed to delete the old version file, this task is skipped, please check permissions, etc....' . PHP_EOL;
                    continue;
                }
            }
            if ($task['tagMethod'] === 'apkpure') {
                $request = $this->client->get($download['apkpureUrl']);
                preg_match('#(?<=href=")https:\/\/download\.apkpure\.com\/b\/APK[^"]+#', $request->getBody()->getContents(), $downloadUrl);
                $downloadUrl = $downloadUrl[0];
            } else {
                $downloadUrl = 'https://github.com/' . $task['gitRepo'] . '/releases/download/' . $tagName . '/' . $sourceName;
            }
            if ($this->getSourceFile($fileName, $savePath, $downloadUrl)) {
                $this->setLocalVersions($this->version);
            }
        }
        echo '====== ' . $task['name'] . ' End ======' . PHP_EOL;
    }
}
