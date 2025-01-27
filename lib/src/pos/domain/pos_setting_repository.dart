abstract class PosSettingRepository {
  Future index();
  Future show({required int id});
  Future create({required obj});
  Future update({required int id, required obj});
  Future delete({required int id});
}
