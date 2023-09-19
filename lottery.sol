//SPDX-License-Identifier:MIT
pragma solidity ^0.8.18;

contract lotery {
    address public manager;
    address payable[] public players;

    constructor() {
        manager = msg.sender;
    }

    function alreadyEntered() private view returns (bool) {
        for (uint i = 0; i < players.length; i++) {
            if (players[i] == msg.sender) {
                return true;
            }
            return false;
        }
    }

    function enter() public payable {
        require(msg.sender != manager, "manager can not enter");
        require(alreadyEntered() == false, "player is already entered");
        require(msg.value >= 1 ether, "minimum value of entry is 1 ETH");
        players.push(payable(msg.sender));
    }

    function random() private view returns (uint) {
        return
            uint(
                sha256(
                    abi.encodePacked(block.difficulty, block.number, players)
                )
            );
    }

    function pickWinner() public {
        require(msg.sender == manager, "only manager can pick the winner");
        uint index = random() % players.length;
        address contractAddress = address(this);
        players[index].transfer(contractAddress.balance);
        players = new address payable[](0);
    }

    function getplayer() public view returns (address payable[] memory) {
        return players;
    }
}
