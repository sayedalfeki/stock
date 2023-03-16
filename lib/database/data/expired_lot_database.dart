import 'package:stock/Helper/constants.dart';
import 'package:stock/Model/expired_lot.dart';
import 'package:stock/Model/model.dart';
import 'package:stock/database/data/database.dart';
import 'package:stock/database/interfaces/basic_database_interface.dart';

class ExpiredLotDataBase extends BasicDataBaseInterface
{
   final _database=StockDatabase.instance.database;
  @override
  void insert({required BasicModel model})async {
       final db=await _database;
       db.insert(expiredLotTable,model.toMap());
  }
  @override
  void delete({required int rowId})async {
    final db=await _database;
    db.delete(expiredLotProcessTable,where: '$expiredLotIdColumn=?',whereArgs: [rowId]);
  }
  @override
  Future<List<BasicModel>> getAllModelsData({int? rowId, String? order1, String? order2})async {
    final db=await _database;
    List<ExpiredLot> expiredLots=[];
    List<Map> expiredLotsMap=await db.query(expiredLotTable,where: '$reagentIdColumn=?',whereArgs: [rowId]);
    if(expiredLotsMap.isNotEmpty)
    {
      expiredLots=List.generate(expiredLotsMap.length, (index){
        return ExpiredLot(expiredLotId:expiredLotsMap[index][expiredLotIdColumn],
            expiredLotNumber:expiredLotsMap[index][expiredLotNumberColumn],
            expiredLotExpireDate: expiredLotsMap[index][expiredLotExpireDateColumn],
            expiredLotQuantity: expiredLotsMap[index][expiredLotQuantityColumn],
            reagentId: expiredLotsMap[index][reagentIdColumn]);
    });

  }
    return expiredLots;
  }
  @override
  Future<BasicModel> getModelData({required int rowId})async {
    final db=await _database;
    List<Map> expiredLotMap=await db.query(expiredLotTable,where: '$expiredLotIdColumn=?',
        whereArgs: [rowId]);
    return ExpiredLot(expiredLotId:expiredLotMap[0][expiredLotIdColumn],
        expiredLotNumber:expiredLotMap[0][expiredLotNumberColumn],
        expiredLotExpireDate: expiredLotMap[0][expiredLotExpireDateColumn],
        expiredLotQuantity: expiredLotMap[0][expiredLotQuantityColumn],
        reagentId: expiredLotMap[0][reagentIdColumn]);
  }



}