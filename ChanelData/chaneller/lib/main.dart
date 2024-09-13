import 'package:chaneller/Canal.dart';
import 'package:chaneller/Codigo.dart';
import 'package:flutter/material.dart';
import 'package:chaneller/alfabetoD.dart';
import 'package:chaneller/fuente.dart';
import 'package:provider/provider.dart';
import 'package:chaneller/manager.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CodeState(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
        
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        ),
        home: const MyHomePage(),
      ),
      
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    
    void actualizarPagina(int index) {
      setState(() {
        selectedIndex = index;
      });
    }

    Widget page;
    switch (selectedIndex) {
      case 1:
        page = Fuente(onActualizar: actualizarPagina,);
        break;
      case 0:
        page = BigPage(onActualizar: actualizarPagina,);
        break;
      case 2:
        page = Alfabeto(onActualizar: actualizarPagina,);
        break;
      case 3:
        page = Codigo(onActualizar: actualizarPagina,);
        break;
      case 4:
        page = Canal(onActualizar: actualizarPagina,);
        break;
      default:
        page =  BigPage(onActualizar: actualizarPagina,);
        
    }

    return LayoutBuilder(builder: (context, constraints) {
      return Scaffold(
        body: 
        Container(
          color: Theme.of(context).colorScheme.primaryContainer,
          child: page,
        ),
            
      );
    });
  }
}

class BigPage extends StatelessWidget {
  const BigPage({super.key, required this.onActualizar});

  final Function(int) onActualizar;
  @override
  Widget build(BuildContext context) {
    var estados = context.watch<CodeState>().getStates();
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        
        title: Text("Codigos Fuente",
        style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),),

      ),
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      body: SingleChildScrollView(
        child: 
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
              SizedBox(height: screenHeight*0.2,width: screenWidth*0.2,),
              Center(child:
               Row(mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(estados[0]),
                  SizedBox(width: screenWidth*0.02),
                  ElevatedButton(
                    onPressed: (){
                      onActualizar(1);
                    }, child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                        SizedBox(height: screenHeight*0.02,),
                        Text("Fuente",style: TextStyle(fontSize: screenWidth*0.03),),
                        Text("S",style: TextStyle(fontSize: screenWidth*0.05),),
                        SizedBox(height: screenHeight*0.02,),
                        ]),
                    
                  ),
                  SizedBox(height: screenHeight*0.1,width: screenWidth*0.1,),
                  Center(
                    child: ElevatedButton(
                      onPressed: (){
                        onActualizar(2);
                      }, child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                          SizedBox(height: screenHeight*0.02,),
                          Text("Alfabeto",style: TextStyle(fontSize: screenWidth*0.03),),
                        Text("D",style: TextStyle(fontSize: screenWidth*0.05),),
                          SizedBox(height: screenHeight*0.02,),
                          ]),
                    ),
                  ),
                  SizedBox(width: screenWidth*0.02,),
                  Text(estados[1]),
                ],
              ),),
              SizedBox(height: screenHeight*0.1),
              Row(mainAxisAlignment: MainAxisAlignment.center,
                children: [
                    Text(estados[2]),
                     SizedBox(width: screenWidth*0.02),
                    ElevatedButton(
                    onPressed: (){
                      onActualizar(3);
                    }, child:  Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                        SizedBox(height: screenHeight*0.02,),
                        Text("Codigo",style: TextStyle(fontSize: screenWidth*0.04),),
                        Row(
                          children: [
                            Text("C",style: TextStyle(fontSize: screenWidth*0.06),),
                            Column(
                              children: [
                                Text("+",style: TextStyle(fontSize: screenWidth*0.04),),
                                SizedBox(height: screenHeight*0.02,),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: screenHeight*0.02,),
                        ]),
                    
                    ),
                    SizedBox(width: screenHeight*0.1,),

                ]),
                SizedBox(height: screenHeight*0.1),
                Row(mainAxisAlignment: MainAxisAlignment.center,
                children: [
                    Text(estados[3]),
                     SizedBox(width: screenWidth*0.02),
                    ElevatedButton(
                    onPressed: (){
                      if(estados[3]!="Canal\nInactivo"){
                        onActualizar(4);
                      }
                    }, child:  Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                        SizedBox(height: screenHeight*0.02,),
                        Text("Canal",style: TextStyle(fontSize: screenWidth*0.04),),
                        Row(
                          children: [
                            Text("===",style: TextStyle(fontSize: screenWidth*0.06),),
                            
                          ],
                        ),
                        SizedBox(height: screenHeight*0.02,),
                        ]),
                    
                    ),
                    SizedBox(width: screenHeight*0.1,),

                ]),
            ],)
      ),
    );
  }
}
