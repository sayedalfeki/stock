
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stock/bloc/app_states.dart';
import 'package:stock/database/data/reagent_database.dart';

class SearchBloc extends Cubit<AppStates>
{
  SearchBloc():super(InitState());
  static SearchBloc instance(BuildContext context)=>BlocProvider.of(context);
  ReagentDataBase reagentDataBase=ReagentDataBase();
  List<Map<String,dynamic>> _searchedReagentsMap=[];
  List<Map<String,dynamic>> get searchedReagentsMap=>_searchedReagentsMap;
  AppStates changeState()
  {
    if(state==SortingState())
      return UpdatingState();
    else
      return SortingState();
  }
  setSearchedReagentsMap(String word)async
  {
    _searchedReagentsMap=await reagentDataBase.setSearchedReagentMap(word);
    emit(changeState());
  }
  clearSearchMap()
  {
    _searchedReagentsMap=[];
    emit(changeState());
  }
}