// SPDX-License-Identifier: GPL-2.0-or-later
pragma solidity =0.8.0;
pragma abicoder v2;

import './TransferHelper.sol';
import './ISwapRouter.sol';

contract SwapExamples {

    ISwapRouter public immutable swapRouter;
    address public constant USDC = 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48;


    uint24 public constant poolFee = 3000;

    constructor(ISwapRouter _swapRouter) {
        swapRouter = _swapRouter;
    }
    function swapExactInputSingle(address from, address to,uint256 amountIn) external returns (uint256 amountOut) {
  
        TransferHelper.safeTransferFrom(from, msg.sender, address(this), amountIn);

        TransferHelper.safeApprove(from, address(swapRouter), amountIn);

        ISwapRouter.ExactInputSingleParams memory params =
            ISwapRouter.ExactInputSingleParams({
                tokenIn: from,
                tokenOut: to,
                fee: poolFee,
                recipient: msg.sender,
                deadline: block.timestamp,
                amountIn: amountIn,
                amountOutMinimum: 0,
                sqrtPriceLimitX96: 0
            });

        amountOut = swapRouter.exactInputSingle(params);
    }

    function swapExactOutputSingle(address from, address to, uint256 amountOut, uint256 amountInMaximum) external returns (uint256 amountIn) {
        TransferHelper.safeTransferFrom(from, msg.sender, address(this), amountInMaximum);
        TransferHelper.safeApprove(from, address(swapRouter), amountInMaximum);

        ISwapRouter.ExactOutputSingleParams memory params =
            ISwapRouter.ExactOutputSingleParams({
                tokenIn: from,
                tokenOut: to,
                fee: poolFee,
                recipient: msg.sender,
                deadline: block.timestamp,
                amountOut: amountOut,
                amountInMaximum: amountInMaximum,
                sqrtPriceLimitX96: 0
            });

        amountIn = swapRouter.exactOutputSingle(params);
        if (amountIn < amountInMaximum) {
            TransferHelper.safeApprove(from, address(swapRouter), 0);
            TransferHelper.safeTransfer(from, msg.sender, amountInMaximum - amountIn);
        }
    }
}