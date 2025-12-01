import 'package:get/get.dart';
import 'package:pos_shared_preferences/models/product_data/product.dart';
import 'package:pos_shared_preferences/models/product_data/product_more_details.dart';
import 'package:pos_shared_preferences/pos_shared_preferences.dart';
import 'package:shared_widgets/config/app_odoo_models.dart';
import 'package:shared_widgets/shared_widgets/handle_exception_helper.dart';
import 'package:shared_widgets/shared_widgets/odoo_connection_helper.dart';
import 'package:yousentech_pos_local_db/yousentech_pos_local_db.dart';
import 'product_repository.dart';

class ProductService extends ProductRepository {
  GeneralLocalDB<Product>? _generalLocalDBInstance;
  static ProductService? productDataServiceInstance;

  ProductService._() {
    _generalLocalDBInstance =
        GeneralLocalDB.getInstance<Product>(fromJsonFun: Product.fromJson)
            as GeneralLocalDB<Product>?;
  }

  static ProductService getInstance() {
    productDataServiceInstance =
        productDataServiceInstance ?? ProductService._();
    return productDataServiceInstance!;
  }

  @override
  Future createTable() async {
    _generalLocalDBInstance =
        GeneralLocalDB.getInstance<Product>(fromJsonFun: Product.fromJson)
            as GeneralLocalDB<Product>?;
    return await _generalLocalDBInstance!
        .createTable(structure: LocalDatabaseStructure.productStructure);
  }

  @override
  Future dropTable() async {
    _generalLocalDBInstance =
        GeneralLocalDB.getInstance<Product>(fromJsonFun: Product.fromJson)
            as GeneralLocalDB<Product>?;
    return await _generalLocalDBInstance!.dropTable();
  }

  @override
  Future deleteData() async {
    _generalLocalDBInstance =
        GeneralLocalDB.getInstance<Product>(fromJsonFun: Product.fromJson)
            as GeneralLocalDB<Product>?;
    return await _generalLocalDBInstance!.deleteData();
  }

  @override
  Future index({int? offset, int? limit}) async {
    _generalLocalDBInstance =
        GeneralLocalDB.getInstance<Product>(fromJsonFun: Product.fromJson)
            as GeneralLocalDB<Product>?;
    return await _generalLocalDBInstance!.index(offset: offset, limit: limit);
  }

  @override
  Future show({required dynamic val, String? arg}) async {
    _generalLocalDBInstance =
        GeneralLocalDB.getInstance<Product>(fromJsonFun: Product.fromJson)
            as GeneralLocalDB<Product>?;
    return await _generalLocalDBInstance!.show(val: val, whereArg: arg ?? 'id');
  }

  @override
  Future<int> create({required obj, bool isRemotelyAdded = false}) async {
    _generalLocalDBInstance =
        GeneralLocalDB.getInstance<Product>(fromJsonFun: Product.fromJson)
            as GeneralLocalDB<Product>?;
    return await _generalLocalDBInstance!
        .create(obj: obj, isRemotelyAdded: isRemotelyAdded);
  }

  @override
  Future search(String query,{int? page, int pageSize = 10, bool quickMenu = false ,  List<dynamic> itemCategSearch = const []}) async {
    try {
      _generalLocalDBInstance =
          GeneralLocalDB.getInstance<Product>(fromJsonFun: Product.fromJson)
              as GeneralLocalDB<Product>?;

      int? offset;
      if (page != null) offset = (page - 1) * pageSize;

      // String query1 = '''
      //   SELECT * FROM product
      //   WHERE (REPLACE(REPLACE(product_name, '"en_US":', ''), '"ar_001":', '') LIKE ? 
      //          OR barcode LIKE ? 
      //          OR default_code LIKE ?) 
      //          ${quickMenu ? 'AND quick_menu_availability = 1' : ''}
      //          ${(page != null) ? 'LIMIT ? OFFSET ?' : ''}
      // ''';

      // var queriesList = ['%$query%', '%$query%', '%$query%'];
      String query1 = '''
        SELECT * FROM product
        WHERE 
        ${itemCategSearch.isNotEmpty ? 'so_pos_categ_id IN (${List.filled(itemCategSearch.length, '?').join(', ')}) AND ' : ''}
          (REPLACE(REPLACE(product_name, '"en_US":', ''), '"ar_001":', '') LIKE ? 
               OR barcode LIKE ? 
               OR default_code LIKE ?
              ) 
               ${quickMenu ? 'AND quick_menu_availability = 1' : ''}
               ${(page != null) ? 'LIMIT ? OFFSET ?' : ''}
      ''';
      List queriesList = [
        ...itemCategSearch,
        '%$query%',
        '%$query%',
        '%$query%',
      ];
      queriesList
          .addAllIf(page != null, [pageSize.toString(), offset.toString()]);
      var result = await DbHelper.db!.rawQuery(
          query1, queriesList); // Offset to start fetching records from;
      return result.map((e) => Product.fromJson(e)).toList();
    } catch (e) {
      return await handleException(
          exception: e, navigation: false, methodName: "ProductSearch");
    }
  }

