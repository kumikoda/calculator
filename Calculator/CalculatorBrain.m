//
//  CalculatorBrain.m
//  Calculator
//
//  Created by Anson Chu on 4/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CalculatorBrain.h"

@interface CalculatorBrain()
@property (nonatomic, strong) NSMutableArray *programStack;
@end

@implementation CalculatorBrain

@synthesize programStack = _programStack;

- (NSMutableArray *)programStack
{
    // lazy instantiation
    if (_programStack == nil) _programStack = [[NSMutableArray alloc] init];
    return _programStack;
}

-(void) pushOperand:(id)operand
{
    [self.programStack addObject:operand];
}

-(double) performOperation:(NSString *)operation
{
    [self.programStack addObject:operation];
    return [CalculatorBrain runProgram:self.program];
}

-(double) performOperation:(NSString *)operation usingVariableValues:(NSDictionary *)variableValues
{
    [self.programStack addObject:operation];
    return [CalculatorBrain runProgram:self.program usingVariableValues:variableValues];
}

- (id) program
{
    return [self.programStack copy];
}

- (void) clear
{
    self.programStack = nil;
}

+ (double) runProgram: (id) program
{
    NSMutableArray *stack;
    if ([program isKindOfClass:[NSArray class]]) {
        stack = [program mutableCopy];
    }
    
    return [self popOperandOffStack:stack];
}

+ (double) popOperandOffStack: (NSMutableArray *)stack
{
    double result = 0;
    
    id topOfStack = [stack lastObject];
    if (topOfStack) [stack removeLastObject];
    
    if ([topOfStack isKindOfClass:[NSNumber class]]){
        result = [topOfStack doubleValue];
    } else if ([topOfStack isKindOfClass:[NSString class]]){
        NSString *operation = topOfStack;
        
        if ([@"+" isEqualToString:operation]){
            result = [self popOperandOffStack:stack] + [self popOperandOffStack:stack];
        } else if ([@"-" isEqualToString:operation]){
            double tmp = [self popOperandOffStack:stack];
            result = [self popOperandOffStack:stack] - tmp;
        } else if ([@"*" isEqualToString:operation]){
            result = [self popOperandOffStack:stack] * [self popOperandOffStack:stack];
        } else if ([@"/" isEqualToString:operation]){
            double tmp = [self popOperandOffStack:stack];
            result = [self popOperandOffStack:stack] / tmp;
        } else if ([@"sin" isEqualToString:operation]){
            result = sin([self popOperandOffStack:stack]);
        } else if ([@"cos" isEqualToString:operation]){
            result = cos([self popOperandOffStack:stack]);
        } else if ([@"sqrt" isEqualToString:operation]){
            result = sqrt([self popOperandOffStack:stack]);
        } else if ([@"π" isEqualToString:operation]){
            result = 3.14;
        }
    }
    
    return result;
}


+ (BOOL) isOperation:(NSString *)operation
{
    return ([[NSSet setWithObjects:@"+",@"-",@"*",@"/",@"sin",@"cos",@"sqrt",@"π", nil] containsObject:operation]);
}
+ (int) ordinalityOf:(NSString *)operation
{
    if ([[NSSet setWithObjects:@"+",@"-",@"*",@"/", nil] containsObject:operation]) return 2;
    else if ([[NSSet setWithObjects:@"sin",@"cos",@"sqrt", nil] containsObject:operation]) return 1;
    else return 0;
}
+ (BOOL) isVariable:(NSString *)operation
{
    return ([[NSSet setWithObjects:@"x",@"y",@"z", nil] containsObject:operation]);
}

+ (NSString *) describe:(NSMutableArray *) stack {
    NSString *description = @"";
    
    id topOfStack = [stack lastObject];
    if (topOfStack) [stack removeLastObject];
    
    if ([topOfStack isKindOfClass:[NSNumber class]]){
        description = [NSString stringWithFormat:@"%@", topOfStack];
    } else if ([topOfStack isKindOfClass:[NSString class]]){
        if ([self isOperation:topOfStack]){
            NSString *operation = topOfStack;
            if ([self ordinalityOf:operation]==0) {
                description = operation;
            } else if ([self ordinalityOf:operation]==1) {
                description = [NSString stringWithFormat:@"%@( %@ )", operation, [self describe:stack]];
            } else if ([self ordinalityOf:operation]==2) {
                NSString *tmp = [self describe:stack];
                description = [NSString stringWithFormat:@"( %@ %@ %@ )", [self describe:stack], operation, tmp];
            }
        } else if ([self isVariable:topOfStack]){
            description = topOfStack;
        }
    }
    
    return description;

}
    
+ (NSString *) descriptionOfProgram:(id)program {
    NSMutableArray *stack;
    if ([program isKindOfClass:[NSArray class]]) {
        stack = [program mutableCopy];
    }
    return [self describe:stack];
}

+ (double) runProgram: (id)program usingVariableValues: (NSDictionary *) variableValues{
    NSMutableArray *stack;
    if ([program isKindOfClass:[NSArray class]]) {
        stack = [program mutableCopy];
    }
    
    // loop through program stack, if we see a variable, replace it with the value
    // 0 if 
    for (int i = 0;i< stack.count;i++){
        id element = [stack objectAtIndex:i];
        if ([self isVariable:element]){
            NSNumber *newNumber = [variableValues objectForKey:element]? [variableValues objectForKey:element]:[NSNumber numberWithInt:0];
            [stack replaceObjectAtIndex:i withObject:newNumber];
        }
    }
    
    return [self popOperandOffStack:stack];
}

+ (NSSet *) variablesUsedInProgram:(id)program{
    return nil;
}


@end
