import 'package:andina_protos/blocs/authentication/authentication.dart';
import 'package:andina_protos/widgets/common/drawer_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          CustomDrawerHeader(),
          ListTile(
            leading: Icon(MdiIcons.basket),
            title: Text('Comprar'),
            onTap: () {
              Navigator.pushNamed(context, '/products');
            },
          ),
          ListTile(
            leading: Icon(MdiIcons.cart,),
            title: Text('Mis pedidos'),
            onTap: () {
              Navigator.pushNamed(context, '/orders');
            },
          ),
          ListTile(
            leading: Icon(MdiIcons.tagHeart),
            title: Text('Promociones'),
            onTap: () {
              Navigator.pushNamed(context, '/sales');
            },
          ),
          ListTile(
            leading: Icon(MdiIcons.accountCircle),
            title: Text('Perfil'),
            onTap: () {
              Navigator.pushNamed(context, '/profile');
            },
          ),
          ListTile(
            leading: Icon(MdiIcons.logout),
            title: Text('Cerrar sesión'),
            onTap: () {
              final authBloc = BlocProvider.of<AuthenticationBloc>(context);
                  authBloc.dispatch(LoggedOut());
                  Navigator.pop(context);
            },
          )
        ],
      ),
    );
  }
}
