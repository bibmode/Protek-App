import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:protek_tracker/main.dart';
import 'package:go_router/go_router.dart';
import 'package:protek_tracker/models/vehicle.dart';
import 'package:protek_tracker/providers/new_vehicle_provider.dart';
import 'package:protek_tracker/providers/vehicle_tracked.dart';
import 'package:provider/provider.dart';

class StartScreen extends StatefulWidget {
  const StartScreen({Key? key}) : super(key: key);

  @override
  _StartScreenState createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  final _listFormKey = GlobalKey<FormBuilderState>();
  final _trackFormKey = GlobalKey<FormBuilderState>();

  final TextEditingController _spaceCodeController = TextEditingController();
  final TextEditingController _plateNoController = TextEditingController();

  late List<Map<String, dynamic>> _freeSpaces;
  late List<Map<String, dynamic>> _allVehicles;

  void _changeSpaceCode(String? newSpaceCode) async {
    print('space code: $newSpaceCode');
    context.read<NewVehicle>().updateSpace(newSpaceCode);
  }

  void _changeVehicleTracked(String? plateNo) async {
    // get the vehicle from the list
    final vehicleMatch = _allVehicles
        .where((vehicle) => vehicle['plate_no'] == plateNo)
        .toList()[0];

    // make new Vehicle instance
    Vehicle currentVehicle = Vehicle.fromMap(vehicleMatch);

    // update vehicle in provider
    context.read<VehicleTracked>().updateCurrentVehicle(currentVehicle);
  }

  Future<void> _getAllFreeSpaces() async {
    try {
      final data = await supabase.from('spaces').select().eq('occupied', false);

      _freeSpaces = data;
    } catch (e) {
      // make an error validation here for internet
      print('error is $e');
    }
  }

  Future<void> _getAllVehicles() async {
    try {
      final data = await supabase.from('vehicles').select();

      _allVehicles = data;
      print('all vehicles :$data');
    } catch (e) {
      // make an error validation here for internet
      print('error is $e');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    _getAllFreeSpaces();
    _getAllVehicles();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.yellow.shade800,
          image: const DecorationImage(
            image: AssetImage('lib/images/protek-garage-2.png'),
            fit: BoxFit.cover,
            opacity: 0.3,
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          // resizeToAvoidBottomInset: false,
          body: SingleChildScrollView(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 24.0, vertical: 30.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // title
                  Center(
                    child: Container(
                      width: 250,
                      padding: const EdgeInsets.only(top: 20),
                      child: const Image(
                        image: AssetImage('lib/images/text-logo.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const Padding(padding: EdgeInsets.all(20)),
                  // list a new car
                  Text(
                    'List a new Car'.toUpperCase(),
                    style: const TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 24.0,
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12.0),
                    child: Text(
                      'Register a new car into Protek\'s comprehensive care and protection system.',
                      style: TextStyle(
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                  const Padding(padding: EdgeInsets.all(6.0)),

                  FormBuilder(
                    key: _listFormKey,
                    child: Column(
                      children: [
                        FormBuilderTextField(
                          name: 'spaceCode',
                          controller: _spaceCodeController,
                          decoration: InputDecoration(
                            labelText: 'Enter Space Code',
                            floatingLabelBehavior: FloatingLabelBehavior.never,
                            filled: true,
                            fillColor: Colors.white,
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: Colors.black87,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: Colors.white,
                              ),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          validator: FormBuilderValidators.compose([
                            FormBuilderValidators.required(),
                            (value) {
                              // see if space code input match an available space
                              bool codeIsFound = _freeSpaces
                                  .where(
                                      (space) => space['space_code'] == value)
                                  .toList()
                                  .isNotEmpty;

                              if (!codeIsFound) {
                                return 'Invalid space';
                              }

                              return null;
                            },
                          ]),
                        ),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.only(top: 18.0),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black87,
                            ),
                            onPressed: () {
                              bool? validated =
                                  _listFormKey.currentState?.validate();

                              if (validated == true) {
                                _changeSpaceCode(_spaceCodeController.text);
                                context.go('/list-new-car');
                              }
                            },
                            child: const Text(
                              'CONTINUE',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),

                  // divider
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 36.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Divider(
                            color: Colors.white,
                            height: 1,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.0),
                          child: Text(
                            'OR',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Divider(
                            color: Colors.white,
                            height: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    'Check Car Status'.toUpperCase(),
                    style: const TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 24.0,
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12.0),
                    child: Text(
                      'Register a new car into Protek\'s comprehensive care and protection system.',
                      style: TextStyle(
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                  const Padding(padding: EdgeInsets.all(6.0)),

                  // track old car
                  FormBuilder(
                    key: _trackFormKey,
                    child: Column(
                      children: [
                        FormBuilderTextField(
                          name: 'plate_no',
                          controller: _plateNoController,
                          decoration: InputDecoration(
                            labelText: 'Enter Plate Number',
                            floatingLabelBehavior: FloatingLabelBehavior.never,
                            filled: true,
                            fillColor: Colors.white,
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: Colors.black87,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: Colors.white,
                              ),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          validator: FormBuilderValidators.compose([
                            FormBuilderValidators.required(),
                            (value) {
                              // see if vehicle input match an available space
                              bool plateNoIsFound = _allVehicles
                                  .where(
                                      (vehicle) => vehicle['plate_no'] == value)
                                  .toList()
                                  .isNotEmpty;

                              if (!plateNoIsFound) {
                                return 'Plate number not found';
                              }

                              return null;
                            }
                          ]),
                        ),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.only(top: 18.0),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black87,
                            ),
                            onPressed: () {
                              bool? validated =
                                  _trackFormKey.currentState?.validate();

                              if (validated == true) {
                                _changeVehicleTracked(_plateNoController.text);
                                context.go('/tracker');
                              }
                            },
                            child: const Text(
                              'CONTINUE',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(20),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
