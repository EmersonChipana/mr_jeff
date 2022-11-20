import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mr_jeff/cubit/app/app_state.dart';

class AppCubit extends Cubit<AppState> {
	AppCubit() : super(AppState(isLoading: true));
	
	Future<void> loadInitialData() async {
		final stableState = state;
		try {
		  emit(state.copyWith(isLoading: true));
	
		  // TODO your code here
	
		  emit(state.copyWith(isLoading: false));
		} catch (error) {
		  emit(state.copyWith(error: error.toString()));
		  emit(stableState.copyWith(isLoading: false));
		}
	}
}
