import 'package:auto_route/auto_route.dart';
import 'package:cybear_jinni/application/devices/device_actor/device_actor_bloc.dart';
import 'package:cybear_jinni/domain/cbj_comp/cbj_comp_entity.dart';
import 'package:cybear_jinni/domain/devices/device_entity.dart';
import 'package:cybear_jinni/injection.dart';
import 'package:cybear_jinni/presentation/routes/app_router.gr.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kt_dart/src/collection/kt_list.dart';

class CBJCompCardWithDevicesControll extends StatelessWidget {
  final CBJCompEntity cbjCompEntity;

  const CBJCompCardWithDevicesControll({
    @required this.cbjCompEntity,
  });

  Widget devicesTypes(BuildContext context) {
    List<Widget> typesList = [];
    KtList<DeviceEntity> deviceEntityList =
        cbjCompEntity.cBJCompDevices.getOrCrash();

    for (final DeviceEntity deviceEntity in deviceEntityList.asList()) {
      if (deviceEntity.type.getOrCrash() == 'Light') {
        typesList.add(
          Center(
            child: BlocProvider(
              create: (context) => getIt<DeviceActorBloc>(),
              child: Text(
                'Type: ${deviceEntity.type.getOrCrash()}',
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ),
        );
      } else {
        typesList.add(
          Text(
            'Type ${deviceEntity.type.getOrCrash()} is not supported',
            style: const TextStyle(color: Colors.white),
          ),
        );
      }
    }
    if (typesList.isEmpty) {
      typesList.add(const Text('Computer does not contain any devices'));
    }

    final Column deviceColumn = Column(
      children: typesList.toList(),
    );

    return deviceColumn;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DeviceActorBloc, DeviceActorState>(
        builder: (context, state) {
      return Container(
        color: Colors.orangeAccent,
        child: Column(
          children: [
            Container(
              decoration: const BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: Colors.white,
                  ),
                  bottom: BorderSide(
                    color: Colors.white,
                  ),
                ),
              ),
              child: devicesTypes(context),
            ),
            const SizedBox(
              height: 30,
            ),
            state.map(
              initial: (_) => const Text(
                'Initial',
                style: TextStyle(color: Colors.white),
              ),
              actionInProgress: (_) => const Text(
                'actionInProgress',
                style: TextStyle(color: Colors.white),
              ),
              deleteFailure: (_) => const Text(
                'deleteFailure',
                style: TextStyle(color: Colors.white),
              ),
              deleteSuccess: (_) => const Text(
                'deleteSuccess',
                style: TextStyle(color: Colors.white),
              ),
            ),
            FlatButton(
              color: Colors.greenAccent,
              onPressed: () {
                ExtendedNavigator.of(context).push(
                  Routes.configureNewCbjCompPage,
                  arguments: ConfigureNewCbjCompPageArguments(
                      cbjCompEntity: cbjCompEntity,
                  ),
                );
              },
              child: const Text(
                'Set up computer',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      );
    });
  }
}
// CBJCompBloc