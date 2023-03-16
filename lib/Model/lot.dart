import 'package:stock/Helper/constants.dart';
import 'package:stock/Model/model.dart';

class Lot extends BasicModel
{
  final int lotId;
  final String lotNumber;
  final String lotExpireDate;
  final int lotQuantity;
  final int reagentId;
  Lot({required this.lotId,required this.lotNumber,required this.lotExpireDate,
    this.lotQuantity=0,required this.reagentId}) : super(lotId);
  @override
  Map<String, Object> toMap()
  {
    Map<String,Object> lotMap=
      {
        lotIdColumn:lotId,
        lotNumberColumn:lotNumber,
        lotExpireDateColumn:lotExpireDate,
        lotQuantityColumn:lotQuantity,
        reagentIdColumn:reagentId
      };
    lotMap.remove(lotIdColumn);
    return lotMap;
  }
}