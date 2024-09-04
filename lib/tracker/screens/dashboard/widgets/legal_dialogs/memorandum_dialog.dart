import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:protek_tracker/models/vehicle.dart';
import 'package:protek_tracker/providers/vehicle_tracked.dart';
import 'package:provider/provider.dart';

class MemorandumDialog extends StatelessWidget {
  const MemorandumDialog({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    Vehicle currentVehicle = context.read<VehicleTracked>().currentVehicle;

    return AlertDialog(
      content: Column(
        children: [
          const Text(
            'MEMORANDUM OF AGREEMENT',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const Padding(padding: EdgeInsets.all(10)),
          const Align(
              alignment: Alignment.bottomLeft,
              child: Text(
                'KNOW ALL MEN BY THESE PRESENTS:',
                style: TextStyle(fontWeight: FontWeight.bold),
              )),
          const Padding(padding: EdgeInsets.all(8)),
          const Padding(
            padding: EdgeInsets.only(left: 16.0),
            child:
                Text('This Memorandum of Agreement executed by and between:'),
          ),
          Padding(
              padding: const EdgeInsets.only(left: 16.0, top: 10),
              child: RichText(
                text: TextSpan(
                  text:
                      'The _____________________________, a government agency organized and established under ______________________________, with office address at ___________________________________________________, represented by its _________________________, _________________________ and herein referred to as the ',
                  style: DefaultTextStyle.of(context).style,
                  children: const <TextSpan>[
                    TextSpan(
                        text: '“FIRSTPARTY"',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    TextSpan(text: ';'),
                  ],
                ),
              )),
          Padding(
              padding: const EdgeInsets.only(left: 16.0, top: 20),
              child: RichText(
                text: TextSpan(
                  text:
                      'Protek Impounding Operated by BRIGHTSTAR MARKETING VENTURES OPC, ',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.black87),
                  children: <TextSpan>[
                    TextSpan(
                      text:
                          'a domestic corporation duly organized and existing under and by virtue of the laws of the Republic of the Philippines, with principal office at ____________________________________________________, Philippines and represented in this act by its President, __________________________________, hereinafter referred to as the',
                      style: DefaultTextStyle.of(context).style,
                    ),
                    const TextSpan(text: ' "SECOND PARTY";'),
                  ],
                ),
              )),
          const Padding(padding: EdgeInsets.all(5)),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10.0),
            child: Text('-and-'),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16.0, top: 10),
            child: RichText(
              text: TextSpan(
                text: 'MR./MS. __________',
                style: const TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.black87),
                children: <TextSpan>[
                  TextSpan(
                    text:
                        ', of legal age, Filipino, married/single, and with residence address at _________________________________________, hereinafter referred to as the ',
                    style: DefaultTextStyle.of(context).style,
                  ),
                  TextSpan(text: '"THIRD PARTY";'),
                ],
              ),
            ),
          ),
          const Padding(padding: EdgeInsets.all(5)),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10.0),
            child: Text(
              'WITNESSETH: That',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: RichText(
              text: TextSpan(
                style: const TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.black87),
                children: [
                  const WidgetSpan(child: SizedBox(width: 16.0)),
                  const TextSpan(text: 'WHEREAS, '),
                  TextSpan(
                      text: 'the ', style: DefaultTextStyle.of(context).style),
                  const TextSpan(text: 'FIRST PARTY '),
                  TextSpan(
                    text:
                        'is authorized to apprehend and impound vehicles (and/or confiscate personal properties, namely _________________________) pursuant to_________________; ',
                    style: DefaultTextStyle.of(context).style,
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: RichText(
              text: TextSpan(
                style: const TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.black87),
                children: [
                  const WidgetSpan(child: SizedBox(width: 16.0)),
                  const TextSpan(text: 'WHEREAS, '),
                  TextSpan(
                      text: 'the ', style: DefaultTextStyle.of(context).style),
                  const TextSpan(text: 'FIRST PARTY '),
                  TextSpan(
                    text:
                        'is charged with the duty to safekeep the impounded vehicles (and/or confiscated personal properties, namely _________________________) until the same is redeemed by its owner;',
                    style: DefaultTextStyle.of(context).style,
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: RichText(
              text: TextSpan(
                style: const TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.black87),
                children: [
                  const WidgetSpan(child: SizedBox(width: 16.0)),
                  const TextSpan(text: 'WHEREAS, '),
                  TextSpan(
                      text: 'the ', style: DefaultTextStyle.of(context).style),
                  const TextSpan(text: 'FIRST PARTY '),
                  TextSpan(
                    text:
                        'lacks resources such as parking or storage area, security personnel, and others, for the safekeeping of the impounded vehicles (and/or confiscated personal properties, namely __________________); ',
                    style: DefaultTextStyle.of(context).style,
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: RichText(
              text: TextSpan(
                style: const TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.black87),
                children: [
                  const WidgetSpan(child: SizedBox(width: 16.0)),
                  const TextSpan(text: 'WHEREAS, '),
                  TextSpan(
                      text: 'the ', style: DefaultTextStyle.of(context).style),
                  const TextSpan(text: 'SECOND PARTY '),
                  TextSpan(
                    text:
                        'is the proprietor of Protek BrightStar, located at Brgy. Silad, Butuan City, which provides resources such as parking or storage area, security personnel, and others, for the safekeeping of vehicles and/or other personal properties;',
                    style: DefaultTextStyle.of(context).style,
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: RichText(
              text: TextSpan(
                style: const TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.black87),
                children: [
                  const WidgetSpan(child: SizedBox(width: 16.0)),
                  const TextSpan(text: 'WHEREAS, '),
                  TextSpan(
                      text: 'the ', style: DefaultTextStyle.of(context).style),
                  const TextSpan(text: 'FIRST PARTY '),
                  TextSpan(
                    text:
                        'recognizes that there is a need to engage the services of the ',
                    style: DefaultTextStyle.of(context).style,
                  ),
                  const TextSpan(text: 'SECOND PARTY '),
                  TextSpan(
                    text:
                        'in order to fulfill the former\'s duty to safekeep the impounded vehicles (and/or confiscated personal properties, namely _____________________________ untilthe same is redeemed by its owner; ',
                    style: DefaultTextStyle.of(context).style,
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: RichText(
              text: TextSpan(
                style: const TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.black87),
                children: [
                  const WidgetSpan(child: SizedBox(width: 16.0)),
                  const TextSpan(text: 'WHEREAS, '),
                  TextSpan(
                      text: 'the ', style: DefaultTextStyle.of(context).style),
                  const TextSpan(text: 'FIRST PARTY '),
                  TextSpan(
                    text:
                        'is authorized to enter into a Memorandum of Agreement (MOA) with the ',
                    style: DefaultTextStyle.of(context).style,
                  ),
                  const TextSpan(text: 'SECOND PARTY '),
                  TextSpan(
                    text: 'pursuant to __________________________;',
                    style: DefaultTextStyle.of(context).style,
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: RichText(
              text: TextSpan(
                style: const TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.black87),
                children: [
                  const WidgetSpan(child: SizedBox(width: 16.0)),
                  const TextSpan(text: 'WHEREAS, '),
                  TextSpan(
                      text: 'the ', style: DefaultTextStyle.of(context).style),
                  const TextSpan(text: 'THIRD PARTY '),
                  TextSpan(
                    text:
                        'is the [registered] owner/possessor/holder of a vehicle (or personal properties, namely ___________________________) which has been impounded (or confiscated) by the FIRST PARTY for violation of ___________________________; ',
                    style: DefaultTextStyle.of(context).style,
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: RichText(
              text: TextSpan(
                style: const TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.black87),
                children: [
                  const WidgetSpan(child: SizedBox(width: 16.0)),
                  const TextSpan(text: 'WHEREAS, '),
                  TextSpan(
                      text: 'the ', style: DefaultTextStyle.of(context).style),
                  const TextSpan(text: 'THIRD PARTY '),
                  TextSpan(
                    text: 'recognizes the need of the ',
                    style: DefaultTextStyle.of(context).style,
                  ),
                  const TextSpan(text: 'FIRST PARTY '),
                  TextSpan(
                    text:
                        'to deliver his/her vehicle (or personal properties, namely ________________________________) to the ',
                    style: DefaultTextStyle.of(context).style,
                  ),
                  const TextSpan(text: 'SECOND PARTY '),
                  TextSpan(
                    text: 'for safekeeping until the same is redeemed; ',
                    style: DefaultTextStyle.of(context).style,
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: RichText(
              text: TextSpan(
                style: const TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.black87),
                children: [
                  const WidgetSpan(child: SizedBox(width: 16.0)),
                  const TextSpan(text: 'NOW THEREFORE, '),
                  TextSpan(
                      text:
                          'for and in consideration of the foregoing premises, the parties hereto hereby agree as follows: ',
                      style: DefaultTextStyle.of(context).style),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: RichText(
              text: TextSpan(
                style: const TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.black87),
                children: [
                  TextSpan(
                      text: '1. ', style: DefaultTextStyle.of(context).style),
                  const TextSpan(text: 'Responsibilities of the FIRST PARTY. '),
                  TextSpan(
                      text: '- The FIRST PARTY shall:',
                      style: DefaultTextStyle.of(context).style),
                ],
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(left: 16.0, top: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('1.1 '),
                Expanded(
                  child: Text(
                    'Deliver to the SECOND PARTY the impounded vehicles (and/or confiscated personal properties, namely __________________________) at __________________________, during office hours only (8am to 5pm);',
                  ),
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(left: 16.0, top: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('1.2 '),
                Expanded(
                  child: Text(
                    'Furnish the SECOND PARTY with an itemized list of the impounded vehicles (and/or confiscated personal properties, namely _________________________) delivered;',
                  ),
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(left: 16.0, top: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('1.3 '),
                Expanded(
                  child: Text(
                    'Collect and pay the SECOND PARTY the prescribed impounding/ storage fees of the impounded vehicles (and/or confiscated personal properties, namely __________________________); ',
                  ),
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(left: 16.0, top: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('1.4 '),
                Expanded(
                  child: Text(
                    'Coordinate properly with the SECOND PARTY all information required for the release of the impounded vehicles (and/or confiscate personal properties, namely ___________________________), in case of redemption; and,',
                  ),
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(left: 16.0, top: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('1.5 '),
                Expanded(
                  child: Text(
                    'Execute and sign necessary documents relative to the above-mentioned responsibilities.',
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: RichText(
              text: TextSpan(
                style: const TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.black87),
                children: [
                  TextSpan(
                      text: '2. ', style: DefaultTextStyle.of(context).style),
                  const TextSpan(
                      text: 'Responsibilities of the SECOND PARTY. '),
                  TextSpan(
                      text: '- The SECOND PARTY shall:',
                      style: DefaultTextStyle.of(context).style),
                ],
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(left: 16.0, top: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('2.1 '),
                Expanded(
                  child: Text(
                    'Prepare a receipt acknowledging the delivery by the FIRST PARTY of the impounded vehicle(s) (and/or confiscated personal properties, namely ___________________________), stating the date, place and time of the delivery;',
                  ),
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(left: 16.0, top: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('2.2 '),
                Expanded(
                  child: Text(
                    'Ensure that the impounded vehicles (and/or confiscated personal properties, namely _________________________) are properly stored, safeguarded, and taken care of so that no damage shall be incurred by it/them, unless it is caused by any fortuitous event;',
                  ),
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(left: 16.0, top: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('2.3 '),
                Expanded(
                  child: Text(
                    'Submit to the FIRST PARTY an inventory of the impounded vehicle(s) (and/or confiscated personal properties, namely _______________________); ',
                  ),
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(left: 16.0, top: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('2.4 '),
                Expanded(
                  child: Text(
                    'Account all payment of the prescribed impounding/ storage fees of the impounded vehicles (and/or confiscated personal properties, namely ___________________________) received from the FIRST PARTY; and,',
                  ),
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(left: 16.0, top: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('2.5 '),
                Expanded(
                  child: Text(
                    'Execute and sign necessary documents relative to the above-mentioned responsibilities.',
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: RichText(
              text: TextSpan(
                style: const TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.black87),
                children: [
                  TextSpan(
                      text: '3. ', style: DefaultTextStyle.of(context).style),
                  const TextSpan(text: 'Responsibilities of the THIRD PARTY. '),
                  TextSpan(
                      text: '- The THIRD PARTY shall:',
                      style: DefaultTextStyle.of(context).style),
                ],
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(left: 16.0, top: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('3.1 '),
                Expanded(
                  child: Text(
                    'Sign a receipt acknowledging the delivery of his/her impounded vehicle(s) (and/or confiscated personal properties, namely _______________________), to the SECOND PARTY; ',
                  ),
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(left: 16.0, top: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('3.2 '),
                Expanded(
                  child: Text(
                    'Pay the prescribed impounding/storage fees to the FIRST PARTY;',
                  ),
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(left: 16.0, top: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('3.3 '),
                Expanded(
                  child: Text(
                    'Coordinate properly with the SECOND PARTY all information required for the release of his/her impounded vehicle(s) (and/or confiscate personal properties, namely ________________________), in case of redemption; ',
                  ),
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(left: 16.0, top: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('3.4 '),
                Expanded(
                  child: Text(
                    'Relinquish or waive any title or rights over his/her impounded vehicle(s) (and/or confiscate personal properties, namely _________________________), in favor of the __________________, in case of failure to pay the impounding/storage fee within the period prescribed by SB/SP Ordinance No. _____________; and.',
                  ),
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(left: 16.0, top: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('3.5 '),
                Expanded(
                  child: Text(
                    'Execute and sign necessary documents relative to the above-mentioned responsibilities.',
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: RichText(
              text: TextSpan(
                style: const TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.black87),
                children: [
                  TextSpan(
                      text: '4. ', style: DefaultTextStyle.of(context).style),
                  const TextSpan(text: 'Effectivity and Duration '),
                  TextSpan(
                      text:
                          '- This agreement shall take effect upon the signing by authorized representatives of the respective parties, and shall continue to be valid and binding until terminated by any party, or automatically terminated secondary to exhaustion or utilization of transferred funds.',
                      style: DefaultTextStyle.of(context).style),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: RichText(
              text: TextSpan(
                style: const TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.black87),
                children: [
                  TextSpan(
                      text: '5. ', style: DefaultTextStyle.of(context).style),
                  const TextSpan(
                      text: 'Amendment, Modification, Adoption or Deletion '),
                  TextSpan(
                      text:
                          '- Any amendment, modification, addition or deletion of any provision of this agreement shall be agreed upon by both parties in writing.',
                      style: DefaultTextStyle.of(context).style),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: RichText(
              text: TextSpan(
                style: const TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.black87),
                children: [
                  TextSpan(
                      text: '6. ', style: DefaultTextStyle.of(context).style),
                  const TextSpan(text: 'Settlement of Disputes '),
                  TextSpan(
                      text:
                          '- The parties shall exert effort to settle amicably any dispute arising out/or in connection with the agreement or its interpretation.',
                      style: DefaultTextStyle.of(context).style),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: RichText(
              text: TextSpan(
                style: const TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.black87),
                children: [
                  TextSpan(
                      text: '7. ', style: DefaultTextStyle.of(context).style),
                  const TextSpan(text: 'Separability '),
                  TextSpan(
                      text:
                          '- In the event that any provision of this MOA is declared or adjudged to be unenforceable or unlawful by the appropriate Government Authority, the remaining provisions shall continue and remain in full force and effect together with all the rights and remedies granted thereby.',
                      style: DefaultTextStyle.of(context).style),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: RichText(
              text: TextSpan(
                style: const TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.black87),
                children: [
                  TextSpan(
                      text: '8. ', style: DefaultTextStyle.of(context).style),
                  const TextSpan(text: 'Venue of Action '),
                  TextSpan(
                      text:
                          '- Any action that may arise by reason of this MOA shall be filed only and exclusively before the proper court of Butuan City, to the exclusion of all other courts.',
                      style: DefaultTextStyle.of(context).style),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: RichText(
              text: TextSpan(
                style: const TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.black87),
                children: [
                  const TextSpan(text: 'IN WITNESS WHEREOF, '),
                  TextSpan(
                      text:
                          'the parties hereunto have affixed their respective signatures this________ day of ________20______ at ________________________, Philippines.',
                      style: DefaultTextStyle.of(context).style),
                ],
              ),
            ),
          ),
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
