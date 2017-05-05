/* 
 * CS:APP Data Lab 
 * 
 * 
 * Luke Reddick - lreddick
 *
 * bits.c - Source file with your solutions to the Lab.
 *          This is the file you will hand in to your instructor.
 *
 * WARNING: Do not include the <stdio.h> header; it confuses the dlc
 * compiler. You can still use printf for debugging without including
 * <stdio.h>, although you might get a compiler warning. In general,
 * it's not good practice to ignore compiler warnings, but in this
 * case it's OK.  
 */

#if 0
/*
 * Instructions to Students:
 *
 * STEP 1: Read the following instructions carefully.
 */

You will provide your solution to the Data Lab by
editing the collection of functions in this source file.

INTEGER CODING RULES:
 
  Replace the "return" statement in each function with one
  or more lines of C code that implements the function. Your code 
  must conform to the following style:
 
  int Funct(arg1, arg2, ...) {
      /* brief description of how your implementation works */
      int var1 = Expr1;
      ...
      int varM = ExprM;

      varJ = ExprJ;
      ...
      varN = ExprN;
      return ExprR;
  }

  Each "Expr" is an expression using ONLY the following:
  1. Integer constants 0 through 255 (0xFF), inclusive. You are
      not allowed to use big constants such as 0xffffffff.
  2. Function arguments and local variables (no global variables).
  3. Unary integer operations ! ~
  4. Binary integer operations & ^ | + << >>
    
  Some of the problems restrict the set of allowed operators even further.
  Each "Expr" may consist of multiple operators. You are not restricted to
  one operator per line.

  You are expressly forbidden to:
  1. Use any control constructs such as if, do, while, for, switch, etc.
  2. Define or use any macros.
  3. Define any additional functions in this file.
  4. Call any functions.
  5. Use any other operations, such as &&, ||, -, or ?:
  6. Use any form of casting.
  7. Use any data type other than int.  This implies that you
     cannot use arrays, structs, or unions.

 
  You may assume that your machine:
  1. Uses 2s complement, 32-bit representations of integers.
  2. Performs right shifts arithmetically.
  3. Has unpredictable behavior when shifting an integer by more
     than the word size.

EXAMPLES OF ACCEPTABLE CODING STYLE:
  /*
   * pow2plus1 - returns 2^x + 1, where 0 <= x <= 31
   */
  int pow2plus1(int x) {
     /* exploit ability of shifts to compute powers of 2 */
     return (1 << x) + 1;
  }

  /*
   * pow2plus4 - returns 2^x + 4, where 0 <= x <= 31
   */
  int pow2plus4(int x) {
     /* exploit ability of shifts to compute powers of 2 */
     int result = (1 << x);
     result += 4;
     return result;
  }

FLOATING POINT CODING RULES

For the problems that require you to implent floating-point operations,
the coding rules are less strict.  You are allowed to use looping and
conditional control.  You are allowed to use both ints and unsigneds.
You can use arbitrary integer and unsigned constants.

You are expressly forbidden to:
  1. Define or use any macros.
  2. Define any additional functions in this file.
  3. Call any functions.
  4. Use any form of casting.
  5. Use any data type other than int or unsigned.  This means that you
     cannot use arrays, structs, or unions.
  6. Use any floating point data types, operations, or constants.


NOTES:
  1. Use the dlc (data lab checker) compiler (described in the handout) to 
     check the legality of your solutions.
  2. Each function has a maximum number of operators (! ~ & ^ | + << >>)
     that you are allowed to use for your implementation of the function. 
     The max operator count is checked by dlc. Note that '=' is not 
     counted; you may use as many of these as you want without penalty.
  3. Use the btest test harness to check your functions for correctness.
  4. Use the BDD checker to formally verify your functions
  5. The maximum number of ops for each function is given in the
     header comment for each function. If there are any inconsistencies 
     between the maximum ops in the writeup and in this file, consider
     this file the authoritative source.

/*
 * STEP 2: Modify the following functions according the coding rules.
 * 
 *   IMPORTANT. TO AVOID GRADING SURPRISES:
 *   1. Use the dlc compiler to check that your solutions conform
 *      to the coding rules.
 *   2. Use the BDD checker to formally verify that your solutions produce 
 *      the correct answers.
 */


#endif
/* Copyright (C) 1991-2014 Free Software Foundation, Inc.
   This file is part of the GNU C Library.

   The GNU C Library is free software; you can redistribute it and/or
   modify it under the terms of the GNU Lesser General Public
   License as published by the Free Software Foundation; either
   version 2.1 of the License, or (at your option) any later version.

   The GNU C Library is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
   Lesser General Public License for more details.

   You should have received a copy of the GNU Lesser General Public
   License along with the GNU C Library; if not, see
   <http://www.gnu.org/licenses/>.  */
