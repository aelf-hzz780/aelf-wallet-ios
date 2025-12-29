//
//  ValidError.swift
//  AelfApp
//
//  Created by 晋先森 on 2019/5/31.
//  Copyright © 2019 AELF. All rights reserved.
//

import Foundation
// Using local Validator implementation

struct ValidatorError: ValidationError {
    public var message: String

    public init(message: String) {
        self.message = message
    }
}
