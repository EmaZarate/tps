import 'package:andina_protos/models/branch.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class ProfileEvent extends Equatable {
  ProfileEvent([List props = const []]) : super(props);
}

class FetchProfile extends ProfileEvent {}

class AddBranch extends ProfileEvent{
  final Branch branch;

  AddBranch({this.branch}): super([branch]);
}

class UpdateBranch extends ProfileEvent{
  final Branch branch;

  UpdateBranch({this.branch}): super([branch]);
}

class RemoveBranch extends ProfileEvent {
  final int branchId;

  RemoveBranch({this.branchId});
}

