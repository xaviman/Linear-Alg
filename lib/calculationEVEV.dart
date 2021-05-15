import 'dart:math';

import 'package:fraction/fraction.dart';
import 'package:equations/equations.dart';
import 'package:math_expressions/math_expressions.dart';

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
  double p = num.parse(val.toStringAsFixed(places));
  print(val);
  if (val.toInt() == val)
    s += val.toInt().toString();
  else
    s += p == 0 ? "0" : "$p";

  return s;
}

List<double> eqnSimplifier(
    List<double> eqn, List<double> variable, String operation) {
  // print("Eqn: $eqn $operation $variable");
  List<double> fin = [];

  if (operation == "*") {
    for (int i = 0; i < eqn.length + variable.length - 1; i++) fin.add(0);

    for (int i = 0; i < eqn.length; i++) {
      for (int j = 0; j < variable.length; j++) {
        fin[i + j] += eqn[i] * variable[j];
      }
    }
  } else if (operation == "+") {
    for (int i = 0; i < max(eqn.length, variable.length); i++) fin.add(0);

    for (int i = 0; i < min(eqn.length, variable.length); i++)
      fin[i] = eqn[i] + variable[i];
    for (int i = min(eqn.length, variable.length);
        i < max(eqn.length, variable.length);
        i++) fin[i] = (eqn.length > variable.length) ? eqn[i] : variable[i];
  } else if (operation == "-") {
    for (int i = 0; i < max(eqn.length, variable.length); i++) fin.add(0);

    for (int i = 0; i < min(eqn.length, variable.length); i++)
      fin[i] = eqn[i] - variable[i];
    // print(
    //     "${min(eqn.length, variable.length) - 1}, ${max(eqn.length, variable.length)}");
    for (int i = min(eqn.length, variable.length);
        i < max(eqn.length, variable.length);
        i++) fin[i] = (eqn.length > variable.length) ? eqn[i] : -variable[i];
  }

  // print(fin);
  return fin;
}

List<double> par(String a) {
  List<String> c = ["", "0"];

  // print(a);
  // print(double.tryParse(a.substring(0, c++)));
  for (var i = 0; i < a.length; i++) {
    c[0] += (a[i].isNumericalExpression ||
            a[i] == "." ||
            a[i] == "/" ||
            a[i] == "-")
        ? a[i]
        : "";

    if (a[i] == "λ") c[1] = "-1";
    // a[i].isNumericalExpression;
  }
  // print(c[0]);
  if (c[0][c[0].length - 1] == "-") {
    c[0] = c[0].substring(0, c[0].length - 1);
  }
  // print(c);
  // if (double.tryParse(a.substring(0, c -1)) != null)
  //   return [double.parse(a.substring(0, c - 1)), -1];
  return [Fraction.fromString(c[0]).toDouble(), double.parse(c[1])];
}

Map<String, List<double>> det(List<List<String>> matrix,
    Function parseUpdateText, Function updateText, bool bigeq) {
  Map<String, List<double>> detA = {"": []};
  if (matrix.length <= 1) {
    // print(matrix);
    // return matrix[0][0]*matrix[1][1]-matrix[0][1]*matrix[1][0];
    // String eq =
    //     " { ${matrix[0][0]}*${matrix[1][1]} - ${matrix[0][1]}*${matrix[1][0]} } ";

    return {"${matrix[0][0]}": par(matrix[0][0])};
  } else {
    List<double> eqn = [];

    for (int k = 0; k < matrix.length; k++) {
      List<List<String>> coff = [];
      for (int i = 1; i < matrix.length; i++) {
        coff.add([]);
        for (int j = 0; j < matrix.length; j++) {
          if (j != k) {
            // print("${matrix[i][j]} $j,$k");
            coff[i - 1].add(matrix[i][j]);
          }
        }
      }
      String eq = "";
      List<double> eqnSim;

      detA.forEach((key, value) => {
            eq = key,
            eqnSim = value,
          });
      det(coff, parseUpdateText, updateText, bigeq).forEach((key, value) {
        eq += " (${matrix[0][k]})[$key] ";
        eqnSim = eqnSimplifier(value, par(matrix[0][k]), "*");
        // print(
        //     "(${matrix[0][k]})[$key]: $value * ${par(matrix[0][k])} = $eqnSim");
      });
      // eq += " ${matrix[0][k]}[${eqn}] ";
      // printMatrix(coff);
      detA = {};
      List<double> l = eqnSimplifier(eqn, eqnSim, (k % 2 != 0 ? "-" : "+"));

      // print("$eq: $eqnSim ${(k % 2 == 0 ? "-" : "+")} $eqn = $l");
      if (bigeq) {
        parseUpdateText({"$eq": l}, updateText, bigeq);
      }
      eqn = l;

      if (k != matrix.length - 1) {
        eq += (k % 2 == 0 ? "-" : "+");

        // eqn = eqnSimplifier(eqnSim, eqn, (k % 2 == 0 ? "-" : "+"));
      }
      // print("$eq: $eqn");
      detA[eq] = eqn;
    }
  }

  return detA;
}

