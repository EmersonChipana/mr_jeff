import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mr_jeff/main.dart';

import 'package:mr_jeff/cubit/sign/sign_cubit.dart';
import 'package:mr_jeff/model/newuser_model/newuser_model.dart';
import 'package:mr_jeff/ui/code_new_user.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // create a signCubit
  final SignCubit _signCubit = SignCubit();

  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _numPhoneController = TextEditingController();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  RegExp pass_valid = RegExp(r'^[a-zA-Z0-9]+$');
  double password_strength = 0;
  bool validatePassword(String pass) {
    String _password = pass.trim();
    if (_password.isEmpty) {
      setState(() {
        password_strength = 0;
      });
    } else if (_password.length < 6) {
      setState(() {
        password_strength = 1 / 4;
      });
    } else if (_password.length < 8) {
      setState(() {
        password_strength = 2 / 4;
      });
    } else {
      if (pass_valid.hasMatch(_password)) {
        setState(() {
          password_strength = 4 / 4;
        });
        return true;
      } else {
        setState(() {
          password_strength = 3 / 4;
        });
        return false;
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Registro"),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  controller: _firstNameController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Nombre',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingrese su nombre';
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: _lastNameController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Apellido',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingrese su apellido';
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: _numPhoneController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Número de teléfono',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingrese su número de teléfono';
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Correo Electrónico',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingrese su correo electrónico';
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: _usernameController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Nombre de Usuario',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingrese su nombre de usuario';
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    onChanged: (value) {
                      _formKey.currentState!.validate();
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Ingrese una contraseña";
                      } else {
                        //call function to check password
                        bool result = validatePassword(value);
                        if (result) {
                          // create account event
                          return null;
                        } else {
                          return " Se necesita una mayúscula, minúscula y numero ";
                        }
                      }
                    },
                    decoration: InputDecoration(
                        border: OutlineInputBorder(), hintText: "Contraseña"),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: LinearProgressIndicator(
                    value: password_strength,
                    backgroundColor: Colors.grey[300],
                    minHeight: 5,
                    color: password_strength <= 1 / 4
                        ? Colors.red
                        : password_strength == 2 / 4
                            ? Colors.yellow
                            : password_strength == 3 / 4
                                ? Colors.blue
                                : Colors.green,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                    onPressed: password_strength != 1
                        ? null
                        : () {
                            final nuevo = NewUser(
                                email: _emailController.text,
                                firstName: _firstNameController.text,
                                gender: 1,
                                lastName: _lastNameController.text,
                                numPhone: _numPhoneController.text,
                                password: _passwordController.text,
                                role: 'user',
                                username: _usernameController.text,
                                token: null);

                            BlocProvider.of<SignCubit>(context)
                                .chargeObject(nuevo);
                            BlocProvider.of<SignCubit>(context).signv2(nuevo);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const CodeNewUserScreen()));

                            // nicloai version
                            // _signCubit.sign(
                            //     _firstNameController.text,
                            //     _lastNameController.text,
                            //     _numPhoneController.text,
                            //     _emailController.text,
                            //     _usernameController.text,
                            //     _passwordController.text);
                            // Navigator.pushNamed(context, "/");

                            /*BlocProvider.of<SignCubit>(signCubit).sign(
                                _firstNameController.text,
                                _lastNameController.text,
                                _emailController.text,
                                _usernameController.text,
                                _passwordController.text);
                          },*/
                          },
                    child: Text("Registrarse"))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
