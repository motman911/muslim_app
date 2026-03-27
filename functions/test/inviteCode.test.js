const { generateInviteCode } = require('../src/utils/inviteCode');

describe('generateInviteCode', () => {
  it('creates an 8-char code by default', () => {
    const code = generateInviteCode();
    expect(code).toHaveLength(8);
  });

  it('uses only allowed chars', () => {
    const code = generateInviteCode(16);
    expect(code).toMatch(/^[ABCDEFGHJKLMNPQRSTUVWXYZ23456789]+$/);
  });
});
