//
//  ViewController.m
//  CallKitTest
//
//  Created by 杜洁鹏 on 05/01/2018.
//  Copyright © 2018 杜洁鹏. All rights reserved.
//

#import "ViewController.h"
#import <CallKit/CallKit.h>

@interface ViewController () <CXProviderDelegate>
@property (nonatomic, strong) CXCallController *callController;
@property (nonatomic, strong) CXProvider *provider;
@property (nonatomic, strong) CXProviderConfiguration *config;
@property (nonatomic, strong) NSUUID *uuid;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self provider];
    self.uuid = [NSUUID UUID];
}

// 模拟呼入
- (IBAction)makeIncomingCallsAction:(UIButton *)sender {
    // 呼入的核心代码就这么点。之后就是要处理CXProviderDelegate的事件。 此处要注意：
    // 打开background models，要勾选voip(xcode9中，已经没有这个选项了，很坑，需要在plist里自己添加。)
    CXCallUpdate *update = [[CXCallUpdate alloc] init];
    update.remoteHandle = [[CXHandle alloc] initWithType:CXHandleTypePhoneNumber value:@"10086"];
    // UUID,标记通话的唯一性。每次有状态更新都要使用uuid生成CXTransaction对象，并更新到CXCallController 对象中。如果没有更新，会导致CallKit认为通话没有结束，显示的ui可能不对。
    [self.provider reportNewIncomingCallWithUUID:self.uuid update:update completion:^(NSError * _Nullable error) {
        NSLog(@"error --- %@",error);
    }];
}

// 模拟呼出
- (IBAction)makingOutgoingCallsAction:(UIButton *)sender {
    
}


- (CXProvider *)provider {
    if (!_provider) {
        // initWithLocalizedName，这个参数只用于显示，是指显示CallKit界面时显示的应用信息，建议填写成App的名称。
        CXProviderConfiguration *configuration = [[CXProviderConfiguration alloc] initWithLocalizedName:@"CallKitTest"];
        configuration.supportsVideo = NO;
        configuration.maximumCallsPerCallGroup = 1;
        configuration.supportedHandleTypes = [NSSet setWithObject:@(CXHandleTypePhoneNumber)];
        _provider = [[CXProvider alloc] initWithConfiguration:configuration];
        [_provider setDelegate:self queue:nil];
    }
    
    return _provider;
}

- (CXCallController *)callController {
    if (!_callController) {
        _callController = [[CXCallController alloc] initWithQueue:dispatch_get_main_queue()];
    }
    
    return _callController;
}

// 这个回调比较奇怪，感觉是provider invalidate后要在这里释放资源，但是实际上，不释放好像也没遇到问题。
- (void)providerDidReset:(CXProvider *)provider {
    
}

- (void)provider:(CXProvider *)provider performStartCallAction:(CXStartCallAction *)action{

}

// user answered this incoming call
- (void)provider:(CXProvider *)provider performAnswerCallAction:(CXAnswerCallAction *)action{

}

// user end this call
- (void)provider:(CXProvider *)provider performEndCallAction:(CXEndCallAction *)action{

}

- (void)provider:(CXProvider *)provider didActivateAudioSession:(AVAudioSession *)audioSession{

}

- (void)provider:(CXProvider *)provider didDeactivateAudioSession:(AVAudioSession *)audioSession{
    
}


@end
