import 'dart:ffi';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:fraction/fraction.dart';
import 'package:linearAlg/calculationGSO.dart';

class GSO extends StatefulWidget {
  GSO({Key key}) : super(key: key);

  @override
  _GSOState createState() => _GSOState();
}

class _GSOState extends State<GSO> {
  int nValue;
  int mValue;
  bool frac;
  Column sol;

  List<int> numbs = List.generate(
    5,
    (index) => (index + 1),
  );

  final _formKey = GlobalKey<FormState>();
  List<List<double>> matrix;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    nValue = numbs[2];
    mValue = numbs[2];
    sol = Column(
      children: [],
    );
    frac = false;
    updatematrix();

    print("WHY AM I FIRING?");
  }

  void updatematrix() {
    List<List<double>> temp = matrix;
    matrix = [];
    for (int i = 0; i < mValue; i++) {
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
    printMatrix(matrix);
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

  Column starting() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          child: Text(
            "In mathematics, particularly linear algebra and numerical analysis, the Gram–Schmidt process is a method for orthonormalizing a set of vectors in an inner product space, most commonly the Euclidean space Rn equipped with the standard inner product. The Gram–Schmidt process takes a finite, linearly independent set of vectors S = {v1, …, vk} for k ≤ n and generates an orthogonal set S′ = {u1, …, uk} that spans the same k-dimensional subspace of Rn as S.",
            style: TextStyle(fontSize: 20),
          ),
          padding: EdgeInsets.all(10),
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("number of vectors =", style: TextStyle(fontSize: 20)),
            DropdownButton<int>(
              value: mValue,
              onChanged: (int Value) {
                setState(() {
                  mValue = Value;
                });
                updatematrix();
              },
              items: numbs.map((int user) {
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
          ],
        ),
        // Padding(padding: EdgeInsets.all(20)),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("the vector lies in Rn, where n =",
                style: TextStyle(fontSize: 20)),
            DropdownButton<int>(
              value: nValue,
              onChanged: (int Value) {
                setState(() {
                  nValue = Value;
                });
                updatematrix();
              },
              items: numbs.map((int user) {
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
          ],
        ),
      ],
    );
  }

  Table initialiseTableA() {
    List<TableRow> tablerows = [];
    for (var i = 0; i < mValue; i++) {
      List<Widget> elems = [
        TextFormField(
          initialValue: "(",
          enabled: false,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.all(0),
            border: InputBorder.none,
          ),
          textAlign: TextAlign.end,
          style: TextStyle(fontSize: 25 - nValue.toDouble()),
        ),
      ];
      for (var j = 0; j < nValue; j++) {
        Container elem = Container(
          padding: EdgeInsets.all(0),
          child: TextFormField(
            initialValue: matrix[i][j].toFraction().toString(),
            keyboardType: TextInputType.datetime,
            validator: (value) => validatorFnc(value, i, j),
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

      elems.add(
        TextFormField(
          initialValue: ")",
          enabled: false,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.all(0),
            border: InputBorder.none,
          ),
          textAlign: TextAlign.start,
          style: TextStyle(fontSize: 25 - nValue.toDouble()),
        ),
      );
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

  void updateSol(
    List<String> a,
    List<List<double>> vectors,
    bool divide,
    bool heading,
  ) {
    // if (sol.children.length == 0)
    // }
    if (heading)
      sol.children.add(Padding(
        padding: EdgeInsets.all(10),
      ));
    if (divide)
      sol.children.add(Divider(
        height: 1,
        color: Colors.black,
      ));

    // sol.children.add(Padding(
    //   padding: EdgeInsets.all(10),
    // ));

    for (var i = 0; i < a.length; i++) {
      List<Text> g = [
        Text(
          "${a[i]}" + ((vectors != null) ? ":" : ""),
          softWrap: true,
          style: TextStyle(
              fontSize: 20 - ((heading) ? 0.0 : matrix[0].length).toDouble()),
        )
      ];
      if (vectors != null) {
        g.add(Text(
          "(",
          softWrap: true,
          style: TextStyle(fontSize: 20 - (matrix[0].length).toDouble()),
        ));

        for (var j = 0; j < vectors[i].length; j++)
          g.add(Text(
            "${frac ? vectors[i][j].toFraction() : dp(vectors[i][j])}" +
                ((j == vectors[0].length - 1) ? " " : ", "),
            softWrap: true,
            style: TextStyle(
              fontSize: 20 - (matrix[0].length).toDouble(),
            ),
          ));
        // ((j == vectors[0].length - 1) ? " " : " ,\t");
        g.add(Text(
          ")",
          softWrap: true,
          style: TextStyle(fontSize: 20 - (matrix[0].length).toDouble()),
        ));
      }
      sol.children.add(Padding(
        padding: EdgeInsets.all(
            10 - ((heading) ? 0.0 : (matrix[0].length).toDouble())),
      ));
      sol.children.add(Table(
        columnWidths: {
          if (vectors != null) 0: FractionColumnWidth(0.1),
          1: FractionColumnWidth(0.05),
          (matrix[0].length + 2): FractionColumnWidth(0.05),
        },
        children: [TableRow(children: g)],
      ));
    }
    sol.children.add(Padding(
      padding: EdgeInsets.all(((heading) ? 10 : 0)),
    ));
    if (divide && a[0] != "")
      sol.children.add(Divider(
        height: 1,
        color: Colors.black,
      ));

    // setState(() {
    //   sol;
    // });
    // print(sol);
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
                    setState(() {
                      sol = Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [],
                      );
                    });

                    startSolve(tempMat, updateSol, frac);
                    print(frac);
                    sol.children.add(choicebut());
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
                    setState(() {
                      sol = Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [],
                      );
                    });

                    startSolve(tempMat, updateSol, frac);
                    print(frac);
                    sol.children.add(choicebut());
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
        Text(
          "* the fraction might look distorted sometimes due to floating point error (for more info google) *",
          style: TextStyle(fontSize: 10),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text("Gram Schimit Orthogonolization"),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: Padding(
          padding: EdgeInsets.all(10),
          child: ListView(
            children: [
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
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Processing Data')));
                    print("Start EVERTHIG");
                    List<List<double>> tempMat = [];
                    for (int i = 0; i < matrix.length; i++) {
                      tempMat.add([]);
                      for (int j = 0; j < matrix[0].length; j++)
                        tempMat[i].add(matrix[i][j]);
                    }
                    setState(() {
                      sol = Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [],
                      );
                    });

                    startSolve(tempMat, updateSol, frac);
                    print("DONE EVERTHIG");
                    printMatrix(matrix);

                    sol.children.add(choicebut());
                  }
                },
                child: Text("Calculate"),
              ),
              sol,
              // Text("eat ass"),

              Padding(
                padding: EdgeInsets.all(50),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => {
          printMatrix(matrix),
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
