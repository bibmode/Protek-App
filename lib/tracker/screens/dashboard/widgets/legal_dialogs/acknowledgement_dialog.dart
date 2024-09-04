import 'package:flutter/material.dart';
import 'package:protek_tracker/models/vehicle.dart';
import 'package:protek_tracker/providers/vehicle_tracked.dart';
import 'package:provider/provider.dart';

class AcknowledgementDialog extends StatelessWidget {
  const AcknowledgementDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Vehicle currentVehicle = context.read<VehicleTracked>().currentVehicle;

    return AlertDialog(
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Align(
            alignment: Alignment.center,
            child: Text(
              'ACKNOWLEDGEMENT',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          const Padding(padding: EdgeInsets.all(8)),
          const Text('Republic of the Philippines)'),
          const Padding(padding: EdgeInsets.all(8)),
          const Text('______________________ )S.S'),
          const Padding(padding: EdgeInsets.all(8)),
          RichText(
            text: TextSpan(
              style: DefaultTextStyle.of(context).style,
              children: const [
                WidgetSpan(child: SizedBox(width: 16.0)),
                TextSpan(
                    text:
                        'BEFORE ME, a Notary Public, this __________ day of __________ 20____ in Butuan City Philippines, personally appeared the following persons:'),
              ],
            ),
          ),
          const Padding(padding: EdgeInsets.all(15)),
          Table(
            border: TableBorder.all(),
            columnWidths: const <int, TableColumnWidth>{
              0: FlexColumnWidth(),
              1: FlexColumnWidth(),
              2: FlexColumnWidth(),
            },
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            children: const [
              TableRow(children: [
                TableCell(
                  verticalAlignment: TableCellVerticalAlignment.top,
                  child: Padding(
                    padding: EdgeInsets.all(4.0),
                    child: Text(
                      'NAME',
                      softWrap: true,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                TableCell(
                  verticalAlignment: TableCellVerticalAlignment.top,
                  child: Padding(
                    padding: EdgeInsets.all(4.0),
                    child: Text(
                      'Government Issued ID',
                      softWrap: true,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                TableCell(
                  verticalAlignment: TableCellVerticalAlignment.top,
                  child: Padding(
                    padding: EdgeInsets.all(4.0),
                    child: Text(
                      'Place/Date of Issue',
                      softWrap: true,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ]),
              TableRow(children: [
                TableCell(
                  verticalAlignment: TableCellVerticalAlignment.top,
                  child: Padding(
                    padding: EdgeInsets.all(4.0),
                    child: Text(
                      '',
                      softWrap: true,
                    ),
                  ),
                ),
                TableCell(
                  verticalAlignment: TableCellVerticalAlignment.top,
                  child: Padding(
                    padding: EdgeInsets.all(4.0),
                    child: Text(''),
                  ),
                ),
                TableCell(
                  verticalAlignment: TableCellVerticalAlignment.top,
                  child: Padding(
                    padding: EdgeInsets.all(4.0),
                    child: Text(''),
                  ),
                ),
              ]),
              TableRow(children: [
                TableCell(
                  verticalAlignment: TableCellVerticalAlignment.top,
                  child: Padding(
                    padding: EdgeInsets.all(4.0),
                    child: Text(
                      'MRS. JACQUELINE Y. ORILLA',
                      softWrap: true,
                    ),
                  ),
                ),
                TableCell(
                  verticalAlignment: TableCellVerticalAlignment.top,
                  child: Padding(
                    padding: EdgeInsets.all(4.0),
                    child: Text(''),
                  ),
                ),
                TableCell(
                  verticalAlignment: TableCellVerticalAlignment.top,
                  child: Padding(
                    padding: EdgeInsets.all(4.0),
                    child: Text(''),
                  ),
                ),
              ]),
            ],
          ),
          const Padding(padding: EdgeInsets.all(10)),
          RichText(
            text: TextSpan(
              style: DefaultTextStyle.of(context).style,
              children: const [
                WidgetSpan(child: SizedBox(width: 16.0)),
                TextSpan(
                    text:
                        'Known to me and to me known to be the same persons who executed the foregoing Memorandum of Agreement, consisting of four (4) pages including this page, and acknowledged to me that the same is their free and voluntary act and deed, and of the institutions they respectively represent.'),
              ],
            ),
          ),
          const Padding(padding: EdgeInsets.all(8)),
          RichText(
            text: TextSpan(
              style: DefaultTextStyle.of(context).style,
              children: const [
                WidgetSpan(child: SizedBox(width: 16.0)),
                TextSpan(
                    text:
                        'WITNESS MY HAND AND SEAL this __________________________ in Butuan City, Philippines.'),
              ],
            ),
          ),
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
