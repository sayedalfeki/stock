import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stock/Helper/const_views.dart';
import 'package:stock/Helper/constants.dart';
import 'package:stock/Helper/date_helper.dart';
import 'package:stock/Model/lot_process.dart';
import 'package:stock/bloc/app_states.dart';
import 'package:stock/bloc/lot_process_bloc.dart';
class LotProcessPage extends StatelessWidget {
  const LotProcessPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Map map = ModalRoute
        .of(context)!
        .settings
        .arguments as Map;
     int lotId=map[lotIdKey];
     String lotNumber = map[lotNumberKey];
     String reagentName=map[reagentNameKey];
    return BlocProvider(
      create: (context)=>LotProcessBloc()..getLotProcesses(lotId),
      child: BlocConsumer<LotProcessBloc,AppStates>(
        listener: (context,state){},
        builder:(context,state) {
          LotProcessBloc model=LotProcessBloc.instance(context);
          model.getLotProcesses(lotId);
          return Scaffold(
          appBar: AppBar(title: const Text('lot processes'),),
          body:
             Container(
               padding: const EdgeInsets.only(top:20),
              child:  Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: 40,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white10)
                      ),
                      child: Text(reagentName,style: customStyle(),)),
                  const SizedBox(height: 10,),
                  Container(
                    height: 40,
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.white54)
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('lot Number:',style: customStyle(
                          color: Colors.black,
                          weight: FontWeight.normal,
                          size: 15
                        ),),
                        const SizedBox(width: 5,),
                        Text(lotNumber,style: customStyle(),),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10,),
                  Expanded(
                    child:
                    ListView.builder(
                        itemCount:model.lotProcesses.length,
                      itemBuilder: (con,index)=>
                         // Text('next')
                          lotProcessView(context,model.lotProcesses,index,(){
                        showDialog(context: context, builder:(context){
                          int lotProcessId=model.lotProcesses[index].lotProcessId;
                          return AlertDialog(
                            content:LotProcessDeletedView(lotProcessId: lotProcessId),
                          );
                        });
                        //model.deleteLotTrack(model.lotTracks[index].lotTrackId);
                      }
                      ,

                    ),
                  )),
                ],
              )
            ));
        },
      ),
    );
  }

  lotProcessView(BuildContext context,List<LotProcess> lotProcess,int index,
      void Function() onpressed) {
    return
      Card(
      child: Container(
        padding: const EdgeInsets.only(left: 10,top: 10),
        height: 170,
        child: Column(
          children: [

            Expanded(
              child: Row(
                children: [
                   Expanded(

                     child: Text('quantity:'.toUpperCase(),style: customStyle(
                      color: Colors.black,
                       size: 15
                  ),),
                   ),
                 // const SizedBox(width: 10,),
                  Expanded(
                      flex: 2,
                      child: Text('${lotProcess[index].lotProcessDateQuantity}',
                          style: customStyle())),
                ],
              ),
            ),
            Expanded(
              child: Row(
                children: [
                   Expanded(
                     child: Text('date :'.toUpperCase(),style: customStyle(
                  color: Colors.black,
                  size: 15
              )),
                   ),
                 // const SizedBox(width: 15,),
                  Expanded(
                      flex: 2,
                      child: Text(lotProcess[index].lotProcessDate,style: customStyle(size: 20))),
                ],
              ),
            ),
            Expanded(
              child: Row(
                children: [
                   Expanded(
                     child: Text('adding:'.toUpperCase(),style: customStyle(
                         color: Colors.black,
                         size: 15
                     )),
                   ),
                 // const SizedBox(width: 10,),
                  Text(lotProcess[index].lotProcessAdding>0?'+':'',style: customStyle(),),
                  Expanded(
                      flex: 2,
                      child: Text(' ${lotProcess[index].lotProcessAdding}',style: customStyle())),
                ],
              ),
            ),
            Expanded(
              child: Row(
                children: [
                     Expanded(
                       child: Text('subtracting:'.toUpperCase(),style: customStyle(
                           color: Colors.black,
                           size: 15
                       )),
                     ),
                    //const SizedBox(width: 10,),
                  Text(lotProcess[index].lotProcessSubtracting>0?'-':'',style: customStyle(),),

                  Expanded(
                      flex: 2,
                      child: Text(' ${lotProcess[index].lotProcessSubtracting}',style: customStyle(),)),
                ],
              ),
            ),
             Row(
               mainAxisAlignment: MainAxisAlignment.end,
               children: [
                index==lotProcess.length-1? IconButton(onPressed: onpressed,
                    icon:const Icon(Icons.delete,color: Colors.teal,)):const SizedBox(width: 0,),
                 IconButton(onPressed:(){
                   showDialog(context: context, builder:(context){
                     return AlertDialog(
                       content: UpdateLotProcessView(lotProcess: lotProcess[index]),
                     );
                   });
                 },
                     icon:const Icon(Icons.edit,color: Colors.teal,))
               ],
             )
          ],
        ),
      ),
    );
  }
}
class LotProcessDeletedView extends StatelessWidget {
  const LotProcessDeletedView({Key? key,required this.lotProcessId}) : super(key: key);
  final int lotProcessId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create:(context)=>LotProcessBloc(),
      child: BlocConsumer<LotProcessBloc,AppStates>(
        listener:(context,state){} ,
        builder:(context,state){
          LotProcessBloc model=LotProcessBloc.instance(context);
          return
            SizedBox(
            width: 400,
            height: 200,
            child: Column(
              children: [
                Text('do you want to delete this  operation on lot?',
                    style: customStyle(
                        size: 20,
                        weight: FontWeight.w900,
                        color: Colors.red
                    )
                ),
                const SizedBox(height: 15,),
                Row(
                  children: [
                    TextButton(onPressed:()async{
                      LotProcess lp=await model.getLotProcess(lotProcessId);
                      model.updateLotQuantity(lp.lotId,lp.lotProcessDateQuantity);
                      model.deleteLotProcess(lotProcessId);
                      Navigator.pop(context);
                    }, child:Text('yes'.toUpperCase(),
                      style: customStyle(
                          size: 20,
                          weight: FontWeight.normal),)),
                    const Expanded(child: SizedBox()),
                    TextButton(onPressed:(){
                      Navigator.pop(context);

                    }, child:Text('cancel'.toUpperCase(),style: customStyle(
                        size: 20,
                        weight: FontWeight.normal))),
                  ],
                )
              ],
            ),
          );
        } ,
      ),
    );
  }
}
class UpdateLotProcessView extends StatelessWidget {
   const UpdateLotProcessView({Key? key,required this.lotProcess}) : super(key: key);
  final LotProcess lotProcess;

