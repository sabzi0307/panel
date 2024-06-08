<?php

declare(strict_types=1);

namespace App\Services\Bot\Telegram;

use DOMDocument;
use DOMXPath;

final class CheckTransaction
{
    public static function checkBNBCryptoPayment($transaction_id)
    {
        // URL of the page to fetch
       // $url = 'https://bscscan.com/tx/0x728277c2c5041bd7728f9ec0cbbc6d466913921d9889ac4fc9596fcd954bdff8';
        $url = 'https://bscscan.com/tx/'.$transaction_id;

        // Use file_get_contents to get the HTML content of the page
        $html = file_get_contents($url);

        if ($html === FALSE) {
            die("Error fetching the HTML content from the URL.");
        }

        // Create a new DOMDocument instance
        $doc = new DOMDocument();

        // Suppress warnings due to malformed HTML
        libxml_use_internal_errors(true);

        // Load the HTML content into the DOMDocument instance
        $doc->loadHTML($html);

        // Clear the libxml error buffer
        libxml_clear_errors();

        // Create a new DOMXPath instance
        $xpath = new DOMXPath($doc);

        // Extract the transaction status
        $status = $xpath->query("//span[contains(@id, 'ContentPlaceHolder1_spanTxStatus')]");

        if ($status->length > 0) {
            echo "Status: " . $status->item(0)->textContent . "\n";
        } else {
            echo "Status not found.\n";
        }

        // Extract BEP-20 tokens transferred
        $tokensTransferred = $xpath->query("//div[@id='ContentPlaceHolder1_maintable']//span[contains(@class, 'text-success')]/parent::td/following-sibling::td[1]");

        if ($tokensTransferred->length > 0) {
            echo "BEP-20 Tokens Transferred:\n";
            foreach ($tokensTransferred as $token) {
                $from = $token->textContent;
                $to = $token->nextSibling->textContent;
                echo "From: $from, To: $to\n";
            }
        } else {
            echo "No BEP-20 Tokens Transferred found.\n";
        }

        return array('amount'=>0);
    }
}
