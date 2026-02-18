# Multi-Precision-Floating-Point-MAC
Designed a multi-precision Floating-Point MAC unit (BF16/FP16/FP32/FP64) in Verilog with custom multiplier and IEEE-754–based FP32 accumulator.

This implementation focuses on the core floating-point datapath architecture for learning and architectural exploration. The design prioritizes clarity and multi-format adaptability over full IEEE-754 compliance.

**Supported Features**

Multi-precision multiplication:BF16,FP16,FP32 and FP64
FP32-based accumulation,
Exponent bias handling,
Mantissa normalization,
Two-stage pipelined MAC architecture and Fully synthesizable RTL

**Assumptions**
Inputs are assumed to be normalized floating-point numbers
The hidden leading bit (implicit 1) is always present
Truncation is used instead of IEEE rounding modes
No floating-point exception flags are generated

The following features are intentionally not included in this version:
Subnormal (denormal) number support
IEEE rounding modes (round-to-nearest, toward-zero, etc.)
Exception flag generation
Fully fused multiply-accumulate (single rounding FMA)
This version is intended to demonstrate floating-point datapath design concepts rather than full IEEE-754 compliance.

**Design Choice: FP32 Accumulation**
All multiplication results are converted to FP32 before accumulation. This approach:
Improves numerical stability
Simplifies adder hardware design
