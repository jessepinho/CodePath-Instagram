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
@property NSMutableArray* photos;
@property (nonatomic, strong) UIRefreshControl *refreshControl;

@end

@implementation PhotosViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.photoTable.dataSource = self;
    self.photoTable.delegate = self;
    self.photos = [[NSMutableArray alloc] init];
    [self loadPhotos];
    [self setUpRefreshControl];
}

- (void)setUpRefreshControl {
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(loadPhotos) forControlEvents:UIControlEventValueChanged];
    [self.photoTable insertSubview:self.refreshControl atIndex:0];
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
                                                [self.refreshControl endRefreshing];
                                                if (!error) {
                                                    NSError *jsonError = nil;
                                                    NSDictionary *responseDictionary =
                                                    [NSJSONSerialization JSONObjectWithData:data
                                                                                    options:kNilOptions
                                                                                      error:&jsonError];
                                                    NSArray *newPhotos = responseDictionary[@"data"];
                                                    [self.photos addObjectsFromArray:newPhotos];
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
    if ([self isLastPhoto:indexPath]) {
        [self triggerInfiniteScroll];
    }
    PhotoCell *cell = [self.photoTable dequeueReusableCellWithIdentifier:@"photoCell"];
    NSURL *url = [NSURL URLWithString:self.photos[indexPath.section][@"images"][@"low_resolution"][@"url"]];
    [cell.photoView setImageWithURL:url];
    return cell;
}

- (BOOL)isLastPhoto:(NSIndexPath *)indexPath {
    return indexPath.section == self.photos.count - 1;
}

- (void)triggerInfiniteScroll {
    [self loadPhotos];
    
    UIView *tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
    UIActivityIndicatorView *loadingView =
    [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [loadingView startAnimating];
    loadingView.center = tableFooterView.center;
    [tableFooterView addSubview:loadingView];
    self.photoTable.tableFooterView = tableFooterView;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
    [headerView setBackgroundColor:[UIColor colorWithWhite:1.0 alpha:0.9]];
    
    UIImageView *profileView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 30, 30)];
    [profileView setClipsToBounds:YES];
    profileView.layer.cornerRadius = 15;
    profileView.layer.borderColor = [UIColor colorWithWhite:0.7 alpha:0.8].CGColor;
    profileView.layer.borderWidth = 1;
    
    // Use the section number to get the right URL
    NSString *profileImageUrl = self.photos[section][@"user"][@"profile_picture"];
    [profileView setImageWithURL:[NSURL URLWithString:profileImageUrl]];
    
    [headerView addSubview:profileView];
    
    // Add a UILabel for the username here
    
    return headerView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return self.photos.count;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    PhotoDetailsViewController *detailsView = [segue destinationViewController];
    NSIndexPath *indexPath = [self.photoTable indexPathForCell:sender];
    detailsView.url = self.photos[indexPath.section][@"images"][@"standard_resolution"][@"url"];
}

@end
