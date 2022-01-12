const { expectRevert } = require('@openzeppelin/test-helpers');

const DFILEToken = artifacts.require('DFILEToken');
const ERC20Vesting = artifacts.require('ERC20Vesting');

contract('DFILEToken', async function ([_, w1, w2, w3]) {
    const BackersStaking = [20000, '0x0000000000000000000000000000000000000005']; // 20% Backers
    const Team = [10000, '0x0000000000000000000000000000000000000001']; // 10% at Team
    const Founder1 = [5000, '0x3d71e8a1a1038623a2def831abdf390897eb1d77']; // 5%
    const Founder2 = [5000, '0xe33aa2d42974479fc6497633c4b3064059d15f95']; // also 5%
    const advisors = [5000, '0x0000000000000000000000000000000000000002']; // also 5% for all Advisors
    const TreusuryAddress = '0x0000000000000000000000000000000000000003';

    var setShares = async (self) => {
        await self.token.addShares(BackersStaking[1], BackersStaking[0]);
        await self.token.addShares(Team[1], Team[0]);
        await self.token.addShares(Founder1[1], Founder1[0]);
        await self.token.addShares(Founder2[1], Founder2[0]);
        await self.token.addShares(advisors[1], advisors[0]);
    };

    beforeEach(async function () {
        this.token = await DFILEToken.new();
    });

    it('Shares is not zero', async function () {
        await expectRevert(this.token.smartMint(), 'Shares count = 0');
    });

    it('Treusury is filled', async function () {
        await setShares(this);
        await expectRevert(this.token.smartMint(), 'This year treasury not set!');
    });

    it('Smart mint', async function () {
        await setShares(this);
        await expectRevert(this.token.smartMint(), 'This year treasury not set!');
        await this.token.setTreasury(TreusuryAddress);
        var VestingAddress = await this.token.vestingOfYear(0);

        if (VestingAddress !== '0x0000000000000000000000000000000000000000') {
            throw new Error('Vesting address already set');
        }

        await this.token.smartMint();
        VestingAddress = await this.token.vestingOfYear(0);
        this.vestingOfThisYear = await ERC20Vesting.at(VestingAddress);

        const TreusuryBalance = await this.vestingOfThisYear.getAmountToWithdraw(TreusuryAddress);
        const VestingBalance = await this.token.balanceOf(this.vestingOfThisYear.address);

        if (VestingBalance.toString() === '0') {
            throw new Error('Vesting balance is zero');
        }
        if (TreusuryBalance.toString() !== '0') {
            throw new Error('Balance already have, but time not mined');
        }
    });
});