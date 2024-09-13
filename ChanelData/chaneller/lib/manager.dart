import 'dart:ffi';
import 'dart:math';


import 'package:flutter/material.dart';



class CodeState extends ChangeNotifier{

  TreeOne fatherRoot = TreeOne(probability: 1,asignacionFuente: -1);

  List<SimbolFuente> _fuente = [];
  List<SimbolFuente> get fuente => _fuente;

  List<SimbolA> _alfabet = [];
  List<SimbolA> get alfabet => _alfabet;

  List<String> _code = [];
  List<String> get code => _code;



  List<Porcentaje> _percen = [];
  int Multiple = 0;
  String texExam = "";
  List<Porcentaje> get percen => _percen;

  List<String> _letters = [
    'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm','n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z'
  ];

  List<String> _numbers = [
    '0', '1', '2', '3', '4', '5', '6', '7', '8', '9'
    ];

  List<String> _bin = [
    '0', '1'
  ];

  List<String> _tri = [
    '0', '1','2'
  ];

  List<String> _octa = [
    '0', '1', '2', '3', '4', '5', '6', '7', '8'
  ];

  List<String> _hexa = [
    '0', '1', '2', '3', '4', '5', '6', '7', '8', '9',     'a', 'b', 'c', 'd', 'e', 'f'
  ];

  String CodableText ="";
  String CodedText ="";

  String deCodableText ="";

  String deCodedText ="";


  void changeCodable(String newcode){
    CodableText = newcode;
    CodedText = "";
    var a= "";
    for (var element in CodableText.characters) {
      a += element;
      if(fuente.indexWhere((fue)=>fue.text ==a)!=-1){
        CodedText += code[fuente.indexWhere((fue)=>fue.text ==a)];
        a = "";
      }else{
        if(fuente.indexWhere((fue)=>fue.text ==element)!=-1){
          if(a!=""){
            CodedText +=" ";
          }
          CodedText += code[fuente.indexWhere((fue)=>fue.text ==element)];
          a = "";
        }
      }
    }
    CodedText +=" ";
    notifyListeners();
  }

  void changedeCodable(String newcode){
    deCodableText = newcode;
    deCodedText = "";
    var a= "";
    for (var element in deCodableText.characters) {
      a += element;
      if(code.contains(a)){
        deCodedText += fuente[code.indexOf(a)].text;
        a = "";
      }else{
        if(code.contains(element)){
          if(a!=""){
            deCodedText +=" ";
          }
          deCodedText += fuente[code.indexOf(element)].text;
          a = "";
        }
      }
    }
    deCodedText +=" ";
    notifyListeners();
  }

  void addSimbol(String text) {
    for (var simbol in _fuente) {
      if(simbol.text == text){
        return;
      }
    }
    _fuente.add(SimbolFuente(text: text));
    _code.add("");
    addPercent();
    notifyListeners();
  }

  void addSimbolAlfa(String text) {
    if(text ==""||text == " "){
      return;
    }
    for (var simbol in _alfabet) {
      if(simbol.text[0] == text){
        return;
      }
    }
    _alfabet.add(SimbolA(text: text[0]));
    resetCode();
    notifyListeners();
  }

  void editSimbol(int index, String newText) {
    _fuente[index].text = newText;
    _fuente[index].isEditing = false;
    notifyListeners();
  }

  void editCode(int index, String newText) {
    if(newText.length>1){
      _code[index]="";
    }else if(newText ==""){
      if(_code[index].length>0){
        _code[index]=_code[index].substring(0,_code[index].length-1);  
      }
      
    }else{
      _code[index]=_code[index]+newText;
    }
    notifyListeners();
  }

  void editSimbolAlf(int index, String newText) {
    _alfabet[index].text = newText[0];
    _alfabet[index].isEditing = false;
    resetCode();
    notifyListeners();
  }

  void resetCode(){
    for (int i =0;i<code.length;i++) {
      _code[i] = "";
    }
    notifyListeners();
  }
  void equalPercent(){
    var lenght = percen.length;
    for(var i = 0;i <lenght;i++){
      _percen[i].porcentaje=  double.parse((1/lenght).toStringAsFixed(5));
    }
    notifyListeners();
  }

  void editPercent(int index,String newPer,bool base){
    var ti = 1;
    if(base){
      ti = Multiple;
    }
    try{
      _percen[index].porcentaje = double.parse((double.parse(newPer)/ti).toStringAsFixed(5));
    }catch(error){
    }
    
    notifyListeners();
  }

 

