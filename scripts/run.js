const main = async () => {
	const sunflowerContractFactory = await hre.ethers.getContractFactory("SunflowerPortal");
	const sunflowerContract = await sunflowerContractFactory.deploy({
		value: hre.ethers.utils.parseEther("0.1"),
	});
	await sunflowerContract.deployed();
	console.log("Contract addy:", sunflowerContract.address);

	/**
	 * Get contract balance
	 */
	let contractBalance = await hre.ethers.provider.getBalance( sunflowerContract.address );
	console.log(
		"Contract balance: ",
		hre.ethers.utils.formatEther(contractBalance)
	);
		
	/**
	 * Get total count
	 */
	let sunflowerCount;
	sunflowerCount = await sunflowerContract.getTotalSunflowers();
	console.log(sunflowerCount.toNumber());

	/**
	 * Send sunflower
	 */
	let sunflowerTxn = await sunflowerContract.plantSunflower("Plant sunflower #1");
	await sunflowerTxn.wait();  // Wait for the transaction to be mined

	let sunflowerTxn2 = await sunflowerContract.plantSunflower("Plant sunflower #1");
	await sunflowerTxn2.wait();  // Wait for the transaction to be mined

	// const [_, randomPerson] = await hre.ethers.getSigners();
	// sunflowerTxn = await sunflowerContract.connect(randomPerson).plantSunflower("Another message");

	// await sunflowerTxn.wait();

	/**
	 * Get contract balance to see what happened
	 */
	contractBalance = await hre.ethers.provider.getBalance( sunflowerContract.address );
	console.log(
		"Contract balance: ",
		hre.ethers.utils.formatEther( contractBalance )
	);

	/**
	 * Get total sunflowers
	 */
	let allSunflowers = await sunflowerContract.getAllSunflowers();
	console.log('All Sunflowers', allSunflowers);
};

const runMain = async () => {
	try {
		await main();
		process.exit(0); // exit Node process without error
	} catch (error) {
		console.log(error);
		process.exit(1); // exit Node process while indicating 'Uncaught Fatal Exception' error
	}
};

runMain();
