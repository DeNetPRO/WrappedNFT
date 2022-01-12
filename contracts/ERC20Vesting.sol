// SPDX-License-Identifier: MIT
/*
    Created by DeNet

    DeMet Vesting.

    This is last year supply vesting with one year.
*/

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract ERC20Vesting  is Ownable {
    using SafeMath for uint256;
    using SafeMath for uint64;

    address public vestingToken;

    constructor (address _token) {
        vestingToken = _token;
    }

    struct VestingProfile {
        uint64 timeStart;
        uint64 timeEnd;
        uint256 amount;
        uint256 payed;
    }
    

    mapping (address => VestingProfile) public vestingStatus;
    
    /*
        Creating vesting for _user
    */
    function createVesting(address _user,  uint64 timeStart, uint64 timeEnd, uint256 amount) public onlyOwner {
        require(_user != address(0), "Address = 0");
        require(vestingStatus[_user].timeStart == 0, "User already have vesting");
        require(amount != 0, "Amount = 0");
        require(timeStart < timeEnd, "TimeStart > TimeEnd");
        require(timeEnd > block.timestamp, "Time end < block.timestamp");

        vestingStatus[_user] = VestingProfile(timeStart, timeEnd, amount, 0);
    }

    /* 
        Return abaialble balance to withdraw
    */
    function getAmountToWithdraw(address _user) public view returns(uint256) {
        VestingProfile memory _tmpProfile = vestingStatus[_user];

        if (_tmpProfile.timeStart < block.timestamp) {
            return 0;
        }
        uint _vestingPeriod = _tmpProfile.timeEnd.sub(_tmpProfile.timeStart);
        uint _amount = _tmpProfile.amount.div(_vestingPeriod);
        if (_tmpProfile.timeEnd > block.timestamp) {
            _amount = _amount.mul(block.timestamp.sub(_tmpProfile.timeStart));
        } else {
            _amount = _tmpProfile.amount;
        }
        return _amount.sub(_tmpProfile.payed);
    }

    /*
        Withdraw tokens
    */
    function withdraw() public {
        uint _amount = getAmountToWithdraw(msg.sender);
        vestingStatus[msg.sender].payed = vestingStatus[msg.sender].payed.add(_amount);

        IERC20 tok = IERC20(vestingToken);
        tok.transfer(msg.sender, _amount);
    }

}