<?php

declare(strict_types=1);

namespace App\Controllers\User;

use App\Controllers\BaseController;
use App\Models\Node;
use App\Models\Setting;
use App\Models\SmartDns;
use App\Services\Cloudflare;
use App\Services\IM\Telegram;
use App\Utils\Tools;
use Cloudflare\API\Endpoints\EndpointException;
use Exception;
use Psr\Http\Message\ResponseInterface;
use Slim\Http\Response;
use Slim\Http\ServerRequest;
use stdClass;
use voku\helper\AntiXSS;
use function trim;

final class SmartDnsController extends BaseController
{
    private static array $details = [
        'field' => [
            'ip' => 'آدرس IP',
            'details' => 'مشخصات IP',
            'updated_at' => 'زمان به روز رسانی',
        ],
    ];

    private static array $update_field = [
        'name',
        'server',
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

    /**
     * Create the data output array for the DataTables rows
     *
     *  @param  array $columns Column information array
     *  @param  array $data    Data from the SQL get
     *  @return array          Formatted data in a row based format
     */
    static function data_output($columns, $data)
    {
        $out = array();

        for ($i = 0, $ien = count($data); $i < $ien; $i++) {
            $row = array();

            for ($j = 0, $jen = count($columns); $j < $jen; $j++) {
                $column = $columns[$j];

                // Is there a formatter?
                if (isset($column['formatter'])) {
                    if (empty($column['db'])) {
                        $row[$column['dt']] = $column['formatter']($data[$i]);
                    } else {
                        $row[$column['dt']] = $column['formatter']($data[$i][$column['db']], $data[$i]);
                    }
                } else {
                    if (!empty($column['db'])) {
                        $row[$column['dt']] = $data[$i][$columns[$j]['db']];
                    } else {
                        $row[$column['dt']] = "";
                    }
                }
            }

            $out[] = $row;
        }

        return $out;
    }

    static function order($request, $columns)
    {
        $order = '';

        if (isset($request['order']) && count($request['order'])) {
            $orderBy = array();
            $dtColumns = self::pluck($columns, 'dt');

            for ($i = 0, $ien = count($request['order']); $i < $ien; $i++) {
                // Convert the column index into the column data property
                $columnIdx = intval($request['order'][$i]['column']);
                $requestColumn = $request['columns'][$columnIdx];

                $columnIdx = array_search($requestColumn['data'], $dtColumns);
                $column = $columns[$columnIdx];

                if ($requestColumn['orderable'] == 'true') {
                    $dir = $request['order'][$i]['dir'] === 'asc' ?
                        'ASC' :
                        'DESC';

                    $orderBy[] = '`' . $column['db'] . '` ' . $dir;
                }
            }

            if (count($orderBy)) {
                // $order = 'ORDER BY '.implode(', ', $orderBy);
                $order = implode(', ', $orderBy);
                $order = implode(', ', $orderBy);
            }
        }

        return $order;
    }

    /**
     * Create a PDO binding key which can be used for escaping variables safely
     * when executing a query with sql_exec()
     *
     * @param  array &$a    Array of bindings
     * @param  *      $val  Value to bind
     * @param  int    $type PDO field type
     * @return string       Bound key to be used in the SQL where this parameter
     *   would be used.
     */
    static function bind(&$a, $val, $type)
    {
        $key = ':binding_' . count($a);

        $a[] = array(
            'key' => $key,
            'val' => $val,
            'type' => $type
        );

        return $key;
    }

    /**
     * Searching / Filtering
     *
     * Construct the WHERE clause for server-side processing SQL query.
     *
     * NOTE this does not match the built-in DataTables filtering which does it
     * word by word on any field. It's possible to do here performance on large
     * databases would be very poor
     *
     *  @param  array $request Data sent to server by DataTables
     *  @param  array $columns Column information array
     *  @param  array $bindings Array of values for PDO bindings, used in the
     *    sql_exec() function
     *  @return string SQL where clause
     */
    static function filter($request, $columns, &$bindings)
    {
        $globalSearch = array();
        $columnSearch = array();
        $dtColumns = self::pluck($columns, 'dt');

        if (isset($request['search']) && $request['search']['value'] != '') {
            $str = $request['search']['value'];

            for ($i = 0, $ien = count($request['columns']); $i < $ien; $i++) {
                $requestColumn = $request['columns'][$i];
                $columnIdx = array_search($requestColumn['data'], $dtColumns);
                $column = $columns[$columnIdx];

                if ($requestColumn['searchable'] == 'true') {
                    if (!empty($column['db'])) {
                        $binding = self::bind($bindings, '%' . $str . '%', PDO::PARAM_STR);
                        $globalSearch[] = "`" . $column['db'] . "` LIKE " . $binding;
                    }
                }
            }
        }

        // Individual column filtering
        if (isset($request['columns'])) {
            for ($i = 0, $ien = count($request['columns']); $i < $ien; $i++) {
                $requestColumn = $request['columns'][$i];
                $columnIdx = array_search($requestColumn['data'], $dtColumns);
                $column = $columns[$columnIdx];

                $str = $requestColumn['search']['value'];

                if (
                    $requestColumn['searchable'] == 'true' &&
                    $str != ''
                ) {
                    if (!empty($column['db'])) {
                        $binding = self::bind($bindings, '%' . $str . '%', PDO::PARAM_STR);
                        $columnSearch[] = "`" . $column['db'] . "` LIKE " . $binding;
                    }
                }
            }
        }

        // Combine the filters into a single string
        $where = '';

        if (count($globalSearch)) {
            $where = '(' . implode(' OR ', $globalSearch) . ')';
        }

        if (count($columnSearch)) {
            $where = $where === '' ?
                implode(' AND ', $columnSearch) :
                $where . ' AND ' . implode(' AND ', $columnSearch);
        }

        // if ( $where !== '' ) {
        // 	$where = 'WHERE '.$where;
        // }

        return $where;
    }

    /**
     * Pull a particular property from each assoc. array in a numeric array, 
     * returning and array of the property values from each item.
     *
     *  @param  array  $a    Array to get data from
     *  @param  string $prop Property to read
     *  @return array        Array of property values
     */
    static function pluck($a, $prop)
    {
        $out = array();

        for ($i = 0, $len = count($a); $i < $len; $i++) {
            if (empty($a[$i][$prop]) && $a[$i][$prop] !== 0) {
                continue;
            }

            //removing the $out array index confuses the filter method in doing proper binding,
            //adding it ensures that the array data are mapped correctly
            $out[$i] = $a[$i][$prop];
        }

        return $out;
    }

    /**
     * Perform the SQL queries needed for an server-side processing requested,
     * utilising the helper functions of this class, limit(), order() and
     * filter() among others. The returned array is ready to be encoded as JSON
     * in response to an SSP request, or can be modified if needed before
     * sending back to the client.
     *
     *  @param  array $request Data sent to server by DataTables
     *  @param  string $primaryKey Primary key of the table
     *  @param  array $columns Column information array
     *  @return array          Server-side processing response array
     */
    static function simple($request, $primaryKey, $columns)
    {
        $bindings = array();

        // Allow for a JSON string to be passed in
        if (isset($request['json'])) {
            $request = json_decode($request['json'], true);
        }

        // $query = SmartDns::select(self::pluck($columns, 'db'));
        $temp1 = self::pluck($columns, 'db');
        $selectColumns = [];
        foreach (self::pluck($columns, 'db') as $column) {
            $selectColumns[] = strtolower($column);
        }
        $query = SmartDns::select($selectColumns);

        $order = self::order($request, $columns);
        if (!empty($order)) {
            $query->orderBy($order);
        }
        ;

        $where = self::filter($request, $columns, $bindings);
        if (!empty($where)) {
            $query->where($where);
        }
        ;

        if (isset($request['start']) && $request['length'] != -1) {
            $query->offset(intval($request['start']))->limit(intval($request['length']));
        }

        $data = $query->get();

        $recordsTotal = $data->count(`{$primaryKey}`);
        $recordsFiltered = $recordsTotal;
        if (!empty($where)) {
            $recordsFiltered = $data->where($where)->count(`{$primaryKey}`);
        }

        /*
         * Output
         */
        return array(
            "draw" => isset($request['draw']) ? intval($request['draw']) : 0,
            "recordsTotal" => intval($recordsTotal),
            "recordsFiltered" => intval($recordsFiltered),
            "data" => self::data_output($columns, $data),
            "error" => ""
        );
    }

    /**
     * @throws Exception
     */
    public function dns(ServerRequest $request, Response $response, array $args): Response|ResponseInterface
    {
        return $response->write($this->view()
            ->fetch('user/smart_dns.tpl'));
    }

    /**
     * 后台节点页面
     *
     * @throws Exception
     */
    public function index(ServerRequest $request, Response $response, array $args): ResponseInterface
    {
        // $_SERVER['REMOTE_ADDR']
        return $response->write(
            $this->view()
                ->assign('details', self::$details)
                ->assign('update_field', self::$update_field)
                ->assign('ip', $_SERVER['REMOTE_ADDR'])
                ->fetch('user/smart_dns.tpl')
        );
    }

    /**
     * 后台添加节点
     *
     * @throws EndpointException
     */
    public function add(ServerRequest $request, Response $response, array $args): ResponseInterface
    {
        $antiXss = new AntiXSS();
        $data = $antiXss->xss_clean($request->getParam('data'));

        if (count($data) > 1) {
            return $response->withStatus(400)
                ->withJson([
                    'ret' => 0,
                    'msg' => 'فقط یک گزینه را انتخاب کنید.',
                    'error' => 'فقط یک گزینه را انتخاب کنید.'
                ]);
        }

        $ip = $antiXss->xss_clean(trim($data[0]['ip']));
        if (!(Tools::isIPv4($ip) || Tools::isIPv6($ip))) {
            return $response->withStatus(200)
                ->withJson([
                    'ret' => 0,
                    'error' => 'مقدار IP صحیح نیست.'
                ]);
        }


        $user = $this->user;
        $count = SmartDns::where('userid', $user->id)->count();

        if ($user->smart_dns === null) {
            return $response->withStatus(200)
                ->withJson([
                    'ret' => 0,
                    'error' => 'دسترسی به این سرویس برای شما فعال نیست',
                ]);
        }

        $dupplicate = SmartDns::where('ip', $ip)->count();
        if ($dupplicate !== 0) {
            return $response->withStatus(200)
                ->withJson([
                    'ret' => 0,
                    'error' => 'این آدرس قبلا ثبت شده و نیازی به ثبت مجدد نیست.',
                ]);
        }

        if ($user->smart_dns !== 0 && ($count === $user->smart_dns || $count > $user->smart_dns)) {
            return $response->withStatus(200)
                ->withJson([
                    'ret' => 0,
                    'error' => 'در حال حاضر شما از حداکثر میزان مجاز تعداد آدرس استفاده کرده اید.',
                ]);
        }

        $dns = new SmartDns();
        $dns->ip = $ip;
        $dns->created_at = time();
        $dns->updated_at = time();
        $dns->mark = Tools::getIpLocation($ip);
        $dns->userid = $user->id;

        if (!$dns->save()) {
            return $response->withStatus(500)
                ->withJson([
                    'ret' => 0,
                    'msg' => 'گره اضافه نشد',
                ]);
        }

        return $response->withStatus(200)
            ->withJson([
                'ret' => 1,
                'msg' => 'سرور با موفقیت اضافه شد'
            ]);
    }

    /**
     * 后台更新指定节点内容
     */
    public function update(ServerRequest $request, Response $response, array $args): ResponseInterface
    {
        $id = $args['id'];
        $dns = SmartDns::find($id);

        $antiXss = new AntiXSS();
        $data = $antiXss->xss_clean($request->getParam('data'));

        if (count($data) > 1) {
            return $response->withStatus(400)
                ->withJson([
                    'ret' => 0,
                    'msg' => 'فقط یک گزینه را انتخاب کنید.',
                    'error' => 'فقط یک گزینه را انتخاب کنید.'
                ]);
        }
        $ip = $antiXss->xss_clean(trim($data[$id]['ip']));

        $dupplicate = SmartDns::where('ip', $ip)->count();
        if ($dupplicate !== 0) {
            return $response->withStatus(400)
                ->withJson([
                    'ret' => 0,
                    'msg' => 'این آدرس قبلا ثبت شده و نیازی به ثبت مجدد نیست.',
                    'error' => 'این آدرس قبلا ثبت شده و نیازی به ثبت مجدد نیست.',
                ]);
        }

        $mark = Tools::getIpLocation($ip);
        $dns->ip = $ip;
        $update = time();
        $dns->updated_at = $update;
        $dns->mark = $mark;


        if (!$dns->save()) {
            return $response->withStatus(500)
                ->withJson([
                    'ret' => 0,
                    'msg' => 'خطا در اصلاح اطلاعات',
                    'error' => 'خطا در اصلاح اطلاعات',
                ]);
        }
        $ret = new stdClass();
        $ret->updated_at = Tools::toDateTime($update);
        $ret->ip = $ip;
        $ret->mark = $mark;

        return $response->withStatus(200)
            ->withJson([
                $id => $ret,
                'ret' => 1,
                'msg' => 'با موفقیت اصلاح شد',
            ]);
    }

    /**
     * 后台删除指定节点
     */
    public function delete(ServerRequest $request, Response $response, array $args): ResponseInterface
    {
        $id = $args['id'];
        $dns = SmartDns::find($id);

        if (!$dns->delete()) {
            return $response->withJson([
                'ret' => 0,
                'msg' => 'حذف نشد',
                'error' => 'حذف نشد',
            ]);
        }

        return $response->withJson([
            'data' => [],
            'ret' => 1,
            'msg' => 'با موفقیت حذف شد',
        ]);
    }

    /**
     * 后台节点页面 AJAX
     */
    public function ajax(ServerRequest $request, Response $response, array $args): ResponseInterface
    {

        // $antiXss = new AntiXSS();
        // $clientName = $antiXss->xss_clean($args['name']);

        $user = $this->user;
        $smartdnss = SmartDns::where('userid', $user->id)->orderBy('id', 'desc')->get();

        foreach ($smartdnss as $smartdns) {
            $smartdns->updated_at = Tools::toDateTime($smartdns->updated_at);
            if (Tools::isIPv4($smartdns->mark) || Tools::isIPv6($smartdns->mark)) {
                $smartdns->mark = Tools::getIpLocation($smartdns->mark);
            }
        }

        // $smartdnss_count = $smartdnss->count();

        return $response->withStatus(200)
            ->withJson([
                'data' => $smartdnss,
                'ret' => 1,
                'msg' => 'success'
            ]);
    }

    /**
     * 后台节点页面 AJAX
     */
    public function ajaxServerSide(ServerRequest $request, Response $response, array $args): ResponseInterface
    {
        // Table's primary key
        $primaryKey = 'id';

        // Array of database columns which should be read and sent back to DataTables.
// The `db` parameter represents the column name in the database, while the `dt`
// parameter represents the DataTables column identifier. In this case simple
// indexes
        $columns = array(
            array('db' => 'id', 'dt' => 'id'),
            array('db' => 'ip', 'dt' => 'ip'),
            array('db' => 'mark', 'dt' => 'mark'),
            array('db' => 'updated_at', 'dt' => 'updated_at'),
        );


        // $da = $request->getBody()->getContents();
        // parse_str($da, $output);

        $res = self::simple(array(), $primaryKey, $columns);
        // $res["error"] = "ye alam error";
        $datas = $res["data"];
        foreach ($datas as &$data) {
            $data["updated_at"] = Tools::toDateTime($data["updated_at"]);
        }
        $res["data"] = $datas;
        return $response->withStatus(200)
            ->withJson($res);
    }
}