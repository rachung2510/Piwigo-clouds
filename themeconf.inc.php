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
add_event_handler('loc_begin_comments', 'clouds_menubar');
add_event_handler('loc_begin_about', 'clouds_menubar');
add_event_handler('loc_begin_notification', 'clouds_menubar');
add_event_handler('loc_begin_picture', 'clouds_menubar');
function clouds_menubar() {
  global $conf, $page, $template;
  $gallery_title = $conf['gallery_title'];
  $icons_url = 'https://box.smartairfilters.com/';
  $template->set_filename('menubar', CLOUDS_TEMPLATE_PATH.'menubar.tpl');
  $template->assign(array(
    'gallery_title' => $gallery_title,
    'gallery_url' => PHPWG_ROOT_PATH,
    'icons_url' => $icons_url,
    'page_section' => isset($page['section']) ? $page['section'] : null,
  ));
  $template->pparse('menubar');
}

/**
 * Extended Description plugin misses out on parent albums under mbRelatedCategories
 * Includes function "parse_lang_tag" to capture parent albums
 */
$this->smarty->registerPlugin('function', 'parse_lang', 'extended_desc_parse_lang_tag');
function extended_desc_parse_lang_tag($params, $smarty) {
  $desc = $params['desc'];

  // only parse if Extended Description plugin enabled
  global $conf;
  if (!isset($conf['ExtendedDescription'])) {
    return $desc;
  }

  global $user;
  $user_lang = $user['language'];
  $small_user_lang = substr($user_lang, 0, 2);

  if (!preg_match('#\[lang=('.$user_lang.'|'.$small_user_lang.')\]#i', $desc)) {
    $user_lang = 'default';
    $small_user_lang = 'default';
  }

  if (preg_match('#\[lang=('.$user_lang.'|'.$small_user_lang.')\]#i', $desc)) {
    // la balise avec la langue de l'utilisateur a été trouvée
    $patterns[] = '#(^|\[/lang\])(.*?)(\[lang=(' . $user_lang . '|' . $small_user_lang . '|all)\]|$)#is';
    $replacements[] = '';
    $patterns[] = '#\[lang=(' . $user_lang . '|' . $small_user_lang . '|all)\](.*?)\[/lang\]#is';
    $replacements[] = '\\1';
  } else {
    // la balise avec la langue de l'utilisateur n'a pas été trouvée
    // On prend tout ce qui est hors balise
    $patterns[] = '#\[lang=all\](.*?)\[/lang\]#is';
    $replacements[] = '\\1';
    $patterns[] = '#\[lang=.*\].*\[/lang\]#is';
    $replacements[] = '';
  }

  return preg_replace($patterns, $replacements, $desc);

}

?>
