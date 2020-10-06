import 'package:andina_protos/blocs/password/password.dart';
import 'package:andina_protos/models/change_password.dart';
import 'package:andina_protos/repositories/customer.repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class PasswordChangeScreen extends StatefulWidget {
  final CustomerRepository customerRepository;

  const PasswordChangeScreen({@required this.customerRepository, Key key})
      : super(key: key);

  @override
  _PasswordChangeScreenState createState() => _PasswordChangeScreenState();
}

class _PasswordChangeScreenState extends State<PasswordChangeScreen> {
  CustomerRepository get _customerRepository => widget.customerRepository;

  PasswordBloc _passwordBloc;

  @override
  void initState() {
    super.initState();
    _passwordBloc = new PasswordBloc(customerRepository: _customerRepository);
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  ChangePassword changePasswordModel = ChangePassword();

  Widget _buildTitle() {
    return Text(
      'Cambiar contraseña',
      style: TextStyle(fontSize: 22.0),
    );
  }

  Widget _buildOldPasswordInput() {
    return TextFormField(
      obscureText: true,
      decoration: InputDecoration(
        labelText: 'Contraseña anterior',
        border: OutlineInputBorder(),
      ),
      onSaved: (String value) {
        changePasswordModel = changePasswordModel.copyWith(oldPassword: value);
      },
      validator: (String value) {
        if (value.isEmpty) {
          return 'El campo no puede quedar vacío';
        }
        return null;
      },
    );
  }

  Widget _buildNewPasswordInput() {
    return TextFormField(
      obscureText: true,
      decoration: InputDecoration(
        labelText: 'Nueva contraseña',
        border: OutlineInputBorder(),
      ),
      onSaved: (String value) {
        changePasswordModel = changePasswordModel.copyWith(newPassword: value);
      },
      validator: (String value) {
        if (value.isEmpty) {
          return 'La contraseña no puede quedar vacía';
        }
        if (value.length < 8) {
          return 'La contraseña debe tener al menos 8 carácteres.';
        }
        return null;
      },
    );
  }

  Widget _buildConfirmNewPasswordInput() {
    return TextFormField(
      obscureText: true,
      decoration: InputDecoration(
        labelText: 'Repita la nueva contraseña',
        border: OutlineInputBorder(),
      ),
      onSaved: (String value) {
        changePasswordModel =
            changePasswordModel.copyWith(newPasswordConfirmed: value);
      },
      validator: (String value) {
        if (value.isEmpty) {
          return 'El campo no puede quedar vacío';
        }
        return null;
      },
    );
  }

  Widget _buildSubmitButton(PasswordBloc _passwordBloc) {
    return RaisedButton(
      child: Text(
        'Actualizar',
        style: TextStyle(fontSize: 20.0),
      ),
      onPressed: () {
        if (!_formKey.currentState.validate()) {
          return;
        }
        _formKey.currentState.save();

        _passwordBloc.dispatch(
            ChangePasswordButtonPressed(changePassword: changePasswordModel));
        // final ProfileBloc _profileBloc =
        //     BlocProvider.of<ProfileBloc>(context);

        // _isEditing
        //     ? _profileBloc.dispatch(UpdateBranch(branch: branch))
        //     : _profileBloc.dispatch(AddBranch(branch: branch));
        // Navigator.pop(context);
      },
      color: Theme.of(context).accentColor,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        padding: const EdgeInsets.all(20.0),
        child: BlocBuilder(
          bloc: _passwordBloc,
          builder: (BuildContext context, PasswordState state) {
            if (state is PasswordChanging) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            if (state is PasswordChanged) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(MdiIcons.checkOutline, color: Colors.green, size: 40.0,),
                    Text('¡Se cambio exitosamente la contraseña!', style: TextStyle(color: Colors.green, fontSize: 18.0, fontWeight: FontWeight.bold),),
                  ],
                ),
              );
            }

            if (state is PasswordUnchanged || state is PasswordError) {
              return SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      _buildTitle(),
                      SizedBox(
                        height: 20.0,
                      ),
                      _buildOldPasswordInput(),
                      SizedBox(
                        height: 20.0,
                      ),
                      _buildNewPasswordInput(),
                      SizedBox(
                        height: 20.0,
                      ),
                      _buildConfirmNewPasswordInput(),
                      Container(
                        margin: const EdgeInsets.only(top: 5.0),
                        child: Text(
                          state is PasswordError ? state.error : '',
                          style: TextStyle(color: Colors.red, fontSize: 14.0),
                        ),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      Container(
                        height: 50.0,
                        width: MediaQuery.of(context).size.width,
                        child: _buildSubmitButton(_passwordBloc),
                      ),
                    ],
                  ),
                ),
              );
            }

            return Center(
              child: Text('Error inesperado, intenelo de nuevo'),
            );
          },
        ),
      ),
    );
  }
}
