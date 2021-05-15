import 'dart:math';
import 'package:string_validator/string_validator.dart';
import 'package:flutter/material.dart';
import 'package:fraction/fraction.dart';

class EQNSOL extends StatefulWidget {
  EQNSOL({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _EQNSOLState createState() => _EQNSOLState();
}

class _EQNSOLState extends State<EQNSOL> {
  String eqn;
  Column sol;
  final _formKey = GlobalKey<FormState>();
  List<List<double>> vals = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // solveeqn();
    sol = Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [Text(" ")],
    );
    print("WHY AM I FIRING?");
  }

  double nummy(String a) {
    print("lsoadosadnasoubdaisubfiasubfgiasbf: $a, ${a == " "}");
    if (a.isEmpty) {
      return 1;
    }
    if (double.tryParse(a) != null) {
      return double.tryParse(a);
    } else
      return Fraction.fromString(a).toDouble();
  }

  String validatorFnc(String value) {
    if (value == "") return "The equation cant be empty.";
    try {
      vals = [];
      String newVal = "";
      for (var i = 0; i < value.length; i++) {
        if (value[i] != " " &&
            // value[i] != "^" &&
            value[i] != "(" &&
            value[i] != ")" &&
            value[i] != "[" &&
            value[i] != "]" &&
            value[i] != "{" &&
            value[i] != "}") newVal += value[i];
      }
      int index = 0;
      List<String> t = [];
      // bool varAct;
      List<String> splitedText = newVal.split("=");
      print(splitedText[0][0] != "+" || splitedText[0][0] != "-");
      if (splitedText[0][0] != "+" || splitedText[0][0] != "-")
        splitedText[0] = "+" + splitedText[0];
      splitedText[0] += "+";
      // print(splitedText);
      for (int i = 0; i < splitedText[0].length; i++) {
        // print(splitedText[0][i]);
        if ((splitedText[0][i] == "+" || splitedText[0][i] == "-")) {
          if (isAlpha(splitedText[0][max(i - 1, 0)]) ||
              splitedText[0][max(i - 1, 0)] != "^") {
            if (splitedText[0].substring(index, i).trim() != "")
              t.add(splitedText[0].substring(index, i).trim());
            // print(splitedText[0].substring(index, i));
            index = i;
          }
        }
      }
      print(t);
      String variable = "";
      for (int k = 0; k < t.length; k++) {
        String s = t[k];
        vals.add([double.parse("${s[0]}1")]);
        bool varAct = false;
        // s = " " + s.substring(1, s.length - 1).trim();
        s += " ";
        for (int i = 0; i < s.length; i++) {
          // if(double.parse(s[i])!=null || s[i]=="."||s[i]=="/"||s[i]=="+"){
          // }
          if (isAlpha(s[i]) || (i == s.length - 1 && !varAct)) {
            if (variable != s[i] && isAlpha(s[i])) if (variable != "")
              return "There are more than one variable:";
            if (isAlpha(s[i])) varAct = true;
            variable = s[i];
            // print(s.substring(1, 2));
            // print("Lilis: ${s.substring(1, i).trim()}");
            vals[k][0] *= nummy(s.substring(1, i));
            index = i + 1;
            if (s[min(i + 1, s.length - 1)] == "^") index++;
          }
        }

        if (varAct) {
          if (s.substring(min(index, s.length - 1), s.length) == " ")
            vals[k].add(1);
          else
            vals[k].add(nummy(s.substring(index, s.length)).round().toDouble());
        } else
          vals[k].add(0);
      }
      for (var i = 0; i < vals.length; i++) {
        if (vals[i][1] < 0) {
          double c = vals[i][1];
          for (var j = 0; j < vals.length; j++) vals[j][1] -= c;
        }
      }
      for (var i = 0; i < vals.length; i++) {
        double ind = vals[i][1];
        int pos = i;
        for (var j = i; j < vals.length; j++) {
          if (ind < vals[j][1]) {
            ind = vals[j][1];
            pos = j;
          }
        }
        var temp = vals[i];
        vals[i] = vals[pos];
        vals[pos] = temp;
      }
      int p = 0;
      print(vals[0][1].round());
      for (var i = vals[0][1].round(); i >= 0; i--) {
        print("${vals[p][1]}: $i");

        if (vals[p++][1].round() != i) {
          vals.insert(p - 1, [0, i.toDouble()]);
          // p++;
        }
      }
      print(vals);
    } catch (e) {
      print(e);
      vals = [];
      return "please check the eqation again";
    }

    return null;
  }

  String dp(double a) {
    if (a.round() == a) return a.round().toString();
    return a.toFraction().toString();
  }

  String powerMeDaddy(double a) {
    if (a == 0) return "";
    List<String> symbols = ["", "", "²", "³", "⁴", "⁵", "⁶", "⁷", "⁸", "⁹"];
    if (a < 10) {
      return "x" + symbols[a.round()];
    }
    String s = "x";
    symbols = ["⁰", "¹", "²", "³", "⁴", "⁵", "⁶", "⁷", "⁸", "⁹"];
    while (a >= 1) {
      s += symbols[a.floor() % 10];
      a /= 10;
      print(a);
    }
    return s;
  }

  void solveeqn() {
    String s = "";
    for (var i = 0; i < vals.length; i++) {
      if (vals[i][0] != 0)
        s += ((vals[i][0] >= 0 && i != 0) ? " +" : " ") +
            dp(vals[i][0]) +
            powerMeDaddy(vals[i][1]);
    }
    s += " = 0";
    print(s);
    sol.children.add(Text(
      s,
      style: TextStyle(fontFamily: "cambria", fontSize: 18),
    ));
  }

  Widget starting() {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(0),
          child: Text(
            "You can solve any single variable equation (No fractional power)\n\n" +
                "Valid Eqation types (example):\n\n" +
                "0.5x3+1=0 or 0.5x^3+1=0\n\n" +
                "0.5x3+(1/3)x2-4x+8-x(-1) = 0\n\n" +
                "0.5x^3+(1/3)x^2-4x+8-x-1 = 0",
            style: TextStyle(fontSize: 20),
          ),
        ),
        Form(
          key: _formKey,
          child: Container(
            margin: EdgeInsets.only(top: 50),
            padding: EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey, width: 1),
              borderRadius: BorderRadius.circular(10),
              // color: Colors.grey,
              // boxShadow: [
              //   BoxShadow(color: Colors.green, spreadRadius: 3),
              // ],
            ),
            child: TextFormField(
              initialValue: eqn,
              validator: validatorFnc,
              style: TextStyle(fontSize: 20),
              // scrollPadding: EdgeInsets.all(20),
              decoration: InputDecoration(border: InputBorder.none),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Row Reduced Echelon Form"),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: ListView(
          padding: EdgeInsets.all(10),
          children: <Widget>[
            starting(),
            TextButton(
              onPressed: () {
                if (_formKey.currentState.validate()) {
                  print("valid form cunts");
                  _formKey.currentState.save();
                  print("Start EVERTHIG");
                  setState(() {
                    sol = Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("sol:"),
                        Divider(
                          color: Colors.black,
                          height: 1,
                        ),
                      ],
                    );
                  });
                  solveeqn();
                  print("DONE EVERTHIG");
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text('Processing Data')));
                }
              },
              child: Text("Calculate"),
            ),
            sol,
            Padding(
              padding: EdgeInsets.all(50),
            ),
          ],
        ),
      ),
    );
  }
}
