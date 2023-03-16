import 'package:flutter/material.dart';
import 'package:stock/Helper/constants.dart';
import 'package:stock/views/add_reagent_page.dart';
import 'package:stock/views/home.dart';
import 'package:stock/views/lot_process.dart';
import 'package:stock/views/reagentpage.dart';
import 'package:stock/views/searchedview.dart';
void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    runApp( MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
   homeRoute: (c) =>const HomePage(),
   addReagentPageRoute: (c)=> const AddReagentView(),
   searchReagentPageRoute: (c)=>const SearchPage(),
    reagentPageRoute: (c)=>const ReagentPage(),
    lotProcessPageRoute: (c)=>const LotProcessPage()
      },
initialRoute: '/'
    ));
  }
  catch(e)
  {
    print(e.toString());
  }
}