Map<String, List<double>> parseUpdateText(
    Map<String, List<double>> tempMat, Function updateText, bool bigeq) {
  String detA1;
  String detA2;
  List<String> symbols = ["", "", "²", "³", "⁴", "⁵", "⁶", "⁷", "⁸", "⁹"];
  tempMat.forEach((key, value) {
    detA1 = key;

    detA2 = value[0].toFraction().toDouble() != 0
        ? ((value[0] >= 0 ? "+" : "") + "${value[0].toFraction()} ")
        : "";
    for (var i = 1; i < value.length; i++) {
      if (!bigeq)
        print("${value.length}: ${value[i].toFraction().toDouble().abs()}");
      if (value[i].toFraction().toDouble() != 0) {
        detA2 = (value[i] >= 0 ? "+" : "") +
            ((value[i].toFraction().toDouble() == 1)
                ? (value[i].toFraction().toDouble() == -1)
                    ? "-"
                    : ""
                : (value[i].toFraction().toDouble() == -1)
                    ? "-"
                    : value[i].toFraction().toString()) +
            "λ${symbols[i]} " +
            detA2;
      }
    }
  });
  // print(det(tempMat));
  // print(detA2);
  if (bigeq) {
    updateText("", false, false);
    updateText(detA1 + " => " + detA2, false, false);
  } else {
    // updateText(detA1 + " = 0", false);
    updateText(detA2 + " = 0", false);
  }
  return tempMat;
}

double dpabs(double val) {
  int places = 3;
  // n = num.parse(n.toStringAsFixed(2));
  return num.parse(val.toStringAsFixed(places));

  // print(s);
}

bool nullMatrixCheck(List<List<double>> matrix) {
  if (matrix == null)
    return true;
  else {
    bool nullMatrix = true;
    matrix.forEach((m) {
      m.forEach((n) {
        nullMatrix = nullMatrix && (n == 0);
        // print(n != 0);
      });
    });
    return nullMatrix;
  }
}

List<List<double>> rowSwap(List<List<double>> matrix, int row1, row2) {
  List<double> temp = matrix[row1];
  matrix[row1] = matrix[row2];
  matrix[row2] = temp;
  return matrix;
}

int rankSemi(List<double> matrix) {
  int j = 0;
  while (dpabs(matrix[j++]) == 0 && j < matrix.length) {}
  return j - 1;
}

List<List<double>> sortForm(
  List<List<double>> matrix,
) {
  for (int i = 0; i < matrix.length; i++) {
    int pos = i;
    int rankA = rankSemi(matrix[i]);
    // while (matrix[i][j++] == 0 && j < matrix[0].length) {}

    // if (j - 1 > i) {
    // print("The row number: $i, with matrix: ${matrix[i]}");
    // print("$position, $i");
    for (int ii = i; ii < matrix.length; ii++) {
      if (rankA > rankSemi(matrix[ii])) {
        pos = ii;
        rankA = rankSemi(matrix[ii]);
      }
    }
    if (pos >= i) {
      matrix = rowSwap(matrix, i, pos);
    }
    // } else {
    //   // print(
    //   //     "Not executed: The row number: $i, with matrix: ${matrix[i]}, j: $j");
    // }
  }
  return matrix;
}

List<List<double>> divideRow(List<List<double>> matrix) {
  for (int i = 0; i < matrix.length; i++) {
    int j = 0;
    while (dpabs(matrix[i][j++]) == 0 && j < matrix[0].length) {}
    double multiplier = matrix[i][j - 1];
    // print(multiplier);
    if (dpabs(multiplier) != 0) {
      // if (dpabs(1 / multiplier) != 0)
      for (j = j - 1; j < matrix[0].length; j++) {
        matrix[i][j] = dpabs(matrix[i][j] / multiplier);
      }
    }
  }
  return matrix;
}

