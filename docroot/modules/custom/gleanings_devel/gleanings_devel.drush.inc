<?php

/**
 * @file
 * Drush commands for the Gleanings Devel module.
 */

use Drupal\user\Entity\Role;

/**
 * Implements hook_drush_command().
 */
function gleanings_devel_drush_command() {
  $items = [];

  $items['gleanings-devel-user-permissions'] = [
    'description' => 'Display the user permissions grid.',
    'examples' => [
      'drush uprm' => 'Display the user permissions grid.',
      'drush uprm --format=csv > permissions.csv' => 'Save the user permissions grid to CSV.',
    ],
    'aliases' => ['uprm'],
    'outputformat' => [
      'default' => 'table',
      'field-labels' => [
        'provider' => 'Provider',
        'permission' => 'Permission',
        'anonymous' => 'Anonymous user',
        'authenticated' => 'Authenticated user',
        'administrator' => 'Administrator',
        'page_creator' => 'Basic page creator',
        'layout_manager' => 'Layout manager',
        'page_reviewer' => 'Basic page reviewer',
        'landing_page_creator' => 'Landing page creator',
        'landing_page_reviewer' => 'Landing page reviewer',
        'media_creator' => 'Media creator',
        'media_manager' => 'Media manager',
      ],
      'output-data-type' => 'format-table',
    ],
  ];

  return $items;
}

/**
 * Implements hook_drush_help().
 */
function gleanings_devel_drush_help($section) {
  switch ($section) {
    case 'meta:gleanings_devel:title':
      return dt('Gleanings Devel commands');
  }
}

/**
 * Implements drush_hook_COMMAND().
 */
function drush_gleanings_devel_user_permissions() {
  $table = [];

  $role_names = [];
  $role_permissions = [];
  $admin_roles = [];
  /** @var \Drupal\user\RoleInterface[] $roles */
  $roles = Role::loadMultiple();
  foreach ($roles as $role_name => $role) {
    $role_names[$role_name] = $role->label();
    $role_permissions[$role_name] = $role->getPermissions();
    $admin_roles[$role_name] = $role->isAdmin();
  }

  // @todo The 'field-labels' option does not currently work with the CSV output
  //   formatter. See https://github.com/drush-ops/drush/pull/130. Compensate
  //   manually until fixed upstream.
  if (drush_get_option('format') == 'csv' && !drush_get_option('no-field-labels')) {
    $table['header']['provider'] = dt('Provider');
    $table['header']['permission'] = dt('Permission');
    foreach ($role_names as $rid => $name) {
      $table['header'][$rid] = $name;
    }
  }

  /** @var \Drupal\user\PermissionHandlerInterface $permission_handler */
  $permission_handler = \Drupal::service('user.permissions');
  $all_permissions = $permission_handler->getPermissions();
  $permissions_by_provider = [];
  foreach ($all_permissions as $permission_name => $permission) {
    $permissions_by_provider[$permission['provider']][$permission_name] = $permission;
  }

  /** @var \Drupal\Core\Extension\ModuleHandlerInterface $module_handler */
  $module_handler = \Drupal::service('module_handler');
  foreach ($permissions_by_provider as $provider => $permissions) {
    $module_name = $module_handler->getName($provider);
    foreach ($permissions as $perm => $perm_item) {
      $table[$perm]['provider'] = $module_name;
      $table[$perm]['permission'] = strip_tags($perm_item['title']);
      foreach ($role_names as $rid => $name) {
        $table[$perm][$rid] = ($admin_roles[$rid] || in_array($perm, $role_permissions[$rid])) ? $name : '';
      }
    }
  }

  return $table;
}
