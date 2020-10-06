import 'package:andina_protos/blocs/profile/profile.dart';
import 'package:andina_protos/models/branch.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BranchEdit extends StatefulWidget {
  final Branch branch;
  final int branches;

  const BranchEdit({Key key, this.branch, this.branches}) : super(key: key);

  @override
  _BranchEditState createState() => _BranchEditState();
}

class _BranchEditState extends State<BranchEdit> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Branch branch;
  int branches;
  bool _isEditing = false;
  @override
  void initState() {
    super.initState();
    if (widget.branch != null) {
      branch = widget.branch;
      _isEditing = true;
      branches = widget.branches;
    } else {
      branch = Branch();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Text(
                  _isEditing ? 'Editar sucursal' : 'Crear nueva sucursal',
                  style: TextStyle(fontSize: 22.0),
                ),
                SizedBox(
                  height: 20.0,
                ),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Nombre',
                    border: OutlineInputBorder(),
                  ),
                  initialValue: branch.name,
                  onSaved: (String value) {
                    branch = branch.copyWith(name: value);
                  },
                  validator: (String value) {
                    if (value.isEmpty) {
                      return 'El campo no puede quedar vacío';
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 20.0,
                ),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Provincia',
                    border: OutlineInputBorder(),
                  ),
                  initialValue: branch.province,
                  onSaved: (String value) {
                    branch = branch.copyWith(province: value);
                  },
                  validator: (String value) {
                    if (value.isEmpty) {
                      return 'El campo no puede quedar vacío';
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 20.0,
                ),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Ciudad',
                    border: OutlineInputBorder(),
                  ),
                  initialValue: branch.city,
                  onSaved: (String value) {
                    branch = branch.copyWith(city: value);
                  },
                  validator: (String value) {
                    if (value.isEmpty) {
                      return 'El campo no puede quedar vacío';
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 20.0,
                ),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Dirección',
                    border: OutlineInputBorder(),
                  ),
                  initialValue: branch.address,
                  onSaved: (String value) {
                    branch = branch.copyWith(address: value);
                  },
                  validator: (String value) {
                    if (value.isEmpty) {
                      return 'El campo no puede quedar vacío';
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 20.0,
                ),
                Container(
                  height: 50.0,
                  width: double.infinity,
                  child: RaisedButton(
                    child: Text(
                      _isEditing ? 'Guardar' : 'Crear',
                      style: TextStyle(fontSize: 20.0),
                    ),
                    onPressed: () {
                      if (!_formKey.currentState.validate()) {
                        return;
                      }
                      _formKey.currentState.save();
                      final ProfileBloc _profileBloc =
                          BlocProvider.of<ProfileBloc>(context);

                      _isEditing
                          ? _profileBloc.dispatch(UpdateBranch(branch: branch))
                          : _profileBloc.dispatch(AddBranch(branch: branch));
                      Navigator.pop(context);
                    },
                    color: Theme.of(context).accentColor,
                  ),
                ),
                SizedBox(
                  height: 15.0,
                ),
                Container(
                  width: double.infinity,
                  child: _isEditing && branches > 1
                      ? RaisedButton(
                          child: Text('Eliminar sucursal'),
                          color: Colors.red,
                          onPressed: () {
                            final ProfileBloc _profileBloc =
                                BlocProvider.of<ProfileBloc>(context);
                            _profileBloc
                                .dispatch(RemoveBranch(branchId: branch.id));
                            Navigator.pop(context);
                          },
                        )
                      : Container(),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
