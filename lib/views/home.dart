import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stock/Helper/const_views.dart';
import 'package:stock/Helper/constants.dart';
import 'package:stock/bloc/app_states.dart';
import 'package:stock/bloc/home_bloc.dart';
class HomePage extends StatelessWidget {
    const HomePage({Key? key}) : super(key: key);
    @override
  Widget build(BuildContext context) {
      return
      BlocProvider(
        create:(context)=>HomeBloc() ,
        child: BlocConsumer<HomeBloc,AppStates>(
          listener:(context,state){} ,
          builder:(context,state) {
            HomeBloc model=HomeBloc.instance(context);
            if(model.oldest) {
              model.setReagentsMap();
            }
            if(model.newest)
            {
              model.setReagentsMap(order1: '$reagentIdColumn desc');
            }
            if(model.name)
            {
              model.setReagentsMap(order1: reagentNameColumn );
            }
            if(model.category)
            {
              model.setReagentsMap(order1: reagentCategoryColumn ,order2:reagentSubCategoryColumn );
            }
            return Scaffold(
            appBar: AppBar(title: const Text('home page'),),
            body:
            Padding(
                  padding: const EdgeInsets.only(top:10,left: 8,right: 8),
                  child: SizedBox(
                  width: double.infinity,
                  child: model.reagentsMap.length<=0?SizedBox(
                    height: double.infinity,
                    child: Center(child: Text('click on button to add reagents'),),
                  ):Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Visibility(
                        visible: model.isVisible,
                        child: searchContainer(() {
                          Navigator.pushNamed(context,searchReagentPageRoute);
                        },true),
                      ),
                      Visibility(
                          visible:model.isVisible,
                          child: SizedBox(height: 10,)),
                      sortList(isVisible:model.isVisible, onTap: (){
                        model.showSorting();
                      }),
                       model.isSorted?
                       Card(
                        child: SizedBox(
                          width: 120,
                          child: Column(
                            children: [
                              sortedContainer(onTap: (){
                                model.oldestSorting();

                              }, text: 'oldest',isChecked: model.oldest),
                              const SizedBox(height: 5,),
                              sortedContainer(onTap: (){
                                model.newestSorting();
                              }, text:'newest',isChecked: model.newest),
                              const SizedBox(height: 5,),
                              sortedContainer(onTap: (){
                                model.nameSorting();
                              }, text:'name',isChecked:model.name),
                              const SizedBox(height: 5,),
                              sortedContainer(onTap: (){
                                model.categorySorting();
                              }, text: 'category',
                                  isChecked: model.category)
                                      ],
                          ),
                        ),
                      ):const SizedBox(width: 0,),
              Expanded(
                child: NotificationListener<UserScrollNotification>(
                    onNotification: (notification){
                      if(notification.direction==ScrollDirection.reverse)
                      {
                        model.changeScroll();
                      }
                      else if(notification.direction==ScrollDirection.forward)
                      {
                        model.changeScroll();
                      }
                      return true;
                    },
                    child:
                    ListView.builder(
                        itemBuilder:(context,index)=>
                            GestureDetector(
                              onTap: (){
                                Navigator.pushNamed(context,reagentPageRoute,
                                arguments: {
                                reagentIdKey:model.reagentsMap[index][reagentIdKey]
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
                                      Expanded(child: Text(model.reagentsMap[index][reagentNameKey]
                                        ,style: customStyle(
                                            color: model.reagentsMap[index][nearExpireKey]==true?Colors.red:
                                            Colors.blue
                                        ), )),
                                      Text('${model.reagentsMap[index][reagentCountKey]}',
                                        style:customStyle() ,),
                                      const SizedBox(width: 5,),
                                      model.reagentsMap[index][minimumStockLevelKey]>=model.reagentsMap[index][reagentCountKey]?
                                      const Icon(Icons.error_outline,color:Colors.red):const SizedBox(width: 0,)
                                    ],
                                  ),
                                ),
                              ),
                            ),
                      itemCount: model.reagentsMap.length,
                    )
                ),
              )
                    ]
                      ),
                  ),
                )
              ,
              floatingActionButton: Visibility(
              visible:model.isVisible,
              child: FloatingActionButton(
                   elevation: 20,
                  onPressed: (){
                     Navigator.pushNamed(context,addReagentPageRoute,arguments:
                     {
                       'adding':'adding'
                     });
                // showDialog(context: context, builder:(ctx){
                //   return AlertDialog(content: AddReagentView());
                // }).then((value){
                //   // context.read<HomeProvider>().getReagents();
                //   // context.read<HomeProvider>().getReagentsCount();
                // });
              },child:  const CircleAvatar(
                radius: 100,
                backgroundColor: Colors.white,
                  child: Icon(Icons.add,color: Colors.blue,))),
            ),
          );
          },
        ),
      );
    }
Widget searchContainer(void Function() onTap,bool isvisible)
{
  return Visibility(
    visible:isvisible,
    child:
    GestureDetector(
       onTap: onTap
      //(){
      //   Navigator.pushNamed(context, '/searchedview');
      // }
        ,
      child: Container(
        width: double.infinity,
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.grey[350],
          border: Border.all(color:Colors.black54),
        ),
        padding: const EdgeInsets.only(left: 10),
        child: Row(
          children: const [
            Icon(Icons.search),
            SizedBox(width: 50,),
            Text('click to search'),

          ],
        ),
      ),
    ),
  );
}
Widget sortList({required bool isVisible,required void Function() onTap})
{
  return Visibility(
    visible: isVisible,
    child: GestureDetector(
      onTap:
      onTap
      //     (){
      //   model.showSorting();
      // }
      ,
      child: Row(
          textBaseline: TextBaseline.alphabetic,
          children: const [
            Text('sort by'),
            Icon(Icons.arrow_drop_down)
          ]),
    ),
  );
}
Widget sortedContainer({required void Function() onTap,required String text,
  bool isChecked=true})
{
  return GestureDetector(
    onTap: onTap,
    child: Container(
      padding: EdgeInsets.only(left: 5),
      child: Row(
        children: [
          Expanded(
            child: Text(text,style: customStyle(
                weight: FontWeight.normal,
                size: 20
            )),
          ),
          // const SizedBox(width: 10,),
          Container(
            width: 25,
            height: 25,
            decoration: BoxDecoration(
                border: Border.all(color: Colors.grey)
            ),
            child:isChecked?const Icon(Icons.check):null,
          )
        ],
      ),
    ),
  );
}
// Expanded(
// child:


}
