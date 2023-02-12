import 'package:flutter/material.dart';

class Workout {
  String name;
  int sets;
  int reps;
  double weight;
  bool status = false;
  bool unit = true;

  Workout(this.name, this.sets, this.reps, this.weight);

  void changeUnit(bool change) {
    unit = change;
    if (unit == false) {
      weight = weight * 0.454;
    }
  }

  bool getUnit() {
    return unit;
  }

  String getName() {
    return name;
  }

  int getSets() {
    return sets;
  }

  int getReps() {
    return reps;
  }

  double getWeight() {
    return weight;
  }

  bool getStatus() {
    return status;
  }

  void changeStatus(bool stat) {
    status = stat;
  }

  void amntSets(int amnt) {
    sets = amnt;
  }

  void amntReps(int amnt) {
    reps = amnt;
  }

  void amntWeight(double amnt) {
    weight = amnt;
  }
}

// class Days {
//   String day;
//   Days(this.day);
// }
