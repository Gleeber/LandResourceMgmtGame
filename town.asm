global testingFunction

global buildVillage
global printVillage

global recruitVillager
global getVillagers
global getVillagersAvail

global buildFarm

global buildWall

global moveTime
global addFunds
global getFunds

extern printf

testingFunction:
    
ret

; **************** Village Functions ********************
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

; **************** Villager Functions ********************
recruitVillager: 
    add DWORD[villagers],1
    add DWORD[villagers+4],1
    sub DWORD[funds],1
ret

getVillagers:
    mov eax, DWORD[villagers]
ret

getVillagersAvail:
    mov eax, DWORD[villagers + 4]
ret

; **************** Farm Functions ********************
buildFarm:
    mov eax, [esp+4] ; village pointer

    cmp DWORD[villagers + 4],0
    jg farmSuccess

    mov eax,DWORD[notEnoughVillagers]               ; Error message = 2
    jmp return

    farmSuccess:
        mov ecx, 0
        findFarm:                       ; Find next free space in village
            cmp BYTE[eax + ecx],'_'
            je addFarmToVillage

            add ecx,1
            cmp ecx,[villageSize]
            jl findFarm

            mov eax,DWORD[notEnoughVillageSpace]    ; Error message = 3
            jmp return

        
        addFarmToVillage:
        mov BYTE[eax + ecx],'F'         ; Add 'F' to village
        sub DWORD[villagers + 4], 1     ; Subtract 1 from available villagers
        add DWORD[farms],1

        mov eax,0
        jmp return

    return:
ret

; **************** Wall Functions ********************
buildWall:
    mov eax, [esp+4] ; village pointer

    sub DWORD[funds],1
    add DWORD[walls],1

    mov BYTE[eax],'W'           ; Add 'W' to village
ret

moveTime:
    mov ecx, 0
    farmLoop:
        add DWORD[funds],1      ; Add 1 to funds for each farm
                                ; Amount to add subject to change

        add ecx, 1
        cmp ecx, DWORD[farms]
        jl farmLoop
ret

; **************** Funds Functions ********************
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
    dd 10

notEnoughVillagers:
    dd 2
notEnoughVillageSpace:
    dd 3

section .data
villagers: 
    dd 0        ; Total villagers
    dd 0        ; Available villagers

walls:
    dd 0

farms:
    dd 0

funds:
    dd 100
