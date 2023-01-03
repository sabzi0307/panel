<?php

declare(strict_types=1);

namespace App\Controllers\Admin;

use App\Controllers\AdminController;
use App\Models\Product;
use App\Utils\Tools;
use Exception;
use Psr\Http\Message\ResponseInterface;
use Slim\Http\Request;
use Slim\Http\Response;

final class ProductController extends AdminController
{
    public static $details = [
        'field' => [
            'op' => 'عمل کنند',
            'id' => 'شناسه محصول',
            'name' => 'نام',
            'price' => 'قیمت فروش',
            'status' => 'وضعیت فروش',
            'create_time' => 'زمان ایجاد',
            'update_time' => 'زمان به روز رسانی',
            'sale_count' => 'تعداد',
            'stock' => 'موجودی',
        ],
    ];

    public static $update_field = [
        'type',
        'name',
        'price',
        'traffic_rate',
        'info',
        'node_group',
        'node_speedlimit',
        'sort',
        'node_ip',
        'node_class',
        'node_bandwidth_limit',
        'bandwidthlimit_resetday',
    ];

    public function index(Request $request, Response $response, array $args): ResponseInterface
    {
        return $response->write(
            $this->view()
                ->assign('details', self::$details)
                ->display('admin/product/index.tpl')
        );
    }

    public function create(Request $request, Response $response, array $args): ResponseInterface
    {
        return $response->write(
            $this->view()
                ->assign('update_field', self::$update_field)
                ->display('admin/product/create.tpl')
        );
    }

    public function add(Request $request, Response $response, array $args): ResponseInterface
    {
        // base product
        $type = $request->getParam('type');
        $name = $request->getParam('name');
        $price = $request->getParam('price');
        $status = $request->getParam('status');
        $stock = $request->getParam('stock');
        // content
        $time = $request->getParam('time');
        $bandwidth = $request->getParam('bandwidth');
        $class = $request->getParam('class');
        $class_time = $request->getParam('class_time'); 
        $speed_limit = $request->getParam('speed_limit');
        $ip_limit = $request->getParam('ip_limit');
        // limit
        $class_requried = $request->getParam('class_requried');
        $node_group_requried = $request->getParam('node_group_requried');
        $new_user_requried = $request->getParam('new_user_requried');

        try {
            $product = new Product();

            if ($name === '') {
                throw new \Exception('لطفا نام محصول را وارد کنید');
            }
            if ($price === '') {
                throw new \Exception('لطفا قیمت محصول را وارد نمایید');
            }
            if ($stock === '') {
                throw new \Exception('لطفا موجودی محصول را وارد کنید');
            }

            if ($type === 'tabp') {
                if ($time === '') {
                    throw new \Exception('لطفا مدت زمان بسته را پر کنید');
                }
                if ($bandwidth === '') {
                    throw new \Exception('لطفا ترافیک بسته را وارد کنید');
                }

                ($class === '') && $class = '0';
                ($class_time === '') && $class_time = $time;
                ($speed_limit === '') && $speed_limit = '0';
                ($ip_limit === '') && $ip_limit = '0';

                $content = [
                    'time' => $time,
                    'bandwidth' => $bandwidth,
                    'class' => $class,
                    'class_time' => $class_time,
                    'speed_limit' => $speed_limit,
                    'ip_limit' => $ip_limit,
                ];
            } elseif ($type === 'time') {
                if ($time === '') {
                    throw new \Exception('لطفا مدت زمان بسته را وارد کنید');
                }

                $content = [
                    'time' => $time,
                ];
            } elseif ($type === 'bandwidth') {
                if ($bandwidth === '') {
                    throw new \Exception('لطفا ترافیک بسته را وارد کنید');
                }

                $content = [
                    'bandwidth' => $bandwidth,
                ];
            } else {
                throw new \Exception('نوع محصول اشتباه وارد شده');
            }

            $limit = [
                'class_requried' => $class_requried,
                'node_group_requried' => $node_group_requried,
                'new_user_requried' => $new_user_requried,
            ];

            $product->type = $type;
            $product->name = $name;
            $product->price = $price;
            $product->content = \json_encode($content);
            $product->limit = \json_encode($limit);
            $product->status = $status;
            $product->create_time = \time();
            $product->update_time = \time();
            $product->sale_count = 0;
            $product->stock = $stock;
            $product->save();
        } catch (\Exception $e) {
            return $response->withJson([
                'ret' => 0,
                'msg' => $e->getMessage(),
            ]);
        }

        return $response->withJson([
            'ret' => 1,
            'msg' => 'با موفقیت اضافه شد',
        ]);
    }

    public function edit(Request $request, Response $response, array $args): ResponseInterface
    {
        $id = $args['id'];
        $product = Product::find($id);
        return $response->write(
            $this->view()
                ->assign('product', $product)
                ->assign('update_field', self::$update_field)
                ->display('admin/product/create.tpl')
        );
    }

