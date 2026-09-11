import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lexxi/aplication/auth/register/bloc/register_bloc.dart';
import 'package:lexxi/aplication/auth/register/bloc/register_event.dart';
import 'package:lexxi/aplication/auth/register/location/location_cubit.dart';
import 'package:lexxi/aplication/auth/register/location/location_state.dart';
import 'package:lexxi/domain/item_dynamic/model/item.dart';
import 'package:lexxi/injection.dart';
import 'package:lexxi/src/global/widgets/rounded_dropdown.dart';
import 'package:lexxi/src/pages/auth/signup/widgets/signup_step_scaffold.dart';

class SignupStep3Location extends StatelessWidget {
  const SignupStep3Location({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<LocationCubit>(),
      child: const _SignupStep3LocationView(),
    );
  }
}

class _SignupStep3LocationView extends StatefulWidget {
  const _SignupStep3LocationView();

  @override
  State<_SignupStep3LocationView> createState() =>
      _SignupStep3LocationViewState();
}

class _SignupStep3LocationViewState
    extends State<_SignupStep3LocationView> {

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final registerData =
          context.read<RegisterBloc>().state.data;

      context.read<LocationCubit>().loadLocation(
            savedDepartment: registerData.department,
            savedCity: registerData.city,
          );
    });
  }

  void _continue(
    BuildContext context,
    LocationState state,
  ) {
    if (state.selectedDepartment == null ||
        state.selectedCity == null) {
      context.read<LocationCubit>().setError(
            'Selecciona tu departamento y ciudad',
          );
      return;
    }

    context.read<RegisterBloc>().add(
          RegisterLocationSubmitted(
            department: state.selectedDepartment!,
            city: state.selectedCity!,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocationCubit, LocationState>(
      builder: (context, state) {
        return SignupStepScaffold(
          currentStep: 2,
          totalSteps: 6,
          imageAsset:
              'assets/signup/bruja-ubicacion.png',
          subtitle:
              '¿En qué ciudad te encuentras?',
          onContinue: () => _continue(
            context,
            state,
          ),
          onBack: () {
            context.read<RegisterBloc>().add(
                  const RegisterStepBack(),
                );
          },
          errorMessage: state.errorMessage,
          content: _buildContent(
            context,
            state,
          ),
        );
      },
    );
  }

  Widget _buildContent(
    BuildContext context,
    LocationState state,
  ) {
    if (state.isLoading) {
      return const Padding(
        padding: EdgeInsets.all(24),
        child: CircularProgressIndicator(
          color: Colors.white,
        ),
      );
    }

    if (state.status == LocationStatus.failure) {
      return const Padding(
        padding: EdgeInsets.all(24),
        child: Text(
          'No pudimos cargar la información.',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      );
    }

    return Column(
      children: [
        if (state.departments.isNotEmpty)
          RoundedDropdown<Item>(
            hintText:
                'Selecciona tu departamento',
            width: double.infinity,
            items: state.departments,
            itemAsString: (Item item) =>
                item.name ?? '',
            initialValue:
                state.selectedDepartment,
            onChanged: (Item? department) {
              if (department == null) {
                return;
              }

              context
                  .read<LocationCubit>()
                  .selectDepartment(
                    department,
                  );
            },
            validator: (_) => null,
          ),

        const SizedBox(height: 14),

        if (state.cities.isNotEmpty)
          RoundedDropdown<Item>(
            hintText:
                'Selecciona tu ciudad',
            width: double.infinity,
            items: state.cities,
            itemAsString: (Item item) =>
                item.name ?? '',
            initialValue:
                state.selectedCity,
            onChanged: (Item? city) {
              if (city == null) {
                return;
              }

              context
                  .read<LocationCubit>()
                  .selectCity(city);
            },
            validator: (_) => null,
          ),
      ],
    );
  }
}