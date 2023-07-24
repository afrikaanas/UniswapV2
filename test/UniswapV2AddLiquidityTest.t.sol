// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "forge-std/Test.sol";
import "forge-std/console.sol";

import "../src/UniswapV2AddLiquidity.sol";
import {IUniswapV2Pair} from "../src/interfaces/IUniswapV2Pair.sol";
import {IUniswapV2Router02} from "../src/interfaces/IUniswapV2Router.sol";

IERC20 constant WETH = IERC20(0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2);

IERC20 constant USDT = IERC20(0xdAC17F958D2ee523a2206206994597C13D831ec7);

IUniswapV2Router02 constant ROUTER = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);

IUniswapV2Pair constant PAIR = IUniswapV2Pair(0x0d4a11d5EEaaC28EC3F61d100daF4d40471f1852);

contract UniswapV2AddLiquidityTest is Test {
    UniswapV2AddLiquidity private uni;

    function setUp() public {
        vm.createSelectFork("mainnet", 17_764_167);
        uni = new UniswapV2AddLiquidity();
    }
    //  Add WETH/USDT Liquidity to Uniswap

    function testAddLiquidity() public {
        // Deal test USDT and WETH to this contract
        deal(address(USDT), address(this), 1e6 * 1e6);
        assertEq(USDT.balanceOf(address(this)), 1e6 * 1e6, "USDT balance incorrect");
        deal(address(WETH), address(this), 1e6 * 1e18);
        assertEq(WETH.balanceOf(address(this)), 1e6 * 1e18, "WETH balance incorrect");

        // Approve uni for transferring
        safeApprove(WETH, address(uni), 1e64);
        safeApprove(USDT, address(uni), 1e64);

        // Calculate amount of USDT to add to equivalent to 1 WETH
        (uint112 reserve0, uint112 reserve1,) = PAIR.getReserves();
        (uint256 amount) = quote(1e18, reserve0, reserve1);

        uni.addLiquidity(address(WETH), address(USDT), 1 * 1e18, amount);
        console.log("pair balance", PAIR.balanceOf(address(uni)));
        assertGt(PAIR.balanceOf(address(uni)), 0, "pair balance 0");
    }

    // Remove WETH/USDT Liquidity from Uniswap

    function testRemoveLiquidity() public {
        // Deal LP tokens to uni
        deal(address(PAIR), address(uni), 1e10);
        assertEq(PAIR.balanceOf(address(uni)), 1e10, "LP tokens balance = 0");
        assertEq(USDT.balanceOf(address(uni)), 0, "USDT balance non-zero");
        assertEq(WETH.balanceOf(address(uni)), 0, "WETH balance non-zero");

        uni.removeLiquidity(address(WETH), address(USDT));

        assertEq(PAIR.balanceOf(address(uni)), 0, "LP tokens balance != 0");
        assertGt(USDT.balanceOf(address(uni)), 0, "USDT balance = 0");
        assertGt(WETH.balanceOf(address(uni)), 0, "WETH balance = 0");
    }

    /**
     * @dev The transferFrom function may or may not return a bool.
     * The ERC-20 spec returns a bool, but some tokens don't follow the spec.
     * Need to check if data is empty or true.
     */
    function safeTransferFrom(IERC20 token, address sender, address recipient, uint256 amount) internal {
        (bool success, bytes memory returnData) =
            address(token).call(abi.encodeCall(IERC20.transferFrom, (sender, recipient, amount)));
        require(success && (returnData.length == 0 || abi.decode(returnData, (bool))), "Transfer from fail");
    }

    function quote(uint256 amountA, uint256 reserveA, uint256 reserveB) internal pure returns (uint256 amountB) {
        require(amountA > 0, "UniswapV2Library: INSUFFICIENT_AMOUNT");
        require(reserveA > 0 && reserveB > 0, "UniswapV2Library: INSUFFICIENT_LIQUIDITY");
        amountB = (amountA * reserveB) / reserveA;
    }

    /**
     * @dev The approve function may or may not return a bool.
     * The ERC-20 spec returns a bool, but some tokens don't follow the spec.
     * Need to check if data is empty or true.
     */
    function safeApprove(IERC20 token, address spender, uint256 amount) internal {
        (bool success, bytes memory returnData) = address(token).call(abi.encodeCall(IERC20.approve, (spender, amount)));
        require(success && (returnData.length == 0 || abi.decode(returnData, (bool))), "Approve fail");
    }
}
