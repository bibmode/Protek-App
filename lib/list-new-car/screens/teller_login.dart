import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:protek_tracker/main.dart';
import 'package:protek_tracker/models/vehicle.dart';
import 'package:protek_tracker/providers/new_vehicle_provider.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TellerLogin extends StatefulWidget {
  const TellerLogin({Key? key, required this.showSteps}) : super(key: key);

  final VoidCallback showSteps;

  @override
  _TellerLoginState createState() => _TellerLoginState();
}

class _TellerLoginState extends State<TellerLogin> {
  final _tellerLoginFormKey = GlobalKey<FormBuilderState>();

  final _userNameFieldKey = GlobalKey<FormBuilderFieldState>();
  final _passwordFieldKey = GlobalKey<FormBuilderFieldState>();

  bool loading = false;
  bool showPassword = false;

  @override
  void initState() {
    if (mounted) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        widget.showSteps();
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Vehicle currentVehicle = context.watch<NewVehicle>().newVehicle!;

    Future<String?> uploadVehicleImage(File? imageFile) async {
      try {
        if (imageFile != null) {
          String namePath = imageFile.path.substring(
              imageFile.path.lastIndexOf('/'), imageFile.path.length);

          final String path = await supabase.storage.from('vehicles').upload(
                namePath,
                imageFile,
                fileOptions:
                    const FileOptions(cacheControl: '3600', upsert: false),
              );

          return path;
        }
      } catch (e) {
        print('vehicle file error: $e');
      }

      return null;
    }

    Future<String?> uploadLegalFileImage(File? imageFile) async {
      try {
        if (imageFile != null) {
          String namePath = imageFile.path.substring(
              imageFile.path.lastIndexOf('/'), imageFile.path.length);

          final String path = await supabase.storage.from('papers').upload(
                namePath,
                imageFile,
                fileOptions:
                    const FileOptions(cacheControl: '3600', upsert: false),
              );

          return path;
        }
      } catch (e) {
        print('legal file error: $e');
      }

      return null;
    }

    Future<bool> confirmVehicle() async {
      setState(() {
        loading = true;
      });

      try {
        // upload images
        // vehicle
        String? frontImageUrl =
            await uploadVehicleImage(context.read<NewVehicle>().frontImage);
        String? backImageUrl =
            await uploadVehicleImage(context.read<NewVehicle>().backImage);
        String? leftImageUrl =
            await uploadVehicleImage(context.read<NewVehicle>().leftImage);
        String? rightImageUrl =
            await uploadVehicleImage(context.read<NewVehicle>().rightImage);
        String? interiorImageUrl =
            await uploadVehicleImage(context.read<NewVehicle>().interiorImage);
        // legal
        // String? affidavitImageUrl = await uploadLegalFileImage(
        //     context.read<NewVehicle>().affidavitImage);
        // String? memorandumImageUrl = await uploadLegalFileImage(
        //     context.read<NewVehicle>().memorandumOfAgreementImage);
        // String? acknowledgementImageUrl = await uploadLegalFileImage(
        //     context.read<NewVehicle>().acknowledgementImage);
        String? signatureImageUrl = await uploadLegalFileImage(
            context.read<NewVehicle>().signatureImage);

        print('space code: ${context.read<NewVehicle>().space}');

        // insert new vehicle in table
        final data = await supabase.from('vehicles').insert({
          'teller_id': currentVehicle.tellerId,
          'branch_id': currentVehicle.branchId,
          'daily_rate': currentVehicle.dailyRate,
          'space': context.read<NewVehicle>().space,
          'date_of_checkin': currentVehicle.dateOfCheckIn,
          'owner_name': currentVehicle.ownerName,
          'owner_email': currentVehicle.ownerEmail,
          'owner_phone': currentVehicle.ownerPhone,
          'make': currentVehicle.make,
          'type': currentVehicle.type,
          'series': currentVehicle.series,
          'year_model': currentVehicle.yearModel,
          'plate_no': currentVehicle.plateNo,
          'engine_no': currentVehicle.engineNo,
          'serial_no': currentVehicle.serialNo,
          'mv_file_no': currentVehicle.mvFileNo,
          'cr_no': currentVehicle.crNo,
          'gas': currentVehicle.gas,
          'mileage': currentVehicle.mileage,
          'damages': currentVehicle.damages,
          'pic_front': frontImageUrl,
          'pic_back': backImageUrl,
          'pic_left': leftImageUrl,
          'pic_right': rightImageUrl,
          'pic_interior': interiorImageUrl,
          'signature': signatureImageUrl,
        });

        final branchData = await supabase
            .from('spaces')
            .update({'occupied': true}).match(
                {'space_code': context.read<NewVehicle>().space});

        print('vehicle submit $data');

        return true;
      } catch (e) {
        print('registration error: $e');
        // setState(() {
        //   loading = false;
        // });
        return false;
      }
    }

    void showLoginError(String message) {
      final snackBar = SnackBar(
        content: const Text('Error Login. Try Again!'),
        action: SnackBarAction(
          label: 'Okay',
          onPressed: () {
            // Some code to undo the change.
          },
        ),
      );

      // Find the ScaffoldMessenger in the widget tree
      // and use it to show a SnackBar.
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }

    Future<void> verifyTeller() async {
      try {
        // confirm if user exists
        final data = await supabase
            .from('tellers')
            .select()
            .eq('name', _userNameFieldKey.currentState!.value)
            .eq('passKey', _passwordFieldKey.currentState!.value);

        if (data.isNotEmpty) {
          // update teller details to newcar
          context.read<NewVehicle>().newVehicle!.updateTellerId(data[0]['id']);
          context
              .read<NewVehicle>()
              .newVehicle!
              .updateBranchId(data[0]['branch']);

          // insert vehicle data to table
          bool confirmed = await confirmVehicle();

          // print('confirmed: $confirmed');
          if (confirmed) {
            // go to next page
            context.read<NewVehicle>().updatePageIndex(5);
          } else {
            setState(() {
              loading = false;
            });
          }
        } else {
          showLoginError('Invalid username or password. Try again!');
        }
      } catch (e) {
        print('verifyteller error: $e');
        showLoginError('Error Login. Try Again!');
      }
    }

    return FormBuilder(
      key: _tellerLoginFormKey,
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Check Details and Confirm',
                  style: TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                const Padding(padding: EdgeInsets.all(8)),
                const Text(
                  'Enter your admin/teller login information to confirm your privileges.',
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 16,
                  ),
                ),
                const Padding(padding: EdgeInsets.all(20)),
                Padding(
                  padding: const EdgeInsets.only(bottom: 22.0),
                  child: FormBuilderTextField(
                    key: _userNameFieldKey,
                    name: 'username',
                    cursorColor: Colors.black54,
                    decoration: InputDecoration(
                      labelText: 'Your Name',
                      filled: true,
                      fillColor: Colors.transparent,
                      floatingLabelStyle:
                          const TextStyle(color: Colors.black87),
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
                    key: _passwordFieldKey,
                    name: 'password',
                    cursorColor: Colors.black54,
                    obscureText: !showPassword,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      filled: true,
                      fillColor: Colors.transparent,
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            showPassword = !showPassword;
                          });
                        },
                        icon: Icon(
                          showPassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: Colors.black54,
                        ),
                      ),
                      floatingLabelStyle:
                          const TextStyle(color: Colors.black87),
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
                const Spacer(),
                OutlinedButton(
                  onPressed: () {
                    bool? validated =
                        _tellerLoginFormKey.currentState?.validate();

                    if (validated == true) {
                      verifyTeller();
                    } else {
                      print('validation error');
                    }
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(10),
                    child: const Center(child: Text('CONFIRM')),
                  ),
                ),
              ],
            ),
          ),
          loading == true
              ? Container(
                  width: double.infinity,
                  height: double.infinity,
                  decoration: const BoxDecoration(color: Colors.black45),
                  child: Center(
                    child: SizedBox(
                      width: 50,
                      height: 50,
                      child: CircularProgressIndicator(
                        color: Colors.yellow.shade500,
                      ),
                    ),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }
}
