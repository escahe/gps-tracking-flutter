import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:reto4/controllers/general_controller.dart';
import 'package:reto4/ui/listar.dart';
import 'package:reto4/proceso/peticiones.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Geo-Tracker'),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  GeneralController controll = Get.find();

  void obtenerUbicacion() async {
    Position posicion = await PeticionesDB.determinePosition();
    controll.cargaUnaPosicion(posicion.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
              onPressed: () {
                Alert(
                        type: AlertType.warning,
                        context: context,
                        title: "Confirmación",
                        buttons: [
                          DialogButton(
                              color: Colors.greenAccent,
                              child: const Text("SI"),
                              onPressed: () {
                                PeticionesDB.eliminarTodo();
                                controll.cargarBD();
                                Navigator.pop(context);
                              }),
                          DialogButton(
                              color: Colors.redAccent,
                              child: const Text("NO"),
                              onPressed: () {
                                Navigator.pop(context);
                              })
                        ],
                        desc:
                            "Esta seguro que desea eliminar TODAS LAS UBICACIONES?")
                    .show();
              },
              icon: const Icon(Icons.delete_forever))
        ],
      ),
      body: const Listar(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          obtenerUbicacion();
          Alert(
                  title: "Confirmación",
                  desc:
                      "¿Está seguro que desea almacenar su ubicacion?.\n\n ${controll.unaPosicion}",
                  type: AlertType.info,
                  buttons: [
                    DialogButton(
                        color: Colors.green,
                        child: const Text("SI"),
                        onPressed: () {
                          PeticionesDB.guardarUbicacion(
                              controll.unaPosicion, DateTime.now().toString());
                          controll.cargarBD();
                          Navigator.pop(context);
                        }),
                    DialogButton(
                        color: Colors.red,
                        child: const Text("NO"),
                        onPressed: () {
                          Navigator.pop(context);
                        })
                  ],
                  context: context)
              .show();
        },
        child: const Icon(Icons.location_searching_outlined, size: 35),
      ),
    );
  }
}
