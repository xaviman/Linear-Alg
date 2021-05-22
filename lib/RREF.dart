import 'dart:math';

import 'package:flutter/material.dart';
import 'package:linearAlg/calculationRREF.dart';
import 'package:fraction/fraction.dart';

class RREF extends StatefulWidget {
  RREF({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _RREFState createState() => _RREFState();
}

class Item {
  const Item(this.value);
  final int value;
}

class _RREFState extends State<RREF> {
  int _counter = 0;
  final _formKey = GlobalKey<FormState>();
  List<Item> users = List.generate(
    10,
    (index) => new Item(
      (index + 1),
    ),
  );
  Item mValue;
  Item nValue;
  Column solution;
  List<List<double>> matrix;
  bool frac = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    mValue = users[1];
    nValue = users[1];
    updatematrix();
    solution = Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [Text(" ")],
    );
    print("WHY AM I FIRING?");
  }

  String validatorFnc(String a, int i, int j) {
    print("In validator");
    List<int> divider = [0, 0];
    for (int i = 0; i < a.length; i++)
      divider += a[i] == "/" ? [divider[0]++, i] : divider;
    if (divider[0] > 1) return "Too many division sign";
    try {
      matrix[i][j] = double.tryParse(a);
      if (matrix[i][j] == null)
        matrix[i][j] = Fraction.fromString(a).toDouble();
    } catch (e) {
      print(e);
      return "Put valid number";
    }
    return null;
  }

  void updatematrix() {
    List<List<double>> temp = matrix;
    matrix = [];
    for (int i = 0; i < mValue.value; i++) {
      matrix.add([]);
      for (int j = 0; j <= nValue.value; j++) {
        try {
          matrix[i].add(temp[i][j]);
        } catch (e) {
          matrix[i].add(0);
        }
      }
    }
    print("\n\nNo\n");
    printMatrix(matrix);
  }