  @override
  Widget build(BuildContext context) {
    TextEditingController lotDateController=TextEditingController(text: lotProcess.lotProcessDate);
var forKey=GlobalKey<FormState>();
    return
      BlocProvider(
          create:(context)=>LotProcessBloc(),
      child:BlocConsumer<LotProcessBloc,AppStates>
        (
        listener:(context,state){} ,
        builder:(context,state)
        {
          LotProcessBloc model=LotProcessBloc.instance(context);
          return SizedBox(
            width: double.infinity,
            height: 300,
            child: Form(
              key: forKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children:  [
                  const Text('update lot process date'),
                  const SizedBox(height: 20,),
              appTextFormField(
                    onTap:()async{
                      DateTime? date=await getDatePicker(context,MyDate.
                      toDate(lotProcess.lotProcessDate));
                      date!=null?
                      lotDateController.text=MyDate.dateToString(date):
                      lotProcess.lotProcessDate;
                    },
                    controller:lotDateController,

                        hint: 'click to add date',
                        label:'date'
                    ),

                  const SizedBox(height: 20,),
                  appButton(
                      width: 100,
                      onPressed: (){
                    model.updateLotProcessDate(lotProcess.lotProcessId,lotDateController.text,);
                    Navigator.pop(context);
                  },text:'update'),
                  const SizedBox(height: 20,),
                  appButton(
                    width: 100,
                    onPressed: (){
                    Navigator.pop(context);
                  },text:'cancel'),
                ],
              ),
            ),
          );
        } ,
      ) ,
      );
  }
}
