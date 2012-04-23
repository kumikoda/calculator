//
//  ViewController.m
//  Calculator
//
//  Created by Anson Chu on 4/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"
#import "CalculatorBrain.h"

@interface ViewController ()
@property (nonatomic) BOOL userIsInTheMiddleOfEnteringANumber;
@property (nonatomic,strong) CalculatorBrain *brain;
@property (nonatomic, strong) NSDictionary *testVariableValues;
@end

@implementation ViewController
@synthesize brain = _brain;
@synthesize display = _display;
@synthesize history = _history;
@synthesize currentVariableValues = _currentVariableValues;
@synthesize testVariableValues = _testVariableValues;
@synthesize userIsInTheMiddleOfEnteringANumber = _userIsInTheMiddleOfEnteringANumber;

- (NSDictionary *) testVariableValues
{
    if (!_testVariableValues) _testVariableValues = [[NSDictionary alloc] init];
    return _testVariableValues;
}

- (CalculatorBrain *) brain
{
    if (!_brain) _brain = [[CalculatorBrain alloc] init];
    return _brain;
}

- (IBAction)digitPressed:(UIButton *)sender {
    NSString *digit = sender.currentTitle;
    if (self.userIsInTheMiddleOfEnteringANumber){
        self.display.text = [self.display.text stringByAppendingString:digit];
    } else {
        self.display.text = digit;
        self.userIsInTheMiddleOfEnteringANumber = YES;
    }
    [self updateHistory:digit];
    
}
- (IBAction)periodPressed:(UIButton *)sender {
    // if display contains decimal, push display, and start a new one
    // if display does not contain decimal, add it
    
    NSRange range = [self.display.text rangeOfString:@"."];
    if (range.location == NSNotFound) {
        self.display.text = [self.display.text stringByAppendingString:@"."];
    } else {
        [self enterPressed];
        self.display.text = @"0.";
    }
    self.userIsInTheMiddleOfEnteringANumber = YES;
    [self updateHistory:@"."];
}

- (IBAction)enterPressed {
    // If variable, push variable string
    // If number, push NS number
    if ([self.display.text isEqual:@"x"] || [self.display.text isEqual:@"y"] ||[self.display.text isEqual:@"z"]){
        [self.brain pushOperand:self.display.text];
    } else {
        [self.brain pushOperand:[NSNumber numberWithDouble:[self.display.text doubleValue]]];
    }
    self.userIsInTheMiddleOfEnteringANumber = NO;
    [self updateHistory:@"enter"];
}


- (IBAction)operationPressed:(UIButton *)sender {
    if(self.userIsInTheMiddleOfEnteringANumber) [self enterPressed];
    //double result = [self.brain performOperation:sender.currentTitle];
    double result = [self.brain performOperation:sender.currentTitle usingVariableValues:self.testVariableValues];
    
    NSString  *resultString = [NSString stringWithFormat:@"%g",result];
    self.display.text = resultString;
    [self updateHistory:sender.currentTitle];
}

- (IBAction)clearPressed:(UIButton *)sender {
    self.display.text = @"0";
    self.history.text = @"";
    self.currentVariableValues.text = @"";
    self.testVariableValues = nil;
    self.userIsInTheMiddleOfEnteringANumber = NO;
    [self.brain clear];
}

- (void)viewDidUnload {
    [self setHistory:nil];
    [self setCurrentVariableValues:nil];
    [super viewDidUnload];
}

- (void) updateHistory:(NSString *)text {
   
    self.history.text = [CalculatorBrain descriptionOfProgram:[self.brain program]];
    
}

- (IBAction)variablePressed:(UIButton *)sender 
{
    if (self.userIsInTheMiddleOfEnteringANumber){
        [self enterPressed];
    }
    self.display.text = sender.currentTitle;
    self.userIsInTheMiddleOfEnteringANumber = NO;
    [self updateHistory:sender.currentTitle];
}

- (void) updateCurrentVariableValues
{
    NSString *s = @"";
    for(id key in self.testVariableValues){
       s = [s stringByAppendingString:[NSString stringWithFormat: @"%@=%@  ", key, [self.testVariableValues objectForKey:key]]];
    }
    self.currentVariableValues.text = s;
}

- (IBAction)testPressed:(UIButton *)sender {
    if([sender.currentTitle isEqualToString:@"test3"]) {
        self.testVariableValues = [NSDictionary dictionaryWithObjectsAndKeys:
                              [NSNumber numberWithInt:1], @"x", 
                              [NSNumber numberWithInt:2], @"y",
                              [NSNumber numberWithInt:3], @"z", nil];
        
    }
    [self updateCurrentVariableValues];
    
    double result = [CalculatorBrain runProgram:self.brain.program usingVariableValues:self.testVariableValues];
    NSString  *resultString = [NSString stringWithFormat:@"%g",result];
    self.display.text = resultString;
}

@end
