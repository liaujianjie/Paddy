//
//  DatePickerPopupViewController.m
//  Paddy
//
//  Created by Jian Jie on 26/7/15.
//  Copyright (c) 2015 Liau Jian Jie. All rights reserved.
//

#import "DatePickerPopupViewController.h"

@interface DatePickerPopupViewController ()
{
    NSDictionary *quickDateOptions;
}

@end

@implementation DatePickerPopupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSInteger numberOfDaysInCurrentMonth = [[NSCalendar currentCalendar] rangeOfUnit:NSCalendarUnitDay
                                                                              inUnit:NSCalendarUnitMonth
                                                                             forDate:[[NSCalendar currentCalendar] dateFromComponents:[NSDateComponents new]]].length;
    
    quickDateOptions = @{@"5 mins":  [NSNumber numberWithInteger:60*5],
                         @"10 mins": [NSNumber numberWithInteger:60*5],
                         @"15 mins": [NSNumber numberWithInteger:60*5],
                         @"30 mins": [NSNumber numberWithInteger:60*30],
                         
                         @"1 hour":  [NSNumber numberWithInteger:60*60*1],
                         @"2 hours": [NSNumber numberWithInteger:60*60*2],
                         @"4 hours": [NSNumber numberWithInteger:60*60*4],
                         @"6 hours": [NSNumber numberWithInteger:60*60*4],
                         
                         @"1 day":   [NSNumber numberWithInteger:60*60*24*1],
                         @"2 days":  [NSNumber numberWithInteger:60*60*24*2],
                         @"1 week":  [NSNumber numberWithInteger:60*60*24*7],
                         @"1 month": [NSNumber numberWithInteger:60*60*24*numberOfDaysInCurrentMonth]};
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UICollectionView Datasource

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CELLIDENTIFIER = @"QuickDateOptionCell";
    QuickDateOptionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CELLIDENTIFIER forIndexPath:indexPath];
    
    cell.titleLabel.text = quickDateOptions.allKeys[indexPath.row];
    
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return quickDateOptions.count;
}

@end
