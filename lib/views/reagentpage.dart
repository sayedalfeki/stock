import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stock/Helper/constants.dart';
import 'package:stock/Helper/date_helper.dart';
import 'package:stock/Model/lot_process.dart';
import 'package:stock/Model/lot.dart';
import 'package:stock/Model/reagents.dart';
import 'package:stock/bloc/app_states.dart';
import 'package:stock/bloc/reagent_bloc.dart';
import '../Helper/const_views.dart';
class ReagentPage extends StatelessWidget {
  const ReagentPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Map map = ModalRoute
        .of(context)!
        .settings
        .arguments as Map;
    int reagentId = map[reagentIdKey];
    //print(reagentId);
    return
      BlocProvider(
        create: (context)=>ReagentBloc()..getReagent(reagentId)
          ..deleteExpiredLots(reagentId)..isReagentCountLessThanMinimum(reagentId),
        child: BlocConsumer<ReagentBloc,AppStates>(
          listener: (context,state){},
          builder:(context,state) {
            ReagentBloc model=ReagentBloc.instance(context);
            model.getReagent(reagentId);
            model.setLotsMap(reagentId);
            model.isReagentCountLessThanMinimum(reagentId);
            return Scaffold(
              appBar: AppBar(title: const Text('reagent page'),
            actions: [
              IconButton(onPressed: (){
                Navigator.pushNamed(context,addReagentPageRoute,arguments: {
                  reagentIdKey:model.reagent!.reagentId,
                  reagentNameKey:model.reagent!.reagentName,
                  reagentTemperatureKey:model.reagent!.stockTemp,
                  reagentCategoryKey:model.reagent!.category,
                  reagentSubCategoryKey:model.reagent!.subCategory,
                  minimumStockLevelKey:model.reagent!.minStockLevel,
                });
                }, icon:const Icon(Icons.edit)),
              IconButton(onPressed: (){
                deleteReagent(model, context, reagentId);
              }, icon:const Icon(Icons.delete)),
            ],
            ),
            body:model.reagent==null?const Center(child: Text('no reagent found'),): Container(
              width: double.infinity,
              padding: const EdgeInsets.only(top: 10, left: 5, right: 5,bottom: 10),
              child:  Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.only(left: 30),
                    width: 350,
                    height: 100,
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.blue)
                    ),
                    child: Center(
                      child: Text(
                        model.reagent!.reagentName, style: const TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueAccent
                      ),),
                    ),
                  ),
                  const SizedBox(height: 10,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('${model.reagent!.category}', style: customStyle(
                        size: 25,
                        color: Colors.teal,

                      ),),
                      const SizedBox(width: 15,),
                      Text('${model.reagent!.subCategory} ',style: customStyle(
                          size: 20,
                          color: Colors.red,
                          weight: FontWeight.normal
                      ),)
                    ],
                  ),
                  const SizedBox(height: 10,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('minimum stock level :', style: customStyle(
                          color: Colors.black,size: 15
                      )),
                      const SizedBox(width: 5,),
                      Text(model.reagent!.minStockLevel.toString(),style:customStyle(
                          size:20,weight: FontWeight.w100
                      )),
                      const SizedBox(width: 20,),
                       !model.isLessThanMinimum?const SizedBox():const Icon(
                        Icons.error_outline, color: Colors.red,)
                    ],
                  ),
                  const SizedBox(height: 5,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('stock temperature : ', style: customStyle(
                          size: 15,
                          color: Colors.black
                      ),),
                      const SizedBox(width: 5,),
                      Text('${model.reagent!.stockTemp} c',style: customStyle(
                          size: 20,
                          color: Colors.red
                      ),)
                    ],
                  ),
                  const SizedBox(height: 10,),
                  model.lotsMap.isEmpty?const Expanded(child: SizedBox()):
                  Expanded(
                    child: ListView.builder(
                      itemBuilder: (ctx, index) {
                        return lotView(context, model.lotsMap, index, model.reagent!,
                            onTap: () async{
                              if(await model.lotProcessLength(model.lotsMap[index]['lot'].lotId)==0)
                              {
                                viewSnackBar(context,const Text('no processes on this lot add processes first'));
                              }
                              else {
                                Navigator.pushNamed(
                                    context, lotProcessPageRoute,
                                    arguments: {
                                      lotIdKey: model.lotsMap[index]['lot']
                                          .lotId,
                                      lotNumberKey: model.lotsMap[index]['lot']
                                          .lotNumber,
                                      reagentNameKey: model.reagent!.reagentName
                                    }
                                );
                              }
                            }
                        );
                      },
                      itemCount: model.lotsMap.length,
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.blue,
                    ),
                    width: 150,

                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.black)
                      ),
                      child: TextButton(onPressed: () {
                        showDialog(context: context, builder: (ctx) {
                          return AlertDialog(
                              content: AddLotViewUpdated(reagent: model.reagent!,));
                        }).then((value) {
                         // model.getLots(reagentId);
                        });
                      }, child:  Text('add lot'.toUpperCase(),style: customStyle(
                          size: 25,weight: FontWeight.normal
                      ),)),
                    ),
                  ),

                ],
              )
            ),
          );
          },
        ),
      );
  }

  Widget lotView(BuildContext context, List<Map<String,dynamic>> lots, int index,
      Reagent reagent,{required void Function() onTap}) {
    Lot lot=lots[index]['lot'] as Lot;
    return GestureDetector(
      onTap:onTap,
      child: Card(
        elevation: 5,
        child: Padding(
          padding: const EdgeInsets.only(left: 10, top: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                children: [
                   Text('lot number : ',style: customStyle(
                     size: 20,color: Colors.black,weight: FontWeight.normal
                   ),),
                  const SizedBox(width: 5,),
                  Text(lot.lotNumber,style: customStyle(),)
                ],
              ),
              const SizedBox(height: 10,),
              Row(
                children: [
                   Text('expire date:', style: customStyle(
                  size: 20,color: Colors.black,weight: FontWeight.normal
              ),),
                  const SizedBox(width: 5,),
                  Text(lot.lotExpireDate,style: customStyle(),),

                ],
              ),
              const SizedBox(height: 10,),
              lots[index]['near_expire']==true?Text('warning! near to expire',
              style: customStyle(weight: FontWeight.w900,size: 20,color: Colors.red),
              ):const SizedBox(),
              const SizedBox(height: 10,),
              Row(
                children: [
                  Text('quantity : ',style: customStyle(
                      size: 20,color: Colors.black,weight: FontWeight.normal
                  )),
                  const SizedBox(width: 15,),
                  Text('${lot.lotQuantity}',style: customStyle(),)
                ],
              ),
              const SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(onPressed: () {
                    showDialog(context: context, builder: (context) {
                      return AlertDialog(
                        content: LotContainer( adding:true,lot:lot ),
                      );
                    });

                  }, icon: const Icon(Icons.add,color: Colors.teal,)),
                  const SizedBox(width: 5,),
                  IconButton(onPressed:lot.lotQuantity==0?null: () {
                    showDialog(context: context, builder: (context) {
                      return AlertDialog(
                        content: LotContainer(adding: false,lot: lot,),
                      );
                    });

                  }, icon:  Icon(Icons.minimize_sharp,color:lot.lotQuantity==0?Colors.grey: Colors.teal)),
                  const SizedBox(width: 5,),
                  IconButton(onPressed: () {
                    showDialog(context: context, builder: (context) {
                      return AlertDialog(
                        content: AddLotViewUpdated(
                          reagent: reagent, lot: lot,),
                      );
                    });
                  }, icon: const Icon(Icons.edit,color: Colors.teal)),
                  IconButton(onPressed:(){
                    showDialog(context: context, builder:(context){
                      return
                        AlertDialog(
                            content: LotDeletedView(lot: lot),
                          );

                    });
                    }, icon: const Icon(Icons.delete,color: Colors.teal))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

deleteReagent(ReagentBloc model,BuildContext context,int reagentId){
  showDialog(context: context, builder:(context){
    return
      AlertDialog(
        content: SizedBox(
          width: 500,
          height: 200,
          child: Column(
            children: [
              Text('do you want to delete this reagent? '
                  ,
                  style: customStyle(
                      size: 20,
                      weight: FontWeight.bold,
                      color: Colors.red
                  )
              ),
            const SizedBox(height:10,),
            Expanded(
              child: Text('warning!!!!!\nthis will delete all data for this reagent !  continue? ',
                  style: customStyle(
                      size: 20,
                      weight: FontWeight.normal,
                      color: Colors.red
                  )
              ),
            ),
              Row(
                children: [
                  appButton(
                    width: 100,
                    onPressed:(){
                      try {
                        model.deleteReagent(reagentId);
                        model.changeIsDeleted();
                        Navigator.pop(context);

                      }catch(e)
                      {
                        viewSnackBar(context,Text(e.toString()));
                      }

                  },text:'yes',
                    style: customStyle(
                        size: 20,
                        weight: FontWeight.normal),),
                  const Expanded(child: SizedBox()),
                  appButton(
                      width: 100,
                      onPressed:(){
                     Navigator.pop(context);

                  },text:'cancel',style: customStyle(
                      size: 20,
                      weight: FontWeight.normal)),
                ],
              )
            ],
          ),
        ),
      );
  }).then((value){
    if(model.isDeleted) {
      Navigator.pop(context);
    }
  });

}
}
class LotContainer extends StatelessWidget {
   const LotContainer({Key? key, required this.adding,required this.lot}) : super(key: key);
  final bool adding;
  final Lot lot;
  @override
  Widget build(BuildContext context) {
    var formKey=GlobalKey<FormState>() ;
    TextEditingController quantityController = TextEditingController();
    TextEditingController dateController = TextEditingController(text: MyDate.dateToString(DateTime.now()));
    return BlocProvider(create:(context)=>ReagentBloc(),
    child: BlocConsumer<ReagentBloc,AppStates>(
      listener: (context,state){},
      builder: (context,state)=>
          SizedBox(
        height: 350,
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(child: Text(lot.lotNumber,style: customStyle(),)),
              const SizedBox(height: 10,),
              Expanded(
                child: appTextFormField(
                  onTap: ()async{
                    DateTime? opDate=await getDatePicker(context,DateTime.now());
                    dateController.text=MyDate.dateToString(opDate??DateTime.now());
                  },
                  controller: dateController,
                  hint: 'tap to add date',
                    label: 'date',
                  ),

                ),

              const SizedBox(height: 10,),
              Expanded(
                flex: 2,
                child: appTextFormField(
                  validator: (value){
                    if(value!.isEmpty) {
                      return 'you must enter quantity';
                    }
                    else if(adding==false&&int.parse(value)>lot.lotQuantity) {
                      return 'this quantity is greater than lot quantity';
                    }
                    return null;
                  },
                  isNum: true,
                  controller: quantityController,
                  hint: 'enter quantity',
                    label: 'quantity',
                  ),
              ),
              const SizedBox(height: 10,),
              Expanded(
                child: appButton(onPressed: () {
                  if(formKey.currentState!.validate()) {
                    if (adding) {
                      LotProcess lotProcess = LotProcess(
                          lotId: lot.lotId,
                          lotProcessDate: dateController.text,
                          lotProcessDateQuantity: lot.lotQuantity,
                          lotProcessAdding: int.parse(quantityController.text)
                      );
                      ReagentBloc.instance(context).addLotProcess(lotProcess);
                      int quantity = lot.lotQuantity +
                          int.parse(quantityController.text);
                      Lot lotUpdated = Lot(lotId: lot.lotId,
                          lotNumber: lot.lotNumber,
                          lotExpireDate: lot.lotExpireDate,
                          reagentId: lot.reagentId,
                          lotQuantity: quantity
                      );
                      ReagentBloc.instance(context).updateLot(
                          lotUpdated, lot.lotId);
                      Navigator.pop(context);
                    }
                    else {
                      if (lot.lotQuantity < int.parse(quantityController.text)) {
                        viewSnackBar(context, const Text(
                            'this quantity greater than lot quantity'));
                      }
                      else {
                        LotProcess lotProcess = LotProcess(
                            lotId: lot.lotId,
                            lotProcessDate: dateController.text,
                            lotProcessDateQuantity: lot.lotQuantity,
                            lotProcessSubtracting: int.parse(
                                quantityController.text)
                        );
                        ReagentBloc.instance(context).addLotProcess(lotProcess);
                        int quantity = lot.lotQuantity - int.parse(
                            quantityController.text);
                        Lot lotUpdated = Lot(lotId: lot.lotId,
                            lotNumber: lot.lotNumber,
                            lotExpireDate: lot.lotExpireDate,
                            reagentId: lot.reagentId,
                            lotQuantity: quantity
                        );
                        ReagentBloc.instance(context).updateLot(
                            lotUpdated, lot.lotId);
                        Navigator.pop(context);
                      }
                    }
                  }
                }, text:adding ? 'add': 'subtract')),
              const SizedBox(height: 10,),
              Expanded(
                child: appButton(onPressed: (){
                  Navigator.pop(context);
                },text:'cancel')),

            ],
          ),
        ),
      ),
    ),
    );
  }
}
class AddLotViewUpdated extends StatelessWidget {
  AddLotViewUpdated({Key? key,required this.reagent, this.lot}) : super(key: key);
  final Reagent reagent;
   Lot? lot;
   @override
  Widget build(BuildContext context) {
    var formKey=GlobalKey<FormState>();
    TextEditingController lotNumController=TextEditingController(text:lot?.lotNumber ?? '' );
    TextEditingController expireDateController=TextEditingController(text: lot?.lotExpireDate ??'');
    return BlocProvider(
        create:(context)=>ReagentBloc(),
    child: BlocConsumer<ReagentBloc,AppStates>
        (
        listener: (context,state){},
      builder: (context,state)=>SizedBox(
        width: double.infinity,
        height: 300,
        child:
        Form(
          key:formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children:  [
              Text(reagent.reagentName,style: customStyle(),),
              const SizedBox(height: 20,),
              Container(
                child: appTextFormField(
                    validator: (value){
                      if(value!.isEmpty) {
                        return 'you must enter lot number';
                      }
                      return null;
                    },
                    hint: 'enter lot number', label: 'lot number',
                    controller: lotNumController),
              ),
              const SizedBox(height: 20,),
              Container(
                child: appTextFormField(
                    validator: (value){
                      if(value!.isEmpty) {
                        return 'you must enter expire date';
                      }
                      return null;
                    },
                    hint: 'enter expire date', label: 'expire date',
                    controller: expireDateController,onTap: ()async{
                      DateTime? expireDate;
                      expireDate=await getDatePicker(context,DateTime.now());
                      if(expireDate!=null)
                      {
                        expireDateController.text=MyDate.dateToString(expireDate);
                      }
                      else
                      {
                        if(lot==null) {
                          expireDateController.text =
                              MyDate.dateToString(DateTime.now());
                        }
                      }
                    }
                ),
              ),
              const SizedBox(height: 20,),

              // Container(
              //   child: makeCustomTextField(hint: 'enter stock temperature', label: 'stock temp',
              //       controller:stockTempController ),
              // ),
              const Expanded(child: SizedBox()),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  appButton(
                      width:100,
                      onPressed: (){
                    // int quantity=int.parse(minStockController.text);
                    // context.read<HomeProvider>().addReagent(Reagent(reagentName:reagentController.text,
                    //     minStockLevel: quantity, stockTemp: stockTempController.text, reagentId: 1));
                    if(formKey.currentState!.validate()) {
                      Lot lotFields = Lot(
                          lotId: lot?.lotId ?? 1,
                          lotNumber: lotNumController.text,
                          lotExpireDate: expireDateController.text,
                          reagentId: reagent.reagentId,
                          lotQuantity: lot?.lotQuantity ?? 0);
                      if (lot == null) {
                        ReagentBloc.instance(context).addLot(lotFields);
                      }
                      else {
                        ReagentBloc.instance(context).updateLot(
                            lotFields, lot!.lotId);
                      }
                      // context.watch<HomeProvider>().getLots(reagent.reagentId);
                      Navigator.pop(context);
                    }
                  }, text: lot==null?'add lot':'update lot'),
                  const SizedBox(width: 20,),
                  appButton(
                      width: 100,
                      onPressed: (){
                    Navigator.pop(context);
                  }, text: 'cancel')
                ],
              )

            ],
          ),
        ),
      ),
        ),
    );

  }
}
class LotDeletedView extends StatelessWidget {
   const LotDeletedView({Key? key,required this.lot}) : super(key: key);
final Lot lot;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:(context)=>ReagentBloc(),
    child: BlocConsumer<ReagentBloc,AppStates>
      (
      listener:(context,state){} ,
      builder: (context,state) {
        return SizedBox(
        width: 400,
        height: 200,
        child: Column(
          children: [
            Text('do you want to delete this lot?',
                style: customStyle(
                    size: 20,
                    weight: FontWeight.w900,
                    color: Colors.red
                )
            ),
            const SizedBox(height: 15,),
            Expanded(
              child: Text(
                'warning ! this will delete all lot data and all process '
                    'confirmed on this lot!    continue?' ,
                style: customStyle(color: Colors.red,size: 15
                    ,weight: FontWeight.w300
                ),
              ),
            ),
            Row(
              children: [
                appButton(
                width: 100,
                onPressed:(){
                  ReagentBloc.instance(context).deleteLot(lot.lotId);
                  Navigator.pop(context);
                },text:'yes',
                  style: customStyle(
                      size: 20,
                      weight: FontWeight.normal),),
                const Expanded(child: SizedBox()),
                appButton(
                    width: 100,
                    onPressed:(){
                  Navigator.pop(context);

                },text:'cancel',style: customStyle(
                    size: 20,
                    weight: FontWeight.normal)),
              ],
            )
          ],
        ),
      );
      },
    ),
    );
  }
}
