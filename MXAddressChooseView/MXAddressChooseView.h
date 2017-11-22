//
//  MXAddressChooseView.h
//  MXAddressChooseDemo
//
//  Created by xin on 2017/11/21.
//  Copyright © 2017年 mashixin. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol AddressChooseViewDelegate<NSObject>
//选择结果,省市区
-(void)chooseAddressProvince:(NSString *)province city:(NSString *)city district:(NSString *)district;
@end

@interface MXAddressChooseView : UIView<UIPickerViewDataSource, UIPickerViewDelegate>
@property(nonatomic,weak)id<AddressChooseViewDelegate>delegate;
@property(nonatomic,strong)UIPickerView *pickerView;
@property(nonatomic,strong)NSMutableArray *addressDataArray;

@end
