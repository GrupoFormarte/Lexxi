import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lexxi/aplication/auth/register/bloc/register_bloc.dart';
import 'package:lexxi/aplication/auth/register/bloc/register_event.dart';
import 'package:lexxi/aplication/item_dynamic/item_dynamic_use_case.dart';
import 'package:lexxi/domain/item_dynamic/model/item.dart';
import 'package:lexxi/injection.dart';
import 'package:lexxi/src/global/widgets/rounded_dropdown.dart';
import 'package:lexxi/src/pages/auth/signup/widgets/signup_step_scaffold.dart';
import 'package:lexxi/utils/loogers_custom.dart';

class SignupStep3Location extends StatefulWidget {
  const SignupStep3Location({super.key});

  @override
  State<SignupStep3Location> createState() => _SignupStep3LocationState();
}

class _SignupStep3LocationState extends State<SignupStep3Location> {
  final _item = getIt.get<ItemDynamicUseCase>();

  final ValueNotifier<List<Item>> _departmentsNotifier = ValueNotifier([]);
  final ValueNotifier<List<Item>> _citiesNotifier = ValueNotifier([]);

  Item? _selectedDepartment;
  Item? _selectedCity;
  bool _isLoadingDepartments = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    final data = context.read<RegisterBloc>().state.data;
    _selectedDepartment = data.department;
    _selectedCity = data.city;
    _loadDepartments();
  }

  Future<void> _loadDepartments() async {
    try {
      _departmentsNotifier.value = await _item.getAllItemsStateAndCity("");
      if (_selectedDepartment != null) {
        await _loadCities(_selectedDepartment!);
      }
    } catch (e) {
      logger.e("Error cargando departamentos: $e");
      setState(() => _error = 'No pudimos cargar los departamentos');
    } finally {
      if (mounted) setState(() => _isLoadingDepartments = false);
    }
  }

  Future<void> _loadCities(Item department) async {
    try {
      _citiesNotifier.value = await _item.getAllItemsStateAndCity(
        "${department.codeDep}/cities",
      );
    } catch (e) {
      logger.e("Error cargando ciudades: $e");
    }
  }

  void _continue() {
    if (_selectedDepartment == null || _selectedCity == null) {
      setState(() => _error = 'Selecciona tu departamento y ciudad');
      return;
    }
    setState(() => _error = null);
    context.read<RegisterBloc>().add(
      RegisterLocationSubmitted(
        department: _selectedDepartment!,
        city: _selectedCity!,
      ),
    );
  }

  @override
  void dispose() {
    _departmentsNotifier.dispose();
    _citiesNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SignupStepScaffold(
      currentStep: 2,
      totalSteps: 6,
      imageAsset: 'assets/signup/bruja-ubicacion.png',
      subtitle: '¿En qué ciudad te encuentras?',
      onContinue: _continue,
      onBack: () => context.read<RegisterBloc>().add(const RegisterStepBack()),
      errorMessage: _error,
      content: _isLoadingDepartments
          ? const Padding(
              padding: EdgeInsets.all(24.0),
              child: CircularProgressIndicator(color: Colors.white),
            )
          : Column(
              children: [
                ValueListenableBuilder<List<Item>>(
                  valueListenable: _departmentsNotifier,
                  builder: (context, departments, _) {
                    if (departments.isEmpty) return const SizedBox();
                    return RoundedDropdown<Item>(
                      hintText: "Selecciona tu departamento",
                      width: double.infinity,
                      items: departments,
                      itemAsString: (Item d) => d.name!,
                      initialValue: _selectedDepartment,
                      onChanged: (Item? department) async {
                        setState(() {
                          _selectedDepartment = department;
                          _selectedCity = null;
                        });
                        _citiesNotifier.value = [];
                        if (department != null) {
                          await _loadCities(department);
                        }
                      },
                      validator: (_) => null,
                    );
                  },
                ),
                const SizedBox(height: 14),
                ValueListenableBuilder<List<Item>>(
                  valueListenable: _citiesNotifier,
                  builder: (context, cities, _) {
                    if (cities.isEmpty) return const SizedBox();
                    return RoundedDropdown<Item>(
                      hintText: "Selecciona tu ciudad",
                      width: double.infinity,
                      items: cities,
                      itemAsString: (Item c) => c.name!,
                      initialValue: _selectedCity,
                      onChanged: (Item? city) {
                        setState(() => _selectedCity = city);
                      },
                      validator: (_) => null,
                    );
                  },
                ),
              ],
            ),
    );
  }
}
