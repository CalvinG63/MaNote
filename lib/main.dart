import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: const MyHomePage(title: 'Calcul ta note'),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

final tffNbPtsObtained = TextEditingController();
final tffNbPtsTotal = TextEditingController();

class _MyHomePageState extends State<MyHomePage> {

  bool bRounding = false;

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  showMarkDialog(BuildContext context, double dblMark) {

    // set up the button
    Widget okButton = TextButton(
      child: Text("OK"),
      onPressed: () => Navigator.pop(context),
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Votre note"),
      content: Text("Votre note est de : " + dblMark.toStringAsFixed(2)),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  showErrorDialog(BuildContext context, String strMessage) {

    // set up the button
    Widget okButton = TextButton(
      child: Text("OK"),
      onPressed: () => Navigator.pop(context),
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Erreur"),
      content: Text(strMessage),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }


  double getNumber(double input, int precision) =>
      double.parse('$input'.substring(0, '$input'.indexOf('.') + precision + 1));

  void validate() {

    double dblMark;
    String strMessage;

    if (tffNbPtsObtained.text.isEmpty)
      {
        strMessage = "Vous n'avez pas indiqué le nombre de point(s) obtenu(s).";
        showErrorDialog(context, strMessage);
      }
    else if (tffNbPtsTotal.text.isEmpty)
      {
        strMessage = "Vous n'avez pas indiqué le nombre de point(s) total.";
        showErrorDialog(context, strMessage);
      }
    else if (double.parse(tffNbPtsTotal.text) < 1)
    {
      strMessage = "Le nombre de point total ne peut pas être inférieur à 1.";
      showErrorDialog(context, strMessage);
    }
    else
    {
      double dblNbPtsObtained = double.parse(tffNbPtsObtained.text);
      double dblNbPtsTotal = double.parse(tffNbPtsTotal.text);

      if (dblNbPtsObtained > dblNbPtsTotal) {
        strMessage =
        "Merci d'entrer un nombre de point(s) total supérieur au nombre de point(s) obtenu(s).";
        showErrorDialog(context, strMessage);
      }
      else {
        if(getNumber(dblNbPtsObtained, 0) != dblNbPtsObtained)
          dblNbPtsObtained = getNumber(dblNbPtsObtained, 0) + 1;

        dblMark = dblNbPtsObtained / dblNbPtsTotal * 5 + 1;

        if(bRounding)
        {
          double dblDecimal = dblMark - getNumber(dblMark, 0);
          if(dblDecimal >= 0.75)
            dblMark = getNumber(dblMark, 0) + 1;
          else if(dblDecimal >= 0.25)
            dblMark = getNumber(dblMark, 0) + 0.5;
          else
            dblMark = getNumber(dblMark, 0);
        }
       showMarkDialog(context, dblMark);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: new Center(child: new Text(widget.title, textAlign: TextAlign.center)),
      ),
      body: Container(
        margin: EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            TextFormField(
              controller: tffNbPtsObtained,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.fromLTRB(10, 10, 10, 10),

                labelText: 'Nombre de point(s) obtenu(s)',
                hintText: "Exemple : 50",
                labelStyle: TextStyle(
                    fontSize: 15,
                    color: Colors.black),
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[0-9.]+')),],
              maxLength: 5,
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: tffNbPtsTotal,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                labelText: 'Nombre de point(s) total',
                hintText: "Exemple : 50",
                labelStyle: TextStyle(
                    fontSize: 15,
                    color: Colors.black),
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[0-9.]+')),],
              maxLength: 5,
            ),

            CheckboxListTile(
            title: Text("Arrondir la note"),
            value: bRounding,
            onChanged: (value) {
            setState(() {
            bRounding = !bRounding;
            });},
            controlAffinity: ListTileControlAffinity.leading,
              contentPadding: EdgeInsets.zero,
            ),
            SizedBox(height: 10),
            RaisedButton(
             onPressed: () { validate(); },
             color: Colors.indigo,

             child: Text('Calculer', style: TextStyle(fontSize: 16)),
             textColor: Colors.white,
             shape: RoundedRectangleBorder(
                 borderRadius: BorderRadius.circular(20.0),
                )
              ),

          ],
        ),
      ),
    );
  }
}
