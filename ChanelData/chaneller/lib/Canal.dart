import "package:flutter/material.dart";
import "package:flutter/widgets.dart";
import "package:provider/provider.dart";
import "package:chaneller/manager.dart";
import "package:flutter_math_fork/flutter_math.dart";

class Canal extends StatelessWidget {
  const Canal({super.key,required this.onActualizar});
  final Function(int) onActualizar;
  final String title = "Canal de informacion";
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<CodeState>();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        leading: BackButton(onPressed: (){
          onActualizar(0);
        },),
        title: Text(title,
        style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),),

      ),
      body: CanalPage(appState: appState),
    );
  }
}

class CanalPage extends StatefulWidget {
  const CanalPage({
    super.key,
    required this.appState,
  });

  final CodeState appState;

  @override
  State<CanalPage> createState() => _CanalPageState();
}

class _CanalPageState extends State<CanalPage> {
  var selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<CodeState>();
    Widget page;
    switch (selectedIndex) {
      case 0:
        page = CoderPage();
      case 1:
        page = deCoderPage();
     
      default:
        page = Placeholder();
    }
    return LayoutBuilder(builder: (context, constraints) {
      return Scaffold(
        body: Row(
          children: [
            SafeArea(
                child: NavigationRail(
                  backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                  indicatorColor: Theme.of(context).colorScheme.primary,
                  extended: constraints.maxWidth >= 600,
                  destinations: [
                    NavigationRailDestination(
                      icon: Icon(Icons.code),
                      label: Text('encoder'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.code_off),
                      label: Text('decoder'),
                    ),
                    
                  ],
                  selectedIndex: selectedIndex,
                  onDestinationSelected: (value) {
                    setState(() {
                      selectedIndex = value;
                    });
                  },
                ),
            ),
            Expanded(
              child: Container(
                
                child: page,
              ),
            ),
          ],
        ),
      );
    });
  }
}


class CoderPage extends StatefulWidget {
  const CoderPage({
    super.key,
  });

  @override
  State<CoderPage> createState() => _CoderPageState();
}




class _CoderPageState extends State<CoderPage> {

  int indexSelected =-1;
  String mode = "Manual";

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<CodeState>();
    return Scaffold(
      body: SingleChildScrollView(
          
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppBar(
                title: Text('Codificador', style: TextStyle(fontSize: 20),),
                /*actions: <Widget>[
                  PopupMenuButton<String>(
                    onSelected: (String value) {
                      // Acción al seleccionar una opción
                      setState(() {
                        mode = value;
                        switch(value){
                          case "Bloque":
                            appState.GenerateCode(0);
                          case "Huffman":
                            appState.Huffman();
                          default:
                            
                        }

                      }); 

                    },
                    itemBuilder: (BuildContext context) {
                      return {'Manual', 'Bloque', 'Huffman'}.map((String choice) {
                        return PopupMenuItem<String>(
                          value: choice,
                          child: Text(choice),

                        );
                      }).toList();
                    },
                  ),
                ],*/
              ),
              const SizedBox(height: 16.0),
              Text("simbolos no identificados se vuelven \" \""),
              const SizedBox(height: 16.0),
              TextField(
                  controller: TextEditingController(text: appState.CodableText),
                  onSubmitted: (newText) {
                    appState.changeCodable(newText);
                    
                  },
                  ),
              const SizedBox(height: 16.0),
              SelectableText(appState.CodedText),
              
          ],),
        ),
    );
  }
}


class deCoderPage extends StatefulWidget {
  const deCoderPage({
    super.key,
  });

  @override
  State<deCoderPage> createState() => _deCoderPageState();
}




class _deCoderPageState extends State<deCoderPage> {

  int indexSelected =-1;
  String mode = "Manual";

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<CodeState>();
    return Scaffold(
      body: SingleChildScrollView(
          
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppBar(
                title: Text('deCodificador', style: TextStyle(fontSize: 20),),
                /*actions: <Widget>[
                  PopupMenuButton<String>(
                    onSelected: (String value) {
                      // Acción al seleccionar una opción
                      setState(() {
                        mode = value;
                        switch(value){
                          case "Bloque":
                            appState.GenerateCode(0);
                          case "Huffman":
                            appState.Huffman();
                          default:
                            
                        }

                      }); 

                    },
                    itemBuilder: (BuildContext context) {
                      return {'Manual', 'Bloque', 'Huffman'}.map((String choice) {
                        return PopupMenuItem<String>(
                          value: choice,
                          child: Text(choice),

                        );
                      }).toList();
                    },
                  ),
                ],*/
              ),
              const SizedBox(height: 16.0),
              Text("simbolos no identificados se vuelven \" \""),
              const SizedBox(height: 16.0),
              TextField(
                  controller: TextEditingController(text: appState.deCodableText),
                  onSubmitted: (newText) {
                    appState.changedeCodable(newText);
                    
                  },
                  ),
              const SizedBox(height: 16.0),
              SelectableText(appState.deCodedText),
              
          ],),
        ),
    );
  }
}