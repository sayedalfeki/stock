
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stock/Helper/const_views.dart';
import 'package:stock/Helper/constants.dart';
import 'package:stock/Model/reagents.dart';
import 'package:stock/bloc/app_states.dart';
import 'package:stock/bloc/home_bloc.dart';
class AddReagentView extends StatelessWidget {
  const AddReagentView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Map map = ModalRoute
        .of(context)!
        .settings
        .arguments as Map;
    int? reagentId = map[reagentIdKey];
    String? reagentName= map[reagentNameKey];
    String? category= map[reagentCategoryKey];
    String? subCategory= map[reagentSubCategoryKey];
    String? stockTemp= map[reagentTemperatureKey];
    int? stockLevel= map[minimumStockLevelKey];
    var formKey=GlobalKey<FormState>();
    final TextEditingController reagentController=TextEditingController(text: reagentName??'');
    final TextEditingController minStockController=TextEditingController(text:stockLevel?.toString());
    final TextEditingController stockTempController=TextEditingController(text: stockTemp??'');
    final TextEditingController categoryController=TextEditingController(text: category??'');
    final TextEditingController subcategoryController=TextEditingController(text: subCategory??'');
    return
      BlocProvider(
        create: (BuildContext context)=>HomeBloc(),
        child: BlocConsumer<HomeBloc,AppStates>(
          listener: (context,states){},
          builder:(context,state)=>
              Scaffold(
            appBar: AppBar(title: Text(reagentId==null?'add reagent page':'update reagent page'),),
            body: Container(
              width: double.infinity,
              padding: const EdgeInsets.only(top: 20),
              child: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    children:  [
                       Text(reagentId==null?'add reagent':'update reagent',style:customStyle()),
                      const SizedBox(height: 15,),
                      appTextFormField(
                          validator: (value){
                            if(value!.isEmpty) {
                              return 'you must enter reagent name';
                            }
                            return null;
                          },
                          hint: 'enter reagent name', label: 'reagent name',
                          controller: reagentController),
                      const SizedBox(height:10,),
                      appTextFormField(
                          validator: (value){
                            if(value!.isEmpty) {
                              return 'you must enter minimum stock level ';
                            }
                            return null;
                          },
                          hint: 'enter minimum stock count for this reagent', label: 'minimum count',
                          controller: minStockController,isNum: true
                      ),
                      const SizedBox(height:10,),
                      appTextFormField(
                          validator: (value){
                            if(value!.isEmpty) {
                              return 'you must enter stock temperature';
                            }
                            return null;
                          },
                          hint: 'enter stock temperature', label: 'stock temp',
                          controller:stockTempController ),
                      const SizedBox(height:10,),
                      appTextFormField(label:'category', hint:'enter reagent category',
                      controller: categoryController
                      ),
                      const SizedBox(height:10,),
                      appTextFormField(label:'sub category', hint:'enter reagent sub category',
                      controller: subcategoryController
                      ),
                      const SizedBox(height: 150,),
                      appButton(onPressed: (){
                        if(formKey.currentState!.validate()) {
                          Reagent reagent = Reagent(
                              reagentName: reagentController.text,
                              minStockLevel: int.parse(minStockController.text),
                              stockTemp: stockTempController.text,
                              reagentId: reagentId ?? 1,
                              category: categoryController.text,
                              subCategory: subcategoryController.text
                          );
                          if (reagentId == null) {
                            HomeBloc.instance(context).addReagent(reagent);
                          } else {
                            HomeBloc.instance(context).updateReagent(
                                reagent, reagentId);
                          }
                          Navigator.pop(context);
                        }
                        //  int quantity=int.parse(minStockController.text);
                        // context.read<HomeProvider>().addReagent(Reagent
                        //   (reagentName:reagentController.text,
                        //      minStockLevel: quantity,
                        //     stockTemp: stockTempController.text,
                        //     reagentId: 1));
                        // Navigator.pop(context);
                      }, text:reagentId==null? 'add reagent':'update reagent'),
                      //const SizedBox(height: 10,),
                      // appButton(onpressed: (){
                      //   Navigator.pop(context);
                      // }, text: 'cancel')
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );

  }
}
