//
//  ViewController.m
//  VPDropDown
//
//  Created by Vivek on 03/08/17.
//  Copyright © 2017 Vivek. All rights reserved.
//

#import "ViewController.h"
#import "DropDown.h"

@interface ViewController ()<VPDropDownDelegate>
@property (strong, nonatomic) IBOutlet UITextField *textField;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // If you have your textfield in scrollView you have to replace self.view with scrollView
    _dropDown = [[DropDown alloc]initWithTextField:self.textField andDataSource:@[@"one",@"two",@"three"] OnView:self.view];
    _dropDown.delegate = self;
    
}

- (void)selectItemAtIndex:(NSInteger)index WithItem:(NSString *)selectedStr{
    self.textField.text = selectedStr;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
