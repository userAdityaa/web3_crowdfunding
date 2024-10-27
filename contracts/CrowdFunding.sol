// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

contract CrowdFunding {
    struct Campaign {
        address owner;
        string title;
        string description;
        uint256 target;
        uint256 deadline;
        uint256 amountCollected;
        string image;
        address[] donators;
        uint256[] donations;
    }
    mapping(uint256 => Campaign) public campaigns;
    uint256 public numberOfCampaigns = 0;

    function createCampaign(
        address _owner,
        string memory _title,
        string memory _description,
        uint256 _deadline,
        uint256 _target,
        string memory _image
    ) public returns (uint256) {
        Campaign storage campaign = campaigns[numberOfCampaigns];
        require(
            campaign.deadling < block.timestamp,
            "Deadline must be in the future"
        );
        campaign.owner = _owner;
        campaign.title = _title;
        campaign.description = _description;
        campaign.deadline = _deadline;
        campaign.target = _target;
        campaign.image = _image;
        numberOfCampaigns++;
        return numberOfCampaigns - 1;
    }

    function donateToCampagin(uint256 _id) public payable {
        uint256 amount = msg.value;
        Campaign storage campaign = campaigns[_id];
        require(
            campaign.deadline > block.timestamp,
            "Campaign is no longer accepting donations"
        );
        campaign.donators.push(msg.sender);
        campaign.donations.push(amount);;
        (bool sent, ) = payable(campaign.owner).call{value: amount}("");
        if (sent) {
            campaign.amountCollected += amount;
        }
    }

    function getDonators(uint256 _id) public view returns(address[] memory, uint256[] memory) {
        return campaigns[_id].donators, campaigns[_id].donations;
    }

    function getCampaing() public view returns(Campaign[] memory) { 
        Campaign[] memory allCampaign = new Campaign[](numberOfCampaigns);
        for(uint256 i = 0; i < numberOfCampaigns; i++) {
            Campaign storage campaign = campaigns[i];
            allCampaign[i] = campaign; 
        }
        return allCampaign;
    }
}
