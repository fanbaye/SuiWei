//
//  PostViewController.m
//  WeiboTest
//
//  Created by lucas on 5/6/13.
//  Copyright (c) 2013 lucas. All rights reserved.
//

#import "PostViewController.h"
#import "SNNetAccess.h"
#import <AssetsLibrary/AssetsLibrary.h>

@interface PostViewController ()

@end

@implementation PostViewController

{
    UIImage *_photo;
    BOOL _havePhoto;
}

@synthesize delegate = _delegate;
@synthesize imgData = _imgData;
@synthesize fdTakeController = _fdTakeController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
	// Do any additional setup after loading the view.
    _headPhoto.layer.cornerRadius = 23;
    _headPhoto.layer.masksToBounds = YES;
    
    _fdTakeController = [[FDTakeController alloc] init];
    _fdTakeController.delegate = self;
    
    _textView.delegate = self;
    
    UISwipeGestureRecognizer *sgr = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(sgrSlider)];
    sgr.direction = UISwipeGestureRecognizerDirectionDown;
    [self.view addGestureRecognizer:sgr];
    
    _photo = [[UIImage alloc] init];
    
    _havePhoto = NO;
}

- (void)sgrSlider
{
    [self back:nil];
}

- (IBAction)back:(id)sender {
    [_textView resignFirstResponder];
    [_delegate hideEdit];
}

- (IBAction)send:(id)sender {
    SNNetAccess *netAccess = [SNNetAccess sharedNetAccess];

    if (_havePhoto) {
        [netAccess postText:_textView.text AndImage:_photo];
    }else{
        [netAccess postText:_textView.text];
    }
    _havePhoto = NO;
}

- (void)showKeyboard
{
    [_textView becomeFirstResponder];
}

- (void)textViewDidChange:(UITextView *)textView
{
    _remainLetter.text = [NSString stringWithFormat:@"%d", 140-[_textView.text length]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_textView release];
    [_headPhoto release];
    [_delegate release];
    [_imgData release];
    [_remainLetter release];
    [_fdTakeController release];
    [_libraryPhoto release];
    [super dealloc];
}

- (void)takeController:(FDTakeController *)controller gotPhoto:(UIImage *)photo withInfo:(NSDictionary *)info
{
    _photo = photo;
    [_libraryPhoto setImage:_photo];
    _havePhoto = YES;
}

- (IBAction)selectImg:(id)sender {
    [_textView resignFirstResponder];
    [_fdTakeController takePhotoOrChooseFromLibrary];
}
@end
