List<Map> accountJournalHeader = [
  {"name": 'id', "flex": 1},
  {"name": 'pos_journal_name', "flex": 2},
  {"name": 'is_default_journal', "flex": 2},
  {"name": 'is_favorite', "flex": 2},
];
List<Map> taxHeader = [
  {"name": 'pos_tax_name', "flex": 2},
  {"name": 'tax_amount', "flex": 1},
  {"name": 'price_include', "flex": 1},
];
List<Map> customerHeader = [
  {"name": 'customer_image', "flex": 1},
  {"name": 'name', "flex": 2},
  {"name": 'email', "flex": 1},
  {"name": 'phone', "flex": 1},
];
List<Map> productHeader = [
  {"name": 'product_image', "flex": 1},
  {"name": 'product_name', "flex": 2},
  // {"name": 'product_barcode', "flex": 2},
  {"name": 'product_category', "flex": 1},
  {"name": 'product_unit_price', "flex": 1},
  {"name": 'product_unit', "flex": 1},
  // {"name": 'product_default_code', "flex": 1},
];
List<Map> productUnitHeader = [
  {"name": 'units', "flex": 2},
];
List<Map> posCategHeader = [
  {"name": 'pos_category_name', "flex": 2},
];
