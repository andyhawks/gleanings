<?php

if (!isset($drush_major_version)) {
  $drush_version_components = explode('.', DRUSH_VERSION);
  $drush_major_version = $drush_version_components[0];
}
// Site gleanings, environment dev.
$aliases['dev'] = array(
  'root' => '/var/www/html/gleanings.dev/docroot',
  'ac-site' => 'gleanings',
  'ac-env' => 'dev',
  'ac-realm' => 'devcloud',
  'uri' => 'gleaningsjs9fnxrdcf.devcloud.acquia-sites.com',
  'remote-host' => 'gleaningsjs9fnxrdcf.ssh.devcloud.acquia-sites.com',
  'remote-user' => 'gleanings.dev',
  'path-aliases' => array(
    '%drush-script' => 'drush' . $drush_major_version,
  ),
);
$aliases['dev.livedev'] = array(
  'parent' => '@gleanings.dev',
  'root' => '/mnt/gfs/gleanings.dev/livedev/docroot',
);

if (!isset($drush_major_version)) {
  $drush_version_components = explode('.', DRUSH_VERSION);
  $drush_major_version = $drush_version_components[0];
}
// Site gleanings, environment test.
$aliases['test'] = array(
  'root' => '/var/www/html/gleanings.test/docroot',
  'ac-site' => 'gleanings',
  'ac-env' => 'test',
  'ac-realm' => 'devcloud',
  'uri' => 'gleanings3pch9sxrah.devcloud.acquia-sites.com',
  'remote-host' => 'gleanings3pch9sxrah.ssh.devcloud.acquia-sites.com',
  'remote-user' => 'gleanings.test',
  'path-aliases' => array(
    '%drush-script' => 'drush' . $drush_major_version,
  ),
);
$aliases['test.livedev'] = array(
  'parent' => '@gleanings.test',
  'root' => '/mnt/gfs/gleanings.test/livedev/docroot',
);
