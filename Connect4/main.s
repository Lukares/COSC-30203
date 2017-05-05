	.equ	NULL, 0x0

#############################################################
# Computer System Fundamentals Lab 3 - Connect Four
# Author: Luke Reddick		Date: April 19th, 2017
#
# .rodata contains all of my ascii strings and printf formats
# that I use in my program. Each of these is thrown to stdout
# using the printf C function call. 
#
############################################################

	.section .rodata
CMD_CLEAR:
	.string "clear"
MSG_QUESTION_1:
	.asciz ", do you want to go first? ([y] or [n])\n"
MSG_QUESTION_2:
	.asciz	"What is your name?\n"
MSG_INSTRUCTIONS:
        .ascii  "Welcome to Connect 4!\nThis is a 2-player turn based strategy game\n"
	.ascii	"in which a player places their corresponding token\n"
	.ascii	"into a selected column. The objective is to connect\n"
	.ascii	"4 tokens in a row either horizontally, veritcally, or\n"
	.ascii 	"diagonally. Each turn consists of placing one token.\n"
	.asciz	"Good luck!\n\n"
MSG_PRESS_ENTER:
	.asciz	"Press Enter to continue. . .\n"
COLUMN_ERR:
	.asciz	", that column does not exist, come on try again!\n"
COLUMN_FULL:
	.asciz	"Column is full! Try a different column!\n"
COLUMN_HEADER:
	.asciz	"|1|2|3|4|5|6|7|\n\n|"
PLAYER_PROMPT:
	.asciz	", select a column(1-7): \n"
PLAYER_WIN:
	.asciz	"Congratulations you are a winner!\n"
COMPUTER_WIN:
	.asciz	"Aww, you lost! Maybe next time!\n"
COMPUTER_TURN:
	.asciz	"Computer player choosing column . . .\n"
NEW_LINE:
	.asciz	"\n"
.LC0:
	.string "%c"
.LC1:
	.string	"%d"

########################################################
# .bss and .data sections contain variables that store
# values I want to save for later, such as player name
# and response to [y/n] questions. 
########################################################

	.bss
	.comm	buffer, 256
	.comm	name, 16
	.comm	answer, 3

	.data
column:
	.short 0

        .text
        .globl main

#######################################################
#
# Main function drives the program. It begins the turn
# order and handles switching turns as well as printing
# the game end scenarios. We initialize the game in this
# function with game instructiosn and prompts for name
# and first turn. Each time we call a turn, we check for 
# wins horizontally, diagonally, and vertically. If any
# of these conditions are true, register %r8 gets turned
# to a 1 indicating a jump to the final printf and exit
#
######################################################

        .type main, @function
main:
        push 	%rbp
        movq	%rsp, %rbp
	sub	$48, %rsp

        call 	clear_screen
        call 	display_instructions
	call	press_enter
	call 	clear_screen
	call	get_name
	call	init_turns
	call	init_board
	call	get_board

	cmp	$0x79, (%rbx)
	jne	.C1
.P1:
	mov	$name, %rdi
	xor	%rax, %rax
	call	printf
	mov	$PLAYER_PROMPT, %rdi
	xor	%rax, %rax
	call	printf
	mov	$.LC1, %rdi
	mov	$column, %rsi
	call	scanf
	mov	$1, %r8
	call	player_turn
	cmp	$0x0, %r8
	je	.P1
	call	get_board
	call	check_P_win
	cmp	$1, %r8
	je	.W1
	call	check_PV_win
	cmp	$1, %r8
	je	.W1
	call	check_PLD_win
	cmp	$1, %r8
	je	.W1
	call	check_PRD_win
	cmp	$1, %r8
	je	.W1
	jmp	.C1
.W1:
	mov	$PLAYER_WIN, %rdi
	xorq	%rax, %rax
	call	printf
	jmp	.E1	
