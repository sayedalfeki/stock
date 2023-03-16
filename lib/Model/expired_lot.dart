import 'package:stock/Helper/constants.dart';
import 'package:stock/Model/model.dart';

class ExpiredLot extends BasicModel
{
  final int expiredLotId;
  final String expiredLotNumber;
  final String expiredLotExpireDate;
  final int expiredLotQuantity;
  final int reagentId;

  ExpiredLot( {required this.expiredLotNumber,
    required this.expiredLotExpireDate,
    required this.expiredLotQuantity, required this.reagentId, required this.expiredLotId}) :
        super(expiredLotId);

  @override
  Map<String, Object> toMap()
  {
    return
      {
        expiredLotIdColumn:expiredLotId,
        expiredLotNumberColumn:expiredLotNumber,
        expiredLotExpireDateColumn:expiredLotExpireDate,
        expiredLotQuantityColumn:expiredLotQuantity,
        reagentIdColumn:reagentId
      };
  }
}