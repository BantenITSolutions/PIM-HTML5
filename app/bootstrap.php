<?php
/**
 * Bootstrap aplikasi
 *
 * @author Taufan Aditya <toopay@taufanaditya.com>
 */

/* Composer Autoload */
require_once __DIR__.'/../vendor/autoload.php';

use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\Response;

/* Global constants */
define('ROOT_PATH', $_SERVER['DOCUMENT_ROOT']);
define('APP_PATH', dirname(ROOT_PATH).DIRECTORY_SEPARATOR.'app'.DIRECTORY_SEPARATOR);
define('ASSETS_PATH', ROOT_PATH.DIRECTORY_SEPARATOR);

/* Inisialisasi app */
$app = new Silex\Application();

/* Service & Providers */
$app->register(new Silex\Provider\TwigServiceProvider(), array(
    'twig.path' => __DIR__.'/views',
));

/* Data & callback */
$app['data'] = array(
	'title' => 'HTML5+PHP : Beyond ordinary web-application...',
);

$app['exec'] = function($c) {
	if (! empty($c['command']))
	{
		if (strpos($c['command'], 'server.php') !== false) {
			if (substr(php_uname(), 0, 7) == "Windows"){ 
				pclose(popen("start /B ". $c['command'], "r"));  
			} 
			else { 
				exec($c['command'] . " > /dev/null &");   
			} 
		} else {
			ob_start();
			passthru($c['command'], $res);
			$out = ob_get_clean();

			return compact('res','out');
		}
	}
};

/**
 * Application Routes
 *
 * +-----------------+-----------------------+-----------------------+
 * | METHOD          | PATH/ENDPOINTS        | KETERANGAN            |
 * +-----------------+-----------------------+-----------------------+
 * | GET             | /                     | Home (default)        |
 * | GET             | /geolocation          | Geolocation demo      |
 * | POST            | /georeverse           | Parse geo-info data   |
 * | GET             | /canvas               | Canvas demo           |
 * | POST            | /chart                | Random data for chart |
 * | GET             | /async                | Asynchronous demo     |
 * | POST            | /detect               | Asynchronous detect   |
 * | GET             | /socket               | Web-Socket demo       |
 * +-----------------+-----------------------+-----------------------+
 */
$app->get('/', function(Request $request) use ($app) {
	return $app['twig']->render('twig/default.tpl', $app['data']);
});

$app->get('/awesome-stuff',function(Request $request) use ($app){
	return $app['twig']->render('twig/default.tpl',$app['data']);
});

$app->get('/simple-stuff',function(Request $request) use ($app){
	return $app['twig']->render('twig/simple.tpl',$app['data']);
});

$app->get('/geolocation', function(Request $request) use ($app) {
	return $app['twig']->render('twig/geolocation.tpl', $app['data']);
});

$app->post('/georeverse', function(Request $request) use ($app) {
	$infos = $request->get('info');

	if ( ! empty($infos) && isset($infos['results']) 
	     && ($info = $infos['results']) && !empty($info)) {
	    $geoinfo = current($info);

	    if (array_key_exists('geometry', $geoinfo) 
	        && array_key_exists('address_components', $geoinfo)) {
	        $geometry = $geoinfo['geometry'];
	        $address_components = $geoinfo['address_components'];

			$latlng = $geometry['location']['lat'].','.$geometry['location']['lng'];
			$kota = '-';
			$propinsi = '-';
			$negara = '-';

			foreach ($address_components as $component) {
				if (in_array('locality', $component['types'])) {
			    	$kota = $component['long_name'];
				} elseif (in_array('administrative_area_level_1', $component['types'])) {
					$propinsi = $component['long_name'];
				} elseif (in_array('country', $component['types'])) {
					$negara = $component['long_name'];
				}
			}

			$app['data'] = array(
				'infos' => array(
					array('key' => 'Latitude/Longitude', 'val' => $latlng),
					array('key' => 'Kota', 'val' => $kota),
					array('key' => 'Propinsi', 'val' => $propinsi),
					array('key' => 'Negara', 'val' => $negara),
				),
			);
	    }
	}

	return $app['twig']->render('twig/geoinfo.tpl', $app['data']);
});

$app->get('/canvas', function(Request $request) use ($app) {
	$app['js'] = array(
		'/js/flot.js',
		'/js/vendor/moo.min.js',
		'/js/cloth.js',
	);

	return $app['twig']->render('twig/canvas.tpl', $app['data']);
});

$app->post('/chart', function(Request $request) use ($app) {

	$min = 0.0000;
	$max = 100.0000;
	$range = $max-$min;
	$data = array();
	$point = 0;
	$points = (int) $request->get('points');
	$currentData = $request->get('currentData');

	if ( ! empty($currentData)) {
		$currentData = current($currentData) and array_shift($currentData);
		$data = array_values($currentData);
	} 

	while ($points > 0) {
		if (! isset($data[$point])) {
			// Generate random float number
			$num = $min + $range * mt_rand(0, 32767)/32767;    
	        $num = round($num, 17);  

			$data[] = array($point, (float) $num);
		} else {
			$data[$point][0] = $data[$point][0] - 1;
		}
		
		$point++;
		$points--;
	}

	return $app->json($data);
});

$app->get('/async', function(Request $request) use ($app) {
	$app['css'] = array(
		'/css/bootstrap-lightbox.min.css',
	);

	$app['js'] = array(
		'/js/bootstrap-lightbox.js',
	);

	return $app['twig']->render('twig/async.tpl', $app['data']);
});

$app->post('/detect', function(Request $request) use ($app) {

	if ($request->server->get('HTTP_X_FILENAME')) {
		$handler = ASSETS_PATH.'res/face-detect';
		$file = ASSETS_PATH.'img/temp/'.$request->server->get('HTTP_X_FILENAME');
		file_put_contents("$file", $request->getContent());

		$cmd  = $handler.' --input="'.$file.'" --dir="'.ASSETS_PATH.'"';
		$last = exec($cmd, $out);

		if (strpos($last, 'Error:') === false)
		{
			$res = array('success' => true);

			foreach ($out as $i => $line)
			{
				if (preg_match('/\d+,\s*([^\s]+)\s+\((\d+)x(\d+)\)/i', $line, $m))
					$res['images'][] = array('src' => str_replace(ASSETS_PATH, '', $m[1]), 'width' => $m[2], 'height' => $m[3]);
			}
		}
		else
			$res = array('success' => false, 'msg' => $last);

		return $app->json($res, 200);
	} else {
		$data = array(
			'success' => false,
			'msg' => '404 - The resource you requested is not found.',
			'file'=>$request->server->get('HTTP_X_FILENAME'),
		);
		return $app->json($data, 404);
	}
});

$app->get('/socket', function(Request $request) use ($app) {
	$app['command'] = 'telnet localhost 8080';
	$connected = $app['exec'];

	if (stripos($connected['out'], 'connected') === false) {
		$app['command'] = '../app/bin/server > /dev/null &';
		$started = $app['exec'];
	}

	return $app['twig']->render('twig/socket.tpl', $app['data']);
});

/* Jalankan app */
$app->run();