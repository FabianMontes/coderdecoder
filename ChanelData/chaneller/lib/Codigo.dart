import "package:flutter/material.dart";
import "package:flutter/widgets.dart";
import "package:provider/provider.dart";
import "package:chaneller/manager.dart";
import "package:flutter_math_fork/flutter_math.dart";

class Codigo extends StatelessWidget {
  const Codigo({super.key,required this.onActualizar});
  final Function(int) onActualizar;
  final String title = "Codigo de la fuente";
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<CodeState>();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        leading: BackButton(onPressed: (){
          appState.leverPercent();
          onActualizar(0);
        },),
        title: Text(title,
        style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),),

      ),
      body: CodePage(appState: appState),
    );
  }
}

class CodePage extends StatefulWidget {
  const CodePage({
    super.key,
    required this.appState,
  });

  final CodeState appState;

  @override
  State<CodePage> createState() => _CodePageState();
}

class _CodePageState extends State<CodePage> {
  var selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<CodeState>();
    Widget page;
    switch (selectedIndex) {
      case 0:
        page = ManualPage();
      case 1:
        page = PercentPage();
      case 2:
        page = StatsPage();
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
                      icon: Icon(Icons.functions),
                      label: Text('S->D+'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.percent),
                      label: Text('Porcentajes'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.query_stats),
                      label: Text('Estadisticas'),
                    ),
                  ],
                  selectedIndex: selectedIndex,
                  onDestinationSelected: (value) {
                    setState(() {
                      selectedIndex = value;
                      appState.leverPercent();
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


class PercentPage extends StatefulWidget {
  const PercentPage({super.key});

  @override
  State<PercentPage> createState() => _PercentPageState();
}

class _PercentPageState extends State<PercentPage> {
  int indexSelected =-1;
  String mode = "Manual";

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<CodeState>();
    String totalPer = appState.totalPercent();
    int Multi = appState.Multiple;
    return Scaffold(
      body: SingleChildScrollView(
          
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppBar(
                title: Text('Metodo de distribucion', style: TextStyle(fontSize: 15),),
                actions: <Widget>[
                  PopupMenuButton<String>(
                    onSelected: (String value) {
                      // Acción al seleccionar una opción
                      setState(() {
                        if(value == 'Igualar'){
                          appState.equalPercent();
                          if( mode != 'Manual'&& mode != 'Razon de'){
                            mode = 'Manual';   
                          }
                        }else{
                          mode = value;
                        }


                      }); 

                    },
                    itemBuilder: (BuildContext context) {
                      return {'Manual', 'Igualar', 'Razon de','Texto',}.map((String choice) {
                        return PopupMenuItem<String>(
                          value: choice,
                          child: Text(choice),

                        );
                      }).toList();
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              
              Text("El porcentaje actual es $totalPer %"),
              mode=='Razon de'? Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text("Los Valores se Muestran en razon de"),
                TextField(
                  controller: TextEditingController(text: Multi.toString()),
                  onSubmitted: (newText) {
                    var m = appState.Multiple;
                    try{
                      m = int.parse(newText);
                    }catch(error){

                    }
                    setState(() {
                      appState.Multiple=m;
                    });
                    
                  },
                  ),

                ])
              :(mode == 'Texto'?Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text("Texto de Referencia:"),
                TextField(
                  controller: TextEditingController(text: appState.textoEjemplo()),
                  onSubmitted: (newText) {
                    print(newText);
                    appState.updateText(newText);
                    
                  },
                  ),
                  Text("El largo del texto es $Multi"),

                ]):SizedBox()),
              const SizedBox(height: 16.0),



              //mode =="Manual"?
                //BotonesEnFilaScrollable(indexer: indexSelected,):SizedBox(),
              
              const SizedBox(height: 16.0),
              
              ...appState.fuente.asMap().entries.map((entry) {
                int index = entry.key;
                int valuee = index+1;
                SimbolFuente reminder = entry.value;
                Porcentaje porcenter = appState.percen[index];
                double valor = (mode == 'Razon de'||mode == 'Texto'?(porcenter.porcentaje*Multi) : porcenter.porcentaje)*1.0;
                bool selected = false;
                if(indexSelected==index){
                  selected = true;
                }
                return ListTile(
                  tileColor : selected ? Theme.of(context).colorScheme.primaryContainer: Theme.of(context).colorScheme.onPrimary,
                  leading:
                  Text("X$valuee",style: const TextStyle(fontSize: 10),),

                  title: 
                   SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                          Text(reminder.text, style: const TextStyle(fontSize: 20)),
                          SizedBox(width: 50,),
                          porcenter.isEditing && mode != 'Texto'
                            ? SizedBox(
                              width: 100,
                              child: 
                              TextField(
                                controller: TextEditingController(text: valor.toString()),
                                onSubmitted: (newText) {
                                  setState(() {
                                    appState.editPercent(index, newText,mode == 'Razon de');
                                  });
                                  
                                },
                              ))
                            : Text(valor.toString()),
                            ],),
                  ),
                    
                  trailing:
                    mode == "Manual" || mode == 'Razon de'?
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        appState.togglePercent(index);
                      },
                    ):SizedBox(),
                  onTap: () {
                    setState(() {
                      if(mode != 'Texto' && indexSelected != -1){
                        appState.tradePercent(indexSelected,index);
                        
                        selected = true;
                      }
                      if(selected){
                        indexSelected = -1;
                      }else{
                        indexSelected = index;

                      }
                      
                    });
                  },
                );
              }),
              
          ],),
        ),
    );
  }
}