.C1:
	call	computer_turn
	call	get_board
	call	check_CH_win
	cmp	$1, %r8
	je	.W2
	call	check_CV_win
	cmp	$1, %r8
	je	.W2
	call	check_CRD_win
	cmp	$1, %r8
	je	.W2
	call	check_CLD_win
	cmp	$1, %r8
	je	.W2
	jmp	.P1
.W2:	
	mov	$COMPUTER_WIN, %rdi
	xorq	%rax, %rax
	call	printf
	jmp	.E1
.E1:
	add	$48, %rsp
        leave
        movq    $5, %rdi
        call	exit

############################################################
#
# The following four functions all check for a player win. 
# PRD checks for right-to-left diagonal wins, PLD checks for
# left-to-right diagonal wins, PV checks for vertical wins,
# and check_P_win checks for horizontal wins. Each function
# iterates through the game board in its corresponding 
# check orientation and as it iterates keeps a counter in
# register %rax where each time we see a player token (X) 
# then we increment %rax, but if we see anything else or
# change row/column/diagonal (respective to the function)
# then we flush %rax and make it 0. Once we hit %rax = 4
# we turn %r8 to a 1 (indicating a win occured) and exit.  
#
############################################################

	.type check_PRD_win, @function
check_PRD_win:
	mov	$-7, %r13		# Track row here by 7 byte offsets on the stack.
	mov	$0x3, %r14		# Track column number here indexed 0-6
	mov	$0x0, %rax		# Count piece connections - when four we have a player win.
	xorq	%r9, %r9
	xorq	%r8, %r8
	jmp	.CPRD0
.CPRD0:	
	cmp	$-1, %r14
	je	.CPRD5
	cmp	$-49, %r13
	je	.CPRD5
	lea	(%rbp, %r13), %r15
	add	%r14, %r15
	inc	%r9
	cmpb	$88, (%r15)
	je	.CPRD1
	jne	.CPRD2
.CPRD1:
	inc	%rax
	cmp	$4, %rax
	je	.CPRD6	
	jmp	.CPRD3
.CPRD2:
	mov	$0x0, %rax
	jmp	.CPRD3
.CPRD3:
	dec	%r14
	sub	$7, %r13
	jmp	.CPRD0
.CPRD4:
	ret
.CPRD5:
	xorq	%rax, %rax
	cmp	$0x7, %r14
	je	.CPRD7
	add	%r9, %r14
	xorq	%r9, %r9
	mov	$-7, %r13
	inc	%r14
	jmp	.CPRD0
.CPRD7:
	cmp	$-49, %r13
	je	.CPRD4
	sub	$-7, %r13
	jmp	.CPRD0
.CPRD6:
	xorq	%r8, %r8
	mov	$1, %r8
	ret

	.type check_PLD_win, @function
check_PLD_win:
	mov	$-7, %r13		# Track row here by 7 byte offsets on the stack.
	mov	$0x3, %r14		# Track column number here indexed 0-6
	mov	$0x0, %rax		# Count piece connections - when four we have a player win.
	xorq	%r9, %r9
	xorq	%r8, %r8
	jmp	.CPLD0
.CPLD0:
	cmp	$7, %r14
	je	.CPLD5
	cmp	$-49, %r13
	je	.CPLD5
	lea	(%rbp, %r13), %r15
	add	%r14, %r15
	inc	%r9
	cmpb	$88, (%r15)
	je	.CPLD1
	jne	.CPLD2
.CPLD1:
	inc	%rax
	cmp	$4, %rax
	je	.CPLD6	
	jmp	.CPLD3
.CPLD2:
	mov	$0x0, %rax
	jmp	.CPLD3
.CPLD3:
	inc	%r14
	sub	$7, %r13
	jmp	.CPLD0
.CPLD4:
	ret
.CPLD5:
	xorq	%rax, %rax
	cmp	$0x0, %r14
	je	.CPLD7
	sub	%r9, %r14
	xorq	%r9, %r9
	dec	%r14
	mov	$-7, %r13
	jmp	.CPLD0
