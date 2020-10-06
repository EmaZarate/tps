import 'package:andina_protos/widgets/login/input_field_area.dart';
import 'package:flutter/material.dart';

class FormContainer extends StatelessWidget {
  final TextEditingController usernameController;
  final TextEditingController passwordController;

  const FormContainer(
      {Key key,
      @required this.usernameController,
      @required this.passwordController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Form(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                InputFieldArea(
                    controller: usernameController,
                    hint: 'Usuario',
                    obscure: false,
                    icon: Icons.person_outline),
                InputFieldArea(
                    controller: passwordController,
                    hint: 'Contraseña',
                    obscure: true,
                    icon: Icons.lock_outline),
              ],
            ),
          )
        ],
      ),
    );
  }
}
