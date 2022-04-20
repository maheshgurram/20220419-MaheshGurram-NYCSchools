//
//  PrintLog.swift
//  20220419-MaheshGurram-NYCSchools
//
//  Created by Mahesh on 4/19/22.
//

import Foundation

class PrintLog {
    
    static func printToConsole(str: String) {
        #if targetEnvironment(simulator)
            print(str)
        #endif
    }
    
}
