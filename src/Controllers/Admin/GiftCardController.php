<?php

declare(strict_types=1);

namespace App\Controllers\Admin;

use App\Controllers\BaseController;
use App\Models\GiftCard;
use App\Utils\Tools;
use Psr\Http\Message\ResponseInterface;
use Slim\Http\Request;
use Slim\Http\Response;

final class GiftCardController extends BaseController
{
    public static $details = [
        'field' => [
            'op' => 'شرح عملیات',
            'id' => 'شناسه کارت هدیه',
            'card' => 'شماره کارت',
            'balance' => 'ارزش اسمی',
            'create_time' => 'زمان ایجاد',
            'status' => 'وضعیت استفاده',
            'use_time' => 'زمان استفاده',
            'use_user' => 'کاربر',
        ],
        'create_dialog' => [
            [
                'id' => 'card_number',
                'info' => 'تولید به تعداد',
                'type' => 'input',
                'placeholder' => '',
            ],
            [
                'id' => 'card_value',
                'info' => 'ارزش اسمی کارت هدیه',
                'type' => 'input',
                'placeholder' => '',
            ],
            [
                'id' => 'card_length',
                'info' => 'طول کارت هدیه',
                'type' => 'select',
                'select' => [
                    '12' => '12بیت',
                    '18' => '18بیت',
                    '24' => '24بیت',
                    '30' => '30بیت',
                    '36' => '36بیت',
                ],
            ],
        ],
    ];

    public function index(Request $request, Response $response, array $args): ResponseInterface
    {
        return $response->write(
            $this->view()
                ->assign('details', self::$details)
                ->display('admin/giftcard.tpl')
        );
    }

    public function add(Request $request, Response $response, array $args): ResponseInterface
    {
        $card_number = $request->getParam('card_number');
        $card_value = $request->getParam('card_value');
        $card_length = $request->getParam('card_length');
        $card_added = '';

        if ($card_number === null || $card_number < 0) {
            return $response->withJson([
                'ret' => 0,
                'msg' => 'مقدار تولید شده نمی تواند خالی یا کمتر از 0 باشد',
            ]);
        }

        if ($card_value === null || $card_value < 0) {
            return $response->withJson([
                'ret' => 0,
                'msg' => 'ارزش اسمی کارت هدیه نباید خالی یا کمتر از 0 باشد',
            ]);
        }

        for ($i = 0; $i < $card_number; $i++) {
            $card = Tools::genRandomChar($card_length);
            // save to database
            $giftcard = new GiftCard();
            $giftcard->card = $card;
            $giftcard->balance = $card_value;
            $giftcard->create_time = \time();
            $giftcard->status = 0;
            $giftcard->use_time = 0;
            $giftcard->use_user = 0;
            $giftcard->save();
            $card_added .= $card . PHP_EOL;
        }

        return $response->withJson([
            'ret' => 1,
            'msg' => 'با موفقیت اضافه شد' . PHP_EOL . $card_added,
        ]);
    }

    public function delete(Request $request, Response $response, array $args): ResponseInterface
    {
        $card_id = $args['id'];
        GiftCard::find($card_id)->delete();
        return $response->withJson([
            'ret' => 1,
            'msg' => 'با موفقیت حذف شد',
        ]);
    }

    public function ajax(Request $request, Response $response, array $args): ResponseInterface
    {
        $giftcards = GiftCard::orderBy('id', 'desc')->get();
        foreach ($giftcards as $giftcard) {
            $giftcard->op = '<button type="button" class="btn btn-red" id="delete-gift-card-' . $giftcard->id . '" 
        onclick="deleteGiftCard(' . $giftcard->id . ')">حذف</button>';
            $giftcard->status = Tools::getGiftCardStatus($giftcard);
            $giftcard->create_time = Tools::toDateTime((int) $giftcard->create_time);
            $giftcard->use_time = Tools::toDateTime((int) $giftcard->use_time);
        }
        return $response->withJson([
            'giftcards' => $giftcards,
        ]);
    }
}
