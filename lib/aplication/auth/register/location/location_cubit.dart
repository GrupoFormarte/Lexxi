import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:lexxi/aplication/item_dynamic/item_dynamic_use_case.dart';
import 'package:lexxi/domain/item_dynamic/model/item.dart';
import 'package:lexxi/utils/loogers_custom.dart';

import 'location_state.dart';

@injectable
class LocationCubit extends Cubit<LocationState> {
  final ItemDynamicUseCase _itemDynamicUseCase;

  LocationCubit(this._itemDynamicUseCase)
      : super(const LocationState());

  Future<void> loadLocation({
    Item? savedDepartment,
    Item? savedCity,
  }) async {
    emit(
      state.copyWith(
        status: LocationStatus.loading,
        clearError: true,
      ),
    );

    try {
      final departments =
          await _itemDynamicUseCase.getAllItemsStateAndCity('');

      Item? selectedDepartment;

      if (savedDepartment != null) {
        selectedDepartment = _findDepartment(
          departments,
          savedDepartment,
        );
      }

      emit(
        state.copyWith(
          status: LocationStatus.loaded,
          departments: departments,
          selectedDepartment: selectedDepartment,
          cities: const [],
          clearSelectedDepartment:
              selectedDepartment == null,
          clearSelectedCity: true,
        ),
      );

      if (selectedDepartment != null) {
        await selectDepartment(
          selectedDepartment,
          savedCity: savedCity,
        );
      }
    } catch (e) {
      logger.e(
        'Error cargando departamentos: $e',
      );

      emit(
        state.copyWith(
          status: LocationStatus.failure,
          errorMessage:
              'No pudimos cargar los departamentos',
        ),
      );
    }
  }

  Future<void> selectDepartment(
    Item department, {
    Item? savedCity,
  }) async {
    emit(
      state.copyWith(
        selectedDepartment: department,
        cities: const [],
        clearSelectedCity: true,
        clearError: true,
      ),
    );

    try {
      final cities =
          await _itemDynamicUseCase.getAllItemsStateAndCity(
        '${department.codeDep}/cities',
      );

      Item? selectedCity;

      if (savedCity != null) {
        selectedCity = _findCity(
          cities,
          savedCity,
        );
      }

      emit(
        state.copyWith(
          cities: cities,
          selectedCity: selectedCity,
          clearSelectedCity: selectedCity == null,
        ),
      );
    } catch (e) {
      logger.e(
        'Error cargando ciudades: $e',
      );

      emit(
        state.copyWith(
          errorMessage:
              'No pudimos cargar las ciudades',
        ),
      );
    }
  }

  void selectCity(Item city) {
    emit(
      state.copyWith(
        selectedCity: city,
        clearError: true,
      ),
    );
  }

  void setError(String message) {
    emit(
      state.copyWith(
        errorMessage: message,
      ),
    );
  }

  void clearError() {
    emit(
      state.copyWith(
        clearError: true,
      ),
    );
  }

  Item? _findDepartment(
    List<Item> departments,
    Item savedDepartment,
  ) {
    for (final department in departments) {
      if (department.codeDep == savedDepartment.codeDep) {
        return department;
      }
    }

    return savedDepartment;
  }

  Item? _findCity(
    List<Item> cities,
    Item savedCity,
  ) {
    for (final city in cities) {
      if (city.code == savedCity.code) {
        return city;
      }
    }

    return savedCity;
  }
}