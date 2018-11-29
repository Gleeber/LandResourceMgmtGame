global testingFunction

global buildVillage
global printVillage

global recruitVillager
global getVillagers

global addFunds
global getFunds

extern printf

testingFunction:
    
ret

buildVillage:
    mov edi,[villageSize]    ; Village size (in bytes)
    extern malloc
    call malloc

    mov ecx, 0
    fillVillage:
        mov BYTE[eax + ecx],'_'
        add ecx,1
        cmp ecx,[villageSize]
        jl fillVillage
ret

printVillage:
    mov eax, [esp+4] ; village pointer
    mov ecx, 0
    startLoop:
        push eax
        push ecx

        push DWORD[eax]
        push villageFormat
        call printf
        add esp,8

        pop ecx
        pop eax
        add eax, 1
        add ecx, 1
        cmp ecx,DWORD[villageSize]
        jl startLoop
    
    push printNewLine
    call printf
    push printNewLine
    call printf
     add esp,8
ret

recruitVillager: 
    add DWORD[villagers],1
    sub DWORD[funds],1
    call getVillagers
    call getFunds
ret

getVillagers:
    mov eax, DWORD[villagers]
ret

printVillagers:

ret


addFunds:
    add DWORD[funds],1
ret

getFunds:
    mov eax, DWORD[funds]
ret

space:
    db ' ',0

villageFormat:
    db ` %c`,0

;section .data
printNewLine:
	db `\n`,0

printChar:
    db `a`,0

villageSize:
    dd 15

section .data
villagers: 
    dd 0
    db 'Number of villagers: ',0

funds:
    dd 100
