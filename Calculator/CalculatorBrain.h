//
//  CalculatorBrain.h
//  Calculator
//
//  Created by Anson Chu on 4/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CalculatorBrain : NSObject
- (void) pushOperand:(id)operand;
- (double) performOperation:(NSString *)operation;
- (double) performOperation:(NSString *)operation usingVariableValues: (NSDictionary *) variableValues;
- (void) removeTopItemFromStack;
- (void) clear;

@property (readonly) id program;

+ (double) runProgram: (id)program; 
+ (NSString *) descriptionOfProgram: (id)program;
+ (double) runProgram: (id)program usingVariableValues: (NSDictionary *) variableValues;
+ (NSSet *) variablesUsedInProgram:(id)program;


@end
