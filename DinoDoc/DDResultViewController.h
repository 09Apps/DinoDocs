//
//  DDResultViewController.h
//  DinoDoc
//
//  Created by Swapnil Takalkar on 3/8/14.
//  Copyright (c) 2014 09Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DDResultViewController : UIViewController

@property NSUInteger score;
@property NSUInteger quizcount;
@property NSUInteger time;
@property (weak, nonatomic) IBOutlet UILabel *scorelbl;
@property (weak, nonatomic) IBOutlet UILabel *titlelbl;
@property (weak, nonatomic) IBOutlet UILabel *namelbl;

@end
