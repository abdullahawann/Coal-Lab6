[org 0x0100]
jmp start

strTitle: db "Snakes and Apples",0
strStartGame: db "Press Enter to start the game",0
strExitGame: db "Press Esc to exit the game",0
strCreator: db "Created by Abdullah Awan",0

clearscr :
push es
push ax
push di
mov ax,0xb800
mov es,ax
mov di,0
next:
mov word[es:di],0x0720
add di,2
cmp di,4000
jne next
pop di
pop ax
pop es
ret

strlen: 
push bp
mov bp,sp
push es
push cx
push di
les di, [bp+4] ; point es:di to string
mov cx, 0xffff ; load maximum number in cx
xor al, al ; load a zero in al
repne scasb ; find zero in the string
mov ax, 0xffff ; load maximum number in ax
sub ax, cx ; find change in cx
dec ax ; exclude null from length
pop di
pop cx
pop es
pop bp
ret 4
; subroutine to print a string
; takes the x position, y position, attribute, and address of a null
; terminated string as parameters

printstr:
push bp
mov bp, sp
push es
push ax
push cx
push si
push di
push ds ; push segment of string
mov ax, [bp+4]
push ax ; push offset of string
call strlen ; calculate string length
cmp ax, 0 ; is the string empty
jz exit ; no printing if string is empty
mov cx, ax ; save length in cx
mov ax, 0xb800
mov es, ax ; point es to video base
mov al, 80 ; load al with columns per row
mul byte [bp+8] ; multiply with y position
add ax, [bp+10] ; add x position
shl ax, 1 ; turn into byte offset
mov di,ax ; point di to required location
mov si, [bp+4] ; point si to string
mov ah, [bp+6] ; load attribute in ah
cld ; auto increment mode
nextchar: lodsb ; load next char in al
stosw ; print char/attribute pair
loop nextchar ; repeat for the whole string
exit: pop di
pop si
pop cx
pop ax
pop es
pop bp
ret 8

start: 
call clearscr
mov ax, 30
push ax
mov ax, 1
push ax
mov ax, 6
push ax
mov ax, strTitle
push ax
call printstr
mov ax, 1
push ax
mov ax, 20
push ax
mov ax, 8
push ax
mov ax, strCreator
push ax
call printstr
mov ax, 22
push ax
mov ax, 9
push ax
mov ax, 9
push ax
mov ax, strStartGame
push ax
call printstr
mov ax, 24
push ax
mov ax, 11
push ax
mov ax, 9
push ax
mov ax, strExitGame
push ax
call printstr
 
mov ax, 0x4c00 
int 0x21