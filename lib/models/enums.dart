/// Friend status
enum FriendStatus { active, pending, declined, blocked, inactive, requested }

/// Authentication state
enum AuthenticationState {
  unauthenticated,
  authenticated,
  loading,
  missingInfo
}
