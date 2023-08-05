# CREATING A TOKEN ON LOCAL HARDHAT NETWORK

In this repository, a smart contract is written to create a token on local hardhat network and interact with the smart contract using remix IDE or any other ethereum IDE. 

This README file provides the steps necessary for deployment of the contract on local hardhat network using remix connect localhost and provides detailed explanation on the basic features of the project.

## Features

The following features ar provided by the Project:

- `Token.sol` contains the source code of the token.
- Token attributes like `name` , `symbol` and `totalSupply`.
- `tokenBalance` displayes the balance associated with a certain address.
- `mintToken` function is used to mint tokens to a address, restricted to be used only by owner.
- `burnToken` function is used to burn tokens from a address, no restriction on access.
- `transfer` function is used to transfer tokens from owner to receiver address, no restriction on access.
- `transferFrom` function is used to transfer tokens from sender(specified by user) to a receiver, no restriction on access.

Only the owner can use `mintToken` function whereas all other functions can be used by other users/addresses.

## Deployment on Local Hardhat Network

Follow these steps to deploy token on local hardhat network using local pc (here i have used VS Code)

1. Clone the repository and install its dependencies:

```
git clone https://github.com/Pawash97/Metacrafter_ETH_EVAX_Module3.git
cd Metacrafter_ETH_EVAX_Module3
npm install
```

2. Install the `@remix-project/remixd` dependency to connect Remix IDE:

```
npm install -g @remix-project/remixd
```

3. Run the following command in the terminal to connect Remix IDE to the Hardhat local host:

```
remixd -s ./ --remix-ide https://remix.ethereum.org
```

4. Open a new terminal and start Hardhat's testing network:

```
npx hardhat node
```

5. Open the [Remix](https://remix.ethereum.org/) online IDE in your browser.

6. Go to File Explorer -> Workspaces -> Connect to locahost and click confirm.

7. Rewrite the `Token.sol` file in the contracts directory with your own token code.

8. Compile the contract in the Remix IDE.

9. In the deploy section of Remix, select the environment as "Dev-Hardhat Provider".

10. Deploy your contract on the local Hardhat network using the deploy button in Remix.

11. Confirm the deployment transaction in Remix.

12. Once the contract is deployed, you will see the contract address in the Remix console. Make note of this address for future interactions.

## Interacting with the Contract using Remix with Hardhat Provider

-After the contract is deployed, Remix will display the deployed contract instance in the "Deployed Contracts" section.

-Expand the deployed contract instance to see the available functions and their input fields.

-You can now interact with the contract by calling its functions and providing the required inputs.
  
  -To mint tokens, call the mint function and provide the receiver's address and the desired amount.
  -To burn tokens, call the burn function and provide the amount to be burned.
  -To transfer tokens, call the transfer function and provide the receiver's address and the amount to be transferred.

After providing the inputs, click on the "Transact" button to execute the function.

## Authors

Pawash Kumar Singh
pawash97@gmail.com

## License

This project is licensed under the MIT License - see the LICENSE.md file for details

## Video Walkthrough
https://www.loom.com/share/11b0f131d2c145e6b3f136d87836e69b?sid=9f80ebb6-0c89-4cde-92f2-ea26101725fa
