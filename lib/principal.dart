import 'package:flutter/material.dart';

class Principal extends StatefulWidget {
  // ignore: use_super_parameters
  const Principal({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _PrincipalState createState() => _PrincipalState();
}

class _PrincipalState extends State<Principal> {

 @override
  Widget build(BuildContext context) {    
    return Scaffold(    
      backgroundColor: Colors.white,  
      body: SingleChildScrollView(
        child: Column (
        children: [ 
          SizedBox(height: MediaQuery.of(context).size.height * 0.05),
          //titulo ----------------------------------------------------------------------
          Container(
              alignment: Alignment.center,
              child: const Text(
                'MENU PRINCIPAL',
                style: TextStyle(
                  color: Color(0xFF48a0d4),
                  fontSize: 50,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),         
        ],
        ),
      ),
    );
  }
}