import 'package:flutter/material.dart';
import 'dart:collection';
import '../../widgets/widgets.dart';
import '../../classes/classes.dart';

class ChatEndDrawer extends StatelessWidget {
  Widget build(BuildContext context){
    return Drawer(
      // Add a ListView to the drawer. This ensures the user can scroll
      // through the options in the drawer if there isn't enough vertical
      // space to fit everything.
      // 
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Text('SpaceX'),
          ),
          ListTile(
            title: Text('Add Members'),
            onTap: () {
              // Update the state of the app.
              // ...
            },
          ),
          ExpansionTile(
            title: Text('Members'),
            children: [
              ExpansionTile(
                title: Text('halo'),
                children: [
                  ListTile(
                    title: Text('One-line with trailing widget'),
                    trailing: PopUpAdminActions(),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      FlatButton(
                        height: 30.0,
                        onPressed: () {},
                        color: Colors.green[600],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Text('Make Admin',
                            style: TextStyle(
                              fontSize: 15.0,
                              fontWeight: FontWeight.w400,
                              color: Colors.white,
                            )),
                      ),
                      FlatButton(
                        height: 30.0,
                        onPressed: () {},
                        color: Colors.red[600],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Text('Kick User',
                            style: TextStyle(
                              fontSize: 15.0,
                              fontWeight: FontWeight.w400,
                              color: Colors.white,
                            )),
                      ),
                    ],
                  ),
                ]
              ),
              ExpansionTile(
                title: Text('hello'),
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      FlatButton(
                        height: 30.0,
                        onPressed: () {},
                        color: Colors.orange[600],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Text('Make User',
                            style: TextStyle(
                              fontSize: 15.0,
                              fontWeight: FontWeight.w400,
                              color: Colors.white,
                            )),
                      ),
                      FlatButton(
                        height: 30.0,
                        onPressed: () {},
                        color: Colors.red[600],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Text('Kick User',
                            style: TextStyle(
                              fontSize: 15.0,
                              fontWeight: FontWeight.w400,
                              color: Colors.white,
                            )),
                      ),
                    ],
                  ),
                ]
              ),
            ],
          ),
        ],
      ),
    );
  }
}