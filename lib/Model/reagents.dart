import 'package:stock/Helper/constants.dart';
import 'package:stock/Model/model.dart';

class Reagent extends BasicModel
{
  final int reagentId;
  final String reagentName;
  final  int minStockLevel;
  final String stockTemp;
  final String? category;
  final String? subCategory;
  Reagent({required this.reagentName,required this.minStockLevel,required this.stockTemp,
  required this.reagentId,this.category,this.subCategory}):super(reagentId);
  @override
  Map<String, Object> toMap()
  {
    Map<String, Object> reagentMap= {
      reagentIdColumn:reagentId,
      reagentNameColumn:reagentName,
      reagentMinimumStockLevelColumn:minStockLevel,
      stockReagentTemperatureColumn:stockTemp,
      reagentCategoryColumn:category??'no category',
      reagentSubCategoryColumn:subCategory??'no subCategory'
    };
    reagentMap.remove(reagentIdColumn);
    return reagentMap;
  }
}