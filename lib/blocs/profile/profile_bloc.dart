import 'package:andina_protos/blocs/profile/profile_event.dart';
import 'package:andina_protos/blocs/profile/profile_state.dart';
import 'package:andina_protos/models/customer.dart';
import 'package:andina_protos/repositories/customer.repository.dart';
import 'package:bloc/bloc.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final CustomerRepository customerRepository;

  ProfileBloc({this.customerRepository}) : assert(customerRepository != null);

  @override
  ProfileState get initialState => ProfileUnloaded();

  @override
  Stream<ProfileState> mapEventToState(
    ProfileEvent event,
  ) async* {
    if (event is FetchProfile) {
      final Customer customerLogged = await customerRepository.getUser();
      yield ProfileLoaded(customer: customerLogged);
    }

    if (event is AddBranch) {
      final String customerLoggedId =
          (currentState as ProfileLoaded).customer.id;
      await customerRepository.addBranch(customerLoggedId, event.branch);
      yield ProfileLoading();
      final Customer customerUpdated =
          await _updateProfileStored(customerLoggedId);
      yield ProfileLoaded(customer: customerUpdated);
    }

    if (event is UpdateBranch) {
      final String customerLoggedId =
          (currentState as ProfileLoaded).customer.id;
      await customerRepository.updateBranch(customerLoggedId, event.branch);
      yield ProfileLoading();
      final Customer customerUpdated =
          await _updateProfileStored(customerLoggedId);
      yield ProfileLoaded(customer: customerUpdated);
    }

    if (event is RemoveBranch) {
      final String customerLoggedId =
          (currentState as ProfileLoaded).customer.id;
      await customerRepository.removeBranch(customerLoggedId, event.branchId);
      yield ProfileLoading();
      final Customer customerUpdated =
          await _updateProfileStored(customerLoggedId);
      yield ProfileLoaded(customer: customerUpdated);
    }
  }

  Future<Customer> _updateProfileStored(String customerId) async {
    final Customer customerUpdated =
        await customerRepository.getMe(id: customerId);
    await customerRepository.deleteUser();
    await customerRepository.persistUser(customerUpdated);

    return customerUpdated;
  }
}
