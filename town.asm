global buildVillage
global recruitVillager
global printVillage

buildVillage:
    mov edi,[villageSize]    ; Village size (in bytes)
    extern malloc
    call malloc

    mov ecx, 0
    fillVillage:
        mov BYTE[eax + ecx],'a'
        add ecx,1
        cmp ecx,[villageSize]
        jl fillVillage
ret

printVillage:
    mov eax, edi ; village pointer
    mov ecx, 0
    startLoop:
        push eax
        push ecx

        mov edi, villageFormat
        mov esi, BYTE[eax+ecx]
        extern printf
        call printf

        pop ecx
        pop eax
        add eax, 1
        add ecx, 1
        cmp ecx,DWORD[villageSize]
        jl startLoop
ret

recruitVillager: 

ret

space:
    db ' ',0

villageFormat:
    db ` %c`,0

section .data
villageSize:
    dd 10
