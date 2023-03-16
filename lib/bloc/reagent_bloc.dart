import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stock/Model/lot.dart';
import 'package:stock/Model/lot_process.dart';
import 'package:stock/Model/reagents.dart';
import 'package:stock/bloc/app_states.dart';
import 'package:stock/database/data/lot_database.dart';
import 'package:stock/database/data/lot_process_database.dart';
import 'package:stock/database/data/reagent_database.dart';

class ReagentBloc extends Cubit<AppStates>
{
  ReagentBloc():super(InitState());
  static ReagentBloc instance(BuildContext context)=>BlocProvider.of(context);
  ReagentDataBase reagentDataBase=ReagentDataBase();
  LotDatabase lotDatabase=LotDatabase();
  LotProcessDataBase lotProcessDataBase=LotProcessDataBase();
  Reagent? reagent;
  List<Map<String,dynamic>> _lotsMap=[];
  List<Map<String,dynamic>> get lotsMap=>_lotsMap;
  bool isDeleted=false;
  bool isLessThanMinimum=false;
  changeIsDeleted()
  {
    isDeleted=true;
    emit(ChangeIsDeleted());
  }
  AppStates changeState()
  {
    if(state==SortingState())
      return UpdatingState();
    else
      return SortingState();
  }
  getReagent(int reagentId)async
  {
   reagent=await reagentDataBase.getModelData(rowId: reagentId);
   emit(GetReagentState());
  }
deleteReagent(int reagentId)async
{
  List<Lot>lots=await lotDatabase.getAllModelsData(rowId: reagentId);
  for(var l in lots)
  {
    lotProcessDataBase.deleteAllLotProcess(l.lotId);
  }
  lotDatabase.deleteAllReagentLots(reagentId);
  reagentDataBase.delete(rowId: reagentId);
  //isDeleted=true;
  emit(DeleteLotState());
}
addLot(Lot lot)
{
  lotDatabase.insert(model: lot);
  emit(AddLotState());
}
  updateLot(Lot lot,int lotId)
  {
    lotDatabase.update(model: lot, rowId: lotId);
    emit(UpdateLotState());
  }
  deleteLot(int lotId)
  {
    lotProcessDataBase.deleteAllLotProcess(lotId);
    lotDatabase.delete(rowId: lotId);
    emit(DeleteLotState());
  }
setLotsMap(int reagentId)async
{
  _lotsMap=await lotDatabase.setLotMap(reagentId);
  emit(SetLotMapState());
}
addLotProcess(LotProcess lotProcess)async
{
  lotProcessDataBase.insert(model: lotProcess);
  emit(LotProcessState());
}
 Future<int> lotProcessLength(int lotId)async
{
  List<LotProcess> lp= await lotProcessDataBase.getAllModelsData(rowId: lotId);
  return lp.length;
}
deleteExpiredLots(int reagentId)
{
  lotDatabase.deleteExpiredLots(reagentId);
  emit(changeState());
}
isReagentCountLessThanMinimum(int reagentId)async
{
  int reagentCount=await reagentDataBase.getReagentCount(reagentId);
  isLessThanMinimum=reagentCount<=reagent!.minStockLevel;
  emit(changeState());
}
}