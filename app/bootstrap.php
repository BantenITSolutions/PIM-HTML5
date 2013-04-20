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

/**
 * Application Routes
 *
 * +-----------------+-----------------------+-----------------------+
 * | METHOD          | PATH/ENDPOINTS        | KETERANGAN            |
 * +-----------------+-----------------------+-----------------------+
 * | GET             | /                     | Default Routes        |
 * +-----------------+-----------------------+-----------------------+
 */
$app->get('/', function(Request $request) use ($app) {
	$title = 'Depan - HTML5/PHP';
	return $app['twig']->render('twig/default.tpl', compact('title'));
});

/* Jalankan app */
$app->run();