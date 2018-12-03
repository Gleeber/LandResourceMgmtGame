// Liam Eberhart, Andrew Adler
// interface.cpp
// CS 301 Project 2: Resource Management Game
// This is the C++ code for the Resource Management Game
// linked with town.asm

#include <iostream>
using std::cin;
using std::cout;
using std::endl;
#include <iomanip>
using std::setw;
using std::setfill;
#include <string>
using std::string;
using std::getline;
#include <cstdlib>
using std::rand;
using std::srand;
#include <ctime>
using std::time;
#include <stdlib.h>
using std::system;

#define gotoxy(x,y) printf("\033[%d;%dH", (x), (y))

extern "C" char * buildVillage();
extern "C" void printVillage(char *);

extern "C" int recruitVillager();
extern "C" int getVillagers();
extern "C" int getVillagersAvail();

extern "C" int buildFarm(char *);

extern "C" int buildWall(char *);
extern "C" int getWalls();

extern "C" void moveTime(char *);
extern "C" int getTime();
extern "C" int getAttackChance();
extern "C" int attack(char *);
extern "C" int getFunds();

int main () {
    char *villagePtr = buildVillage();  // Sets up "village" at runtime
    bool keepPlaying = true;
    int line;                           // What line to move cursor to
    int charSpaces;                     // How many chars to move cursor
    int message = 0;                    // Interface message to display
    int linesUntilVillage;

    srand(time(NULL));                  // Seeding the random number generator
    int attackChance;                   // Calculated chance for attack each hour
    int maxRandValue = 100;             // Used in calculating chance for attack
    
    while (keepPlaying) {   // Loops while the person continues playing
        system("clear");    // Clears console for each loop (only on Linux)
        line = 10;          // Lines down to set cursor to for input
        charSpaces = 3;     // Characters to move cursor to the right
        linesUntilVillage = 6;

        // Print the current time
        cout << "Time: " << setw(2) << setfill('0') << getTime() << ":00";
        if (getTime() <= 5) // Between 00:00 and 06:00, there is a chance to be attacked
        {
            cout << "\t (" << getAttackChance() << "\% chance of attack)";
        }
        cout << endl;

        cout << "Number of villagers: " << getVillagers() 
             << " (" << getVillagersAvail() << " unassigned)" << endl;
        cout << "Coin: " << getFunds() << endl;

        cout << "Choose your action:\ne \t exit\n";
        cout << "blank \t skip time\n";
        cout << "r \t recruit villager\n";
        cout << "f \t build a farm\n";
        cout << "w \t build a wall\n";

        // If there is an additional message to display to user
        //      Used for displaying specific error messages as well
        if (message)
        {
            cout << endl;

            switch (message)
            {
                case 1:
                    cout << "Input not recognized. Please enter a valid input.\n";
                    break;

                case 2:
                    cout << "Not enough unassigned villagers.\n";
                    break;

                case 3:
                    cout << "Not enough farmland to build another farm.\n";
                    break;

                case 4:
                    cout << "You've been attacked!\n";
                    break;

                case 5:
                    cout << "Your unprotected village was attacked!" << endl;
                    cout << "Game over..." << endl;
                    line++;
                    keepPlaying = false;
                    continue;
                    break;

                case 6:
                    cout << "You don't have enough funds to perform that action." << endl;
                    break;

                case 7:
                    cout << "Your walls are already at their maximum level." << endl;
                    break;
            }

            cout << endl;

            line += 3;
            linesUntilVillage -= 3;

            message = 0;
        }

        cout << ">:";   // What is displayed in front of cursor accepting input

        // To keep the village from moving from its location on the screen
        // linesUntilVillage is updated when additional console messages are displayed
        for (int i = 0; i < linesUntilVillage; i++) 
        {
            cout << endl;
        }
        printVillage(villagePtr);

        gotoxy(line,charSpaces);        // Move cursor to the ">:" to get input
	    string input;
	    getline(cin, input);

        if (input == "e") 
        {
            keepPlaying = false;
            system("clear");
	        cout << "Farewell!" << endl;
            break;
        }
	
        else if (input == "")
        {
            // Do nothing
        }

        else if (input == "r") 
        {
            if(message = recruitVillager())   
            // If recruitVillager doesn't return 0, a villager was not recruited
            {
                continue;   // Prevents time from advancing
            }
	    }
        
	    else if (input == "f") 
        {
            // Build a farm here
            if(message = buildFarm(villagePtr))   
            // If buildFarm doesn't return 0, a farm was not built
            {
                continue;   // Prevents time from advancing
            }
	    }

        else if (input == "w") 
        {
            // Build walls here
            if (message = buildWall(villagePtr))
            // If buildWall doesn't return 0, a wall was not built
            {
                continue;   // Prevents time from advancing
            }
	    }

        else                // When an unexpected input is given
        {
            message = 1;
            continue;       // Prevents time from advancing
        }

        // Calculating if the village gets attacked
        if (getTime() >= 0 && getTime() <= 5)
        {
            attackChance = rand()%maxRandValue + 1;
            // attackChance will be a value 1-100
            if (attackChance <= getAttackChance())
            {
                if (message = attack(villagePtr))
                {
                    // message = 5: game over message
                }
                else 
                {
                    // message = 4: player was attacked, but survived
                    message = 4;
                }
            }
        }

        moveTime(villagePtr);   // After handling input, advance time by 1 hour
    }
    return 0;
}
