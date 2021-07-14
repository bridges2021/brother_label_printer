//
//  Generated file. Do not edit.
//

#include "generated_plugin_registrant.h"

#include <brother_label_printer/brother_label_printer_plugin.h>

void fl_register_plugins(FlPluginRegistry* registry) {
  g_autoptr(FlPluginRegistrar) brother_label_printer_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "BrotherLabelPrinterPlugin");
  brother_label_printer_plugin_register_with_registrar(brother_label_printer_registrar);
}
