abstract class AuthStates {}

class AuthInitialState extends AuthStates {}

class AuthSignUpWithGoogleLoadingState extends AuthStates {}

class AuthSignUpWithGoogleSuccessState extends AuthStates {}

class AuthSignUpWithGoogleErrorState extends AuthStates {}

class AuthSignUpWithFacebookLoadingState extends AuthStates {}

class AuthSignUpWithFacebookSuccessState extends AuthStates {}

class AuthSignUpWithFacebookErrorState extends AuthStates {}

class AuthSignUpWithEmailAndPassLoadingState extends AuthStates {}

class AuthSignUpWithEmailAndPassSuccessState extends AuthStates {}

class AuthSignUpWithEmailAndPassErrorState extends AuthStates {}

class AuthSignInWithEmailAndPassLoadingState extends AuthStates {}

class AuthSignInWithEmailAndPassSuccessState extends AuthStates {}

class AuthSignInWithEmailAndPassErrorState extends AuthStates {}

class UpdateUserDataLoadingState extends AuthStates {}

class UpdateUserDataSuccessState extends AuthStates {}

class UpdateUserDataErrorState extends AuthStates {}

class GetImageSuccessState extends AuthStates {}

class GetImageErrorState extends AuthStates {}
