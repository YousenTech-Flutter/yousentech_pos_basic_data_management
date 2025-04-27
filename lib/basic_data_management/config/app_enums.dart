
enum CustomerType {
  individual('individual',false),
  company('company',true);
  final String lable;
  final bool isCompany;
  const CustomerType(this.lable ,this.isCompany);
}

// ================================= [ Product Detailed Type] ==================================
enum DetailedType {
  consu('إستهلاكي','consu'),
  service('الخدمة','service'),
  product('منتج قابل للتخزين','product'),
  combo('مجموعة','combo');

  final String ar001;
  final String enUS;

  const DetailedType(this.ar001 , this.enUS);
}
// ================================= [ Product Detailed Type] ==================================
