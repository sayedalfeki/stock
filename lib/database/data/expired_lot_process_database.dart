import 'package:stock/Helper/constants.dart';
import 'package:stock/Model/expired_lot_process.dart';
import 'package:stock/Model/model.dart';
import 'package:stock/database/data/database.dart';
import 'package:stock/database/interfaces/basic_database_interface.dart';
class ExpiredLotProcessDataBase extends BasicDataBaseInterface
{
  final _database=StockDatabase.instance.database;
  @override
  void insert({required BasicModel model}) async{
   final db=await _database;
   db.insert(expiredLotProcessTable,model.toMap());
  }

  @override
  void delete({required int rowId}) async{
    final db=await _database;
    db.delete(expiredLotProcessTable,where: '$expiredLotProcessIdColumn=?',whereArgs: [rowId]);
  }

  @override
  Future<List<ExpiredLotProcess>> getAllModelsData({int? rowId, String? order1,
    String? order2}) async{
    List<ExpiredLotProcess> lpList=[];
    final db=await _database;
List<Map> lpMap=await db.query(expiredLotProcessTable,where: '$expiredLotIdColumn=?',
    whereArgs:[rowId]);
lpList=List.generate(lpMap.length, (index){
  return
    ExpiredLotProcess(expiredLotProcessId: lpMap[index][expiredLotProcessIdColumn],
      expiredLotProcessDate: lpMap[index][expiredLotProcessDateColumn],
      expiredLotProcessAdding: lpMap[index][expiredLotProcessAddingColumn],
      expiredLotProcessSubtracting: lpMap[index][expiredLotProcessSubtractingColumn],
      expiredLotDateQuantity: lpMap[index][expiredLotQuantityColumn],
      expiredLotId: lpMap[index][expiredLotIdColumn]);
});
return lpList;
  }

  @override
  Future<BasicModel> getModelData({required int rowId})async {
    final db=await _database;
    List<Map> lpMap=await db.query(expiredLotProcessTable,where: '$expiredLotProcessIdColumn=?',
        whereArgs:[rowId]);
    return ExpiredLotProcess(expiredLotProcessId: lpMap[0][expiredLotProcessIdColumn],
        expiredLotProcessDate: lpMap[0][expiredLotProcessDateColumn],
        expiredLotProcessAdding: lpMap[0][expiredLotProcessAddingColumn],
        expiredLotProcessSubtracting: lpMap[0][expiredLotProcessSubtractingColumn],
        expiredLotDateQuantity: lpMap[0][expiredLotQuantityColumn],
        expiredLotId: lpMap[0][expiredLotIdColumn]);
  }
}