/* This header is separate from features.h so that the compiler can
   include it implicitly at the start of every compilation.  It must
   not itself include <features.h> or any other header that includes
   <features.h> because the implicit include comes before any feature
   test macros that may be defined in a source file before it first
   explicitly includes a system header.  GCC knows the name of this
   header in order to preinclude it.  */
/* glibc's intent is to support the IEC 559 math functionality, real
   and complex.  If the GCC (4.9 and later) predefined macros
   specifying compiler intent are available, use them to determine
   whether the overall intent is to support these features; otherwise,
   presume an older compiler has intent to support these features and
   define these macros by default.  */
/* wchar_t uses ISO/IEC 10646 (2nd ed., published 2011-03-15) /
   Unicode 6.0.  */
/* We do not support C11 <threads.h>.  */
/* 
 * addOK - Determine if can compute x+y without overflow
 *   Example: addOK(0x80000000,0x80000000) = 0,
 *            addOK(0x80000000,0x70000000) = 1, 
 *   Legal ops: ! ~ & ^ | + << >>
 *   Max ops: 20
 *   Rating: 3
 */
int addOK(int x, int y) {
 
	/* Check sign bits - if not same then no overflow */
	/* Overflow if sign bits are same and sign of sum differs 
	/* from sign of x */

 
	int a = x>>31;
	int b = y>>31;
	int z = x + y;
	int c = z>>31;

	return !(~(a ^ b) & (a ^ c));

}
/* 
 * allOddBits - return 1 if all odd-numbered bits in word set to 1
 *   Examples allOddBits(0xFFFFFFFD) = 0, allOddBits(0xAAAAAAAA) = 1
 *   Legal ops: ! ~ & ^ | + << >>
 *   Max ops: 12
 *   Rating: 2
 */
int allOddBits(int x) {

	/* Need bit mask for 10101010 or 0xAA but for word size */
	/* Build bit mask within bits.c parameters */
	/* Use 32-bit int mask to check all odd bits */
	/* If x has all odd bits at 1 then x & oddBits turns it into oddBits */
	/* oddBits ^ oddBits therefore will be 0 but we want to return 1, so use ! */

	int oddBits = (0xAA << 8) + 0xAA;
	oddBits = (oddBits << 16) + oddBits;
	return !((x & oddBits) ^ oddBits);
}
/* 
 * anyOddBit - return 1 if any odd-numbered bit in word set to 1
 *   Examples anyOddBit(0x5) = 0, anyOddBit(0x7) = 1
 *   Legal ops: ! ~ & ^ | + << >>
 *   Max ops: 12
 *   Rating: 2
 */
int anyOddBit(int x) {

	/* Shift through masking all even bits to keep only
	 * odd bits. So variables a-d are all byte segments
	 * from x that have a 1 flipped for the presence of an
	 * odd bit. Add all of these up and if a number even exists
	 * then we know a bit had to be odd so use ! operator
	 * to discern zero / nonzero number - where a zero sum
	 * would indicate no odd bits were flipped. 
	 */

	
	int a = x & 0xAA;
	int b = (x >> 8) & 0xAA;
	int c = (x >> 16) & 0xAA;
	int d = (x >> 24) & 0xAA;
	
	int sum = a + b + c + d;

	return !(!sum);

}
/* 
 * bitAnd - x&y using only ~ and | 
 *   Example: bitAnd(6, 5) = 4
 *   Legal ops: ~ |
 *   Max ops: 8
 *   Rating: 1
 */
int bitAnd(int x, int y) {

	/* De morgan's law (x&y) = ~(~x|~y) */

	return ~(~x | ~y);
}
/*
 * bitCount - returns count of number of 1's in word
 *   Examples: bitCount(5) = 2, bitCount(7) = 3
 *   Legal ops: ! ~ & ^ | + << >>
 *   Max ops: 40
 *   Rating: 4
 */
int bitCount(int x) {

	/* Create mask with 1's at every least significant bit in a 
	 * 4 bit increment. Then shifting with x, & our mask to find 
	 * 1's in the orginial bit pattern. Counter holds number of 1's
	 * in first 4 bits. Add adjacent 4 bits together then shift and
	 * mask to ensure result is 0-32.
	 */

	int m = 0x11 | (0x11 << 8);
	int mask = m | (m << 16);

	int counter = x & mask;
	counter = counter + ((x >> 1) & mask);
	counter = counter + ((x >> 2) & mask);
	counter = counter + ((x >> 3) & mask);

	counter = counter + (counter >> 16);

	m = 0xF | (0xF << 8);

	counter = (counter & m) + ((counter >> 4) & m);

	return (((counter + (counter >> 8)) & 0x3F));
}
/* 
 * bitNor - ~(x|y) using only ~ and & 
 *   Example: bitNor(0x6, 0x5) = 0xFFFFFFF8
 *   Legal ops: ~ &
 *   Max ops: 8
 *   Rating: 1
 */
