import 'package:andina_protos/blocs/profile/profile.dart';
import 'package:andina_protos/widgets/profile/options.dart';
import 'package:andina_protos/widgets/profile/picture.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../helpers/customer_helper.dart';

class ProfileScreen extends StatefulWidget {

  const ProfileScreen({Key key})
      : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  ProfileBloc _profileBloc;
  CustomerHelper _customerHelper;

  @override
  void initState() {
    super.initState();
    _customerHelper = new CustomerHelper();
    _profileBloc = BlocProvider.of<ProfileBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.grey[300],
        toolbarOpacity: 1.0,
      ),
      body: BlocBuilder(
        bloc: _profileBloc,
        builder: (BuildContext context, ProfileState state) {
          if (state is ProfileLoaded) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  height: MediaQuery.of(context).size.height / 3,
                  width: MediaQuery.of(context).size.width,
                  color: Colors.grey[300],
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[

                      PictureProfile(image: state.customer.img != null ? state.customer.img.split(',')[1] : ''),
                      Column(
                        children: <Widget>[
                          Text(
                            state.customer != null ? state.customer.username : '',
                            style: TextStyle(
                                fontSize: 20.0, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            state.customer != null ? state.customer.businessName : '',
                            style: TextStyle(fontSize: 18.0),
                          ),
                           Container(
                             margin: const EdgeInsets.only(top: 4.0),
                             child: Text(
                              'Día de entrega: ' + _customerHelper.returnShipmentDay(state.customer.shipmentDay),
                              style: TextStyle(fontSize: 18.0),
                          ),
                           )
                        ],
                      ),
                    ],
                  ),
                ),
                OptionsProfile(customer: state.customer),
              ],
            );
          } else {
            return Center(
              child: Text('Error recuperando tus datos'),
            );
          }
        },
      ),
    );
  }
}
