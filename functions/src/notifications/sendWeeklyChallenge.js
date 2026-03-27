const functions = require('firebase-functions');
const { messaging } = require('../config');

exports.sendWeeklyChallenge = functions.pubsub
  .schedule('0 10 * * 0')
  .timeZone('Etc/UTC')
  .onRun(async () => {
    await messaging.send({
      notification: {
        title: 'Weekly challenge started',
        body: 'Open Noor and join this week challenge.',
      },
      data: {
        type: 'weekly_challenge',
      },
      topic: 'weekly_challenge',
    });

    return null;
  });