int bitNor(int x, int y) {

	/* Application of De Morgan's law from discrete mathematics */
	return (~x & ~y);
}
/*
 * bitParity - returns 1 if x contains an odd number of 0's
 *   Examples: bitParity(5) = 0, bitParity(7) = 1
 *   Legal ops: ! ~ & ^ | + << >>
 *   Max ops: 20
 *   Rating: 4
 */
int bitParity(int x) {

	/* XOR operation can find parity on 2 bits since
	 * 1 ^ 0 is 1 - marking a 0 in the original bit pattern
	 * so we XOR all 32 bits of x by "folding" the bits on
	 * themselves.
	 */

	x ^= x >> 16;
	x ^= x >> 8;
	x ^= x >> 4;
	x ^= x >> 2;
	x ^= x >> 1;
	x &= 1;

	return x;
}
/* 
 * greatestBitPos - return a mask that marks the position of the
 *               most significant 1 bit. If x == 0, return 0
 *   Example: greatestBitPos(96) = 0x40
 *   Legal ops: ! ~ & ^ | + << >>
 *   Max ops: 70
 *   Rating: 4 
 */
int greatestBitPos(int x) {
 
	/* Make all bits to the right of MSB 1 trailing 1's
	 * then shift right 1 and add 1 to mark the MSB 1
	 */

	x = x | (x >> 1);
	x = x | (x >> 2);
	x = x | (x >> 4);
	x = x | (x >> 8);
	x = x | (x >> 16);

	/* Mark leading bit make sure x is non-zero */

	x = x & ((~x >> 1) ^ (1 << 31));;

	return x;

}
/*
 * ilog2 - return floor(log base 2 of x), where x > 0
 *   Example: ilog2(16) = 4
 *   Legal ops: ! ~ & ^ | + << >>
 *   Max ops: 90
 *   Rating: 4
 */
int ilog2(int x) {

	/* Remember >> indicates dividing by 2 to the n 
	 * And since we are dealing in integers our return
	 * value is bonded 0 <= return <= 31 sine a logarithm
	 * base 2 equaling anythin outside these boundaries could
	 * not fit inside an integer. 0 - 31 fits into 5 bits 
	 * and we build this "5 bit" return by shifting left at 
	 * each operation decrementing our shift each time. 
	 * Check to see if 2 to the 16 divides into the number
	 * if we have values left then we need to turn on our 
	 * 5th bit in our return since we can atleast fit 2 to
	 * the 16th. Logarithms equal exponents so we are 
	 * essentially looking at 2 to the ??? gives us our
	 * input parameter, since we are in binary we just keep
	 * testing powers of two. Use !! operator to erase the bits
	 * and just return a 1 or 0 indicating divisibility by the
	 * shift. Add this to the next test of divisibility to see if
	 * we indeed need more bits so if 16 DID divide, we check 24
	 * this would mean we need to turn on our "4th bit" or 8. 
	 * continue this pattern all the way to 1, completing our
	 * "5 bit" return value. Math is sexy. 
	 */


	int result = 0;
	result = !!((x >> 16)) << 4;
	result = result + ((!!(x >> (result + 8))) << 3);
	result = result + ((!!(x >> (result + 4))) << 2);
	result = result + ((!!(x >> (result + 2))) << 1);
	result = result + (!!(x >> (result + 1)));

	return result; 
}
/* 
 * isNonNegative - return 1 if x >= 0, return 0 otherwise 
 *   Example: isNonNegative(-1) = 0.  isNonNegative(0) = 1.
 *   Legal ops: ! ~ & ^ | + << >>
 *   Max ops: 6
 *   Rating: 3
 */
int isNonNegative(int x) {

	/* Logical not the sign bit */

	return !(x >> 31);
}
/*
 * isTmax - returns 1 if x is the maximum, two's complement number,
 *     and 0 otherwise 
 *   Legal ops: ! ~ & ^ | +
 *   Max ops: 10
 *   Rating: 1
 */
int isTmax(int x) {

	/* max + max = -2 so x + x + 2 would equal 0. And !(~x) would
	 * return 1 if it was Tmax so this checks both cases
	 */
	return !((x + x + 2) | !(~x));
}
/* 
 * leastBitPos - return a mask that marks the position of the
 *               least significant 1 bit. If x == 0, return 0
 *   Example: leastBitPos(96) = 0x20
 *   Legal ops: ! ~ & ^ | + << >>
 *   Max ops: 6
 *   Rating: 2 
 */
