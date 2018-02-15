<?php

namespace Drupal;

use Behat\Behat\Context\Context;
use Behat\Gherkin\Node\TableNode;
use Drupal\Core\Entity\Entity\EntityFormDisplay;
use Drupal\field\Entity\FieldConfig;
use Drupal\field\FieldConfigInterface;
use TravisCarden\BehatTableComparison\TableEqualityAssertion;

/**
 * Provides content model step definitions for Behat.
 */
class ContentModelContext extends FeatureContext implements Context {

  /**
   * @var \Drupal\Core\Entity\EntityTypeManagerInterface
   */
  private $entityTypeManager;

  /**
   * @var \Drupal\Core\Config\ConfigFactoryInterface
   */
  private $configFactory;

  /**
   * @var \Drupal\Core\Field\FieldTypePluginManagerInterface
   */
  private $fieldTypePluginManager;

  /**
   * @var \Drupal\Component\Plugin\PluginManagerInterface
   */
  private $fieldWidgetPluginManager;

  public function __construct() {
    $this->entityTypeManager = \Drupal::entityTypeManager();
    $this->configFactory = \Drupal::configFactory();
    $this->fieldTypePluginManager = \Drupal::service('plugin.manager.field.field_type');
    $this->fieldWidgetPluginManager = \Drupal::service('plugin.manager.field.widget');
  }

  /**
   * @Then exactly the following auto labels should be configured
   * @throws \Exception
   */
  public function assertAutoLabels(TableNode $expected) {
    $config = \Drupal::config('auto_entitylabel.settings')->get();
    $auto_label_info = [];
    foreach ($config as $key => $value) {
      $key_suffix = '_pattern';
      if (substr($key, -8) === $key_suffix) {
        $entity_types = [
          'node_type',
          'taxonomy_vocabulary',
        ];
        foreach ($entity_types as $entity_type_id) {
          $key_prefix = "{$entity_type_id}_";
          if (strpos($key, $key_prefix) === 0) {
            $id = substr($key, strlen($key_prefix), -strlen($key_suffix));
            /** @var \Drupal\Core\Entity\EntityInterface $entity_type */
            $entity_type = \Drupal::entityTypeManager()
              ->getStorage($entity_type_id)
              ->load($id);
            if ($entity_type) {
              $auto_label_info[] = [
                (string) $entity_type->getEntityType()->getLabel(),
                $entity_type->label(),
                $value,
              ];
            }
          }
        }
      }
    }
    $actual = new TableNode($auto_label_info);

    (new TableEqualityAssertion($expected, $actual))
      ->expectHeader([
        'type',
        'bundle',
        'pattern',
      ])
      ->ignoreRowOrder()
      ->setMissingRowsLabel('Missing patterns')
      ->setUnexpectedRowsLabel('Unexpected patterns')
      ->assert();
  }

  /**
   * @Then exactly the following entity type bundles should exist
   * @throws \Exception
   */
  public function assertBundles(TableNode $expected) {
    $bundle_info = [];
    foreach ($this->getContentEntityTypes() as $entity_type) {
      $bundles = $this->entityTypeManager
        ->getStorage($entity_type->getBundleEntityType())
        ->loadMultiple();
      foreach ($bundles as $bundle) {
        $description = '';
        $description_getter = 'getDescription';
        if (method_exists($bundle, $description_getter)) {
          $description = call_user_func([
            $bundle,
            $description_getter,
          ]);
        }
        if (!isset($description) || !$description) {
          $description = '';
        }

        $bundle_info[] = [
          $bundle->label(),
          $bundle->id(),
          $entity_type->getBundleLabel(),
          $description,
        ];
      }
    }
    $actual = new TableNode($bundle_info);

    (new TableEqualityAssertion($expected, $actual))
      ->expectHeader([
        'Name',
        'Machine name',
        'Type',
        'Description',
      ])
      ->ignoreRowOrder()
      ->setMissingRowsLabel('Missing bundles')
      ->setUnexpectedRowsLabel('Unexpected bundles')
      ->assert();
  }

  /**
   * @Given exactly the fields in :csv should exist
   * @throws \Exception
   */
  public function assertFieldsFromCsv($csv) {
    $this->assertFieldsFromTable($this->getTableNodeFromCsv($csv));
  }

  /**
   * @Then exactly the following fields should exist
   * @throws \Exception
   */
  public function assertFieldsFromTable(TableNode $expected) {
    $fields = [];
    foreach ($this->getContentEntityTypes() as $entity_type) {
      $bundles = $this->entityTypeManager
        ->getStorage($entity_type->getBundleEntityType())
        ->loadMultiple();
      foreach ($bundles as $bundle) {
        /** @var string[] $ids */
        $ids = \Drupal::entityQuery('field_config')
          ->condition('bundle', $bundle->id())
          ->condition('entity_type', $entity_type->id())
          ->execute();

        if (!$ids) {
          continue;
        }

        $display_id = "{$entity_type->id()}.{$bundle->id()}.default";
        $form_display = EntityFormDisplay::load($display_id);
        if (is_null($form_display)) {
          throw new \Exception(sprintf('No such form display %s.', $display_id));
        }
        $form_components = $form_display->getComponents();

        /** @var FieldConfigInterface $field_config */
        foreach (FieldConfig::loadMultiple($ids) as $id => $field_config) {
          $machine_name = $this->getFieldMachineNameFromConfigId($id);
          $field_storage = $field_config->getFieldStorageDefinition();
          $fields[] = [
            $entity_type->getBundleLabel(),
            $bundle->label(),
            $field_config->getLabel(),
            $machine_name,
            (string) $this->fieldTypePluginManager->getDefinition($field_config->getType())['label'],
            $field_config->isRequired() ? 'Required' : '',
            $field_storage->getCardinality() === -1 ? 'Unlimited' : $field_storage->getCardinality(),
            isset($form_components[$machine_name]['type']) ? (string) $this->fieldWidgetPluginManager->getDefinition($form_components[$machine_name]['type'])['label'] : '-- Hidden --',
            $field_config->isTranslatable() ? 'Translatable' : '',
            $field_config->getDescription(),
          ];
        }
      }
    }
    $actual = new TableNode($fields);

    (new TableEqualityAssertion($expected, $actual))
      ->expectHeader([
        'Type',
        'Bundle',
        'Field label',
        'Machine name',
        'Field type',
        'Required',
        'Cardinality',
        'Form widget',
        'Translatable',
        'Help text',
      ])
      ->ignoreRowOrder()
      ->setMissingRowsLabel('Missing fields')
      ->setUnexpectedRowsLabel('Unexpected fields')
      ->assert();
  }

  /**
   * Gets the content entity types in scope.
   *
   * @return \Drupal\Core\Entity\EntityTypeInterface[]
   *   An array of entity types.
   */
  protected function getContentEntityTypes() {
    $ids = [
      'block_content',
      'media',
      'node',
      'taxonomy_term',
    ];
    $entity_types = [];
    foreach ($ids as $id) {
      $entity_types[] = $this->entityTypeManager->getDefinition($id);
    }
    return $entity_types;
  }

  /**
   * Gets the field machine name from a configuration object ID.
   *
   * @param string $id
   *   The field configuration object ID.
   *
   * @return string|false
   *   The machine name if found or FALSE if not.
   */
  protected function getFieldMachineNameFromConfigId($id) {
    return substr($id, strrpos($id, '.') + 1);
  }

}