.CPLD7:
	cmp	$-49, %r13
	je	.CPLD4
	sub	$-7, %r13
	jmp	.CPLD0
.CPLD6:
	xorq	%r8, %r8
	mov	$1, %r8
	ret

	.type check_P_win, @function
check_P_win:
	mov	$-7, %r13		# Track row here by 7 byte offsets on the stack.
	mov	$0x0, %r14		# Track column number here indexed 0-6
	mov	$0x0, %rax		# Count piece connections - when four we have a player win.
	xorq	%r8, %r8
	jmp	.CPW0
.CPW0:
	cmp	$7, %r14
	je	.CPW4
	cmp	$-49, %r13
	je	.CPW5
	lea	(%rbp, %r13), %r15
	add	%r14, %r15
	cmpb	$88, (%r15)
	je	.CPW1
	jne	.CPW2
.CPW1:
	inc	%rax
	cmp	$4, %rax
	je	.CPW6	
	jmp	.CPW3
.CPW2:
	mov	$0x0, %rax
	jmp	.CPW3
.CPW3:
	inc	%r14
	jmp	.CPW0
.CPW4:
	mov	$0x0, %r14
	sub	$7, %r13
	xorq	%rax, %rax
	jmp	.CPW0
.CPW5:
	ret
.CPW6:
	xorq	%r8, %r8
	mov	$1, %r8
	ret

	.type check_PV_win, @function
check_PV_win:
	mov	$-7, %r13		# Track row here by 7 byte offsets on the stack.
	mov	$0x0, %r14		# Track column number here indexed 0-6
	mov	$0x0, %rax		# Count piece connections - when four we have a player win.
	xorq	%r8, %r8
	jmp	.CPVW0
.CPVW0:
	cmp	$7, %r14
	je	.CPVW5
	cmp	$-49, %r13
	je	.CPVW4
	lea	(%rbp, %r13), %r15
	add	%r14, %r15
	cmpb	$88, (%r15)
	je	.CPVW1
	jne	.CPVW2
.CPVW1:
	inc	%rax
	cmp	$4, %rax
	je	.CPVW6
	jmp	.CPVW3
.CPVW2:
	mov	$0x0, %rax
	jmp	.CPVW3
.CPVW3:
	sub	$7, %r13
	jmp	.CPVW0
.CPVW4:
	xorq	%r13, %r13
	mov	$-7, %r13
	inc	%r14
	xorq	%rax, %rax
	jmp	.CPVW0
.CPVW5:
	ret
.CPVW6:
	xorq	%r8, %r8
	mov	$1, %r8
	ret

###########################################################
#
# player_turn handles the column input from the player which
# for reasons unknown gets placed in %r11, but nevetheless
# I'll take it. It will only accept column input between 1 
# and 7 (though a negative or strings break the shit out of it)
# The player_turn will iterate up the column checking for the
# first available blank space and place the player token there.
# If the top is reached, we notify the player the column is full
# and they must input a different column.
#
############################################################

	.type player_turn, @function
player_turn:
	mov	$-7, %r13
	jmp	.PT0
.PT0:
	cmp	$-49, %r13
	je	.PT2
	lea	(%rbp,%r13), %r14
	cmp	$7,%r11
	jg	.PT3
	cmp	$1, %r11
	jl	.PT3
	add	%r11, %r14
	sub	$1, %r14
	cmpb	$95, (%r14) 
	je	.PT1
	sub	$7, %r13
	jmp	.PT0
.PT1:
	movb	$88, (%r14)
	ret
.PT2:
	mov	$COLUMN_FULL, %rdi
	xorq	%rax, %rax
	call	printf
	xorq	%r8, %r8
	ret
.PT3:
	mov	$name, %rdi
	xorq	%rax, %rax
	call	printf
	mov	$COLUMN_ERR, %rdi
	xorq	%rax, %rax
	call	printf
	xorq	%r8, %r8
	ret

