abstract class SearchStates {}

class SearchInitialState extends SearchStates {}

class SearchPeopleLoadingState extends SearchStates {}

class SearchPeopleSuccessState extends SearchStates {}

class SearchPeopleErrorState extends SearchStates {}

class SearchPostLoadingState extends SearchStates {}

class SearchPostSuccessState extends SearchStates {}

class SearchPostErrorState extends SearchStates {}

class ChangeSearchType extends SearchStates {}
