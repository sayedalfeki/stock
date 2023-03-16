import 'package:stock/Helper/constants.dart';
import 'package:stock/Model/model.dart';

class LotProcess extends BasicModel
{
  final int lotProcessId;
  final String lotProcessDate;
  final int lotProcessAdding;
  final int lotProcessSubtracting;
  final int lotProcessDateQuantity;
  final int lotId;
  LotProcess({
    required this.lotProcessDate, this.lotProcessAdding=0,this.lotProcessSubtracting=0,
    required this.lotProcessDateQuantity,required this.lotId,this.lotProcessId=0
}) : super(lotProcessId);
  @override
  Map<String, Object> toMap()
  {
    var lotMap=
      {
        lotProcessIdColumn:lotProcessId,
        lotProcessDateColumn:lotProcessDate,
        lotProcessAddingColumn:lotProcessAdding,
        lotProcessSubtractingColumn:lotProcessSubtracting,
        lotDateQuantityColumn:lotProcessDateQuantity,
        lotIdColumn:lotId,

      };
    lotMap.remove(lotProcessIdColumn);
    return lotMap;
  }
}