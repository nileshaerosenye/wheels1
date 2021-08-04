import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wheels1/Screens/LoginUser.dart';

class AddStock extends StatefulWidget {
  const AddStock({Key? key}) : super(key: key);

  static const routeName = "/AddStock";

  @override
  _AddStockState createState() => _AddStockState();
}

class _AddStockState extends State<AddStock> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late String _symbol;

  void _handleMenuItems( BuildContext context, item ) {
    switch (item) {
      case 0:
        Navigator.of(context).pushReplacementNamed(LoginUser.routeName);
        break;
      case 1:
        print("Handle Settings page");
        break;
    }
  }

  void _getStockDetails() {

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset : false,

      appBar: AppBar(
        backgroundColor: new Color.fromRGBO(70,60,0, 1),
        title: Text("X-opt"),
        centerTitle: true,
        actions: <Widget>[
          PopupMenuButton<int>(
            itemBuilder: (context) => [
              PopupMenuItem<int>(value: 0, child: Text('Login')),
              PopupMenuItem<int>(value: 1, child: Text('Settings')),
            ],
            onSelected: (item) => { _handleMenuItems( context, item ) },
          ),
        ],
      ),

      body: Container(
        padding: EdgeInsets.all(10.0),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [

                  TextFormField(
                    decoration: InputDecoration( labelText: "Symbol"),
                    keyboardType: TextInputType.name,
                    validator: ( value ) {
                      if ( value!.isEmpty ) {
                        return "Enter Stock Symbol";
                      }
                      else {
                        return null;
                      }
                    },
                    onSaved: (value) {
                      this._symbol = value!;
                    },
                  ),

                  SizedBox(height: 10.0,),

                  ElevatedButton(
                      onPressed: _getStockDetails,
                      child: Text("Get details")
                  ),

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

}
