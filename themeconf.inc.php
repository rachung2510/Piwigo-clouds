<?php

/*
Theme Name: My greenery
Version: 0.1
Description: My very first theme
Theme URI: http://piwigo.org/ext/extension_view.php?eid=347
Author: John Do
Author URI: http://piwigo.org/
*/

define('CLOUDS_PATH' , PHPWG_THEMES_PATH.basename(dirname(__FILE__)).'/');
define('CLOUDS_TEMPLATE_PATH' , CLOUDS_PATH.'template/');

$themeconf = array(
  'parent' => 'default',
  'colorscheme' => 'clear',
  'local_head' => 'local_head.tpl',
);

/* menubar */
add_event_handler('loc_begin_index', 'clouds_menubar');
add_event_handler('loc_begin_identification', 'clouds_menubar');
add_event_handler('loc_begin_register', 'clouds_menubar');
add_event_handler('loc_begin_profile', 'clouds_menubar');
add_event_handler('loc_begin_tags', 'clouds_menubar');
add_event_handler('loc_begin_search', 'clouds_menubar');
add_event_handler('loc_begin_comments', 'clouds_menubar');
add_event_handler('loc_begin_about', 'clouds_menubar');
add_event_handler('loc_begin_notification', 'clouds_menubar');
add_event_handler('loc_begin_picture', 'clouds_menubar');
add_event_handler('loc_begin_password', 'clouds_menubar');
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
    'is_homepage' => isset($page['is_homepage']),
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
    // tag with user's language found
    $patterns[] = '#(^|\[/lang\])(.*?)(\[lang=(' . $user_lang . '|' . $small_user_lang . '|all)\]|$)#is';
    $replacements[] = '';
    $patterns[] = '#\[lang=(' . $user_lang . '|' . $small_user_lang . '|all)\](.*?)\[/lang\]#is';
    $replacements[] = '\\1';
  } else {
    // tag with user's language not found
    // take everything outside the tag
    $patterns[] = '#\[lang=all\](.*?)\[/lang\]#is';
    $replacements[] = '\\1';
    $patterns[] = '#\[lang=.*\].*\[/lang\]#is';
    $replacements[] = '';
  }

  return preg_replace($patterns, $replacements, $desc);

}

// render image in single page
add_event_handler('render_element_content', 'render_svg', 40, 2 );
function render_svg($content, $picture)
{
    global $template, $picture, $page, $conf, $user, $refresh;

    $img = $picture['current'];
    $name = substr($img['file'], 0, strrpos($img['file'], '.'));
    $ext = substr($img['file'], strrpos($img['file'], '.')+1); // file extension
    if ($ext == 'svg' or $ext == 'gif') {
        $path = $picture['current']['path'];

        $template->assign(
            array(
                'url' => $path,
                'title' => $name.' - '.$img['file'],
                'alt' => $img['file'],
            )
        );
        $template->set_filenames(
            array('preview' => CLOUDS_TEMPLATE_PATH."preview.tpl")
        );

        // Return the rendered html
        $test = $template->parse('preview', true);
        return $test;
    }
}

?>
