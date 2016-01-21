//
//  MyApp.m
//  deployOnDayOne
//
//  Created by Zachary Drossman on 1/28/15.
//  Copyright (c) 2015 Zachary Drossman. All rights reserved.
//

#import "MyApp.h"


@interface MyApp()

@end


@implementation MyApp

-(void)execute
{
    NSInteger stage=1;
    NSMutableArray *Questions=[@[@"What is your nickname?",
                @"Do you have any siblings?",
                @"What did you do before Flatiron?",
                @"What are your hobbies?",
                @"What is your favorite color?",
                @"What is your spirit animal?"] mutableCopy];
    
    NSMutableArray *Users = [@[] mutableCopy];
    
    while (stage > 0) {
    
        NSLog(@"Please type your full name: ");
        NSString *username = [self requestKeyboardInput];
        NSString *currentUser = nil;
        
        if ([Users count] == 0) {
            [Users addObject:@{ @"name":username,
                           @"questions":[@{} mutableCopy]}];
            currentUser=Users[0][@"name"];
        }
        else {
            
            NSPredicate *filterUser = [NSPredicate predicateWithFormat:@"name CONTAINS[cd] %@",username];
            NSArray *filteredUser = [Users filteredArrayUsingPredicate:filterUser];
            if ([filteredUser count]==1) {
                NSLog(@"Welcome Back!");
                currentUser = filteredUser[0][@"name"];
            }
            else if([filteredUser count] > 1) {
                NSLog(@"Multiple Matches were found.");
            }
            else {
                NSLog(@"Welcome! We're adding a new profile for you on our database.");
                [Users addObject:@{ @"name":username,
                                    @"questions":[@{} mutableCopy]
                                }];
                currentUser=username;
            }
            
        }
        
        NSInteger indexOfUser = -1;
        for (NSInteger i=0; i<[Users count]; i++) {
            if ([Users[i][@"name"] isEqualToString:currentUser]) {
                indexOfUser = i;
            }
            
        }
            stage=2;
            while (stage>1) {
            
                NSLog(@"\nMENU: \n 1) Be interviewed. \n 2) Write a new interview question. \n 3) Read an interview with another student. \n 4) Log out. \n\n Please choose one.");
                NSString *m1Choice = [self requestKeyboardInput];
            
                /********* BE INTERVIEWED **********/
                    if ([m1Choice isEqualToString:@"1"]) {
                        BOOL quitInterview = FALSE;
                        while (!quitInterview) {
                            
                            NSLog(@"You have chosen to be interviewed.");
                            
                            if ([Questions count] == [[Users[indexOfUser][@"questions"] allKeys] count]) {
                                NSLog(@"You've answered all possible questions! Returning to main menu...");
                                quitInterview=TRUE;
                            }
                            
                            else {
                                NSLog(@"\n 1. Choose the question you will be asked. \n 2. Be asked a random question.");
                                NSString *m2Choice = [self requestKeyboardInput];
                                
                                if ([m2Choice isEqualToString:@"1"]) {
                                    NSLog(@"Here is a list of questions available");
                                    for (NSInteger i=0; i<[Questions count]; i++) {
                                        NSLog(@"%lu. %@",(i+1),Questions[i]);
                                    }
                                    NSLog(@"Please pick one (type the corresponding number):");
                                    NSString *numInString =[self requestKeyboardInput];
                                    
                                    NSNumberFormatter *numForm = [[NSNumberFormatter alloc] init];
                                    [numForm setNumberStyle:NSNumberFormatterDecimalStyle];
                                    NSNumber *num=[numForm numberFromString:numInString];
                                    
                                    NSString *question=Questions[[num integerValue]-1];
                                    
                                    if (Users[indexOfUser][@"questions"][question]!=nil) {
                                        NSLog(@"You've already answered that question!");
                                    }
                                    else {
                                    
                                    NSLog(@"%@. %@",num,question);
                                    NSString *answer = [self requestKeyboardInput];
                                    
                                    Users[indexOfUser][@"questions"][question]=answer;
                                    }
                                }
                                else if ([m2Choice isEqualToString:@"2"]) {
                                    NSInteger randomIndex = arc4random_uniform([Questions count]);
                                    NSString *question=Questions[randomIndex];
                                    
                                    while(Users[indexOfUser][@"questions"][question]!=nil) {
                                        randomIndex = arc4random_uniform([Questions count]);
                                        question = Questions[randomIndex];
                                    }
                                    
                                    NSLog(@"%ld. %@",(randomIndex+1),question);
                                    NSString *answer = [self requestKeyboardInput];
                                
                                    Users[indexOfUser][@"questions"][question]=answer;
                                    
                                }
                                NSLog(@"Would you like to keep answering questions? y/n:");
                                NSString *continueInterview = [self requestKeyboardInput];
                                
                                if ([continueInterview isEqualToString:@"y"]) {
                                    quitInterview = FALSE;
                                }
                                else if ([continueInterview isEqualToString:@"n"]) {
                                    quitInterview = TRUE;
                                }
                                else {
                                    NSLog(@"Could not recognize reponse. Returning to main menu.");
                                    quitInterview = TRUE;
                                }
                            }
                        }
                    
                    }
                /********* ADD QUESTIONS ***********/
                else if ([m1Choice isEqualToString:@"2"]) {
                    BOOL quitAddingQuestions = FALSE;
                    while (!quitAddingQuestions) {
                        NSLog(@"You have chosen to write a new interview question.");
                        NSLog(@"Here are the current questions in the database.");
                        for (NSString *question in Questions) {
                            NSLog(@"---- %@",question);
                        }
                        NSLog(@"\n\nPlease type your new question below:");
                        NSString *newQuestion = [self requestKeyboardInput];
                        [Questions addObject:newQuestion];
                
                        NSLog(@"Question has been added! Thank you for your contribution.");
                        NSLog(@"Would you like to continue adding questions? y/n:");
                        NSString *continueOrQuit = [self requestKeyboardInput];
                        
                        if ([continueOrQuit isEqualToString:@"n"]) {
                            quitAddingQuestions = TRUE;
                        }
                        else if ([continueOrQuit isEqualToString:@"y"]){
                            quitAddingQuestions = FALSE;
                        }
                        else {
                            NSLog(@"Could not recognize input. Returning to main menu.");
                            quitAddingQuestions = TRUE;
                        }
                        
                    }
                }
                /*********** READ ANOTHER STUDENT'S INTERVIEW *********/
                else if ([m1Choice isEqualToString:@"3"]) {
                    BOOL quitReading = FALSE;
                    while (!quitReading) {
                        
                    
                        NSLog(@"You have chosen to read another student's interview.");
                        NSSortDescriptor *sortUsersAsc = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES selector:@selector(caseInsensitiveCompare:)];
                        NSArray *sortedUsers = [Users sortedArrayUsingDescriptors:@[sortUsersAsc]];
                    
                        NSLog(@"Here are the current users to pick from:");
                        for (NSUInteger i=0; i<[sortedUsers count]; i++) {
                            NSLog(@"%lu. %@",(i+1),sortedUsers[i][@"name"]);
                        }
                        NSLog(@"Please choose a person's profile (Choose corresponding number):");
                        NSString *studentProfileNum = [self requestKeyboardInput];
                        
                    
                        NSNumberFormatter *numForm = [[NSNumberFormatter alloc] init];
                        [numForm setNumberStyle:NSNumberFormatterDecimalStyle];
                        NSNumber *numProf=[numForm numberFromString:studentProfileNum];
                        NSInteger numProfIndex = ([numProf integerValue]-1) ;
                        
                        NSLog(@"%@:",sortedUsers[numProfIndex][@"name"]);
                        for (NSString *key in sortedUsers[numProfIndex][@"questions"]) {
                            NSLog(@"%@ -------- %@",key,sortedUsers[numProfIndex][@"questions"][key]);
                        }
                        
                        NSLog(@"Would you like to keep reading other user's profiles? y/n");
                        NSString *continueOrQuit = [self requestKeyboardInput];
                        
                        if ([continueOrQuit isEqualToString:@"n"]) {
                            quitReading = TRUE;
                        }
                        else if ([continueOrQuit isEqualToString:@"y"]){
                            quitReading = FALSE;
                        }
                    
            
                    }
                }
                /******* LOG OUT ********/
                else if ([m1Choice isEqualToString:@"4"]){
                    NSLog(@"Have a great day!");
                    for (NSInteger i=0; i<25; i++) {
                        NSLog(@" ");
                    }
                    stage--;
                }
                else {
                    NSLog(@"Please type either 1, 2, 3 or 4.");
                }
            }
        }


    }


// This method will read a line of text from the console and return it as an NSString instance.
// You shouldn't have any need to modify (or really understand) this method.
-(NSString *)requestKeyboardInput
{
    char stringBuffer[4096] = { 0 };  // Technically there should be some safety on this to avoid a crash if you write too much.
    scanf("%[^\n]%*c", stringBuffer);
    return [NSString stringWithUTF8String:stringBuffer];
}

-(void)storeDictionary {
    
}



@end