  void addPercent(){
    var lenght = percen.length;
    var tot = 0.0;
    for(var i = 0;i <lenght;i++){
      var adder =  double.parse((_percen[i].porcentaje*1/(lenght+1)).toStringAsFixed(5));
      _percen[i].porcentaje-= adder;
      tot +=adder;
    }
    if(lenght==0){
      tot = 1.0;
    }
    tot = double.parse((tot).toStringAsFixed(5));
    _percen.add(Porcentaje(porcentaje: tot));
    Multiple+=1;

    limitPercent();
    notifyListeners();
  }

  String totalPercent(){
    var lenght = percen.length;
    var tot = 0.0;
    for(var i = 0;i <lenght;i++){
      tot +=_percen[i].porcentaje;
    }
    tot=tot*100;
    return tot.toStringAsFixed(2);
  }

  void deletePercent(double moved){
    var lenght = percen.length;
    for(var i = 0;i <lenght;i++){
      var adder =  _percen[i].porcentaje*moved;
      _percen[i].porcentaje+= adder;
    }
    limitPercent();
    Multiple-=1;
  }


  void deleteSimbol(int index) {
    _fuente.removeAt(index);
    _code.removeAt(index);    
    deletePercent(_percen.removeAt(index).porcentaje);
    notifyListeners();
  }
  void deleteSimbolAl(int index) {
    _alfabet.removeAt(index);
    resetCode();
    notifyListeners();
  }

  void toggleEditing(int index) {
    _fuente[index].isEditing = !_fuente[index].isEditing;
    notifyListeners();
  }

  void toggleEditingAl(int index) {
    _alfabet[index].isEditing = !_alfabet[index].isEditing;
    notifyListeners();
  }

  void togglePercent(int index){
    _percen[index].isEditing = !_percen[index].isEditing;
    notifyListeners();
  }

  void addList(int index) {
    List<String>list = [];
    switch(index){
      case 0:
        list = _letters;
        break;
      case 1:
        list = _numbers;
        break;
      case 2:
        list = _bin;
        break;
      case 3:
        list = _hexa;
        break;
      default:
        return;
        
    }
    for (var simbol in list) {
      addSimbol(simbol);
    }

  }

  void addListAl(int index) {
    List<String>list = [];
    switch(index){
      case 0:
        list = _letters;
        break;
      case 1:
        list = _numbers;
        break;
      case 2:
        list = _bin;
        break;
      case 3:
        list = _tri;
        break;
      case 4:
        list = _octa;
        break;
      case 5:
        list = _hexa;
        break;
      default:
        return;
        
    }
    for (var simbol in list) {
      addSimbolAlfa(simbol[0]);
    }
  }

  void deleteList(int index) {
    List<String>list = [];
    switch(index){
      case 0:
        list = _letters;
        break;
      case 1:
        list = _numbers;
        break;
      case 2:
        list = _bin;
        break;
      case 3:
        list = _hexa;
        break;
      default:
        return;
        
    }
    for (var simbol in list) {
      int ind = _fuente.indexWhere((xim)=>xim.text == simbol);
      if(ind>=0){
        deleteSimbol(ind);
      }
      
    }
  }

  void deleteListAl(int index) {
    List<String>list = [];
    switch(index){
      case 0:
        list = _letters;
        break;
      case 1:
        list = _numbers;
        break;
      case 2:
        list = _bin;
        break;
      case 3:
        list = _tri;
        break;
      case 4:
        list = _octa;
        break;
      case 5:
        list = _hexa;
        break;
      default:
        return;
        
    }
    for (var simbol in list) {
      int ind = _alfabet.indexWhere((xim)=>xim.text == simbol);
      if(ind>=0){
        deleteSimbolAl(ind);
      }
      
    }
  }

  List<String> getStates(){
    List<String> estados = [];
    if(fuente.isEmpty){
      estados.add("Fuente \n Vacia");
    }else{
      estados.add("Fuente \n Lista");
    }

    if(alfabet.isEmpty){
      estados.add("Alfabeto \n Vacio");
    }else{
      estados.add("Alfabeto \n Listo");
    }
    var coderr ="";
    switch(estadoCodigo()){
      case -1:
        coderr = "Codigo\nIncompleto";
      case 0:
        coderr = "Codigo\nVacio";
      case 1: 
        coderr = "Codigo\nListo";
    }
    estados.add(coderr);

    var canal ="";

    switch(canalEstate()){
      case -1:
        canal = "Canal\nInactivo";
      case 0:
        canal = "Canal\nImpreciso";
      case 1: 
        canal = "Canal\nBloque";
      case 2: 
        canal = "Canal\nPrefijo";
    }
    
    estados.add(canal);

    return estados;
  }

