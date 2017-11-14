//
//  DropDown.h
//  VPDropDown
//
//  Created by Vivek on 03/08/17.
//  Copyright © 2017 Vivek. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol VPDropDownDelegate <NSObject>

- (void)selectItemAtIndex:(NSInteger)index WithItem:(NSString*)selectedStr withTextField:(UITextField*)textField;
- (void)selectItemAtIndex:(NSInteger)index WithItem:(NSString*)selectedStr withTextField:(UITextField*)textField andIndexPath:(NSIndexPath*)indexPath;

@end


@interface DropDown : UIView<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, weak) id<VPDropDownDelegate> delegate;

@property (nonatomic, strong)UITableView *dropDownList;

- (id)initWithTextField:(UITextField*)textField andDataSource:(NSArray*)data OnView:(UIView*)view;
- (id)initWithTextField:(UITextField*)textField andDataSource:(NSArray*)data withTableView:(UITableView*)mainTableView OnIndexPath:(NSIndexPath*)indexPath;


@property(nonatomic, strong)UITextField *currentTextField;
@property (nonatomic, strong)UIView *currentView;
@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic, strong) NSMutableArray *filterContentList;

@property (nonatomic)BOOL isFilter;
@end
