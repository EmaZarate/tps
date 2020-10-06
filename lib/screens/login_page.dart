import 'package:andina_protos/blocs/authentication/authentication_bloc.dart';
import 'package:andina_protos/blocs/login/login.dart';
import 'package:andina_protos/repositories/customer.repository.dart';
import 'package:andina_protos/widgets/login/contact_us.dart';
import 'package:andina_protos/widgets/login/forgot_password.dart';
import 'package:andina_protos/widgets/login/form_container.dart';
import 'package:andina_protos/widgets/login/picture.dart';
import 'package:flutter/material.dart';
import 'package:andina_protos/screens/styles.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginPage extends StatefulWidget {
  final CustomerRepository customerRepository;

  LoginPage({Key key, @required this.customerRepository})
      : assert(customerRepository != null),
        super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  LoginBloc _loginBloc;
  AuthenticationBloc _authenticationBloc;
  CustomerRepository get _customerRepository => widget.customerRepository;

  @override
  void initState() {
    _authenticationBloc = BlocProvider.of<AuthenticationBloc>(context);
    _loginBloc = LoginBloc(
        authenticationBloc: _authenticationBloc,
        customerRepository: _customerRepository);
    super.initState();
  }

  @override
  void dispose() {
    _loginBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final usernameController = TextEditingController();
    final passwordController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Text('AndinaApp'),
      ),
      body: BlocBuilder<LoginEvent, LoginState>(
        bloc: _loginBloc,
        builder: (BuildContext context, LoginState state) {
          return ListView(
            padding: const EdgeInsets.all(10.0),
            children: <Widget>[
              Stack(
                alignment: AlignmentDirectional.bottomCenter,
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Picture(image: picture),
                      FormContainer(
                        usernameController: usernameController,
                        passwordController: passwordController,
                      ),
                      validateUserAndPassword(state),
                      Padding(
                        padding: const EdgeInsets.only(top: 30.0, bottom: 30.0),
                        child: state is LoginLoading ? CircularProgressIndicator() : _buildSubmitButton(usernameController, passwordController, context),
                        ),
                      ForgotPassword(),
                      ContactUs(),
                    ],
                  ),
                ],
              )
            ],
          );
        },
      ),
    );
  }

  Widget _buildSubmitButton(
    TextEditingController usernameController,
    TextEditingController passwordController,
    BuildContext context
  ){
    return Container(
      width: 280.0,
      height: 60.0,
      child: RaisedButton(
        child: Text(
          'Ingresar',
          style: TextStyle(
              color: Colors.white,
              fontSize: 20.0,
              fontWeight: FontWeight.w300,
              letterSpacing: 0.3),
        ),
        onPressed: () {
          _dispatchLoginButtonPressed(usernameController, passwordController);
        },
        color: Theme.of(context).accentColor,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
      ),
    );
  }

  void _dispatchLoginButtonPressed(
    TextEditingController usernameController,
    TextEditingController passwordController,
  ) {
    _loginBloc.dispatch(LoginButtonPressed(
        username: usernameController.text, password: passwordController.text));
  }

  Widget validateUserAndPassword(LoginState state){
    if(state is LoginFailure) {
      return Padding(
        padding: EdgeInsets.all(15), 
        child: Text('Usuario o contraseña incorrecta', style: TextStyle(color: Colors.red, fontSize: 16))
      );
    }
    else if(state is LoginLocked){
      return Padding(
        padding: EdgeInsets.all(15), 
        child: Text('Usuario bloqueado', style: TextStyle(color: Colors.red, fontSize: 16))
      );
    }
    else {
      return Container();
    }
  }
}