  int canalEstate(){
    if(estadoCodigo() != 1){
      return -1;
    }

    if(prefijo()){
      return 2;
    }
    if(bloque()){
      return 1;
    }
    return 0;


  }

  void tradePercent(int index1,int index2){
    var codi = _percen[index1];
    _percen[index1] =_percen[index2];
    _percen[index2] = codi;
    notifyListeners();
  }

  void leverPercent(){
    var totalPercen=double.parse(totalPercent())/100;
    for (var i = 0; i < _percen.length; i++) {
      _percen[i].porcentaje = _percen[i].porcentaje/totalPercen;  
    }
    limitPercent();
    notifyListeners();
  }

  void tradeCode(int index1,int index2){
    var codi = _code[index1];
    _code[index1] =_code[index2];
    _code[index2] = codi;
    notifyListeners();
  }

  int estadoCodigo(){
    var coderr = 1;
    var anyys = false;
    for (var element in code) {
      if(element==""){
        coderr = -1;
      }else{
        anyys = true;
      }
    }
    if(!anyys){
      coderr = 0;
    }
    return coderr;
  }



  int type = 0;
  void GenerateCode(int type){
    if(code.isEmpty||alfabet.isEmpty){
      return;
    }
    switch(type){
      case 0: //bloque
        int lenght = code.length;
        var codelenght = (log(lenght)/log(alfabet.length)).ceil();
        for(int i = 0; i< lenght;i++){
          var paso = "";
          var nm = i;
          do {
            var res = nm % alfabet.length;
            paso = alfabet[res].text+paso;
            nm = (nm-res)~/alfabet.length;
          } while (nm>0);
          while(paso.length<codelenght){
            paso = alfabet[0].text+paso;
          }
          _code[i] = paso;
        }

        break;
      default:
        return;
    }
    this.type = type;
    notifyListeners();
  }

  String textoEjemplo() {
    if(texExam ==""){
      for (var simbol in fuente) {
        texExam +=simbol.text;
      }
      Multiple = _fuente.length;
    }
    return texExam;
  }

  void updateText(String newText) {
    var many = 0;
    
    for (var i = 0; i < _percen.length; i++) {
      _percen[i].porcentaje=0.0;
    }
    for (var element in newText.characters) {
      for (var i = 0; i < _percen.length; i++) {
        if(_fuente[i].text==element){
          many+=1;
          _percen[i].porcentaje+=1.0;
          break;
        }
      }
    }
    Multiple = many;
    for (var i = 0; i < _percen.length; i++) {
      _percen[i].porcentaje=_percen[i].porcentaje/Multiple;
    }
    limitPercent();
    texExam = newText;
    notifyListeners();
  }


  void Huffman(){
    List<String> fontt = fuente.map((toElement)=>toElement.text).toList();
    List<TreeOne> nodesfont = List.filled(fontt.length, TreeOne(asignacionFuente: -3));
    List<double> probability = percen.map((percen)=>percen.porcentaje).toList();
    List<String> d = alfabet.map((toElement)=>toElement.text).toList();
    for (var i = 1; i < probability.length; i++) {
      var a = i;
      for (var j = i-1; j >= 0; j--) {
        if(probability[i]>probability[j]){
          trade(fontt, i, j);
          trade(probability, i, j);
          i = j;
        }else{
          break;
        }
      }
      i=a;
    }

    

    while(probability.length>d.length){
      var father = TreeOne(asignacionFuente: -2);
      for (var i = 0; i < d.length; i++) {
        var prob = probability.removeLast();
        var fontter = fontt.removeLast(); 
        var node = nodesfont[probability.length];
        nodesfont[probability.length]  = TreeOne(asignacionFuente: -3);
        father.probability += prob;
        if(node.asignacionFuente ==-3){
          father.sons.add(TreeOne(asignacionFuente: _fuente.indexWhere((test)=>test.text==fontter),probability: prob,valorActual: d[i]));
        }else{
          node.valorActual = d[i]+node.valorActual;
          node.upSons();
          father.sons.add(node);
        }
      }
      nodesfont[probability.length]=father;
      probability.add(father.probability);
      fontt.add("");
      var look = probability.length-1;
      for (var j = look-1; j >= 0; j--) {
        
        if(probability[look]>probability[j]){
          trade(fontt, look, j);
          trade(nodesfont, look, j);
          trade(probability, look, j);
          
          look = j;


        }else{
          
          break;
        }
      }
    }
    var root = TreeOne();
    for (var i = 0; i < probability.length; i++) {
      root.probability += probability[i];
      if(nodesfont[i].asignacionFuente == -3){
        root.sons.add(TreeOne(asignacionFuente: _fuente.indexWhere((test)=>test.text==fontt[i]),probability: probability[i],valorActual: d[i]));
      }else{
        nodesfont[i].valorActual = d[i]+nodesfont[i].valorActual;
        nodesfont[i].upSons();
        root.sons.add(nodesfont[i]!);
      }
    }


    this.fatherRoot = root;
    treetoCode();
    notifyListeners();
  }

