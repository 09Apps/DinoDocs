//
//  DDSelectViewController.h
//  DinoDoc
//
//  Created by Swapnil Takalkar on 1/31/14.
//  Copyright (c) 2014 09Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DDSelectViewController : UIViewController

- (void)showQuestions;

@property NSUInteger animaltype;
@property NSUInteger answernum;
@property NSUInteger currentqnum;
@property (nonatomic, strong) NSArray* questions;
@property (weak, nonatomic) IBOutlet UILabel *quetxt;

@end
