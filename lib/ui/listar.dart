import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reto4/controllers/general_controller.dart';
import 'package:reto4/proceso/peticiones.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class Listar extends StatefulWidget {
  const Listar({super.key});

  @override
  State<Listar> createState() => _ListarState();
}

class _ListarState extends State<Listar> {
  GeneralController controll = Get.find();

  @override
  void initState() {
    super.initState();
    controll.cargarBD();
    PeticionesDB.determinePosition();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => Container(
          child: controll.listaPosiciones?.isEmpty == false
              ? ListView.builder(
                  itemCount: controll.listaPosiciones!.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                        child: ListTile(
                      leading: const Icon(Icons.location_on),
                      trailing: IconButton(
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
                                            PeticionesDB.eliminarUbicacion(
                                                controll.listaPosiciones![index]
                                                    ["id"]);
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
                                        "Esta seguro que desea eliminar esta posicion?")
                                .show();
                          },
                          icon: const Icon(
                            Icons.delete_forever_rounded,
                            color: Colors.redAccent,
                          )),
                      title:
                          Text(controll.listaPosiciones![index]["coordenadas"]),
                      subtitle: Text(controll.listaPosiciones![index]["fecha"]),
                    ));
                  },
                )
              : const Center(
                  child: Text("No hay ubicaciones registradas"),
                ),
        ));
  }
}
