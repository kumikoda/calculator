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
@end

@implementation ViewController
@synthesize brain = _brain;
@synthesize display = _display;
@synthesize history = _history;

@synthesize userIsInTheMiddleOfEnteringANumber = _userIsInTheMiddleOfEnteringANumber;


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
    
    
}
- (IBAction)periodPressed:(UIButton *)sender {
    // if display contains decimal, push display, and start a new one
    // if display does not contain decimal, add it
    NSRange range = [self.display.text rangeOfString:@"."];
    
    if (self.userIsInTheMiddleOfEnteringANumber){
        if (range.location == NSNotFound) {
            self.display.text = [self.display.text stringByAppendingString:@"."];
        }else {
            [self enterPressed];
            self.display.text = @"0.";
        }     
    } else {
        self.display.text = @"0.";
    } 
    
    self.userIsInTheMiddleOfEnteringANumber = YES;
    
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
    [self updateHistory];
}


- (IBAction)operationPressed:(UIButton *)sender {
    if(self.userIsInTheMiddleOfEnteringANumber) [self enterPressed];
    double result = [self.brain performOperation:sender.currentTitle];
    NSString  *resultString = [NSString stringWithFormat:@"%g",result];
    self.display.text = resultString;
    [self updateHistory];
}

- (IBAction)clearPressed:(UIButton *)sender {
    self.display.text = @"0";
    self.history.text = @"";
    self.userIsInTheMiddleOfEnteringANumber = NO;
    [self.brain clear];
}

- (void)viewDidUnload {
    [self setHistory:nil];
    [super viewDidUnload];
}

- (void) updateHistory {
   
    self.history.text = [CalculatorBrain descriptionOfProgram:[self.brain program]];
    
}

- (IBAction)variablePressed:(UIButton *)sender 
{
    if (self.userIsInTheMiddleOfEnteringANumber){
        [self enterPressed];
    }
    self.display.text = sender.currentTitle;
    self.userIsInTheMiddleOfEnteringANumber = NO;
}


- (IBAction)undoPressed:(id)sender {
    // if in the middle of typing, remove a digit
    if (self.userIsInTheMiddleOfEnteringANumber){
        self.display.text =[self.display.text substringToIndex:self.display.text.length-1];
        if (self.display.text.length == 0) self.userIsInTheMiddleOfEnteringANumber = NO;
    } else{
        [self.brain removeTopItemFromStack];
    }
    [self updateHistory];
}

@end
