const { onUserCreated } = require('./auth/onUserCreated');
const { onUserDeleted } = require('./auth/onUserDeleted');

const { onMemberJoined } = require('./social/onMemberJoined');
const { onNewMessage } = require('./social/onNewMessage');
const { onAchievementEarned } = require('./social/onAchievementEarned');
const { generateInviteCode } = require('./social/generateInviteCode');

const { sendDailyAyah } = require('./notifications/sendDailyAyah');
const { sendWeeklyChallenge } = require('./notifications/sendWeeklyChallenge');
const { sendInactivityReminder } = require('./notifications/sendInactivityReminder');
const { registerDeviceToken } = require('./notifications/registerDeviceToken');
const { removeDeviceToken } = require('./notifications/removeDeviceToken');

const { onGroupMemberWrite } = require('./stats/updateGroupStats');
const { calculateStreak } = require('./stats/calculateStreak');

module.exports = {
  onUserCreated,
  onUserDeleted,
  onMemberJoined,
  onNewMessage,
  onAchievementEarned,
  generateInviteCode,
  sendDailyAyah,
  sendWeeklyChallenge,
  sendInactivityReminder,
  registerDeviceToken,
  removeDeviceToken,
  onGroupMemberWrite,
  calculateStreak,
};
