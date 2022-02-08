const WrappedNFT = artifacts.require('Wrapper');
const TokenMock = artifacts.require('TokenMock');
const ExampleNFT = artifacts.require('ExampleNFT');

contract('Wrapepr', async function ([_, w1, w2, w3]) {
    const treasuryWallet = w1;
    const GovernanceWallet = w2;

    beforeEach(async function () {
        this.token = await TokenMock.new('Terabyte/Years Token', 'TB/Year');
        this.ExampleNFT = await ExampleNFT.new('Examole', 'ENFT');
        this.WrappedContract = await WrappedNFT.new(this.token.address);
        await this.WrappedContract.changeGovernance(GovernanceWallet);
        await this.WrappedContract.unpause({ from: GovernanceWallet });
    });

    /**
     * @dev Make wrap 5 times
     */
    it('Wrap', async function () {
        let tokenId;
        
        for (let i = 0; i < 5; i = i + 1) {
            await this.ExampleNFT.mintMe({ from: treasuryWallet });
            tokenId = await this.ExampleNFT.counter();
            console.log('Token id:', tokenId.toString());
            
            // Approve to make wrap
            await this.ExampleNFT.approve(this.WrappedContract.address, parseInt(tokenId.toString()), { from: treasuryWallet });
            
            // Make it wrap
            await this.WrappedContract.wrap(
                this.ExampleNFT.address,
                tokenId,
                '0x7f83b1657ff1fc53b92dc18148a1d65dfc2d4b1fa3d677284addd200126d9069',
                'https://gateway.denet.pro/' + tokenId.toString(),
                1048576, { from: treasuryWallet });
        }
    });

    it('UnWrap', async function () {
        let tokenId;
        
        for (let i = 0; i < 5; i = i + 1) {
            await this.ExampleNFT.mintMe({ from: treasuryWallet });
            tokenId = await this.ExampleNFT.counter();
            console.log('Token id:', tokenId.toString());
            
            // Approve to make wrap
            await this.ExampleNFT.approve(this.WrappedContract.address, parseInt(tokenId.toString()), { from: treasuryWallet });
            
            // Make it wrap
            await this.WrappedContract.wrap(
                this.ExampleNFT.address,
                tokenId,
                '0x7f83b1657ff1fc53b92dc18148a1d65dfc2d4b1fa3d677284addd200126d9069',
                'https://gateway.denet.pro/' + tokenId.toString(),
                1048576, { from: treasuryWallet });
            
            const WrappedId = await this.WrappedContract.tokenOfOwnerByIndex(treasuryWallet, 0);
            await this.WrappedContract.unwrap(WrappedId, { from: treasuryWallet });
        }
    });
});