    public function update(Request $request, Response $response, array $args): ResponseInterface
    {
        $product_id = $args['id'];
        // base product
        $type = $request->getParam('type');
        $name = $request->getParam('name');
        $price = $request->getParam('price');
        $status = $request->getParam('status');
        $stock = $request->getParam('stock');
        // content
        $time = $request->getParam('time');
        $bandwidth = $request->getParam('bandwidth');
        $class = $request->getParam('class');
        $class_time = $request->getParam('class_time'); 
        $speed_limit = $request->getParam('speed_limit');
        $ip_limit = $request->getParam('ip_limit');
        // limit
        $class_requried = $request->getParam('class_requried');
        $node_group_requried = $request->getParam('node_group_requried');
        $new_user_requried = $request->getParam('new_user_requried');

        try {
            $product = Product::find($product_id);

            if ($name === '') {
                throw new \Exception('لطفا نام محصول را وارد کنید');
            }
            if ($price === '') {
                throw new \Exception('لطفا قیمت محصول را وارد نمایید');
            }
            if ($stock === '') {
                throw new \Exception('لطفا موجودی محصول را وارد کنید');
            }

            if ($type === 'tabp') {
                if ($time === '') {
                    throw new \Exception('لطفا مدت زمان بسته را وارد کنید');
                }
                if ($bandwidth === '') {
                    throw new \Exception('لطفا ترافیک بسته را وارد کنید');
                }

                ($class === '') && $product_class = '0';
                ($class_time === '') && $class_time = $time;
                ($speed_limit === '') && $speed_limit = '0';
                ($ip_limit === '') && $ip_limit = '0';

                $content = [
                    'time' => $time,
                    'bandwidth' => $bandwidth,
                    'class' => $class,
                    'class_time' => $class_time,
                    'speed_limit' => $speed_limit,
                    'ip_limit' => $ip_limit,
                ];
            } elseif ($type === 'time') {
                if ($time === '') {
                    throw new \Exception('لطفا مدت زمان بسته را وارد کنید');
                }

                $content = [
                    'time' => $time,
                ];
            } elseif ($type === 'bandwidth') {
                if ($bandwidth === '') {
                    throw new \Exception('لطفا ترافیک بسته را وارد کنید');
                }

                $content = [
                    'bandwidth' => $bandwidth,
                ];
            } else {
                throw new \Exception('نوع محصول اشتباه وارد شده');
            }

            $limit = [
                'class_requried' => $class_requried,
                'node_group_requried' => $node_group_requried,
                'new_user_requried' => $new_user_requried,
            ];

            $product->type = $type;
            $product->name = $name;
            $product->price = $price;
            $product->content = \json_encode($content);
            $product->stock = $stock;
            $product->status = $status;
            $product->update_time = \time();
            $product->save();
        } catch (\Exception $e) {
            return $response->withJson([
                'ret' => 0,
                'msg' => $e->getMessage(),
            ]);
        }

        return $response->withJson([
            'ret' => 1,
            'msg' => 'به روز رسانی تکمیل شد',
        ]);
    }

    public function delete(Request $request, Response $response, array $args): ResponseInterface
    {
        $product_id = $args['id'];
        Product::find($product_id)->delete();

        return $response->withJson([
            'ret' => 1,
            'msg' => 'با موفقیت حذف شد',
        ]);
    }

    public function copy(Request $request, Response $response, array $args): ResponseInterface
    {
        try {
            $old_product_id = $args['id'];
            $old_product = Product::find($old_product_id);
            $new_product = new Product();
            // https://laravel.com/docs/9.x/eloquent#replicating-models
            $new_product = $old_product->replicate([
                'create_time',
                'update_time',
            ]);
            $new_product->name .= ' (副本)';
            $new_product->create_time = \time();
            $new_product->update_time = \time();
            $new_product->sale_count = 0;
            $new_product->save();
        } catch (\Exception $e) {
            return $response->withJson([
                'ret' => 0,
                'msg' => $e->getMessage(),
            ]);
        }

        return $response->withJson([
            'ret' => 1,
            'msg' => 'با موفقیت کپی کنید',
        ]);
    }

    public function ajax(Request $request, Response $response, array $args): ResponseInterface
    {
        $products = Product::orderBy('id', 'desc')->get();

        foreach ($products as $product) {
            $product->op = '<button type="button" class="btn btn-red" id="delete-product-' . $product->id . '" 
            onclick="deleteNode(' . $product->id . ')">حذف</button>
            <button type="button" class="btn btn-orange" id="copy-product-' . $product->id . '" 
            onclick="copyNode(' . $product->id . ')">کپی</button>
            <a class="btn btn-blue" href="/admin/product/' . $product->id . '/edit">ویرایش</a>';
            $product->create_time = Tools::toDateTime($product->create_time);
            $product->update_time = Tools::toDateTime($product->update_time);
        }

        return $response->withJson([
            'products' => $products,
        ]);
    }
}
