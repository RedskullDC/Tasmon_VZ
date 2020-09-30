
; Specify target machine

;#DEFINE TRS80
#DEFINE VZ

; Routines which exist in both TRS-80 Level2 and VZ200/300:

Delay			.equ 0060H	; General purpose delay routine. count down BC register. Not called in VZ??
ROM_KBD_Routine		.equ 0013H	; Reads KBD via DCB
DRIVER_EXIT		.equ 03DDH	; restore regs after DCB call, then return to caller

;-------------------------------------------------------------------

; Routines in both, but relocated

#IFDEF TRS80

.org 6000h
								
Cassette_Off		.equ 01F8H					; no equivalent		; commented out by IFDEF on VZ
Select_Cass_Unit	.equ 0212H					; no equivalent		; commented out by IFDEF on VZ
CASS_READ_BYTE		.equ 0235H					; 3775h
CASS_WRITE_BYTE		.equ 0264H					; 3511h
Cass_Find_Sync		.equ 0296H					; 3B68h
Blink_Asterisk		.equ 022CH					; no equivalent		; commented out by IFDEF on VZ
Write_Leader_Sync	.equ 0287H					; 3558h
									; 
SCREEN_START		.equ 3C00H					; 7000h			; TRS-80 Screen is 1024 bytes 
RAM_START		.equ 4000H					; 7200h			; First location after screen mem. ($7200 on a stock VZ, $7800 on 64x32 VZ)
LINE_LEN		.equ 64						; 32			; 64 chars long on TRS-80, or 64x32 VZ
SCREEN_LEN		.equ (RAM_START - SCREEN_START)			; 0200h			; ($400 long on a Model 1, $800 on 64x32 VZ300)
SCREEN_LINES		.equ (RAM_START - SCREEN_START)/LINE_LEN	; 32 on a 64x32 screen on Laser310_FPGA, 16 on VZ/TRS-80

SCREEN_OVERFLOW		.equ ((RAM_START >> 8) & 0FFH)			; High byte of RAM START. Set to $72 on stock VZ

L2_PRINTER_DCB		.equ 4025H					; 7825h
PRINT_CONTROL		.equ 37E8h					; Port 00h              ; Call 5C4h to test printer
#ENDIF


#IFDEF VZ

.org 8000h

;Cassette_Off		.equ no equivalent				; commented out by IFDEF on VZ
;Select_Cass_Unit	.equ no equivalent				; commented out by IFDEF on VZ
CASS_READ_BYTE		.equ 3775h
CASS_WRITE_BYTE		.equ 3511h
Cass_Find_Sync		.equ 3B68h
;Blink_Asterisk		.equ no equivalent				; commented out by IFDEF on VZ
Write_Leader_Sync	.equ 3558h

SCREEN_START		.equ 7000h					; TRS-80 Screen is 1024 bytes, Stock VZ = 512, 64x32 VZ = 2048
RAM_START		.equ 7800h					; First location after screen mem. ($7200 on a stock VZ, $7800 on 64x32 VZ)
LINE_LEN		.equ 64						; 32 on Stock VZ. 64 chars long on TRS-80, or 64x32 VZ
SCREEN_LEN		.equ (RAM_START - SCREEN_START)			; ($200 on stock VZ, $400 long on a Model 1, $800 on 64x32 VZ300)
SCREEN_LINES		.equ (RAM_START - SCREEN_START)/LINE_LEN	; 32 on a 64x32 screen on Laser310_FPGA, 16 on Stock VZ/TRS-80

SCREEN_OVERFLOW		.equ ((RAM_START >> 8) & 0FFH)			; High byte of RAM START. Set to $72 on stock VZ

L2_PRINTER_DCB		.equ 7825h
PRINT_CONTROL		.equ 00h					; PORT 00h   Call 5C4h to test printer on VZ
#ENDIF

;-------------------------------------------------------------------

; TRS-80 only: 

