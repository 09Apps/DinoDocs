//
//  DDSelectViewController.h
//  DinoDoc
//
//  Created by Swapnil Takalkar on 1/31/14.
//  Copyright (c) 2014 09Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DDSelectViewController : UIViewController

@property NSUInteger animaltype;
@property (nonatomic, strong) NSArray* questions;
@property (weak, nonatomic) IBOutlet UILabel *quetxt;
@property (weak, nonatomic) IBOutlet UIButton *opt1;
@property (weak, nonatomic) IBOutlet UIButton *opt2;
@property (weak, nonatomic) IBOutlet UIButton *opt3;
@property (weak, nonatomic) IBOutlet UIButton *opt4;

//-(id) initWithAnimalType:(NSUInteger) type;
@end