  Future<int> bulkUpdateFields(
      {required List<Map<String, dynamic>> updates,
      String? quantityColumnName}) async {
    _generalLocalDBInstance =
        GeneralLocalDB.getInstance<Product>(fromJsonFun: Product.fromJson)
            as GeneralLocalDB<Product>?;
    return await _generalLocalDBInstance!.bulkUpdateFields(
        updates: updates,
        quantityColumnName: quantityColumnName,
        whereColumnName: 'product_id');
  }

  Future searchProductsByIds({required List<int> ids}) async {
    try {
      _generalLocalDBInstance =
          GeneralLocalDB.getInstance<Product>(fromJsonFun: Product.fromJson)
              as GeneralLocalDB<Product>?;

      // Create a string of placeholders
      final placeholders =
          List<String>.generate(ids.length, (index) => '?').join(', ');

      // Construct the SQL query using placeholders
      String query =
          'SELECT * FROM product WHERE product_id IN ($placeholders)';

      // Execute the query, passing the list of ids as arguments
      var result = await DbHelper.db!.rawQuery(query, ids);

      return result.map((e) => Product.fromJson(e)).toList();
    } catch (e) {
      return await  handleException(
          exception: e, navigation: false, methodName: "searchProductsByIds");
    }
  }

  Future barcodeSearch(String query) async {
    try {
      _generalLocalDBInstance =
          GeneralLocalDB.getInstance<Product>(fromJsonFun: Product.fromJson)
              as GeneralLocalDB<Product>?;
      String query1 = '''
        SELECT * FROM product
        WHERE barcode = ?
      ''';
      var result = await DbHelper.db!.rawQuery(query1, [query]);
      return result.map((e) => Product.fromJson(e)).toList();
    } catch (e) {
      return await handleException(
          exception: e, navigation: false, methodName: "ProductSearch");
    }
  }

  Future searchByCateg({required List query, int? page, int? limit}) async {
    try {
      _generalLocalDBInstance =
          GeneralLocalDB.getInstance<Product>(fromJsonFun: Product.fromJson) as GeneralLocalDB<Product>?;
      return await _generalLocalDBInstance!.filter(
          whereArgs: query,
          where: 'so_pos_categ_id in  (${query.map((_) => '?').join(', ')})',
          // page: page,
          // limit: limit ?? 25
          );
    } catch (e) {
      return await handleException(
          exception: e, navigation: false, methodName: "searchByCateg");
    }
  }

  // object can be map or class object
  Future createProductRemotely({required obj}) async {
    try {
      int result = await OdooProjectOwnerConnectionHelper.odooClient.callKw({
        'model': OdooModels.productTemplate,
        'method': 'create',
        'args': [obj is Map<String, dynamic> ? obj : obj.toJson()],
        'kwargs': {},
      });
      return result;
    } catch (e) {
      return await handleException(
          exception: e, navigation: false, methodName: "createProductRemotely");
    }
  }

  @override
  Future<int> update(
      {required int id, required obj, required String whereField}) async {
    _generalLocalDBInstance =
        GeneralLocalDB.getInstance<Product>(fromJsonFun: Product.fromJson)
            as GeneralLocalDB<Product>?;
    return await _generalLocalDBInstance!
        .update(id: id, obj: obj, whereField: 'id');
  }

  @override
  Future<int> updateList({
    required List recordsList,
    String whereKey = 'product_id',
    required List<int> productIds
  }) async {
    _generalLocalDBInstance = GeneralLocalDB.getInstance<Product>(fromJsonFun: Product.fromJson) as GeneralLocalDB<Product>?;
    return await _generalLocalDBInstance!.updateList(recordsList: recordsList, whereKey: whereKey, ids: productIds);
  }

  Future updateProductRemotely({required int id, required obj}) async {
    try {
      var result = await OdooProjectOwnerConnectionHelper.odooClient.callKw({
        'model': OdooModels.productTemplate,
        'method': 'write',
        'args': [id, obj],
        'kwargs': {
          'context': {
            'lang': SharedPr.lang == 'ar'
                ? '${SharedPr.lang}_001'
                : '${SharedPr.lang}_US'
          }
        },
      });
      return result;
    } catch (e) {
      return await handleException(
          exception: e, navigation: true, methodName: "updateProductRemotely");
    }
  }

  Future getMoreProductInfo({required int productTemplateId}) async {
    try {
      var result = await OdooProjectOwnerConnectionHelper.odooClient.callKw({
        'model': OdooModels.productProductTransit,
        'method': 'get_product_more_details',
        'args': [
          productTemplateId,
        ],
        'kwargs': {
          'context': {'lang': SharedPr.lang == 'ar' ? 'ar_001' : 'en_US'}
        }
      });
      // print(result);
      return ProductMoreDetails.fromJson(result);
    } catch (e) {
      return await handleException(
          exception: e, navigation: false, methodName: "getMoreProductInfo");
    }
  }
  // Future createProductNote({required String note}) async {
  //   try {
  //     var result = await OdooProjectOwnerConnectionHelper.odooClient.callKw({
  //       'model': "so.pos.category.note",
  //       'method': 'create',
  //       'args': [note],
  //       'kwargs': {}
  //     });
  //     return result;
  //   } catch (e) {
  //     return await handleException(exception: e, navigation: false, methodName: "createProductNote");
  //   }
  // }
}
