*-----------------------------------------------------------
* Program    :
* Written by : Daniel Maugeri
* Date       :
* Description: This program sorts a text file using Selection sort then searches the file using a binary search
*	       the first number in the text file contains the number of bites for it to read
*-----------------------------------------------------------
	ORG	$1000
START:				; first instruction of program
	lea	file,a1
	move.w	#51,d0
	trap	#15
	
	lea	size,a1		; a1 should contain the address of size
	move.w	#1,d2		; number of bytes to read	
	move.w	#53,d0		; to read first character in file which is size of array 
	trap	#15

	sub.b	#$30,size

	lea	array,a1
	move.b	size,d2
	move.w	#53,d0
	trap	#15
	
	move.w	#56,d0
	trap	#15
	
	move.w	#4,d0
	trap	#15
	move.b	d1,d6
	
	
	JSR	SORT
	JSR	SEARCH
	
	move.w	#13,d0
	trap	#15
		
done	MOVE.B	#9,D0
	TRAP	#15		; halt simulator


SORT	move.w	d2,-(sp)	; outer counter = i
	move.w	d3,-(sp)	; inner counter = j
	move.w	d4,-(sp)	; j - 1
	move.w	d5,-(sp)	 
	move.w	d6,-(sp)	; tmp variable holds a[j]
	move.w	d7,-(sp)	; tmp variable holds a[j-1]
	move.w	a1,-(sp)	; holds array of numbers
	
	lea	array,a1
	move.w	#2,d2		; start outer counter to first element
	
outer	cmp.b	size,d2
	bge	done2
	
	move.b	d2,d3		; j = i

inner	cmp.b	#0,d3		; if j <= 0 end loop
	ble	outEnd		
	
	move.b	d3,d4		; d4 = j
	sub.b	#1,d4		; d4 = j - 1
	
	move.b	(a1,d3),d6	; d6 = a[j]
	move.b	(a1,d4),d7	; d7 = a[j-1]
	
	cmp.b	d7,d6		; if a[j] < a[j-1] swap
	blt	swap
	bra	noswap
	
swap	move.b	(a1,d3),d5	; d5 = a[j]
	move.b	(a1,d4),(a1,d3)	; a[j] = a[j-1]
	move.b	d5,(a1,d4)	; a[j-1] = a[j]

noswap	sub.b	#1,d3		; decrements inner loop and repeats
	bra	inner
	
outEnd	add.b	#1,d2		; increments outer loop and repeats
	bra	outer
	
done2	move.w	(sp)+,a1
	move.w	(sp)+,d7
	move.w	(sp)+,d6
	move.w	(sp)+,d5
	move.w	(sp)+,d4
	move.w	(sp)+,d3
	move.w	(sp)+,d2
	RTS
	
SEARCH	move.w	d2,-(sp)	; left value
	move.w	d3,-(sp)	; right value
	move.w	d4,-(sp)	; mid value
	move.w	d5,-(sp)	; tmp
	move.w	d7,-(sp)
	
	lea	array,a2
	add.l	#$30,d6
	
	move.b	#0,d2
	move.b	size,d3
	
loop	cmp.b	d3,d2
	bgt	nfound
	;find mid
	move.w	d3,d5
	add.w	d2,d5		; tmp = left + right		
	divu.w	#2,d5		; tmp = (left + right)/2
	move.b	d5,d4		; mid = tmp (make sure mid has only a byte)
	
	; if a[mid] = value (then value is found in the array)
	cmp.b	(a2,d4),d6
	beq	found
	; if value < a[mid] go to rightS
	; right := mid - 1
	cmp.b	(a2,d4),d6
	blt	rightS
	; else
	; left := mid + 1
	add.b	#1,d4	; mid = mid + 1
	move.b	d4,d2	; mid = left
	bra	loop
	
rightS	sub.b	#1,d4
	move.b	d4,d3
	bra	loop

found	lea	foundM,a1
	bra	finishL
	
nfound	lea	foundME,a1
	bra	finishL

finishL	move.w	(sp)+,d7
	move.w	(sp)+,d5
	move.w	(sp)+,d4
	move.w	(sp)+,d3
	move.w	(sp)+,d2
	RTS


* Variables and Strings
file	dc.b	'numbers.txt',0
foundM	dc.b	'Found',0
foundME	dc.b	'Not Found',0
array	ds.b	9
size	ds.b	1
	END	START		; last line of source



*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~8~