####################################################################
#
# computer_turn waits two seconds to add some suspense to the opponents
# next move with a stdout indicator. Then it will iterate through all 
# first available blanks in each column. For each iteration, it places 
# a computer piece there and checks for a computer win, if that placement
# yielded a computer win, then the computer places there. If there are no
# available computer wins it checks for player wins by placing an player
# token there instead. If that placement yields a player win, it chooses 
# that column to place its token. Otherwise it will place to the rightmost
# column from the one selected by the player. 
#
####################################################################

	.type computer_turn, @function
computer_turn:
	mov	$COMPUTER_TURN, %rdi
	xorq	%rax, %rax
	call	printf
	mov	$1, %rdi
	call	sleep
	mov	$-7, %rbx
	mov	$0x0, %rcx
	jmp	.CT4
.CT4:
	cmp	$7, %rcx
	je	.CT6
	cmp	$-49, %rbx
	je	.CT7
	lea	(%rbp, %rbx), %rdx
	add	%rcx, %rdx
	cmpb	$95, (%rdx)
	je	.CT5
	sub	$7, %rbx
	jmp	.CT4
.CT7:
	inc	%rcx
	mov	$-7, %rbx
	jmp	.CT4	
.CT5:
	movb	$79, (%rdx)
	call	check_CH_win
	cmp	$1, %r8
	je	.CT1
	call	check_CV_win
	cmp	$1, %r8
	je	.CT1
	call	check_CLD_win
	cmp	$1, %r8
	je	.CT1
	call	check_CRD_win
	cmp	$1, %r8
	je	.CT1

	movb	$88, (%rdx)
	call	check_P_win
	cmp	$1, %r8
	je	.CT1
	call	check_PV_win
	cmp	$1, %r8
	je	.CT1
	call	check_PLD_win
	cmp	$1, %r8
	je	.CT1
	call	check_PRD_win
	cmp	$1, %r8
	je	.CT1

	movb	$95, (%rdx)
	mov	$-7, %rbx
	inc	%rcx
	jmp	.CT4
.CT6:
	mov	$-7, %rbx
	lea	(%rbp, %rbx), %rdx
	jmp	.CT0	
.CT0:
	cmp	$-49, %rbx
	je	.CT2
	lea	(%rbp, %rbx), %rdx
	add	column, %rdx
	cmpb	$95, (%rdx)
	je	.CT1
	sub	$7, %rbx
	jmp	.CT0
.CT1:
	movb	$79, (%rdx)
	ret
.CT2:
	xorq	%r8, %r8
	add	$1, column
	mov	$-7, %rbx
	jmp	.CT0		

#######################################################################
# 
# The following four functions are the check for a computer win functions.
# They are essentially copy paste from the check player win functions above. 
# Read the comment from the check player win function group, the exact same
# logic is found here but instead cmpb with a $79 ('O') instead. 
#
#######################################################################

	.type check_CH_win, @function
check_CH_win:
	mov	$-7, %r13		# Track row here by 7 byte offsets on the stack.
	mov	$0x0, %r14		# Track column number here indexed 0-6
	mov	$0x0, %rax		# Count piece connections - when four we have a player win.
	xorq	%r8, %r8
	jmp	.CHW0
.CHW0:
	cmp	$7, %r14
	je	.CHW4
	cmp	$-49, %r13
	je	.CHW5
	lea	(%rbp, %r13), %r15
	add	%r14, %r15
	cmpb	$79, (%r15)
	je	.CHW1
	jne	.CHW2
.CHW1:
	inc	%rax
	cmp	$4, %rax
	je	.CHW6	
	jmp	.CHW3
.CHW2:
	mov	$0x0, %rax
	jmp	.CHW3
.CHW3:
	inc	%r14
	jmp	.CHW0
.CHW4:
	mov	$0x0, %r14
	sub	$7, %r13
	xorq	%rax, %rax
	jmp	.CHW0
.CHW5:
	ret
.CHW6:
	xorq	%r8, %r8
	mov	$1, %r8
	ret
	
	.type check_CV_win, @function
