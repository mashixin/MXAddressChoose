//
//  MXAddressChooseView.m
//  MXAddressChooseDemo
//
//  Created by xin on 2017/11/21.
//  Copyright © 2017年 mashixin. All rights reserved.
//

#import "MXAddressChooseView.h"

#define PICKER_HEIGHT 216
#define GETX(VIEW) ((VIEW).frame.origin.x)
#define GETY(VIEW) ((VIEW).frame.origin.y)
#define GETWIDTH(VIEW)  ((VIEW).frame.size.width)
#define GETHEIGHT(VIEW) ((VIEW).frame.size.height)

@implementation MXAddressChooseView
{
    NSInteger _provinceIndex;   // 省份选择 位置
    NSInteger _cityIndex;       // 市选择 位置
    NSInteger _districtIndex;   // 区选择 位置
}

- (instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
        self.userInteractionEnabled = YES;
        
        //初始化选择位置
        _provinceIndex = _cityIndex = _districtIndex = 0;
        //创建内容
        [self creatUI];
    }
    return self;
}

-(void)creatUI{
    //添加picker
    [self addSubview:self.pickerView];
    [self resetPickerSelectRow];//重置选择内容
    
    //按钮背景
    UIView *buttonBgView = [[UIView alloc] initWithFrame:CGRectMake(0,GETHEIGHT(self)-PICKER_HEIGHT-35,GETWIDTH(self),35)];
    buttonBgView.backgroundColor = [UIColor whiteColor];
    buttonBgView.userInteractionEnabled=YES;
    [self addSubview:buttonBgView];
    
    //取消按钮
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame = CGRectMake(10, 5, 68, 30);
    cancelBtn.layer.cornerRadius = 4;
    cancelBtn.layer.masksToBounds=YES;
    [cancelBtn setBackgroundColor:[UIColor lightGrayColor]];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [cancelBtn addTarget:self action:@selector(clickCancelButton) forControlEvents:UIControlEventTouchUpInside];
    [buttonBgView addSubview:cancelBtn];
    
    //确定按钮
    UIButton *retainBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    retainBtn.frame = CGRectMake(GETWIDTH(self)-GETX(cancelBtn)-GETWIDTH(cancelBtn),
                                 GETY(cancelBtn),
                                 GETWIDTH(cancelBtn),
                                 GETHEIGHT(cancelBtn));
    retainBtn.layer.cornerRadius = 4;
    retainBtn.layer.masksToBounds=YES;
    [retainBtn setBackgroundColor:[UIColor redColor]];
    [retainBtn setTitle:@"确认" forState:UIControlStateNormal];
    retainBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [retainBtn addTarget:self action:@selector(clickRetainButton) forControlEvents:UIControlEventTouchUpInside];
    [buttonBgView addSubview:retainBtn];
    
}

#pragma mark - 取消&确定
//点击取消
-(void)clickCancelButton{
    [self removeFromSuperview];
}

//点击确定
-(void)clickRetainButton{
    // 省市区地址
    NSString *province=self.addressDataArray[_provinceIndex][@"province"];
    NSString *city=self.addressDataArray[_provinceIndex][@"citys"][_cityIndex][@"city"];
    NSString *district=self.addressDataArray[_provinceIndex][@"citys"][_cityIndex][@"districts"][_districtIndex];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(chooseAddressProvince:city:district:)]) {
        [self.delegate chooseAddressProvince:province city:city district:district];
    }
    [self removeFromSuperview];
}

#pragma mark - PickerView Delegate
//分区数
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}

//每个分区行数
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if(component == 0){
        return self.addressDataArray.count;
    }
    else if (component == 1){
        return [self.addressDataArray[_provinceIndex][@"citys"] count];
    }
    else{
        return [self.addressDataArray[_provinceIndex][@"citys"][_cityIndex][@"districts"] count];
    }
}

//内容展示View
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(nullable UIView *)view{
    
    if (!view) {
        UILabel *titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, GETWIDTH(self)/3, 40)];
        titleLabel.textAlignment=NSTextAlignmentCenter;
        titleLabel.font=[UIFont systemFontOfSize:15];
        titleLabel.backgroundColor=[UIColor clearColor];
        view=titleLabel;
    }
    
    if(component == 0){
        [(UILabel *)view setText:self.addressDataArray[row][@"province"]];
    }
    else if (component == 1){
        [(UILabel *)view setText:self.addressDataArray[_provinceIndex][@"citys"][row][@"city"]];
    }
    else{
        [(UILabel *)view setText:self.addressDataArray[_provinceIndex][@"citys"][_cityIndex][@"districts"][row]];
    }
    
    return view;
}

// 滑动或点击选择，确认pickerView选中结果
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if(component == 0){
        _provinceIndex = row;
        _cityIndex = 0;
        _districtIndex = 0;
        
        [self.pickerView reloadComponent:1];
        [self.pickerView reloadComponent:2];
    }
    else if (component == 1){
        _cityIndex = row;
        _districtIndex = 0;
        
        [self.pickerView reloadComponent:2];
    }
    else{
        _districtIndex = row;
    }
    
    //刷新当前选中项
    [self resetPickerSelectRow];
}

#pragma mark - 懒加载
//地址数据
-(NSMutableArray *)addressDataArray{
    if (!_addressDataArray) {
        NSString * path = [[NSBundle mainBundle] pathForResource:@"Address" ofType:@"plist"];
        _addressDataArray = [[NSMutableArray alloc] initWithContentsOfFile:path];
    }
    return _addressDataArray;
}

-(UIPickerView *)pickerView{
    if(!_pickerView){
        _pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, GETHEIGHT(self)-PICKER_HEIGHT, GETWIDTH(self), PICKER_HEIGHT)];
        _pickerView.dataSource = self;
        _pickerView.delegate = self;
        _pickerView.showsSelectionIndicator = YES;
        _pickerView.backgroundColor = [UIColor whiteColor];
    }
    return _pickerView;
}

//重置刷新选择项
-(void)resetPickerSelectRow{
    [self.pickerView selectRow:_provinceIndex inComponent:0 animated:YES];
    [self.pickerView selectRow:_cityIndex inComponent:1 animated:YES];
    [self.pickerView selectRow:_districtIndex inComponent:2 animated:YES];
}
@end
