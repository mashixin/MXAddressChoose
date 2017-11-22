//
//  ViewController.m
//  MXAddressChooseDemo
//
//  Created by xin on 2017/11/21.
//  Copyright © 2017年 mashixin. All rights reserved.
//

#import "ViewController.h"
#import "MXAddressChooseView.h"

#define KSCREENHEIGHT   CGRectGetHeight([[UIScreen mainScreen] bounds])
#define KSCREENWIDTH    CGRectGetWidth([[UIScreen mainScreen] bounds])

@interface ViewController ()<AddressChooseViewDelegate>
//地址选择View
@property(nonatomic,strong)MXAddressChooseView *addressChooseView;
//地址选择Button
@property(nonatomic,strong)UIButton *addressButton;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //创建添加地址选择按钮
    [self.view addSubview:self.addressButton];
}

-(UIButton *)addressButton{
    if (!_addressButton) {
        _addressButton=[UIButton buttonWithType:UIButtonTypeCustom];
        _addressButton.frame=CGRectMake(30, 150, KSCREENWIDTH-60, 50);
        _addressButton.layer.borderWidth=1;
        _addressButton.layer.borderColor=[[UIColor lightGrayColor] CGColor];
        _addressButton.titleLabel.font=[UIFont systemFontOfSize:16];
        [_addressButton setTitle:@"点击选择地址" forState:UIControlStateNormal];
        [_addressButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [_addressButton addTarget:self action:@selector(clickAddressButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addressButton;
}

//点击地址选择按钮
-(void)clickAddressButton{
    [self.view addSubview:self.addressChooseView];
}

-(MXAddressChooseView *)addressChooseView{
    if (!_addressChooseView) {
        _addressChooseView=[[MXAddressChooseView alloc] initWithFrame:CGRectMake(0, 0, KSCREENWIDTH, KSCREENHEIGHT)];
        _addressChooseView.delegate=self;
    }
    return _addressChooseView;
}

#pragma mark - AddressChooseViewDelegate 选择结果,省市区
-(void)chooseAddressProvince:(NSString *)province city:(NSString *)city district:(NSString *)district{
    NSString *addressString=[NSString stringWithFormat:@"%@-%@-%@",province,city,district];
    [_addressButton setTitle:addressString forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
