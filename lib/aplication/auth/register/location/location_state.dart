import 'package:equatable/equatable.dart';
import 'package:lexxi/domain/item_dynamic/model/item.dart';

enum LocationStatus {
  initial,
  loading,
  loaded,
  failure,
}

class LocationState extends Equatable {
  final LocationStatus status;
  final List<Item> departments;
  final List<Item> cities;
  final Item? selectedDepartment;
  final Item? selectedCity;
  final String? errorMessage;

  const LocationState({
    this.status = LocationStatus.initial,
    this.departments = const [],
    this.cities = const [],
    this.selectedDepartment,
    this.selectedCity,
    this.errorMessage,
  });

  bool get isLoading => status == LocationStatus.loading;

  LocationState copyWith({
    LocationStatus? status,
    List<Item>? departments,
    List<Item>? cities,
    Item? selectedDepartment,
    Item? selectedCity,
    String? errorMessage,
    bool clearSelectedDepartment = false,
    bool clearSelectedCity = false,
    bool clearError = false,
  }) {
    return LocationState(
      status: status ?? this.status,
      departments: departments ?? this.departments,
      cities: cities ?? this.cities,
      selectedDepartment: clearSelectedDepartment
          ? null
          : selectedDepartment ?? this.selectedDepartment,
      selectedCity: clearSelectedCity
          ? null
          : selectedCity ?? this.selectedCity,
      errorMessage:
          clearError ? null : errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        departments,
        cities,
        selectedDepartment,
        selectedCity,
        errorMessage,
      ];
}