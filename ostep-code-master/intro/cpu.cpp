/*************************** Sujay *************************

* File Name             :   cpu.cpp
    
* Author                :   Sujay

* Creation Date         :   29-06-2020

* Last Modified         :   Mon Jun 29 18:11:03 2020

* Description           :   

***********************************************************/
#include<iostream>
#include"common.h"
using namespace std; 

int main(int argc, char** argv) {
    if(argc <2) {
        cout << "Give string argument" << endl ; 
        exit(1) ;
    }
    while(1){
        cout << argv[1] << endl ; 
        Spin(1) ; 
    }
    return 0 ;
}
