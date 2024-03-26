import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:protek_tracker/models/vehicle.dart';
import 'package:protek_tracker/providers/new_vehicle_provider.dart';
import 'package:provider/provider.dart';

class GeneralInfo extends StatefulWidget {
  const GeneralInfo({Key? key, required this.hideStepsController})
      : super(key: key);

  final ScrollController hideStepsController;

  @override
  _GeneralInfoState createState() => _GeneralInfoState();
}

class _GeneralInfoState extends State<GeneralInfo> {
  final _generalInfoFormKey = GlobalKey<FormBuilderState>();
  final TextEditingController _damageInputController = TextEditingController();

  final _dateFieldKey = GlobalKey<FormBuilderFieldState>();
  final _dailyRateFieldKey = GlobalKey<FormBuilderFieldState>();
  final _nameFieldKey = GlobalKey<FormBuilderFieldState>();
  final _emailFieldKey = GlobalKey<FormBuilderFieldState>();
  final _phoneFieldKey = GlobalKey<FormBuilderFieldState>();
  final _makeFieldKey = GlobalKey<FormBuilderFieldState>();
  final _typeFieldKey = GlobalKey<FormBuilderFieldState>();
  final _seriesFieldKey = GlobalKey<FormBuilderFieldState>();
  final _colorFieldKey = GlobalKey<FormBuilderFieldState>();
  final _yearFieldKey = GlobalKey<FormBuilderFieldState>();
  final _plateNoFieldKey = GlobalKey<FormBuilderFieldState>();
  final _engineNoFieldKey = GlobalKey<FormBuilderFieldState>();
  final _serialNoFieldKey = GlobalKey<FormBuilderFieldState>();
  final _mvNoFieldKey = GlobalKey<FormBuilderFieldState>();
  final _crNoFieldKey = GlobalKey<FormBuilderFieldState>();
  final _gasFieldKey = GlobalKey<FormBuilderFieldState>();
  final _mileageFieldKey = GlobalKey<FormBuilderFieldState>();
  final _damageFieldKey = GlobalKey<FormBuilderFieldState>();

  String? damageInput;

  List<String> vehicleTypes = [
    "Midsize SUV",
    "Small SUV",
    "Motorbicycle",
    "Van",
    "Bus",
  ];

  late List<String>? vehicleDamageList =
      context.read<NewVehicle>().newVehicle != null
          ? context.read<NewVehicle>().newVehicle!.damages
          : [];

