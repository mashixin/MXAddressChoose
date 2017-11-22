# MXAddressChooseDemo
通过PickerView实现“省、市、区”的选择。

使用方式:
1、将MXAddressChooseView文件夹拖入目标项目

2、#import "MXAddressChooseView.h"，设置代理AddressChooseViewDelegate

3、初始化使用
@property(nonatomic,strong)MXAddressChooseView *addressChooseView;

-(MXAddressChooseView *)addressChooseView{
if (!_addressChooseView) {
_addressChooseView=[[MXAddressChooseView alloc] initWithFrame:CGRectMake(0, 0, KSCREENWIDTH, KSCREENHEIGHT)];
_addressChooseView.delegate=self;
}
return _addressChooseView;
}

4、实现代理方法
// AddressChooseViewDelegate 选择结果,省市区
-(void)chooseAddressProvince:(NSString *)province city:(NSString *)city district:(NSString *)district{
NSString *addressString=[NSString stringWithFormat:@"%@-%@-%@",province,city,district];
}
