import 'package:andina_protos/blocs/profile/profile.dart';
import 'package:andina_protos/widgets/profile/branch_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class BranchesScreen extends StatelessWidget {
  const BranchesScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pushNamed(context, '/branch/new');
          },
          child: Icon(MdiIcons.plus, color: Colors.black54),
          backgroundColor: Colors.teal[300],
        ),
        backgroundColor: Colors.grey[200],
        body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                centerTitle: true,
                backgroundColor: Colors.teal[300],
                expandedHeight: 150.0,
                floating: false,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  centerTitle: true,
                  title: Text(
                    'Mis sucursales',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: Colors.black54,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  background: Container(
                    height: 70.0,
                    child: Stack(
                      fit: StackFit.expand,
                      // crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Container(
                          alignment: Alignment.centerRight,
                          child: Icon(
                            Icons.home,
                            color: Colors.teal.withOpacity(0.30),
                            size: 180.0,
                          ),
                        ),
                      ],
                    ),
                    decoration: BoxDecoration(
                      color: Colors.teal[300],
                    ),
                  ),
                ),
              )
            ];
          },
          body: _buildBody(context),
        ));
  }

  Widget _buildBody(BuildContext context) {
    ProfileBloc _profileBloc = BlocProvider.of<ProfileBloc>(context);
    return BlocBuilder(
      bloc: _profileBloc,
      builder: (BuildContext context, ProfileState state) {
        if (state is ProfileLoaded) {
          return Column(
            children: <Widget>[
              Expanded(
                child: Container(
                  child: ListView.builder(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
                    itemCount: state.customer.branches.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 3.0),
                        child: BranchCard(branch: state.customer.branches[index], branches: state.customer.branches.length,),
                      );
                    },
                  ),
                ),
              )
            ],
          );
        }
        if(state is ProfileLoading){
          return Center(child: CircularProgressIndicator(),);
        }
        else{
          return Center(child: Text('Hubo un error cargando los datos.'),);
        }
      },
    );
  }
}
