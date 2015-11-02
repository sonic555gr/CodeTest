//
//  ViewController.m
//  CodeTest
//
//  Created by Alkiviadis Papadakis on 29/10/2015.
//  Copyright © 2015 Alkimo Ltd. All rights reserved.
//

#import "ViewController.h"
#import "CTNetworkLibrary.h"
#import "CTResult.h"
#import "CTDetailsViewController.h"
@interface ViewController () <UISearchBarDelegate>
@property (nonatomic, strong) CTNetworkLibrary *networkLibrary;
@property (nonatomic, strong) NSArray *data;
@property (nonatomic, weak) IBOutlet UISearchBar *searchBar;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _networkLibrary = [CTNetworkLibrary sharedLibrary];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - SearchBar Delegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    __weak typeof(self) wself = self;
    [_networkLibrary searchResultsForQuery:searchText completion:^(NSArray *results, NSError *error) {
        if (!error)
        {
            wself.data = results;
            [wself.tableView reloadData];
        }
    }];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}

#pragma  mark - UITableViewController Delegate & DataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"SongCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    CTResult *result = _data[indexPath.row];
    cell.textLabel.text = result.trackName;
    cell.detailTextLabel.text = result.albumName;
    
    cell.imageView.alpha = 0;
    __weak typeof(cell) weakCell = cell;
    [_networkLibrary asyncronousImageWithURL:result.artworkUrl completion:^(UIImage *image, NSError *error) {
        weakCell.imageView.image = image;
        //Some fade in animation to account for the setting of the image with a nice transition.
        [UIView animateWithDuration:0.1 animations:^{
            [weakCell setNeedsLayout];
            weakCell.imageView.alpha = 1.0f;
        }];
    }];

    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _data.count;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [super prepareForSegue:segue sender:sender];
    [self.searchBar resignFirstResponder];
    NSIndexPath *selectedPath = self.tableView.indexPathForSelectedRow;
    CTDetailsViewController *detailsViewController = segue.destinationViewController;
    detailsViewController.result = _data[selectedPath.row];
}



@end
