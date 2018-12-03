; Liam Eberhart, Andrew Adler
; town.asm
; CS 301 Project 2: Resource Management Game
; This is the assembly code for the Resource Management Game
; linked with interface.cpp

global buildVillage
global printVillage

global recruitVillager
global getVillagers
global getVillagersAvail

global buildFarm

global buildWall
global getWalls

global moveTime
global getTime
global getAttackChance
global attack
global getFunds

extern printf
extern malloc

; **************** Village Functions ********************
; buildVillage generates villagePtr and farmPtr
buildVillage:
    mov edi,DWORD[villageSize]      ; Village size (in bytes)
    push edi                        ; Pass value to malloc
    call malloc                     ; Generate villagePtr
    add esp,4                       ; Clear pushed value
    push eax                        ; Save villagePtr until return

    mov ecx, 0                      ; Loop counter
    fillVillage:                    ; Initialized each spot of village with '_'
        mov BYTE[eax + ecx],'_'
        add ecx,1
        cmp ecx,DWORD[villageSize]
        jl fillVillage

    mov edi,DWORD[villageSize]      ; Total possible village size
    sub edi, 2                      ; Subtract 2 for both walls
    mov DWORD[numPossibleFarms],edi ; The remaining village spaces can be farms

    makeFarmPtr:
        mov edi,[numPossibleFarms]
        imul edi,4                  ; Size of one int per farm
        push edi                    ; Pass value to malloc
        call malloc                 ; Allocate memory for the farm pointer
        add esp,4                   ; Clear pushed value
        mov DWORD[farmPtr],eax      ; Store the farm pointer

    mov ecx,0
    mov edx,DWORD[timeToMakeFarm]
    sub edx, 1
    fillFarmPtr:
        mov eax,DWORD[farmPtr]      ; Get pointer to farm pointer
        mov DWORD[eax+ecx*4],edx    ; Set each farm's value to -4

        add ecx,1                   ; Progress loop
        cmp ecx,DWORD[numPossibleFarms]
        jne fillFarmPtr

    returnVillage:
    pop eax                         ; Return the village pointer
ret

; Displays the current status of the village
printVillage:
    mov eax, [esp+4]                ; Village pointer

    mov ecx, 0                      ; Loop counter
    startLoop:
        push eax                    ; Preserve registers
        push ecx

        push DWORD[eax]             ; The next char in villagePtr
        push villageFormat          ; The format string for printf
        call printf
        add esp,8                   ; Clear stack after function call

        pop ecx
        pop eax
        add eax, 1                  ; Update variables for next loop
        add ecx, 1
        cmp ecx,DWORD[villageSize]
        jl startLoop
    
    push printNewLine               ; Prints a new line after the village
    call printf
    add esp,4
ret

; **************** Villager Functions ********************
; Adds a villager to be employed at a farm
recruitVillager: 
    cmp DWORD[funds],1              ; Check for sufficient funds
    mov eax,DWORD[notEnoughFunds]
    jl noRecruitedVillagers

    mov eax,0                       ; Return 0 for successfully added villager
    add DWORD[villagers],1          ; Add to number of villagers
    add DWORD[villagers+4],1        ; Add to number of available villagers
    sub DWORD[funds],1              ; Cost of recruiting a villager
    noRecruitedVillagers:
ret

; Returns the current number of villagers
getVillagers:
    mov eax, DWORD[villagers]
ret

; Returns the current number of available villagers
getVillagersAvail:
    mov eax, DWORD[villagers + 4]
ret

; **************** Farm Functions ********************
buildFarm:
    mov eax, [esp+4]                ; village pointer

    cmp DWORD[villagers + 4],0      ; Check for available villagers
    jg farmSuccess

    mov eax,DWORD[notEnoughVillagers]           ; Error message = 2
    jmp return

    farmSuccess:
        mov ecx, 0
        findFarm:                   ; Find next free space in village
            cmp ecx,0
            je tryNextFarmSpot      ; Can't build farm on first space (for a wall)

            mov edx,DWORD[villageSize]
            sub edx,1
            cmp ecx,edx
            je tryNextFarmSpot

            cmp BYTE[eax + ecx],'_' ; Check for available village space
            je addFarmToVillage

            tryNextFarmSpot:        ; Move to next village space
            add ecx,1
            cmp ecx,DWORD[villageSize]
            jl findFarm

            mov eax,DWORD[notEnoughVillageSpace]    ; Error message = 3
            jmp return

        
        addFarmToVillage:               ; When a farm can successfully be added 
        mov BYTE[eax + ecx],'f'         ; Add 'f' to village to represent farm in progress
        sub DWORD[villagers + 4], 1     ; Subtract 1 from available villagers
        add DWORD[farms],1              ; Add to number of farms


        mov ecx,DWORD[farms]            ; Update corresponding farmPtr value
        sub ecx,1                       ; Index starts at 0, not 1
        mov edi,DWORD[farmPtr]          ; In order to get pointer to pointer
        add DWORD[edi+ecx*4],1          ; Start building farm

        mov eax,0
        jmp return
    return:
ret

