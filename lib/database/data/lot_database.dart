import 'package:stock/Helper/constants.dart';
import 'package:stock/Helper/date_helper.dart';
import 'package:stock/Model/expired_lot.dart';
import 'package:stock/Model/expired_lot_process.dart';
import 'package:stock/Model/lot.dart';
import 'package:stock/Model/lot_process.dart';
import 'package:stock/Model/model.dart';
import 'package:stock/database/data/database.dart';
import 'package:stock/database/data/expired_lot_database.dart';
import 'package:stock/database/data/expired_lot_process_database.dart';
import 'package:stock/database/data/lot_process_database.dart';
import 'package:stock/database/interfaces/basic_database_interface.dart';
class LotDatabase extends BasicDataBaseInterface with UpdateInterface
{
  final _database=StockDatabase.instance.database;
  @override
  void insert({required BasicModel model})async {
    final db= await _database;
    db.insert(lotTable,model.toMap());
  }

  @override
  void delete({required int rowId})async {
    final db= await _database;
    db.delete(lotTable,where: '$lotIdColumn=?',whereArgs: [rowId]);
  }
  void deleteAllReagentLots(int reagentId)async {
    final db= await _database;
    db.delete(lotTable,where: '$reagentIdColumn=?',whereArgs: [reagentId]);
  }
  @override
  void update({required BasicModel model,required int rowId}) async{
    final db= await _database;
    db.update(lotTable,model.toMap(),where: '$lotIdColumn=?',whereArgs: [rowId]);
  }
updateLotQuantity(int lotId,int quantity)async
{
  final db= await _database;
  db.update(lotTable, {
    lotQuantityColumn:quantity
  },where: '$lotIdColumn=?',whereArgs: [lotId]);
}
  @override
  Future<List<Lot>> getAllModelsData({int? rowId,String? order1,String? order2}) async{
    final db= await _database;
    List<Lot> lotsList=[];
    List<Map> lotsMap=await db.query(lotTable,where: '$reagentIdColumn=?',whereArgs: [rowId],
        orderBy:'$lotQuantityColumn desc,$lotExpireDateColumn ');
    if(lotsMap.isNotEmpty)
    {
      lotsList=List.generate(lotsMap.length, (index){
        return Lot(lotId:lotsMap[index][lotIdColumn],
            lotNumber: lotsMap[index][lotNumberColumn],
            lotExpireDate: lotsMap[index][lotExpireDateColumn],
            reagentId: lotsMap[index][reagentIdColumn],
        lotQuantity: lotsMap[index][lotQuantityColumn]
        );
      });
    }
    return lotsList;
  }
  @override
  Future<Lot> getModelData({required int rowId})async {
    final db=await _database;
    List<Map> lotMap=await db.query(lotTable,where: '$lotIdColumn=?',whereArgs: [rowId]);

    return Lot(lotId:lotMap[0][lotIdColumn], lotNumber: lotMap[0][lotNumberColumn],
        lotExpireDate: lotMap[0][lotExpireDateColumn], reagentId: lotMap[0][reagentIdColumn]);
  }
  Future<List<Lot>> getExpiredLots(int reagentId)async
  {
    List<Lot> expiredLots=[];
    List<Lot> lots=await getAllModelsData(rowId: reagentId);
    for(var lot in lots)
    {
      if(MyDate.isExpire(MyDate.toDate(lot.lotExpireDate)))
      {
        expiredLots.add(lot);
      }
    }
    return expiredLots;
  }
Future<List<Map<String, dynamic>>> setLotMap(int reagentId)async
{
  List<Map<String,dynamic>> lotsMap=[];
  List<Lot> lots=await getAllModelsData(rowId: reagentId);
  for(var lot in lots)
  {
    DateTime expireDate=MyDate.toDate(lot.lotExpireDate);
    bool nearExpire=false;
    if(MyDate.isNearExpire(expireDate))
    {
      nearExpire=true;
    }
    Map<String,dynamic> lotMap={
      'lot':lot,
      'near_expire':nearExpire
    };
    lotsMap.add(lotMap);
  }
  return lotsMap;
}
deleteExpiredLots(int reagentId)async
{
  List<Lot> lots=await getExpiredLots(reagentId);
  for(var lot in lots)
  {
    ExpiredLot expiredLot=ExpiredLot(expiredLotNumber:lot.lotNumber,
        expiredLotExpireDate:lot.lotExpireDate,
        expiredLotQuantity:lot.lotQuantity,
        reagentId:lot.reagentId,
        expiredLotId: lot.lotId);
    List<LotProcess> lotProcesses=await LotProcessDataBase().getAllModelsData(rowId:lot.lotId);
    for(var lp in lotProcesses)
    {
      ExpiredLotProcess expiredLotProcess=ExpiredLotProcess(expiredLotProcessId:
      lp.lotProcessId, expiredLotProcessDate: lp.lotProcessDate,
          expiredLotProcessAdding: lp.lotProcessAdding,
          expiredLotProcessSubtracting: lp.lotProcessSubtracting,
          expiredLotDateQuantity: lp.lotProcessDateQuantity, expiredLotId: lp.lotId);
      ExpiredLotProcessDataBase().insert(model: expiredLotProcess);
    }
    LotProcessDataBase().deleteAllLotProcess(lot.lotId);
    ExpiredLotDataBase().insert(model:expiredLot);
    delete(rowId: lot.lotId);
  }
}
}

