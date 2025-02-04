abstract class ProductRepository {
  Future createTable();
  Future dropTable();
  Future deleteData();
  Future index();
  Future show({required dynamic val});
  Future create({required obj});
  Future update({required int id, required obj, required String whereField});
  Future updateList({required List recordsList, required String whereKey,required List<int> productIds });
  Future search(String query);
}
