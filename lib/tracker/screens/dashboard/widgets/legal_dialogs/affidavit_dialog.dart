import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:protek_tracker/models/vehicle.dart';
import 'package:protek_tracker/providers/vehicle_tracked.dart';
import 'package:provider/provider.dart';

class AffidavitDialog extends StatelessWidget {
  const AffidavitDialog({
    super.key,
    required this.affidavit,
  });

  final String affidavit;

  @override
  Widget build(BuildContext context) {
    Vehicle currentVehicle = context.read<VehicleTracked>().currentVehicle;

    return AlertDialog(
      content: Column(
        children: [
          const Text(
            'AFFIDAVIT',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const Padding(padding: EdgeInsets.all(8)),
          Text(
              'I, ${currentVehicle.ownerName}, of legal age, Filipino, single/married, and a resident of _________________________________________ under oath, depose and state THAT:'),
          const Padding(padding: EdgeInsets.all(8)),
          Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: Text(
                '1. On ${currentVehicle.dateOfCheckOut}, I have retrieved the personal property deposited to Brightstar Marketing Ventures OPC last ${currentVehicle.dateOfCheckIn}, which deposit is evidenced by the attached Acknowledgement Receipt; '),
          ),
          const Padding(
            padding: EdgeInsets.only(left: 16.0, top: 10),
            child: Text(
                '2. I confirm that I have received such property in good condition - as it was when delivered/deposited; '),
          ),
          const Padding(
            padding: EdgeInsets.only(left: 16.0, top: 10),
            child: Text(
                '3. I have paid the necessary fees for the storage and safekeeping of such property; '),
          ),
          const Padding(
            padding: EdgeInsets.only(left: 16.0, top: 10),
            child: Text(
                '4. After claiming the said property, I hereby release and forever discharge Brightstar Marketing Ventures OPC, its agents, officers, affiliates, employees, representatives, successors, and assigns, from any and all liabilities, claims, demands, actions, and causes of action whatsoever, directly and indirectly arising out of or related to the deposit of the said property within the company\'s private parking and storage facility;'),
          ),
          const Padding(
            padding: EdgeInsets.only(left: 16.0, top: 10),
            child: Text(
                '5. I declare that the release of claim hereby given is made willingly and voluntarily and with full knowledge of my rights under the law;'),
          ),
          const Padding(
            padding: EdgeInsets.only(left: 16.0, top: 10),
            child: Text(
                '6. I am executing this affidavit to attest to the truth of the foregoing for whatever legal purpose it may serve.'),
          ),
          const Padding(padding: EdgeInsets.all(8)),
          Text(
              'IN WITNESS WHEREOF, I have hereunto affixed my signature this ________________ day of ______________20_____ at Butuan City, Philippines.'),
          const Padding(padding: EdgeInsets.all(20)),
          Text(
            '${currentVehicle.ownerName}',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text('Affiant'),
          const Padding(padding: EdgeInsets.all(20)),
          Text(
              'SUBSCRIBED AND SWORN TO BEFORE ME this ____________________ day of ___________ 2024 at Butuan City, Philippines.'),
          const Padding(padding: EdgeInsets.all(10)),
          Align(alignment: Alignment.bottomLeft, child: Text('Doc No. : ')),
          Align(alignment: Alignment.bottomLeft, child: Text('Page No. : ')),
          Align(alignment: Alignment.bottomLeft, child: Text('Book No. : ')),
          Align(alignment: Alignment.bottomLeft, child: Text('Series of 2024')),
        ],
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      contentPadding: const EdgeInsets.all(20),
      insetPadding: const EdgeInsets.all(20),
      actionsAlignment: MainAxisAlignment.end,
      actionsPadding: const EdgeInsets.only(bottom: 20, right: 20),
      scrollable: true,
      actions: [
        OutlinedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.close),
              Padding(padding: EdgeInsets.all(4)),
              Text('CLOSE'),
            ],
          ),
        ),
      ],
    );
  }
}