  @override
  Widget build(BuildContext context) {
    // set the vehicle in provider
    void submitGeneralInfo() {
      Vehicle newVehicle = Vehicle(
        dateOfCheckIn: _dateFieldKey.currentState!.value.toString(),
        dailyRate: double.parse(_dailyRateFieldKey.currentState!.value),
        ownerName: _nameFieldKey.currentState!.value,
        ownerEmail: _emailFieldKey.currentState?.value,
        ownerPhone: _phoneFieldKey.currentState!.value,
        make: _makeFieldKey.currentState!.value,
        type: _typeFieldKey.currentState!.value,
        series: _seriesFieldKey.currentState!.value,
        color: _colorFieldKey.currentState!.value,
        yearModel: _yearFieldKey.currentState!.value,
        plateNo: _plateNoFieldKey.currentState!.value,
        engineNo: _engineNoFieldKey.currentState!.value,
        serialNo: _serialNoFieldKey.currentState!.value,
        mvFileNo: _mvNoFieldKey.currentState!.value,
        crNo: _crNoFieldKey.currentState!.value,
        gas: _gasFieldKey.currentState!.value,
        mileage: _mileageFieldKey.currentState!.value,
        damages: vehicleDamageList,
      );

      // update vehicle in provider
      context.read<NewVehicle>().updateNewVehicle(newVehicle);

      // go to next page
      context.read<NewVehicle>().updatePageIndex(1);
    }

    return SingleChildScrollView(
      controller: widget.hideStepsController,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 28),
        child: FormBuilder(
          key: _generalInfoFormKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // DATE OF TRANSFER
              const Text(
                'Impound Information',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Padding(padding: EdgeInsets.all(10)),
              Padding(
                padding: const EdgeInsets.only(bottom: 22.0),
                child: FormBuilderDateTimePicker(
                  key: _dateFieldKey,
                  name: 'date',
                  initialValue: DateTime.now(),
                  decoration: InputDecoration(
                    labelText: 'Date of transfer',
                    suffixIcon:
                        const Icon(Icons.calendar_month, color: Colors.black54),
                    filled: true,
                    fillColor: Colors.transparent,
                    floatingLabelStyle: const TextStyle(color: Colors.black87),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: Colors.black87,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: Colors.black26,
                      ),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(),
                  ]),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 30.0),
                child: FormBuilderTextField(
                  key: _dailyRateFieldKey,
                  name: 'dailyRate',
                  initialValue: context
                      .read<NewVehicle>()
                      .newVehicle
                      ?.dailyRate
                      .toString(),
                  cursorColor: Colors.black54,
                  decoration: InputDecoration(
                    labelText: 'Daily Rate*',
                    prefixText: '₱  ',
                    filled: true,
                    fillColor: Colors.transparent,
                    floatingLabelStyle: const TextStyle(color: Colors.black87),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: Colors.black87,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: Colors.black26,
                      ),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(),
                    FormBuilderValidators.numeric(),
                  ]),
                ),
              ),

              // OWNER INFORMATION
              const Text(
                'Owner Information',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Padding(padding: EdgeInsets.all(10)),
              Padding(
                padding: const EdgeInsets.only(bottom: 22.0),
                child: FormBuilderTextField(
                  key: _nameFieldKey,
                  name: 'name',
                  initialValue:
                      context.read<NewVehicle>().newVehicle?.ownerName,
                  cursorColor: Colors.black54,
                  decoration: InputDecoration(
                    labelText: 'Full Name*',
                    filled: true,
                    fillColor: Colors.transparent,
                    floatingLabelStyle: const TextStyle(color: Colors.black87),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: Colors.black87,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: Colors.black26,
                      ),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(),
                  ]),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 22.0),
                child: FormBuilderTextField(
                  key: _emailFieldKey,
                  name: 'email',
                  initialValue:
                      context.read<NewVehicle>().newVehicle?.ownerEmail,
                  cursorColor: Colors.black54,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    filled: true,
                    fillColor: Colors.transparent,
                    floatingLabelStyle: const TextStyle(color: Colors.black87),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: Colors.black87,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: Colors.black26,
                      ),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.email(),
                  ]),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 30.0),
                child: FormBuilderTextField(
                  key: _phoneFieldKey,
                  name: 'phone',
                  initialValue:
                      context.read<NewVehicle>().newVehicle?.ownerPhone,
                  cursorColor: Colors.black54,
                  decoration: InputDecoration(
                    labelText: 'Phone*',
                    filled: true,
                    fillColor: Colors.transparent,
                    floatingLabelStyle: const TextStyle(color: Colors.black87),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: Colors.black87,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: Colors.black26,
                      ),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.numeric(),
                    FormBuilderValidators.required(),
                  ]),
                ),
              ),

              // VEHICLE INFORMATION
              const Text(
                'Vehicle Information',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Padding(padding: EdgeInsets.all(10)),
              Padding(
                padding: const EdgeInsets.only(bottom: 22.0),
                child: FormBuilderTextField(
                  key: _makeFieldKey,
                  name: 'make',
                  initialValue: context.read<NewVehicle>().newVehicle?.make,
                  cursorColor: Colors.black54,
                  decoration: InputDecoration(
                    labelText: 'Make*',
                    filled: true,
                    fillColor: Colors.transparent,
                    floatingLabelStyle: const TextStyle(color: Colors.black87),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: Colors.black87,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: Colors.black26,
                      ),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(),
                  ]),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 22.0),
                child: FormBuilderDropdown(
                  key: _typeFieldKey,
                  name: 'type',
                  initialValue: context.read<NewVehicle>().newVehicle?.type,
                  decoration: InputDecoration(
                    labelText: 'Type*',
                    filled: true,
                    fillColor: Colors.transparent,
                    floatingLabelStyle: const TextStyle(color: Colors.black87),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: Colors.black87,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: Colors.black26,
                      ),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  items: vehicleTypes
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style: const TextStyle(fontWeight: FontWeight.normal),
                      ),
                    );
                  }).toList(),
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(),
                  ]),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 22.0),
                child: FormBuilderTextField(
                  key: _seriesFieldKey,
                  name: 'series',
                  initialValue: context.read<NewVehicle>().newVehicle?.series,
                  cursorColor: Colors.black54,
                  decoration: InputDecoration(
                    labelText: 'Series*',
                    filled: true,
                    fillColor: Colors.transparent,
                    floatingLabelStyle: const TextStyle(color: Colors.black87),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: Colors.black87,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: Colors.black26,
                      ),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(),
                  ]),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 22.0),
                child: FormBuilderTextField(
                  key: _colorFieldKey,
                  name: 'color',
                  initialValue: context.read<NewVehicle>().newVehicle?.color,
                  cursorColor: Colors.black54,
                  decoration: InputDecoration(
                    labelText: 'Color*',
                    filled: true,
                    fillColor: Colors.transparent,
                    floatingLabelStyle: const TextStyle(color: Colors.black87),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: Colors.black87,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: Colors.black26,
                      ),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(),
                  ]),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 22.0),
                child: FormBuilderTextField(
                  key: _yearFieldKey,
                  name: 'year',
                  initialValue:
                      context.read<NewVehicle>().newVehicle?.yearModel,
                  cursorColor: Colors.black54,
                  decoration: InputDecoration(
                    labelText: 'Year Model*',
                    filled: true,
                    fillColor: Colors.transparent,
                    floatingLabelStyle: const TextStyle(color: Colors.black87),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: Colors.black87,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: Colors.black26,
                      ),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(),
                    FormBuilderValidators.numeric(),
                  ]),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 22.0),
                child: FormBuilderTextField(
                  key: _plateNoFieldKey,
                  name: 'plate',
                  initialValue: context.read<NewVehicle>().newVehicle?.plateNo,
                  cursorColor: Colors.black54,
                  decoration: InputDecoration(
                    labelText: 'Plate No.*',
                    filled: true,
                    fillColor: Colors.transparent,
                    floatingLabelStyle: const TextStyle(color: Colors.black87),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: Colors.black87,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: Colors.black26,
                      ),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(),
                  ]),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 22.0),
                child: FormBuilderTextField(
                  key: _engineNoFieldKey,
                  name: 'engine',
                  initialValue: context.read<NewVehicle>().newVehicle?.engineNo,
                  cursorColor: Colors.black54,
                  decoration: InputDecoration(
                    labelText: 'Engine No.*',
                    filled: true,
                    fillColor: Colors.transparent,
                    floatingLabelStyle: const TextStyle(color: Colors.black87),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: Colors.black87,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: Colors.black26,
                      ),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(),
                  ]),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 22.0),
                child: FormBuilderTextField(
                  key: _serialNoFieldKey,
                  name: 'serial',
                  initialValue: context.read<NewVehicle>().newVehicle?.serialNo,
                  cursorColor: Colors.black54,
                  decoration: InputDecoration(
                    labelText: 'Serial No.*',
                    filled: true,
                    fillColor: Colors.transparent,
                    floatingLabelStyle: const TextStyle(color: Colors.black87),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: Colors.black87,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: Colors.black26,
                      ),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(),
                  ]),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 22.0),
                child: FormBuilderTextField(
                  key: _mvNoFieldKey,
                  name: 'mv',
                  initialValue: context.read<NewVehicle>().newVehicle?.mvFileNo,
                  cursorColor: Colors.black54,
                  decoration: InputDecoration(
                    labelText: 'MV File No.*',
                    filled: true,
                    fillColor: Colors.transparent,
                    floatingLabelStyle: const TextStyle(color: Colors.black87),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: Colors.black87,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: Colors.black26,
                      ),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(),
                  ]),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 30.0),
                child: FormBuilderTextField(
                  key: _crNoFieldKey,
                  name: 'cr',
                  initialValue: context.read<NewVehicle>().newVehicle?.crNo,
                  cursorColor: Colors.black54,
                  decoration: InputDecoration(
                    labelText: 'CR No.*',
                    filled: true,
                    fillColor: Colors.transparent,
                    floatingLabelStyle: const TextStyle(color: Colors.black87),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: Colors.black87,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: Colors.black26,
                      ),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(),
                  ]),
                ),
              ),

              // VEHICLE STATUS
              const Text(
                'Vehicle Status',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Padding(padding: EdgeInsets.all(10)),
              Padding(
                padding: const EdgeInsets.only(bottom: 22.0),
                child: FormBuilderTextField(
                  key: _gasFieldKey,
                  name: 'gas',
                  initialValue: context.read<NewVehicle>().newVehicle?.gas,
                  cursorColor: Colors.black54,
                  decoration: InputDecoration(
                    labelText: 'Gas*',
                    filled: true,
                    fillColor: Colors.transparent,
                    floatingLabelStyle: const TextStyle(color: Colors.black87),
                    prefixIcon: const Icon(
                      Icons.local_gas_station,
                      color: Colors.black54,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: Colors.black87,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: Colors.black26,
                      ),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(),
                  ]),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 22.0),
                child: FormBuilderTextField(
                  key: _mileageFieldKey,
                  name: 'mileage',
                  initialValue: context.read<NewVehicle>().newVehicle?.mileage,
                  cursorColor: Colors.black54,
                  decoration: InputDecoration(
                    labelText: 'Mileage*',
                    filled: true,
                    fillColor: Colors.transparent,
                    floatingLabelStyle: const TextStyle(color: Colors.black87),
                    prefixIcon: const Icon(
                      Icons.speed,
                      color: Colors.black54,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: Colors.black87,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: Colors.black26,
                      ),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(),
                  ]),
                ),
              ),

              // DAMAGES
              const Text(
                'Damages',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Padding(padding: EdgeInsets.all(10)),
              Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: Row(
                  children: [
                    Expanded(
                      child: FormBuilderTextField(
                        key: _damageFieldKey,
                        controller: _damageInputController,
                        name: 'damage',
                        cursorColor: Colors.black54,
                        decoration: InputDecoration(
                          labelText: 'Add Damage',
                          filled: true,
                          fillColor: Colors.transparent,
                          floatingLabelBehavior: FloatingLabelBehavior.never,
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: Colors.black87,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: Colors.black26,
                            ),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onChanged: (value) {
                          setState(() {
                            damageInput = value;
                          });
                        },
                      ),
                    ),
                    const Padding(padding: EdgeInsets.all(4)),
                    IconButton(
                      onPressed: damageInput != null &&
                              damageInput!.trim() != ""
                          ? () {
                              print('damage input: $damageInput');
                              setState(() {
                                vehicleDamageList!.add(damageInput!);
                                _damageInputController.text = "";
                              });
                              print('vehicleDamageList: $vehicleDamageList');
                            }
                          : null,
                      icon: const Icon(Icons.add, color: Colors.white),
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.yellow.shade700,
                        disabledBackgroundColor: Colors.grey.shade300,
                      ),
                    ),
                  ],
                ),
              ),
              ...vehicleDamageList!.map(
                (e) => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      e,
                      style: const TextStyle(fontSize: 16),
                    ),
                    IconButton(
                        onPressed: () {
                          setState(() {
                            vehicleDamageList!.remove(e);
                          });
                        },
                        icon: const Icon(Icons.close)),
                  ],
                ),
              ),
              const Padding(padding: EdgeInsets.all(10)),
              OutlinedButton(
                onPressed: () {
                  bool? validated =
                      _generalInfoFormKey.currentState?.validate();

                  if (validated != null) {
                    if (validated) {
                      submitGeneralInfo();
                    }
                  }
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(10),
                  child: const Center(child: Text('CONTINUE')),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
