section .data
 	a dd 3,2,34,"megh"
 	f dd "abcd",10,"piyu",0 
 	f1 db "abcd",10,"piyush",0 
	b db 20
	mys db "hello world,this is a text",0,10,20,"megh"
	b1 db 20

section .bss
	c1 resd 3
	c2 resb 9
section .text
	extern fact
	global main
main:
	sub dword[ecx],ebx
        sub ecx,dword[ebx]
	sub ebx,dword[b]
	sub edx,ebx
	sub ecx,b
	sub edx,394
	sub ecx,34
	sub dword[b],ebx
	sub dword[b],edx
	sub dword[b],300
	sub dword[b],3
	sub dword[b],b
	sub dword[ecx],300
	sub dword[ecx],3
	sub dword[ecx],b
	add ebx,ecx
	add ecx,dword[ebx]
	add dword[ecx],ebx
	add ebx,dword[b]
	add edx,b
	add ecx,b
	add edx,394
	add ecx,34
	add dword[b],ebx
	add dword[b],edx
	add dword[b],300
	add dword[b],3
	add dword[b],b
	add dword[ecx],300
	add dword[ecx],3
	add dword[ecx],b
	cmp ebx,ecx
        cmp ecx,dword[ebx]
        cmp dword[ecx],ebx
        cmp ebx,dword[b]
        cmp edx,b
        cmp ecx,b
        cmp edx,394
        cmp ecx,34
        cmp dword[b],ebx
        cmp dword[b],edx
        cmp dword[b],300
        cmp dword[b],3
        cmp dword[b],b
        cmp dword[ecx],300
        cmp dword[ecx],3
        cmp dword[ecx],b
	xor ebx,ecx
        xor ecx,dword[ebx]
        xor dword[ecx],ebx
        xor ebx,dword[b]
        xor edx,b
        xor ecx,b
        xor edx,394
        xor ecx,34
        xor dword[b],ebx
        xor dword[b],edx
        xor dword[b],300
        xor dword[b],b
        xor dword[ecx],300
        xor dword[ecx],b

	mov ebx,ecx
	mov ecx,dword[ebx]
	mov dword[ecx],ebx
	mov ebx,dword[b]
	mov edx,b
	mov ecx,b
	mov edx,394
	mov ecx,34
	mov dword[b],ebx
	mov dword[b],edx
	mov dword[b],3
	mov dword[b],300
	mov dword[b],b
	mov dword[ecx],3
	mov dword[ecx],300
	mov dword[ecx],b
ab:
	mul ebx
	mul ecx
	mul edx
	mul esi
	mul edi
	mul dword[b]
	mul dword[edx]
	inc ecx
	dec eax
	inc dword[b]
	dec dword[b]
	inc dword[ecx]
	dec dword[ecx]
	jnz b
	jz b
	jmp b
	jmp dword[ecx]
	div ebx
	div dword[a]
	div dword[ecx]
	jmp ab
	jmp dword[b]
	jnz ab
	jz ab
	jmp dword[ab]
	jmp dword[edx]
	jmp edx
	jmp b
	jmp e
	jnz e
	jz e
e:

