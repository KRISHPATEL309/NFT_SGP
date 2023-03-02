// SPDX-License-Identifier: MIT
pragma solidity ^0.8.12;

contract NFTContract {
    string public constant name = "NFTpro";
    string public constant symbol = "nFt";

    event Transfer(address indexed from, address indexed to, uint256 indexed tolenId);

    event Creat (
        address owner,
        uint256 nftid,
        uint256 genes
    );

    struct Nft {
        uint256 genes;
        uint64 creattime;
        uint16 generation;
    }

    Nft[] nfts;
    
    mapping(uint256 => address) public nftIndexToOwner;
    mapping(address => uint256) ownershipTokenCount;
    mapping(address => uint256[]) ownerToNfts;

    function balancOf(address owner) external view returns(uint256 balance){
        return ownershipTokenCount[owner];
    }

    function totalSupply() public view returns (uint) {
        return nfts.length;
    }
    
    function ownerOf(uint256 _tokenId) external view returns (address) {
        return nftIndexToOwner[_tokenId];
    }

    function getAllNftsFor(address _owner) external view returns(uint[] memory) {
        return ownerToNfts[_owner];
    }

    function _owns(address _claimant, uint256 _tokenId) internal view returns (bool){
        return nftIndexToOwner[_tokenId] == _claimant;
    }

    function transfer(address _to, uint256 _tokenId) external {
        require(_to != address(0));
        require(_to != address(this));
        require(_owns(msg.sender, _tokenId));

        _transfer(msg.sender, _to, _tokenId);
    }

    function _transfer(address _from, address _to, uint256 _tokenId) internal{
        ownershipTokenCount[_to]++;
        nftIndexToOwner[_tokenId] = _to;
        ownerToNfts[_to].push(_tokenId);
        if(_from != address(0)){
            ownershipTokenCount[_from]--;
            _removeTokenIdFromOwner(_from, _tokenId);
        }

        emit Transfer(_from, _to, _tokenId);
    }

    function _removeTokenIdFromOwner(address _owner, uint256 _tokenId) internal {
        
        uint256 lastId = ownerToNfts[_owner][ownerToNfts[_owner].length - 1];
        
        for(uint i = 0; i < ownerToNfts[_owner].length; i++){
            
            if (ownerToNfts[_owner][i]==_tokenId){
                ownerToNfts[_owner][i] = lastId;
                ownerToNfts[_owner].pop();
            }
        }
    }

    function _createNft(uint256 _genes) public returns (uint256){
        return _createNft(0,_genes,msg.sender);
    }

    function _createNft(uint256 _generation, uint256 _genes, address _owner) public returns (uint256){
        Nft memory _nft = Nft({ genes: _genes, creattime: uint64(block.timestamp),
        generation: uint16(_generation)
        });
        nfts.push(_nft);
        uint256 newNftId = nfts.length - 1;

        emit Creat(_owner, newNftId, _genes);

        _transfer(address(0), _owner, newNftId);

        return newNftId;
    }
    
    }