// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

contract SupplyChain {
    uint32 public p_id = 0;
    uint32 public u_id = 0;
    uint32 public r_id = 0;

    struct product {
        string modelNumber;
        string partNumber;
        string serialNumber;
        address productOwner;
        uint32 cost;
        uint32 mfgTimeStamp;
    }

    mapping (uint32 => product) public products;

    struct participant {
        string userName;
        string password;
        string participantType;
        address participantAddress;
    }

    mapping (uint32 => participant) public participants;

    struct registration {
        uint32 productId;
        uint32 ownerId;
        uint32 trxTimeStamp;
        address productOwner;
    }

    mapping (uint32 => registration) public registrations; // registrations by r_id
    mapping (uint32 => uint32[]) public productTrack; // registrations by p_id

    event Transfer(uint32 indexed prodId);

    function createParticipant(
        string memory pName, 
        string memory pPass, 
        string memory pType, 
        address pAdd) public returns (uint32) {

        uint32 userId = u_id++;

        participants[userId].userName = pName;
        participants[userId].password = pPass;
        participants[userId].participantType = pType;
        participants[userId].participantAddress = pAdd;

        return userId;
    }

    function getParticipantDetails(uint32 pId) public view returns (string memory, address, string memory) {
        return (
            participants[pId].userName, 
            participants[pId].participantAddress, 
            participants[pId].participantType
        );
    }

    function createProduct(
        uint32 participantId, 
        string memory pModelNum, 
        string memory pPartNum, 
        string memory pSerialNum, 
        uint32 pCost) public returns (uint32) {

        if (keccak256(abi.encodePacked(participants[participantId].participantType)) == keccak256("Manufacturer")) {
            uint32 prodId = p_id++;

            products[prodId].modelNumber = pModelNum;
            products[prodId].partNumber = pPartNum;
            products[prodId].serialNumber = pSerialNum;
            products[prodId].productOwner = participants[participantId].participantAddress;
            products[prodId].cost = pCost;
            products[prodId].mfgTimeStamp = uint32(block.timestamp);

            return prodId;
        }
        
        return 0;
    }

    function getProductDetails(uint32 prodId) public view returns (string memory, string memory, string memory, uint32, address, uint32) {
        return (
            products[prodId].modelNumber, 
            products[prodId].partNumber, 
            products[prodId].serialNumber, 
            products[prodId].cost, 
            products[prodId].productOwner, 
            products[prodId].mfgTimeStamp
        );
    }

    modifier onlyOwner(uint32 prodId) {
        require(msg.sender == products[prodId].productOwner);
        _;
    }

    function transferToParticipant(
        uint32 participantId,
        uint32 prodId) onlyOwner(prodId) public returns (bool) {
        
        participant memory p = participants[participantId];

        uint32 regId = r_id++;

        registrations[regId].productId = prodId;
        registrations[regId].productOwner = p.participantAddress;
        registrations[regId].ownerId = participantId;
        registrations[regId].trxTimeStamp = uint32(block.timestamp);

        products[prodId].productOwner = p.participantAddress;

        productTrack[prodId].push(regId);

        emit Transfer(prodId);

        return true;
    }

    function getProductTrack(uint32 prodId) external view returns (uint32[] memory) {
        return productTrack[prodId];
    }

    function getRegistrationDetails(uint32 regId) public view returns (uint32, uint32, address, uint32) {
        
        registration memory r = registrations[regId];

        return (r.productId, r.ownerId, r.productOwner, r.trxTimeStamp);
    }
}