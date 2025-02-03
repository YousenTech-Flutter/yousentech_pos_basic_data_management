

abstract class CustomerRepository {
  Future update ({required int id, required  dataUpdated});
  Future create ({required  dataCreate});
  Future index ();
  Future dropTable ();
  Future deleteData ();
  Future show ({required int id});
  Future count ();
  Future delete ({required int odooId});
  Future search(String query);
}
