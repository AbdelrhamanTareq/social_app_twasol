abstract class PostsStates {}

class PostsInitialState extends PostsStates {}

class GetPostsLoadingState extends PostsStates {}

class GetPostsSuccessState extends PostsStates {}

class GetPostsErorrState extends PostsStates {}

// class GetPostsOwnerLoadingState extends PostsStates {}

// class GetPostsOwnerSuccessState extends PostsStates {}

// class GetPostsOwnerErrorState extends PostsStates {}

class AddPostsLoadingState extends PostsStates {}

class AddPostsSuccessState extends PostsStates {}

class AddPostsErrorState extends PostsStates {}

class PickImageSuccesState extends PostsStates {}

class PickImageErrorState extends PostsStates {}

// class AddLikeLoadingState extends PostsStates {}

class AddLikeState extends PostsStates {}

class AddOrRemoveLikeErrorState extends PostsStates {}

class RemoveLikeState extends PostsStates {}

// class RemoveLikeErrorState extends PostsStates {}

class GetPostOwnerDataLoadingState extends PostsStates {}

class GetPostOwnerDataSuccessState extends PostsStates {}

class GetPostOwnerDataErrorState extends PostsStates {}

class GetPostOwnerPostsLoadingState extends PostsStates {}

class GetPostOwnerPostsSuccessState extends PostsStates {}

class GetPostOwnerPostsErrorState extends PostsStates {}
