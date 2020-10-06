import 'package:andina_protos/widgets/common/drawer.dart';
import 'package:andina_protos/widgets/dashboard/option_menu.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:andina_protos/blocs/profile/profile.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DashboardPage extends StatefulWidget {
  final Function initializeCart;

  const DashboardPage({Key key, @required this.initializeCart})
      : super(key: key);

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _currentIndex = 0;
  ProfileBloc _profileBloc;
  @override
  void initState() {
    widget.initializeCart();
    _profileBloc = BlocProvider.of<ProfileBloc>(context);
    _profileBloc.dispatch(FetchProfile());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
        leading: Builder(builder: (BuildContext ctx) {
          return IconButton(
            icon: Icon(MdiIcons.menu),
            onPressed: () {
              Scaffold.of(ctx).openDrawer();
            },
          );
        }),
      ),
      body: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.circular(20.0),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(20.0),
                    onTap: () {
                      Navigator.pushNamed(context, '/products');
                    },
                    child: MenuOption(
                      title: 'Comprar',
                      icon: MdiIcons.basket,
                    ),
                  ),
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(20.0),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(20.0),
                    onTap: () {
                      Navigator.pushNamed(context, '/orders');
                    },
                    child: MenuOption(
                      title: 'Mis pedidos',
                      icon: MdiIcons.cart,
                    ),
                  ),
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.circular(20.0),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(20.0),
                    onTap: ( ) { Navigator.pushNamed(context, '/sales'); },
                    child: MenuOption(
                      title: 'Promociones',
                      icon: MdiIcons.tagHeart,
                    ),
                  ),
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(20.0),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(20.0),
                    onTap: () {
                      Navigator.pushNamed(context, '/profile');
                    },
                    child: MenuOption(
                      title: 'Perfil',
                      icon: MdiIcons.accountCircle,
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
      drawer: CustomDrawer(),
    );
  }
}
