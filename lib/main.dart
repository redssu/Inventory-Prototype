import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:inventory_prototype/enviroment/dtos/environment_settings.dart';
import 'package:inventory_prototype/enviroment/entities/car_entity.dart';
import 'package:inventory_prototype/enviroment/entities/cloud_entity.dart';
import 'package:inventory_prototype/enviroment/entities/duck_entity.dart';
import 'package:inventory_prototype/enviroment/entities/moai_entity.dart';
import 'package:inventory_prototype/enviroment/entities/sun_entity.dart';
import 'package:inventory_prototype/enviroment/entities/tree_entity.dart';
import 'package:inventory_prototype/enviroment/environment_manager.dart';
import 'package:inventory_prototype/enviroment/widgets/environment.dart';
import 'package:inventory_prototype/inventory/widgets/inventory_wrapper.dart';
import 'package:inventory_prototype/inventory/dtos/inventory_grid.dart';
import 'package:inventory_prototype/inventory/inventory_manager.dart';
import 'package:inventory_prototype/vector2.dart';

final double kScreenWidth = MediaQueryData.fromView(PlatformDispatcher.instance.views.first).size.width;
final double kScreenHeight = MediaQueryData.fromView(PlatformDispatcher.instance.views.first).size.height;

void main() {
  runApp(const InventoryPrototypeApp());
}

class InventoryPrototypeApp extends StatefulWidget {
  const InventoryPrototypeApp({super.key});

  @override
  State<InventoryPrototypeApp> createState() => _InventoryPrototypeAppState();
}

class _InventoryPrototypeAppState extends State<InventoryPrototypeApp> {
  late final InventoryManager inventoryManager;
  late final EnvironmentManager environmentManager;

  @override
  void initState() {
    super.initState();

    inventoryManager = InventoryManager(
      grid: const InventoryGrid(
        rows: 4,
        columns: 4,
        centered: true,
      ),
    );

    const EnvironmentSettings envirovnmentSettings = EnvironmentSettings(
      size: Size(600, 600),
    );

    environmentManager = EnvironmentManager(
      settings: envirovnmentSettings,
      inventoryManager: inventoryManager,
      entites: [
        SunEntity(
          position: Vector2(15, 15),
        ),
        for (int i = 0; i < 10; i++)
          TreeEntity(
            position: envirovnmentSettings.randomPosition().setY(450),
          ),
        for (int i = 0; i < 15; i++)
          CloudEntity(
            position: envirovnmentSettings.randomPosition().setY(50),
          ),
        for (int i = 0; i < 5; i++)
          MoaiEntity(
            position: envirovnmentSettings.randomPosition().setY(525),
          ),
        for (int i = 0; i < 10; i++)
          DuckEntity(
            position: envirovnmentSettings.randomPosition(),
          ),
        for (int i = 0; i < 2; i++)
          CarEntity(
            position: envirovnmentSettings.randomPosition().setY(550),
          )
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Inventory Prototype",
      home: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            color: Colors.grey[200],
          ),
          child: InventoryWrapper(
            manager: inventoryManager,
            children: [
              Positioned(
                top: (kScreenHeight - environmentManager.settings.size.height) / 2,
                left: 30,
                child: Environment(
                  manager: environmentManager,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // TODO: Po najechaniu na item wyświetla się jego opis (Tooltip)
  // TODO: Otwieranie i zamykanie ekwipunku
  // TODO: Wyrzucanie itemów z ekwipunku do akwarium po przeciągnięciu itemu na akwarium
  // TODO: Wynieść wszystkie "BUILD METHODS" poza inventory_manager
}
