.data
 msg0: .asciiz "aX2 + bX + c"
 msg1: .asciiz "\nEneter value for A = "
 msg2: .asciiz "\nEneter value for B = "
 msg3: .asciiz "\nEneter value for C = "
 error: .asciiz "\nThis equation has a complex root.\nTry again!!!"
 result: .asciiz "\nThe two value for x = "
 continue: .asciiz "\nEnter 1 to continue Or any other number to quit = "
 an: .asciiz " & "
 zero: .float 0.0
 minus_one: .float -1.0    # to convert number from positive to negetive
 four: .float 4
 two: .float 2
 one: .word 1
.text
 lw $t4,one   # load word address one to $t4

 li $v0,4
 la $a0,msg0
 syscall

 main:
 lwc1 $f3,zero
 lwc1 $f1,minus_one
 lwc1 $f6,two
 lwc1 $f11,four

# display message
 li $v0,4
 la $a0,msg1
 syscall

# ask user to input A
 li $v0,6
 syscall
 mov.s $f9,$f0   # move floating point precision single
# display message
 li $v0,4 
 la $a0,msg2
 syscall

# ask user to input B
 li $v0,6
 syscall
 mov.s $f10,$f0   # move floating point precision single
# display message
 li $v0,4
 la $a0,msg3
 syscall

# ask user to input C
 li $v0,6
 syscall
 mov.s $f8,$f0   # move floating point precision single

 mul.s $f13,$f10,$f10     # b^2
 mul.s $f25,$f10,$f1     # -b value
 mul.s $f15,$f9,$f8    # a*c
 mul.s $f7,$f11,$f15    # 4*a*c
 sub.s $f19,$f13,$f7    # b^2-4*a*c
 mfc1 $t1,$f19          # convert from float to integer
 bltz $t1 cmplxRoot   # branch if less than zero to complexRoot
 sqrt.s $f29,$f19       # sqrt(b^2-4*a*c)
 add.s $f20,$f25,$f29   # -b+sqrt(b^2-4*a*c)
 sub.s $f24,$f25,$f29   # -b-sqrt(b^2-4*a*c)
 mul.s $f18,$f6,$f9     # 2*a
 div.s $f28,$f20,$f18   # (-b+sqrt(b^2-4*a*c))/2*a
 div.s $f30,$f24,$f18   # (-b-sqrt(b^2-4*a*c))/2*a

# to display result
 li $v0,4
 la $a0,result 
 syscall
 
# display result
 li $v0,2
 add.s $f12,$f3,$f28
 syscall
 
# display message
 li $v0,4
 la $a0,an         
 syscall
 
# display result
 li $v0,2
 add.s $f12,$f3,$f30
 syscall
 
# branching operation
 b cnt

# for error message
 cmplxRoot:
 li $v0,4
 la $a0,error   # display Complex Root
 syscall

# jump operation
 j main

# to ask user if to continue
 cnt:   
 li $v0,4
 la $a0,continue
 syscall

# for return operation
 li $v0,5
 syscall
 move $t0,$v0

# loop operation
 beq $t0,$t4,main    # branch to main if input = 1

# exit program
 li $v0,10
 syscall   #system call
