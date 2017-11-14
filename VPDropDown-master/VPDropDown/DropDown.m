//
//  DropDown.m
//  VPDropDown
//
//  Created by Vivek on 03/08/17.
//  Copyright © 2017 Vivek. All rights reserved.
//

#import "DropDown.h"
#import "DropDownCell.h"
static NSString* dropDownCell = @"DropDownCell";


@implementation DropDown{
    BOOL isTableView;
    NSIndexPath *currentIndexPath;
}

- (id)init {
    self = [super init];
    
    if (self) {
        
    }
    
    return self;
}



- (id)initWithTextField:(UITextField*)textField andDataSource:(NSArray*)data OnView:(UIView*)view{
    
    self = [super init];
    if (self) {
        self.frame = CGRectMake(CGRectGetMinX(textField.frame), CGRectGetMaxY(textField.frame), CGRectGetWidth(textField.frame), 100);

        _currentTextField = textField;
        _dataSource = data;
        
        _dropDownList = [UITableView new];
        
        [self.dropDownList registerNib:[UINib nibWithNibName:dropDownCell bundle:nil] forCellReuseIdentifier:dropDownCell];
        self.dropDownList.separatorStyle = UITableViewCellSeparatorStyleNone;
        

        self.dropDownList.delegate = self;
        self.dropDownList.dataSource = self;
        self.dropDownList.layer.cornerRadius = 5.0;
        self.dropDownList.layer.masksToBounds = NO;
        self.dropDownList.layer.shadowOffset = CGSizeMake(-5, 5);
        self.dropDownList.layer.shadowRadius = 3;
        self.dropDownList.layer.shadowOpacity = 0.5;
        [self addSubview:self.dropDownList];

        // Add a "textFieldDidChange" notification method to the text field control.
        [textField addTarget:self
                      action:@selector(textFieldDidChange:)
            forControlEvents:UIControlEventEditingChanged];
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(myTextFieldDidBeginEditing:) name:UITextFieldTextDidBeginEditingNotification object:textField];
          [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(myTextFieldDidEndEditing:) name:UITextFieldTextDidEndEditingNotification object:textField];
        
        [self.dropDownList reloadData];
        self.hidden = YES;
        [view addSubview:self];
        _currentView = view;
    }
    return self;

}

- (id)initWithTextField:(UITextField*)textField andDataSource:(NSArray*)data withTableView:(UITableView*)mainTableView OnIndexPath:(NSIndexPath*)indexPath{    self = [super init];
    if (self) {
        CGRect cellRectInTable = [mainTableView rectForRowAtIndexPath:indexPath];
        CGRect cellInSuperview = [mainTableView convertRect:cellRectInTable toView:mainTableView];
        
        self.frame = CGRectMake(CGRectGetMinX(textField.frame), CGRectGetMinY(cellInSuperview)+CGRectGetMaxY(textField.frame), CGRectGetWidth(textField.frame), 100);
        currentIndexPath = indexPath;
        _currentTextField = textField;
        _dataSource = data;
        isTableView = YES;
        _dropDownList = [UITableView new];
        
        [self.dropDownList registerNib:[UINib nibWithNibName:dropDownCell bundle:nil] forCellReuseIdentifier:dropDownCell];
        self.dropDownList.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        
        self.dropDownList.delegate = self;
        self.dropDownList.dataSource = self;
        self.dropDownList.layer.cornerRadius = 5.0;
        self.dropDownList.layer.masksToBounds = NO;
        self.dropDownList.layer.shadowOffset = CGSizeMake(-5, 5);
        self.dropDownList.layer.shadowRadius = 3;
        self.dropDownList.layer.shadowOpacity = 0.5;
        [self addSubview:self.dropDownList];
        
        // Add a "textFieldDidChange" notification method to the text field control.
        [textField addTarget:self
                      action:@selector(textFieldDidChange:)
            forControlEvents:UIControlEventEditingChanged];
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(myTextFieldDidBeginEditing:) name:UITextFieldTextDidBeginEditingNotification object:textField];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(myTextFieldDidEndEditing:) name:UITextFieldTextDidEndEditingNotification object:textField];
        
        
        [self.dropDownList reloadData];
        self.hidden = YES;
        [mainTableView addSubview:self];
        _currentView = mainTableView;
    }
    return self;

}

- (void)myTextFieldDidBeginEditing:(NSNotification *)notification {
    UITextField *textField = (UITextField *)notification.object;
    _currentTextField = textField;
    [self showDropDown];
}
- (void)layoutSubviews {
    self.dropDownList.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
   
}

-(void)textFieldDidChange :(UITextField *)theTextField{
    NSLog( @"text changed: %@", theTextField.text);
    if (![theTextField hasText]) {
        [self hideDropDown];
        return;
    }
    [self showDropDown];
    _isFilter = YES;
    [_filterContentList removeAllObjects];
    NSString *searchString = theTextField.text;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF contains[cd] %@", searchString];
    
    NSArray *filtered = [_dataSource filteredArrayUsingPredicate:predicate];
    _filterContentList = [NSMutableArray arrayWithArray:filtered];
    
    [self.dropDownList reloadData];

}

- (void)myTextFieldDidEndEditing:(NSNotification *)notification{
    [self hideDropDown];
}

#pragma mark - TableView-Datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_isFilter) {
        return _filterContentList.count;
    }
    return _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DropDownCell *cell = [tableView dequeueReusableCellWithIdentifier:dropDownCell];
    if (cell == nil) {
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:dropDownCell owner:self options:nil];
        cell = [topLevelObjects objectAtIndex:0];
    }
    if (_isFilter) {
        cell.textLabel.text = _filterContentList[indexPath.row];
    }else{
        cell.textLabel.text = _dataSource[indexPath.row];

    }
    cell.layer.cornerRadius = 5.0;
    return cell;
}

#pragma mark - TableView delegate


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *selectedStr = [NSString new];
    if (_isFilter) {
        selectedStr = _filterContentList[indexPath.row];
    }else{
        selectedStr = _dataSource[indexPath.row];
    }
    _currentTextField.text = selectedStr;
    
    id<VPDropDownDelegate> strongDelegate = self.delegate;
    self.hidden = YES;
    
    if (isTableView) {
        if ([strongDelegate respondsToSelector:@selector(selectItemAtIndex:WithItem:withTextField:andIndexPath:)]) {
            [strongDelegate selectItemAtIndex:indexPath.row WithItem:selectedStr withTextField:_currentTextField andIndexPath:currentIndexPath];
        }
    }else{
        if ([strongDelegate respondsToSelector:@selector(selectItemAtIndex:WithItem:withTextField:)]) {
            [strongDelegate selectItemAtIndex:indexPath.row WithItem:selectedStr withTextField:_currentTextField];
        }
 
    }
   
}

- (void)showDropDown{
   
    for (UIView* subView in _currentView.subviews) {
        if (subView == self) {
            subView.hidden = YES;
        }
    }
    self.hidden = NO;

}

- (void)hideDropDown{
    self.hidden = YES;

}

@end
