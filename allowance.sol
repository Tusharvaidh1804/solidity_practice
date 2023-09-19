//SPDX-License-Identifier:MIT

pragma solidity ^0.8.18;

contract Allowance {
    receive() external payable {}

    function checkbal() public view returns (uint) {
        return address(this).balance;
    }

    mapping(address => uint) public allowance;
    address public owner;

    constructor() {
        owner = msg.sender;
    }

    function addallowance(address _to, uint _amt) public {
        require(owner == msg.sender, "not the owner");
        allowance[_to] += _amt;
    }

    function isowner() private view returns (bool) {
        return owner == msg.sender;
    }

    modifier owneriorallowance(uint amt) {
        require(isowner() || allowance[msg.sender] >= amt, "not a allowancer");
        _;
    }

    event sendmon(string description, address to, uint amt);

    function withdrawMoney(
        string memory _description,
        address payable _to,
        uint amt
    ) public owneriorallowance(amt) {
        require(address(this).balance >= amt, "balance is not enought");
        if (isowner() == false) {
            allowance[msg.sender] -= amt;
        }
        emit sendmon(_description, _to, amt);
        _to.transfer(amt);
    }

    function renounceOwnership() public pure {
        revert("can not renounce owner!");
    }
}
