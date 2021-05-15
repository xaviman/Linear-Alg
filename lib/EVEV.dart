import 'package:equations/equations.dart';
import 'package:fraction/fraction.dart';
import 'package:linearAlg/calculationEVEV.dart';
import 'package:flutter/material.dart';

class EVEV extends StatefulWidget {
  EVEV({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _EVEVState createState() => _EVEVState();
}

class _EVEVState extends State<EVEV> {
  int nValue;
  bool frac = true;
  List<int> num = List.generate(
    5,
    (index) => (index + 1),
  );
  List<List<double>> matrix;
  final _formKey = GlobalKey<FormState>();
  Column solution;
  Column calculation;
  bool toggleCal;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    nValue = num[1];
    updatematrix();
    // solution = Column(
    //   mainAxisAlignment: MainAxisAlignment.start,
    //   crossAxisAlignment: CrossAxisAlignment.start,
    //   children: [Text(" ")],
    // );
    print("WHY AM I FIRING?");
  }

  void updatematrix() {
    List<List<double>> temp = matrix;
    matrix = [];
    toggleCal = false;
    solution = Column(children: []);
    for (int i = 0; i < nValue; i++) {
      matrix.add([]);
      for (int j = 0; j < nValue; j++) {
        try {
          matrix[i].add(temp[i][j]);
        } catch (e) {
          matrix[i].add(0);
        }
      }
    }
    print("\n\nNo\n");
    // printMatrix(matrix);
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

  Table initialiseTableA() {
    List<TableRow> tablerows = [];
    for (var i = 0; i < nValue; i++) {
      List<Container> elems = [];
      for (var j = 0; j < nValue; j++) {
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
            style: TextStyle(fontSize: 20 - nValue.toDouble()),
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
            ],
          ),
          TableRow(
            children: [
              initialiseTableA(),
            ],
          ),
        ],
      ),
    );
  }

  Column starting() {
    return Column(
      children: [
        Text(
          "Let the equation be A 𝑥 = λ𝑥 where A is a mxn, where,",
          style: TextStyle(fontSize: 20),
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("m =", style: TextStyle(fontSize: 20)),
            DropdownButton<int>(
              value: nValue,
              onChanged: (int Value) {
                setState(() {
                  nValue = Value;
                });
                updatematrix();
              },
              items: num.map((int user) {
                return DropdownMenuItem<int>(
                  value: user,
                  child: Row(
                    children: <Widget>[
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        user.toString(),
                        style: TextStyle(color: Colors.black),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
            // Padding(padding: EdgeInsets.all(20)),
          ],
        ),
      ],
    );
  }

  Table matrixA() {
    List<TableRow> tablerows = [];
    for (var i = 0; i < matrix.length; i++) {
      List<Container> elems = [];
      for (var j = 0; j < matrix[0].length; j++) {
        Container elem = Container(
          padding: EdgeInsets.all(5),
          child: Text(
            "${frac ? matrix[i][j].toFraction() : dp(matrix[i][j])}" +
                ((i == j) ? "-λ" : ""),
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20 - nValue.toDouble()),
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

  void startUpdateSolu() {
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
      calculation = Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [],
      );
    });
    Column t = Column(
      children: [
        Text(
          "| A 𝑥 - λ𝑥 | = 0 => ",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 15,
          ),
        ),
        Padding(
          padding: EdgeInsets.all(10),
        ),
        if (matrix != null)
          Table(
            columnWidths: {1: FractionColumnWidth(0.1)},
            children: [
              TableRow(
                children: [
                  Table(
                    columnWidths: {
                      0: FractionColumnWidth(0.5),
                    },
                    border: TableBorder(
                      left: BorderSide(
                        width: 1,
                      ),
                      right: BorderSide(
                        width: 1,
                      ),
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
                          matrixA(),
                        ],
                      ),
                    ],
                  ),
                  TableCell(
                    verticalAlignment: TableCellVerticalAlignment.middle,
                    child: Center(
                      child: Text("=0"),
                    ),
                  ),
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
    // print(sol.children.length);
  }

  void updateCalculation(String s, bool header, bool toggleChange) {
    if (!toggleChange && toggleCal) {
      if (header) {
        calculation.children.add(Divider(
          height: 1,
          color: Colors.black,
        ));
        calculation.children.add(Padding(
          padding: EdgeInsets.all(5),
        ));
      }
      if (s != "")
        calculation.children.add(
          Text(
            s.trim(),
            style: TextStyle(
              fontFamily: "cambria",
              fontSize: header ? 22 : 18,
              letterSpacing: 1,
            ),
            textAlign: TextAlign.left,
          ),
        );
      else
        calculation.children.add(Divider(
          height: 1,
          color: Colors.black,
        ));
      if (header) {
        calculation.children.add(Padding(
          padding: EdgeInsets.all(5),
        ));
        calculation.children.add(Divider(
          height: 1,
          color: Colors.black,
        ));
      }
    } else
      solution.children.add(calculation);
  }

  void updateText(String s, bool header) {
    if (header) {
      solution.children.add(Divider(
        height: 1,
        color: Colors.black,
      ));
      solution.children.add(Padding(
        padding: EdgeInsets.all(5),
      ));
    }
    if (s != "")
      solution.children.add(
        Text(
          s.trim(),
          style: TextStyle(
            fontFamily: "cambria",
            fontSize: header ? 22 : 18,
            letterSpacing: 1,
          ),
        ),
      );
    else
      solution.children.add(Divider(
        height: 1,
        color: Colors.black,
      ));
    if (header) {
      solution.children.add(Padding(
        padding: EdgeInsets.all(5),
      ));
      solution.children.add(Divider(
        height: 1,
        color: Colors.black,
      ));
    }

    solution.children.add(Padding(
      padding: EdgeInsets.all(10),
    ));
  }

  void updateEigenValues(List<Complex> root) {
    List<Padding> t = [];

    for (int i = 0; i < root.length; i++) {
      String st = "";

      st += root[i].real.toStringAsFixed(3);

      if (double.parse(root[i].imaginary.toStringAsFixed(3)) != 0)
        st += ((root[i].imaginary > 0) ? "+" : "") +
            root[i].imaginary.toStringAsFixed(3) +
            "i";

      t.add(Padding(
          padding: EdgeInsets.all(10),
          child: Text(
            st,
            style: TextStyle(fontSize: 20 - (matrix.length).toDouble()),
            textAlign: TextAlign.center,
          )));
    }
    solution.children.add(Table(
      border: TableBorder.all(),
      children: [
        TableRow(
          children: t,
        ),
      ],
    ));
    solution.children.add(Padding(
      padding: EdgeInsets.all(10),
    ));
  }

  void eigenVectors(List<List<double>> eigenvec, Complex root) {
    if (double.parse(root.imaginary.toStringAsFixed(3)) == 0) {
      solution.children.add(
        Padding(
          padding: EdgeInsets.all(20),
          child: Text(
            "λ = ${dpabs(root.real)}",
            style: TextStyle(fontSize: 20),
          ),
        ),
      );
      Row r = Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
              padding: EdgeInsets.all(20),
              child: Text("Eigen vectors:   ", style: TextStyle(fontSize: 18)))
        ],
      );
      for (int i = 0; i < eigenvec.length; i++) {
        List<Padding> t = [];
        for (int j = 0; j < eigenvec[0].length; j++) {
          t.add(Padding(
              padding: EdgeInsets.symmetric(vertical: 5),
              child: Text(
                dp(eigenvec[i][j]),
                style: TextStyle(fontSize: 20 - eigenvec.length.toDouble()),
              )));
        }
        r.children.add(Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Container(
            padding: EdgeInsets.all(10),
            margin: EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
                border: Border.symmetric(
                    vertical: BorderSide(color: Colors.black))),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: t,
            ),
          ),
        ));
        if (i != eigenvec.length - 1)
          r.children.add(Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Text(","),
          ));
      }
      solution.children.add(r);

      solution.children.add(Divider(
        height: 1,
        color: Colors.black,
      ));
    } else
      solution.children.add(Padding(
        padding: EdgeInsets.all(20),
        child: Text(
          "The root is ${dpabs(root.real)} +${dpabs(root.imaginary)}i, and I cant calculate the eigen vector of imaginary, sorry :(.",
          style: TextStyle(fontSize: 20),
        ),
      ));
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
                            !toggleCal ? Colors.white : Colors.green)),
                    onPressed: () {
                      setState(() {
                        toggleCal = toggleCal ? false : true;
                      });
                      List<List<double>> tempMat = [];
                      for (int i = 0; i < matrix.length; i++) {
                        tempMat.add([]);
                        for (int j = 0; j < matrix[0].length; j++)
                          tempMat[i].add(matrix[i][j]);
                      }

                      startUpdateSolu();
                      startSolve(tempMat, updateText, updateEigenValues,
                          eigenVectors, updateCalculation, frac);
                      solution.children.add(choicebut());
                    },
                    child: Text(
                      toggleCal ? "Hide calculation" : "Show Calculation",
                      style: TextStyle(
                          color: toggleCal ? Colors.white : Colors.green),
                    )),
              ],
            )
          ],
        ),
        Table(
          children: [
            TableRow(children: [
              Text(
                "* the calculation is still under development, so it might look weird *",
                style: TextStyle(fontSize: 10),
              ),
            ])
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Eigen Value Eigen Vector"),
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
                  // printMatrix(matrix);
                  print("Start EVERTHIG");
                  List<List<double>> tempMat = [];
                  for (int i = 0; i < matrix.length; i++) {
                    tempMat.add([]);
                    for (int j = 0; j < matrix[0].length; j++)
                      tempMat[i].add(matrix[i][j]);
                  }
                  // startSolve(
                  // tempMat, nullMatrixIn, fracputed, updateSolution, lastPartSol);

                  startUpdateSolu();
                  startSolve(tempMat, updateText, updateEigenValues,
                      eigenVectors, updateCalculation, frac);
                  // solution.children.add(Text("asd"));
                  solution.children.add(choicebut());

                  print("DONE EVERTHIG");
                  // printMatrix(matrix);
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
    );
  }
}
