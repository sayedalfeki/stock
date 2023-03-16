import 'package:stock/Model/model.dart';

abstract class BasicDataBaseInterface
{
  void insert({required BasicModel model});
  void delete({required int rowId});
  Future<List<BasicModel>> getAllModelsData({int? rowId,String? order1,String? order2});
  Future<BasicModel> getModelData({required int rowId});
}
abstract class UpdateInterface
{
  void update({required BasicModel model,required int rowId});
}