  Column starting() {
    return Column(
      children: [
        Text(
          "Let the equation be A 𝑥 =b where A is a mxn, where,",
          style: TextStyle(fontSize: 20),
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("m =", style: TextStyle(fontSize: 20)),
            DropdownButton<Item>(
              value: mValue,
              onChanged: (Item Value) {
                setState(() {
                  mValue = Value;
                });
                updatematrix();
              },
              items: users.map((Item user) {
                return DropdownMenuItem<Item>(
                  value: user,
                  child: Row(
                    children: <Widget>[
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        user.value.toString(),
                        style: TextStyle(color: Colors.black),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
            // Padding(padding: EdgeInsets.all(20)),
            Text("n =", style: TextStyle(fontSize: 20)),
            DropdownButton<Item>(
              value: nValue,
              onChanged: (Item Value) {
                setState(() {
                  nValue = Value;
                });
                updatematrix();
              },
              items: users.map((Item user) {
                return DropdownMenuItem<Item>(
                  value: user,
                  child: Row(
                    children: <Widget>[
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        user.value.toString(),
                        style: TextStyle(color: Colors.black),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ],
    );
  }

  Table initialiseTableA() {
    List<TableRow> tablerows = [];
    for (var i = 0; i < mValue.value; i++) {
      List<Container> elems = [];
      for (var j = 0; j < nValue.value; j++) {
        Container elem = Container(
          padding: EdgeInsets.all(0),
          child: TextFormField(
            initialValue: matrix[i][j].toFraction().toString(),
            keyboardType: TextInputType.datetime,
            validator: (value) => validatorFnc(value, i, j),
            // onSaved: (value) {
            //   matrix[i][j] = Fraction.fromString(value).toDouble();
            //   // print("Got submited with val");
            // },
            decoration: InputDecoration(
              contentPadding: EdgeInsets.all(0),
              border: InputBorder.none,
            ),
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20 - nValue.value.toDouble()),
          ),
        );
        elems.add(elem);
      }
      tablerows.add(TableRow(children: elems));
    }
    return Table(
      children: tablerows,
    );
  }

  Table initialiseTableB() {
    Container elem;
    List<TableRow> tablerows = [];
    for (var i = 0; i < mValue.value; i++) {
      elem = Container(
        padding: EdgeInsets.all(0),
        child: TextFormField(
          initialValue: matrix[i][nValue.value].toFraction().toString(),
          keyboardType: TextInputType.datetime,
          validator: (value) => validatorFnc(value, i, nValue.value),
          decoration: InputDecoration(
            contentPadding: EdgeInsets.all(0),
            border: InputBorder.none,
          ),
          // onSaved: (value) {
          //   matrix[i][nValue.value] = Fraction.fromString(value).toDouble();
          //   // print("Got submited with val");
          // },
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 20 - nValue.value.toDouble()),
        ),
      );

      tablerows.add(TableRow(
        children: [elem],
      ));
    }
    return Table(
      children: tablerows,
    );
  }

  Widget matform() {
    return Form(
      key: _formKey,
      child: Table(
        columnWidths: {
          1: FractionColumnWidth(0.2),
        },
        border: TableBorder(
            verticalInside: BorderSide(
              width: 1,
            ),
            horizontalInside: BorderSide(
              width: 1,
            )),
        children: [
          TableRow(
            children: [
              Text(
                "A",
                style: TextStyle(
                  fontSize: 25,
                ),
                textAlign: TextAlign.center,
              ),
              Text(
                "b",
                style: TextStyle(
                  fontSize: 25,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          TableRow(
            children: [
              initialiseTableA(),
              initialiseTableB(),
            ],
          ),
        ],
      ),
    );
  }

  Table matrixA(List<List<double>> matrixA) {
    // printMatrix(matrixA);
    // print(dp(0.000005));
    List<TableRow> tablerows = [];
    for (var i = 0; i < matrixA.length; i++) {
      List<Container> elems = [];
      for (var j = 0; j < matrixA[0].length - 1; j++) {
        Container elem = Container(
          padding: EdgeInsets.all(5),
          child: Text(
            "${frac ? matrixA[i][j].toFraction() : dp(matrixA[i][j])}",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20 - nValue.value.toDouble()),
          ),
        );
        elems.add(elem);
      }
      tablerows.add(TableRow(children: elems));
    }
    return Table(
      children: tablerows,
    );
  }

  Table matrixB(List<List<double>> matrixA) {
    List<TableRow> tablerows = [];
    for (var i = 0; i < matrixA.length; i++) {
      List<Container> elems = [];

      Container elem = Container(
        padding: EdgeInsets.all(5),
        child: Text(
            "${frac ? matrixA[i][matrix[0].length - 1].toFraction() : dp(matrixA[i][matrix[0].length - 1])}",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20 - nValue.value.toDouble())),
      );

      tablerows.add(TableRow(children: [elem]));
    }
    return Table(
      children: tablerows,
    );
  }

  void nullMatrixInputed(bool isNull) {
    if (isNull)
      setState(() {
        solution = Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [Text("Null matrix Inputed, only one solution 𝑥 = 0.")],
        );
      });
    else
      setState(() {
        solution = Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Solution:"),
            Divider(
              color: Colors.black,
              height: 1,
            ),
          ],
        );
      });
  }

  void lastPartSol(List<double> solMat, List<double> rank, List<int> rankPos) {
    List<Padding> sol = [];

    double padding = 10;
    TextStyle style = TextStyle(fontSize: 18, fontWeight: FontWeight.w400);
    String mess = "";
    Table gensol;
    if (rank[0] != rank[1])
      gensol = Table(
        border: TableBorder.all(),
        children: [
          TableRow(
            children: [
              Padding(
                padding: EdgeInsets.all(padding),
                child: Text(
                  "The eqation is inconsistent as Rank(A)!=Rank(A|b)",
                  style: style,
                ),
              ),
            ],
          )
        ],
      );
    else {
      mess = "The general sol of the eqation is:";
      int cou = 0;
      Column solu = Column(children: []);
      for (int i = 0; i < nValue.value; i++) {
        if (rankPos.contains(i)) {
          solu.children.add(
            Padding(
              padding: EdgeInsets.all(5),
              child: Text(
                frac
                    ? solMat[cou].toFraction().toString()
                    : solMat[cou].toStringAsFixed(3),
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20 - nValue.value.toDouble()),
              ),
            ),
          );
          cou++;
        } else {
          solu.children.add(
            Padding(
              padding: EdgeInsets.all(5),
              child: Text(
                frac ? 0.toFraction().toString() : 0.toStringAsFixed(3),
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20 - nValue.value.toDouble()),
              ),
            ),
          );
        }
        gensol = Table(
          border: TableBorder.all(),
          columnWidths: {1: FractionColumnWidth(0.3)},
          children: [
            TableRow(
              children: [
                Padding(
                  padding: EdgeInsets.all(padding),
                  child: Text(
                    "The general sol of the eqation is:",
                    style: style,
                  ),
                ),
                solu,
              ],
            )
          ],
        );
      }
      // solMat.forEach((element) {
      //   sol.add(Padding(
      //       padding: EdgeInsets.all(5),
      //       child: Text(
      //         frac ? element.toFraction().toString() : dp(element),
      //         textAlign: TextAlign.center,
      //         style: TextStyle(
      //           fontSize: (20 - solMat.length).toDouble(),
      //         ),
      //       )));
      // });
    }
    Column t = Column(
      children: [
        Table(
          border: TableBorder.all(),
          children: [
            TableRow(
              children: [
                Padding(
                  padding: EdgeInsets.all(padding),
                  child: Text("Rank(A): ${rank[0].toFraction()}",
                      style: style, textAlign: TextAlign.center),
                ),
                Padding(
                  padding: EdgeInsets.all(padding),
                  child: Text("Rank[A|b]: ${rank[1].toFraction()}",
                      style: style, textAlign: TextAlign.center),
                ),
                Padding(
                  padding: EdgeInsets.all(padding),
                  child: Text(
                      "|A| = ${frac ? rank[2].toFraction() : dp(rank[2])}",
                      style: style,
                      textAlign: TextAlign.center),
                ),
              ],
            ),
          ],
        ),
        gensol,
        // Table(
        //   border: TableBorder.all(),
        //   children: [
        //     TableRow(
        //       children: [
        //         gensol,
        //       ],
        //     )
        //   ],
        // ),
      ],
    );
    setState(() {
      solution.children.add(Center(
        child: t,
      ));
    });
  }

  void updateSolution(List<List<double>> matrixX, String message) {
    Column t = Column(
      children: [
        Text(
          message,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 15,
          ),
        ),
        if (matrixX != null)
          Table(
            columnWidths: {
              1: FractionColumnWidth(0.2),
            },
            border: TableBorder(
              verticalInside: BorderSide(
                width: 1,
              ),
              horizontalInside: BorderSide(
                width: 1,
              ),
              // bottom: BorderSide(width: 1),
            ),
            children: [
              TableRow(
                children: [
                  matrixA(matrixX),
                  matrixB(matrixX),
                ],
              ),
            ],
          ),
        Padding(
          padding: EdgeInsets.all(10),
        ),
        Divider(
          color: Colors.black,
          height: 1,
          // thickness: 3,
          // indent: 5,
        ),
        Padding(
          padding: EdgeInsets.all(10),
        )
      ],
    );
    setState(() {
      solution.children.add(t);
    });
  }

  Column choicebut() {
    return Column(
      children: [
        Table(
          children: [
            TableRow(
              children: [
                OutlinedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        !frac ? Colors.white : Colors.green),
                  ),
                  onPressed: () {
                    setState(() {
                      frac = true;
                    });
                    List<List<double>> tempMat = [];
                    for (int i = 0; i < matrix.length; i++) {
                      tempMat.add([]);
                      for (int j = 0; j < matrix[0].length; j++)
                        tempMat[i].add(matrix[i][j]);
                    }
                    startSolve(tempMat, nullMatrixInputed, updateSolution,
                        lastPartSol, nullSpaceUpdate, frac);
                    solution.children.add(choicebut());
                  },
                  child: Text(
                    "Fraction",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: frac ? Colors.white : Colors.green,
                    ),
                  ),
                ),
                OutlinedButton(
                  onPressed: () {
                    setState(() {
                      frac = false;
                    });
                    List<List<double>> tempMat = [];
                    for (int i = 0; i < matrix.length; i++) {
                      tempMat.add([]);
                      for (int j = 0; j < matrix[0].length; j++)
                        tempMat[i].add(matrix[i][j]);
                    }
                    startSolve(tempMat, nullMatrixInputed, updateSolution,
                        lastPartSol, nullSpaceUpdate, frac);
                    solution.children.add(choicebut());
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        frac ? Colors.white : Colors.green),
                  ),
                  child: Text(
                    "Decimal",
                    textAlign: TextAlign.center,
                    style:
                        TextStyle(color: !frac ? Colors.white : Colors.green),
                  ),
                ),
              ],
            ),
          ],
        ),
        Table(
          children: [
            TableRow(children: [
              Text(
                "* the fraction is might show wrong values due to floating value point errors *",
                style: TextStyle(fontSize: 10),
              ),
            ])
          ],
        )
      ],
    );
  }

  void nullSpaceUpdate(List<List<double>> ns) {
    if (ns.length != 0) {
      // String t = "{";
      // for (int i = 0; i < ns.length; i++) {
      //   t+="(";
      //   for (int j = 0; j < ns[0].length; j++) {
      //     t += frac ? ns[i][j].toFraction().toString() : ns[i][j].toStringAsFixed(3);
      //     t += j != ns[0].length - 1 ? "," : "";
      //   }
      //   t+=")"+ (i != ns.length - 1 ? "," : "");
      // }
      // t+="}";
      List<TableRow> t = [];
      print("frac getting printers$frac");
      for (int i = 0; i < ns[0].length; i++) {
        t.add(TableRow(children: []));
        for (int j = 0; j < ns.length; j++) {
          t[i].children.add(
                Padding(
                  padding: EdgeInsets.all(5),
                  child: Text(
                    frac
                        ? ns[j][i].toFraction().toString()
                        : ns[j][i].toStringAsFixed(3),
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20 - ns.length.toDouble()),
                  ),
                ),
              );
        }
      }

      solution.children.add(Table(
        border: TableBorder.all(),
        children: [
          TableRow(children: [
            Text(
              "The rank of the null space: ${ns.length}\nThe Nullspace of the above matrix N(A) are:",
              style: TextStyle(fontSize: 20),
            ),
          ])
        ],
      ));
      solution.children.add(Table(
        border: TableBorder(
          left: BorderSide(
            width: 1,
          ),
          right: BorderSide(
            width: 1,
          ),
          bottom: BorderSide(
            width: 1,
          ),
          verticalInside: BorderSide(
            width: 1,
          ),
        ),
        children: t,
      ));
    } else
      solution.children.add(Table(
        border: TableBorder.all(),
        children: [
          TableRow(children: [
            Text(
              "The Nullspace of the above matrix N(A) doesnt exist.",
              style: TextStyle(fontSize: 20),
            ),
          ])
        ],
      ));
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
            matform(),
            Text(
              "* you can also put in fraction as: 6/5. and even in decimal as: 1.2",
              style: TextStyle(fontSize: 10),
            ),
            TextButton(
              onPressed: () {
                if (_formKey.currentState.validate()) {
                  print("valid form cunts");
                  _formKey.currentState.save();
                  printMatrix(matrix);
                  print("Start EVERTHIG");
                  List<List<double>> tempMat = [];
                  for (int i = 0; i < matrix.length; i++) {
                    tempMat.add([]);
                    for (int j = 0; j < matrix[0].length; j++)
                      tempMat[i].add(matrix[i][j]);
                  }
                  startSolve(tempMat, nullMatrixInputed, updateSolution,
                      lastPartSol, nullSpaceUpdate, frac);
                  solution.children.add(choicebut());

                  print("DONE EVERTHIG");
                  printMatrix(matrix);
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text('Processing Data')));
                }
              },
              child: Text("Calculate"),
            ),
            solution,
            Padding(
              padding: EdgeInsets.all(50),
            ),
          ],
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     if (_formKey.currentState.validate()) {
      //       print("valid form cunts");
      //       _formKey.currentState.save();
      //       printMatrix(matrix);
      //       print("Start EVERTHIG");
      //       List<List<double>> tempMat = [];
      //       for (int i = 0; i < matrix.length; i++) {
      //         tempMat.add([]);
      //         for (int j = 0; j < matrix[0].length; j++)
      //           tempMat[i].add(matrix[i][j]);
      //       }
      //       startSolve(tempMat, nullMatrixInputed, updateSolution, lastPartSol);nullSpaceUpdate,
      //       print("DONE EVERTHIG");
      //       printMatrix(matrix);,frac
      //       ScaffoldMessenger.of(context)
      //           .showSnackBar(SnackBar(content: Text('Processing Data')));
      //     }
      //   },
      //   tooltip: 'Increment',
      //   child: Icon(Icons.assignment),
      // ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
