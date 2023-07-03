import 'dart:async';

import 'package:floor/floor.dart';

import 'dao/WaterDao.dart';
import 'datamodel/WaterData.dart';
import 'package:sqflite/sqflite.dart' as sqflite;


part 'database.g.dart';

@Database(version: 1, entities: [WaterData])
abstract class FlutterDatabase extends FloorDatabase {

  WaterDao get waterDao;

}
