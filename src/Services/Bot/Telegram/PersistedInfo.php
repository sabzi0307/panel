<?php

declare(strict_types=1);

namespace App\Services\Bot\Telegram;

use App\Models\GiftCard;
use App\Models\Invoice;
use App\Models\Order;
use App\Models\User;
use App\Models\Product;
use App\Models\TelegramBotLog;
use App\Models\TelegramBotState;
use App\Models\UserCoupon;
use App\Models\UserMoneyLog;
use DOMDocument;
use DOMXPath;
use Fastly\Model\Stats;
use Illuminate\Database\Eloquent\Model;

final class PersistedInfo
{



    /**
     * 搜索用户
     *
     * @param int $value  搜索值
     * @param string $method 查找列
     */
    public static function getUser(int $value, string $method = 'im_value'): null|Model|User
    {
        return (new User())->where('im_type', 4)->where($method, $value)->first();
    }

    public static function getProducts()
    {
        return (new Product())->where('status', '1')->orderBy('id')->get();
    }


    public static function getProduct(int $id): Product
    {
        return (new Product())->where('id', $id)->first();
    }

    public static function processInvoice($product, $coupon_raw, $user)
    {
        $err_msg = 'ایجاد سفارش ناموفق بود';
        $buy_price = $product->price;


        if ($user->is_shadow_banned) {
            //return error message
        }

        if ($coupon_raw !== '') {
            $coupon = (new UserCoupon())->where('code', $coupon_raw)->first();

            if ($coupon === null || ($coupon->expire_time !== 0 && $coupon->expire_time < time())) {
                //return error message
            }

            $coupon_limit = json_decode($coupon->limit);

            if ($coupon_limit->disabled) {
                //return error message
            }

            if ($coupon_limit->product_id !== '' && !in_array($product->id, explode(',', $coupon_limit->product_id))) {
                //return error message
            }

            $coupon_use_limit = $coupon_limit->use_time;

            if ($coupon_use_limit > 0) {
                $user_use_count = (new Order())->where('user_id', $user->id)->where('coupon', $coupon->code)->count();
                if ($user_use_count >= $coupon_use_limit) {
                    //return error message
                }
            }

            if (property_exists($coupon_limit, 'total_use_time')) {
                $coupon_total_use_limit = $coupon_limit->total_use_time;
            } else {
                $coupon_total_use_limit = -1;
            }

            if ($coupon_total_use_limit > 0 && $coupon->use_count >= $coupon_total_use_limit) {
                //return error message
            }

            $content = json_decode($coupon->content);

            if ($content->type === 'percentage') {
                $discount = $product->price * $content->value / 100;
            } else {
                $discount = $content->value;
            }

            $buy_price = $product->price - $discount;
        }

        $product_limit = json_decode($product->limit);

        if ($product_limit->class_required !== '' && $user->class < (int) $product_limit->class_required) {
            //return error message
        }

        if (
            $product_limit->node_group_required !== ''
            && $user->node_group !== (int) $product_limit->node_group_required
        ) {
            //return error message
        }

        if ($product_limit->new_user_required !== 0) {
            $order_count = (new Order())->where('user_id', $user->id)->count();
            if ($order_count > 0) {
                //return error message
            }
        }

        $order = new Order();
        $order->user_id = $user->id;
        $order->product_id = $product->id;
        $order->product_type = $product->type;
        $order->product_name = $product->name;
        $order->product_content = $product->content;
        $order->coupon = $coupon_raw;
        $order->price = $buy_price;
        $order->status = 'pending_payment';
        $order->create_time = time();
        $order->update_time = time();
        $order->save();

        $invoice_content = [];

        $invoice_content[] = [
            'content_id' => 0,
            'name' => $product->name,
            'price' => $product->price,
        ];

        if ($coupon_raw !== '') {
            $invoice_content[] = [
                'content_id' => 1,
                'name' => 'کد تخفیف ' . $coupon_raw,
                'price' => '-' . $discount,
            ];
        }

        $invoice = new Invoice();
        $invoice->user_id = $user->id;
        $invoice->order_id = $order->id;
        $invoice->content = json_encode($invoice_content);
        $invoice->price = $buy_price;
        $invoice->status = 'unpaid';
        $invoice->create_time = time();
        $invoice->update_time = time();
        $invoice->pay_time = 0;
        $invoice->save();

        if ($product->stock > 0) {
            $product->stock -= 1;
        }
        $product->sale_count += 1;
        $product->save();

        if ($coupon_raw !== '') {
            $coupon->use_count += 1;
            $coupon->save();
        }

        $money_before = $user->money;
        $user->money -= $invoice->price;
        $user->save();

        (new UserMoneyLog())->add(
            $user->id,
            $money_before,
            (float) $user->money,
            -$invoice->price,
            'پرداخت صورت حساب #' . $invoice->id
        );

        $invoice->status = 'paid_balance';
        $invoice->update_time = time();
        $invoice->pay_time = time();
        $invoice->save();
    }

    public static function applyGiftCard(string $giftcard_raw, $user)
    {
        $giftcard = (new GiftCard())->where('card', $giftcard_raw)->first();

        if ($giftcard === null || $giftcard->status !== 0 || $user->is_shadow_banned) {
          
            return null;
        }
       

        $giftcard->status = 1;
        $giftcard->use_time = time();
        $giftcard->use_user = $user->id;
        $giftcard->save();

        $money_before = $user->money;
        $user->money += $giftcard->balance;
        $user->save();

        (new UserMoneyLog())->add(
            $user->id,
            $money_before,
            (float) $user->money,
            $giftcard->balance,
            'شارژ کارت هدیه ' . $giftcard->card
        );


        
        return $giftcard;
    }
    public function applyCryptoPayment($transaction_id, $user)
    {
        $paymentResult = $this->checkBNBCryptoPayment($transaction_id);

        $money_before = $user->money;
        $user->money += $paymentResult['balance'];
        $user->save();

        (new UserMoneyLog())->add(
            $user->id,
            $money_before,
            (float) $user->money,
            $paymentResult['balance'],
            'شارژ انتقال تتر در بایننس. شماره تراکنش:  ' . $transaction_id
        );
    }

    public static function checkBNBCryptoPayment($transaction_id)
    {
        // URL of the page to fetch
        // $url = 'https://bscscan.com/tx/0x728277c2c5041bd7728f9ec0cbbc6d466913921d9889ac4fc9596fcd954bdff8';
        $url = 'https://bscscan.com/tx/' . $transaction_id;

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

        return array('balance' => 0);
    }
    public static function logTelegramBotState($userid, $state, $contnt)
    {
        $tbs = new TelegramBotState();
        $statelog = $tbs->where('user_id', $userid)->first();
        if ($statelog == null) {
            $tbs->add($userid, $state, $contnt);
        } else {
            $statelog->state = $state;
            $statelog->last_update_time = time();
            $statelog->content = $contnt;
            $statelog->save();
        }
    }
    public static function getTelegramBotState($userid): null|TelegramBotState
    {
        return (new TelegramBotState())->where('user_id', $userid)->first();
    } 
     public static function updateTelegramBotState(TelegramBotState $state): null|TelegramBotState
    {
        $state->state='NONE';
        $state->save();
        return $state;
    }
}
