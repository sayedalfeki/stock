import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stock/Helper/const_views.dart';
import 'package:stock/Helper/constants.dart';
import 'package:stock/bloc/app_states.dart';
import 'package:stock/bloc/search_bloc.dart';
class SearchPage extends StatelessWidget {
  const SearchPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return
      BlocProvider(
        create:(context)=>SearchBloc() ,
        child: BlocConsumer<SearchBloc,AppStates>(
          listener:(context,state){} ,
          builder:(context,state) {
            SearchBloc model=SearchBloc.instance(context);

            return Scaffold(
              appBar: AppBar(title: const Text('search page'),),
              body:
              Padding(
                padding: const EdgeInsets.only(top:10,left: 8,right: 8),
                child: SizedBox(
                  width: double.infinity,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                       appTextFormField(onChanged:(value){
                         if(value!.isNotEmpty) {
                           model.setSearchedReagentsMap(value);
                         }
                         model.clearSearchMap();
                       },
                           label: 'search',hint: 'enter your searched word'),
                        Expanded(
                          child: ListView.builder(
                            itemBuilder:(context,index)=>
                                GestureDetector(
                                  onTap: (){
                                    Navigator.pushNamed(context,reagentPageRoute,
                                    arguments: {
                                    reagentIdKey:model.searchedReagentsMap[index][reagentIdKey]
                                    }
                                    );
                                  },
                                  child: Card(
                                    elevation: 20,
                                    child: Container(
                                      padding: const EdgeInsets.only(left: 10,right: 10),
                                      height: 120,
                                      child: Row(
                                        children: [
                                          Expanded(child: Text(model.searchedReagentsMap[index]['reagentName']
                                            ,style: customStyle(
                                                color: model.searchedReagentsMap[index]['nearExpire']==true?Colors.red:
                                                Colors.blue
                                            ), )),
                                          Text('${model.searchedReagentsMap[index]['reagentCount']}',
                                            style:customStyle() ,),
                                          const SizedBox(width: 5,),
                                          model.searchedReagentsMap[index]['minimumStockLevel']>=model.searchedReagentsMap[index]['reagentCount']?
                                          const Icon(Icons.error_outline,color:Colors.red):const SizedBox(width: 0,)
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                            itemCount: model.searchedReagentsMap.length,
                          ),
                        )
                      ]
                  ),
                ),
              )

            );
          },
        ),
      );
  }

}