  void treetoCode(){
    resetCode();
    List<TreeOne> treeFam = [fatherRoot];

    while(treeFam.isNotEmpty){
      var poper = treeFam.removeAt(0);
      if(poper.asignacionFuente>=0){
        _code[poper.asignacionFuente]=poper.valorActual;
      }
      for (var element in poper.sons) {
        treeFam.add(element);
      }
    }

    notifyListeners();
  }

  List trade(List list,int index1,int index2){

    var lia = list[index1];

    list[index1] = list[index2];
    list[index2] = lia;
    return list;
  }
  
  void limitPercent() {
    for (var i = 0; i < _percen.length; i++) {
      _percen[i].porcentaje = double.parse((_percen[i].porcentaje).toStringAsFixed(5));
    }
  }

  double LongProm() {
    var lon = 0.0;
    for (var i = 0; i < fuente.length; i++) {
      lon += _code[i].length*_percen[i].porcentaje;
    }

    return lon;
  }

  double Entropia() {
    var lon = 0.0;
    for (var i = 0; i < fuente.length; i++) {
      lon += _percen[i].porcentaje*(log(_percen[i].porcentaje)/log(alfabet.length));
    }

    return -lon;
  }

  bool bloque(){
    var le = code[0].length;
    for (var element in code) {
      if(le != element.length){
        return false;
      }
    }

    return true;
  }

  bool prefijo(){
    for (var element in code) {
      var codi = List.from(code);
      codi.remove(element);
      for (var i = 0; i < element.length; i++) {
        var j = 0;
        while (j< codi.length) {
          if(codi[j].length<=i){
            return false;
          }else{
            if(codi[j][i] != element[i]){
              codi.removeAt(j);
              
            }else{
              j++;
            }
          }
        }
      }
      if(codi.isNotEmpty){
        return false;
      }
    }
    return true;
  }

  bool isPrefixFree() {
  // Crear una lista para almacenar todas las concatenaciones posibles
  Set<String> allConcatenations = {};
  List<String> C = List.from(code);
  List<String> C_prev = C;
  // Generar todas las concatenaciones posibles de códigos
  var a = 0;
  while(a <100 && C_prev.isNotEmpty){
      Set<String> Ci = {};

    for (String u in C) {
      for (String v in C_prev) {
        if(v.startsWith(u)){
          Ci.add(v.replaceFirst(u, ""));
        }
      }
    }

    for (String u in C_prev) {
      for (String v in C) {
        if(v.startsWith(u)){
          Ci.add(v.replaceFirst(u, ""));
        }
      }

    }

    var tri = true;
    for (var element in C_prev) {
      if(!Ci.contains(element)){
        tri = false;
        break;
      }
    }
    if(tri){
      break;
    }
    C_prev = Ci.toList();
    allConcatenations.addAll(Ci);
    a++;
  }

  for (var element in C) {
    if(allConcatenations.contains(element)){
      return false;
    }
  }


  return true; // El conjunto es un código de prefijo
}

  

}

class SimbolFuente {
  String text;
  bool isEditing;

  SimbolFuente({required this.text, this.isEditing = false});
}

class Porcentaje {
  double porcentaje;
  bool isEditing;

  Porcentaje({required this.porcentaje, this.isEditing = false});
}

class SimbolA {
  String text;
  bool isEditing;

  SimbolA({required this.text, this.isEditing = false});
}

class TreeOne{
  double probability;
  int asignacionFuente=-2;
  String valorActual ="";
  List<TreeOne> sons = [];

  void CrearHijos(List<String> alfabet){
    sons = [];
    for (var element in alfabet) {
      sons.add(TreeOne(valorActual: valorActual+element));
    }
  }

  TreeOne({this.valorActual = "",this.asignacionFuente=-1,this.probability=0.0});
  
  void upSons() {
    for (var node in sons) {
      //node.upSons();
      node.valorActual = valorActual[0]+node.valorActual;
      node.upSons();
    }
  }

  void printer(){
    print("$asignacionFuente $valorActual $probability");
    for (var node in sons) {
      node.printer();
    }
    print("don");
  }
}