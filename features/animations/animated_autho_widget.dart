import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
// ignore: must_be_immutable
class SwitcherAutho extends StatefulWidget {
   SwitcherAutho({super.key, required this.toggle});
  var toggle;
  @override
  State<SwitcherAutho> createState() => _SwitcherAuthoState();
}


class _SwitcherAuthoState extends State<SwitcherAutho> {
      var sizeLog;
      var sizeReg;
void InitSizes(double size1, double size2, double value){
  if(sizeReg == null){setState((){sizeReg = size2 * value; sizeLog = size1 *value;});};
}

double sizer( bool togle, double value){
  if(togle == true){
    return value ;
  }
  else{
    return value /1.1;
  }

}

  @override
void initState() {
    // TODO: implement initState
    super.initState();
  }
  Widget build(BuildContext context) {
    final QueryLenght = MediaQuery.of(context).size.width;
    final QueryHight1 = MediaQuery.of(context).size.height/13;
    final QueryHight2 = MediaQuery.of(context).size.height/60;
    final QueryHight = MediaQuery.of(context).size.height; 
    return TweenAnimationBuilder(
      tween: Tween(
        begin: widget.toggle ? QueryLenght/QueryLenght: QueryLenght/2.38+40 ,
        end: widget.toggle ? QueryLenght/2.38+40 : QueryLenght/QueryLenght,
      ),
      curve: Curves.easeOut,
      duration: Duration(milliseconds: 1000),
      builder: (BuildContext context,double value, _) {
        return Card(
          color: Theme.of(context).scaffoldBackgroundColor,
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        side: BorderSide(width: 1, color: Colors.black26),
                        borderRadius: BorderRadius.only(
                          topRight: const Radius.circular(30),
                          bottomRight: const Radius.circular(30)
                        )
                      ),
                      margin: EdgeInsets.fromLTRB(0, 0, 0, QueryHight/70),
                        child:Container(
                          height: QueryHight/10,
                          width: QueryLenght-QueryLenght/10,
                          child: 
                             Stack(
                              children: <Widget>[
                                Positioned(
                                  bottom:QueryHight/50 ,
                                  right: value,
                                  child: 
                                Container(
                                    height: QueryHight2*3.8,
                                    width: QueryHight2*15,
                                    padding: EdgeInsets.fromLTRB(0, 0, value, 0),
                                    decoration: BoxDecoration(
                                      color: Colors.grey.withOpacity(0.5),
                                      border: Border.all(color: Colors.black38,),
                                      borderRadius: BorderRadius.circular(25),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  right: QueryLenght/2.38,
                                  bottom: QueryHight/50,
                                  height: QueryHight2*5,
                                  width: QueryHight2*14,
                                  child:
                                Text('Login', style: TextStyle(fontSize:  QueryHight1/1.2,color: Theme.of(context).textTheme.bodyMedium?.color),),
                                ),
                                Positioned(

                                  right: QueryLenght/70,
                                  bottom: QueryHight/50,
                                  height: QueryHight2*4,
                                  width: QueryHight2*14,
                                  child: 
                                Text('Registrate',style: TextStyle(fontSize: QueryHight2*3, color: Theme.of(context).textTheme.bodyMedium?.color)),
                                )
                              ],
                            )
                        ) // include here Row with Text "Login" and card Registration
                      );
      
      }
    );
  }
}

//переделать