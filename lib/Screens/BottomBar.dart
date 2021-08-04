import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wheels1/Stocks/AddStock.dart';

class BottomBar extends StatelessWidget implements PreferredSizeWidget {
  const BottomBar({Key? key}) : super(key: key);

  @override
  Size get preferredSize {
    return Size.fromHeight(5.0);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(10.0),
        child:
        Card(
          color: new Color.fromRGBO(70,60,0, 1),

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
                child: FittedBox(
                  alignment: Alignment.center,
                  fit: BoxFit.scaleDown,
                  child: Row(
                    children: [
                      // IconButton(
                      //     icon: Icon(Icons.app_registration),
                      //     onPressed: () {
                      //     }
                      // ),
                      IconButton(
                        icon: Icon(Icons.add),
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context)=> AddStock()));
                        },
                      ),
                    ],
                  ),
                ))
          ]
        ),
        ),
    );
  }
}
