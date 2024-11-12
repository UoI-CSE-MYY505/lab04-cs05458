
.globl str_ge, recCheck

.data

maria:    .string "Maria"
markos:   .string "Markos"
marios:   .string "Marios"
marianna: .string "Marianna"

.align 4  # make sure the string arrays are aligned to words (easier to see in ripes memory view)

# These are string arrays
# The labels below are replaced by the respective addresses
arraySorted:    .word maria, marianna, marios, markos

arrayNotSorted: .word marianna, markos, maria

.text

            la   a0, arrayNotSorted
            li   a1, 4
            jal  recCheck

            li   a7, 10
            ecall

str_ge:
#---------
# Write the subroutine code here
#  You may move jr ra   if you wish.
#---------
            loop:
                addi a0, a0,1
                 addi a1, a1,1
                #load the two current chars
                lbu t0, -1(a0)
                lbu t1, -1(a1)
                bne t0,t1,diff
                bne t0, zero, loop
                ge:
                addi a0, zero, 1
                jr ra
            diff:
                bge t0, t1, ge
                 add a0, zero, zero
                jr   ra
 
# ----------------------------------------------------------------------------
# recCheck(array, size)
# if size == 0 or size == 1
#     return 1
# if str_ge(array[1], array[0])      # if first two items in ascending order,
#     return recCheck(&(array[1]), size-1)  # check from 2nd element onwards
# else
#     return 0

recCheck:
#---------
# Write the subroutine code here
#  You may move jr ra   if you wish.
#---------
            addi t0,zero,2
            bge a1,t0,cmp
            addi a0, zero, 1
            jr ra
            cmp:
                addi sp, sp,-12
                sw ra, 8(sp)
                sw a1, 4(sp)
                sw a0, 0(sp)
                lw a1, 0(a0)
                lw a0, 4(a0) 
                jal str_ge
                bne a0,zero, next
                add a0, zero,zero
                lw ra, 8(sp)
                addi sp, sp,12
                jr ra
                next: 
                 lw a1, 4(sp)
                 lw a0, 0(sp)
                 addi sp, sp, 8
                 addi a0, a0, 4
                 addi a1, a1, -1
                 jal recCheck
                 lw ra, 0(sp)
                 addi sp, sp, 4                 
                 jr   ra
