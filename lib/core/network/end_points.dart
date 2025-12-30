abstract class EndPoints {
  // static const baseUrl='https://flyeasy.io/api/v1/';
  static const baseUrl='https://flyeasy.wwdigi.it/api/v1/';

  static const login = 'login';
  static const register = 'register';
  static const verifyOtp = 'otp/verify';
  static const forgetPassword = 'forgot-password';
  static const resendOtp = 'otp/resend';
  static const changePassword = 'change-password';

  static const adminChannels = 'channels/users/admin';
  static const guestChannels = 'channels/users/joined';
  static const archivedChannels = 'channels/users/archived';

  static const members = 'users/without-authenticated';

  static const deleteChannel = 'channels/delete';
  static const createChannel = 'channels/store';
  static const updateChannel = 'channels/update';
  static const archiveChannel = 'channels/archive';
  static const duplicateChannel = 'channels/duplicate';
  static const channelDetails = 'channels/show';
  static const leaveChannel = 'channels/users/delete';

  static const plans = 'plans/all';
  static const selectPlan = 'plans/users/select';

  static const updateUserData = 'profile/data/update';
  static const updateUserImage = 'profile/image/update';
  static const updateUserPassword = 'profile/password/update';
  static const logout = 'profile/logout';
  static const deleteAccount='deleteaccount';

  static const myContacts = 'channels/members';
  static const allTeams = 'channels/authenticateJoined';

  static const allLibrarySections = 'library/sections/all';
  static const sectionFiles = 'library/sections/files/get';

  static const forwardMessage = 'channels/users/forward';
  static const recentChats = 'channels/users/chats/recent';
  static const deleteRecentChat = 'channels/users/deletechat';

  static const sendUserNotification = 'notification/user-notification';
  static const sendTeamNotification = 'notification/chanel-notification';
  static const notifications = 'notification/notifications';
  static const clearUserNotification = 'notification/reset-user-notification';
  static const clearTeamNotification = 'notification/reset-chanel-notification';
  static const deleteNotification = 'notification/delete-notification';
  static const notificationsCount = 'notification/notificationCounter';
  static const resetNotificationsCount = 'notification/resetnotification';
}
