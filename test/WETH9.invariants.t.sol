pragma solidity ^0.8.13;

import {Test} from "forge-std/Test.sol";
import {WETH9} from "../src/WETH9.sol";
import {Handler} from "./handlers/Handler.sol";

contract WETH9Invariants is Test {
    WETH9 public weth;
    Handler public handler;

    function setUp() public {
        weth = new WETH9();
        handler = new Handler(weth);
        // explictly filter for a given contract
        targetContract(address(handler));
    }

    function invariant_wethSupplyIsAlwaysZero() public view {
        assertEq(0, weth.totalSupply());
    }

    // ETH can only be wrapped into WETH, WETH can only
    // be unwrapped back into ETH. The sum of the Handler's
    // ETH balance plus the WETH totalSupply() should always
    // equal the total ETH_SUPPLY.
    function invariant_conservationOfETH() public view {
        assertEq(handler.ETH_SUPPLY(), address(handler).balance + weth.totalSupply());
    }
}
