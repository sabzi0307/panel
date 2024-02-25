<?php

declare(strict_types=1);

namespace App\Command;

use App\Services\Cloudflare;
use App\Utils\Tools;
use GuzzleHttp\Client;
use GuzzleHttp\Exception\GuzzleException;
use function file_exists;
use function file_get_contents;
use function file_put_contents;
use function get_current_user;
use function is_file;
use function json_decode;
use function json_encode;
use function posix_geteuid;
use function posix_getpwuid;
use function str_replace;
use function substr;
use function time;
use function unlink;
use const BASE_PATH;
use const PHP_EOL;

final class ClientDownload extends Command
{
    public string $description = '├─=: php xcat ClientDownload - regularly update the client' . PHP_EOL;
    private Client $client;
    private string $basePath = BASE_PATH . '/';
    private array $version;

    /**
     * @throws GuzzleException
     */
    public function boot(): void
    {
        $this->client = new Client();
        $this->version = $this->getLocalVersions();
        $clientsPath = BASE_PATH . '/conf/clients.json';

        if (! is_file($clientsPath)) {
            echo 'clients.json does not exist, the script aborts.' . PHP_EOL;
            exit(0);
        }

        $runningUser = posix_getpwuid(posix_geteuid())['name'];
        $fileOwner = get_current_user();

        if ($runningUser !== $fileOwner) {
            echo 'current user is ' . $runningUser . ', with the file owner ' . $fileOwner . ' If it does not match, the script aborts.' . PHP_EOL;
            exit(0);
        }

        $clients = json_decode(file_get_contents($clientsPath), true);

        foreach ($clients['clients'] as $client) {
            $this->getSoft($client);
        }
    }

    /**
     * 下载远程文件
     *
     * @param string $fileName
     * @param string $savePath
     * @param string $url
     */
    private function getSourceFile(string $fileName, string $savePath, string $url): bool
    {
        try {
            if (! file_exists($savePath)) {
                echo 'target folder ' . $savePath . ' does not exist, the download failed.' . PHP_EOL;
                return false;
            }

            echo '- start download ' . $fileName . '...' . PHP_EOL;
            $request = $this->client->get($url);
            echo '- download ' . $fileName . ' successful, saving...' . PHP_EOL;
            $result = file_put_contents($savePath . $fileName, $request->getBody()->getContents());

            if (! $result) {
                echo '- keep ' . $fileName . ' to ' . $savePath . ' fail.' . PHP_EOL;
            } else {
                echo '- keep ' . $fileName . ' to ' . $savePath . ' success.' . PHP_EOL;
            }

            return true;
        } catch (GuzzleException $e) {
            echo '- download ' . $fileName . ' fail...' . PHP_EOL;
            echo $e->getMessage() . PHP_EOL;

            return false;
        }
    }

    /**
     * 获取 GitHub 常规 Release
     *
     * @param string $repo
     *
     * @throws GuzzleException
     */
    private function getLatestReleaseTagName(string $repo): string
    {
        $url = 'https://api.github.com/repos/' . $repo . '/releases/latest' .
            ($_ENV['github_access_token'] !== '' ? '?access_token=' . $_ENV['github_access_token'] : '');
        $request = $this->client->get($url);

        return json_decode(
            $request->getBody()->getContents(),
            true
        )['tag_name'];
    }

    /**
     * 获取 GitHub Pre-Release
     *
     * @param string $repo
     *
     * @throws GuzzleException
     */
    private function getLatestPreReleaseTagName(string $repo): string
    {
        $url = 'https://api.github.com/repos/' . $repo . '/releases' .
            ($_ENV['github_access_token'] !== '' ? '?access_token=' . $_ENV['github_access_token'] : '');
        $request = $this->client->get($url);
        $latest = json_decode(
            $request->getBody()->getContents(),
            true
        )[0];

        return $latest['tag_name'];
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

            if (! $result) {
                echo 'LocalClientVersion.json Creation failed, script aborted.' . PHP_EOL;
                exit(0);
            }
        }

        $fileContent = file_get_contents($filePath);

        if (! Tools::isJson($fileContent)) {
            echo 'LocalClientVersion.json File format exception, script aborted.' . PHP_EOL;
            exit(0);
        }

        return json_decode($fileContent, true);
    }

    /**
     * 储存本地软体版本库
     *
     * @param array $versions
     */
    private function setLocalVersions(array $versions): void
    {
        $fileName = 'LocalClientVersion.json';
        $filePath = BASE_PATH . '/storage/' . $fileName;

        file_put_contents(
            $filePath,
            json_encode(
                $versions
            )
        );
    }

    /**
     * @param $name
     * @param $taskName
     * @param $tagName
     */
    private static function getNames($name, $taskName, $tagName): array|string
    {
        return str_replace(
            [
                '%taskName%',
                '%tagName%',
                '%tagName1%',
            ],
            [
                $taskName,
                $tagName,
                substr($tagName, 1),
            ],
            $name
        );
    }

    /**
     * @param array $task
     *
     * @throws GuzzleException
     */
    private function getSoft(array $task): void
    {
        $savePath = $this->basePath . $task['savePath'];
        echo '====== ' . $task['name'] . ' start ======' . PHP_EOL;

        $tagName = match ($task['tagMethod']) {
            'github_pre_release' => self::getLatestPreReleaseTagName($task['gitRepo']),
            default => self::getLatestReleaseTagName($task['gitRepo']),
        };

        if (! isset($this->version[$task['name']])) {
            echo '- does not exist locally ' . $task['name'] . '，The current latest version detected is ' . $tagName . PHP_EOL;
        } else {
            if ($tagName === $this->version[$task['name']]) {
                echo '- detected current ' . $task['name'] . ' The latest version is consistent with the local version, skip this task.' . PHP_EOL;
                echo '====== ' . $task['name'] . ' End ======' . PHP_EOL;
                return;
            }
            echo '- detected current ' . $task['name'] . ' The latest version is ' .
                $tagName . '，The latest local version is ' . $this->version[$task['name']] . PHP_EOL;
        }

        $this->version[$task['name']] = $tagName;

        foreach ($task['downloads'] as $download) {
            $fileName = $download['saveName'] !== '' ? $download['saveName'] : $download['sourceName'];
            $fileName = self::getNames($fileName, $task['name'], $tagName);
            $sourceName = self::getNames($download['sourceName'], $task['name'], $tagName);
            $filePath = $savePath . $fileName;

            echo '- Deleting old versions of files...' . PHP_EOL;

            if (file_exists($filePath) && ! unlink($filePath)) {
                echo '- فایل نسخه قدیمی حذف نشد، این کار نادیده گرفته شد، لطفاً مجوزها را بررسی کنید' . PHP_EOL;
                continue;
            }

            $downloadUrl = 'https://github.com/' . $task['gitRepo'] .
                '/releases/download/' . $tagName . '/' . $sourceName;

            if ($this->getSourceFile($fileName, $savePath, $downloadUrl)) {
                $this->setLocalVersions($this->version);
            }

            if ($_ENV['enable_r2_client_download']) {
                Cloudflare::uploadR2($fileName, file_get_contents($filePath));
                unlink($filePath);
            }
        }

        echo '====== ' . $task['name'] . ' End ======' . PHP_EOL;
    }
}
