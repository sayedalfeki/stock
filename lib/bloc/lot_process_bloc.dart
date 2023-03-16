import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stock/Model/lot_process.dart';
import 'package:stock/bloc/app_states.dart';
import 'package:stock/database/data/lot_database.dart';
import 'package:stock/database/data/lot_process_database.dart';

class LotProcessBloc extends Cubit<AppStates> {
  LotProcessBloc() :super(InitState());

  static LotProcessBloc instance(BuildContext context) => BlocProvider.of(context);
  LotProcessDataBase lotProcessDataBase=LotProcessDataBase();
  List<LotProcess> _lotProcesses=[];
  List<LotProcess> get lotProcesses=>_lotProcesses;
  getLotProcesses(int lotId)async
  {
    _lotProcesses=await lotProcessDataBase.getAllModelsData(rowId: lotId);
    emit(GetLotProcesses());
  }
  updateLotProcessDate(int lotProcessId,String date)
  {
    lotProcessDataBase.updateLotProcessDate(lotProcessId, date);
    emit(UpdateLotProcesse());
  }
  deleteLotProcess(int lotProcessId)
  {
    lotProcessDataBase.delete(rowId:lotProcessId );
    emit(DeleteLotProcesse());
  }
  updateLotQuantity(int lotId,int quantity)
  {
    LotDatabase().updateLotQuantity(lotId, quantity);
    emit(UpdateLotState());
  }
  Future<LotProcess> getLotProcess(int lotProcessId)async
  {
    return await  lotProcessDataBase.getModelData(rowId: lotProcessId);
  }
}