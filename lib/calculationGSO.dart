import 'dart:math';

import 'package:fraction/fraction.dart';

void printMatrix(List<List<double>> matrix) {
  if (matrix != null) {
    int counterofdooom = 0;
    matrix.forEach((m) {
      String g = "${counterofdooom++}) ";
      m.forEach((n) {
        g += n.toStringAsFixed(3) + "\t";
      });
      print(g);
    });
  } else
    print("STFU");
  // print("\nLOLIES WILL DIE");
}

String dp(double val) {
  int places = 3;
  String s = "";
  // n = num.parse(n.toStringAsFixed(2));
  if (val.toInt() == val)
    s += val.toInt().toString();
  else
    s += num.parse(val.toStringAsFixed(places)).toString();

  print(s);
  return s;
}

double scalarMulti(List<double> u, List<double> a) {
  double ua = 0;
  for (int i = 0; i < u.length; i++) {
    print("${u[i]} ${a[i]}");
    ua += u[i] * a[i];
  }
  return ua;
}

void orthogonalis(
  List<List<double>> matrix,
  List<List<double>> u,
  Function updateSol,
  bool frac,
) {
  for (int i = 0; i < matrix.length; i++) {
    List<List<double>> uau = [];
    updateSol(["Step ${i + 1}:"], null, true, true);
    String g = "v${i + 1} = a${i + 1}";
    for (int j = 0; j < u.length; j++) {
      // ui.ar
      print("Iteration: $i");
      double ua = scalarMulti(u[j], matrix[i]);
      updateSol(["(u${j + 1})(a${i + 1}): ${frac ? ua.toFraction() : dp(ua)} "],
          null, false, false);
      g += "- {(u${j + 1})(a${i + 1})}u${j + 1}";
      uau.add([]);

      for (int k = 0; k < matrix[0].length; k++) {
        uau[j].add(u[j][k] * ua);
      }
      print("u$j a$i: ${ua.toFraction()}; u${i - 1}:");
      printMatrix([u[i - 1]]);
    }
    List<double> v = matrix[i];
    print("::::::::::::::::::::");
    printMatrix(uau);
    for (int m = 0; m < uau.length; m++) {
      for (int n = 0; n < uau[m].length; n++) {
        v[n] -= uau[m][n];
      }
    }
    updateSol([g], null, false, false);
    print("v$i:");
    printMatrix([v]);
    updateSol(["v${i + 1}"], [v], false, false);
    u.add([]);
    for (int m = 0; m < v.length; m++) {
      double mod = modulusq(v);
      u[i].add(mod == 0 ? v[m] : v[m] / modulusq(v));
    }
    updateSol(
        ["|v${i + 1}| = ${frac ? modulusq(v).toFraction() : dp(modulusq(v))}"],
        null,
        false,
        false);
    updateSol(["u${i + 1} = v${i + 1} / |v${i + 1}|"], null, false, false);
    updateSol(["u${i + 1}"], [u[i]], false, false);

    print("u$i: ${u[i]}");
    // updateSol([
    //   g,
    //   "v${i + 1} =",
    //   "|v${i + 1}| =",
    //   "u${i + 1} = v${i + 1}/|v${i + 1} =|",
    //   "u${i + 1}=",
    // ], [
    //   v,
    //   [modulusq(v)],
    //   null,
    //   u[i],
    // ]);

    printMatrix([u[i]]);
  }
  updateSol(["The orthonormalise vectors are:"], null, true, true);
  updateSol(List.generate(matrix.length, (index) => "u${index + 1}").toList(),
      u, false, false);
  updateSol([""], null, true, true);

  printMatrix(u);
}

double modulusq(List<double> row) {
  double m = 0;
  row.forEach((e) {
    m += e * e;
  });
  print("value of m: $m, ${sqrt(m)}");
  return sqrt(m);
}

void startSolve(List<List<double>> matrix, Function updateSol, bool frac) {
  print("START SOLVE");
  updateSol(["Solution:"], null, true, true);

  updateSol(
    List.generate(matrix.length, (index) => "a${index + 1}").toList(),
    matrix,
    false,
    false,
  );
  List<List<double>> u = [];
  orthogonalis(matrix, u, updateSol, frac);
}
