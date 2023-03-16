import 'package:flutter/material.dart';

TextStyle customStyle({Color color=Colors.blue,double size=25,FontWeight weight=FontWeight.bold})=>TextStyle(
  color: color,
  fontSize: size,
  fontWeight:weight,
);
Widget appButton({Color backgroundColor=Colors.white,required String text,TextStyle? style,
required void Function() onPressed,double height=50,double width=200})
{

  return  Container(
                     height: height,
                      width: width,
                      decoration: BoxDecoration(
                        color: backgroundColor,
                        border: Border.all(color: Colors.black)
                      ),
                      child: TextButton(onPressed: onPressed,
                          child:  Text(text.toUpperCase(),
                            style: style,)),
                    );

}
Widget appTextFormField({String? Function(String?)? validator,void Function()? onTap,
void Function(String?)? onChanged,TextEditingController? controller,bool isNum=false,
  required String label,required String hint,void Function(String)? onSubmit
})
{
  return Container(
    padding: const EdgeInsets.only(left: 10,right: 10),
    child: TextFormField(

      keyboardAppearance:Brightness.light ,
      validator: validator,
      onFieldSubmitted: onSubmit,
      onTap:onTap ,
      onChanged: onChanged,
      controller: controller,
      keyboardType:isNum?TextInputType.number:TextInputType.text ,
      decoration: InputDecoration(
        border: const OutlineInputBorder(borderSide: BorderSide(color: Colors.teal)),
        labelText: label,
        hintText: hint
      ),
    ),
  );
}
Widget appListView({required BuildContext context,required Widget widget,required List modelList})
{
  return ListView.builder(
      itemCount: modelList.length,
      itemBuilder:(context,index){
    return widget;
  });

}
Future<DateTime?> getDatePicker(BuildContext context,DateTime initialDate)async
{
  return await showDatePicker(context: context, initialDate:initialDate,
      lastDate:DateTime(2050), firstDate:DateTime(2022));
}
viewSnackBar(BuildContext context,Widget child,{int duration=2000})
{
  ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          duration: Duration(milliseconds: duration),
          content: child));
}