import 'package:auto_route/auto_route.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lexxi/aplication/item_dynamic/item_dynamic_use_case.dart';
import 'package:lexxi/domain/auth/model/register_model.dart';
import 'package:lexxi/domain/item_dynamic/model/item.dart';
// import 'package:lexxi/domain/auth/model/SignUp_model.dart';
import 'package:lexxi/injection.dart';
import 'package:lexxi/src/global/colors_custom.dart';
import 'package:lexxi/src/global/widgets/gradient_button.dart';
import 'package:lexxi/src/global/widgets/rounded_date_picker.dart';
import 'package:lexxi/src/global/widgets/rounded_dropdown.dart';
import 'package:lexxi/src/global/widgets/rounded_dropdown_and_text_field.dart';
import 'package:lexxi/src/global/widgets/rounded_text_field.dart';
import 'package:lexxi/utils/loogers_custom.dart';
import 'package:lexxi/utils/whatsapp.dart';
import 'package:sizer/sizer.dart';

import '../../../../aplication/auth/service/auth_service.dart';

class TypeDocument {
  int id;
  String abrev;

  TypeDocument({required this.id, required this.abrev});
}

class Gender {
  int id;
  String name;
  Gender({required this.id, required this.name});
}

@RoutePage() // Add this annotation to your routable pages
class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  AuthService? _authService; // Servicio de autenticación
  final item = getIt.get<ItemDynamicUseCase>();

  // Controladores de texto
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _secondNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _secondLastNameController =
      TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _documentNumberController =
      TextEditingController();

  // Variables para almacenar selecciones
  TypeDocument? _selectedTypeDocument;
  Gender? _selectedGender;
  DateTime? _selectedBirthday;
  Item? _selectedState;
  Item? _selectedCity;
  Item? _selectedProgram;

  // Listas de opciones
  final List<Gender> genders = [
    Gender(id: 1, name: "Masculino"),
    Gender(id: 2, name: "Femenino"),
  ];
  final List<TypeDocument> typesDocument = [
    TypeDocument(id: 1, abrev: "C.C"),
    TypeDocument(id: 2, abrev: "NIT"),
    TypeDocument(id: 3, abrev: "C.E"),
    TypeDocument(id: 4, abrev: "T.I"),
    TypeDocument(id: 5, abrev: "PAS"),
    TypeDocument(id: 6, abrev: "SEG"),
    TypeDocument(id: 7, abrev: "E.S.N"),
    TypeDocument(id: 8, abrev: "FID"),
    TypeDocument(id: 9, abrev: "R.C"),
    TypeDocument(id: 10, abrev: "C.D"),
    TypeDocument(id: 11, abrev: "PAT"),
    TypeDocument(id: 12, abrev: "PEP"),
  ];

  // Notificadores para estados, ciudades y programas
  ValueNotifier<List<Item>> statesNotifier = ValueNotifier([]);
  ValueNotifier<List<Item>> cityNotifier = ValueNotifier([]);
  ValueNotifier<List<Item>> programas = ValueNotifier([]);

  // Variable para manejar errores
  String? error;

  // Form key para validaciones
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    loadData();
    super.initState();
  }

  void loadData() async {
    _authService = getIt.get<AuthService>();
    // Initialize default values for selections
    _selectedTypeDocument = typesDocument.first;
    _selectedGender = genders.first;
    _selectedBirthday = DateTime(2000, 1, 1); // Default to Jan 1, 2000

    // Load programs
    try {
      programas.value = await item.getAllItemsApi();
      if (programas.value.isNotEmpty) {
        _selectedProgram = programas.value[0];
      }
    } catch (e) {
      logger.e("Error loading programs: $e");
    }

    // Load states
    try {
      statesNotifier.value =
          await item.getAllItemsStateAndCity("info/department");
      if (statesNotifier.value.isNotEmpty) {
        _selectedState = statesNotifier.value[0];

        // Load cities based on selected state
        try {
          cityNotifier.value = await item.getAllItemsStateAndCity(
              "info/municipality/department/${_selectedState!.codeDep}");
          if (cityNotifier.value.isNotEmpty) {
            _selectedCity = cityNotifier.value[0];
          }
        } catch (e) {
          logger.e("Error loading cities: $e");
        }
      }
    } catch (e) {
      logger.e("Error loading states: $e");
    }

    // Debug print for verification
    if (_selectedCity != null) {
      print(_selectedCity!.toJson());
    }

    // Uncomment for debug mode testing with sample data
    // if (kDebugMode) {
    //   _nameController.text = "Vane";
    //   _secondNameController.text = "Ana";
    //   _lastNameController.text = "Perez";
    //   _secondLastNameController.text = "Gomez";
    //   _emailController.text = "millerjeison@gmail.com";
    //   _phoneController.text = "3183491375";
    //   _documentNumberController.text = "123456789";
    //   _selectedGender = genders[0];
    //   _selectedTypeDocument = typesDocument[0];
    //   _selectedBirthday = DateTime(2000, 1, 1);
    //   _selectedProgram = programas.value.isNotEmpty ? programas.value[0] : null;
    // }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _secondNameController.dispose();
    _lastNameController.dispose();
    _secondLastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _documentNumberController.dispose();
    statesNotifier.dispose();
    cityNotifier.dispose();
    programas.dispose();
    super.dispose();
  }

  // Función para validar y enviar el formulario
  void _submit() async {
    if (_formKey.currentState!.validate()) {
      // Construir el objeto de registro
      final signUpData = {
        "type_id": _selectedTypeDocument!.id,
        "number_id": _documentNumberController.text.trim(),
        "name": _nameController.text.trim(),
        "second_name": _secondNameController.text.trim(),
        "last_name": _lastNameController.text.trim(),
        "second_last": _secondLastNameController.text.trim(),
        "email": _emailController.text.trim(),
        "cellpone": _phoneController.text.trim(),
        "local_district":
            _selectedCity!.name, // Asumiendo que 'id' es el código de la ciudad
        "gender": _selectedGender!.name,
        "type_user": "student",
        "birthday": _selectedBirthday != null
            ? "${_selectedBirthday!.year}-${_selectedBirthday!.month.toString().padLeft(2, '0')}-${_selectedBirthday!.day.toString().padLeft(2, '0')}"
            : "",
        "programa": _selectedProgram!.shortName
      };

      final data = RegisterModel.fromJson(signUpData);
      try {
        await _authService!.register(data);
        if (kDebugMode) {
          print("Datos de registro: $signUpData");
        }
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Registro exitoso")),
        );
        context.router.replaceNamed('/login');
      } catch (e) {
        String errorMessage = e.toString().trim();

        if (errorMessage.contains('ID number already registered'.trim())) {
          errorMessage = 'El documento ya existe';
        }
        if (errorMessage.contains('Email already registered'.trim())) {
          errorMessage = 'El correo ya existe';
        }

        setState(() {
          error = errorMessage;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            behavior: SnackBarBehavior.floating,
            margin:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorPalette.primary,
      appBar: AppBar(backgroundColor: ColorPalette.primary),
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: Opacity(
                opacity: 0.3,
                child: Container(
                  width: 150,
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage("assets/logo_lexxi.png"))),
                ),
              ),
            ),
            SizedBox(
              width: 100.w,
              height: 100.h,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      // mainAxisAlignment: MainAxisAlignment.spaceAround, // Evita usar spaceAround en Column
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Logo
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 30,
                              height: 30,
                              decoration: const BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage('assets/logo_lexxi.png'),
                                  fit: BoxFit.contain,
                                ),
                              ),
                              margin: const EdgeInsets.symmetric(vertical: 20),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Container(
                              width: 80,
                              height: 50,
                              decoration: const BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage('assets/lexxi.png'),
                                  fit: BoxFit.contain,
                                ),
                              ),
                              margin: const EdgeInsets.symmetric(vertical: 20),
                            ),
                          ],
                        ),

                        //----
                        Center(
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 24.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  'Regístrate',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 20),
                                const Text(
                                  'Crea tu cuenta para acceder a recursos y actividades de aprendizaje.',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.white,
                                    height: 1.4,
                                  ),
                                ),
                                const SizedBox(height: 40),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text(
                                      '¿Ya tienes cuenta? ',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.white,
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        context.router.replaceNamed('/login');
                                      },
                                      child: const Text(
                                        'Iniciar sesión',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                          decoration: TextDecoration.underline,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),

                        //----
                        // Campos del formulario
                        Column(
                          children: [
                            // Nombre
                            RoundedTextField(
                              controller: _nameController,
                              hintText: 'Primer Nombre*',
                              width: 70.w,
                              onSubmitted: (_) {
                                FocusScope.of(context).nextFocus();
                              },
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Por favor, ingresa tu nombre';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 2.h),
                            // Segundo Nombre
                            RoundedTextField(
                              controller: _secondNameController,
                              hintText: 'Segundo Nombre',
                              width: 70.w,
                              onSubmitted: (_) {
                                FocusScope.of(context).nextFocus();
                              },
                              // Segundo nombre es opcional, no requiere validación
                            ),
                            SizedBox(height: 2.h),
                            // Primer Apellido
                            RoundedTextField(
                              controller: _lastNameController,
                              hintText: 'Primer Apellido*',
                              width: 70.w,
                              onSubmitted: (_) {
                                FocusScope.of(context).nextFocus();
                              },
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Por favor, ingresa tu primer apellido';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 2.h),
                            // Segundo Apellido
                            RoundedTextField(
                              controller: _secondLastNameController,
                              hintText: 'Segundo Apellido',
                              width: 70.w,
                              onSubmitted: (_) {
                                FocusScope.of(context).nextFocus();
                              },
                              // Segundo apellido es opcional, no requiere validación
                            ),
                            SizedBox(height: 2.h),
                            // Fecha de Nacimiento
                            RoundedDatePicker(
                              hintText: "Fecha de nacimiento",
                              width: 70.w,
                              initialDate: _selectedBirthday,
                              firstDate: DateTime(1900, 1, 1),
                              lastDate: DateTime.now(),
                              onDateSelected: (DateTime date) {
                                setState(() {
                                  _selectedBirthday = date;
                                });
                              },
                              validator: (date) {
                                return null;
                              },
                            ),
                            SizedBox(height: 2.h),
                            // Correo Electrónico
                            RoundedTextField(
                              controller: _emailController,
                              hintText: 'Correo',
                              width: 70.w,
                              keyboardType: TextInputType.emailAddress,
                              onSubmitted: (_) {
                                FocusScope.of(context).nextFocus();
                              },
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Por favor, ingresa tu correo electrónico';
                                }
                                final emailRegex = RegExp(
                                    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@"
                                    r"[a-zA-Z0-9]+\.[a-zA-Z]+");
                                if (!emailRegex.hasMatch(value)) {
                                  return 'Por favor, ingresa un correo válido';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 2.h),
                            // Teléfono
                            RoundedTextField(
                              controller: _phoneController,
                              hintText: 'Teléfono',
                              width: 70.w,
                              keyboardType: TextInputType.phone,
                              onSubmitted: (_) {
                                FocusScope.of(context).nextFocus();
                              },
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Por favor, ingresa tu teléfono';
                                }
                                final phoneRegex = RegExp(r"^\d{10}$");
                                if (!phoneRegex.hasMatch(value)) {
                                  return 'Por favor, ingresa un teléfono válido de 10 dígitos';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 2.h),
                            // Tipo de Documento y Número de Documento
                            RoundedDropdownAndTextField<TypeDocument>(
                              dropdownHint: "Tipo de documento",
                              textFieldHint: "Número de documento",
                              totalWidth: 70.w,
                              dropdownItems: typesDocument,
                              dropdownItemAsString: (TypeDocument typeDoc) =>
                                  typeDoc.abrev,
                              onDropdownChanged: (TypeDocument? newType) {
                                setState(() {
                                  _selectedTypeDocument = newType;
                                });
                              },
                              onTextChanged: (String newText) {
                                // No es necesario asignar aquí, se usará el controlador
                              },
                              onTextSubmitted: (String submittedText) {
                                FocusScope.of(context).nextFocus();
                              },
                              initialDropdownValue: typesDocument[0],
                              textFieldController: _documentNumberController,
                              textFieldKeyboardType: TextInputType.number,
                              validator: (number) {
                                if (number == null || number.trim().isEmpty) {
                                  return 'Por favor, ingresa tu número de documento';
                                }
                                // Opcional: Validar formato según tipo de documento
                                return null;
                              },
                            ),
                            SizedBox(height: 2.h),
                            // Género
                            RoundedDropdown<Gender>(
                              hintText: "Selecciona género",
                              width: 70.w,
                              items: genders,
                              itemAsString: (Gender gen) => gen.name,
                              onChanged: (Gender? selectedGender) {
                                setState(() {
                                  _selectedGender = selectedGender;
                                });
                              },
                              initialValue: genders[0],
                              validator: (gender) {
                                if (gender == null) {
                                  return 'Por favor, selecciona tu género';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 2.h),
                            // Estado
                            ValueListenableBuilder(
                              valueListenable: statesNotifier,
                              builder: (context, states, _) {
                                if (states.isEmpty) {
                                  return const SizedBox();
                                }
                                return RoundedDropdown<Item>(
                                  hintText: "Selecciona un estado",
                                  width: 70.w,
                                  items: states,
                                  itemAsString: (Item state) => state.name!,
                                  onChanged: (Item? selectedState) async {
                                    setState(() {
                                      _selectedState = selectedState;
                                      _selectedCity = null;
                                    });
                                    if (selectedState != null) {
                                      cityNotifier.value =
                                          await item.getAllItemsStateAndCity(
                                              "info/municipality/department/${selectedState.codeDep}");
                                      if (cityNotifier.value.isNotEmpty) {
                                        setState(() {
                                          _selectedCity = cityNotifier.value[0];
                                        });
                                      }
                                    }
                                  },
                                  initialValue: _selectedState ?? states[0],
                                  validator: (state) {
                                    if (state == null) {
                                      return 'Por favor, selecciona un estado';
                                    }
                                    return null;
                                  },
                                );
                              },
                            ),
                            SizedBox(height: 2.h),
                            // Ciudad
                            ValueListenableBuilder(
                              valueListenable: cityNotifier,
                              builder: (context, cities, _) {
                                if (cities.isEmpty) {
                                  return const SizedBox();
                                }
                                return RoundedDropdown<Item>(
                                  hintText: "Selecciona una ciudad",
                                  width: 70.w,
                                  items: cities,
                                  itemAsString: (Item city) => city.name!,
                                  onChanged: (Item? selectedCity) {
                                    setState(() {
                                      _selectedCity = selectedCity;
                                    });
                                  },
                                  initialValue: _selectedCity ?? cities[0],
                                  validator: (city) {
                                    if (city == null) {
                                      return 'Por favor, selecciona una ciudad';
                                    }
                                    return null;
                                  },
                                );
                              },
                            ),
                            SizedBox(height: 2.h),
                            // Programa
                            ValueListenableBuilder(
                              valueListenable: programas,
                              builder: (context, programasList, _) {
                                if (programasList.isEmpty) {
                                  return const SizedBox();
                                }
                                return RoundedDropdown<Item>(
                                  hintText: "Selecciona el programa",
                                  width: 70.w,
                                  items: programasList,
                                  itemAsString: (Item program) =>
                                      program.shortName!,
                                  onChanged: (Item? selectedProgram) {
                                    setState(() {
                                      _selectedProgram = selectedProgram;
                                    });
                                  },
                                  initialValue:
                                      _selectedProgram ?? programasList[0],
                                  validator: (program) {
                                    if (program == null) {
                                      return 'Por favor, selecciona un programa';
                                    }
                                    return null;
                                  },
                                );
                              },
                            ),
                            SizedBox(height: 4.h),
                            // Botón de Ingreso
                            GradientButton(
                              text: 'Registrar',
                              onPressed: _submit,
                            ),
                            SizedBox(height: 2.h),
                            // Mensaje de Error
                            if (error != null)
                              GestureDetector(
                                onTap: () async {
                                  launchWhatsAppUri('+573183491375',
                                      'El usuario con el correo: ${_emailController.text.trim()}, tiene el siguiente error: $error');
                                },
                                child: Column(
                                  children: [
                                    CircleAvatar(
                                      backgroundColor: Colors.redAccent[100],
                                      child: const Icon(
                                        Icons.warning_amber_rounded,
                                        size: 25,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Text(
                                      "Si persiste este error informar aquí",
                                      style: TextStyle(
                                          color: Colors.redAccent[100]),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
