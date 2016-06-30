//
//  ViewController.m
//  FCNotificationSample
//
//  Created by viziner on 16/6/30.
//  Copyright © 2016年 viziner. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *replyLable;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _replyLable.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"action2"];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refresh) name:UIApplicationWillEnterForegroundNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    _replyLable.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"action2"];

}
- (void)refresh{
    _replyLable.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"action2"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
