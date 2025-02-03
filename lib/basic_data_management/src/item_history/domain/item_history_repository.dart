abstract class ItemHistoryRepository {
  // Future update ({required int id, required  dataUpdated});
  // Future create ({required  dataCreate});
  // Future delete ({required int odooId});

  Future show({required int itemId, required String type});
  Future update ({required String type});
  Future updateHistoryAndReturnProductId({required int productTemplateId});
}
