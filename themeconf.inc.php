<?php

/*
Theme Name: Clouds
Version: 1.0
Description: Piwigo theme for Smart Air that closely resembles Box
Author: rachung
Author URI: https://github.com/rachung2510
*/

define('CLOUDS_PATH' , PHPWG_THEMES_PATH.basename(dirname(__FILE__)).'/');
define('CLOUDS_TEMPLATE_PATH' , CLOUDS_PATH.'template/');

$themeconf = array(
  'parent' => 'default',
  'colorscheme' => 'clear',
  'local_head' => 'local_head.tpl',
  'mime_icon_dir' => CLOUDS_PATH.'icon/mimetypes/',
);

load_language('theme.lang', CLOUDS_PATH);

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
//  $icons_url = 'https://box.smartairfilters.com/';
  $icons_url = CLOUDS_PATH.'icon/nextcloud/';
  $template->set_filename('menubar', CLOUDS_TEMPLATE_PATH.'menubar.tpl');
  $template->assign(array(
    'gallery_title' => $gallery_title,
    'gallery_url' => PHPWG_ROOT_PATH,
    'icons_url' => $icons_url,
    'page_section' => isset($page['section']) ? $page['section'] : null,
    'is_homepage' => isset($page['is_homepage']),
  ));
  $template->parse('menubar',true);
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

// update clear or dark mood
global $conf, $user;
if (isset($conf['clouds_theme'])) {
    if (!is_array($conf['clouds_theme']))
        $conf['clouds_theme'] = unserialize($conf['clouds_theme']);

    // switch mood when user clicks button
    if (!is_a_guest() and !is_generic()) {
        $user_id = $user['user_id'];
        if (isset($_GET['mood'])) {
            $new_conf = $conf['clouds_theme'];
            $not_mood = ($_GET['mood'] == 'clear') ? 'dark' : 'clear'; // opposite
            $new_conf[$_GET['mood']][$user_id] = 1;
            unset($new_conf[$not_mood][$user_id]);
            conf_update_param('clouds_theme', addslashes(serialize($new_conf)));

            // redirect to refresh themeconf
            $redirect_url = get_root_url().get_query_string_diff(array("mood"));
            redirect($redirect_url);
        }
    }
}

// update themeconf colorscheme
if (!is_a_guest() and !is_generic()) {
    $user_id = $user['id'];
    $user_mood = isset($conf['clouds_theme']['dark'][$user_id]) ? 'dark' : 'clear'; // default to clear
    if ($user_mood == 'dark') {
        $themeconf['colorscheme'] = 'dark';
    }
}

// template variables for mood switch button
add_event_handler('loc_end_index', 'clouds_mood_switch');
add_event_handler('loc_end_picture', 'clouds_mood_switch');
function clouds_mood_switch() {
    global $conf, $user, $template;

    $user_id = $user['id'];
    if (isset($conf['clouds_theme']) && isset($conf['clouds_theme']['dark'])) {
        $mood = (isset($conf['clouds_theme']['dark'][$user_id])) ? 'dark' : 'clear'; // default to light
    } else {
        $mood = 'clear'; // default to light
    }
    $new_mood = ($mood == 'clear') ? 'dark' : 'clear'; // opposite
    $base_url = get_root_url().get_query_string_diff(array("mood"));

    // disable mood switch when not logged in
    $template->assign(array(
        'enable_mood_switch' => (is_a_guest() or is_generic()) ? 0 : 1,
        'mood' => $mood,
        'mood_title' => l10n('Switch to '.$new_mood.' mode'),
        'mood_switch_url' => add_url_params($base_url, array('mood' => $new_mood)), // opposite
    ));
    $template->set_filename('mood_switch', CLOUDS_TEMPLATE_PATH.'mood_button.tpl');
    $button = $template->parse('mood_switch', true);
    if (script_basename()=='index') {
        $template->add_index_button($button, BUTTONS_RANK_NEUTRAL);
    } else {
        $template->add_picture_button($button, BUTTONS_RANK_NEUTRAL);
    }
    $template->clear_assign('mood_switch');
}

// set default thumbnail size; default=square
add_event_handler('get_index_derivative_params', 'clouds_get_index_photo_derivative_params');
function clouds_get_index_photo_derivative_params($default) {
    if (pwg_get_session_var('index_deriv')===null) {
        $new = @ImageStdParams::get_by_type('square');
        if ($new) return $new;
    }
    return $default;
}


?>
