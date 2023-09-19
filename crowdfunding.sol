////SPDX-License-Identifier:MIT

pragma solidity ^0.8.18;

contract crowdfunding {
    address public owner;
    mapping(address => uint) public funders;
    uint public goal;
    uint public minamount;
    uint public noOFfunders;
    uint public fundRaised;
    uint public timePeriod; //timestamp

    constructor(uint _goal, uint _time) {
        goal = _goal;
        timePeriod = block.timestamp + _time;
        owner = msg.sender;
        minamount = 100 wei;
    }

    function contribution() public payable {
        require(block.timestamp < timePeriod, "time of funding is over");
        require(msg.value >= minamount, "min amount is 1000 wei");

        if (funders[msg.sender] == 0) {
            noOFfunders++;
        }

        funders[msg.sender] += msg.value;
        fundRaised += msg.value;
    }

    receive() external payable {
        contribution;
    }

    function getrefund() public {
        require(block.timestamp > timePeriod, "funding is still on");
        require(fundRaised < goal, "funding is successful");
        require(funders[msg.sender] > 0, "you are not a funder");

        payable(msg.sender).transfer(funders[msg.sender]);
        fundRaised -= funders[msg.sender];
        funders[msg.sender] = 0;
    }

    struct Requests {
        uint amount;
        string description;
        address payable receiver;
        uint NOofvoters;
        mapping(address => bool) votes;
        bool completed;
    }
    mapping(uint => Request) public AllRequest;
    uint public numReq;

    function createreq(
        string memory _description,
        uint _amount,
        address payable _receiver
    ) public {
        require(msg.sender == owner, "you are not owner");
        Requests storage newRequest = AllRequest[numReq];
        numReq++;

        newrequest.description = _description;
        newrequest.amount = _amount;
        newrequest.receiver = _receiver;
        newrequest.completed = false;
        newrequest.NOofvoters = 0;
    }

    function votingforreq(uint reqnum) public {
        require(funders[msg.sender] > 0, "not a funder");
        Requests storage thisRequest = AllRequest[reqnum];

        require(thisRequest.votes[msg.sender] == false, "already  voted");
        thisRequest.vote[msg.sender] == true;
        thisRequest.NOofvoters++;
    }

    function makepayment(uint reqnum) public {
        Requests storage thisRequest = AllRequest[reqnum];
        require(thisRequest.complete == false, "voting is already done");
        require(
            thisRequest.NOofvoters >= noOFfunders / 2,
            "voting is not favour"
        );

        thisRequest.receiver.transfer(thisRequest.amount);
        thisRequiest.complete = true;
    }
}