check_CV_win:
	mov	$-7, %r13		# Track row here by 7 byte offsets on the stack.
	mov	$0x0, %r14		# Track column number here indexed 0-6
	mov	$0x0, %rax		# Count piece connections - when four we have a player win.
	xorq	%r8, %r8
	jmp	.CCVW0
.CCVW0:
	cmp	$7, %r14
	je	.CCVW5
	cmp	$-49, %r13
	je	.CCVW4
	lea	(%rbp, %r13), %r15
	add	%r14, %r15
	cmpb	$79, (%r15)
	je	.CCVW1
	jne	.CCVW2
.CCVW1:
	inc	%rax
	cmp	$4, %rax
	je	.CCVW6	
	jmp	.CCVW3
.CCVW2:
	mov	$0x0, %rax
	jmp	.CCVW3
.CCVW3:
	sub	$7, %r13
	jmp	.CCVW0
.CCVW4:
	xorq	%r13, %r13
	mov	$-7, %r13
	inc	%r14
	xorq	%rax, %rax
	jmp	.CCVW0
.CCVW5:
	ret
.CCVW6:
	xorq	%r8, %r8
	mov	$1, %r8
	ret
	
	.type check_CRD_win, @function
check_CRD_win:
	mov	$-7, %r13		# Track row here by 7 byte offsets on the stack.
	mov	$0x3, %r14		# Track column number here indexed 0-6
	mov	$0x0, %rax		# Count piece connections - when four we have a player win.
	xorq	%r9, %r9
	xorq	%r8, %r8
	jmp	.CCRD0
.CCRD0:	
	cmp	$-1, %r14
	je	.CCRD5
	cmp	$-49, %r13
	je	.CCRD5
	lea	(%rbp, %r13), %r15
	add	%r14, %r15
	inc	%r9
	cmpb	$79, (%r15)
	je	.CCRD1
	jne	.CCRD2
.CCRD1:
	inc	%rax
	cmp	$4, %rax
	je	.CCRD6	
	jmp	.CCRD3
.CCRD2:
	mov	$0x0, %rax
	jmp	.CCRD3
.CCRD3:
	dec	%r14
	sub	$7, %r13
	jmp	.CCRD0
.CCRD4:
	ret
.CCRD5:
	xorq	%rax, %rax
	cmp	$0x7, %r14
	je	.CCRD7
	add	%r9, %r14
	xorq	%r9, %r9
	mov	$-7, %r13
	inc	%r14
	jmp	.CCRD0
.CCRD7:
	cmp	$-49, %r13
	je	.CCRD4
	sub	$-7, %r13
	jmp	.CCRD0
.CCRD6:
	xorq	%r8, %r8
	mov	$1, %r8
	ret

	.type check_CLD_win, @function
check_CLD_win:
	mov	$-7, %r13		# Track row here by 7 byte offsets on the stack.
	mov	$0x3, %r14		# Track column number here indexed 0-6
	mov	$0x0, %rax		# Count piece connections - when four we have a player win.
	xorq	%r9, %r9
	xorq	%r8, %r8
	jmp	.CCLD0
.CCLD0:
	cmp	$7, %r14
	je	.CCLD5
	cmp	$-49, %r13
	je	.CCLD5
	lea	(%rbp, %r13), %r15
	add	%r14, %r15
	inc	%r9
	cmpb	$79, (%r15)
	je	.CCLD1
	jne	.CCLD2
.CCLD1:
	inc	%rax
	cmp	$4, %rax
	je	.CCLD6	
	jmp	.CCLD3
.CCLD2:
	mov	$0x0, %rax
	jmp	.CCLD3
.CCLD3:
	inc	%r14
	sub	$7, %r13
	jmp	.CCLD0
.CCLD4:
	ret
.CCLD5:
	xorq	%rax, %rax
	cmp	$0x0, %r14
	je	.CCLD7
	sub	%r9, %r14
	xorq	%r9, %r9
	dec	%r14
	mov	$-7, %r13
	jmp	.CCLD0
