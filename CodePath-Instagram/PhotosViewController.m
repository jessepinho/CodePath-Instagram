//
//  ViewController.m
//  CodePath-Instagram
//
//  Created by Jesse Pinho on 10/22/15.
//  Copyright © 2015 Jesse Pinho. All rights reserved.
//

#import "PhotosViewController.h"

@interface PhotosViewController ()
@property NSArray* photos;

@end

@implementation PhotosViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *urlString = @"https://api.instagram.com/v1/media/popular?client_id=6e0de7ee68c94e08a3448ccbe6c9d367";
    
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    
    NSURLSession *session =
    [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]
                                  delegate:nil
                             delegateQueue:[NSOperationQueue mainQueue]];
    
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                            completionHandler:^(NSData * _Nullable data,
                                                                NSURLResponse * _Nullable response,
                                                                NSError * _Nullable error) {
                                                if (!error) {
                                                    NSError *jsonError = nil;
                                                    NSDictionary *responseDictionary =
                                                    [NSJSONSerialization JSONObjectWithData:data
                                                                                    options:kNilOptions
                                                                                      error:&jsonError];
                                                    NSLog(@"Response: %@", responseDictionary[@"data"]);
                                                    self.photos = responseDictionary[@"data"];
                                                } else {
                                                    NSLog(@"An error occurred: %@", error.description);
                                                }
                                            }];
    [task resume];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
