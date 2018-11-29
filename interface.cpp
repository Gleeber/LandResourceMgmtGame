//Liam Eberhart
//Andrew Adler
//CS 303 Project 2
//This is loosely based on the "Kingdom" series, mostly just resouce management

#include <iostream>
using std::cin;
using std::cout;
using std::endl;
#include <string>
using std::string;
using std::getline;
#include <stdlib.h>
using std::system;

#define gotoxy(x,y) printf("\033[%d;%dH", (x), (y))

extern "C" void testingFunction();

extern "C" char * buildVillage();
extern "C" void printVillage(char *);

extern "C" void recruitVillager();
extern "C" int getVillagers();
extern "C" int getVillagersAvail();

extern "C" int buildFarm(char *);

extern "C" int buildWall(char *);

extern "C" void moveTime();
extern "C" void addFunds();
extern "C" int getFunds();

int main () {
    char *villagePtr = buildVillage();
    bool keepPlaying = true;
    int line = 9;           // What line to move cursor to
    int charSpaces = 3;     // How many chars to move cursor
    int errorMessage = 0;
    int linesUntilVillage = 0;
    while (keepPlaying) {
        system("clear");
        line = 9;
        charSpaces = 3;
        linesUntilVillage = 6;
        cout << "Number of villagers: " << getVillagers() 
             << " (" << getVillagersAvail() << " unassigned)" << endl;
        cout << "Coin: " << getFunds() << endl;

        cout << "Choose your action:\ne \t exit\nblank \t skip time\nr \t recruit villager\nf \t build a farm ("<<"#" << "//2)\nw \t walls\n";

        if (errorMessage)
        {
            cout << endl;

            switch (errorMessage)
            {
                case 1:
                    cout << "Input not recognized. Please enter a valid input\n";
                    break;

                case 2:
                    cout << "Not enough unassigned villagers.\n";
                    break;

                case 3:
                    cout << "Not enough farmland to build another farm.\n";
                    break;
            }

            cout << endl;

            line += 3;
            linesUntilVillage -= 3;

            errorMessage = 0;
        }

        cout << ">:";

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
	        cout << "Farewell!" << endl;
            system("clear");
            break;
        }
	
	else if(input == "" )
	{
	    moveTime();
	    continue;
	}

        else if (input == "r") 
        {
            recruitVillager();
	}
        
	else if (input == "f") 
        {
            //build a farm here, would give income limit farms?
            if(errorMessage = buildFarm(villagePtr))   
            // If buildFarm doesn't return 0, a farm was not built
            {
                continue;
            }
	}

        else if (input == "w") 
        {
            //build walls here, maybe have upgrade table/cost of upgrades?
            buildWall(villagePtr);
	}

        else        // When an unexpected input is given
        {
            errorMessage = 1;
            continue;
        }

        moveTime();
    }
    return 0;
}
