import 'package:stock/Helper/constants.dart';
import 'package:stock/Model/lot.dart';
import 'package:stock/Model/lot_process.dart';
import 'package:stock/Model/model.dart';
import 'package:stock/database/data/database.dart';
import 'package:stock/database/data/lot_database.dart';
import 'package:stock/database/interfaces/basic_database_interface.dart';

class LotProcessDataBase extends BasicDataBaseInterface
{
  final _database=StockDatabase.instance.database;
  @override
  void insert({required BasicModel model})async {
    final db= await _database;
    db.insert(lotProcessTable,model.toMap());
  }

  @override
  void delete({required int rowId})async {
    final db= await _database;
    LotProcess lotProcess=await getModelData(rowId: rowId);
    db.delete(lotProcessTable,where: '$lotProcessIdColumn=?',whereArgs: [rowId]);
  }
  void deleteAllLotProcess( int lotId)async {
    final db= await _database;
    db.delete(lotProcessTable,where: '$lotIdColumn=?',whereArgs: [lotId]);
  }
  // @override
  // void update({required BasicModel model,required int rowId}) async{
  //   final db= await _database;
  //   db.update(lotProcessTable,model.toMap(),where: '$lotProcessIdColumn=?',whereArgs: [rowId]);
  // }
updateLotProcessDate(int lotProcessId,String date)async
{
  final db= await _database;
  db.update(lotProcessTable,{
    lotProcessDateColumn:date
  },where:'$lotProcessIdColumn=?',whereArgs: [lotProcessId]);
}
  @override
  Future<List<LotProcess>> getAllModelsData({int? rowId,String? order1,String? order2})async {
    final db = await _database;
    List<LotProcess> lotprocessesList = [];
    List<Map> lotProcessesMap = await db.query(
        lotProcessTable, where: '$lotIdColumn=?', whereArgs: [rowId]);
    if (lotProcessesMap.isNotEmpty) {
      lotprocessesList = List.generate(lotProcessesMap.length, (index) {
        return LotProcess(
            lotProcessId: lotProcessesMap[index][lotProcessIdColumn],
            lotProcessDate: lotProcessesMap[index][lotProcessDateColumn],
            lotProcessDateQuantity: lotProcessesMap[index][lotDateQuantityColumn],
            lotProcessAdding: lotProcessesMap[index][lotProcessAddingColumn],
            lotProcessSubtracting: lotProcessesMap[index][lotProcessSubtractingColumn],
            lotId: lotProcessesMap[index][lotIdColumn]);
      });
    }
    return lotprocessesList;
  }

  @override
  Future<LotProcess> getModelData({required int rowId})async {
    final db=await _database;
    List<Map> lotProcessMap=await db.query(lotProcessTable,where: '$lotProcessIdColumn=?',
        whereArgs: [rowId]);
    return LotProcess(
        lotProcessId: lotProcessMap[0][lotProcessIdColumn],
        lotProcessDate: lotProcessMap[0][lotProcessDateColumn],
        lotProcessDateQuantity: lotProcessMap[0][lotDateQuantityColumn],
        lotProcessAdding: lotProcessMap[0][lotProcessAddingColumn],
        lotProcessSubtracting: lotProcessMap[0][lotProcessSubtractingColumn],
        lotId: lotProcessMap[0][lotIdColumn]);
  }
}