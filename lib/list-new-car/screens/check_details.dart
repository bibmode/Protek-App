import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:protek_tracker/models/vehicle.dart';
import 'package:protek_tracker/providers/new_vehicle_provider.dart';
import 'package:protek_tracker/tracker/screens/dashboard/widgets/detail_row.dart';
import 'package:provider/provider.dart';

class CheckDetails extends StatefulWidget {
  const CheckDetails(
      {Key? key, required this.hideStepsController, required this.showSteps})
      : super(key: key);

  final ScrollController hideStepsController;
  final VoidCallback showSteps;

  @override
  _CheckDetailsState createState() => _CheckDetailsState();
}

class _CheckDetailsState extends State<CheckDetails> {
  List<String> vehicleDamageList = [
    "Front Shield Crack",
    "Left front wheel is flat"
  ];

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
    Vehicle vehicleInfo = context.read<NewVehicle>().newVehicle!;

    DateTime checkInDate = DateTime.parse(vehicleInfo.dateOfCheckIn!);
    List<String> months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];

    return SingleChildScrollView(
      controller: widget.hideStepsController,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // title
          const Padding(
            padding: EdgeInsets.fromLTRB(20, 28, 20, 0),
            child: Text(
              'Check Details and Confirm',
              style: TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
          ),

          // VEHICLE STATUS
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 22, 20, 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'VEHICLE STATUS',
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 16,
                  ),
                ),
                DetailRow(
                  title: 'Gas',
                  data: '${vehicleInfo.gas} litres',
                ),
                DetailRow(
                  title: 'Mileage',
                  data: '${vehicleInfo.mileage} mi',
                ),
              ],
            ),
          ),

          // VEHICLE STATUS
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Divider(
              height: 1.5,
              color: Colors.grey.shade300,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'IMPOUND INFORMATION',
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 16,
                  ),
                ),
                DetailRow(
                  title: 'Date of transfer',
                  data:
                      '${months[checkInDate.month - 1]} ${checkInDate.day}, ${checkInDate.year} ${checkInDate.hour}:${checkInDate.minute}',
                ),
                DetailRow(
                  title: 'Daily Rate',
                  data: '₱ ${vehicleInfo.dailyRate}',
                ),
              ],
            ),
          ),

          // VEHICLE STATUS
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Divider(
              height: 1.5,
              color: Colors.grey.shade300,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'VEHICLE INFORMATION',
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 16,
                  ),
                ),
                DetailRow(
                  title: 'Make',
                  data: '${vehicleInfo.make}',
                ),
                DetailRow(
                  title: 'Type',
                  data: '${vehicleInfo.type}',
                ),
                DetailRow(
                  title: 'Series',
                  data: '${vehicleInfo.series}',
                ),
                DetailRow(
                  title: 'Year Model',
                  data: '${vehicleInfo.yearModel}',
                ),
                DetailRow(
                  title: 'Plate No.',
                  data: '${vehicleInfo.plateNo}',
                ),
                DetailRow(
                  title: 'Engine No.',
                  data: '${vehicleInfo.engineNo}',
                ),
                DetailRow(
                  title: 'Serial/Chassis No.',
                  data: '${vehicleInfo.serialNo}',
                ),
                DetailRow(
                  title: 'MV File No.',
                  data: '${vehicleInfo.mvFileNo}',
                ),
                DetailRow(
                  title: 'C.R. No.',
                  data: '${vehicleInfo.crNo}',
                ),
              ],
            ),
          ),

          // OWNER INFORMATION
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Divider(
              height: 1.5,
              color: Colors.grey.shade300,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'OWNER INFORMATION',
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 16,
                  ),
                ),
                DetailRow(
                  title: 'Full Name',
                  data: '${vehicleInfo.ownerName}',
                ),
                DetailRow(
                  title: 'Email',
                  data: vehicleInfo.ownerEmail ?? '-',
                ),
                DetailRow(
                  title: 'Phone No.',
                  data: '${vehicleInfo.ownerPhone}',
                ),
              ],
            ),
          ),

          // VEHICLE DAMAGES
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Divider(
              height: 1.5,
              color: Colors.grey.shade300,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'VEHICLE DAMAGES',
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 16,
                  ),
                ),
                const Padding(padding: EdgeInsets.all(4)),
                if (vehicleInfo.damages != null)
                  ...vehicleInfo.damages!.map(
                    (e) => Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Text(
                        '${vehicleInfo.damages!.indexOf(e) + 1}. $e',
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),

          const Padding(padding: EdgeInsets.all(10)),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            child: OutlinedButton(
              onPressed: () {
                context.read<NewVehicle>().updatePageIndex(4);
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                child: const Center(child: Text('CONTINUE')),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
