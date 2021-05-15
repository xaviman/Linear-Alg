import 'dart:math';
import 'package:fraction/fraction.dart';
import 'package:flutter/material.dart';
import 'package:linearAlg/RREF.dart';

void printMatrix(List<List<double>> matrix) {
  if (matrix != null) {
    int counterofdooom = 0;
    matrix.forEach((m) {
      String g = "${counterofdooom++}) ";
      m.forEach((n) {
        g += n.toString() + "\t";
      });
      print(g);
    });
  } else
    print("STFU");
  print("\nLOLIES WILL DIE");
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
  Function updateSolution,
  bool frac,
) {
  // updateSolution(null, "start of row swapping");

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
    if (pos > i) {
      matrix = rowSwap(matrix, i, pos);
      updateSolution(matrix, "R${i + 1} --> R${pos + 1}");
    }
    // } else {
    //   // print(
    //   //     "Not executed: The row number: $i, with matrix: ${matrix[i]}, j: $j");
    // }
  }
  return matrix;
}

List<List<double>> divideRow(
    List<List<double>> matrix, Function updateSolution, bool frac) {
  String message = "";
  for (int i = 0; i < matrix.length; i++) {
    int j = 0;
    while (dpabs(matrix[i][j++]) == 0 && j < matrix[0].length) {}
    double multiplier = matrix[i][j - 1];
    print(multiplier);
    if (dpabs(multiplier) != 0) if (dpabs(1 / multiplier) != 0) {
      message =
          "R${i + 1} --> (${frac ? (1 / multiplier).toFraction() : dp(1 / multiplier)})R${i + 1};\n";
      for (j = j - 1; j < matrix[0].length; j++) {
        matrix[i][j] = matrix[i][j] / multiplier;
      }
    }
  }
  updateSolution(matrix, message);
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
  return matrix;
}

List<List<List<double>>> rowOpperation(
  List<List<double>> matrix,
  Function updateSolution,
  bool frac,
) {
  // updateSolution(null, "start of row opperation");
  for (int i = 0; i < min(matrix.length - 1, matrix[0].length); i++) {
    // if (matrix[i][i] != 0) {
    String message = "";
    for (var u = i + 1; u < matrix.length; u++) {
      if (matrix[i][rankSemi(matrix[i])] != 0) {
        double multiplier =
            matrix[u][rankSemi(matrix[i])] / matrix[i][rankSemi(matrix[i])];
        if (dpabs(multiplier) != 0) if (dpabs(1 / multiplier) != 0) {
          matrix = rowAdder(matrix, u, i, -multiplier);
          if (frac)
            message +=
                "R${u + 1} --> R${u + 1} + (${(-multiplier).toFraction()})R${i + 1};\n";
          else
            message +=
                "R${u + 1} --> R${u + 1} + (${dp(-multiplier)})R${i + 1};\n";
        }
      }
      if (message != "") updateSolution(matrix, message);
    }
  }
  double detA = 1;
  for (int i = 0; i < min(matrix.length, matrix[0].length); i++) {
    detA *= dpabs(matrix[i][i]);
  }

  matrix = divideRow(matrix, updateSolution, frac);
  matrix = sortForm(matrix, updateSolution, frac);
  updateSolution(null, "The Echelon form is:");
  updateSolution(matrix, "[R|p]");

  for (int i = min(matrix.length - 1, matrix[0].length - 1); i >= 0; i--) {
    // print("${matrix[i][i]} is the val");
    // if (matrix[i][i] != 0) {
    String message = "";
    for (var u = i - 1; u >= 0; u--) {
      if (matrix[i][rankSemi(matrix[i])] != 0) {
        print("${matrix[i]}: ${rankSemi(matrix[i])}");

        double multiplier =
            matrix[u][rankSemi(matrix[i])] / matrix[i][rankSemi(matrix[i])];
        if (dpabs(multiplier) != 0) if (dpabs(1 / multiplier) != 0) {
          matrix = rowAdder(matrix, u, i, -multiplier);
          if (frac)
            message +=
                "R${u + 1} --> R${u + 1} + (${(-multiplier).toFraction()})R${i + 1};\n";
          else
            message +=
                "R${u + 1} --> R${u + 1} + (${dp(-multiplier)})R${i + 1};\n";
        }
      }
      // }
      if (message != "") updateSolution(matrix, message);
    }
  }
  return [
    matrix,
    [
      [detA]
    ]
  ];
}

List rankCalc(
    List<List<double>> matrix, double detA, Function lastPartSol, frac) {
  double rankA = 0;
  double rankAB = 0;
  List<int> rankPos = [];
  List<double> solMat = [];
  for (int i = 0; i < matrix.length; i++) {
    int j = 0;
    solMat.add(matrix[i][matrix[0].length - 1]);
    do {
      if (dpabs(matrix[i][j]) != 0) {
        if (j < matrix[0].length) {
          rankPos.add(j);
          rankA++;
        }
        rankAB += 1;
      }
    } while (matrix[i][j] == 0 && j++ < matrix[0].length - 1);
  }
  // print("Rank of the matrixes are: $rankA, $rankAB");
  lastPartSol(solMat, [rankA, rankAB, detA]);
  return [rankA.round(), rankPos];
}

List<List<double>> nullSpace(
  List<List<double>> matrix,
  int rank,
  List<int> pos,
) {
  print(rank);
  print(pos);
  // printMatrix(matrix);
  List<int> freePos = [];
  for (int i = 0; i < matrix[0].length; i++)
    if (!pos.contains(i)) freePos.add(i);
  print("freposs ---------------- $freePos");
  List<List<double>> ns = [];
  for (int k = 0; k < freePos.length; k++) {
    ns.add([]);
    int j = 0;
    print(ns);
    for (int i = 0; i < matrix[0].length; i++) {
      if (freePos.contains(i))
        ns[k].add((i == freePos[k]) ? 1 : 0);
      else {
        print("[$j][${freePos[k]}]:");
        ns[k].add(-matrix[j++][freePos[k]]);
      }
    }
  }
  printMatrix(ns);
  return ns;
}

void startSolve(
  List<List<double>> matrix,
  Function nullMatrixInputed,
  Function updateSolution,
  Function lastPartSol,
  Function nullSpaceUpdate,
  bool frac,
) {
  // print(nullMatrixCheck(matrix));
  if (nullMatrixCheck(matrix)) {
    // print("nullmatrix??");
    nullMatrixInputed(true);
    return;
  } else {
    nullMatrixInputed(false);
    // printMatrix(matrix);
    updateSolution(matrix, "");
    matrix = sortForm(matrix, updateSolution, frac);
    // rowAdder(matrix, 1, 0, 2);

    List<List<List<double>>> mat = rowOpperation(matrix, updateSolution, frac);
    matrix = mat[0];
    matrix = sortForm(matrix, updateSolution, frac);
    // matrix = sortForm(matrix, updateSolution);
    updateSolution(null, "Row Reduced Echelon form is:");
    // matrix = sortForm(matrix, updateSolution);
    updateSolution(matrix, "[ U | q ]");
    List rankA = rankCalc(matrix, mat[1][0][0], lastPartSol, frac);
    print(" NULL SPACE ");
    for (int i = 0; i < matrix.length; i++) {
      matrix[i].removeAt(matrix[i].length - 1);
    }
    // List<List<double>> nullspace= nullSpace(matrix, rankA[0], rankA[1]);
    nullSpaceUpdate(nullSpace(matrix, rankA[0], rankA[1]));
  }
}
