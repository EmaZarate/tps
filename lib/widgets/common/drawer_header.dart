import 'package:andina_protos/blocs/profile/profile_bloc.dart';
import 'package:andina_protos/blocs/profile/profile_state.dart';
import 'package:andina_protos/widgets/profile/picture.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CustomDrawerHeader extends StatelessWidget {
  const CustomDrawerHeader({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    ProfileBloc _profileBloc = BlocProvider.of<ProfileBloc>(context);
    return BlocBuilder(
      bloc: _profileBloc,
      builder: (BuildContext context, ProfileState state) {
        if(state is ProfileLoaded) {
          return UserAccountsDrawerHeader(
            accountName: Text(state.customer.username),
            accountEmail: Text(state.customer.email != null ? state.customer.email : ''),
            currentAccountPicture: state.customer.img != null ? PictureProfile(image: state.customer.img.split(',')[1]) : CircleAvatar(backgroundColor: Theme.of(context).backgroundColor,child: Text(state.customer.username.substring(0,1).toUpperCase(), style: TextStyle(fontSize: 40.0)))
          );
        }else {
          return UserAccountsDrawerHeader(
            accountName: Text('Andina'),
            accountEmail: Text('andina@andina.com'),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Theme.of(context).backgroundColor,
              child: Text('A', style: TextStyle(fontSize: 40.0),),
            ),
          );
        }
      }
    );
  }
}