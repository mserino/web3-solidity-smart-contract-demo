// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import "hardhat/console.sol";

contract SunflowerPortal {
	uint256 totalSunflowers;

	/**
	 * To generate a random number
	 */
	uint256 private seed;

	event NewSunflower(address indexed from, uint256 timestamp, string message);

	struct Sunflower {
		address waver; // The address of the user
		string message; // The message the user sent
		uint256 timestamp; // The timestamp when the user sent the message
	}

	Sunflower[] sunflowers;

	/**
	 * This is an address => uint mapping, meaning I can associate an address with a number.
	 * In this case, I'll be storing the address with the last time the user sent a sunflower
	 */
	mapping(address => uint256) public lastPlantedAt;

	constructor() payable {
		console.log("Yo yo, I am a contract and I am smart!");

		/**
		 * Set the initial seed
		 */
		seed = (block.timestamp + block.difficulty) % 100;
	}

	function plantSunflower(string memory _message) public {
		// We need to make sure the current timestamp is at least 15 minutes bigger than the last timestamp we stored
		require(
			lastPlantedAt[msg.sender] + 30 seconds < block.timestamp,
			"Must wait 30 seconds"
		);

		// Update the current timestamp we have for the user
		lastPlantedAt[msg.sender] = block.timestamp;

		totalSunflowers += 1;
		console.log("%s has planted a sunflower", msg.sender, _message);

		// Storing the sunflower data in the array
		sunflowers.push(Sunflower(msg.sender, _message, block.timestamp));

		// Generate a new seed for the next user that plants a sunflower
		seed = (block.difficulty + block.timestamp + seed) % 100;
		console.log("Random # generated: %d", seed);

		// Give 50% chance that the user wins the prize
		if (seed <= 50) {
			console.log("%s won!", msg.sender);

			uint256 prizeAmount = 0.0001 ether;
			require(
				prizeAmount <= address(this).balance,
				"Trying to withdraw more money than the contract has."
			);
			(bool success, ) = (msg.sender).call{value: prizeAmount}("");
			require(success, "Failed to withdraw money from contract.");
		}

		emit NewSunflower(msg.sender, block.timestamp, _message);
	}

	/**
	 * Function which will return the struct array, sunflowers, to us.
	 * This will make it easy to retrieve the sunflowers  from our website.
	 */
	function getAllSunflowers() public view returns (Sunflower[] memory) {
		return sunflowers;
	}

	function getTotalSunflowers() public view returns (uint256) {
		console.log("We have %d sunflowers!", totalSunflowers);
		return totalSunflowers;
	}
}