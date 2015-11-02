//
//  CTDetailsViewController.m
//  CodeTest
//
//  Created by Alkiviadis Papadakis on 30/10/2015.
//  Copyright © 2015 Alkimo Ltd. All rights reserved.
//

#import "CTDetailsViewController.h"
#import "CTResult.h"
#import "CTNetworkLibrary.h"
@interface CTDetailsViewController ()
@property (nonatomic, weak) IBOutlet UILabel *trackNameLabel;
@property (nonatomic, weak) IBOutlet UILabel *albumNameLabel;
@property (nonatomic, weak) IBOutlet UILabel *artistNameLabel;
@property (nonatomic, weak) IBOutlet UILabel *priceLabel;
@property (nonatomic, weak) IBOutlet UILabel *releaseDateLabel;
@property (nonatomic, weak) IBOutlet UIImageView *artworkImageView;
@property (nonatomic, strong) NSDateFormatter *formatter;
@property (nonatomic, strong) CTNetworkLibrary *library;
@end

@implementation CTDetailsViewController

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        _library = [CTNetworkLibrary sharedLibrary];
        _formatter = [[NSDateFormatter alloc] init];
        _formatter.dateFormat = @"YYYY";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _trackNameLabel.text = _result.trackName;
    _albumNameLabel.text = _result.albumName;
    _artistNameLabel.text = _result.artistName;
    __weak typeof(self) weakSelf = self;
    [_library asyncronousImageWithURL:_result.artworkUrl completion:^(UIImage *image, NSError *error) {
        weakSelf.artworkImageView.image = image;
        weakSelf.artworkImageView.layer.cornerRadius = 50;
        weakSelf.artworkImageView.layer.masksToBounds = YES;
    }];
    _priceLabel.text = [NSString stringWithFormat:@"Price: £%.2f",_result.price];
    _releaseDateLabel.text = [NSString stringWithFormat:@"Release Date: %@",[_formatter stringFromDate:_result.releaseDate]];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setResult:(CTResult *)result
{
    _result = result;
}

/*
    - The detail view should show: the track name, the album name, artist name, the artwork in a circular picture, price and the release date.
 */

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