int leastBitPos(int x) {

	/* Negative and with original give least bit position mask */


	return x & (~x + 1);
}
/* 
 * logicalNeg - implement the ! operator, using all of 
 *              the legal operators except !
 *   Examples: logicalNeg(3) = 0, logicalNeg(0) = 1
 *   Legal ops: ~ & ^ | + << >>
 *   Max ops: 12
 *   Rating: 4 
 */
int logicalNeg(int x) {

	/* Check if it's zero by &ing the complement with its
	 * two's complement - shift to check the last bit which will
	 * be a 0 if it is zero & with 1 to get a logical return.
	 */

	return (((~x) & (~(~x +1))) >> 31) & 1;
}
/* 
 * logicalShift - shift x to the right by n, using a logical shift
 *   Can assume that 0 <= n <= 31
 *   Examples: logicalShift(0x87654321,4) = 0x08765432
 *   Legal ops: ~ & ^ | + << >>
 *   Max ops: 20
 *   Rating: 3 
 */
int logicalShift(int x, int n) {
	
	/* Create a mask to get the bits we actually want
	 * and ignore the extended sign bits if they exist.
	 * Copy a 1 into the bit mask and extend it the shift
	 * amount then ~ it to reverse bits and we have our 
	 * mask - then & with arithmetic shift to get logical.
	 */
	
	return (x >> n) & ~(((0x1 << 31) >> n) << 1);
}
/* 
 * negate - return -x 
 *   Example: negate(1) = -1.
 *   Legal ops: ! ~ & ^ | + << >>
 *   Max ops: 5
 *   Rating: 2
 */
int negate(int x) {

	/* Standard two's complement arithmetic to negate a number */
	/* Flip bits and add one */
  	return ~x + 1;
}
/* 
 * oddBits - return word with all odd-numbered bits set to 1
 *   Legal ops: ! ~ & ^ | + << >>
 *   Max ops: 8
 *   Rating: 2
 */
int oddBits(void) {

	/* 0xAA matches an odd bit representation so we need to 
	 * extend it to the 32-bit word size with shifts.
	 * Remember bits are indexed at 0 so 0x55 is actually evens. 
	 * It took me awhile to figure that out . . . RIP 
	 */

	int a = (0xAA << 8) + 0xAA;
	return (a << 16) + a;
}
/* 
 * reverseBytes - reverse the bytes of x
 *   Example: reverseBytes(0x01020304) = 0x04030201
 *   Legal ops: ! ~ & ^ | + << >>
 *   Max ops: 25
 *   Rating: 3
 */
int reverseBytes(int x) {

	/* Copy byte by byte with & 0xFF and store it into its
	 * new location in result (the reverse order) by turning
	 * bits on with the | operator. Shift left to place bytes
	 * in correct bit location in result. 
	 * Thanks for the help on this one Dr. Scherger!
	 */


	int result = 0;

	result = result | ((x >> 24) & 0xFF);
	result = result | (((x >> 16) & 0xFF) << 8);
	result = result | (((x >> 8) & 0xFF) << 16);
	result = result | ((x & 0xFF) << 24);
	return result;
}
/* subOK - Determine if can compute x-y without overflow
 *   Example: subOK(0x80000000,0x80000000) = 1,
 *            subOK(0x80000000,0x70000000) = 0, 
 *   Legal ops: ! ~ & ^ | + << >>
 *   Max ops: 20
 *   Rating: 3
 */
int subOK(int x, int y) {


	/* Subtraction is equal to adding the negative and we check sign bits
	 * as if we were checking for adding overflow
	 */

	int negY = ~y + 1;
	int z = x + negY;
	int signBit = x ^ y;
	int subSignBit = x ^ z;

	return !((signBit & subSignBit) >> 31);

}
/* 
 * thirdBits - return word with every third bit (starting from the LSB) set to 1
 *   Legal ops: ! ~ & ^ | + << >>
 *   Max ops: 8
 *   Rating: 1
 */
int thirdBits(void) {

	/* 0x49 starts thirdBit pattern and we manipulate the pattern  by adding in 
	 * necessary padding zeros to maintain the pattern through shifts and adding
	 * our 0x49 pattern back in. I call it useLessOpsVar because
	 * it is indeed a variable that helps use less operations. Bless up.
	 */

	 int useLessOpsVar = ((0x49 << 9) + 0x49);
 	 return ((useLessOpsVar << 18) + useLessOpsVar);
}
/* 
 * tmin - return minimum two's complement integer 
 *   Legal ops: ! ~ & ^ | + << >>
 *   Max ops: 4
 *   Rating: 1
 */
int tmin(void) {
	
	/* Need 1 followed by all zeros, so push 0x80 all the way to MSB */
	return ((0x80) << 24);
}