class ManualPage extends StatefulWidget {
  const ManualPage({
    super.key,
  });

  @override
  State<ManualPage> createState() => _ManualPageState();
}




class _ManualPageState extends State<ManualPage> {

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
                title: Text('Metodo de asignacion', style: TextStyle(fontSize: 20),),
                actions: <Widget>[
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
                ],
              ),
              const SizedBox(height: 16.0),

              mode =="Manual"?
                BotonesEnFilaScrollable(indexer: indexSelected,):SizedBox(),
              
              const SizedBox(height: 16.0),
              
              ...appState.fuente.asMap().entries.map((entry) {
                int index = entry.key;
                int valuee = index+1;
                SimbolFuente reminder = entry.value;
                bool selected = false;
                if(indexSelected==index){
                  selected = true;
                }
                return ListTile(
                  tileColor : selected ? Theme.of(context).colorScheme.primaryContainer: Theme.of(context).colorScheme.onPrimary,
                  leading:
                  Text("X$valuee",style: const TextStyle(fontSize: 10),),

                  title: 
                   SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                          Text(reminder.text, style: const TextStyle(fontSize: 20)),
                          SizedBox(width: 50,),
                          Text(appState.code[index], style: const TextStyle(fontSize: 20)),
                        ],),
                  ),
                    
                  trailing:
                    mode == "Manual" ?
                    Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.backspace),
                        onPressed: () {
                          appState.editCode(index,"");
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          appState.editCode(index,"  ");
                        },
                      ),
                    ],
                  ):SizedBox(),
                  onTap: () {
                    setState(() {
                      if(mode != "Manual" && indexSelected != -1){
                        appState.tradeCode(indexSelected,index);
                        
                        selected = true;
                      }
                      if(selected){
                        indexSelected = -1;
                      }else{
                        indexSelected = index;

                      }
                      
                    });
                  },
                );
              }),
              
          ],),
        ),
    );
  }
}



class BotonesEnFilaScrollable extends StatelessWidget {
  // Lista de elementos para los botones
  BotonesEnFilaScrollable({super.key,required this.indexer});

  int indexer;

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<CodeState>();
    var items = appState.alfabet;
    return Wrap(
        spacing: 8.0, // Espacio horizontal entre botones
        runSpacing: 8.0,
        children: items.map((item) {
          return ElevatedButton(
            onPressed: () {
              if(indexer != -1){
                appState.editCode(indexer, item.text);
              }
              
            },
            child: Text(item.text),
          );
        }).toList(),
    );
  }
}


class StatsPage extends StatelessWidget {
  const StatsPage({super.key});

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<CodeState>();
    var longitud = appState.LongProm();
    var entropia = appState.Entropia();
    var bloque = appState.bloque();
    var prefijo = appState.prefijo();
    //var univo = appState.isPrefixFree();
    return Scaffold(
      body: SingleChildScrollView(
        child: 
        Wrap(
          
          children: [
          Text("Estadisticas del Codigo Fuente.", style: TextStyle(fontSize: 20),),
          SizedBox(height: 40,),
          Text("Longitud media de palabra: $longitud", style: TextStyle(fontSize: 20),),
          Math.tex(
                r'L(C) = \sum_{x \in S} (p(x) \times {l(C(x))})',
                textStyle: TextStyle(fontSize: 20),
              ),
          SizedBox(height: 40,),
          Text("La Entropia del codigo: $entropia", style: TextStyle(fontSize: 20),),
          Math.tex(
                r'H(X) = - \sum_{i} ( p_i \log_2(p_i) )',
                textStyle: TextStyle(fontSize: 20),
              ),
          SizedBox(height: 40,),
          bloque?Text("Es un codigo en bloque", style: TextStyle(fontSize: 20)):Text("No es un codigo en bloque", style: TextStyle(fontSize: 20)),
          SizedBox(height: 40,),
          prefijo?Text("Es un codigo en prefijo", style: TextStyle(fontSize: 20)):Text("No es un codigo en prefijo", style: TextStyle(fontSize: 20)),
          SizedBox(height: 40,),
          //univo?Text("Es un codigo unívocamente decodificables", style: TextStyle(fontSize: 20)):Text("No es un codigo unívocamente decodificables", style: TextStyle(fontSize: 20)),


          

        ],),


      ),

    );
  }
}



class ListSimbols extends StatelessWidget {
  ListSimbols({super.key,required this.title,required this.index});

  String title;
  int index;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); 
    var appState = context.watch<CodeState>();
    return SizedBox(
      width: 150.0,
      height: 50.0,
      child: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.primaryContainer, // El color de fondo
          borderRadius: BorderRadius.circular(20.0), // Radio de las esquinas
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
          IconButton(onPressed: (){appState.deleteList(index);
          print("delete");}, icon: const Icon(Icons.remove)),
          Text(title),
          IconButton(onPressed: (){appState.addList(index);}, icon: const Icon(Icons.add))
        ],)
      ),
    );
  }
}

class SimbolF extends StatelessWidget {
  const SimbolF({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}