<?php

function theme_activate($id, $version, &$errors)
{
  global $conf;
  $default_conf = array(
    'clear' => array(),
    'dark' => array(),
  );

  $user_ids = query2array('SELECT user_id FROM '.USER_INFOS_TABLE.';');
  foreach ($user_ids as $user_id) {
    $id = $user_id['user_id'];
    $default_conf['clear'][$id] = 1;
  }

  $my_conf = @$conf['clouds_theme'];
  $my_conf = @unserialize($my_conf);
  if (empty($my_conf))
    $my_conf = $default_conf;

  $my_conf = array_merge($default_conf, $my_conf);
  $my_conf = array_intersect_key($my_conf, $default_conf);
  conf_update_param('clouds_theme', addslashes(serialize($my_conf)) );
}

function theme_delete()
{
  $query = 'DELETE FROM ' . CONFIG_TABLE . ' WHERE param="clouds_theme"';
  pwg_query($query);
}

?>
