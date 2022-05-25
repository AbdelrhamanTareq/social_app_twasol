abstract class FollowStates {}

class FollowInitialState extends FollowStates {}

class FollowUserChangeButtuonState extends FollowStates {}

class FollowUserSuccesState extends FollowStates {}

class UnFollowUserSuccesState extends FollowStates {}

class FollowUserErrorState extends FollowStates {}

class GetFollowCountSuccesState extends FollowStates {}

class GetFollowCountErrorState extends FollowStates {}
