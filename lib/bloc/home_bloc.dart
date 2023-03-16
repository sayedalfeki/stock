import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stock/Model/reagents.dart';
import 'package:stock/bloc/app_states.dart';
import 'package:stock/database/data/reagent_database.dart';

class HomeBloc extends Cubit<AppStates>
{
  HomeBloc():super(InitState());
  static HomeBloc instance(BuildContext context)=>BlocProvider.of(context);
  ReagentDataBase reagentDataBase=ReagentDataBase();
  List<Map<String,dynamic>> _reagentsMap=[];
  bool isSorted=false;
  bool oldest=true;
  bool newest=false;
  bool name=false;
  bool category=false;
  bool isVisible=true;
  get reagentsMap=>_reagentsMap;
  AppStates changeState()
  {
    if(state==SortingState())
      return UpdatingState();
    else
      return SortingState();
  }
  updateReagent(Reagent reagent,int reagentId)async
  {
    reagentDataBase.update(model: reagent,rowId: reagentId);
    emit(changeState());
  }

  addReagent(Reagent reagent)
  {
    try {
      reagentDataBase.insert(model: reagent);
      emit(changeState());
    }catch(e)
    {
      print(e.toString());
    }
  }
  setReagentsMap({String? order1,String? order2})async
  {
    _reagentsMap=await reagentDataBase.setReagentMap(order1: order1,order2: order2);
    emit(changeState());
  }

void showSorting()
{
  isSorted=!isSorted;
  emit(SortingState());
}
void oldestSorting()
{
  oldest=true;
  newest=false;
  name=false;
  category=false;
  isSorted=false;
  emit(changeState());
}
void newestSorting()
{
  newest=true;
  oldest=false;
  name=false;
  category=false;
  isSorted=false;
  emit(changeState());
}
  void nameSorting()
  {
    name=true;
    oldest=false;
    newest=false;
    category=false;
    isSorted=false;
    emit(changeState());
  }
  void categorySorting()
  {
    category=true;
    oldest=false;
    newest=false;
    name=false;
    isSorted=false;
    emit(changeState());
  }
  changeScroll()
  {
    isVisible=!isVisible;
    emit(changeState());
  }
}