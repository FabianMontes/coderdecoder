import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:chaneller/manager.dart";

class Alfabeto extends StatelessWidget {
  const Alfabeto({super.key,required this.onActualizar});
  final Function(int) onActualizar;
  final String title = "Alfabeto del Codigo. D";
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<CodeState>();
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text(title,
          style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
        ),
        leading: BackButton(onPressed: (){
          onActualizar(0);
        },)
      ),
      body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16.0),
                 Wrap(
                  spacing: screenWidth*0.02, // Espacio horizontal entre botones
                  runSpacing: screenHeight*0.02,
                  children: [
                  ListSimbols(title: "letters", index: 0),
                  ListSimbols(title: "numbers", index: 1),
                  ListSimbols(title: "binary", index: 2),
                  ListSimbols(title: "tri", index: 3),
                  ListSimbols(title: "octa", index: 4),
                  ListSimbols(title: "hex", index: 5),
                ],),
                
                const SizedBox(height: 16.0),
                ...appState.alfabet.asMap().entries.map((entry) {
                  int index = entry.key;
                  int valuee = index+1;
                  SimbolA reminder = entry.value;
                  return ListTile(
                    title:Row(children: [Text("X$valuee    ",style: const TextStyle(fontSize: 10),),reminder.isEditing
                        ? TextField(
                            controller: TextEditingController(text: reminder.text),
                            onSubmitted: (newText) {
                              appState.editSimbolAlf(index, newText);
                            },
                          )
                        : Text(reminder.text),],),
                      
                    trailing:
                     Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                            appState.toggleEditingAl(index);
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            appState.deleteSimbolAl(index);
                          },
                        ),
                      ],
                    ),
                  );
                }),
                TextField(
                  onSubmitted: (text) {
                    appState.addSimbolAlfa(text);
                    
                  },
                  decoration: const InputDecoration(
                    labelText: 'agregarSimbolo',
                    border: OutlineInputBorder(),
                  ),
                ),
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
          IconButton(onPressed: (){appState.deleteListAl(index);
          print("delete");}, icon: const Icon(Icons.remove)),
          Text(title),
          IconButton(onPressed: (){appState.addListAl(index);}, icon: const Icon(Icons.add))
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