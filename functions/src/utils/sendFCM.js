const { messaging } = require('../config');

function chunk(items, size) {
  const output = [];
  for (let i = 0; i < items.length; i += size) {
    output.push(items.slice(i, i + size));
  }
  return output;
}

async function sendNotification(tokens, payload) {
  if (!Array.isArray(tokens) || tokens.length === 0) {
    return { successCount: 0, failureCount: 0, invalidTokens: [] };
  }

  const batches = chunk(tokens, 500);
  const result = {
    successCount: 0,
    failureCount: 0,
    invalidTokens: [],
  };

  for (const tokenBatch of batches) {
    const response = await messaging.sendEachForMulticast({
      tokens: tokenBatch,
      notification: payload.notification,
      data: payload.data || {},
    });

    result.successCount += response.successCount;
    result.failureCount += response.failureCount;

    response.responses.forEach((entry, index) => {
      if (!entry.success) {
        const code = entry.error?.code || '';
        if (
          code.includes('registration-token-not-registered') ||
          code.includes('invalid-registration-token')
        ) {
          result.invalidTokens.push(tokenBatch[index]);
        }
      }
    });
  }

  return result;
}

module.exports = {
  sendNotification,
};
