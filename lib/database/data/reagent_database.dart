import 'package:stock/Helper/constants.dart';
import 'package:stock/Helper/date_helper.dart';
import 'package:stock/Model/model.dart';
import 'package:stock/Model/reagents.dart';
import 'package:stock/database/data/database.dart';
import 'package:stock/database/data/lot_database.dart';
import 'package:stock/database/interfaces/basic_database_interface.dart';
import '../../Model/lot.dart';
class ReagentDataBase extends BasicDataBaseInterface with UpdateInterface
{
  final _database=StockDatabase.instance.database;
  @override
  void insert({required BasicModel model})async {
      final db= await _database;
      db.insert(reagentTable,model.toMap());
  }

  @override
  void delete({required int rowId})async {
    final db= await _database;
    db.delete(reagentTable,where: '$reagentIdColumn=?',whereArgs: [rowId]);
  }

  @override
  void update({required BasicModel model,required int rowId}) async{
    final db= await _database;
    db.update(reagentTable,model.toMap(),where: '$reagentIdColumn=?',whereArgs: [rowId]);
  }

  @override
  Future<List<Reagent>> getAllModelsData({int? rowId,String? order1,String? order2}) async{
    final db= await _database;
   List<Reagent> reagentsList=[];
   List<Map> reagentsMap=await db.query(reagentTable,orderBy: '$order1 ,$order2');
   if(reagentsMap.isNotEmpty)
   {
     reagentsList=List.generate(reagentsMap.length, (index){
       return Reagent(reagentName:reagentsMap[index][reagentNameColumn],
           minStockLevel: reagentsMap[index][reagentMinimumStockLevelColumn],
           stockTemp: reagentsMap[index][stockReagentTemperatureColumn],
           reagentId:reagentsMap[index][reagentIdColumn],
           category: reagentsMap[index][reagentCategoryColumn],
          subCategory: reagentsMap[index][reagentSubCategoryColumn]
       );
     });
   }
   return reagentsList;
  }

  @override
  Future<Reagent> getModelData({required int rowId})async {
    final db=await _database;
    List<Map> reagentMap=await db.query(reagentTable,where: '$reagentIdColumn=?',whereArgs: [rowId]);

      return Reagent(reagentName:reagentMap[0][reagentNameColumn] ,
          minStockLevel: reagentMap[0][reagentMinimumStockLevelColumn],
          stockTemp: reagentMap[0][stockReagentTemperatureColumn],
          reagentId: reagentMap[0][reagentIdColumn],
      category: reagentMap[0][reagentCategoryColumn],
        subCategory: reagentMap[0][reagentSubCategoryColumn]
      );

  }
  Future<int> getReagentCount(int reagentId)async
  {
    int count=0;
    List<Lot> lots=await LotDatabase().getAllModelsData(rowId: reagentId);
    for(var lot in lots)
    {
      count+=lot.lotQuantity;
    }
    return count;
  }
  Future<List<Reagent>> getSearchedReagent(String word) async
  {
    final db=await _database;
    List<Reagent> reagentsList=[];
    List <Map> reagentsMap=await db.query(reagentTable,
        where:"$reagentNameColumn like'%$word%' or $reagentCategoryColumn like '%$word%' or"
        " $reagentSubCategoryColumn like'%$word%' or $stockReagentTemperatureColumn like '%$word%'");
    if(reagentsMap.isNotEmpty) {
       reagentsList= List.generate(reagentsMap.length, (index) {
         return Reagent(reagentName:reagentsMap[index][reagentNameColumn],
             minStockLevel: reagentsMap[index][reagentMinimumStockLevelColumn],
             stockTemp: reagentsMap[index][stockReagentTemperatureColumn],
             reagentId:reagentsMap[index][reagentIdColumn],
             category: reagentsMap[index][reagentCategoryColumn],
             subCategory: reagentsMap[index][reagentSubCategoryColumn]
         );
       });
    }
    return reagentsList;
  }
  Future<bool> _isReagentHasLotNearExpire(int reagentId)async
  {
    bool nearExpire=false;
    List<Lot> lots=await LotDatabase().getAllModelsData(rowId: reagentId);
    for(var lot in lots)
    {
      if(MyDate.isNearExpire(MyDate.toDate(lot.lotExpireDate)))
      {
        nearExpire=true;
      }
    }
    return nearExpire;
  }
  Future<List<Map<String, dynamic>>> reagentsToMap(List<Reagent> reagents)async
  {
    List<Map<String,dynamic>> reagentsMap=[];
    for(var reagent in reagents)
    {
      bool nearExpire=await _isReagentHasLotNearExpire(reagent.reagentId);
      int c=await getReagentCount(reagent.reagentId);
      Map<String,dynamic> reagentMap=
      {
        reagentNameKey:reagent.reagentName,
        reagentIdKey:reagent.reagentId,
        minimumStockLevelKey:reagent.minStockLevel,
        reagentCountKey:c,
        nearExpireKey:nearExpire
      };
      reagentsMap.add(reagentMap);
    }
    return reagentsMap;
  }
  Future<List<Map<String, dynamic>>>setReagentMap({String? order1,String? order2})async
  {
    List<Reagent> reagentsList=await getAllModelsData(order1: order1,order2: order2);
    return reagentsToMap(reagentsList);
  }
  Future<List<Map<String, dynamic>>>setSearchedReagentMap(String word)async
  {
    List<Reagent> reagentsList=await getSearchedReagent(word);
    return reagentsToMap(reagentsList);
  }

}