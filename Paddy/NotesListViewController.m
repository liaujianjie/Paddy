//
//  NotesListViewController.m
//  Paddy
//
//  Created by Jian Jie on 22/7/15.
//  Copyright (c) 2015 Liau Jian Jie. All rights reserved.
//

#import "NotesListViewController.h"

@interface NotesListViewController ()

@end

@implementation NotesListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView Datasource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CELLIDENTIFIER = @"NotesCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELLIDENTIFIER];
    
//    if (!cell || cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CELLIDENTIFIER];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.text = indexPath.displayableString;
        cell.detailTextLabel.text = @"detail";
    }
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 25;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0;
}

@end
