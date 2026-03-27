const functions = require('firebase-functions');
const { messaging } = require('../config');

exports.sendDailyAyah = functions.pubsub
  .schedule('0 8 * * *')
  .timeZone('Etc/UTC')
  .onRun(async () => {
    const payload = {
      notification: {
        title: 'Daily Ayah',
        body: 'Open Noor and read your daily ayah.',
      },
      data: {
        type: 'daily_ayah',
      },
      topic: 'daily_ayah',
    };

    await messaging.send(payload);
    return null;
  });
