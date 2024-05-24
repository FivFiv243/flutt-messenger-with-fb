import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
// ignore: must_be_immutable
class ConfirmerPassAutho extends StatefulWidget {
   ConfirmerPassAutho({super.key, required this.toggle, required this.controller});
  var toggle;
  final controller;
  @override
  State<ConfirmerPassAutho> createState() => _ConfirmerPassAuthoState();
}


class _ConfirmerPassAuthoState extends State<ConfirmerPassAutho> {
      var sizeLog;
      var sizeReg;
void InitSizes(double size1, double size2, double value){
  if(sizeReg == null){setState((){sizeReg = size2 * value; sizeLog = size1 *value;});};
}
  @override
void initState() {
    // TODO: implement initState
    super.initState();
  }
  Widget build(BuildContext context) {

    final QueryLenght = MediaQuery.of(context).size.width;
    final QueryHight = MediaQuery.of(context).size.height; 
    return TweenAnimationBuilder(
      tween: Tween(
        begin: widget.toggle ? QueryLenght/QueryLenght: QueryLenght/2.38+40 ,
        end: widget.toggle ? QueryLenght/2.38+40 : QueryLenght/QueryLenght,
      ),
      curve: Curves.easeOut,
      duration: Duration(milliseconds: 1000),
      builder: (BuildContext context,double value, _) {
        return Positioned(
                          height: QueryHight/5,
                          width: QueryHight/1.3,
                          right: value,
                          child: Container(
                            width: QueryLenght/1.3,
                            child: TextField(
                            style: TextStyle(color: Theme.of(context).textTheme.bodyMedium?.color),
                          decoration: InputDecoration(
                            icon: Icon(Icons.lock_person),
                            labelText: 'Confirm your password',
                            border: OutlineInputBorder(),
                            disabledBorder:OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                              borderSide: BorderSide(
                                color: Colors.grey,
                                width:1,
                                style: BorderStyle.solid,
                              )
                            ),
                          ),
                        controller: widget.controller,maxLength: 64,
                        onChanged: (value) => widget.controller.text,),
                          ),
                        );

      }
    );
  }
}