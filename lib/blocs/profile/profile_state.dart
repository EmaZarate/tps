import 'package:andina_protos/models/customer.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class ProfileState extends Equatable {
  ProfileState([List props = const []]) : super(props);
}

class ProfileUnloaded extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final Customer customer;

  ProfileLoaded({@required this.customer}) : super([customer]);
}

class ProfileLoading extends ProfileState {}