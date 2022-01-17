// SPDX-License-Identifier: MIT
/*
    Created by DeNet

    (DFILE) is  DeNet File Token contract
*/

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "./ERC20Vesting.sol";
import "./interfaces/ISmartStaking.sol";

contract ContractRoles is Ownable {

    address private _smartStaking;

    function smartStaking() public view virtual returns (address) {
        return _smartStaking;
    }

    function setSmartStaking(address _newSS) public virtual onlyOwner {
        require(_newSS != address(0), "CR: zero address");
        _smartStaking = _newSS;
    }

    /**
     * @dev Throws if called by any account other than the Smart Staking.
     */
    modifier onlySmartStaking() {
        require(owner() == _msgSender(), "CR: caller is not the SS");
        _;
    }
}

contract Shares {
    using SafeMath for uint256;
    uint public tenYearsSupply = 1000000000000000000000000000;
    uint public currentSupply = 0;
    uint public thisYearSupply = 0;
    uint public timeNextYear = 0;
    uint public currentYear = 0;

    address public treasury = address(0);

    /**
    * @dev Supply of year's inside array
    */
    uint[10] public supplyOfYear = [
        145000000000000000000000000,
        128000000000000000000000000,
        121000000000000000000000000,
        112000000000000000000000000,
        104000000000000000000000000,
        95000000000000000000000000,
        87000000000000000000000000,
        79000000000000000000000000,
        71000000000000000000000000, 
        58000000000000000000000000
    ];

    /**
    * @dev Vesting contract addresses
    */
    address[10] public vestingOfYear;

    /**
    * @dev Divider of 100% for shares calculating (ex: 100000 = 100%)
    */
    uint public constant sharesRatio =  100000;

    mapping (address => uint) public shares;
    mapping (uint32 => address) public sharesVector;
    uint32 public sharesCount = 0;
    uint public sharesAvailable = sharesRatio;

    /**
    * @dev add shares for _reciever (can be contract)
    */
    function _addShares(address _reciever, uint _size) internal {
        require(sharesAvailable.sub(_size) > 0, "Shares: Wrong size");
        require(_size > 0, "Shares: Size < 0");

        if (shares[_reciever] == 0) {
            sharesVector[sharesCount] = _reciever;
            sharesCount = sharesCount + 1;
        }
        
        shares[_reciever] = shares[_reciever].add(_size);
        sharesAvailable = sharesAvailable.sub(_size);
    }

    /**
    * @dev remove shares for _reciever (can be contract)
    */
    function _removeShares(address _reciever, uint _size) internal  {
        require(shares[_reciever].sub(_size) >= 0, "Shares: Shares < _size");
        shares[_reciever] = shares[_reciever].sub(_size);
        sharesAvailable = sharesAvailable.add(_size);
    }

}

contract DFILEToken is ERC20, Shares, ContractRoles {
    using SafeMath for uint256;

    constructor () ERC20("DeNet FIle Token", "DFILE") {
        _mint(address(this), tenYearsSupply);
    }

    function addShares(address _reciever, uint _size) public onlyOwner {
        _addShares(_reciever, _size);
    }

    function removeShares(address _reciever, uint _size) public onlyOwner  {
       _removeShares(_reciever, _size);
    }

    /*
        @dev Minting year supply with shares and vesting
        
    */
    function smartMint() public onlyOwner {
        require(block.timestamp > timeNextYear, "Main: Time is not available");
        require(sharesCount > 0, "Main: Shares count = 0");
        uint _amount = supplyOfYear[currentYear];
        require(currentSupply.add(_amount) <= tenYearsSupply, "Main: amount > available");
        uint transfered = 0;
        ERC20Vesting theVesting = new ERC20Vesting(address(this));
        vestingOfYear[currentYear] = address(theVesting);
        IERC20 thisToken = IERC20(address(this));
        thisToken.transfer(address(theVesting), _amount);

        for (uint32 i = 0; i < sharesCount; i = i + 1) {
            uint sendAmount = _amount.mul(shares[sharesVector[i]]).div(sharesRatio);
            theVesting.createVesting(sharesVector[i], uint64(block.timestamp), uint64(block.timestamp + 31536000), sendAmount);
            transfered = transfered.add(sendAmount);
        }

        require(treasury != address(0), "Main: This year treasury not set!");
        uint _treasuryAmount = _amount.sub(transfered);
        theVesting.createVesting(treasury, uint64(block.timestamp), uint64(block.timestamp + 31536000), _treasuryAmount);
        
        transfered = transfered.add(_treasuryAmount);
        /*
            Make for next year
                1. reset treasury address
                2. nextTime + 365 days
                3. currentYear++
        */
        treasury = address(0);
        timeNextYear = block.timestamp + 31536000; // move next year;
        currentYear = currentYear + 1;
    }

    function setTreasury(address _new) public onlyOwner {
        require(_new != address(0), "Main: _new = zero");
        require(_new != address(this), "Main: _new = this");

        treasury = _new;
    }

    /* Smart Staking Part */
    mapping (address => bool) isSmartStaking;

    function addToSmartStaking(address _holder) public onlySmartStaking {
        require(_holder != address(0), "SS: holder = 0x0");
        require(isSmartStaking[_holder] == false, "SS: holder already in SS");
        
        isSmartStaking[_holder] = true;
    }

    function removeFromSmartStaking(address _holder) public onlySmartStaking {
        require(isSmartStaking[_holder] == true, "SS: holder is not in SS");

        isSmartStaking[_holder] = false;
    }

    function _afterTokenTransfer(
        address from,
        address to,
        uint256 amount
    ) internal virtual override {
        if (isSmartStaking[from]) {
            ISmartStaking _iss = ISmartStaking(smartStaking());
            _iss.changeBalance(from, balanceOf(from));
            uint8 _holderStatus = _iss.getHolderStatus(from);
            
            // removing from stating
            if (_holderStatus == 2) {
                isSmartStaking[from] = false;
            }
        }
    }
}