; **************** Wall Functions ********************
buildWall:
    mov edi, [esp+4] ; village pointer

    cmp DWORD[funds],25             ; Check for sufficient funds
    mov eax,DWORD[notEnoughFunds]   ; message = 6
    jl wallsBuilt

    cmp DWORD[walls],4              ; Check for fully upgraded walls
    mov eax,DWORD[wallMaxLevel]     ; message = 7
    je wallsBuilt

    mov eax,0                       ; message = 0

    sub DWORD[funds],25             ; cost of wall
    add DWORD[walls],1              ; Update number of walls

        mov BYTE[edi],'w'           ; 1 level 1 wall (at start of villagePtr)
        
        cmp DWORD[walls],2          ; Walls at level 2
        jl wallsBuilt

        mov BYTE[edi],'W'           ; 1 level 2 wall
        cmp DWORD[walls],3          ; Walls at level 3
        jl wallsBuilt

        mov edx,DWORD[villageSize]  ; Move to end of villagePtr
        sub edx,1
        mov BYTE[edi+edx],'w'       ; 2nd wall at level 1
        cmp DWORD[walls],4          ; Walls at level 4
        jl wallsBuilt

        mov BYTE[edi+edx],'W'       ; 2nd wall at level 2
    wallsBuilt:
ret

; Return current number of walls
getWalls:
    mov eax,DWORD[walls]
ret

;****************** Time *****************************
; Progress time by one hour
moveTime:
    mov eax, [esp+4]                ; village pointer

    mov ecx, 0
    mov edi,DWORD[farmPtr]
    farmLoop:                       ; Loop through farmPtr
        cmp DWORD[edi+ecx*4],1      ; Check for 1 in farm's value
        jne noFundsAdded
        add DWORD[funds],1          ; Add 1 to funds for each farm

        noFundsAdded:
        add ecx, 1                  ; Increment loop
        cmp ecx, DWORD[farms]
        jl farmLoop
    
    mov edx,DWORD[timeToMakeFarm]
    mov ecx, 0
    upgradeFarms:
        cmp DWORD[edi+ecx*4],edx    ; Once a farm at -4 is reached, farms are done
        jl upgradeFarmsDone
        cmp DWORD[edi+ecx*4],1      ; A farm already at '1' doesn't need to be updated
        je upgradeFarmsNextLoop
        
        add DWORD[edi+ecx*4],1      ; Otherwise, adds 1 to farm's value

        cmp DWORD[edi+ecx*4],1      ; If the farm has been built
        jne upgradeFarmsNextLoop
        add ecx,1                   ; Account for indexing at 0
        mov BYTE[eax+ecx],'F'       ; Replace 'f' with 'F' in village
        sub ecx,1

        upgradeFarmsNextLoop:
            add ecx,1
            cmp ecx,DWORD[numPossibleFarms]
            jl upgradeFarms
        upgradeFarmsDone:

    add DWORD[hour],1               ; Increment time
    cmp DWORD[hour],24              ; Reset time to 00:00 at 23:00
    jl dontResetTime
    mov DWORD[hour],0

    cmp DWORD[attackChancePerNight],100
    je dontResetTime
    add DWORD[attackChancePerNight],10  ; Chance for attack increases each day
    dontResetTime:
ret

; Returns the current time
getTime:
    mov eax,DWORD[hour]
ret

; The current chance for attack
getAttackChance:
    mov eax,DWORD[attackChancePerNight]
ret

; When the village is attacked
attack:
    mov edi, [esp+4]                ; Village pointer

    mov eax,0
    cmp DWORD[walls],0              ; If there are no walls when attacked, player loses
    je gameOver

        sub DWORD[walls],1          ; Decrease walls' level
        mov edx,DWORD[villageSize]
        sub edx,1
        mov BYTE[edi+edx],'w'
        
        cmp DWORD[walls],3
        je attackReturn

        mov BYTE[edi+edx],'_'
        cmp DWORD[walls],2
        je attackReturn

        mov BYTE[edi],'w'
        cmp DWORD[walls],1
        je attackReturn

        mov BYTE[edi],'_'
        jmp attackReturn

    gameOver:
    mov eax,DWORD[gameOverMessage]  ; message = 5: game over
    attackReturn:
ret

; **************** Funds Functions ********************
; Returns current funds
getFunds:
    mov eax, DWORD[funds]
ret

villageFormat:
    db ` %c`,0          ; Format string for printing village

printNewLine:
	db `\n`,0                             

villageSize:
    dd 10               ; Size of village - used in buildVillage

; Various error messages
notEnoughVillagers:
    dd 2
notEnoughVillageSpace:
    dd 3
gameOverMessage:
    dd 5
notEnoughFunds:
    dd 6
wallMaxLevel:
    dd 7

section .data
villagers: 
    dd 0        ; Total villagers
    dd 0        ; Available villagers

walls:
    dd 0        ; Number of walls

farms:
    dd 0        ; Number of farms

numPossibleFarms:
    dd 0        ; Available spots for farms

timeToMakeFarm:
    dd -3       ; Time a farm starts at before being fully built

farmPtr:
    dd 0        ; Pointer to array with farm information

funds:
    dd 10       ; Amount of starting funds

hour:
    dd 9        ; Starting hour

attackChancePerNight:
    dd 0        ; Starting chance for attack
