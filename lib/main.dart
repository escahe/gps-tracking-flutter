import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reto4/controllers/general_controller.dart';
import 'package:reto4/ui/home.dart';

void main() {
  Get.put(GeneralController());
  runApp(const MyApp());
}