.CCLD7:
	cmp	$-49, %r13
	je	.CCLD4
	sub	$-7, %r13
	jmp	.CCLD0
.CCLD6:
	xorq	%r8, %r8
	mov	$1, %r8
	ret

#######################################################################
#
# init_board allocates 42 bytes onto the stack for our game board. In 
# each byte an ascii '_' is placed to indicate a blank for this space. 
#
#######################################################################

	.type init_board, @function
init_board:
	mov	$-42, %rax
	jmp	.IB0
.IB0:
	cmp	$0, %rax 
	je	.IB1
	movb	$95, (%rbp, %rax)
	inc	%rax
	jmp	.IB0
.IB1:
	xorq	%rax, %rax
	ret

#######################################################################
#
# get_board iterates through the 42 byte stack space of the game board
# printing each ascii character found per byte as it goes. Between each
# it prints an ascii '|' for some clarity and QoL. After 7 printfs it 
# prints a newline thus creating the game board you see in stdout. 
#
#######################################################################

	.type get_board, @function
get_board:
	call	clear_screen
	mov	$COLUMN_HEADER, %rdi	
	xorq	%rax, %rax
	call	printf

	mov	$-42, %r8
	mov	$0, %r12
	jmp	.GB0
.GB0:
	cmp	$0x0, %r8
	je	.GB1
	cmp	$7, %r12
	je	.GB2
	mov	$.LC0, %rdi
	movb	(%rbp,%r8),%sil
	xorq	%rax, %rax
	call	printf
	mov	$.LC0, %rdi
	xorq	%rsi, %rsi
	mov	$124, %rsi
	xorq	%rax, %rax
	call	printf
	inc	%r8
	inc	%r12
	jmp	.GB0
.GB2:
	mov	$NEW_LINE, %rdi
	xorq	%rax, %rax
	call	printf
	mov	$.LC0, %rdi
	mov	$124, %rsi
	xorq	%rax, %rax
	call	printf
	mov	$0x0, %r12
	jmp	.GB0
.GB1:
	mov	$NEW_LINE, %rdi
	xorq	%rax, %rax
	call	printf
	ret

	.type press_enter, @function
press_enter:
	movq	$MSG_PRESS_ENTER, %rdi
	movq	$0x0, %rax
	call 	printf
	call	get_string
	ret

	.type get_name, @function
get_name:
	movq	$MSG_QUESTION_2, %rdi
	movq	$0x0, %rax
	call	printf
	
	mov	$name, %rdi
	mov	$16, %rsi
	mov	stdin, %rdx
	call	fgets

	mov	$name, %rdi
	call	strlen

	dec	%rax
	movq	$name, %rbx
	movb	$NULL, (%rbx, %rax)
	ret

        .type clear_screen, @function
clear_screen:
        movq    $CMD_CLEAR, %rdi
        call	system
        ret

        .type display_instructions, @function
display_instructions:
        movq    $MSG_INSTRUCTIONS, %rdi
        xorq	%rax, %rax
        call	printf
        ret
	
	.type init_turns, @function
init_turns:
	movq	$name, %rdi
	xorq	%rax, %rax
	call	printf
	movq	$MSG_QUESTION_1, %rdi
	movq	$0x0, %rax
	call	printf

	mov	$answer, %rdi
	mov	$3, %rsi
	mov	stdin, %rdx
	call	fgets

	mov	$answer, %rdi
	call	strlen

	dec	%rax
	mov	$answer,%rbx
	movb	$NULL, (%rbx, %rax)

	ret
	
	.type get_string, @function
get_string:
	## Call fgets to read from stdin
	movq	$buffer, %rdi
	movq	$256, %rsi
	movq	stdin, %rdx
	call	fgets

	## Call strlen to get length
	movq	$buffer, %rdi
	call	strlen

	## Copy NULL char to where the '\n' is
	dec	%rax
	movq	$buffer, %rbx	
	movb	$NULL, (%rbx, %rax)
	ret