List<List<double>> rowAdder(
  List<List<double>> matrix,
  int row,
  int row2,
  double multiplier,
) {
  for (int i = 0; i < matrix[row].length; i++) {
    matrix[row][i] += multiplier * matrix[row2][i];
  }
  // matrix[row][row2] = 0;
  return matrix;
}

List<List<double>> rowOpperation(
  List<List<double>> matrix,
) {
  matrix = sortForm(matrix);

  for (int i = 0; i < min(matrix.length - 1, matrix[0].length); i++) {
    // if (matrix[i][i] != 0) {
    for (var u = i + 1; u < matrix.length; u++) {
      if (matrix[i][rankSemi(matrix[i])] != 0) {
        double multiplier =
            matrix[u][rankSemi(matrix[i])] / matrix[i][rankSemi(matrix[i])];
        if (dpabs(multiplier) != 0) if (dpabs(1 / multiplier) != 0) {
          matrix = rowAdder(matrix, u, i, -multiplier);
        }
        // if (message != "") updateSolution(matrix, message);
      }
    }
    // double detA = 1;
    // for (int i = 0; i < min(matrix.length, matrix[0].length); i++) {
    //   detA *= matrix[i][i];
    // }

    print("THE Divide MATRIX:");
    printMatrix(matrix);
    print("::::::::::::::::::");
    matrix = divideRow(matrix);
    matrix = sortForm(matrix);
    print("THE SORTED MATRIS:");
    printMatrix(matrix);
    print("::::::::::::::::::");

    for (int i = min(matrix.length - 1, matrix[0].length - 1); i >= 0; i--) {
      // print("${matrix[i][i]} is the val");
      // if (matrix[i][i] != 0) {
      // String message = "";
      for (var u = i - 1; u >= 0; u--) {
        if (matrix[i][rankSemi(matrix[i])] != 0) {
          print("${matrix[i]}: ${rankSemi(matrix[i])}");

          double multiplier =
              matrix[u][rankSemi(matrix[i])] / matrix[i][rankSemi(matrix[i])];
          if (dpabs(multiplier) != 0) if (dpabs(1 / multiplier) != 0) {
            matrix = rowAdder(matrix, u, i, -multiplier);
          }
        }
        // }
        //  if (message != "") updateSolution(matrix, message);
      }
    }
  }
  print("THE RREF MATRIS:");

  printMatrix(matrix);
  print("::::::::::::::::::");
  matrix = sortForm(matrix);
  return matrix;
}

List rankCalc(List<List<double>> matrix) {
  double rankA = 0;
  List<int> rankPos = [];

  for (int i = 0; i < matrix.length; i++) {
    int j = 0;
    print("in asshole");
    // solMat.add(matrix[i][matrix[0].length - 1]);
    do {
      print(dpabs(matrix[i][j]) != 0);
      if (dpabs(matrix[i][j]) != 0) {
        if (j < matrix[0].length) {
          rankPos.add(j);
          rankA++;
        }
      }
    } while (matrix[i][j] == 0 && j++ < matrix[0].length - 1);
  }
  // print("Rank of the matrixes are: $rankA, $rankAB");
  return [rankA.round(), rankPos];
}

List<List<double>> nullSpace(
    List<List<double>> matrix, int rank, List<int> pos) {
  // print(rank);
  // print(pos);
  // printMatrix(matrix);
  List<int> freePos = [];
  for (int i = 0; i < matrix[0].length; i++)
    if (!pos.contains(i)) freePos.add(i);
  print("freposs ---------------- $freePos");
  // print(freePos);
  List<List<double>> ns = [];
  for (int k = 0; k < freePos.length; k++) {
    ns.add([]);
    int j = 0;
    // print(ns);
    for (int i = 0; i < matrix[0].length; i++) {
      if (freePos.contains(i))
        ns[k].add((i == freePos[k]) ? 1 : 0);
      else {
        ns[k].add(-matrix[j++][freePos[k]]);
      }
    }
  }
  return ns;
}

List<List<double>> rref(List<List<double>> matrix) {
  matrix = rowOpperation(matrix);
  for (var i = 0; i < matrix.length; i++)
    for (var j = 0; j < matrix[0].length; j++)
      matrix[i][j] = double.parse(matrix[i][j].toStringAsFixed(3));

  return matrix;
}

