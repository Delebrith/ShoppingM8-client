import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shoppingm8_fe/common/roundButtonWidget.dart';
import 'package:shoppingm8_fe/list/invitation/listInvitationsWidget.dart';

class InvitationsTileWidget extends StatelessWidget {
  final Function addToListsFunction;

  const InvitationsTileWidget({Key key, this.addToListsFunction}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      padding: EdgeInsets.only(bottom: 90, top: 50, left: 40, right: 40),
      child: DottedBorder(
        color: Colors.blueGrey,
        dashPattern: [8, 4],
        strokeWidth: 3,
        strokeCap: StrokeCap.butt,
        child: Card(
          color: Color.fromARGB(180, 242, 255, 255),
          borderOnForeground: false,
          margin: EdgeInsets.all(0),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(15),
                      child:
                      Text("See invitations:",
                          style: TextStyle(
                              fontSize: 28
                          )
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: RoundButtonWidget(
                        icon: Icons.group_add,
                        radius: 40,
                        color: Colors.lightBlueAccent,
                        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ListInvitationsWidget(addToListsFunction: addToListsFunction))),
                      ),
                    )
                  ],
                ),
              ],
            )
          ),
        ),
      )
    );
  }

}
