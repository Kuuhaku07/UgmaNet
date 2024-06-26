import 'package:UgmaNet/services/firebase_service.dart';
import 'package:UgmaNet/services/globals.dart';
import 'package:flutter/material.dart';
import 'package:UgmaNet/visual/Screens/feed.dart';

TextEditingController expedientNumber = TextEditingController();
TextEditingController password = TextEditingController();

class SignInPage2 extends StatefulWidget {
  const SignInPage2({super.key});

  @override
  State<SignInPage2> createState() => _SignInPage2State();
}

class _SignInPage2State extends State<SignInPage2> {
  @override
  Widget build(BuildContext context) {
    final bool isSmallScreen = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      //---------------------------Appbar-------------------------------------//
      appBar: AppBar(
        title: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(width: 16),
              Text(
                'UGMANET',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: const Color.fromARGB(206, 36, 55, 165),
                    fontWeight: FontWeight.bold,
                    fontSize: 35),
              ),
            ],
          ),
        ),
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Container(
              color: Colors.grey, // change the color as per your requirement
              height: 1.0,
            ),
          ),
        ),
      ),
      //---------------------------Appbar-------------------------------------//

      body: Center(
        child: isSmallScreen
            ? const Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _Logo(),
                  _FormContent(),
                  _RegisterButton(), // Add this widget below the login form
                ],
              )
            : Container(
                padding: const EdgeInsets.all(32.0),
                constraints: const BoxConstraints(maxWidth: 800),
                child: const Row(
                  children: [
                    Expanded(child: _Logo()),
                    Expanded(
                      child: Center(child: _FormContent()),
                    ),
                  ],
                ),
              ),
      ),
      //-------------------------------Body---------------------------------//
    );
  }
}

class _Logo extends StatelessWidget {
  const _Logo();

  @override
  Widget build(BuildContext context) {
    final bool isSmallScreen = MediaQuery.of(context).size.width < 200;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        //FlutterLogo(size: isSmallScreen ? 100 : 200),
        Image.network("https://i.postimg.cc/jS99jk2H/logo.png"),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            "Bienvenido a UgmaNet!",
            textAlign: TextAlign.center,
            style: isSmallScreen
                ? Theme.of(context).textTheme.headlineSmall
                : Theme.of(context)
                    .textTheme
                    .headlineMedium
                    ?.copyWith(color: Colors.black),
          ),
        )
      ],
    );
  }
}

class _FormContent extends StatefulWidget {
  const _FormContent();

  @override
  State<_FormContent> createState() => __FormContentState();
}

