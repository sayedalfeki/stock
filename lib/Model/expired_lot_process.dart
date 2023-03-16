import 'package:stock/Helper/constants.dart';
import 'package:stock/Model/model.dart';

class ExpiredLotProcess extends BasicModel
{
  final int expiredLotProcessId;
  final String expiredLotProcessDate;
  final int expiredLotProcessAdding;
  final int expiredLotProcessSubtracting;
  final int expiredLotDateQuantity;
  final int expiredLotId;

  ExpiredLotProcess({required this.expiredLotProcessId, required this.expiredLotProcessDate,
  required this.expiredLotProcessAdding,required this.expiredLotProcessSubtracting,
    required this.expiredLotDateQuantity,required this.expiredLotId}) : super(expiredLotProcessId);

  @override
  Map<String, Object> toMap()
  {
    var lotMap=
    {
      expiredLotProcessIdColumn:expiredLotProcessId,
      expiredLotProcessDateColumn:expiredLotProcessDate,
      expiredLotProcessAddingColumn:expiredLotProcessAdding,
      expiredLotProcessSubtractingColumn:expiredLotProcessSubtracting,
      expiredLotDateQuantityColumn:expiredLotDateQuantity,
      expiredLotIdColumn:expiredLotId,
    };
    //lotMap.remove(EXPIRED_LOT_TRACK_ID);
    return lotMap;
  }
}