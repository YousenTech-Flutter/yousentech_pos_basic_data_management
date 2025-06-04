abstract class UserSalePriceRepository {
  Future createTable();
  Future index();
  Future dropTable();
  Future deleteData();
  Future show({required dynamic val});
  Future create({required obj});
  Future update({required int id, required obj, required String whereField});
  Future search(String query);
}
