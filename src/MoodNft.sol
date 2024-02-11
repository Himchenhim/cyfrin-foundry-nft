// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

import {ERC721} from "lib/openzeppelin-contracts/contracts/token/ERC721/ERC721.sol";
import {Base64} from "lib/openzeppelin-contracts/contracts/utils/Base64.sol";

import {console} from "../lib/forge-std/src/Test.sol";

contract MoodNft is ERC721 {
    // errors
    error MoodNft__CantFlipMoodIfNotOwner();

    uint256 private s_tokenCounter;
    string private s_sadSvgImageUri;
    string private s_happySvgImageUri;

    enum NftState {
        HAPPY,
        SAD
    }
    mapping(uint256 => NftState) private s_tokenIdToMood;

    constructor(
        string memory sadSvgImageUri,
        string memory happySvgImageUri
    ) ERC721("Mood NFT", "MN") {
        s_sadSvgImageUri = sadSvgImageUri;
        s_happySvgImageUri = happySvgImageUri;
    }

    function mintNft() public {
        _safeMint(msg.sender, s_tokenCounter);
        s_tokenIdToMood[s_tokenCounter] = NftState.HAPPY;
        ++s_tokenCounter;
    }

    function _baseURI() internal pure override returns (string memory) {
        return "data:application/json;base64,";
    }

    function flipMood(uint256 tokenId) public {
        // only want the NFT owner to be able to change the mood
        if (!_isAuthorized(_ownerOf(tokenId), msg.sender, tokenId)) {
            revert MoodNft__CantFlipMoodIfNotOwner();
        }

        if (s_tokenIdToMood[tokenId] == NftState.HAPPY) {
            s_tokenIdToMood[tokenId] = NftState.SAD;
        } else {
            s_tokenIdToMood[tokenId] = NftState.HAPPY;
        }
    }

    function tokenURI(
        uint256 tokenId
    ) public view override returns (string memory) {
        string memory imageURI;
        if (s_tokenIdToMood[tokenId] == NftState.HAPPY) {
            imageURI = s_happySvgImageUri;
        } else {
            imageURI = s_sadSvgImageUri;
        }

        // because we want to encode this data to base64 -> we need to:
        // 1. packed them
        // 2. convert them to "dynamic bytes"
        // 3. encode to base64
        // string memory tokenMetadata = string.concat(
        //     '{"name": "',
        //     name(),
        //     '", ',
        //     '"description": "An NFT that reflects the owners mood.", "attributes": [{"trait_type":"moodiness","value":100}], "image": "',
        //     imageURI,
        //     '"}'
        // );
        return
            string(
                abi.encodePacked(
                    _baseURI(),
                    Base64.encode(
                        bytes(
                            abi.encodePacked(
                                // NOTE: it is really importand to delete useless spaces
                                '{"name": "',
                                name(),
                                '", "description": "An NFT that reflects the owners mood. 100% on Chain!", ',
                                '"attributes": [{"trait_type":"moodiness","value":100}], "image":"',
                                imageURI,
                                '"}'
                            )
                        )
                    )
                )
            );
    }
}
