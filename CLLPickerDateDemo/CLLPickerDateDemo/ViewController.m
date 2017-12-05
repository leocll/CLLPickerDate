//
//  ViewController.m
//  CLLPickerDateDemo
//
//  Created by leocll on 2017/12/5.
//  Copyright © 2017年 leocll. All rights reserved.
//

#import "ViewController.h"
#import "CLLPickerDate.h"

@interface ViewController ()
/**date*/
@property (nonatomic, strong) NSDate *date;
/**时间格式化*/
@property (nonatomic, strong) NSDateFormatter *format;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.format = [[NSDateFormatter alloc] init];
}

- (IBAction)touchesYearMonthBtn:(UIButton *)sender {
    [self showPickerWithMode:CLLPickerDateYear | CLLPickerDateMonth dateFormat:@"yyyy-MM" button:sender];
}

- (IBAction)touchesYearMonthDayBtn:(UIButton *)sender {
    [self showPickerWithMode:CLLPickerDateYear | CLLPickerDateMonth | CLLPickerDateDay dateFormat:@"yyyy-MM-dd" button:sender];
}

- (IBAction)touchesHourMinuteSecondBtn:(UIButton *)sender {
    [self showPickerWithMode:CLLPickerDateHour | CLLPickerDateMinute | CLLPickerDateSecond dateFormat:@"HH:mm:ss" button:sender];
}

- (IBAction)touchesAllComponentsBtn:(UIButton *)sender {
    [self showPickerWithMode:CLLPickerDateYear | CLLPickerDateMonth | CLLPickerDateDay | CLLPickerDateHour | CLLPickerDateMinute | CLLPickerDateSecond dateFormat:@"yyyy-MM-dd HH:mm:ss" button:sender];
}

- (void)showPickerWithMode:(CLLPickerDateOptions)mode dateFormat:(NSString *)format button:(UIButton *)btn {
    __weak typeof(self) weakSelf = self;
    CLLPickerDate *picker = [[CLLPickerDate alloc] init];
    picker.mode = mode;
    picker.date = self.date;
    picker.touchesSureBlock = ^(NSDictionary<CLLPickerDateSelectedKey,NSNumber *> * _Nonnull selectedValueDictionary, NSDate * _Nonnull date) {
        weakSelf.date = date;
        weakSelf.format.dateFormat = format;
        [btn setTitle:[weakSelf.format stringFromDate:date] forState:UIControlStateNormal];
    };
    [picker show];
}

#pragma mark - getter
- (NSDate *)date {
    if (!_date) {
        _date = [NSDate date];
    }
    return _date;
}

@end
