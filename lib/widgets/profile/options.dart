import 'package:andina_protos/blocs/authentication/authentication.dart';
import 'package:andina_protos/models/customer.dart';
//import 'package:andina_protos/screens/branches.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class OptionsProfile extends StatelessWidget {
  final Customer customer;

  const OptionsProfile({Key key, this.customer}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        child: ListView(
          shrinkWrap: true,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                  border: Border(
                top: BorderSide(color: Colors.black),
              )),
              child: ListTile(
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                leading: IconTile(
                  icon: MdiIcons.cart,
                ),
                title: Text("Mis pedidos"),
                trailing: IconTile(
                  icon: MdiIcons.chevronRight,
                ),
                onTap: () {
                  Navigator.popAndPushNamed(context, '/orders');
                },
              ),
            ),
            // Container(
            //   decoration: BoxDecoration(
            //       border: Border(
            //     top: BorderSide(color: Colors.black),
            //   )),
            //   child: ListTile(
            //     contentPadding:
            //         const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
            //     leading: IconTile(
            //       icon: MdiIcons.store,
            //     ),
            //     title: Text(
            //       "Mis Sucursales",
            //     ),
            //     onTap: () {
            //       Navigator.push(
            //         context,
            //         MaterialPageRoute(
            //           builder: (BuildContext context) => BranchesScreen(),
            //         ),
            //       );
            //     },
            //     trailing: IconTile(
            //       icon: MdiIcons.chevronRight,
            //     ),
            //   ),
            // ),
            Container(
              decoration: BoxDecoration(
                  border: Border(
                top: BorderSide(color: Colors.black),
              )),
              child: ListTile(
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                leading: IconTile(
                  icon: MdiIcons.keyVariant
                ),
                title: Text(
                  "Cambiar contraseña",
                ),
                trailing: IconTile(
                  icon: MdiIcons.chevronRight,
                ),
                onTap: () {
                  Navigator.pushNamed(context, '/password');
                },
              ),
            ),
            Container(
              decoration: BoxDecoration(
                  border: Border(
                      top: BorderSide(color: Colors.black),
                      bottom: BorderSide(color: Colors.black))),
              child: ListTile(
                onTap: () {
                  final authBloc = BlocProvider.of<AuthenticationBloc>(context);
                  authBloc.dispatch(LoggedOut());
                  Navigator.pop(context);
                },
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                leading: IconTile(icon: MdiIcons.logout),
                title: Text("Cerrar sesión"),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class IconTile extends StatelessWidget {
  final IconData icon;

  IconTile({this.icon});

  @override
  Widget build(BuildContext context) {
    return Icon(
      icon,
      size: 40.0,
      color: Colors.teal,
    );
  }
}
