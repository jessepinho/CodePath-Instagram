//
//  ViewController.m
//  CodePath-Instagram
//
//  Created by Jesse Pinho on 10/22/15.
//  Copyright © 2015 Jesse Pinho. All rights reserved.
//

#import "PhotosViewController.h"
#import <UIImageView+AFNetworking.h>
#import "PhotoCell.h"
#import "PhotoDetailsViewController.h"

@interface PhotosViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *photoTable;
@property NSArray* photos;

@end

@implementation PhotosViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.photoTable.dataSource = self;
    self.photoTable.delegate = self;
    [self loadPhotos];
}

- (void)loadPhotos {
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
                                                    self.photos = responseDictionary[@"data"];
                                                    [self.photoTable reloadData];
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PhotoCell *cell = [self.photoTable dequeueReusableCellWithIdentifier:@"photoCell"];
    NSURL *url = [NSURL URLWithString:self.photos[indexPath.row][@"images"][@"low_resolution"][@"url"]];
    [cell.photoView setImageWithURL:url];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.photos.count;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    PhotoDetailsViewController *detailsView = [segue destinationViewController];
    NSIndexPath *indexPath = [self.photoTable indexPathForCell:sender];
    detailsView.url = self.photos[indexPath.row][@"images"][@"standard_resolution"][@"url"];
}

@end
