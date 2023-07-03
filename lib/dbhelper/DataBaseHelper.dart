

import 'package:water_tracker/dbhelper/database.dart';
import 'package:water_tracker/utils/Debug.dart';

import 'datamodel/WaterData.dart';

class DataBaseHelper {
  static final DataBaseHelper _dataBaseHelper = DataBaseHelper._internal();

  factory DataBaseHelper() {
    return _dataBaseHelper;
  }

  DataBaseHelper._internal();

  static FlutterDatabase? _database;

  Future<FlutterDatabase?> initialize() async {
    _database =
        await $FloorFlutterDatabase.databaseBuilder('flutter_water_app.db').build();
    return _database;
  }



  Future<WaterData> insertDrinkWater(WaterData data) async {
    final waterDao = _database!.waterDao;
    await waterDao.insertDrinkWater(data);
    Debug.printLog("Insert DrinkWater Data Successfully  ==> " +
        data.ml.toString() +
        " CurrentTime ==> " +
        data.dateTime.toString() +
        " Date ==> " +
        data.date.toString() +
        " Time ==> " +
        data.time.toString());
    return data;
  }


  Future<List<WaterData>> selectTodayDrinkWater(String date) async {
    final waterDao = _database!.waterDao;
    final List<WaterData> result = await waterDao.getTodayDrinkWater(date);
    result.forEach((element) {
      Debug.printLog("Select Today DrinkWater Data Successfully  ==> Id =>" +
          element.id.toString() +
          " Ml =>" +
          element.ml.toString() +
          " Date ==> " +
          element.date.toString() +
          " Time ==> " +
          element.time.toString() +
          " DateTime => " +
          element.dateTime.toString());
    });
    return result;
  }

  static Future<int?> getTotalDrinkWater(String date) async {
    final waterDao = _database!.waterDao;
    final totalDrinkWater = await waterDao.getTotalOfDrinkWater(date);
    Debug.printLog("Total DrinkWater ==> " + totalDrinkWater!.total.toString());
    return totalDrinkWater.total;
  }

  static Future<List<WaterData>> getTotalDrinkWaterAllDays(
      List<String> date) async {
    final waterDao = _database!.waterDao;
    final totalDrinkWater = await waterDao.getTotalDrinkWaterAllDays(date);
    totalDrinkWater.forEach((element) {
      Debug.printLog("Total DrinkWater For Week Days ==> " +
          element.total.toString() +
          " Date ==> " +
          element.date.toString());
    });
    return totalDrinkWater;
  }

  static Future<int?> getTotalDrinkWaterAverage(List<String> date) async {
    final waterDao = _database!.waterDao;
    final totalDrinkWater = await waterDao.getTotalDrinkWaterAverage(date);
    Debug.printLog(
        "Daily Average DrinkWater ==> " + totalDrinkWater!.total.toString());
    return totalDrinkWater.total;
  }

  static Future<WaterData> deleteTodayDrinkWater(WaterData data) async {
    final waterDao = _database!.waterDao;
    await waterDao.deleteTodayDrinkWater(data);
    Debug.printLog(
        "Delete DrinkWater From Today History==> " + data.toString());
    return data;
  }


}
