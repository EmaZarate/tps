import 'package:andina_protos/models/branch.dart';
import 'package:andina_protos/screens/branch_edit.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class BranchCard extends StatelessWidget {
  final Branch branch;
  final int branches;

  const BranchCard({Key key, this.branch, this.branches}) : super(key: key);

  _buildTitleCard() {
    return Container(
      margin: const EdgeInsets.only(left: 8.0),
      child: Text(
        branch.name,
        style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
      ),
    );
  }

  _buildSubtitleCard() {
    return Container(
      margin: const EdgeInsets.only(left: 8.0),
      child: Text(
        branch.address,
        style: TextStyle(
            fontSize: 14.0, color: Colors.grey, fontWeight: FontWeight.bold),
      ),
    );
  }

  _buildEditButton(BuildContext context, int branches) {
    return Container(
      height: 60.0,
      alignment: Alignment.topRight,
      child: InkWell(
        borderRadius: BorderRadius.circular(100.0),
        child: Icon(MdiIcons.pencil, color: Colors.teal),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => BranchEdit(
                    branch: branch,
                    branches: branches,
                  ),
            ),
          );
        },
      ),
    );
  }

  _buildIconCard() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5.0),
        color: Colors.teal[200],
      ),
      width: 60.0,
      height: 60.0,
      child: Icon(
        MdiIcons.store,
        color: Colors.teal,
        size: 40.0,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    _buildIconCard(),
                    Container(
                      height: 60.0,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          _buildTitleCard(),
                          _buildSubtitleCard(),
                        ],
                      ),
                    ),
                  ],
                ),
                _buildEditButton(context, branches),
              ],
            ),
            Divider(),
            Row(
              children: <Widget>[
                _buildItemData('Ciudad', branch.city),
                _buildItemData('Provincia', branch.province),
              ],
            )
          ],
        ),
      ),
    );
  }

  Expanded _buildItemData(String title, String description) {
    return Expanded(
      flex: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(
                fontSize: 14.0,
                color: Colors.grey,
                fontWeight: FontWeight.bold),
          ),
          Text(
            description,
            style: TextStyle(fontSize: 17.0, fontWeight: FontWeight.w400),
          ),
        ],
      ),
    );
  }
}
