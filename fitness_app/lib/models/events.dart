import 'dart:collection';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../screens/homeScreen.dart';

/// Example event class.
class Event {
  final String name;
  final String sets;
  final String reps;
  final String weight;

  const Event(this.name, this.sets, this.reps, this.weight);

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'sets': sets,
      'reps': reps,
      'weight': weight,
    };
  }

  Event.fromFirestore(Map<String, dynamic> firestore)
      : name = firestore['name'],
        sets = firestore['sets'],
        reps = firestore['reps'],
        weight = firestore['weight'];

  @override
  String toString() => name;
}

/// Example events.
///
/// Using a [LinkedHashMap] is highly recommended if you decide to use a map.
final kEvents = LinkedHashMap<DateTime, List<Event>>(
  equals: isSameDay,
  hashCode: getHashCode,
)..addAll(_kEventSource);

Map<DateTime, List<Event>> _kEventSource = {};

// Stream<List<Event>> getEventStream(DateTime dateTime) async*{
//   yield* db.collection('users').doc(user?.uid).snapshots().map((event) => event.)
// }

int getHashCode(DateTime key) {
  return key.day * 1000000 + key.month * 10000 + key.year;
}

/// Returns a list of [DateTime] objects from [first] to [last], inclusive.
List<DateTime> daysInRange(DateTime first, DateTime last) {
  final dayCount = last.difference(first).inDays + 1;
  return List.generate(
    dayCount,
    (index) => DateTime.utc(first.year, first.month, first.day + index),
  );
}

final kToday = DateTime.now();
final kFirstDay = DateTime(kToday.year, kToday.month - 3, kToday.day);
final kLastDay = DateTime(kToday.year, kToday.month + 3, kToday.day);