ROM_DISPLAY_Routine	.equ 001BH	; VZ doesn't use display DCB properly
sub_3FE			.equ 03FEH	; jumps midway into kbd routine :o(
CONVERT_LCASE		.equ 047BH
OUTPUT_CHAR		.equ 047DH
CHECK_GRAPHIC		.equ 04A6H
PROCESS_CONTROL		.equ 0506H	; process screen handling, control chars. return via $480
ROM_PRT_DRIVER		.equ 058DH

KBD_ROW_01		.equ 3801H	; keyboard locations. Keyboard totally different in VZ/LASER
KBD_ROW_40		.equ 3840H


L2_VIDEO_DCB		.equ 401DH	; Video DCB ignored by VZ.  *CAREFUL* here
NEXT_CHAR_ADD_L2	.equ 4020H	; Video DCB ignored by VZ.  *CAREFUL* here


KBD_work_area		.equ 4036H
Display_Control		.equ 403DH	; Upper/Lower Case

RST28_Vector		.equ 400CH	; 780Ch			; Not used in VZ?
Cursor_ON_OFF		.equ 4022H	; Video DCB ignored by VZ.  *CAREFUL* here
MEM_SIZE		.equ 4049H

DOS_INIT		.equ 4420H	; INIT creates a new file in the directory and opens the DCB for this file. 
DOS_OPEN		.equ 4424H	; OPEN opens the DCB of an existing file
DOS_CLOSE		.equ 4428H	; CLOSE: Closes a file. Updates the directory and then closes the file from any more processing.

;-------------------------------------------------------------------------------------------------------

; Routines with hardcoded values in original (in addition to references above): 

; sub_60FF:
; 610E 21 28 3C                    ld      hl,  SCREEN_START+28h	; 3C28h
; 611A 21 30 3C                    ld      hl,  SCREEN_START+30h	; 3C30h

; SHOW_REGS:
; 636B 21 28 3C                    ld      hl,  SCREEN_START+28h	; 3C28h
; 6379 21 27 3C                    ld      hl,  SCREEN_START+27h	; 3C27h

; 67FE 11 F0 00                    ld      de, 0F0h			; '-' means display *previous* page
; 680A 06 08                       ld      b, 8				; 8 chars
; 696D 21 E8 3D                    ld      hl,  SCREEN_START+1E8h
; 
; 6998 3E 07                       ld      a, 7				; last 7 lines
; 699A 21 28 3E                    ld      hl,  SCREEN_START+228h
; 69A6 01 18 00                    ld      bc, 24
; 69AF 21 E8 3F                    ld      hl,  SCREEN_START+3E8h
; 69BA 21 E8 3F                    ld      hl,  SCREEN_START+3E8h
; 
; 6A51 3A 40 38                    ld      a, (KBD_ROW_40)
; 6A7F 3A 40 38                    ld      a, (KBD_ROW_40)
; 
; 792E 3A E8 37                    ld      a, (37E8h)			; check printer
; 
; 
; 79B7 01 01 38                    ld      bc, KBD_ROW_01		; kbd code needs major re-work

;-------------------------------------------------------------------------------------------------------

; Routines with hardcoded values now fixxxed!

; 66F4 01 0F 00                    ld      bc, 15          ; disassemble next *15* instructions
; 6713 06 1E                       ld      b, 30           ; disassemble previous 30 instructions to go pack a page
; 67EA 0E 0F                       ld      c, 15           ; Display 15 lines
; Scroll_savregs:
; 6984 01 40 00                    ld      bc, 64
; 698F FE 40                       cp      40h ; '@'       ; Are we off the end of the screen?
; 69A1 01 40 00                    ld      bc, 64

; 793B 0E 10                       ld      c, 16           ; 16 lines
; 793D 06 40                       ld      b, 64           ; 64 chars per line


;-------------------------------------------------------------------------------------------------------


TASMON_ENTRY:
                di
                call    CLEAR_VIDEO
                ld      hl, (NEXT_CHAR_ADD_L2)		; L2 Video DCB next char address $3C00<=X<=$3FFF
                ld      (NEXT_CHAR_ADD_SAVE), hl	; save video DCB next character address when calling program
                ld      sp, a_IXplus
                xor     a
                ld      (Cursor_ON_OFF), a
                ld      (Cursor_ON_OFF_SAVE), a
                call    clear_all_breakpoints
                ld      hl, TasmonVer222 ; "TASMON  VER 2.22\n(C) 1981 by Bruce G. "...
                ld      a, 1
                ld      (dis_DISPLAY_FLG), a
                call    SHOW_INSTR_HDR
                call    SET_EXEC1_to_1  ; default all breakpoints to 1 execution only
                call    SHOW_REGS
                call    SET_PROMPT_POS
                call    SCROLL_SAVEREGS ; save all regs and scroll down

loc_602E:                               ; CODE XREF: GET_CHAR-B0↓j
                call    GET_COMMAND
                call    SCROLL_SAVEREGS ; save all regs and scroll down

loc_6034:                               ; CODE XREF: GET_CHAR+14↓j
                di
                ld      sp, a_IXplus
                jr      loc_602E

; =============== S U B R O U T I N E =======================================


GET_COMMAND:                            ; CODE XREF: GET_CHAR:loc_602E↑p

                ld      a, 5Eh ; '^'	; => right arrow on Model 1
                call    TAS_VID_DRIVER
                ld      a, 1
                ld      (dis_DISPLAY_FLG), a

unknown_command:                        ; CODE XREF: GET_COMMAND+AB↓j
                call    GET_CHAR        ; get character, return in A
                cp      1Fh
                jr      nz, loc_6054
                call    CLEAR_VIDEO
                call    SET_PROMPT_POS
                jp      SHOW_REGS
; ---------------------------------------------------------------------------

loc_6054:                               ; CODE XREF: GET_COMMAND+F↑j
                cp      'I'
                jp      z, single_step
                cp      'G'
                jp      z, goto
                cp      'D'
                jp      z, disassemble
                cp      'B'
                jp      z, breakpoints
                cp      'C'
                jp      z, clear_breakpoints
                cp      'M'
                jp      z, modify_memory
                cp      'R'
                jp      z, replace_reg_pair
                cp      0Ah
                jp      z, loc_6740
                cp      'F'
                jp      z, find_search_key
                cp      'A'
                jp      z, ascii_dump
                cp      'H'
                jp      z, hex_dump
                cp      'E'
                jp      z, exit_tasmon
                cp      'T'
                jp      z, trace
                cp      'S'
                jp      z, subtract_add
                cp      'P'
                jp      z, disassem_to_printer
                cp      'L'
                jp      z, load_cmd_file
                cp      'W'
                jp      z, write_tape_disk
                cp      9
                jp      z, loc_77C3
                cp      8
                jp      z, loc_77DA
                cp      'O'
                jp      z, output_disassembly
                cp      'X'
                jp      z, relocate_memory
                cp      'Y'
                jp      z, block_move
                cp      'Z'
                jp      z, set_memory
                cp      'V'
                jp      z, view_file_info
                cp      'J'
                jp      z, toggle_restarts
                cp      'K'
                jp      z, keep_screen
                cp      'N'
                jp      z, number_or_executions
                cp      'Q'             ; new command in V2.22
                jp      z, Q_command
                cp      'U'
                jp      z, return_from_user
                jp      unknown_command
; End of function GET_COMMAND


; =============== S U B R O U T I N E =======================================

; get character, return in A

GET_CHAR:                               ; CODE XREF: GET_COMMAND:unknown_command↑p
                                        ; GET_COMMAND:reg_char_error↓p ...

                call    SAVE_REGS_GET_CHAR
                cp      2Ah ; '*'	; Asterisk == perform Screen Dump
                call    z, SCREEN_DUMP	; dump current screen contents to printer
                cp      1
                ret     nz

return_from_user:                       ; CODE XREF: GET_COMMAND+A8↑j
                                        ; sub_60FF+4↓j ...
                ld      sp, a_IXplus
                call    SHOW_REGS
                call    SCROLL_SAVEREGS ; save all regs and scroll down
                jp      loc_6034

; =============== S U B R O U T I N E =======================================


sub_60FF:                               ; CODE XREF: sub_6745:loc_6749↓p
                ld      a, (byte_7EEB)
                or      a
                jr      nz, return_from_user
                ld      hl, (reg_PC)
                call    HL_to_HEX
                call    SPC_VID_OUT     ; Output a SPC to video and return to caller
                ld      hl, SCREEN_START+28h	; 3C28h
                ld      b, 5

loc_6113:                               ; CODE XREF: sub_60FF+19↓j
                ld      a, (hl)
                call    TAS_VID_DRIVER
                inc     hl
                djnz    loc_6113
                ld      hl, SCREEN_START+30h	; 3C30h
                ld      b, 0Ah

loc_611F:                               ; CODE XREF: sub_60FF+25↓j
                ld      a, (hl)
                call    TAS_VID_DRIVER
                inc     hl
                djnz    loc_611F
                ld      a, (byte_7B8D)
                or      a
                ld      hl, (reg_PC)
                jr      nz, loc_6177

loc_612F:                               ; CODE XREF: sub_60FF+FC↓j
                                        ; sub_60FF+14C↓j
                ld      a, (byte_7BB4)
                ld      b, a
                ld      de, byte_7BAD

loc_6136:                               ; CODE XREF: sub_60FF+3B↓j
                ld      a, (hl)
                inc     hl
                ld      (de), a
                inc     de
                djnz    loc_6136
                ld      (word_7B94), hl
                ld      a, 0CDh
                ld      (de), a
                push    de
                inc     de
                ld      hl, BREAKPOINT_RETURN
                ld      a, l
                ld      (de), a
                inc     de
                ld      a, h
                ld      (de), a
                ld      hl, (reg_SP)
                dec     hl
                push    hl
                ld      hl, byte_7BAD
                ld      (reg_PC), hl
                call    LOAD_BREAKPOINTS ; save existing code, and insert breakpoint traps in target code.
                call    sub_62CC
                call    RESTORE_BREAKPOINTS ; remove breakpoints, and re-insert original code
                pop     bc
                pop     de
                ld      hl, (reg_PC)
                or      a
                sbc     hl, de
                ld      hl, (word_7B94)
                jr      z, loc_6173
                ld      a, h
                ld      (bc), a
                dec     bc
                ld      a, l
                ld      (bc), a
                ret
; ---------------------------------------------------------------------------

loc_6173:                               ; CODE XREF: sub_60FF+6C↑j
                ld      (reg_PC), hl
                ret
; ---------------------------------------------------------------------------

loc_6177:                               ; CODE XREF: sub_60FF+2E↑j
                cp      1
                jr      nz, loc_6184

loc_617B:                               ; CODE XREF: sub_60FF+90↓j
                inc     hl
                ld      e, (hl)
                inc     hl
                ld      d, (hl)
                ex      de, hl
                ld      (reg_PC), hl
                ret
; ---------------------------------------------------------------------------

loc_6184:                               ; CODE XREF: sub_60FF+7A↑j
                cp      2
                jr      nz, loc_6198
                ld      b, (hl)
                ld      a, (reg_AF)
                call    sub_6278
                jr      nz, loc_617B

loc_6191:                               ; CODE XREF: sub_60FF+127↓j
                inc     hl
                inc     hl
                inc     hl
                ld      (reg_PC), hl
                ret
; ---------------------------------------------------------------------------

loc_6198:                               ; CODE XREF: sub_60FF+87↑j
                cp      3
                jr      nz, loc_61B0

loc_619C:                               ; CODE XREF: sub_60FF+BC↓j
                                        ; sub_60FF+D2↓j
                inc     hl
                ld      (GEN_PTR_16), hl
                xor     a
                ld      (dis_DISPLAY_FLG), a
                call    sub_71F5
                ld      a, 1
                ld      (dis_DISPLAY_FLG), a
                ld      (reg_PC), hl
                ret
; ---------------------------------------------------------------------------

loc_61B0:                               ; CODE XREF: sub_60FF+9B↑j
                cp      4
                jr      nz, loc_61C3
                ld      a, (reg_BC+1)
                dec     a
                ld      (reg_BC+1), a
                jr      nz, loc_619C

loc_61BD:                               ; CODE XREF: sub_60FF+D4↓j
                inc     hl
                inc     hl
                ld      (reg_PC), hl
                ret
; ---------------------------------------------------------------------------

loc_61C3:                               ; CODE XREF: sub_60FF+B3↑j
                cp      5
                jr      nz, loc_61D5
                ld      a, (hl)
                and     18h
                ld      b, a
                ld      a, (reg_AF)
                call    sub_6278
                jr      nz, loc_619C
                jr      loc_61BD
; ---------------------------------------------------------------------------

loc_61D5:                               ; CODE XREF: sub_60FF+C6↑j
                cp      6
                jr      nz, loc_61F3
                ld      a, (hl)
                cp      0E9h
                jr      nz, loc_61E5
                ld      hl, (reg_HL)

loc_61E1:                               ; CODE XREF: sub_60FF+ED↓j
                                        ; sub_60FF+F2↓j
                ld      (reg_PC), hl
                ret
; ---------------------------------------------------------------------------

loc_61E5:                               ; CODE XREF: sub_60FF+DD↑j
                cp      0DDh
                jr      nz, loc_61EE
                ld      hl, (reg_IX)	; register IX save area
                jr      loc_61E1
; ---------------------------------------------------------------------------

loc_61EE:                               ; CODE XREF: sub_60FF+E8↑j
                ld      hl, (reg_IY)	; register IY save area
                jr      loc_61E1
; ---------------------------------------------------------------------------

loc_61F3:                               ; CODE XREF: sub_60FF+D8↑j
                cp      7
                jr      nz, loc_6219

loc_61F7:                               ; CODE XREF: sub_60FF+125↓j
                ld      a, (byte_7B8E)
                or      a
                jp      z, loc_612F
                inc     hl
                ld      e, (hl)
                inc     hl
                ld      d, (hl)
                inc     hl
                ld      (reg_PC), de
                ld      (STACK_SAVE), sp
                ld      sp, (reg_SP)
                push    hl
                ld      (reg_SP), sp
                ld      sp, (STACK_SAVE)
                ret
; ---------------------------------------------------------------------------

loc_6219:                               ; CODE XREF: sub_60FF+F6↑j
                cp      8
                jr      nz, loc_6229
                ld      b, (hl)
                ld      a, (reg_AF)
                call    sub_6278
                jr      nz, loc_61F7
                jp      loc_6191
; ---------------------------------------------------------------------------

loc_6229:                               ; CODE XREF: sub_60FF+11C↑j
                cp      9
                jr      nz, loc_6243

loc_622D:                               ; CODE XREF: sub_60FF+172↓j
                ld      (STACK_SAVE), sp
                ld      sp, (reg_SP)
                pop     de
                ld      (reg_SP), sp
                ld      (reg_PC), de
                ld      sp, (STACK_SAVE)
                ret
; ---------------------------------------------------------------------------

loc_6243:                               ; CODE XREF: sub_60FF+12C↑j
                cp      0Bh
                jr      nz, loc_626A
                ld      a, (RESTARTS_STYLE)
                or      a
                jp      z, loc_612F
                ld      a, (hl)
                and     38h ; '8'
                ld      (STACK_SAVE), sp
                ld      sp, (reg_SP)
                inc     hl
                push    hl
                ld      (reg_SP), sp
                ld      sp, (STACK_SAVE)
                ld      l, a
                ld      h, 0
                ld      (reg_PC), hl
                ret
; ---------------------------------------------------------------------------

loc_626A:                               ; CODE XREF: sub_60FF+146↑j
                ld      b, (hl)
                ld      a, (reg_AF)
                call    sub_6278
                jr      nz, loc_622D
                inc     hl
                ld      (reg_PC), hl
                ret
; End of function sub_60FF


; =============== S U B R O U T I N E =======================================


sub_6278:                               ; CODE XREF: sub_60FF+8D↑p
                                        ; sub_60FF+CF↑p ...
                ld      c, a
                ld      a, b
                and     38h ; '8'
                cp      0
                jr      nz, loc_6286
                bit     6, c
                jr      z, loc_62C8
                jr      loc_62C6
; ---------------------------------------------------------------------------

loc_6286:                               ; CODE XREF: sub_6278+6↑j
                cp      8
                jr      nz, loc_6290
                bit     6, c
                jr      nz, loc_62C8
                jr      loc_62C6
; ---------------------------------------------------------------------------

loc_6290:                               ; CODE XREF: sub_6278+10↑j
                cp      10h
                jr      nz, loc_629A
                bit     0, c
                jr      z, loc_62C8
                jr      loc_62C6
; ---------------------------------------------------------------------------

loc_629A:                               ; CODE XREF: sub_6278+1A↑j
                cp      18h
                jr      nz, loc_62A4
                bit     0, c
                jr      nz, loc_62C8
                jr      loc_62C6
; ---------------------------------------------------------------------------

loc_62A4:                               ; CODE XREF: sub_6278+24↑j
                cp      20h ; ' '
                jr      nz, loc_62AE
                bit     2, c
                jr      z, loc_62C8
                jr      loc_62C6
; ---------------------------------------------------------------------------

loc_62AE:                               ; CODE XREF: sub_6278+2E↑j
                cp      28h ; '('
                jr      nz, loc_62B8
                bit     2, c
                jr      nz, loc_62C8
                jr      loc_62C6
; ---------------------------------------------------------------------------

loc_62B8:                               ; CODE XREF: sub_6278+38↑j
                cp      30h ; '0'
                jr      nz, loc_62C2
                bit     7, c
                jr      z, loc_62C8
                jr      loc_62C6
; ---------------------------------------------------------------------------

loc_62C2:                               ; CODE XREF: sub_6278+42↑j
                bit     7, c
                jr      nz, loc_62C8

loc_62C6:                               ; CODE XREF: sub_6278+C↑j
                                        ; sub_6278+16↑j ...
                xor     a
                ret
; ---------------------------------------------------------------------------

loc_62C8:                               ; CODE XREF: sub_6278+A↑j
                                        ; sub_6278+14↑j ...
                ld      a, 1
                or      a
                ret
; End of function sub_6278


; =============== S U B R O U T I N E =======================================


sub_62CC:

                ld      (STACK_SAVE), sp
                ld      sp, USER_REGS			; set stack to user regs area, then pop them off below
                ld      hl, (NEXT_CHAR_ADD_SAVE)
                ld      (NEXT_CHAR_ADD_L2), hl		; L2 Video DCB next char address $3C00<=X<=$3FFF
                ld      a, (Cursor_ON_OFF_SAVE)
                ld      (Cursor_ON_OFF), a
                ld      a, (KEEP_SCREEN_STATE)		; 0 = keep screen off, 1 = keep screen on
                or      a
                jr      z, load_user_regs
                ld      de, SCREEN_START
                ld      hl, (USER_SCREEN_ptr)		; ptr to user supplied $400 byte screen area
                ld      bc, SCREEN_LEN			; 400h
                ldir

load_user_regs:
                pop     ix
                pop     iy
                pop     af
                pop     bc
                pop     de
                pop     hl
                exx
                ex      af, af'
                pop     af
                pop     bc
                pop     de
                pop     hl
                ld      (GEN_PTR_16), hl
                pop     hl
                ld      (dis_DISASSEM_START), hl
                pop     hl
                ld      (dis_NUM_INSTRS), hl
                ld      sp, (dis_DISASSEM_START)
                ld      hl, (dis_NUM_INSTRS)
                push    hl
                ld      hl, (GEN_PTR_16)
                ret
; End of function sub_62CC

; ---------------------------------------------------------------------------

BREAKPOINT_RETURN:                      ; DATA XREF: sub_60FF+45↑o
                                        ; LOAD_BREAKPOINTS+1E↓o
                ld      (BP_STACK_SAVE), sp
                ld      sp, reg_SP		; set stack above user reg save area, then push them below
                push    hl
                ld      hl, (NEXT_CHAR_ADD_L2) ; L2 Video DCB next char address $3C00<=X<=$3FFF
                ld      (NEXT_CHAR_ADD_SAVE), hl
                push    de
                push    bc
                push    af
                ex      af, af'
                exx
                push    hl
                push    de
                push    bc
                push    af
                push    iy
                push    ix
                ld      sp, (BP_STACK_SAVE)
                pop     hl
                dec     hl
                dec     hl
                dec     hl
                ld      (reg_PC), hl
                ld      (reg_SP), sp
                ld      sp, (STACK_SAVE)
                ld      hl, (NEXT_CHAR_ADD_TM)
                ld      (NEXT_CHAR_ADD_L2), hl ; L2 Video DCB next char address $3C00<=X<=$3FFF
                ld      a, (Cursor_ON_OFF)
                ld      (Cursor_ON_OFF_SAVE), a
                xor     a
                ld      (Cursor_ON_OFF), a
                ld      a, (KEEP_SCREEN_STATE) ; 0 = keep screen off, 1 = keep screen on
                or      a
                ret     z
                ld      hl, SCREEN_START
                ld      bc, SCREEN_LEN		; 400h
                ld      de, (USER_SCREEN_ptr) ; ptr to user supplied $400 byte screen area
                ldir
                ret

; =============== S U B R O U T I N E =======================================


SHOW_REGS:
		ld      hl, (NEXT_CHAR_ADD_TM)
                ld      (SAVE_CURSOR), hl
                ld      hl, SCREEN_START+28h		; 3C28h
                ld      (NEXT_CHAR_ADD_L2), hl		; L2 Video DCB next char address $3C00<=X<=$3FFF
                ld      (NEXT_CHAR_ADD_TM), hl
                ld      a, 1Eh				; clear to EOL
                call    TAS_VID_DRIVER
                ld      hl, SCREEN_START+27h		; 3C27h
                ld      (NEXT_CHAR_ADD_L2), hl		; L2 Video DCB next char address $3C00<=X<=$3FFF
                ld      hl, (reg_PC)
                ld      bc, 1				; disassemble *1* instruction
                ld      a, 1
                ld      (byte_7BA6), a
                call    DISASSEMBLE
                ld      (byte_7BB4), a
                call    SCROLL_SAVEREGS ; save all regs and scroll down
                xor     a
                ld      (byte_7BA6), a
                ld      hl, REG_ASCII_LAYOUT ; IX IY AF' BC' DE' HL'  AF BC DE HL SP PC
                ld      de, USER_REGS   ; user register save area
                ld      (GEN_PTR_16), de

show_reg_cont: 
                ld      b, 4		; 4 bytes of register name displayed
reg_hdr:        ld      a, (hl)
                inc     hl
                call    TAS_VID_DRIVER
                djnz    reg_hdr		
                ex      de, hl
                call    sub_7173
                call    inc_PTR_16
                ex      de, hl
                call    SPC_VID_OUT     ; Output a SPC to video and return to caller
                call    TAS_VID_DRIVER
                dec     hl
                ld      a, (hl)
                inc     hl
                cp      80h
                jr      nz, show_reg_cont
                call    SCROLL_SAVEREGS		; save all regs and scroll down
                ld      a, (hl)
                cp      80h			; Double 80h signifies end of reg hdr
                jr      nz, show_reg_cont
                ld      b, 8
                ld      a, (reg_AF)  ; LD a with saved F register
                ld      hl, FLAGS		; flags in display format

flags_continue:					; CODE XREF: SHOW_REGS+78↓j
                push    hl
                rla
                jr      c, flag_set
                inc     hl              ; flag not set. show '-' instead

flag_set:                               
                ld      c, a
                ld      a, (hl)
                pop     hl
                inc     hl
                inc     hl
                call    TAS_VID_DRIVER
                ld      a, c
                djnz    flags_continue
                call    SPC_VID_OUT     ; Output a SPC to video and return to caller
                call    SPC_VID_OUT     ; Output a SPC to video and return to caller
                ld      hl, HL_ascii    ; Text for (HL)
                call    SHOW_INSTR_HDR
                call    SPC_VID_OUT     ; Output a SPC to video and return to caller
                call    SPC_VID_OUT     ; Output a SPC to video and return to caller
                ld      hl, (reg_HL)
                ld      a, (hl)
                call    sub_7147
                ld      hl, (SAVE_CURSOR)
                ld      (NEXT_CHAR_ADD_TM), hl
                ret

; ---------------------------------------------------------------------------

replace_reg_pair:                      
                call    OUT_CHAR_SPC    ; output char in A, followed by a space to vid and return

reg_char_error:                         
                call    GET_CHAR        ; get character, return in A
                cp      'P'
                jr      z, replace_PC
                cp      'S'
                jr      z, replace_SP
                cp      'I'
                jr      z, replace_IX_IY
                cp      'A'
                jr      z, replace_AF
                cp      'B'
                jr      z, replace_BC
                cp      'D'
                jr      z, replace_DE
                cp      'H'
                jr      nz, reg_char_error
                call    TAS_VID_DRIVER
                ld      b, 12h
                ld      a, 4Ch ; 'L'
                jr      loc_646B
; ---------------------------------------------------------------------------

replace_PC:                             ; CODE XREF: GET_COMMAND+3CD↑j
                call    TAS_VID_DRIVER
                ld      b, 16h
                ld      a, 43h ; 'C'
                jr      loc_648D
; ---------------------------------------------------------------------------

replace_SP:                             ; CODE XREF: GET_COMMAND+3D1↑j
                call    TAS_VID_DRIVER
                ld      b, 14h
                ld      a, 50h ; 'P'
                jr      loc_648D
; ---------------------------------------------------------------------------

replace_IX_IY:                          ; CODE XREF: GET_COMMAND+3D5↑j
                call    TAS_VID_DRIVER

loc_643F:                               ; CODE XREF: GET_COMMAND+40E↓j
                call    GET_CHAR        ; get character, return in A
                cp      58h ; 'X'
                jr      z, loc_644E
                cp      59h ; 'Y'
                jr      nz, loc_643F
                ld      b, 2
                jr      loc_648D
; ---------------------------------------------------------------------------

loc_644E:                               ; CODE XREF: GET_COMMAND+40A↑j
                ld      b, 0
                jr      loc_648D
; ---------------------------------------------------------------------------

replace_AF:                             ; CODE XREF: GET_COMMAND+3D9↑j
                call    TAS_VID_DRIVER
                ld      b, 0Ch
                ld      a, 46h ; 'F'
                jr      loc_646B
; ---------------------------------------------------------------------------

replace_BC:                             ; CODE XREF: GET_COMMAND+3DD↑j
                call    TAS_VID_DRIVER
                ld      b, 0Eh
                ld      a, 43h ; 'C'
                jr      loc_646B
; ---------------------------------------------------------------------------

replace_DE:                             ; CODE XREF: GET_COMMAND+3E1↑j
                call    TAS_VID_DRIVER
                ld      b, 10h
                ld      a, 45h ; 'E'

loc_646B:                               ; CODE XREF: GET_COMMAND+3EE↑j
                                        ; GET_COMMAND+41F↑j ...
                call    TAS_VID_DRIVER

loc_646E:                               ; CODE XREF: GET_COMMAND+43B↓j
                call    GET_HEX_CHAR
                jr      z, loc_6482
                cp      27h ; '''       ; alt reg
                jr      nz, loc_646E
                call    TAS_VID_DRIVER
                ld      a, b
                sub     8
                ld      b, a
                ld      a, 20h ; ' '
                jr      loc_6492
; ---------------------------------------------------------------------------

loc_6482:                               ; CODE XREF: GET_COMMAND+437↑j
                push    af
                call    SPC_VID_OUT     ; Output a SPC to video and return to caller
                pop     af
                push    bc
                call    HEX_VAL_to_HL   ; 4 byte hex value to HL register
                jr      loc_6499
; ---------------------------------------------------------------------------

loc_648D:                               ; CODE XREF: GET_COMMAND+3F7↑j
                                        ; GET_COMMAND+400↑j ...
                call    TAS_VID_DRIVER
                ld      a, 20h ; ' '

loc_6492:                               ; CODE XREF: GET_COMMAND+446↑j
                call    TAS_VID_DRIVER
                push    bc
                call    HEX_to_HL       ; get 4 digit hex value into the HL register

loc_6499:                               ; CODE XREF: GET_COMMAND+451↑j
                push    hl
                pop     de
                pop     bc
                ld      c, b
                ld      b, 0
                ld      hl, USER_REGS   ; user register save area
                add     hl, bc
                ld      (hl), e
                inc     hl
                ld      (hl), d
                jp      SHOW_REGS
; ---------------------------------------------------------------------------

modify_memory:                          ; CODE XREF: GET_COMMAND+35↑j
                call    OUT_CHAR_SPC    ; output char in A, followed by a space to vid and return

loc_64AC:                               ; CODE XREF: GET_COMMAND+47B↓j
                call    GET_CHAR        ; get character, return in A
                cp      41h ; 'A'
                jr      z, loc_64BD
                cp      48h ; 'H'
                jr      nz, loc_64AC
                call    TAS_VID_DRIVER
                xor     a
                jr      loc_64C2
; ---------------------------------------------------------------------------

loc_64BD:                               ; CODE XREF: GET_COMMAND+477↑j
                call    TAS_VID_DRIVER
                ld      a, 1

loc_64C2:                               ; CODE XREF: GET_COMMAND+481↑j
                ld      (HEX_ASCII_FLAG), a
                call    SPC_VID_OUT     ; Output a SPC to video and return to caller
                call    GET_HEX_ADDRESS
                jr      loc_64D0
; ---------------------------------------------------------------------------

loc_64CD:                               ; CODE XREF: GET_COMMAND+4C7↓j
                call    HL_to_HEX

loc_64D0:                               ; CODE XREF: GET_COMMAND+491↑j
                call    SPC_VID_OUT     ; Output a SPC to video and return to caller
                ld      a, (hl)
                cp      20h ; ' '
                jr      c, loc_64E4
                cp      7Fh
                jr      nc, loc_64E4
                call    TAS_VID_DRIVER
                call    SPC_VID_OUT     ; Output a SPC to video and return to caller
                jr      loc_64EA
; ---------------------------------------------------------------------------

loc_64E4:                               ; CODE XREF: GET_COMMAND+49C↑j
                                        ; GET_COMMAND+4A0↑j
                call    SPC_VID_OUT     ; Output a SPC to video and return to caller
                call    TAS_VID_DRIVER

loc_64EA:                               ; CODE XREF: GET_COMMAND+4A8↑j
                ld      a, (hl)
                call    sub_7147
                call    SPC_VID_OUT     ; Output a SPC to video and return to caller

loc_64F1:                               ; CODE XREF: GET_COMMAND+4BB↓j
                                        ; GET_COMMAND+4DE↓j ...
                call    GET_CHAR        ; get character, return in A
                or      a
                jr      z, loc_64F1
                cp      0Ah
                jr      nz, loc_6503

loc_64FB:                               ; CODE XREF: GET_COMMAND+519↓j
                inc     hl

loc_64FC:                               ; CODE XREF: GET_COMMAND+4CE↓j
                push    hl
                call    SCROLL_SAVEREGS ; save all regs and scroll down
                pop     hl
                jr      loc_64CD
; ---------------------------------------------------------------------------

loc_6503:                               ; CODE XREF: GET_COMMAND+4BF↑j
                cp      5Bh ; '['
                jr      nz, loc_650A
                dec     hl
                jr      loc_64FC
; ---------------------------------------------------------------------------

loc_650A:                               ; CODE XREF: GET_COMMAND+4CB↑j
                push    af
                ld      a, (HEX_ASCII_FLAG)
                or      a
                jr      z, loc_651F
                pop     af
                cp      0Dh
                jr      z, loc_654D
                cp      20h ; ' '
                jr      c, loc_64F1
                call    TAS_VID_DRIVER
                jr      loc_654D
; ---------------------------------------------------------------------------

loc_651F:                               ; CODE XREF: GET_COMMAND+4D5↑j
                pop     af
                cp      30h ; '0'
                jr      c, loc_64F1
                cp      47h ; 'G'
                jr      nc, loc_64F1
                cp      41h ; 'A'
                jr      nc, loc_6532
                cp      3Ah ; ':'
                jr      c, loc_6532
                jr      loc_64F1
; ---------------------------------------------------------------------------

loc_6532:                               ; CODE XREF: GET_COMMAND+4F0↑j
                                        ; GET_COMMAND+4F4↑j
                call    TAS_VID_DRIVER
                call    Adjust_AF
                sla     a
                sla     a
                sla     a
                sla     a
                ld      c, a

loc_6541:                               ; CODE XREF: GET_COMMAND+50A↓j
                call    GET_HEX_CHAR
                jr      nz, loc_6541
                call    TAS_VID_DRIVER
                call    Adjust_AF
                add     a, c

loc_654D:                               ; CODE XREF: GET_COMMAND+4DA↑j
                                        ; GET_COMMAND+4E3↑j
                ld      (hl), a
                push    hl
                call    SHOW_REGS
                pop     hl
                jr      loc_64FB

; =============== S U B R O U T I N E =======================================


Adjust_AF:                              ; CODE XREF: GET_COMMAND+4FB↑p
                                        ; GET_COMMAND+50F↑p ...
                sub     30h ; '0'
                cp      0Ah
                ret     c
                sub     7
                ret
; End of function Adjust_AF


; =============== S U B R O U T I N E =======================================


sub_655D:                               ; CODE XREF: DISASSEMBLE+9E↓p
                ld      a, 1Ah
                call    TAS_VID_DRIVER
                ld      a, 1Dh
                jp      TAS_VID_DRIVER
; End of function sub_655D


; =============== S U B R O U T I N E =======================================

; get 4 digit hex value into the HL register

HEX_to_HL:                              ; CODE XREF: GET_COMMAND+45C↑p
                                        ; HEX_to_HL+3↓j ...
                call    GET_HEX_CHAR
                jr      nz, HEX_to_HL   ; get 4 digit hex value into the HL register
; End of function HEX_to_HL


; =============== S U B R O U T I N E =======================================

; 4 byte hex value to HL register

HEX_VAL_to_HL:                          ; CODE XREF: GET_COMMAND+44E↑p
                                        ; GET_COMMAND:loc_675D↓p ...
                call    TAS_VID_DRIVER
                call    Adjust_AF
                sla     a
                sla     a
                sla     a
                sla     a
                ld      h, a

loc_657B:                               ; CODE XREF: HEX_VAL_to_HL+12↓j
                call    GET_HEX_CHAR
                jr      nz, loc_657B
                call    TAS_VID_DRIVER
                call    Adjust_AF
                add     a, h
                ld      h, a
; End of function HEX_VAL_to_HL


; =============== S U B R O U T I N E =======================================

; 2 byte hex value to L register (also in A)

HEX_VAL_to_L:                           ; CODE XREF: HEX_VAL_to_L+3↓j
                                        ; GET_COMMAND+A9A↓p ...
                call    GET_HEX_CHAR
                jr      nz, HEX_VAL_to_L ; 2 byte hex value to L register (also in A)
                call    TAS_VID_DRIVER
                call    Adjust_AF
                sla     a
                sla     a
                sla     a
                sla     a
                ld      l, a

loc_659C:                               ; CODE XREF: HEX_VAL_to_L+17↓j
                call    GET_HEX_CHAR
                jr      nz, loc_659C
                call    TAS_VID_DRIVER
                call    Adjust_AF
                add     a, l
                ld      l, a
                ret
; End of function HEX_VAL_to_L


; =============== S U B R O U T I N E =======================================


GET_HEX_CHAR:                           ; CODE XREF: GET_COMMAND:loc_646E↑p
                                        ; GET_COMMAND:loc_6541↑p ...
                call    GET_CHAR        ; get character, return in A
                cp      0
                jr      z, GET_HEX_CHAR
                cp      30h ; '0'
                jr      c, loc_65C1
                cp      47h ; 'G'
                jr      nc, loc_65C1
                cp      3Ah ; ':'
                jr      c, loc_65C3
                cp      41h ; 'A'
                jr      nc, loc_65C3

loc_65C1:                               ; CODE XREF: GET_HEX_CHAR+9↑j
                                        ; GET_HEX_CHAR+D↑j
                or      a
                ret
; ---------------------------------------------------------------------------

loc_65C3:                               ; CODE XREF: GET_HEX_CHAR+11↑j
                                        ; GET_HEX_CHAR+15↑j
                cp      a
                ret

; ---------------------------------------------------------------------------

breakpoints:                            ; CODE XREF: GET_COMMAND+2B↑j
                call    OUT_CHAR_SPC    ; output char in A, followed by a space to vid and return

bp_range_error:                         ; CODE XREF: GET_COMMAND+597↓j
                                        ; GET_COMMAND+59B↓j
                call    GET_CHAR        ; get character, return in A
                cp      0Dh
                jr      z, loc_65F3
                cp      31h ; '1'
                jr      c, bp_range_error
                cp      3Ah ; ':'
                jr      nc, bp_range_error
                call    TAS_VID_DRIVER
                sub     31h ; '1'
                sla     a
                ld      c, a
                ld      b, 0
                ld      hl, BREAKPOINTS ; 9 breakpoints (9 x 2 byte addresses)
                add     hl, bc
                call    SPC_VID_OUT     ; Output a SPC to video and return to caller
                push    hl
                call    HEX_to_HL       ; get 4 digit hex value into the HL register
                push    hl
                pop     de
                pop     hl
                ld      (hl), e
                inc     hl
                ld      (hl), d
                ret
; ---------------------------------------------------------------------------

loc_65F3:                               ; CODE XREF: GET_COMMAND+593↑j
                ld      b, 3
                push    bc
                call    SCROLL_SAVEREGS ; save all regs and scroll down
                ld      hl, BREAKPOINTS ; 9 breakpoints (9 x 2 byte addresses)
                ld      de, EXEC2
                ld      (GEN_PTR_16), hl

loc_6602:                               ; CODE XREF: GET_COMMAND+5E7↓j
                ld      b, 3
                jr      loc_6609
; ---------------------------------------------------------------------------

loc_6606:                               ; CODE XREF: GET_COMMAND+5DD↓j
                call    SPC_VID_OUT     ; Output a SPC to video and return to caller

loc_6609:                               ; CODE XREF: GET_COMMAND+5CA↑j
                call    sub_7173
                call    inc_PTR_16
                call    SPC_VID_OUT     ; Output a SPC to video and return to caller
                ld      a, (de)
                inc     de
                call    sub_7147
                djnz    loc_6606
                pop     bc
                dec     b
                push    bc
                jr      z, loc_6623
                call    SCROLL_SAVEREGS ; save all regs and scroll down
                jr      loc_6602
; ---------------------------------------------------------------------------

loc_6623:                               ; CODE XREF: GET_COMMAND+5E2↑j
                pop     bc
                jp      SHOW_REGS
; ---------------------------------------------------------------------------

clear_breakpoints:                      ; CODE XREF: GET_COMMAND+30↑j
                call    OUT_CHAR_SPC    ; output char in A, followed by a space to vid and return

loc_662A:                               ; CODE XREF: GET_COMMAND+5F9↓j
                                        ; GET_COMMAND+5FD↓j
                call    GET_CHAR        ; get character, return in A
                cp      0Dh
                jr      z, clear_all_breakpoints
                cp      31h ; '1'
                jr      c, loc_662A
                cp      3Ah ; ':'
                jr      nc, loc_662A
                call    TAS_VID_DRIVER
                sub     31h ; '1'
                sla     a
                ld      c, a
                ld      b, 0
                ld      hl, BREAKPOINTS ; 9 breakpoints (9 x 2 byte addresses)
                add     hl, bc
                ld      (hl), 0
                inc     hl
                ld      (hl), 0
                ret

; =============== S U B R O U T I N E =======================================


clear_all_breakpoints:                  ; CODE XREF: RAM:6014↑p
                                        ; GET_COMMAND+5F5↑j
                ld      hl, BREAKPOINTS ; 9 breakpoints (9 x 2 byte addresses)
                xor     a
                ld      b, 18

loc_6653:                               ; CODE XREF: clear_all_breakpoints+8↓j
                ld      (hl), a
                inc     hl
                djnz    loc_6653
                ret
; End of function clear_all_breakpoints

; ---------------------------------------------------------------------------

goto:                                   ; CODE XREF: GET_COMMAND+21↑j
                call    OUT_CHAR_SPC    ; output char in A, followed by a space to vid and return
                call    GET_HEX_ADDRESS
                ld      (reg_PC), hl

loc_6661:                               ; CODE XREF: GET_COMMAND+656↓j
                call    LOAD_BREAKPOINTS ; save existing code, and insert breakpoint traps in target code.
                call    sub_62CC
                call    RESTORE_BREAKPOINTS ; remove breakpoints, and re-insert original code
                ld      hl, (reg_PC)
                call    sub_6AE2
                jp      z, loc_68AD
                call    SHOW_REGS

loc_6676:                               ; CODE XREF: GET_COMMAND+652↓j
                ld      b, 3

loc_6678:                               ; CODE XREF: GET_COMMAND+654↓j
                push    bc
                call    CHECK_BREAK     ; check status of the BREAK key
                jp      nz, return_from_user
                call    sub_6739
                ld      hl, (reg_PC)
                call    sub_6AE2
                pop     bc
                jp      z, loc_68AD
                jr      c, loc_6676
                djnz    loc_6678
                jr      loc_6661

; =============== S U B R O U T I N E =======================================

; save existing code, and insert breakpoint traps in target code.

LOAD_BREAKPOINTS:                       ; CODE XREF: sub_60FF+58↑p
                                        ; GET_COMMAND:loc_6661↑p
                ld      b, 9
                ld      hl, BREAKPOINTS ; 9 breakpoints (9 x 2 byte addresses)
                ld      ix, CODE_SAVE

loc_669B:                               ; CODE XREF: LOAD_BREAKPOINTS+2D↓j
                ld      e, (hl)
                inc     hl
                ld      d, (hl)
                inc     hl
                ld      a, (de)
                ld      (ix+0), a
                inc     ix
                ld      a, 0CDh
                ld      (de), a
                inc     de
                ld      a, (de)
                ld      (ix+0), a
                inc     ix
                push    hl
                ld      hl, BREAKPOINT_RETURN
                ld      a, l
                ld      (de), a
                inc     de
                ld      a, (de)
                ld      (ix+0), a
                inc     ix
                ld      a, h
                ld      (de), a
                pop     hl
                djnz    loc_669B
                ret
; End of function LOAD_BREAKPOINTS


; =============== S U B R O U T I N E =======================================

; remove breakpoints, and re-insert original code

RESTORE_BREAKPOINTS:                    ; CODE XREF: sub_60FF+5E↑p
                                        ; GET_COMMAND+62D↑p
                ld      b, 9
                ld      hl, BREAKPOINTS ; 9 breakpoints (9 x 2 byte addresses)
                ld      ix, CODE_SAVE

loc_66CB:                               ; CODE XREF: RESTORE_BREAKPOINTS+21↓j
                ld      e, (hl)
                inc     hl
                ld      d, (hl)
                inc     hl
                ld      a, (ix+0)
                inc     ix
                ld      (de), a
                inc     de
                ld      a, (ix+0)
                inc     ix
                ld      (de), a
                inc     de
                ld      a, (ix+0)
                inc     ix
                ld      (de), a
                djnz    loc_66CB
                ret
; End of function RESTORE_BREAKPOINTS

; ---------------------------------------------------------------------------

disassemble:                            ; CODE XREF: GET_COMMAND+26↑j
                call    OUT_CHAR_SPC    ; output char in A, followed by a space to vid and return
                call    GET_HEX_ADDRESS
                push    hl
                call    SET_PROMPT_POS
                pop     hl
                call    CLEAR_VIDEO

dis_next_page:
		ld      bc, SCREEN_LINES - 1		; 15 on TRS-80/Stock VZ,   32 on FPGA6432LASER	; disassemble next *15* instructions
                ld      a, 1				; direct output to screen

loc_66F9:
                call    DISASSEMBLE
                ld      hl, (GEN_PTR_16)

dis_key_error:
                call    GET_CHAR			; get character, return in A
                cp      20h ; ' '
                jr      z, dis_next_page		; space == continue for next page
                cp      2Dh ; '-'
                jr      z, dis_previous_page		; '-' == go back a page
                cp      0Ah
                jr      nz, dis_key_error		; down arrow = disassemble one more line
                ld      bc, 1				; 1 line
                jr      loc_66F9
; ---------------------------------------------------------------------------

dis_previous_page:                              
                ld      b, (SCREEN_LINES - 1) * 2)	; 30 or 62		; disassemble previous 30 instructions to go pack a page

loc_6715:
                push    bc
                call    sub_77EB
                pop     bc
                djnz    loc_6715
                jr      dis_next_page
; ---------------------------------------------------------------------------

toggle_restarts:                        ; CODE XREF: GET_COMMAND+94↑j
                call    OUT_CHAR_SPC    ; output char in A, followed by a space to vid and return
                ld      a, (RESTARTS_STYLE)
                cpl
                and     1
                ld      (RESTARTS_STYLE), a
                or      a
                jr      z, loc_6732
                ld      a, 49h ; 'I'

loc_672F:                               ; CODE XREF: GET_COMMAND+6FA↓j
                jp      TAS_VID_DRIVER
; ---------------------------------------------------------------------------

loc_6732:                               ; CODE XREF: GET_COMMAND+6F1↑j
                ld      a, 5Ch ; '\'
                jr      loc_672F
; ---------------------------------------------------------------------------

single_step:                            ; CODE XREF: GET_COMMAND+1C↑j
                call    OUT_CHAR_SPC    ; output char in A, followed by a space to vid and return

; =============== S U B R O U T I N E =======================================


sub_6739:                               ; CODE XREF: GET_COMMAND+645↑p
                                        ; GET_COMMAND+843↓p
                ld      a, 1
                ld      (byte_7B8E), a
                jr      loc_6749
; End of function sub_6739

; ---------------------------------------------------------------------------

loc_6740:                               ; CODE XREF: GET_COMMAND+3F↑j
                ld      a, 5Ch ; '\'
                call    OUT_CHAR_SPC    ; output char in A, followed by a space to vid and return

; =============== S U B R O U T I N E =======================================


sub_6745:                               ; CODE XREF: GET_COMMAND:loc_6882↓p
                xor     a
                ld      (byte_7B8E), a

loc_6749:                               ; CODE XREF: sub_6739+5↑j
                call    sub_60FF
                jp      SHOW_REGS
; End of function sub_6745

; ---------------------------------------------------------------------------

find_search_key:                        ; CODE XREF: GET_COMMAND+44↑j
                call    OUT_CHAR_SPC    ; output char in A, followed by a space to vid and return

loc_6752:                               ; CODE XREF: GET_COMMAND+721↓j
                call    GET_HEX_CHAR
                jr      z, loc_675D
                cp      0Dh
                jr      z, loc_67A3
                jr      loc_6752
; ---------------------------------------------------------------------------

loc_675D:                               ; CODE XREF: GET_COMMAND+71B↑j
                call    HEX_VAL_to_HL   ; 4 byte hex value to HL register
                call    SPC_VID_OUT     ; Output a SPC to video and return to caller
                ld      (word_7B96), hl
                ld      b, 4
                ld      de, byte_7B98

loc_676B:                               ; CODE XREF: GET_COMMAND+75A↓j
                call    GET_HEX_CHAR
                jr      z, loc_6774
                cp      0Dh
                jr      z, loc_6796

loc_6774:                               ; CODE XREF: GET_COMMAND+734↑j
                call    TAS_VID_DRIVER
                call    Adjust_AF
                sla     a
                sla     a
                sla     a
                sla     a
                ld      c, a

loc_6783:                               ; CODE XREF: GET_COMMAND+74C↓j
                call    GET_HEX_CHAR
                jr      nz, loc_6783
                call    TAS_VID_DRIVER
                call    Adjust_AF
                add     a, c
                ld      (de), a
                inc     de
                call    SPC_VID_OUT     ; Output a SPC to video and return to caller
                djnz    loc_676B

loc_6796:                               ; CODE XREF: GET_COMMAND+738↑j
                ld      a, 4
                sub     b
                ld      (byte_7B9C), a
                ld      bc, 0
                ld      (word_7B9D), bc

loc_67A3:                               ; CODE XREF: GET_COMMAND+71F↑j
                                        ; GET_COMMAND+788↓j
                ld      hl, (word_7B96)
                ld      bc, (word_7B9D)
                ld      a, (byte_7B98)
                cpir
                ld      (word_7B96), hl
                dec     hl
                ld      (word_7B9D), bc
                ret     po
                ld      de, byte_7B98
                ld      a, (byte_7B9C)
                ld      b, a

loc_67BF:                               ; CODE XREF: GET_COMMAND+78B↓j
                ld      a, (de)
                inc     de
                cp      (hl)
                jr      nz, loc_67A3
                inc     hl
                djnz    loc_67BF
                ld      hl, (word_7B96)
                dec     hl
                jp      HL_to_HEX
; ---------------------------------------------------------------------------

hex_dump:                               ; CODE XREF: GET_COMMAND+4E↑j
                call    OUT_CHAR_SPC    ; output char in A, followed by a space to vid and return
                ld      a, 1
                ld      (HEX_ASCII_FLAG), a
                jr      loc_67DF
; ---------------------------------------------------------------------------

ascii_dump:                             ; CODE XREF: GET_COMMAND+49↑j
                call    OUT_CHAR_SPC    ; output char in A, followed by a space to vid and return
                xor     a
                ld      (HEX_ASCII_FLAG), a

loc_67DF:                               ; CODE XREF: GET_COMMAND+79C↑j
                call    GET_HEX_ADDRESS
                push    hl
                call    SET_PROMPT_POS
                pop     hl
                call    CLEAR_VIDEO

dump_next_page:
                ld      c, SCREEN_LINES - 1	; 15 or 31          ; Display 15 lines

loc_67EC:
                call    show_8_chars

loc_67EF:
                call    GET_CHAR        ; get character, return in A
                cp      20h ; ' '
                jr      z, dump_next_page ; SPC == show nest page
                cp      0Ah
                jr      z, dump_next_line ; Down Arrow = show one more line
                cp      2Dh ; '-'
                jr      nz, loc_67EF
                ld      de, 0F0h        ; '-' means display *previous* page
                xor     a
                sbc     hl, de
                jr      dump_next_page
; ---------------------------------------------------------------------------

dump_next_line: 
                ld      c, 1		; one more line
                jr      loc_67EC

; =============== S U B R O U T I N E =======================================


show_8_chars:                           ; CODE XREF: GET_COMMAND:loc_67EC↑p
                                        ; show_8_chars+33↓j
                ld      b, 8            ; 8 chars
                call    HL_to_HEX       ; Show source address at left
                call    SPC_VID_OUT     ; Output a SPC to video and return to caller

loc_6812:                               ; CODE XREF: show_8_chars+2B↓j
                ld      a, (hl)
                inc     hl
                push    af
                ld      a, (HEX_ASCII_FLAG)
                or      a               ; A = 1 force HEX, A = 0 try display ASCII char
                jr      z, try_show_ascii
                pop     af

undisplayable:                          ; CODE XREF: show_8_chars+1A↓j
                                        ; show_8_chars+1E↓j
                call    sub_7147
                jr      loc_6832
; ---------------------------------------------------------------------------

try_show_ascii:                         ; CODE XREF: show_8_chars+F↑j
                pop     af
                cp      20h ; ' '       ; 0-1F = CTRL chars
                jr      c, undisplayable
                cp      80h             ; >$80 = GFX chars
                jr      nc, undisplayable
                push    af
                call    SPC_VID_OUT     ; Output a SPC to video and return to caller
                pop     af
                call    TAS_VID_DRIVER

loc_6832:                               ; CODE XREF: show_8_chars+15↑j
                call    SPC_VID_OUT     ; Output a SPC to video and return to caller
                djnz    loc_6812
                ld      a, 0Dh
                call    TAS_VID_DRIVER
                dec     c               ; shown 15 lines yet?
                jr      nz, show_8_chars
                ret
; End of function show_8_chars

; ---------------------------------------------------------------------------

exit_tasmon:                            ; CODE XREF: GET_COMMAND+53↑j
                call    OUT_CHAR_SPC    ; output char in A, followed by a space to vid and return

loc_6843:                               ; CODE XREF: GET_COMMAND+80E↓j
                call    GET_CHAR        ; get character, return in A
                cp      0Dh             ; don't exit till <ENTER> pressed
                jr      nz, loc_6843
                halt
                rst     00H               ; Jump back to BASIC

trace:                                  ; CODE XREF: GET_COMMAND+58↑j
                call    OUT_CHAR_SPC    ; output char in A, followed by a space to vid and return
                xor     a
                ld      (byte_7BB6), a

loc_6853:                               ; CODE XREF: GET_COMMAND+822↓j
                call    GET_CHAR        ; get character, return in A
                cp      0Ah
                jr      z, loc_6866
                cp      49h ; 'I'
                jr      nz, loc_6853
                call    TAS_VID_DRIVER
                ld      (byte_7BAC), a
                jr      loc_686F
; ---------------------------------------------------------------------------

loc_6866:                               ; CODE XREF: GET_COMMAND+81E↑j
                ld      a, 5Ch ; '\'
                call    TAS_VID_DRIVER
                xor     a
                ld      (byte_7BAC), a

loc_686F:                               ; CODE XREF: GET_COMMAND+82A↑j
                call    SCROLL_SAVEREGS ; save all regs and scroll down
                ld      a, 6
                ld      (byte_7BA3), a

loc_6877:                               ; CODE XREF: GET_COMMAND+8B7↓j
                ld      a, (byte_7BAC)
                or      a
                jr      z, loc_6882
                call    sub_6739
                jr      loc_6885
; ---------------------------------------------------------------------------

loc_6882:                               ; CODE XREF: GET_COMMAND+841↑j
                call    sub_6745

loc_6885:                               ; CODE XREF: GET_COMMAND+846↑j
                call    SCROLL_SAVEREGS ; save all regs and scroll down
                ld      a, (byte_7BB6)
                or      a
                jr      z, loc_68A5
                ld      a, (byte_7B8D)
                cp      9
                jr      z, loc_68B0
                cp      0Ah
                jr      nz, loc_68A5
                ld      hl, (reg_PC)
                ld      b, (hl)
                ld      a, (reg_AF)
                call    sub_6278
                jr      nz, loc_68B0

loc_68A5:                               ; CODE XREF: GET_COMMAND+852↑j
                                        ; GET_COMMAND+85D↑j
                ld      hl, (reg_PC)
                call    sub_6AE2
                jr      nz, loc_68B3

loc_68AD:                               ; CODE XREF: GET_COMMAND+636↑j
                                        ; GET_COMMAND+64F↑j
                call    copy_EXEC1_to_EXEC2

loc_68B0:                               ; CODE XREF: GET_COMMAND+859↑j
                                        ; GET_COMMAND+869↑j ...
                jp      return_from_user
; ---------------------------------------------------------------------------

loc_68B3:                               ; CODE XREF: GET_COMMAND+871↑j
                call    GET_CHAR        ; get character, return in A
                cp      20h ; ' '
                jr      nz, loc_68C1

loc_68BA:                               ; CODE XREF: GET_COMMAND+885↓j
                call    GET_CHAR        ; get character, return in A
                cp      20h ; ' '
                jr      nz, loc_68BA

loc_68C1:                               ; CODE XREF: GET_COMMAND+87E↑j
                cp      30h ; '0'
                jr      c, loc_68D2
                cp      38h ; '8'
                jr      nc, loc_68D2
                sub     30h ; '0'
                ld      b, a
                ld      a, 8
                sub     b
                ld      (byte_7BA3), a

loc_68D2:                               ; CODE XREF: GET_COMMAND+889↑j
                                        ; GET_COMMAND+88D↑j
                cp      52h ; 'R'
                jr      nz, loc_68D9
                ld      (byte_7BB6), a

loc_68D9:                               ; CODE XREF: GET_COMMAND+89A↑j
                ld      a, (byte_7BA3)
                rlca
                rlca
                ld      b, a

loc_68DF:                               ; CODE XREF: GET_COMMAND+8B5↓j
                ld      a, (byte_7BA3)
                ld      e, a
                dec     a
                ld      d, a

loc_68E5:                               ; CODE XREF: GET_COMMAND+8B3↓j
                dec     de
                call    CHECK_BREAK     ; check status of the BREAK key
                jr      nz, loc_68B0
                ld      a, d
                or      e
                jr      nz, loc_68E5
                djnz    loc_68DF
                jr      loc_6877
; ---------------------------------------------------------------------------

subtract_add:                           ; CODE XREF: GET_COMMAND+5D↑j
                call    OUT_CHAR_SPC    ; output char in A, followed by a space to vid and return
                call    HEX_to_HL       ; get 4 digit hex value into the HL register
                push    hl
                call    SPC_VID_OUT     ; Output a SPC to video and return to caller
                call    HEX_to_HL       ; get 4 digit hex value into the HL register
                call    SPC_VID_OUT     ; Output a SPC to video and return to caller

loc_6903:                               ; CODE XREF: GET_COMMAND+8D2↓j
                call    GET_CHAR        ; get character, return in A
                cp      2Bh ; '+'
                jr      z, loc_691C
                cp      2Dh ; '-'
                jr      nz, loc_6903
                call    TAS_VID_DRIVER
                call    SPC_VID_OUT     ; Output a SPC to video and return to caller
                pop     de
                xor     a
                ex      de, hl
                sbc     hl, de

loc_6919:                               ; CODE XREF: GET_COMMAND+8EA↓j
                                        ; GET_COMMAND+931↓j
                jp      HL_to_HEX
; ---------------------------------------------------------------------------

loc_691C:                               ; CODE XREF: GET_COMMAND+8CE↑j
                pop     de
                call    TAS_VID_DRIVER
                call    SPC_VID_OUT     ; Output a SPC to video and return to caller
                add     hl, de
                jr      loc_6919
; ---------------------------------------------------------------------------

Q_command:                              ; CODE XREF: GET_COMMAND+A3↑j
                call    OUT_CHAR_SPC    ; output char in A, followed by a space to vid and return

q_cmd_error:                            ; CODE XREF: GET_COMMAND+8F6↓j
                call    GET_HEX_CHAR
                jr      z, loc_6934
                cp      0Dh
                jr      nz, q_cmd_error
                jr      loc_6948
; ---------------------------------------------------------------------------

loc_6934:                               ; CODE XREF: GET_COMMAND+8F2↑j
                call    HEX_VAL_to_HL   ; 4 byte hex value to HL register
                ld      (word_7B9F), hl
                call    SPC_VID_OUT     ; Output a SPC to video and return to caller
                call    HEX_to_HL       ; get 4 digit hex value into the HL register
                ld      (word_7BA1), hl
                ld      a, 20h ; ' '
                call    OUT_CHAR_SPC    ; output char in A, followed by a space to vid and return

loc_6948:                               ; CODE XREF: GET_COMMAND+8F8↑j
                ld      hl, (word_7B9F)
                ld      de, (word_7BA1)
                xor     a
                push    hl
                sbc     hl, de
                pop     hl
                ret     z

loc_6955:                               ; CODE XREF: GET_COMMAND+91F↓j
                ld      a, (de)
                cp      (hl)
                inc     hl
                inc     de
                jr      z, loc_6955
                ld      (word_7B9F), hl
                ld      (word_7BA1), de
                dec     hl
                dec     de
                call    HL_to_HEX
                call    SPC_VID_OUT     ; Output a SPC to video and return to caller
                ex      de, hl
                jr      loc_6919

; =============== S U B R O U T I N E =======================================


SET_PROMPT_POS:                         ; CODE XREF: RAM:6028↑p
                                        ; GET_COMMAND+14↑p ...
                ld      hl, SCREEN_START+1E8h	; 3DE8h
                ld      (NEXT_CHAR_ADD_L2), hl ; L2 Video DCB next char address $3C00<=X<=$3FFF
                ld      (NEXT_CHAR_ADD_TM), hl
                ret
; End of function SET_PROMPT_POS


; =============== S U B R O U T I N E =======================================

; save all regs and scroll down

SCROLL_SAVEREGS: 
                push    hl
                push    de
                push    bc
                call    SCROLL_CMD
                pop     bc
                pop     de
                pop     hl
                ret


; =============== S U B R O U T I N E =======================================


SCROLL_CMD:						; CODE XREF: SCROLL_SAVEREGS+3↑p
                ld      hl, (NEXT_CHAR_ADD_TM)
                ld      bc, LINE_LEN			; 64
                add     hl, bc				; down one line
                ld      (NEXT_CHAR_ADD_TM), hl
                ld      (NEXT_CHAR_ADD_L2), hl		; L2 Video DCB next char address $3C00<=X<=$3FFF
                ld      a, h
                cp      SCREEN_OVERFLOW			; 40XXh ; Are we off the end of the screen?
                ret     m				; return if not off bottom of screen
                xor     a
                sbc     hl, bc
                ld      (NEXT_CHAR_ADD_TM), hl
                ld      a, 7				; last 7 lines?
                ld      hl, SCREEN_START+228h		; 3E28h
                push    hl

loc_699E:
                pop     de
                push    de
                pop     hl
                ld      bc, LINE_LEN			; 64
                add     hl, bc
                push    hl
                ld      bc, 24				; command area 24chars wide
                ldir
                dec     a
                jr      nz, loc_699E
                pop     hl
                ld      hl, SCREEN_START+3E8h		; 3FE8h
                ld      (NEXT_CHAR_ADD_L2), hl		; L2 Video DCB next char address $3C00<=X<=$3FFF
                ld      a, 1Eh				; clear to end of current line
                call    TAS_VID_DRIVER
                ld      hl, SCREEN_START+3E8h		; 3FE8h
                ld      (NEXT_CHAR_ADD_L2), hl		; L2 Video DCB next char address $3C00<=X<=$3FFF
                ld      (NEXT_CHAR_ADD_TM), hl
                ret
; End of function SCROLL_CMD


; =============== S U B R O U T I N E =======================================

; output char in A, followed by a space to vid and return

OUT_CHAR_SPC:                           ; CODE XREF: GET_COMMAND:replace_reg_pair↑p
                                        ; GET_COMMAND:modify_memory↑p ...
                call    TAS_VID_DRIVER
                jp      SPC_VID_OUT     ; Output a SPC to video and return to caller
; End of function OUT_CHAR_SPC

; ---------------------------------------------------------------------------

disassem_to_printer:                    ; CODE XREF: GET_COMMAND+62↑j
                call    OUT_CHAR_SPC    ; output char in A, followed by a space to vid and return
                call    HEX_to_HL       ; get 4 digit hex value into the HL register
                push    hl
                call    SPC_VID_OUT     ; Output a SPC to video and return to caller
                call    HEX_to_HL       ; get 4 digit hex value into the HL register
                pop     de
                ex      de, hl
                call    checkPRT        ; Check if Printer is Ready
                ret     nz
                push    hl
                call    SET_PROMPT_POS
                call    CLEAR_VIDEO
                pop     hl
                ld      (GEN_PTR_16), hl

loc_69E8:                               ; CODE XREF: GET_COMMAND+9D1↓j
                ld      a, 1
                ld      (PRINT_OUT_FLAG), a
                ld      bc, 1
                push    de
                ld      hl, (GEN_PTR_16)
                call    DISASSEMBLE
                xor     a
                ld      (PRINT_OUT_FLAG), a
                ld      a, 0Dh
                call    TAS_PTR_DRIVER
                call    GET_CHAR        ; get character, return in A
                ld      hl, (GEN_PTR_16)
                dec     hl
                pop     de
                or      a
                sbc     hl, de
                jp      m, loc_69E8
                jp      SHOW_REGS

; =============== S U B R O U T I N E =======================================


CLEAR_VIDEO:                            ; CODE XREF: RAM:6001↑p
                                        ; GET_COMMAND+11↑p ...
                call    do_clear_screen
                xor     a
                ld      (Display_Control), a
                out     (0FFh), a       ; ensure 64 character mode active
                ret
; End of function CLEAR_VIDEO


; =============== S U B R O U T I N E =======================================


do_clear_screen:                        ; CODE XREF: CLEAR_VIDEO↑p
                                        ; GET_COMMAND+12F6↓p
                push    hl
                push    de
                push    bc
                ld      hl, SCREEN_START
                ld      (NEXT_CHAR_ADD_L2), hl ; L2 Video DCB next char address $3C00<=X<=$3FFF
                ld      de, SCREEN_START+1	; 3C01h
                ld      bc, SCREEN_LEN-1	; 3FFh
                ld      (hl), 20h ; ' '
                ldir
                pop     bc
                pop     de
                pop     hl
                ret


; ---------------------------------------------------------------------------

keep_screen:                            
                call    OUT_CHAR_SPC    ; output char in A, followed by a space to vid and return

loc_6A35:
		call    GET_HEX_CHAR
                jr      z, set_user_screen_buffer
                cp      4Eh ; 'N'
                jr      z, keep_screen_off
                cp      59h ; 'Y'
                jr      z, keep_screen_on
                cp      0Dh
                jr      nz, loc_6A35
                ld      de, SCREEN_START
                ld      hl, (USER_SCREEN_ptr) ; ptr to user supplied $400 byte screen area
                ld      bc, SCREEN_LEN		; 400h
                ldir

loc_6A51:                               ; CODE XREF: GET_COMMAND+A1C↓j
                ld      a, (KBD_ROW_40)
                cp      1		; wait for ENTER key press
                jr      z, loc_6A51
                jp      return_from_user
; ---------------------------------------------------------------------------

set_user_screen_buffer:                 
                call    HEX_VAL_to_HL   ; 4 byte hex value to HL register
                ld      (USER_SCREEN_ptr), hl ; ptr to user supplied $400 byte screen area
                ld      bc, SCREEN_LEN	; 400h

loc_6A64:                               
                ld      a, 20h ; ' '
                ld      (hl), a
                inc     hl
                dec     bc
                ld      a, b
                or      c
                jr      nz, loc_6A64
                ret
; ---------------------------------------------------------------------------

keep_screen_off:                        ; CODE XREF: GET_COMMAND+A02↑j
                call    TAS_VID_DRIVER
                xor     a
                ld      (KEEP_SCREEN_STATE), a ; 0 = keep screen off, 1 = keep screen on
                ret
; ---------------------------------------------------------------------------

keep_screen_on:                         ; CODE XREF: GET_COMMAND+A06↑j
                call    TAS_VID_DRIVER
                ld      a, 1
                ld      (KEEP_SCREEN_STATE), a ; 0 = keep screen off, 1 = keep screen on
                ret

; =============== S U B R O U T I N E =======================================

; check status of the BREAK key

CHECK_BREAK:
                ld      a, (KBD_ROW_40)
                and     4
                ret

; End of function CHECK_BREAK


; =============== S U B R O U T I N E =======================================


GET_HEX_ADDRESS: 
                call    GET_HEX_CHAR
                jp      z, HEX_VAL_to_HL ; 4 byte hex value to HL register
                cp      0Dh
                jr      nz, GET_HEX_ADDRESS
                ld      hl, (reg_PC) ; if return pressed, use saved PC value
                jp      HL_to_HEX

; ---------------------------------------------------------------------------

number_or_executions:                   ; CODE XREF: GET_COMMAND+9E↑j
                call    OUT_CHAR_SPC    ; output char in A, followed by a space to vid and return

loc_6A98:    
                call    GET_CHAR        ; get character, return in A
                cp      0Dh
                jr      z, copy_EXEC1_to_EXEC2
                cp      49h ; 'I'
                jr      z, loc_6AAD
                cp      31h ; '1'
                jr      c, loc_6A98
                cp      3Ah ; ':'
                jr      nc, loc_6A98
                jr      loc_6ACA
; ---------------------------------------------------------------------------

loc_6AAD:  
                call    OUT_CHAR_SPC    ; output char in A, followed by a space to vid and return

; =============== S U B R O U T I N E =======================================

; default all breakpoints to 1 execution only

SET_EXEC1_to_1:                         ; CODE XREF: RAM:6022↑p
                ld      b, 9
                ld      hl, EXEC1
                ld      a, 1

loc_6AB7:                               ; CODE XREF: SET_EXEC1_to_1+9↓j
                ld      (hl), a
                inc     hl
                djnz    loc_6AB7
; End of function SET_EXEC1_to_1


; =============== S U B R O U T I N E =======================================


copy_EXEC1_to_EXEC2:                    ; CODE XREF: GET_COMMAND:loc_68AD↑p
                                        ; GET_COMMAND+A63↑j
                ld      b, 9
                ld      hl, EXEC1
                ld      de, EXEC2

loc_6AC3:                               ; CODE XREF: copy_EXEC1_to_EXEC2+C↓j
                ld      a, (hl)
                inc     hl
                ld      (de), a
                inc     de
                djnz    loc_6AC3
                ret
; End of function copy_EXEC1_to_EXEC2

; ---------------------------------------------------------------------------

loc_6ACA:                               ; CODE XREF: GET_COMMAND+A71↑j
                push    af
                call    OUT_CHAR_SPC    ; output char in A, followed by a space to vid and return
                pop     af
                sub     31h ; '1'
                ld      c, a
                ld      b, 0
                call    HEX_VAL_to_L    ; 2 byte hex value to L register (also in A)
                ld      hl, EXEC1
                add     hl, bc
                ld      (hl), a
                ld      hl, EXEC2
                add     hl, bc
                ld      (hl), a
                ret

; =============== S U B R O U T I N E =======================================


sub_6AE2:                               ; CODE XREF: GET_COMMAND+633↑p
                                        ; GET_COMMAND+64B↑p ...
                ld      ix, BREAKPOINTS ; 9 breakpoints (9 x 2 byte addresses)
                ld      b, 9
                ld      a, 1

loc_6AEA:                               ; CODE XREF: sub_6AE2+19↓j
                ld      e, (ix+0)
                ld      d, (ix+1)
                inc     ix
                inc     ix
                or      a
                ex      de, hl
                sbc     hl, de
                ex      de, hl
                jr      z, loc_6AFF
                djnz    loc_6AEA
                or      a
                ret
; ---------------------------------------------------------------------------

loc_6AFF:                               ; CODE XREF: sub_6AE2+17↑j
                ld      a, 9
                sub     b
                ld      c, a
                ld      b, 0
                ld      hl, EXEC2
                add     hl, bc
                dec     (hl)
                scf
                ret
; End of function sub_6AE2


; =============== S U B R O U T I N E =======================================


DISASSEMBLE:                            ; CODE XREF: SHOW_REGS+25↑p
                                        ; GET_COMMAND:loc_66F9↑p ...
                ld      (GEN_PTR_16), hl
                ld      (dis_DISASSEM_START), hl ; HL = Instruction Start Address
                ld      (dis_NUM_INSTRS), bc ; BC = number of instructions to disassemble
                ld      (dis_DISPLAY_FLG), a  ; A = 0 (no display) , A = 1 (display dump)
                xor     a
                ld      (byte_7EEB), a
                ld      (byte_7B8D), a

loc_6B20:                               ; CODE XREF: DISASSEMBLE+C9↓j
                ld      a, (byte_7EE4)
                or      a
                jr      z, loc_6B2B
                call    sub_747A
                jr      loc_6B3E
; ---------------------------------------------------------------------------

loc_6B2B:                               ; CODE XREF: DISASSEMBLE+18↑j
                ld      a, (byte_7BA6)
                cp      1
                jr      z, loc_6B3E
                ld      a, (byte_7EE9)
                or      a
                jr      nz, loc_6B3E
                call    HL_to_HEX
                call    sub_7282

loc_6B3E:                               ; CODE XREF: DISASSEMBLE+1D↑j
                                        ; DISASSEMBLE+24↑j ...
                ld      a, (dis_DISPLAY_FLG)
                push    af
                xor     a
                ld      (dis_DISPLAY_FLG), a
                call    sub_6BD8
                pop     af
                ld      (dis_DISPLAY_FLG), a
                ld      a, (byte_7EE4)
                or      a
                ret     nz
                ld      a, (byte_7EE9)
                or      a
                ret     nz
                call    inc_PTR_16
                ld      hl, (GEN_PTR_16)
                ld      de, (dis_DISASSEM_START)
                sbc     hl, de
                ld      b, l
                ld      a, (dis_DISPLAY_FLG)
                or      a
                ld      a, b
                ret     z
                ld      hl, (dis_DISASSEM_START)
                ld      (GEN_PTR_16), hl
                ld      a, (byte_7BA6)
                cp      1
                jr      z, loc_6B97
                push    hl
                push    bc

loc_6B79:                               ; CODE XREF: DISASSEMBLE+71↓j
                call    sub_7146
                inc     hl
                djnz    loc_6B79
                pop     bc
                pop     hl
                push    bc
                ld      a, 0Eh
                call    sub_7096
                pop     bc

loc_6B88:                               ; CODE XREF: DISASSEMBLE+89↓j
                ld      a, (hl)
                cp      20h ; ' '
                jr      c, loc_6BAF
                cp      80h
                jr      nc, loc_6BAF
                call    sub_70B8

loc_6B94:                               ; CODE XREF: DISASSEMBLE+A6↓j
                inc     hl
                djnz    loc_6B88

loc_6B97:                               ; CODE XREF: DISASSEMBLE+69↑j
                call    sub_6BD8
                call    inc_PTR_16
                ld      a, (dis_DISPLAY_FLG)
                or      a
                jr      z, loc_6BB9
                ld      a, (byte_7BA6)
                cp      1
                jr      nz, loc_6BB4
                call    sub_655D
                jr      loc_6BB9
; ---------------------------------------------------------------------------

loc_6BAF:                               ; CODE XREF: DISASSEMBLE+7F↑j
                                        ; DISASSEMBLE+83↑j
                call    sub_728D
                jr      loc_6B94
; ---------------------------------------------------------------------------

loc_6BB4:                               ; CODE XREF: DISASSEMBLE+9C↑j
                ld      a, 0Dh
                call    TAS_VID_DRIVER

loc_6BB9:                               ; CODE XREF: DISASSEMBLE+95↑j
                                        ; DISASSEMBLE+A1↑j
                ld      bc, (dis_NUM_INSTRS)
                dec     bc
                ld      (dis_NUM_INSTRS), bc
                ld      de, (dis_DISASSEM_START)
                xor     a
                sbc     hl, de
                ld      a, b
                or      c
                jr      nz, loc_6BCF
                ld      a, l
                ret
; ---------------------------------------------------------------------------

loc_6BCF:                               ; CODE XREF: DISASSEMBLE+BF↑j
                ld      hl, (GEN_PTR_16)
                ld      (dis_DISASSEM_START), hl
                jp      loc_6B20
; End of function DISASSEMBLE


; =============== S U B R O U T I N E =======================================


sub_6BD8:                               ; CODE XREF: DISASSEMBLE+3A↑p
                                        ; DISASSEMBLE:loc_6B97↑p

                ld      hl, (GEN_PTR_16)
                ld      a, (hl)
                ld      hl, byte_7C30
                ld      b, 15h
                ld      de, byte_7DBB
                call    sub_72B0
                ret     z
                xor     a
                ld      (byte_7B8A), a
                ld      (byte_7B8B), a
                ld      a, (hl)
                cp      0DDh
                jr      z, loc_6BF8
                cp      0FDh
                jr      nz, loc_6C14

loc_6BF8:                               ; CODE XREF: sub_6BD8+1A↑j
                ld      (byte_7B8A), a
                ld      b, a
                call    inc_PTR_16
                ld      a, (hl)
                cp      66h ; 'f'
                jr      z, loc_6C14
                cp      6Eh ; 'n'
                jr      z, loc_6C14
                cp      74h ; 't'
                jr      z, loc_6C14
                cp      75h ; 'u'
                jr      z, loc_6C14
                ld      a, b
                ld      (byte_7B8B), a

loc_6C14:                               ; CODE XREF: sub_6BD8+1E↑j
                                        ; sub_6BD8+2A↑j ...
                ld      a, (hl)
                and     0C0h
                cp      40h ; '@'
                jr      nz, loc_6C2F
                ld      a, (hl)
                push    af
                ld      hl, byte_7C91
                call    sub_7061
                pop     af
                push    af
                call    sub_7129
                call    sub_7279
                pop     af
                jp      loc_7137
; ---------------------------------------------------------------------------

loc_6C2F:                               ; CODE XREF: sub_6BD8+41↑j
                ld      a, (hl)
                cp      3Ah ; ':'
                jr      nz, loc_6C3F
                ld      hl, byte_7C9A
                call    sub_7061
                call    inc_PTR_16
                jr      loc_6C6D
; ---------------------------------------------------------------------------

loc_6C3F:                               ; CODE XREF: sub_6BD8+5A↑j
                cp      32h ; '2'
                jr      nz, loc_6C5A
                ld      hl, byte_7C91
                call    sub_7061
                ld      a, 28h ; '('
                call    sub_70B8
                call    inc_PTR_16
                call    sub_7173
                ld      hl, byte_7CA0
                jp      SHOW_INSTR_HDR
; ---------------------------------------------------------------------------

loc_6C5A:                               ; CODE XREF: sub_6BD8+69↑j
                cp      2Ah ; '*'
                jr      nz, loc_6C70
                ld      hl, byte_7C91
                call    sub_7061
                call    sub_718B
                call    sub_7279
                call    inc_PTR_16

loc_6C6D:                               ; CODE XREF: sub_6BD8+65↑j
                jp      sub_7167
; ---------------------------------------------------------------------------

loc_6C70:                               ; CODE XREF: sub_6BD8+84↑j
                cp      22h ; '"'
                jr      nz, loc_6C86
                ld      hl, byte_7C91
                call    sub_7061
                call    inc_PTR_16
                call    sub_7167
                call    sub_7279
                jp      sub_718B
; ---------------------------------------------------------------------------

loc_6C86:                               ; CODE XREF: sub_6BD8+9A↑j
                cp      0C6h
                jr      nz, loc_6C96
                ld      hl, byte_7CBA
                call    sub_7061
                call    inc_PTR_16
                jp      sub_7143
; ---------------------------------------------------------------------------

loc_6C96:                               ; CODE XREF: sub_6BD8+B0↑j
                cp      0C3h
                jr      nz, loc_6CAB
                ld      a, 1
                ld      (byte_7B8D), a
                ld      hl, byte_7CD3
                call    sub_7061

loc_6CA5:                               ; CODE XREF: sub_6BD8+214↓j
                call    inc_PTR_16
                jp      sub_7173
; ---------------------------------------------------------------------------

loc_6CAB:                               ; CODE XREF: sub_6BD8+C0↑j
                cp      18h
                jr      nz, loc_6CB9
                ld      a, 3
                ld      (byte_7B8D), a
                ld      hl, byte_7CD7
                jr      loc_6CD5
; ---------------------------------------------------------------------------

loc_6CB9:                               ; CODE XREF: sub_6BD8+D5↑j
                cp      38h ; '8'
                jr      nz, loc_6CCB
                ld      hl, byte_7CDB
                call    sub_6CC5
                jr      loc_6CD5
; End of function sub_6BD8


; =============== S U B R O U T I N E =======================================


sub_6CC5:                               ; CODE XREF: sub_6BD8+E8↑p
                                        ; sub_6BD8+FA↓p ...
                ld      a, 5
                ld      (byte_7B8D), a
                ret
; End of function sub_6CC5

; ---------------------------------------------------------------------------

loc_6CCB:                               ; CODE XREF: sub_6BD8+E3↑j
                cp      30h ; '0'
                jr      nz, loc_6CDE
                ld      hl, byte_7CE1
                call    sub_6CC5

loc_6CD5:                               ; CODE XREF: sub_6BD8+DF↑j
                                        ; sub_6BD8+EB↑j ...
                call    sub_7061
                call    inc_PTR_16
                jp      sub_71F5
; ---------------------------------------------------------------------------

loc_6CDE:                               ; CODE XREF: sub_6BD8+F5↑j
                cp      28h ; '('
                jr      nz, loc_6CEA
                ld      hl, byte_7CE8
                call    sub_6CC5
                jr      loc_6CD5
; ---------------------------------------------------------------------------

loc_6CEA:                               ; CODE XREF: sub_6BD8+108↑j
                cp      20h ; ' '
                jr      nz, loc_6CF6
                ld      hl, byte_7CEE
                call    sub_6CC5
                jr      loc_6CD5
; ---------------------------------------------------------------------------

loc_6CF6:                               ; CODE XREF: sub_6BD8+114↑j
                cp      0E9h
                jr      nz, loc_6D11
                ld      hl, byte_7CD3
                ld      a, 6
                ld      (byte_7B8D), a
                call    sub_7061
                ld      a, 28h ; '('
                call    sub_70B8
                call    sub_718B
                ld      a, 29h ; ')'
                jr      loc_6D55
; ---------------------------------------------------------------------------

loc_6D11:                               ; CODE XREF: sub_6BD8+120↑j
                cp      10h
                jr      nz, loc_6D1F
                ld      hl, byte_7CF5
                ld      a, 4
                ld      (byte_7B8D), a
                jr      loc_6CD5
; ---------------------------------------------------------------------------

loc_6D1F:                               ; CODE XREF: sub_6BD8+13B↑j
                cp      0CDh
                jr      nz, loc_6D34
                ld      hl, byte_7CFB
                ld      a, 7
                ld      (byte_7B8D), a
                call    sub_7061

loc_6D2E:                               ; CODE XREF: sub_6BD8+22C↓j
                call    inc_PTR_16
                jp      sub_7173
; ---------------------------------------------------------------------------

loc_6D34:                               ; CODE XREF: sub_6BD8+149↑j
                cp      0C9h
                jr      nz, loc_6D43
                ld      hl, byte_7D01
                ld      a, 9
                ld      (byte_7B8D), a
                jp      sub_7061
; ---------------------------------------------------------------------------

loc_6D43:                               ; CODE XREF: sub_6BD8+15E↑j
                cp      0DBh
                jr      nz, loc_6D58
                ld      hl, byte_7D0B
                call    sub_7061
                call    inc_PTR_16
                call    sub_7143
                ld      a, 29h ; ')'

loc_6D55:                               ; CODE XREF: sub_6BD8+137↑j
                jp      sub_70B8
; ---------------------------------------------------------------------------

loc_6D58:                               ; CODE XREF: sub_6BD8+16D↑j
                cp      0D3h
                jr      nz, loc_6D6E
                ld      hl, byte_7D12
                call    sub_7061
                call    inc_PTR_16
                call    sub_7143
                ld      hl, byte_7CA0
                jp      SHOW_INSTR_HDR
; ---------------------------------------------------------------------------

loc_6D6E:                               ; CODE XREF: sub_6BD8+182↑j
                cp      0CEh
                jr      nz, loc_6D77
                ld      hl, byte_7D18
                jr      loc_6D90
; ---------------------------------------------------------------------------

loc_6D77:                               ; CODE XREF: sub_6BD8+198↑j
                cp      0D6h
                jr      nz, loc_6D80
                ld      hl, byte_7D1F
                jr      loc_6D90
; ---------------------------------------------------------------------------

loc_6D80:                               ; CODE XREF: sub_6BD8+1A1↑j
                cp      0DEh
                jr      nz, loc_6D89
                ld      hl, byte_7D24
                jr      loc_6D90
; ---------------------------------------------------------------------------

loc_6D89:                               ; CODE XREF: sub_6BD8+1AA↑j
                cp      0E6h
                jr      nz, loc_6D98
                ld      hl, byte_7D2B

loc_6D90:                               ; CODE XREF: sub_6BD8+19D↑j
                                        ; sub_6BD8+1A6↑j ...
                call    sub_7061
                call    inc_PTR_16
                jr      loc_6DC8
; ---------------------------------------------------------------------------

loc_6D98:                               ; CODE XREF: sub_6BD8+1B3↑j
                cp      0F6h
                jr      nz, loc_6DA1
                ld      hl, byte_7D30
                jr      loc_6D90
; ---------------------------------------------------------------------------

loc_6DA1:                               ; CODE XREF: sub_6BD8+1C2↑j
                cp      0EEh
                jr      nz, loc_6DAA
                ld      hl, byte_7D34
                jr      loc_6D90
; ---------------------------------------------------------------------------

loc_6DAA:                               ; CODE XREF: sub_6BD8+1CB↑j
                cp      0FEh
                jr      nz, loc_6DB3
                ld      hl, byte_7D39
                jr      loc_6D90
; ---------------------------------------------------------------------------

loc_6DB3:                               ; CODE XREF: sub_6BD8+1D4↑j
                and     0C7h
                cp      6
                jr      nz, loc_6DCB
                ld      hl, byte_7C91
                call    sub_7061
                call    sub_7125
                call    sub_7279
                call    inc_PTR_16

loc_6DC8:                               ; CODE XREF: sub_6BD8+1BE↑j
                jp      sub_7143
; ---------------------------------------------------------------------------

loc_6DCB:                               ; CODE XREF: sub_6BD8+1DF↑j
                cp      4
                jr      nz, loc_6DD7
                ld      hl, byte_7CC1
                call    sub_7061
                jr      loc_6E3B
; ---------------------------------------------------------------------------

loc_6DD7:                               ; CODE XREF: sub_6BD8+1F5↑j
                cp      0C2h
                jr      nz, loc_6DEF
                ld      a, 2
                ld      (byte_7B8D), a
                ld      hl, byte_7CD3
                call    sub_7061
                call    sub_71CF
                call    sub_7279
                jp      loc_6CA5
; ---------------------------------------------------------------------------

loc_6DEF:                               ; CODE XREF: sub_6BD8+201↑j
                cp      0C4h
                jr      nz, loc_6E07
                ld      hl, byte_7CFB
                ld      a, 8
                ld      (byte_7B8D), a
                call    sub_7061
                call    sub_71CF
                call    sub_7279
                jp      loc_6D2E
; ---------------------------------------------------------------------------

loc_6E07:                               ; CODE XREF: sub_6BD8+219↑j
                cp      0C0h
                jr      nz, loc_6E19
                ld      hl, byte_7D01
                ld      a, 0Ah
                ld      (byte_7B8D), a
                call    sub_7061
                jp      sub_71CF
; ---------------------------------------------------------------------------

loc_6E19:                               ; CODE XREF: sub_6BD8+231↑j
                cp      0C7h
                jr      nz, loc_6E31
                ld      a, 0Bh
                ld      (byte_7B8D), a
                ld      hl, byte_7D06
                call    sub_7061
                ld      hl, (GEN_PTR_16)
                ld      a, (hl)
                and     38h ; '8'
                jp      sub_7147
; ---------------------------------------------------------------------------

loc_6E31:                               ; CODE XREF: sub_6BD8+243↑j
                cp      5
                jr      nz, loc_6E3E
                ld      hl, byte_7CCE
                call    sub_7061

loc_6E3B:                               ; CODE XREF: sub_6BD8+1FD↑j
                jp      sub_7125
; ---------------------------------------------------------------------------

loc_6E3E:                               ; CODE XREF: sub_6BD8+25B↑j
                ld      a, (hl)
                and     0CFh
                cp      1
                jr      nz, loc_6E57
                ld      hl, byte_7C91
                call    sub_7061
                call    sub_7194
                call    inc_PTR_16
                call    sub_7279
                jp      sub_7173
; ---------------------------------------------------------------------------

loc_6E57:                               ; CODE XREF: sub_6BD8+26B↑j
                cp      0C5h
                jr      nz, loc_6E61
                ld      hl, byte_7CAF
                jr      loc_6E68
                ret
; ---------------------------------------------------------------------------

loc_6E61:                               ; CODE XREF: sub_6BD8+281↑j
                cp      0C1h
                jr      nz, loc_6E6E
                ld      hl, byte_7CB5

loc_6E68:                               ; CODE XREF: sub_6BD8+286↑j
                call    sub_7061
                jp      loc_71BB
; ---------------------------------------------------------------------------

loc_6E6E:                               ; CODE XREF: sub_6BD8+28B↑j
                ld      a, (hl)
                and     0F8h
                cp      80h
                jr      nz, loc_6E7D
                ld      hl, byte_7CBA
                call    sub_7061
                jr      loc_6EA2
; ---------------------------------------------------------------------------

loc_6E7D:                               ; CODE XREF: sub_6BD8+29B↑j
                cp      88h
                jr      nz, loc_6E86
                ld      hl, byte_7D18
                jr      loc_6E9F
; ---------------------------------------------------------------------------

loc_6E86:                               ; CODE XREF: sub_6BD8+2A7↑j
                cp      90h
                jr      nz, loc_6E8F
                ld      hl, byte_7D1F
                jr      loc_6E9F
; ---------------------------------------------------------------------------

loc_6E8F:                               ; CODE XREF: sub_6BD8+2B0↑j
                cp      98h
                jr      nz, loc_6E98
                ld      hl, byte_7D24
                jr      loc_6E9F
; ---------------------------------------------------------------------------

loc_6E98:                               ; CODE XREF: sub_6BD8+2B9↑j
                cp      0A0h
                jr      nz, loc_6EA5
                ld      hl, byte_7D2B

loc_6E9F:                               ; CODE XREF: sub_6BD8+2AC↑j
                                        ; sub_6BD8+2B5↑j ...
                call    sub_7061

loc_6EA2:                               ; CODE XREF: sub_6BD8+2A3↑j
                jp      loc_7133
; ---------------------------------------------------------------------------

loc_6EA5:                               ; CODE XREF: sub_6BD8+2C2↑j
                cp      0B0h
                jr      nz, loc_6EAE
                ld      hl, byte_7D30
                jr      loc_6E9F
; ---------------------------------------------------------------------------

loc_6EAE:                               ; CODE XREF: sub_6BD8+2CF↑j
                cp      0A8h
                jr      nz, loc_6EB7
                ld      hl, byte_7D34
                jr      loc_6E9F
; ---------------------------------------------------------------------------

loc_6EB7:                               ; CODE XREF: sub_6BD8+2D8↑j
                cp      0B8h
                jr      nz, loc_6EC0
                ld      hl, byte_7D39
                jr      loc_6E9F
; ---------------------------------------------------------------------------

loc_6EC0:                               ; CODE XREF: sub_6BD8+2E1↑j
                ld      a, (hl)
                and     0CFh
                cp      9
                jr      nz, loc_6EDB
                ld      hl, byte_7DAE
                call    sub_7061
                call    sub_718B
                call    sub_7279
                jr      loc_6ED8
; ---------------------------------------------------------------------------

loc_6ED5:                               ; CODE XREF: sub_6BD8+30A↓j
                                        ; sub_6BD8+313↓j
                call    sub_7061

loc_6ED8:                               ; CODE XREF: sub_6BD8+2FB↑j
                jp      sub_7194
; ---------------------------------------------------------------------------

loc_6EDB:                               ; CODE XREF: sub_6BD8+2ED↑j
                cp      3
                jr      nz, loc_6EE4
                ld      hl, byte_7CC1
                jr      loc_6ED5
; ---------------------------------------------------------------------------

loc_6EE4:                               ; CODE XREF: sub_6BD8+305↑j
                cp      0Bh
                jr      nz, loc_6EED
                ld      hl, byte_7CCE
                jr      loc_6ED5
; ---------------------------------------------------------------------------

loc_6EED:                               ; CODE XREF: sub_6BD8+30E↑j
                ld      a, (hl)
                cp      0CBh
                jp      nz, loc_6F9D
                call    inc_PTR_16
                ld      a, (byte_7B8A)
                or      a
                call    nz, inc_PTR_16
                ld      a, (hl)
                and     0F8h
                jr      nz, loc_6F07
                ld      hl, byte_7D3D
                jr      loc_6F29
; ---------------------------------------------------------------------------

loc_6F07:                               ; CODE XREF: sub_6BD8+328↑j
                cp      10h
                jr      nz, loc_6F10
                ld      hl, byte_7D42
                jr      loc_6F29
; ---------------------------------------------------------------------------

loc_6F10:                               ; CODE XREF: sub_6BD8+331↑j
                cp      8
                jr      nz, loc_6F19
                ld      hl, byte_7D46
                jr      loc_6F29
; ---------------------------------------------------------------------------

loc_6F19:                               ; CODE XREF: sub_6BD8+33A↑j
                cp      18h
                jr      nz, loc_6F22
                ld      hl, byte_7D4B
                jr      loc_6F29
; ---------------------------------------------------------------------------

loc_6F22:                               ; CODE XREF: sub_6BD8+343↑j
                cp      20h ; ' '
                jr      nz, loc_6F4B
                ld      hl, byte_7D4F

loc_6F29:                               ; CODE XREF: sub_6BD8+32D↑j
                                        ; sub_6BD8+336↑j ...
                call    sub_7061
                ld      a, (byte_7B8A)
                or      a
                jr      z, loc_6F7A

loc_6F32:                               ; CODE XREF: sub_6BD8+3BA↓j
                ld      hl, (GEN_PTR_16)
                ld      a, (hl)
                and     7
                cp      6
                jr      z, loc_6F42
                call    sub_70DA
                call    sub_7279

loc_6F42:                               ; CODE XREF: sub_6BD8+362↑j
                                        ; sub_6BD8+3A5↓j
                call    dec2_PTR_16
                call    sub_720F
                jp      inc_PTR_16
; ---------------------------------------------------------------------------

loc_6F4B:                               ; CODE XREF: sub_6BD8+34C↑j
                cp      28h ; '('
                jr      nz, loc_6F54
                ld      hl, byte_7D59
                jr      loc_6F29
; ---------------------------------------------------------------------------

loc_6F54:                               ; CODE XREF: sub_6BD8+375↑j
                cp      30h ; '0'
                jr      nz, loc_6F5D
                ld      hl, byte_7D5E
                jr      loc_6F29
; ---------------------------------------------------------------------------

loc_6F5D:                               ; CODE XREF: sub_6BD8+37E↑j
                cp      38h ; '8'
                jr      nz, loc_6F66
                ld      hl, byte_7D54
                jr      loc_6F29
; ---------------------------------------------------------------------------

loc_6F66:                               ; CODE XREF: sub_6BD8+387↑j
                ld      a, (hl)
                and     0C0h
                cp      40h ; '@'
                jr      nz, loc_6F7F
                ld      hl, byte_7D63
                call    sub_7061
                call    sub_71E1
                ld      a, (byte_7B8A)
                or      a

loc_6F7A:                               ; CODE XREF: sub_6BD8+358↑j
                                        ; sub_6BD8+3B8↓j
                jp      z, loc_7133
                jr      loc_6F42
; ---------------------------------------------------------------------------

loc_6F7F:                               ; CODE XREF: sub_6BD8+393↑j
                cp      0C0h
                jr      nz, loc_6F94
                ld      hl, byte_7D68

loc_6F86:                               ; CODE XREF: sub_6BD8+3C3↓j
                call    sub_7061
                call    sub_71E1
                ld      a, (byte_7B8A)
                or      a
                jr      z, loc_6F7A
                jr      loc_6F32
; ---------------------------------------------------------------------------

loc_6F94:                               ; CODE XREF: sub_6BD8+3A9↑j
                cp      80h
                jr      nz, loc_6FBD
                ld      hl, byte_7D6D
                jr      loc_6F86
; ---------------------------------------------------------------------------

loc_6F9D:                               ; CODE XREF: sub_6BD8+318↑j
                ld      a, (byte_7B8A)
                or      a
                jr      z, loc_6FBA
                ld      a, (hl)
                cp      0F9h
                jr      nz, loc_6FAD
                ld      hl, byte_7D9E
                jr      loc_6FB4
; ---------------------------------------------------------------------------

loc_6FAD:                               ; CODE XREF: sub_6BD8+3CE↑j
                cp      0E3h
                jr      nz, loc_6FBD
                ld      hl, byte_7DA5

loc_6FB4:                               ; CODE XREF: sub_6BD8+3D3↑j
                call    sub_7061
                jp      loc_722F
; ---------------------------------------------------------------------------

loc_6FBA:                               ; CODE XREF: sub_6BD8+3C9↑j
                ld      a, (hl)
                cp      0EDh

loc_6FBD:                               ; CODE XREF: sub_6BD8+3BE↑j
                                        ; sub_6BD8+3D7↑j
                jp      nz, loc_729C
                call    inc_PTR_16
                ld      a, (hl)
                ld      hl, byte_7C45
                ld      b, 1Ch
                ld      de, byte_7E3F
                call    sub_72B0
                ret     z
                ld      a, (hl)
                and     0CFh
                cp      4Bh ; 'K'
                jr      nz, loc_6FE9
                ld      hl, byte_7C91
                call    sub_7061
                call    sub_7194
                call    sub_7279
                call    inc_PTR_16
                jp      sub_7167
; ---------------------------------------------------------------------------

loc_6FE9:                               ; CODE XREF: sub_6BD8+3FD↑j
                cp      43h ; 'C'
                jr      nz, loc_7008
                ld      hl, byte_7C91
                call    sub_7061
                call    inc_PTR_16
                call    sub_7167
                call    dec2_PTR_16
                call    sub_7279
                call    sub_7194
                call    inc_PTR_16
                jp      inc_PTR_16
; ---------------------------------------------------------------------------

loc_7008:                               ; CODE XREF: sub_6BD8+413↑j
                ld      a, (hl)
                and     0CFh
                cp      4Ah ; 'J'
                jr      nz, loc_7014
                ld      hl, byte_7D72
                jr      loc_701B
; ---------------------------------------------------------------------------

loc_7014:                               ; CODE XREF: sub_6BD8+435↑j
                cp      42h ; 'B'
                jr      nz, loc_7021
                ld      hl, byte_7D7A

loc_701B:                               ; CODE XREF: sub_6BD8+43A↑j
                call    sub_7061
                jp      sub_7194
; ---------------------------------------------------------------------------

loc_7021:                               ; CODE XREF: sub_6BD8+43E↑j
                ld      a, (hl)
                cp      4Dh ; 'M'
                jr      nz, loc_7030
                ld      hl, byte_7D82

loc_7029:                               ; CODE XREF: sub_6BD8+45F↓j
                ld      a, 9
                ld      (byte_7B8D), a
                jr      sub_7061
; ---------------------------------------------------------------------------

loc_7030:                               ; CODE XREF: sub_6BD8+44C↑j
                cp      45h ; 'E'
                jr      nz, loc_7039
                ld      hl, byte_7D87
                jr      loc_7029
; ---------------------------------------------------------------------------

loc_7039:                               ; CODE XREF: sub_6BD8+45A↑j
                and     0C7h
                cp      40h ; '@'
                jr      nz, loc_7050
                ld      hl, byte_7D8C
                call    sub_7061
                call    sub_7125
                call    sub_7279
                ld      hl, byte_7D90
                jr      SHOW_INSTR_HDR
; ---------------------------------------------------------------------------

loc_7050:                               ; CODE XREF: sub_6BD8+465↑j
                ld      a, (hl)
                and     0C7h
                cp      41h ; 'A'
                jp      nz, loc_729C
                ld      hl, byte_7D95
                call    sub_7061
                jp      sub_7125

; =============== S U B R O U T I N E =======================================


sub_7061:                               ; CODE XREF: sub_6BD8+48↑p
                                        ; sub_6BD8+5F↑p ...
                dec     hl
                ld      a, (byte_7EE4)
                or      a
                jr      nz, loc_7088
                ld      a, (dis_DISPLAY_FLG)
                or      a
                ret     z
                jr      loc_708F
; End of function sub_7061


; =============== S U B R O U T I N E =======================================


SHOW_INSTR_HDR:                               ; CODE XREF: RAM:601F↑p
                                        ; SHOW_REGS+83↑p ...

                ld      a, (byte_7EE4)
                or      a
                jr      nz, loc_707A
                ld      a, (dis_DISPLAY_FLG)
                or      a
                ret     z

loc_707A:                               ; CODE XREF: SHOW_INSTR_HDR+4↑j
                                        ; SHOW_INSTR_HDR+47↓j
                ld      a, (hl)
                cp      3
                ret     z
                cp      9
                jr      nz, loc_70AE
                ld      a, (byte_7EE4)
                or      a
                jr      z, loc_708F

loc_7088:                               ; CODE XREF: sub_7061+5↑j
                ld      a, 9
                call    sub_73B2
                jr      loc_70B2
; ---------------------------------------------------------------------------

loc_708F:                               ; CODE XREF: sub_7061+C↑j
                                        ; SHOW_INSTR_HDR+17↑j
                ld      a, 13h
                call    sub_7096
                jr      loc_70B2
; End of function SHOW_INSTR_HDR


; =============== S U B R O U T I N E =======================================


sub_7096:                               ; CODE XREF: DISASSEMBLE+78↑p
                                        ; SHOW_INSTR_HDR+22↑p ...
                ld      c, a
                ld      a, (NEXT_CHAR_ADD_L2) ; L2 Video DCB next char address $3C00<=X<=$3FFF
                and     3Fh ; '?'
                ld      b, a
                cp      c
                ld      a, c
                jr      c, loc_70A6
                ld      a, b
                and     38h ; '8'
                add     a, 8

loc_70A6:                               ; CODE XREF: sub_7096+9↑j
                sub     b
                ld      b, a

loc_70A8:                               ; CODE XREF: sub_7096+15↓j
                call    sub_7282
                djnz    loc_70A8
                ret
; End of function sub_7096

; ---------------------------------------------------------------------------

loc_70AE:                               ; CODE XREF: SHOW_INSTR_HDR+11↑j
                ld      a, (hl)
                call    sub_70B8

loc_70B2:                               ; CODE XREF: SHOW_INSTR_HDR+1E↑j
                                        ; SHOW_INSTR_HDR+25↑j
                inc     hl
                cp      0Dh
                ret     z
                jr      loc_707A

; =============== S U B R O U T I N E =======================================


sub_70B8:                               ; CODE XREF: DISASSEMBLE+85↑p
                                        ; sub_6BD8+73↑p ...
                push    af
                ld      a, (byte_7EE4)
                or      a
                jr      z, loc_70C3
                pop     af
                jp      sub_73B2
; ---------------------------------------------------------------------------

loc_70C3:                               ; CODE XREF: sub_70B8+5↑j
                ld      a, (dis_DISPLAY_FLG)
                or      a
                jr      nz, loc_70CB

loc_70C9:                               ; CODE XREF: sub_70B8+1C↓j
                pop     af
                ret
; ---------------------------------------------------------------------------

loc_70CB:                               ; CODE XREF: sub_70B8+F↑j
                pop     af
                call    TAS_VID_DRIVER
                push    af
                ld      a, (PRINT_OUT_FLAG)
                or      a
                jr      z, loc_70C9
                pop     af
                jp      TAS_PTR_DRIVER
; End of function sub_70B8


; =============== S U B R O U T I N E =======================================


sub_70DA:                               ; CODE XREF: sub_6BD8+364↑p
                cp      4
                jr      c, loc_70F0
                jr      nz, loc_70E4
                ld      a, 'H'
                jr      sub_70B8
; ---------------------------------------------------------------------------

loc_70E4:                               ; CODE XREF: sub_70DA+4↑j
                cp      5
                jr      nz, loc_70F4
                ld      a, 'L'
                jr      sub_70B8
; ---------------------------------------------------------------------------

loc_70EC:                               ; CODE XREF: sub_7129+8↓j
                                        ; sub_6BD8+561↓j
                cp      4
                jr      nc, loc_70F4

loc_70F0:                               ; CODE XREF: sub_70DA+2↑j
                add     a, 'B'
                jr      sub_70B8
; ---------------------------------------------------------------------------

loc_70F4:                               ; CODE XREF: sub_70DA+C↑j
                                        ; sub_70DA+14↑j
                cp      7
                jr      c, loc_70FC
                ld      a, 'A'
                jr      sub_70B8
; ---------------------------------------------------------------------------

loc_70FC:                               ; CODE XREF: sub_70DA+1C↑j
                cp      5
                jr      z, loc_7106
                jr      nc, loc_7118
                ld      a, 'H'
                jr      loc_7108
; ---------------------------------------------------------------------------

loc_7106:                               ; CODE XREF: sub_70DA+24↑j
                ld      a, 'L'

loc_7108:                               ; CODE XREF: sub_70DA+2A↑j
                call    sub_70B8
                ld      a, (byte_7B8B)
                cp      0DDh
                ret     c
                ld      a, 58h ; 'X'
                jr      z, sub_70B8
                inc     a
                jr      sub_70B8
; ---------------------------------------------------------------------------

loc_7118:                               ; CODE XREF: sub_70DA+26↑j
                ld      a, (byte_7B8A)
                or      a
                jp      nz, sub_720F
                ld      hl, HL_ascii    ; Text for (HL)
                jp      SHOW_INSTR_HDR
; End of function sub_70DA


; =============== S U B R O U T I N E =======================================


sub_7125:                               ; CODE XREF: sub_6BD8+1E7↑p
                                        ; sub_6BD8:loc_6E3B↑j ...
                ld      hl, (GEN_PTR_16)
                ld      a, (hl)
; End of function sub_7125


; =============== S U B R O U T I N E =======================================


sub_7129:                               ; CODE XREF: sub_6BD8+4D↑p
                and     38h ; '8'
                srl     a
                srl     a
                srl     a
                jr      loc_70EC
; End of function sub_7129

; ---------------------------------------------------------------------------

loc_7133:                               ; CODE XREF: sub_6BD8:loc_6EA2↑j
                                        ; sub_6BD8:loc_6F7A↑j
                ld      hl, (GEN_PTR_16)
                ld      a, (hl)

loc_7137:                               ; CODE XREF: sub_6BD8+54↑j
                and     7
                jr      loc_70EC

; =============== S U B R O U T I N E =======================================

; Increment general purpose 16 bit pointer by 1

inc_PTR_16:	
		ld      hl, (GEN_PTR_16)
                inc     hl
                ld      (GEN_PTR_16), hl
                ret

; =============== S U B R O U T I N E =======================================


sub_7143:                               ; CODE XREF: sub_6BD8+BB↑j
                                        ; sub_6BD8+178↑p ...
                ld      hl, (GEN_PTR_16)
; End of function sub_7143


; =============== S U B R O U T I N E =======================================


sub_7146:                               ; CODE XREF: DISASSEMBLE:loc_6B79↑p
                                        ; sub_7173+F↓p ...
                ld      a, (hl)
; End of function sub_7146


; =============== S U B R O U T I N E =======================================


sub_7147:                               ; CODE XREF: SHOW_REGS+90↑p
                                        ; GET_COMMAND+4B1↑p ...
                push    af
                ld      a, (byte_7EE4)
                or      a
                jp      nz, loc_749F
                pop     af
; End of function sub_7147


; =============== S U B R O U T I N E =======================================


sub_7150:                               ; CODE XREF: sub_748C+21↓p
                push    af
                srl     a
                srl     a
                srl     a
                srl     a
                call    sub_715F
                pop     af
                and     0Fh
; End of function sub_7150


; =============== S U B R O U T I N E =======================================


sub_715F:                               ; CODE XREF: sub_7150+9↑p
                                        ; sub_724D+9↓p ...
                add     a, 90h
                daa
                adc     a, 40h ; '@'
                daa
                jr      loc_71B1
; End of function sub_715F


; =============== S U B R O U T I N E =======================================


sub_7167:                               ; CODE XREF: sub_6BD8:loc_6C6D↑j
                                        ; sub_6BD8+A5↑p ...
                ld      a, 28h ; '('
                call    sub_70B8
                call    sub_7173
                ld      a, 29h ; ')'
                jr      loc_71B1
; End of function sub_7167


; =============== S U B R O U T I N E =======================================


sub_7173:                               ; CODE XREF: SHOW_REGS+46↑p
                                        ; GET_COMMAND:loc_6609↑p ...

                ld      a, (byte_7EE9)
                or      a
                jp      nz, loc_74B5
                ld      a, (byte_7EE4)
                or      a
                jp      nz, loc_74C4
                inc     hl
                call    sub_7146
                dec     hl
                call    sub_7146
                jr      inc_PTR_16
; End of function sub_7173


; =============== S U B R O U T I N E =======================================


sub_718B:                               ; CODE XREF: sub_6BD8+8C↑p
                                        ; sub_6BD8+AB↑j ...
                ld      b, 0
                ld      c, 4
                ld      hl, byte_7C61
                jr      loc_71B3
; End of function sub_718B


; =============== S U B R O U T I N E =======================================


sub_7194:                               ; CODE XREF: sub_6BD8+273↑p
                                        ; sub_6BD8:loc_6ED8↑j ...

                ld      hl, (GEN_PTR_16)
                ld      a, (hl)
                and     30h ; '0'
                srl     a
                srl     a
                srl     a
                ld      c, a
                ld      b, 0
                ld      hl, byte_7C69

loc_71A6:                               ; CODE XREF: sub_6BD8+5F5↓j
                cp      4
                jr      z, loc_71B3

loc_71AA:                               ; CODE XREF: sub_7194+23↓j
                                        ; sub_71CF+10↓j
                add     hl, bc
                ld      a, (hl)
                call    sub_70B8
                inc     hl
                ld      a, (hl)

loc_71B1:                               ; CODE XREF: sub_715F+6↑j
                                        ; sub_7167+A↑j
                jr      loc_722C
; ---------------------------------------------------------------------------

loc_71B3:                               ; CODE XREF: sub_718B+7↑j
                                        ; sub_7194+14↑j
                ld      a, (byte_7B8A)
                or      a
                jr      z, loc_71AA
                jr      loc_722F
; End of function sub_7194

; ---------------------------------------------------------------------------

loc_71BB:                               ; CODE XREF: sub_6BD8+293↑j
                ld      hl, (GEN_PTR_16)
                ld      a, (hl)
                and     30h ; '0'
                srl     a
                srl     a
                srl     a
                ld      c, a
                ld      b, 0
                ld      hl, byte_7C61
                jr      loc_71A6

; =============== S U B R O U T I N E =======================================


sub_71CF:                               ; CODE XREF: sub_6BD8+20E↑p
                                        ; sub_6BD8+226↑p ...
                ld      hl, (GEN_PTR_16)
                ld      a, (hl)
                and     38h ; '8'
                srl     a
                srl     a
                ld      c, a
                ld      b, 0
                ld      hl, byte_7C81
                jr      loc_71AA
; End of function sub_71CF


; =============== S U B R O U T I N E =======================================


sub_71E1:                               ; CODE XREF: sub_6BD8+39B↑p
                                        ; sub_6BD8+3B1↑p
                ld      hl, (GEN_PTR_16)
                ld      a, (hl)
                and     38h ; '8'
                srl     a
                srl     a
                srl     a
                add     a, 30h ; '0'
                call    sub_70B8
                jp      sub_7279
; End of function sub_71E1


; =============== S U B R O U T I N E =======================================


sub_71F5:                               ; CODE XREF: sub_60FF+A5↑p
                                        ; sub_6BD8+103↑j
                ld      hl, (GEN_PTR_16)
                ld      a, (hl)
                ld      c, a
                ld      b, 0
                inc     bc
                ld      a, c
                bit     7, a
                jr      z, loc_7203
                dec     h

loc_7203:                               ; CODE XREF: sub_71F5+B↑j
                add     hl, bc
                jr      HL_to_HEX
; End of function sub_71F5


; =============== S U B R O U T I N E =======================================

; decrement egneral purpose PTR16 by 2

dec2_PTR_16:
		ld      hl, (GEN_PTR_16)
                dec     hl
                dec     hl
                ld      (GEN_PTR_16), hl
                ret

; =============== S U B R O U T I N E =======================================


sub_720F:                               ; CODE XREF: sub_6BD8+36D↑p
                                        ; sub_70DA+42↑j
                ld      a, 28h ; '('
                call    sub_70B8
                ld      a, (byte_7B8A)
                cp      0DDh
                ld      hl, a_IXplus
                jr      z, loc_7221
                ld      hl, a_IYplus

loc_7221:                               ; CODE XREF: sub_720F+D↑j
                call    SHOW_INSTR_HDR
                call    inc_PTR_16
                call    sub_7143
                ld      a, 29h ; ')'

loc_722C:                               ; CODE XREF: sub_7194:loc_71B1↑j
                                        ; sub_7279+2↓j
                jp      sub_70B8
; End of function sub_720F

; ---------------------------------------------------------------------------

loc_722F:                               ; CODE XREF: sub_6BD8+3DF↑j
                                        ; sub_7194+25↑j
                ld      a, (byte_7B8A)
                cp      0DDh
                ld      hl, a_IX
                jr      z, loc_723C
                ld      hl, a_IY

loc_723C:                               ; CODE XREF: sub_6BD8+65F↑j
                jp      SHOW_INSTR_HDR

; =============== S U B R O U T I N E =======================================


HL_to_HEX:                              ; CODE XREF: sub_60FF+9↑p
                                        ; GET_COMMAND:loc_64CD↑p ...


                ld      a, (byte_7EE4)
                or      a
                jp      nz, loc_7480
                ld      a, (byte_7EE9)
                or      a
                jp      nz, loc_7412

; =============== S U B R O U T I N E =======================================


sub_724D:                               ; CODE XREF: sub_748C:loc_7498↓p
                ld      a, h
                srl     a
                srl     a
                srl     a
                srl     a
                call    sub_715F
                ld      a, h
                and     0Fh
                call    sub_715F
                ld      a, l
                srl     a
                srl     a
                srl     a
                srl     a
                call    sub_715F
                ld      a, l
                and     0Fh
                jp      sub_715F
; End of function sub_724D

; ---------------------------------------------------------------------------
                ld      hl, (GEN_PTR_16)
                dec     hl
                ld      (GEN_PTR_16), hl
                ret

; =============== S U B R O U T I N E =======================================


sub_7279:                               ; CODE XREF: sub_6BD8+50↑p
                                        ; sub_6BD8+8F↑p ...
                ld      a, 2Ch ; ','
                jr      loc_722C
; End of function sub_7279


; =============== S U B R O U T I N E =======================================

; Output a SPC to video and return to caller

SPC_VID_OUT:                            ; CODE XREF: sub_60FF+C↑p
                                        ; SHOW_REGS+4D↑p ...
                ld      a, 20h ; ' '
                jp      TAS_VID_DRIVER
; End of function SPC_VID_OUT


; =============== S U B R O U T I N E =======================================


sub_7282:                               ; CODE XREF: DISASSEMBLE+2F↑p
                                        ; sub_7096:loc_70A8↑p
                ld      a, (byte_7EE4)
                or      a
                jr      nz, sub_728D
                ld      a, (dis_DISPLAY_FLG)
                or      a
                ret     z
; End of function sub_7282


; =============== S U B R O U T I N E =======================================


sub_728D:                               ; CODE XREF: DISASSEMBLE:loc_6BAF↑p
                                        ; sub_7282+4↑j
                ld      a, 20h ; ' '
                call    TAS_VID_DRIVER
                ld      a, (PRINT_OUT_FLAG)
                or      a
                ret     z
                ld      a, 20h ; ' '
                jp      TAS_PTR_DRIVER
; End of function sub_728D

; ---------------------------------------------------------------------------

loc_729C:                               ; CODE XREF: sub_6BD8:loc_6FBD↑j
                                        ; sub_6BD8+47D↑j
                ld      a, 1
                ld      (byte_7EEB), a
                ld      hl, (dis_DISASSEM_START)
                ld      (GEN_PTR_16), hl
                ld      hl, a_DEFB
                call    sub_7061
                jp      sub_7143

; =============== S U B R O U T I N E =======================================


sub_72B0:                               ; CODE XREF: sub_6BD8+C↑p
                                        ; sub_6BD8+3F4↑p
                ld      c, b

loc_72B1:                               ; CODE XREF: sub_72B0+5↓j
                cp      (hl)
                jr      z, loc_72BE
                inc     hl
                djnz    loc_72B1
                ld      hl, (GEN_PTR_16)
                ld      a, 1
                or      a
                ret
; ---------------------------------------------------------------------------

loc_72BE:                               ; CODE XREF: sub_72B0+2↑j
                ld      a, c
                sub     b
                inc     a
                ex      de, hl
                ld      e, a
                ld      a, 3
                ld      bc, 0

loc_72C8:                               ; CODE XREF: sub_72B0+1B↓j
                cpir
                dec     e
                jr      nz, loc_72C8
                call    sub_7061
                ld      hl, (GEN_PTR_16)
                xor     a
                ret

; ---------------------------------------------------------------------------

output_disassembly:                     ; CODE XREF: GET_COMMAND+7B↑j
                call    OUT_CHAR_SPC    ; output char in A, followed by a space to vid and return

out_key_error:                          ; CODE XREF: GET_COMMAND+12A9↓j
                call    GET_CHAR        ; get character, return in A
                ld      b, 0
                cp      44h ; 'D'
                jr      z, out_disassem_disk
                cp      54h ; 'T'
                jr      nz, out_key_error
                inc     b

out_disassem_disk:                      ; CODE XREF: GET_COMMAND+12A5↑j
                call    GET_PARAMS
                ld      a, b
                ld      (DISK_TAPE_FLAG), a ; 1 = TAPE, 0 = DISK
                ld      hl, (MEM_SIZE)
                ld      (word_7EE5), hl
                ld      hl, 0
                ld      (word_7EE7), hl
                ld      de, (parm_START)
                ld      hl, (parm_END)
                call    check_range     ; HL = Start, DE = End. Ensure DE >= HL (1=OK, 0=ERR)
                jp      z, return_from_user
                ld      a, (DISK_TAPE_FLAG) ; 1 = TAPE, 0 = DISK
                or      a
                jr      nz, loc_7322
                call    OPEN_DSK_FILE_WR
                call    sub_739B
                ld      a, 0D3h
                call    sub_73C1
                ld      b, 6

loc_7319:                               ; CODE XREF: GET_COMMAND+12E4↓j
                ld      a, 41h ; 'A'
                call    sub_73C1
                djnz    loc_7319
                jr      loc_732D
; ---------------------------------------------------------------------------

loc_7322:                               ; CODE XREF: GET_COMMAND+12D0↑j
                call    GET_PARAM_STRING
                call    sub_739B
                ld      a, 0D3h
                call    WRITE_FILENAME

loc_732D:                               ; CODE XREF: GET_COMMAND+12E6↑j
                call    SET_PROMPT_POS
                call    do_clear_screen
                call    sub_7403
                ld      hl, disORG
                ld      a, 1
                ld      (byte_7EE4), a
                ld      (dis_DISPLAY_FLG), a
                call    sub_7061
                ld      hl, (parm_START)
                call    sub_748C
                xor     a
                ld      (byte_7EE4), a
                ld      (dis_DISPLAY_FLG), a
                ld      a, 0Dh
                call    sub_73B2
                ld      (GEN_PTR_16), hl
                ld      a, 1
                ld      (byte_7EE4), a
                ld      hl, (parm_START)
                ld      (GEN_PTR_16), hl
                call    sub_73D5
                call    sub_7403
                ld      hl, disEND
                call    sub_7061
                ld      hl, (parm_TRANSFER)
                call    sub_748C
                xor     a
                ld      (byte_7EE4), a
                ld      a, 0Dh
                call    sub_73B2
                ld      a, 1Ah
                call    sub_73B2
                ld      a, (DISK_TAPE_FLAG) ; 1 = TAPE, 0 = DISK
                or      a
                jr      z, loc_738F
#IFDEF TRS80
                call    Cassette_Off	; no motor control on VZ/LASER
#ENDIF
                jr      loc_7398
; ---------------------------------------------------------------------------

loc_738F:                               ; CODE XREF: GET_COMMAND+134E↑j
                ld      de, string_buffer
                call    DOS_CLOSE
                jp      nz, loc_7602

loc_7398:                               ; CODE XREF: GET_COMMAND+1353↑j
                jp      return_from_user

; =============== S U B R O U T I N E =======================================


sub_739B:                               ; CODE XREF: GET_COMMAND+12D5↑p
                                        ; GET_COMMAND+12EB↑p
                xor     a
                ld      (dis_DISPLAY_FLG), a
                inc     a
                ld      (byte_7EE9), a
                ld      hl, (parm_START)
                ld      (GEN_PTR_16), hl
                di
                call    sub_73D5
                xor     a
                ld      (byte_7EE9), a
                ret


; =============== S U B R O U T I N E =======================================


sub_73B2:                               ; CODE XREF: SHOW_INSTR_HDR+1B↑p
                                        ; sub_70B8+8↑j ...
                push    af
                cp      9
                jr      nz, loc_73BD
                xor     a
                call    sub_7096
                jr      loc_73C0
; ---------------------------------------------------------------------------

loc_73BD:                               ; CODE XREF: sub_73B2+3↑j
                call    TAS_VID_DRIVER

loc_73C0:                               ; CODE XREF: sub_73B2+9↑j
                pop     af
; End of function sub_73B2


; =============== S U B R O U T I N E =======================================


sub_73C1:                               ; CODE XREF: GET_COMMAND+12DA↑p
                                        ; GET_COMMAND+12E1↑p ...
                push    de
                push    af
                ld      a, (DISK_TAPE_FLAG) ; 1 = TAPE, 0 = DISK
                or      a
                jr      z, loc_73CF
                pop     af
                call    CASS_WRITE_BYTE
                pop     de
                ret
; ---------------------------------------------------------------------------

loc_73CF:                               ; CODE XREF: sub_73C1+6↑j
                pop     af
                call    sub_7636
                pop     de
                ret
; End of function sub_73C1


; =============== S U B R O U T I N E =======================================


sub_73D5:                               ; CODE XREF: GET_COMMAND+132A↑p
                                        ; sub_739B+F↑p ...
                ld      hl, (GEN_PTR_16)
                ld      a, (byte_7EE4)
                or      a
                jr      z, loc_73E1
                call    sub_7403

loc_73E1:                               ; CODE XREF: sub_73D5+7↑j
                ld      bc, 1
                xor     a
                call    DISASSEMBLE
                call    inc_PTR_16
                ld      a, (byte_7EE4)
                or      a
                jr      z, loc_73F6
                ld      a, 0Dh
                call    sub_73B2

loc_73F6:                               ; CODE XREF: sub_73D5+1A↑j
                ld      hl, (GEN_PTR_16)
                ld      de, (parm_END)
                call    check_range     ; HL = Start, DE = End. Ensure DE >= HL (1=OK, 0=ERR)
                jr      z, sub_73D5
                ret
; End of function sub_73D5


; =============== S U B R O U T I N E =======================================


sub_7403:                               ; CODE XREF: GET_COMMAND+12F9↑p
                                        ; GET_COMMAND+132D↑p ...
                ld      b, 5

loc_7405:                               ; CODE XREF: sub_7403+7↓j
                ld      a, 0B0h
                call    sub_73C1
                djnz    loc_7405
                ld      a, 20h ; ' '
                call    sub_73C1
                ret
; End of function sub_7403

; ---------------------------------------------------------------------------

loc_7412:                               ; CODE XREF: HL_to_HEX+B↑j
                                        ; sub_7173+34E↓j
                push    de
                ld      de, (parm_START)
                call    check_range     ; HL = Start, DE = End. Ensure DE >= HL (1=OK, 0=ERR)
                jr      z, loc_7447
                ld      de, (parm_END)
                call    check_range     ; HL = Start, DE = End. Ensure DE >= HL (1=OK, 0=ERR)
                jr      nz, loc_7447
                pop     de
                call    sub_7449
                ret     z
                ld      (STACK_SAVE), sp
                ld      sp, (word_7EE5)
                push    hl
                ld      (word_7EE5), sp
                ld      sp, (STACK_SAVE)
                push    bc
                ld      bc, (word_7EE7)
                inc     bc
                ld      (word_7EE7), bc
                pop     bc
                ret
; ---------------------------------------------------------------------------

loc_7447:                               ; CODE XREF: HL_to_HEX+1DB↑j
                                        ; HL_to_HEX+1E4↑j
                pop     de
                ret

; =============== S U B R O U T I N E =======================================


sub_7449:                               ; CODE XREF: HL_to_HEX+1E7↑p
                                        ; sub_747A↓p ...
                push    bc
                push    de
                ld      (STACK_SAVE), sp
                ld      sp, (word_7EE5)
                ld      bc, (word_7EE7)
                ld      a, b
                or      c
                jr      z, loc_7468

loc_745B:                               ; CODE XREF: sub_7449+1D↓j
                pop     de
                ex      de, hl
                xor     a
                sbc     hl, de
                ex      de, hl
                jr      z, loc_7472
                dec     bc
                ld      a, b
                or      c
                jr      nz, loc_745B

loc_7468:                               ; CODE XREF: sub_7449+10↑j
                ld      sp, (STACK_SAVE)
                pop     de
                pop     bc
                ld      a, 1
                or      a
                ret
; ---------------------------------------------------------------------------

loc_7472:                               ; CODE XREF: sub_7449+18↑j
                ld      sp, (STACK_SAVE)
                pop     de
                pop     bc
                xor     a
                ret
; End of function sub_7449


; =============== S U B R O U T I N E =======================================


sub_747A:                               ; CODE XREF: DISASSEMBLE+1A↑p
                call    sub_7449
                ret     nz
                jr      loc_7485
; ---------------------------------------------------------------------------

loc_7480:                               ; CODE XREF: HL_to_HEX+4↑j
                                        ; sub_7173+35D↓j
                call    sub_7449
                jr      nz, sub_748C

loc_7485:                               ; CODE XREF: sub_747A+4↑j
                ld      a, 5Ah ; 'Z'
                call    sub_73B2
                jr      loc_7498
; End of function sub_747A


; =============== S U B R O U T I N E =======================================


sub_748C:                               ; CODE XREF: GET_COMMAND+130D↑p
                                        ; GET_COMMAND+1339↑p ...
                ld      a, h
                srl     a
                cp      50h ; 'P'
                jr      c, loc_7498
                ld      a, 30h ; '0'
                call    sub_73B2

loc_7498:                               ; CODE XREF: sub_747A+10↑j
                                        ; sub_748C+5↑j
                call    sub_724D
                ld      a, 48h ; 'H'
                jr      loc_74B2
; ---------------------------------------------------------------------------

loc_749F:                               ; CODE XREF: sub_7147+5↑j
                pop     af
                push    af
                srl     a
                cp      50h ; 'P'
                jr      c, loc_74AC
                ld      a, 30h ; '0'
                call    sub_73B2

loc_74AC:                               ; CODE XREF: sub_748C+19↑j
                pop     af
                call    sub_7150
                ld      a, 48h ; 'H'

loc_74B2:                               ; CODE XREF: sub_748C+11↑j
                jp      sub_73B2
; End of function sub_748C

; ---------------------------------------------------------------------------

loc_74B5:                               ; CODE XREF: sub_7173+4↑j
                ld      a, (hl)
                push    af
                inc     hl
                ld      a, (hl)
                ld      h, a
                pop     af
                ld      l, a
                push    hl
                call    inc_PTR_16
                pop     hl
                jp      loc_7412
; ---------------------------------------------------------------------------

loc_74C4:                               ; CODE XREF: sub_7173+B↑j
                ld      a, (hl)
                push    af
                inc     hl
                ld      a, (hl)
                ld      h, a
                pop     af
                ld      l, a
                push    hl
                call    inc_PTR_16
                pop     hl
                jr      loc_7480

; ---------------------------------------------------------------------------

load_cmd_file:                          ; CODE XREF: GET_COMMAND+67↑j
                call    OUT_CHAR_SPC    ; output char in A, followed by a space to vid and return
                di
                xor     a
                ld      (byte_7F3D), a
                ld      hl, 0
                ld      (parm_OFFSET), hl
                ld      (parm_START), hl
                dec     hl
                ld      (parm_END), hl

loc_74E7:                               ; CODE XREF: GET_COMMAND+14B7↓j
                call    GET_CHAR        ; get character, return in A
                cp      54h ; 'T'
                jp      z, load_tape_file
                cp      44h ; 'D'
                jr      nz, loc_74E7
                call    OUT_CHAR_SPC    ; output char in A, followed by a space to vid and return

loc_74F6:                               ; CODE XREF: GET_COMMAND+14C5↓j
                call    GET_HEX_CHAR
                jr      z, loc_7501
                cp      0Dh
                jr      z, loc_750A
                jr      loc_74F6
; ---------------------------------------------------------------------------

loc_7501:                               ; CODE XREF: GET_COMMAND+14BF↑j
                call    HEX_VAL_to_HL   ; 4 byte hex value to HL register
                ld      (parm_OFFSET), hl

disk_file_info:                         ; CODE XREF: GET_COMMAND+1A19↓j
                call    TAS_VID_DRIVER

loc_750A:                               ; CODE XREF: GET_COMMAND+14C3↑j
                call    OPEN_DSK_FILE_RD

loc_750D:                               ; CODE XREF: GET_COMMAND+14FC↓j
                                        ; GET_COMMAND+1536↓j
                call    sub_75A3
                cp      1
                jr      z, loc_7538
                cp      2
                jr      z, loc_7572
                or      a
                jr      z, loc_7525
                cp      3
                jp      m, loc_75AE
                cp      20h ; ' '
                jp      p, loc_75AE

loc_7525:                               ; CODE XREF: GET_COMMAND+14DF↑j
                call    sub_75A3
                sub     2
                ld      b, a
                call    sub_75A3
                call    sub_75A3

loc_7531:                               ; CODE XREF: GET_COMMAND+14FA↓j
                call    sub_75A3
                djnz    loc_7531
                jr      loc_750D
; ---------------------------------------------------------------------------

loc_7538:                               ; CODE XREF: GET_COMMAND+14D8↑j
                call    sub_75A3
                sub     2
                ld      b, a
                call    sub_75A3
                ld      l, a
                call    sub_75A3
                ld      h, a
                ld      de, (parm_OFFSET)
                add     hl, de
                ld      de, (parm_END)
                ex      de, hl
                call    sub_7813
                ex      de, hl

loc_7554:                               ; CODE XREF: GET_COMMAND+152A↓j
                call    sub_75A3
                push    af
                ld      a, (byte_7F3D)
                or      a
                jr      z, loc_7561
                pop     af
                jr      loc_7563
; ---------------------------------------------------------------------------

loc_7561:                               ; CODE XREF: GET_COMMAND+1522↑j
                pop     af
                ld      (hl), a

loc_7563:                               ; CODE XREF: GET_COMMAND+1525↑j
                inc     hl
                djnz    loc_7554
                dec     hl
                ld      de, (parm_START)
                ex      de, hl
                call    sub_781C
                ex      de, hl
                jr      loc_750D
; ---------------------------------------------------------------------------

loc_7572:                               ; CODE XREF: GET_COMMAND+14DC↑j
                call    sub_75A3
                call    sub_75A3
                ld      l, a
                call    sub_75A3
                ld      h, a
                ld      de, (parm_OFFSET)
                add     hl, de
                push    hl
                ld      de, string_buffer
                call    DOS_CLOSE
                jr      nz, loc_7602
                ld      hl, (parm_END)
                call    HL_to_HEX
                call    SPC_VID_OUT     ; Output a SPC to video and return to caller
                ld      hl, (parm_START)
                call    HL_to_HEX
                call    SPC_VID_OUT     ; Output a SPC to video and return to caller
                pop     hl
                call    HL_to_HEX
                jr      loc_7618

; =============== S U B R O U T I N E =======================================


sub_75A3:                               ; CODE XREF: GET_COMMAND:loc_750D↑p
                                        ; GET_COMMAND:loc_7525↑p ...

                push    de
                ld      de, string_buffer
                call    ROM_KBD_Routine
                pop     de
                jr      nz, loc_7602
                ret
; ---------------------------------------------------------------------------

loc_75AE:                               ; CODE XREF: GET_COMMAND+14E3↑j
                                        ; GET_COMMAND+14E8↑j
                ld      a, 22h ; '"'
                jr      loc_7602
; ---------------------------------------------------------------------------

write_tape_disk:                        ; CODE XREF: GET_COMMAND+6C↑j
                call    OUT_CHAR_SPC    ; output char in A, followed by a space to vid and return
                di

loc_75B6:                               ; CODE XREF: sub_75A3+1D↓j
                call    GET_CHAR        ; get character, return in A
                cp      54h ; 'T'
                jp      z, write_tape_file
                cp      44h ; 'D'
                jr      nz, loc_75B6
                call    GET_PARAMS
                call    OPEN_DSK_FILE_WR
                ld      de, (parm_START)
                ld      hl, (parm_END)
                xor     a
                sbc     hl, de
                inc     hl

loc_75D3:                               ; CODE XREF: sub_75A3+39↓j
                dec     h
                jp      m, loc_75DE
                ld      b, 0
                call    sub_761B
                jr      loc_75D3
; ---------------------------------------------------------------------------

loc_75DE:                               ; CODE XREF: sub_75A3+31↑j
                ld      b, l
                xor     a
                cp      l
                call    nz, sub_761B
                ld      a, 2
                call    sub_7636
                ld      a, 2
                call    sub_7636
                ld      a, (parm_TRANSFER)
                call    sub_7636
                ld      a, (parm_TRANSFER+1)
                call    sub_7636
                ld      de, string_buffer
                call    DOS_CLOSE
                jr      z, loc_7618

loc_7602:                               ; CODE XREF: GET_COMMAND+135B↑j
                                        ; GET_COMMAND+154F↑j ...
                push    af
                xor     a
                ld      (byte_7EE4), a
                inc     a
                ld      (dis_DISPLAY_FLG), a
                call    SCROLL_SAVEREGS ; save all regs and scroll down
                ld      hl, DOS_ERROR
                call    SHOW_INSTR_HDR
                pop     af
                call    sub_7147

loc_7618:                               ; CODE XREF: GET_COMMAND+1567↑j
                                        ; sub_75A3+5D↑j
                jp      return_from_user

; =============== S U B R O U T I N E =======================================


sub_761B:                               ; CODE XREF: sub_75A3+36↑p
                                        ; sub_75A3+3E↑p
                ld      a, 1
                call    sub_7636
                ld      a, 2
                add     a, b
                call    sub_7636
                ld      a, e
                call    sub_7636
                ld      a, d
                call    sub_7636

loc_762E:                               ; CODE XREF: sub_761B+18↓j
                ld      a, (de)
                call    sub_7636
                inc     de
                djnz    loc_762E
                ret

; =============== S U B R O U T I N E =======================================


sub_7636:
		push    de
                ld      de, string_buffer
                call    ROM_DISPLAY_Routine
                jr      nz, loc_7602
                di
                pop     de
                ret

OPEN_DSK_FILE_WR:
		call    GET_DOS_PARAMS
                call    DOS_INIT
                jr      nz, loc_7602
                ret


OPEN_DSK_FILE_RD:                               
                call    GET_DOS_PARAMS
                call    DOS_OPEN
                jr      nz, loc_7602
                jp      SCROLL_SAVEREGS ; save all regs and scroll down


GET_DOS_PARAMS:
		call    SCROLL_SAVEREGS		; save all regs and scroll down
                ld      hl, string_buffer
                ld      b, 17h
                call    GET_ASCII		; Get ascii string to (HL), maxlen = B
                ld      de, string_buffer
                ld      b, 0			; LRL 0 = 256 bytes
                ld      hl, Sector_Buffer	; 256 byte DOS workspace
                ret

; ---------------------------------------------------------------------------

load_tape_file:                         ; CODE XREF: GET_COMMAND+14B2↑j
                call    OUT_CHAR_SPC    ; output char in A, followed by a space to vid and return

loc_766D:                               ; CODE XREF: GET_COMMAND+163C↓j
                call    GET_HEX_CHAR
                jr      z, loc_7678
                cp      0Dh
                jr      z, tape_file_info
                jr      loc_766D
; ---------------------------------------------------------------------------

loc_7678:                               ; CODE XREF: GET_COMMAND+1636↑j
                call    HEX_VAL_to_HL   ; 4 byte hex value to HL register
                ld      (parm_OFFSET), hl

tape_file_info:                         ; CODE XREF: GET_COMMAND+163A↑j
                                        ; GET_COMMAND+1A23↓j
                call    SCROLL_SAVEREGS ; save all regs and scroll down
                xor     a
#IFDEF TRS80
                call    Select_Cass_Unit ; no unit control on VZ/LASER
#ENDIF
                call    Cass_Find_Sync

wait_cass_sync_byte:                    ; CODE XREF: GET_COMMAND+1653↓j
                call    CASS_READ_BYTE
                cp      55h ; 'U'
                jr      nz, wait_cass_sync_byte
                ld      b, 6

show_tape_filename:                     ; CODE XREF: GET_COMMAND+165D↓j
                call    CASS_READ_BYTE
                call    TAS_VID_DRIVER
                djnz    show_tape_filename

loc_7699:                               ; CODE XREF: GET_COMMAND+1668↓j
                                        ; GET_COMMAND+16A8↓j
                call    CASS_READ_BYTE
                cp      78h ; 'x'
                jr      z, loc_76E4
                cp      3Ch ; '<'
                jr      nz, loc_7699
                call    CASS_READ_BYTE
                ld      b, a
                call    CASS_READ_BYTE
                ld      e, a
                call    CASS_READ_BYTE
                ld      d, a
                add     a, e
                ld      c, a
                ld      hl, (parm_OFFSET)
                add     hl, de
                push    hl
                pop     de
                ld      hl, (parm_END)
                call    sub_7813

loc_76BE:                               ; CODE XREF: GET_COMMAND+1696↓j
                call    CASS_READ_BYTE
                push    af
                ld      a, (byte_7F3D)
                or      a
                jr      z, loc_76CB
                pop     af
                jr      loc_76CD
; ---------------------------------------------------------------------------

loc_76CB:                               ; CODE XREF: GET_COMMAND+168C↑j
                pop     af
                ld      (de), a

loc_76CD:                               ; CODE XREF: GET_COMMAND+168F↑j
                inc     de
                add     a, c
                ld      c, a
                djnz    loc_76BE
                dec     de
                ld      hl, (parm_START)
                call    sub_781C
                call    CASS_READ_BYTE
                cp      c
                jr      nz, loc_7711
#IFDEF TRS80
                call    Blink_Asterisk	; no equivalent on VZ/LASER
#ENDIF
                jr      loc_7699
; ---------------------------------------------------------------------------

loc_76E4:                               ; CODE XREF: GET_COMMAND+1664↑j
                call    CASS_READ_BYTE
                ld      l, a
                call    CASS_READ_BYTE
                ld      h, a
                ld      de, (parm_OFFSET)
                add     hl, de
                push    hl
#IFDEF TRS80
                call    Cassette_Off
#ENDIF
		call    SCROLL_SAVEREGS ; save all regs and scroll down
                ld      hl, (parm_END)
                call    HL_to_HEX
                call    SPC_VID_OUT     ; Output a SPC to video and return to caller
                ld      hl, (parm_START)
                call    HL_to_HEX
                call    SPC_VID_OUT     ; Output a SPC to video and return to caller
                pop     hl
                call    HL_to_HEX
                jp      return_from_user
; ---------------------------------------------------------------------------

loc_7711:                               ; CODE XREF: GET_COMMAND+16A3↑j
                call    SCROLL_SAVEREGS ; save all regs and scroll down
                xor     a
                ld      (byte_7EE4), a
                ld      hl, TAPE_ERROR  ; tape error message
                call    SHOW_INSTR_HDR
#IFDEF TRS80
                jp      Cassette_Off
#ELSE
		ret			; Just return on VZ, no motor control
#ENDIF

; =============== S U B R O U T I N E =======================================


GET_PARAM_STRING:

                call    SCROLL_SAVEREGS ; save all regs and scroll down
                ld      hl, string_buffer
                ld      b, 6
                call    GET_ASCII       ; Get ascii string to (HL), maxlen = B
                xor     a
#IFDEF TRS80
                call    Select_Cass_Unit ; no unit control on VZ/LASER
#ENDIF
                jp      Write_Leader_Sync

; =============== S U B R O U T I N E =======================================


WRITE_FILENAME:                        ; CODE XREF: GET_COMMAND+12F0↑p
                                        ; sub_75A3+1B0↓p
                call    CASS_WRITE_BYTE
                ld      hl, string_buffer
                ld      b, 6

loc_773B:                               ; CODE XREF: WRITE_FILENAME+15↓j
                ld      a, (hl)
                cp      0Dh
                jr      nz, loc_7744
                ld      a, 20h ; ' '
                jr      loc_7745
; ---------------------------------------------------------------------------

loc_7744:                               ; CODE XREF: WRITE_FILENAME+B↑j
                inc     hl

loc_7745:                               ; CODE XREF: WRITE_FILENAME+F↑j
                call    CASS_WRITE_BYTE
                djnz    loc_773B
                ret

; ---------------------------------------------------------------------------

write_tape_file:                        ; CODE XREF: sub_75A3+18↑j
                call    GET_PARAMS
                call    GET_PARAM_STRING
                ld      a, 55h ; 'U'
                call    WRITE_FILENAME
                xor     a
                ld      de, (parm_START)
                ld      hl, (parm_END)
                sbc     hl, de
                inc     hl

loc_7761:                               ; CODE XREF: sub_75A3+1C7↓j
                dec     h
                jp      m, tape_less_256
                ld      b, 0			; 0 == 256 bytes
                call    WRITE_TAPE_BLOCK	; B = number of bytes, DE = ptr to Data
                jr      loc_7761
; ---------------------------------------------------------------------------

tape_less_256:                               ; CODE XREF: sub_75A3+1BF↑j
                xor     a
                cp      l
                ld      b, l
                call    nz, WRITE_TAPE_BLOCK	; B = number of bytes, DE = ptr to Data
                ld      a, 78h ; 'x'
                call    CASS_WRITE_BYTE
                ld      a, (parm_TRANSFER)
                call    CASS_WRITE_BYTE
                ld      a, (parm_TRANSFER+1)	; 2 bytes of execution address
                call    CASS_WRITE_BYTE
#IFDEF TRS80
                jp      Cassette_Off
#ELSE
		ret			; Just return on VZ, no motor control
#ENDIF

; =============== S U B R O U T I N E =======================================

; B = number of bytes, DE = ptr to Data

WRITE_TAPE_BLOCK: 
		
		ld      a, d
                add     a, e
                ld      c, a
                ld      a, 3Ch ; '<'
                call    CASS_WRITE_BYTE
                ld      a, b
                call    CASS_WRITE_BYTE
                ld      a, e
                call    CASS_WRITE_BYTE
                ld      a, d
                call    CASS_WRITE_BYTE

loc_779A:                               ; CODE XREF: WRITE_TAPE_BLOCK+1B↓j
                ld      a, (de)
                call    CASS_WRITE_BYTE
                add     a, c
                ld      c, a
                inc     de
                djnz    loc_779A
                ld      a, c
                jp      CASS_WRITE_BYTE	; Write checksum byte
; End of function WRITE_TAPE_BLOCK


; =============== S U B R O U T I N E =======================================


GET_PARAMS:                             ; CODE XREF: GET_COMMAND:out_disassem_disk↑p
                                        ; sub_75A3+1F↑p ...
                call    OUT_CHAR_SPC    ; output char in A, followed by a space to vid and return
                call    HEX_to_HL       ; get 4 digit hex value into the HL register
                ld      (parm_START), hl
                call    SPC_VID_OUT     ; Output a SPC to video and return to caller
                call    HEX_to_HL       ; get 4 digit hex value into the HL register
                ld      (parm_END), hl
                call    SPC_VID_OUT     ; Output a SPC to video and return to caller
                call    HEX_to_HL       ; get 4 digit hex value into the HL register
                ld      (parm_TRANSFER), hl
                ret
; End of function GET_PARAMS

; ---------------------------------------------------------------------------

loc_77C3:                               ; CODE XREF: GET_COMMAND+71↑j
                ld      a, 5Eh ; '^'
                call    TAS_VID_DRIVER
                ld      hl, (reg_PC)
                ld      bc, 1
                xor     a
                call    DISASSEMBLE
                ld      hl, (GEN_PTR_16)
                ld      (reg_PC), hl
                jr      loc_77E8
; ---------------------------------------------------------------------------

loc_77DA:                               ; CODE XREF: GET_COMMAND+76↑j
                ld      a, 5Dh ; ']'
                call    TAS_VID_DRIVER
                ld      hl, (reg_PC)
                call    sub_77EB
                ld      (reg_PC), hl

loc_77E8:                               ; CODE XREF: GET_COMMAND+179E↑j
                jp      SHOW_REGS

; =============== S U B R O U T I N E =======================================


sub_77EB:                               ; CODE XREF: GET_COMMAND+6DC↑p
                                        ; GET_COMMAND+17A8↑p
                ld      (word_7F3B), hl
                ld      bc, 0Ah
                sbc     hl, bc

loc_77F3:                               ; CODE XREF: sub_77EB+21↓j
                ld      bc, 1
                xor     a
                ld      (parm_END), hl
                call    DISASSEMBLE
                ld      hl, (GEN_PTR_16)
                ld      bc, (word_7F3B)
                xor     a
                sbc     hl, bc
                jr      z, loc_780F
                ld      hl, (GEN_PTR_16)
                jp      m, loc_77F3

loc_780F:                               ; CODE XREF: sub_77EB+1C↑j
                ld      hl, (parm_END)
                ret
; End of function sub_77EB


; =============== S U B R O U T I N E =======================================


sub_7813:                               ; CODE XREF: GET_COMMAND+1516↑p
                                        ; GET_COMMAND+1681↑p
                call    check_range     ; HL = Start, DE = End. Ensure DE >= HL (1=OK, 0=ERR)
                ret     z
                ld      (parm_END), de
                ret
; End of function sub_7813


; =============== S U B R O U T I N E =======================================


sub_781C:                               ; CODE XREF: GET_COMMAND+1532↑p
                                        ; GET_COMMAND+169C↑p
                call    check_range     ; HL = Start, DE = End. Ensure DE >= HL (1=OK, 0=ERR)
                ret     nz
                ld      (parm_START), de
                ret
; End of function sub_781C


; =============== S U B R O U T I N E =======================================

; HL = Start, DE = End. Ensure DE >= HL (1=OK, 0=ERR)

check_range:                            ; CODE XREF: GET_COMMAND+12C6↑p
                                        ; sub_73D5+28↑p ...
                push    hl
                or      a
                sbc     hl, de
                pop     hl
                jr      c, range_check_error
                ld      a, 1
                or      a
                ret
; ---------------------------------------------------------------------------

range_check_error:                      ; CODE XREF: check_range+5↑j
                xor     a
                ret
; End of function check_range

; ---------------------------------------------------------------------------

relocate_memory:                        ; CODE XREF: GET_COMMAND+80↑j
                call    GET_PARAMS
                ld      de, (parm_START)
                ld      hl, (parm_END)
                call    check_range     ; HL = Start, DE = End. Ensure DE >= HL (1=OK, 0=ERR)
                jp      z, return_from_user
                xor     a
                sbc     hl, de
                inc     hl
                push    hl
                ld      (word_7F33), hl
                ld      hl, (parm_TRANSFER)
                ld      de, (parm_START)
                xor     a
                sbc     hl, de
                ld      (parm_OFFSET), hl
                pop     bc
                ld      hl, (parm_START)
                ld      de, (parm_TRANSFER)
                call    MOVE            ; MOVE HL=SRC, DE=DEST, BC=COUNT (overlap aware!)
                ld      hl, (parm_TRANSFER)
                ld      (GEN_PTR_16), hl

loc_7868:                               ; CODE XREF: GET_COMMAND+1866↓j
                ld      a, (hl)
                cp      0EDh
                jr      z, reloc_ED
                cp      0DDh
                jr      z, reloc_DD_FD
                cp      0FDh
                jr      z, reloc_DD_FD
                ld      ix, XX_Adjust   ; 26 x  Single Byte instructions requiring adjustment
                ld      b, 26

loc_787B:                               ; CODE XREF: GET_COMMAND+1848↓j
                cp      (ix+0)
                jr      z, loc_78B9
                inc     ix
                djnz    loc_787B

loc_7884:                               ; CODE XREF: GET_COMMAND+1879↓j
                                        ; GET_COMMAND+1891↓j
                ld      bc, 1
                ld      hl, (GEN_PTR_16)
                xor     a
                call    DISASSEMBLE

loc_788E:                               ; CODE XREF: GET_COMMAND+18B8↓j
                                        ; GET_COMMAND+18C1↓j
                ld      hl, (word_7F33)
                ld      c, a
                ld      b, 0
                xor     a
                sbc     hl, bc
                ld      (word_7F33), hl
                jp      m, return_from_user
                ld      hl, (GEN_PTR_16)
                jr      loc_7868
; ---------------------------------------------------------------------------

reloc_ED:                               ; CODE XREF: GET_COMMAND+1831↑j
                inc     hl
                ld      a, (hl)
                ld      ix, ED_adjust   ; 8 x  ED XX instructions requiring adjustment
                ld      b, 8

loc_78AA:                               ; CODE XREF: GET_COMMAND+1877↓j
                cp      (ix+0)
                jr      z, loc_78B5
                inc     ix
                djnz    loc_78AA
                jr      loc_7884
; ---------------------------------------------------------------------------

loc_78B5:                               ; CODE XREF: GET_COMMAND+1873↑j
                                        ; GET_COMMAND+1887↓j ...
                ld      a, 4
                jr      loc_78CD
; ---------------------------------------------------------------------------

loc_78B9:                               ; CODE XREF: GET_COMMAND+1844↑j
                ld      a, 3
                jr      loc_78CD
; ---------------------------------------------------------------------------

reloc_DD_FD:                            ; CODE XREF: GET_COMMAND+1835↑j
                                        ; GET_COMMAND+1839↑j
                inc     hl
                ld      a, (hl)
                cp      21h ; '!'
                jr      z, loc_78B5
                cp      22h ; '"'
                jr      z, loc_78B5
                cp      2Ah ; '*'
                jr      z, loc_78B5
                jr      loc_7884
; ---------------------------------------------------------------------------

loc_78CD:                               ; CODE XREF: GET_COMMAND+187D↑j
                                        ; GET_COMMAND+1881↑j
                push    af
                inc     hl
                push    hl
                ld      e, (hl)
                inc     hl
                ld      d, (hl)
                ld      hl, (parm_END)
                call    check_range     ; HL = Start, DE = End. Ensure DE >= HL (1=OK, 0=ERR)
                jr      z, loc_78F4
                ld      hl, (parm_START)
                call    check_range     ; HL = Start, DE = End. Ensure DE >= HL (1=OK, 0=ERR)
                jr      nz, loc_78F4
                ld      hl, (parm_OFFSET)
                add     hl, de
                push    hl
                pop     de
                pop     hl
                ld      (hl), e
                inc     hl
                ld      (hl), d
                inc     hl
                ld      (GEN_PTR_16), hl
                pop     af
                jr      loc_788E
; ---------------------------------------------------------------------------

loc_78F4:                               ; CODE XREF: GET_COMMAND+189F↑j
                                        ; GET_COMMAND+18A7↑j
                pop     hl
                inc     hl
                inc     hl
                ld      (GEN_PTR_16), hl
                pop     af
                jr      loc_788E
; ---------------------------------------------------------------------------

block_move:                             ; CODE XREF: GET_COMMAND+85↑j
                call    GET_PARAMS
                ld      hl, (parm_END)
                ld      de, (parm_START)
                xor     a
                sbc     hl, de
                inc     hl
                push    hl
                pop     bc
                ld      hl, (parm_START)
                ld      de, (parm_TRANSFER)

; =============== S U B R O U T I N E =======================================

; MOVE HL=SRC, DE=DEST, BC=COUNT (overlap aware!)

MOVE:                                   ; CODE XREF: GET_COMMAND+1825↑p
                push    hl
                or      a
                sbc     hl, de
                pop     hl
                jr      c, blk_overlap
                ldir
                ret
; ---------------------------------------------------------------------------

blk_overlap:                            ; CODE XREF: MOVE+5↑j
                add     hl, bc
                dec     hl
                ex      de, hl
                add     hl, bc
                dec     hl
                ex      de, hl
                lddr
                ret
; End of function MOVE


; =============== S U B R O U T I N E =======================================


SCREEN_DUMP:                               ; CODE XREF: GET_CHAR+5↑p

                call    checkPRT        ; Check if Printer is Ready
                jr      z, do_screen_dump
                xor     a
                ret


; =============== S U B R O U T I N E =======================================

; Check if Printer is Ready

checkPRT:                               
                ld      a, (37E8h)
                and     0F0h
                cp      30h ; '0'
                ret

; ---------------------------------------------------------------------------

do_screen_dump:
                push    hl
                push    bc
                ld      hl, SCREEN_START
                ld      c, SCREEN_LINES		; 16 or 32

prt_next_line:                               
                ld      b, LINE_LEN		; 64

prt_next_char:					
                ld      a, (hl)
                cp      1Bh
                jr      c, loc_794C
                cp      81h
                jr      c, loc_794E
                ld      a, 2Eh ; '.'
                jr      loc_794E
; ---------------------------------------------------------------------------

loc_794C:
                add     a, 40h ; '@'

loc_794E: 
                call    TAS_PTR_DRIVER
                inc     hl
                djnz    prt_next_char
                ld      a, 0Dh			; <CR>
                call    TAS_PTR_DRIVER
                dec     c
                jr      nz, prt_next_line
                pop     bc
                pop     hl
                xor     a
                ret

; =============== S U B R O U T I N E =======================================

; Get ascii string to (HL), maxlen = B

GET_ASCII:                              ; CODE XREF: GET_DOS_PARAMS+8↑p
                                        ; GET_PARAM_STRING+8↑p
                ld      c, b

loc_7961:                               ; CODE XREF: GET_ASCII+34↓j
                                        ; GET_ASCII+4A↓j
                ld      a, 5Fh ; '_'
                call    TAS_VID_DRIVER

loc_7966:                               ; CODE XREF: GET_ASCII+A↓j
                                        ; GET_ASCII+1A↓j ...
                call    SAVE_REGS_GET_CHAR
                or      a
                jr      z, loc_7966
                cp      1
                jr      z, loc_79AC
                cp      0Dh
                jr      z, loc_7999
                cp      8
                jr      z, loc_799C
                cp      20h ; ' '
                jr      c, loc_7966
                cp      5Bh ; '['
                jr      nc, loc_7966
                push    af
                ld      a, b
                or      a
                jr      z, loc_7996
                dec     b

loc_7986:                               ; CODE XREF: GET_ASCII+3A↓j
                ld      a, 8
                call    TAS_VID_DRIVER
                pop     af
                ld      (hl), a
                inc     hl
                cp      0Dh
                ret     z
                call    TAS_VID_DRIVER
                jr      loc_7961
; ---------------------------------------------------------------------------

loc_7996:                               ; CODE XREF: GET_ASCII+23↑j
                pop     af
                jr      loc_7966
; ---------------------------------------------------------------------------

loc_7999:                               ; CODE XREF: GET_ASCII+12↑j
                push    af
                jr      loc_7986
; ---------------------------------------------------------------------------

loc_799C:                               ; CODE XREF: GET_ASCII+16↑j
                ld      a, b
                sub     c
                jr      z, loc_7966
                inc     b
                dec     hl
                ld      a, 8
                call    TAS_VID_DRIVER
                call    TAS_VID_DRIVER
                jr      loc_7961
; ---------------------------------------------------------------------------

loc_79AC:                               ; CODE XREF: GET_ASCII+E↑j
                ld      a, 8
                call    TAS_VID_DRIVER
                jp      return_from_user

; =============== S U B R O U T I N E =======================================

; tasmon internal keyboard driver
; very similar to L2 keyboard driver @ $03E3
;

TAS_KBD_DRIVER:                         
                ld      hl, TAS_KBD_work_area ; 7 bytes of previously pressed key rows
                ld      bc, KBD_ROW_01
                ld      d, 0            ; column index

tas_rows_remaining:                     ; CODE XREF: TAS_KBD_DRIVER+13↓j
                ld      a, (bc)         ; get data from Row
                ld      e, a
                xor     (hl)            ; exclude any previously pressed keys
                ld      (hl), e
                and     e               ; A (and E) both now have the new key press bit
                jr      nz, key_active  ; Key active in this row
                inc     d
                inc     hl              ; bump to next work area row
                rlc     c               ; step row address from 3801h => 3840h
                jp      p, tas_rows_remaining ; Scan rows 3801 => 3840.  3880 (Shift Key) checked later
                ld      a, (KBD_LAST_BYTE)
                or      a
                ret     z               ; no previously pressed key active
                ld      hl, (KBD_LAST_ROW)
                cp      (hl)            ; If last active row, and last active bit combo match, do auto-repeat
                jr      z, AUTO_REPEAT
                xor     a               ; clear auto-repeat key bit combo
                ld      (KBD_LAST_BYTE), a
                ret
; ---------------------------------------------------------------------------

continue_delay:
                xor     a
                ret
; ---------------------------------------------------------------------------

AUTO_REPEAT: 
                ld      hl, (REPEAT_DELAY)
                dec     hl
                ld      (REPEAT_DELAY), hl
                ld      a, h
                or      l
                jr      nz, continue_delay	; Repeat counter not ZERO yet, return to caller without keypress
                ld      hl, 60h ; '`'		; Delay between each auto-repeated key
                ld      (REPEAT_DELAY), hl
                ld      a, (byte_7F3A)
                ld      d, a
                ld      a, (KBD_LAST_BYTE)
                ld      bc, (KBD_LAST_ROW)
                ld      e, a
                jr      loc_7A09
; ---------------------------------------------------------------------------

key_active:
                ld      (KBD_LAST_BYTE), a
                ld      (KBD_LAST_ROW), bc
                ld      e, a
                ld      hl, 0A00h		; Delay before auto-repeat kicks in
                ld      (REPEAT_DELAY), hl	; set up auto repeat delay on this key bit

loc_7A09:
                ld      a, d
                ld      (byte_7F3A), a
                push    af
                ld      bc, 0A00h
                call    Delay
                ld      a, (RST28_Vector)	; disable any 3rd Party Keyboard intercepts
                ld      (RST28_SAVE), a
                ld      a, 0C9h
                ld      (RST28_Vector), a
                pop     af
                rlca
                rlca
                call    sub_3FE			; Jump into LV2 Keyboard Routine
                push    af
                ld      a, (RST28_SAVE)		; Restore any 3rd party vectors
                ld      (RST28_Vector), a
                pop     af
                ret

; =============== S U B R O U T I N E =======================================


SAVE_REGS_GET_CHAR: 

                push    hl
                push    de
                push    bc
                call    TAS_KBD_DRIVER  ; tasmon internal keyboard driver
                pop     bc
                pop     de
                pop     hl
                ret

; ---------------------------------------------------------------------------

view_file_info: 
                call    OUT_CHAR_SPC    ; output char in A, followed by a space to vid and return
                ld      a, 1
                ld      (byte_7F3D), a
                ld      hl, 0
                ld      (parm_OFFSET), hl
                ld      (parm_START), hl
                dec     hl
                ld      (parm_END), hl
                di

fi_kbd_err:  
                call    GET_CHAR        ; get character, return in A
                cp      44h ; 'D'
                jp      z, disk_file_info
                cp      54h ; 'T'
                jr      nz, fi_kbd_err
                call    TAS_VID_DRIVER
                jp      tape_file_info
; ---------------------------------------------------------------------------

set_memory:                             ; CODE XREF: GET_COMMAND+8A↑j
                call    OUT_CHAR_SPC    ; output char in A, followed by a space to vid and return
                call    HEX_to_HL       ; get 4 digit hex value into the HL register
                push    hl
                call    SPC_VID_OUT     ; Output a SPC to video and return to caller
                call    HEX_to_HL       ; get 4 digit hex value into the HL register
                push    hl
                call    SPC_VID_OUT     ; Output a SPC to video and return to caller
                call    HEX_VAL_to_L    ; 2 byte hex value to L register (also in A)
                pop     hl              ; end
                pop     de              ; start
                or      a
                sbc     hl, de          ; calc number of bytes to fill
                inc     hl
                ex      de, hl          ; HL = start, DE = number of bytes
                ld      b, a            ; fill value

fill_continue:                          ; CODE XREF: GET_COMMAND+1A47↓j
                ld      (hl), b
                inc     hl
                dec     de
                ld      a, d
                or      e
                jr      nz, fill_continue
                jp      return_from_user

; =============== S U B R O U T I N E =======================================


TAS_VID_DRIVER:                         ; CODE XREF: GET_COMMAND+2↑p
                                        ; sub_60FF+15↑p ...

                push    bc
                push    hl
                push    ix
                push    de
                ld      ix, L2_VIDEO_DCB
                ld      c, a
                ld      hl, DRIVER_EXIT ; restore regs after DCB call, then return to caller
                push    hl
                ld      l, (ix+3)
                ld      h, (ix+4)
                ld      a, (ix+5)
                or      a
                jr      z, loc_7AA1
                ld      (hl), a

loc_7AA1:                               ; CODE XREF: TAS_VID_DRIVER+18↑j
                ld      a, c
                cp      20h ; ' '
                jp      c, PROCESS_CONTROL
                cp      80h
                jp      nc, CHECK_GRAPHIC
                ld      (hl), a
                cp      (hl)
                jp      nz, CONVERT_LCASE
                jp      OUTPUT_CHAR
; End of function TAS_VID_DRIVER


; =============== S U B R O U T I N E =======================================


TAS_PTR_DRIVER:                         

                push    bc
                push    hl
                push    ix
                push    de
                ld      ix, L2_PRINTER_DCB
                ld      hl, DRIVER_EXIT ; restore regs after DCB call, then return to caller
                push    hl
                ld      c, a
                jp      ROM_PRT_DRIVER

; DATA Follows

; ---------------------------------------------------------------------------
TasmonVer222:	.DB "TASMON  VER 2.22\n"
                .DB "(C) 1981 by Bruce G. Hansen"
                .DB  3
USER_REGS:			; user register save area
reg_IX:		.DW  0                    
reg_IY:		.DW  0
reg_xAF:        .DW  0		; ALT regs followed by normal
reg_xBC:        .DW  0
reg_xDE:        .DW  0
reg_xHL:        .DW  0
reg_AF:		.DW  0 
reg_BC:		.DW  0 
reg_DE:	        .DW  0
reg_HL:		.DW  0
reg_SP:		.DW  41FEh 
reg_PC:		.DW  402Dh 

REG_ASCII_LAYOUT:			; DATA XREF: SHOW_REGS+32↑o
		.DB  "IX  IY ",80h                 
                .DB  "AF",27h," BC",27h,80h
                .DB  "DE",27h," HL",27h,80h
                .DB  "AF  BC ",80h
                .DB  "DE  HL ",80h
                .DB  "SP  PC ",80h,80h

BREAKPOINTS:    .DW  0                    ; DATA XREF: GET_COMMAND+5A7↑o
                                        ; GET_COMMAND+5BF↑o ...
                                        ; 9 breakpoints (9 x 2 byte addresses)
                .DW  0
                .DW  0
                .DW  0
                .DW  0
                .DW  0
                .DW  0
                .DW  0
                .DW  0
CODE_SAVE:      .DB  0                    ; DATA XREF: LOAD_BREAKPOINTS+5↑o
                                        ; RESTORE_BREAKPOINTS+5↑o
                .DB  0
                .DB  0
                .DB  0
                .DB  0
                .DB  0
                .DB  0
                .DB  0
                .DB  0
                .DB  0
                .DB  0
                .DB  0
                .DB  0
                .DB  0
                .DB  0
                .DB  0
                .DB  0
                .DB  0
                .DB  0
                .DB  0
                .DB  0
                .DB  0
                .DB  0
                .DB  0
                .DB  0
                .DB  0
                .DB  0
EXEC1:          .DB  0                    ; DATA XREF: SET_EXEC1_to_1+2↑o
                                        ; copy_EXEC1_to_EXEC2+2↑o ...
                .DB  0
                .DB  0
                .DB  0
                .DB  0
                .DB  0
                .DB  0
                .DB  0
                .DB  0
EXEC2:          .DB  0                    ; DATA XREF: GET_COMMAND+5C2↑o
                                        ; copy_EXEC1_to_EXEC2+5↑o ...
                .DB  0
                .DB  0
                .DB  0
                .DB  0
                .DB  0
                .DB  0
                .DB  0
                .DB  0

FLAGS:		.DB  "S-Z-1-H-1-P-N-C-"    ; flags in display format              

byte_7B8A:      .DB  0                    ; DATA XREF: sub_6BD8+11↑w
                                        ; sub_6BD8:loc_6BF8↑w ...
byte_7B8B:      .DB  0                    ; DATA XREF: sub_6BD8+14↑w
                                        ; sub_6BD8+39↑w ...
dis_DISPLAY_FLG:      .DB  0                    ; DATA XREF: RAM:601C↑w
                                        ; GET_COMMAND+7↑w ...
byte_7B8D:      .DB  0                    ; DATA XREF: sub_60FF+27↑r
                                        ; GET_COMMAND+854↑r ...
byte_7B8E:      .DB  0                    ; DATA XREF: sub_60FF:loc_61F7↑r
                                        ; sub_6739+2↑w ...
SAVE_CURSOR:      .DW  0                    ; DATA XREF: SHOW_REGS+3↑w
                                        ; SHOW_REGS+93↑r
                .DB     0
STACK_SAVE:      .DW  0                    ; DATA XREF: sub_60FF+108↑w
                                        ; sub_60FF+115↑r ...
word_7B94:      .DW  0                    ; DATA XREF: sub_60FF+3D↑w
                                        ; sub_60FF+69↑r
word_7B96:      .DW  0                    ; DATA XREF: GET_COMMAND+729↑w
                                        ; GET_COMMAND:loc_67A3↑r ...
byte_7B98:      .DB  0                    ; DATA XREF: GET_COMMAND+770↑r
                .DB  0
                .DB  0
                .DB  0
byte_7B9C:      .DB  0                    ; DATA XREF: GET_COMMAND+75F↑w
                                        ; GET_COMMAND+781↑r
word_7B9D:      .DW  0                    ; DATA XREF: GET_COMMAND+765↑w
                                        ; GET_COMMAND+76C↑r ...
word_7B9F:      .DW  0                    ; DATA XREF: GET_COMMAND+8FD↑w
                                        ; GET_COMMAND:loc_6948↑r ...
word_7BA1:      .DW  0                    ; DATA XREF: GET_COMMAND+906↑w
                                        ; GET_COMMAND+911↑r ...
byte_7BA3:      .DB  0                    ; DATA XREF: GET_COMMAND+83A↑w
                                        ; GET_COMMAND+895↑w ...
BP_STACK_SAVE:      .DW  0                    ; DATA XREF: RAM:BREAKPOINT_RETURN↑w
                                        ; RAM:6330↑r
byte_7BA6:      .DB  0                    ; DATA XREF: SHOW_REGS+22↑w
                                        ; SHOW_REGS+2F↑w ...
NEXT_CHAR_ADD_SAVE:      .DW  0                    ; DATA XREF: RAM:6007↑w
                                        ; sub_62CC+7↑r ...
NEXT_CHAR_ADD_TM:.DW  0                   ; DATA XREF: RAM:6343↑r
                                        ; SHOW_REGS↑r ...
PRINT_OUT_FLAG: .DB  0                    ; DATA XREF: GET_COMMAND+9B0↑w
                                        ; GET_COMMAND+9BE↑w ...
                                        ; 1 = out to printer, 0 = no printer output
byte_7BAC:      .DB  0                    ; DATA XREF: GET_COMMAND+827↑w
                                        ; GET_COMMAND+832↑w ...
byte_7BAD:      .DB  0
                .DB  0
                .DB  0
                .DB  0
                .DB  0
                .DB  0
                .DB  0
byte_7BB4:      .DB  0                    ; DATA XREF: sub_60FF:loc_612F↑r
                                        ; SHOW_REGS+28↑w
HEX_ASCII_FLAG: .DB  0                    ; DATA XREF: GET_COMMAND:loc_64C2↑w
                                        ; GET_COMMAND+4D1↑r ...
byte_7BB6:      .DB  0                    ; DATA XREF: GET_COMMAND+816↑w
                                        ; GET_COMMAND+84E↑r ...
Cursor_ON_OFF_SAVE:      .DB  0                    ; DATA XREF: RAM:6011↑w
                                        ; sub_62CC+D↑r ...
RESTARTS_STYLE: .DB  0                    ; DATA XREF: sub_60FF+148↑r
                                        ; GET_COMMAND+6E7↑r ...
USER_SCREEN_ptr:.DW  screen_save	; 3C00h
                                        ; RAM:635E↑r ...
                                        ; ptr to user supplied $400 byte screen area
KEEP_SCREEN_STATE:.DB  0                  ; DATA XREF: sub_62CC+13↑r
                                        ; RAM:6353↑r ...
                                        ; 0 = keep screen off, 1 = keep screen on
                .DB     0
                .DB     0
                .DB     0
                .DB     0
                .DB     0
                .DB     0
                .DB     0
                .DB     0
                .DB     0
                .DB     0
                .DB     0
                .DB     0
                .DB     0
                .DB     0
                .DB     0
                .DB     0
                .DB     0
                .DB     0
                .DB     0
                .DB     0
                .DB     0
                .DB     0
                .DB     0
                .DB     0
                .DB     0
                .DB     0
                .DB     0
                .DB     0
                .DB     0
                .DB     0
                .DB     0
                .DB     0
                .DB     0
                .DB     0
                .DB     0
                .DB     0
                .DB     0
                .DB     0
                .DB     0
                .DB     0
                .DB     0
                .DB     0
                .DB     0
                .DB     0
                .DB     0
                .DB     0
                .DB     0
                .DB     0
                .DB     0
                .DB     0
                .DB     0
                .DB     0
                .DB     0
                .DB     0
                .DB     0
                .DB     0
                .DB     0
                .DB     0
                .DB     0
                .DB     0
                .DB     0
                .DB     0
                .DB     0
                .DB     0
                .DB     0
                .DB     0
                .DB     0
                .DB     0
                .DB     0
                .DB     0
                .DB     0
                .DB     0
                .DB     0
                .DB     0
                .DB     0
                .DB     0
                .DB     0
                .DB     0
                .DB     0
                .DB     0
                .DB     0
                .DB     0
                .DB     0
                .DB     0
                .DB     0
                .DB     0
                .DB     0
                .DB     0
                .DB     0
                .DB     0
                .DB     0
                .DB     0
                .DB     0
                .DB     0
                .DB     0
                .DB     0
a_IXplus:       .DB  'I'               
                                       
                .DB  'X'
                .DB  '+'
                .DB  3
a_IYplus:       .DB  'I'               
                .DB  'Y'
                .DB  '+'
                .DB  3
a_IX:           .DB  'I'               
                .DB  'X'
                .DB  3
a_IY:           .DB  'I'               
                .DB  'Y'
                .DB  3
a_DEFB:         .DB  'D'               
                .DB  'E'
                .DB  'F'
                .DB  'B'
                .DB  9
                .DB  3
byte_7C30:	.DB   0Ah
                .DB   1Ah
                .DB     2
                .DB   12h
                .DB  0F9h
                .DB  0EBh
                .DB     8
                .DB  0D9h
                .DB  0E3h
                .DB   27h ; '
                .DB   2Fh ; /
                .DB   3Fh ; ?
                .DB   37h ; 7
                .DB     0
                .DB   76h ; v
                .DB  0F3h
                .DB  0FBh
                .DB     7
                .DB   17h
                .DB   0Fh
                .DB   1Fh
byte_7C45:	.DB   57h ; W
                .DB   5Fh ; _
                .DB   47h ; G
                .DB   4Fh ; O
                .DB  0A0h
                .DB  0B0h
                .DB  0A8h
                .DB  0B8h
                .DB  0A1h
                .DB  0B1h
                .DB  0A9h
                .DB  0B9h
                .DB   44h ; D
                .DB   46h ; F
                .DB   56h ; V
                .DB   5Eh ; ^
                .DB   6Fh ; o
                .DB   67h ; g
                .DB  0A2h
                .DB  0B2h
                .DB  0AAh
                .DB  0BAh
                .DB  0A3h
                .DB  0B3h
                .DB  0ABh
                .DB  0BBh
                .DB   70h ; p
                .DB   71h ; q

byte_7C61:	.db "BCDEHLAF"

byte_7C69:	.db "BCDEHLSPBCDEIXSPBCDEIYSP"

byte_7C81:	.db "NZ",0,"ZNC",0,"CPOPE",0,'P',0,'M'

byte_7C91:	.DB  "LD",9,3

HL_ascii:       .DB  "(HL)",3
                
byte_7C9A:	.DB   "LD",9,"A,",3

byte_7CA0:	.DB   "),A",3
                .DB   "LD",9,"HL,",3
		.DB   ",HL",3

byte_7CAF:	.DB   "PUSH",9,3
byte_7CB5:	.DB   "POP",9,3
byte_7CBA:	.DB   "ADD",9,"A,",3
byte_7CC1:	.DB   "INC",9,3
                .DB   "ADD",9,"HL,",3
byte_7CCE:	.DB   "DEC",9,3

byte_7CD3:	.DB   "JP",9,3

byte_7CD7:	.DB   "JR",9,3

byte_7CDB:	.DB   "JR",9,"C,",3

byte_7CE1:	.DB   "JR",9,"NC,",3

byte_7CE8:	.DB   "JR",9,"Z,",3

byte_7CEE:	.DB   "JR",9,"NZ,",3

byte_7CF5:	.DB   "DJNZ",9,3
byte_7CFB:	.DB   "CALL",9,3
byte_7D01:	.DB   "RET",9,3
byte_7D06:	.DB   "RST",9,3
byte_7D0B:	.DB   "IN",9,"A,(",3
byte_7D12:	.DB   "OUT",9,'(',3
byte_7D18:	.DB   "ADC",9,"A,",3
byte_7D1F:	.DB   "SUB",9,3
byte_7D24:	.DB   "SBC",9,"A,",3
byte_7D2B:	.DB   "AND",9,3
byte_7D30:	.DB   "OR",9,3
byte_7D34:	.DB   "XOR",9,3
byte_7D39:	.DB   "CP",9,3
byte_7D3D:	.DB   "RLC",9,3
byte_7D42:	.DB   "RL",9,3
byte_7D46:	.DB   "RRC",9,3
byte_7D4B:	.DB   "RR",9,3
byte_7D4F:	.DB   "SLA",9,3
byte_7D54:	.DB   "SRL",9,3
byte_7D59:	.DB   "SRA",9,3
byte_7D5E:	.DB   "SLS",9,3
byte_7D63:	.DB   "BIT",9,3
byte_7D68:	.DB   "SET",9,3
byte_7D6D:	.DB   "RES",9,3
byte_7D72:	.DB   "ADC",9,"HL,",3
byte_7D7A:	.DB   "SBC",9,"HL,",3
byte_7D82:	.DB   "RETI",3
byte_7D87:	.DB   "RETN",3
byte_7D8C:	.DB   "IN",9,3
byte_7D90:	.DB   "(C)",9,3
byte_7D95:	.DB   "OUT",9,"(C),",3
byte_7D9E:	.DB   "LD",9,"SP,",3
byte_7DA5:	.DB   "EX",9,"(SP),",3
byte_7DAE:	.DB   "ADD",9,3
		.DB   "LD",9,"(HL),"
                
byte_7DBB:	.DB     3
                
		.DB   "LD",9,"A,(BC)",3
                .DB   "LD",9,"A,(DE)",3
		.DB   "LD",9,"(BC),A",3
		.DB   "LD",9,"(DE),A",3
		.DB   "LD",9,"SP,HL",3
		.DB   "EX",9,"DE,HL",3
		.DB   "EX",9,"AF,AF",27h,3
		.DB  "EXX",3
		.DB   "EX",9,"(SP),HL",3
		.DB  "DAA",3
		.DB  "CPL",3
		.DB  "CCF",3
		.DB  "SCF",3
		.DB  "NOP",3
		.DB  "HALT",3
		.DB  "DI",3
		.DB  "EI",3
		.DB  "RLCA",3
		.DB  "RLA",3
		.DB  "RRCA",3
		.DB  "RRA"
byte_7E3F:	.DB     3

		.DB   "LD",9,"A,I",3
		.DB   "LD",9,"A,R",3
		.DB   "LD",9,"I,A",3
		.DB   "LD",9,"R,A",3

		.DB  "LDI",3
		.DB  "LDIR",3
		.DB  "LDD",3
		.DB  "LDDR",3
		.DB  "CPI",3
		.DB  "CPIR",3
		.DB  "CPD",3
		.DB  "CPDR",3
		.DB  "NEG",3

		.DB   "IM",9,'0',3
		.DB   "IM",9,'1',3
		.DB   "IM",9,'2',3

		.DB  "RLD",3
		.DB  "RRD",3
		.DB  "INI",3
		.DB  "INIR",3
		.DB  "IND",3
		.DB  "INDR",3

		.DB  "OUTI",3
		.DB  "OTIR",3
		.DB  "OUTD",3
		.DB  "OTDR",3

		.DB   "IN",9,"-,(C)",3
		.DB   "OUT",9,"(C),0",3

GEN_PTR_16:      .DW  0                
dis_DISASSEM_START:      .DW  0        
dis_NUM_INSTRS:      .DW  0            

disORG:         .DB  "ORG",9,3

disEND:		.DB  "END",9,3

byte_7EE4:      .DB  0         
word_7EE5:      .DW  0         
word_7EE7:      .DW  0         
byte_7EE9:      .DB  0         
DISK_TAPE_FLAG:      .DB  0         
byte_7EEB:      .DB  0         
DOS_ERROR:      .DB  "DOS ERROR ",3
TAPE_ERROR:     .DB  "TAPE ERROR",3 

XX_Adjust:      .DB  0FCh                 ; DATA XREF: GET_COMMAND+183B↑o
                                        ; 26 x  Single Byte instructions requiring adjustment
                .DB  0F4h
                .DB  3Ah
                .DB  0ECh
                .DB  0E4h
                .DB  32h
                .DB  0DCh
                .DB  0D4h
                .DB  1
                .DB  0CCh
                .DB  0C4h
                .DB  11h
                .DB  0CDh
                .DB  0FAh
                .DB  21h
                .DB  0F2h
                .DB  0EAh
                .DB  31h
                .DB  0E2h
                .DB  0DAh
                .DB  2Ah
                .DB  0CAh
                .DB  0D2h
                .DB  22h
                .DB  0C2h
                .DB  0C3h
ED_adjust:      .DB  5Bh                  ; DATA XREF: GET_COMMAND+186A↑o
                                        ; 8 x  ED XX instructions requiring adjustment
                .DB  4Bh
                .DB  7Bh
                .DB  6Bh
                .DB  53h
                .DB  43h
                .DB  73h
                .DB  63h
                
TAS_KBD_work_area:
		.DB  0
                .DB  0
                .DB  0
                .DB  0
                .DB  0
                .DB  0
                .DB  0
parm_END:       .DW  0     
parm_START:     .DW  0     
parm_TRANSFER:  .DW  0     
parm_OFFSET:    .DW  0     
word_7F33:      .DW  0     
KBD_LAST_BYTE:  .DB  0     
REPEAT_DELAY:   .DW  0     
KBD_LAST_ROW:   .DW  0     
byte_7F3A:      .DB  0     
word_7F3B:      .DW  0     
byte_7F3D:      .DB  0     

string_buffer:  .BLOCK	32

Sector_Buffer:  .BLOCK	256

RST28_SAVE:      .DB  0C9h

screen_save	.BLOCK SCREEN_LEN
		.END
