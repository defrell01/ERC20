import { SignerWithAddress } from "@nomiclabs/hardhat-ethers/signers";
import { expect } from "chai";
import { Contract } from "ethers";
import { ethers } from "hardhat";

describe("ERC20 functions", function () {
  let owner: SignerWithAddress;
  let addr1: SignerWithAddress;
  let addr2: SignerWithAddress;
  let contract: Contract;

  describe("Deploying", function () {
    it("Should deploy ERC20 contract and mint them on your balance", async function () {
      [owner, addr1, addr2] = await ethers.getSigners();
      const token20 = await ethers.getContractFactory("PXR3");
      contract = await token20.deploy("PXR3", "PXR", 18);

      await contract.deployed();
    });
  });

  describe("Returning information", function(){

    it("Should return total supply of token", async function() {
      await contract.mint(addr1.address, "100000000");
      expect(await contract.totalSupply()).to.equal(100000000);
    });

    it("Should return balance of account", async function() {
      expect(await contract.balanceOf(addr1.address)).to.equal(100000000);
      expect(await contract.balanceOf(owner.address)).to.equal(0);
    });

    it("Should return information about approves", async function() {
      await contract.approve(addr1.address, 1000);
      expect(await contract.allowance(owner.address, addr1.address)).to.equal(1000);
    });
  });

  describe("Transfers", function(){
    beforeEach(async function(){ 
      await contract.mint(owner.address, "100000000")
    });

    it("Should transfer tokens between accounts", async function() {
      await contract.transfer(addr1.address, 1000);
      expect(await contract.balanceOf(addr1.address)).to.equal(100001000);
    });

    it("Should revert transaction if you have not enough tokens", async function(){
      await expect(contract.transfer(addr1.address, 100000000000)).to.be.revertedWith("Not enough tokens");
    });

    it("Should revert transaction if you try to send tokens on 0x0 address", async function(){
      await expect(contract.transfer("0x0000000000000000000000000000000000000000", 10000)).to.be.revertedWith("Address is incorrect");
    });

    it("Should transfer tokens from another account if you have permission", async function() {
      await contract.connect(addr1).approve(owner.address, 1000);
      await contract.transferFrom(addr1.address, addr2.address, 1000);
      expect(await contract.balanceOf(addr2.address)).to.equal(1000);
    });

    it("Should revert transaction if you try to send more tokens than exist on balance", async function(){
      await contract.connect(addr1).approve(owner.address, 100000000000000);
      await expect(contract.transferFrom(addr1.address, addr2.address, 100000000000000)).to.be.revertedWith("Not enough tokens");
    });

    it("Should revert transaction if you try to send more tokens than allowed", async function(){
      await contract.connect(addr1).approve(owner.address, 10);
      await expect(contract.transferFrom(addr1.address, addr2.address, 100)).to.be.revertedWith("Not allowed");
    });

    it("Should revert transaction if you try to send tokens to 0x0 address", async function(){
      await contract.connect(addr1).approve(owner.address, 10);
      await expect(contract.transferFrom(addr1.address, "0x0000000000000000000000000000000000000000", 8)).to.be.revertedWith("Address is incorrect");
    });

    it("Should revert approving, if you try to approve spending for 0x0 address", async function(){
      await expect(contract.connect(addr1).approve("0x0000000000000000000000000000000000000000", 10)).to.be.revertedWith("Address is incorrect");
    });

    it("Should mint tokens", async function() {
      expect(await contract.balanceOf(owner.address)).to.equal(899999000);
    });

    it("Should burn tokens", async function() {
      await contract.burn(addr1.address, "90000000")
      expect(await contract.balanceOf(addr1.address)).to.equal(10000000);

    });

    it("Should revert burning if account hasn't got enough tokens", async function() {
      await expect(contract.burn(addr1.address, 10000000000000)).to.be.revertedWith("Not enough tokens");
    });

    it("Should revert minting if you are not an owner", async function() {
      await expect(contract.connect(addr2).mint(addr2.address, 10)).to.be.revertedWith("Not an owner");
    });

    it("Should revert burning if you are not an owner", async function() {
      await expect(contract.connect(addr2).burn(addr2.address, 10)).to.be.revertedWith("Not an owner");
    });
  });
});