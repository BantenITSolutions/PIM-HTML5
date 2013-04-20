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

/**
 * Application Routes
 *
 * +-----------------+-----------------------+-----------------------+
 * | METHOD          | PATH/ENDPOINTS        | KETERANGAN            |
 * +-----------------+-----------------------+-----------------------+
 * | GET             | /                     | Home (default)        |
 * | GET             | /geolocation          | Geolocation demo      |
 * +-----------------+-----------------------+-----------------------+
 */
$app->get('/', function(Request $request) use ($app) {
	return $app['twig']->render('twig/default.tpl', $app['data']);
});

$app->get('/geolocation', function(Request $request) use ($app) {
	return $app['twig']->render('twig/geolocation.tpl', $app['data']);
});

/* Jalankan app */
$app->run();