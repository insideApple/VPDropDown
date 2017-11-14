//
//  TableViewSampleVC.m
//  VPDropDown
//
//  Created by Vivek on 03/08/17.
//  Copyright © 2017 Vivek. All rights reserved.
//

#import "TableViewSampleVC.h"
#import "DropDown.h"

@interface TableViewSampleVC ()<UITableViewDelegate,UITableViewDataSource,VPDropDownDelegate>


@end

@implementation TableViewSampleVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    
    UITextField *textField = (UITextField*)[cell viewWithTag:1];
//    DropDown *dropDown =  [[DropDown alloc]initWithTextField:textField andDataSource:@[@"One",@"Two",@"Three"] OnView:cell];
    DropDown *dropDown =  [[DropDown alloc]initWithTextField:textField andDataSource:@[@"One",@"Two",@"Three"] withTableView:tableView OnIndexPath:indexPath];

    dropDown.delegate = self;
    return cell;
}


- (void)selectItemAtIndex:(NSInteger)index WithItem:(NSString *)selectedStr withTextField:(UITextField *)textField andIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"Viewcontroller : selected index : %ld selected str : %@ andCellIndex : %ld",(long)index,selectedStr,indexPath.row);
}

@end
