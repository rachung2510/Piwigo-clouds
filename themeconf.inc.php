<?php

/*
Theme Name: My greenery
Version: 0.1
Description: My very first theme
Theme URI: http://piwigo.org/ext/extension_view.php?eid=347
Author: John Do
Author URI: http://piwigo.org/
*/

$themeconf = array(
  'parent' => 'default',
  'colorscheme' => 'clear',
);

define('CLOUDS_PATH' , PHPWG_THEMES_PATH.basename(dirname(__FILE__)).'/');
define('CLOUDS_TEMPLATE_PATH' , CLOUDS_PATH.'template/');

/* menubar */
add_event_handler('loc_begin_index', 'clouds_menubar');
add_event_handler('loc_begin_register', 'clouds_menubar');
add_event_handler('loc_begin_profile', 'clouds_menubar');
add_event_handler('loc_begin_tags', 'clouds_menubar');
add_event_handler('loc_begin_search', 'clouds_menubar');
add_event_handler('loc_begin_about', 'clouds_menubar');
add_event_handler('loc_begin_notification', 'clouds_menubar');
function clouds_menubar() {
  global $conf,$page,$template;
  $gallery_title = $conf['gallery_title'];
  $icons_url = 'https://box.smartairfilters.com/';
  $template->set_filename('menubar', CLOUDS_TEMPLATE_PATH.'menubar.tpl');
  $template->assign(array(
    'gallery_title' => $gallery_title,
    'gallery_url' => PHPWG_ROOT_PATH,
    'icons_url' => $icons_url,
  ));
  $template->pparse('menubar');
}

?>