class __FormContentState extends State<_FormContent> {
  bool _isPasswordVisible = false;
  bool _rememberMe = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 300),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              validator: (value) {
                // add validation
                if (value == null || value.isEmpty) {
                  return 'Por favor ingrese su numero de expediente';
                }

                bool emailValid = RegExp(r'^\d{9,10}$').hasMatch(value);
                if (!emailValid) {
                  return 'Por favor ingrese su numero de expediente';
                }

                return null;
              },
              controller: expedientNumber,
              decoration: const InputDecoration(
                labelText: 'Numero de expediente',
                hintText: 'Ingresa tu numero de expediente',
                prefixIcon: Icon(Icons.email_outlined),
                border: OutlineInputBorder(),
              ),
            ),
            _gap(),
            TextFormField(
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor pon algo de texto';
                }

                if (value.length < 6) {
                  return 'La contraseña debe tener al menos 6 caracteres';
                }
                return null;
              },
              obscureText: !_isPasswordVisible,
              controller: password,
              decoration: InputDecoration(
                  labelText: 'Contraseña',
                  hintText: 'Ingrese su contraseña',
                  prefixIcon: const Icon(Icons.lock_outline_rounded),
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(_isPasswordVisible
                        ? Icons.visibility_off
                        : Icons.visibility),
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                  )),
            ),
            _gap(),
            CheckboxListTile(
              value: _rememberMe,
              onChanged: (value) {
                if (value == null) return;
                setState(() {
                  _rememberMe = value;
                });
              },
              title: const Text('Recuerdame'),
              controlAffinity: ListTileControlAffinity.leading,
              dense: true,
              contentPadding: const EdgeInsets.all(0),
            ),
            _gap(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4)),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Text(
                      'Ingresar',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                  onPressed: () {
                    FutureBuilder(
                        future: getUsuarios(),
                        builder: ((context, snapshot) {
                          if (snapshot.hasData) {
                            return ListView.builder(
                              itemCount: snapshot.data?.length,
                              itemBuilder: (context, index) {
                                return Text(
                                    snapshot.data?[index]['Expediente']);
                              },
                            );
                          } else {
                            return const Center(
                                child: CircularProgressIndicator());
                          }
                        }));
                    login(expedientNumber.text, password.text, (bool success) {
                      if (success) {
                        expedienteGlobal = int.parse(expedientNumber.text);
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const NewsFeedPage1()),
                        );
                      } else {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Error'),
                              content: const Text(
                                  'Credenciales invalidas. Por favor revise e intente de nuevo'),
                              actions: <Widget>[
                                TextButton(
                                  child: const Text('OK'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      }
                    });
                  }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _gap() => const SizedBox(height: 16);
}

void login(
    String expedientNumber, String password, Function(bool) callback) async {
  int exp = int.parse(expedientNumber);

  String passwordDb = await askUsuario(exp);

  if (passwordDb == "notfound") {
    // Handle the case where the expedient number is not found
    callback(false);
  } else if (password == passwordDb) {
    callback(true);
  } else {
    callback(false);
  }
}

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  RegisterFormState createState() => RegisterFormState();
}

class RegisterFormState extends State<RegisterForm> {
  final _formKey = GlobalKey<FormState>();
  final expedientController = TextEditingController();
  final nameController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 300,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/iconos/logo.png'),
            const SizedBox(height: 16),
            Center(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: expedientController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingrese su numero de expediente';
                        }

                        bool expedientValid =
                            RegExp(r'^\d{9,10}$').hasMatch(value);
                        if (!expedientValid) {
                          return 'Por favor ingrese un numero de expediente valido';
                        }

                        return null;
                      },
                      decoration: const InputDecoration(
                        labelText: 'Numero de expediente',
                        hintText: 'Ingresa tu numero de expediente',
                        prefixIcon: Icon(Icons.email_outlined),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: nameController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingrese su nombre';
                        }

                        return null;
                      },
                      decoration: const InputDecoration(
                        labelText: 'Nombre',
                        hintText: 'Ingresa tu nombre',
                        prefixIcon: Icon(Icons.person),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: passwordController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingrese su contraseña';
                        }

                        if (value.length < 6) {
                          return 'La contraseña debe tener al menos 6 caracteres';
                        }

                        return null;
                      },
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: 'Contraseña',
                        hintText: 'Ingresa tu contraseña',
                        prefixIcon: Icon(Icons.lock_outline_rounded),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          int expediente = int.parse(expedientController.text);
                          String nombre = nameController.text;
                          String password = passwordController.text;
                          registerUser(expediente, nombre, password);
                        }
                      },
                      child: const Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Text(
                          'Registrar',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void registerUser(int expediente, String nombre, String password) async {
    registerUserDB(expediente, nombre, "https://picsum.photos/id/1062/80/80",
        password, "estudiante");
    print('User registered');
    Navigator.pop(context);
  }

  @override
  void dispose() {
    expedientController.dispose();
    nameController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registrarse'),
      ),
      body: const RegisterForm(),
    );
  }
}

class _RegisterButton extends StatelessWidget {
  const _RegisterButton();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        ),
        child: const Padding(
          padding: EdgeInsets.all(10.0),
          child: Text(
            'Registrarse',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const RegisterPage()),
          );
        },
      ),
    );
  }
}