// void nullSpace(List<List<double>> matrix) {
//   print(rankCalc(matrix));
// }

void solveEigenVec(
    List<Complex> sol, List<List<double>> matrix, Function eigenVectors) {
  List<List<double>> tempMat;
  for (Complex root in sol) {
    if (double.parse(root.imaginary.toStringAsFixed(3)) == 0) {
      tempMat = [];
      print("The null space for ${root.real.toStringAsFixed(3)},");
      for (int i = 0; i < matrix.length; i++) {
        tempMat.add([]);
        for (int j = 0; j < matrix[0].length; j++) {
          tempMat[i].add((i == j) ? matrix[i][j] - root.real : matrix[i][j]);
          // print("$i,$j: ${double.parse(root.real.toStringAsFixed(3))}");
        }
      }
      // print(root);
      printMatrix(tempMat);
      print("..................");
      tempMat = rref(tempMat);
      printMatrix(tempMat);
      List ranks = rankCalc(tempMat);
      print("rank ${ranks[0]}--------------------------");

      printMatrix(nullSpace(tempMat, ranks[0], ranks[1]));

      print("---------------------------------------------------------------");
      eigenVectors(nullSpace(tempMat, ranks[0], ranks[1]), root);
    } else {
      eigenVectors(null, root);
      print(root.imaginary.toStringAsFixed(3));
    }
  }
}

void startSolve(
  List<List<double>> matrix,
  Function updateText,
  Function updateEigenValues,
  Function eigenVectors,
  Function updateCalculation,
  bool frac,
) {
  printMatrix(matrix);
  List<List<String>> tempMat = [];
  for (int i = 0; i < matrix.length; i++) {
    tempMat.add([]);
    for (int j = 0; j < matrix[0].length; j++)
      tempMat[i].add((i == j)
          ? "${matrix[i][j].toFraction()} - λ"
          : "${matrix[i][j].toFraction()}");
  }
  updateText("Solution:", true);
  // det(tempMat, parseUpdateText, updateText, true);
  updateCalculation(null, null, true);
  updateCalculation("Calculation:", true, false);

  Map<String, List<double>> detA = parseUpdateText(
      det(
        tempMat,
        parseUpdateText,
        updateCalculation,
        true,
      ),
      updateCalculation,
      true);
  updateText("Final Simplification:", true);
  parseUpdateText(detA, updateText, false);

  List<Complex> coffs = [];
  detA.forEach((key, value) {
    for (var i = value.length - 1; i >= 0; i--) {
      coffs.add(Complex(value[i], 0));
    }
  });
  print(coffs);
  Laguerre equation = Laguerre(coefficients: coffs);
  coffs = equation.solutions();
  updateText("Eigen values are:", true);
  updateEigenValues(coffs);
  print("STARTING SOLVING EIGEN");
  updateText("Eigen vectors are:", true);

  solveEigenVec(coffs, matrix, eigenVectors);
  print("DEBUGG");
  print(rankSemi([0, 0, 0]));
  print(rankSemi([0, 2, 2]));
  // print(dp(0.00025));
  // for()

  // String detA1;
  // String detA2;
  // List<String> symbols = ["", "", "²", "³", "⁴", "⁵", "⁶", "⁷", "⁸", "⁹"];
  // det(tempMat).forEach((key, value) {
  //   detA1 = key;

  //   detA2 = (value[0] >= 0 ? "+" : "") + "${value[0].toFraction()} ";
  //   for (var i = 1; i < value.length; i++) {
  //     detA2 = (value[i] >= 0 ? "+" : "") +
  //         "${value[i].toFraction()}λ${symbols[i]} " +
  //         detA2;
  //   }
  // });
  // // print(det(tempMat));
  // print(detA2);
  // updateText(detA1, false);
  // updateText(detA2, false);

  // eqnSimplifier([5], [2,1], "+");
  // eqnSimplifier([5], [2,1], "-");
  // eqnSimplifier([2,1],[5], "-");

  // print(par("(12865.54 -a)"));
  // eqnSimplifier([5], [2,1], "*");
  // Laguerre equation = Laguerre(coefficients: [
  //   Complex(1, 0),
  //   Complex(4, 0),
  //   Complex(1, 0),
  // ]);
  // for (Complex root in equation.solutions()) {
  //   print(
  //       "${root.real.toStringAsFixed(3)}  ${root.imaginary.toStringAsFixed(3)}i ");
  // }
}
