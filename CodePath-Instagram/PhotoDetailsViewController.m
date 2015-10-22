//
//  PhotoDetailsViewController.m
//  CodePath-Instagram
//
//  Created by Steve Mitchell on 10/22/15.
//  Copyright © 2015 Jesse Pinho. All rights reserved.
//

#import "PhotoDetailsViewController.h"
#import "UIImageView+AFNetworking.h"

@interface PhotoDetailsViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *photoDetailImageView;

@end

@implementation PhotoDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.photoDetailImageView setImageWithURL:[NSURL URLWithString:self.url]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
