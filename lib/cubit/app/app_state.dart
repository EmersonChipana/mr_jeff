class AppState {
	final bool isLoading;
	final String? error;
	  
	const AppState({
		this.isLoading = false,
		this.error,
	});
	  
	AppState copyWith({
		bool? isLoading,
		String? error,
	}) {
		return AppState(
			isLoading: isLoading ?? this.isLoading,
			error: error ?? this.error,
		);
	}
}
