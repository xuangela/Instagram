//
//  ComposeViewController.m
//  Instagram
//
//  Created by Angela Xu on 7/7/20.
//  Copyright © 2020 Angela Xu. All rights reserved.
//

// TODO: clicking the uiimageview actually presenta an option to choose from camera or cameraroll
// TODO: warning message is content and the user is trying to delete
// TODO: can only post once if click the compose button twice

#import <Parse/Parse.h>
#import "ComposeViewController.h"


@interface ComposeViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *pictureView;
@property (weak, nonatomic) IBOutlet UITextField *captionField;

@property (nonatomic, strong) UIImagePickerController *imagePickerVC;
@property (nonatomic, strong) UIAlertController *emptyComposeAlert;

@end

@implementation ComposeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self cameraSetup];
    [self alertSetup];
}

- (void) cameraSetup {
    self.imagePickerVC = [UIImagePickerController new];
    self.imagePickerVC.delegate = self;
    self.imagePickerVC.allowsEditing = YES;
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        self.imagePickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    else {
        NSLog(@"Camera 🚫 available so we will use photo library instead");
        self.imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
}

- (void) alertSetup {
    self.emptyComposeAlert = [UIAlertController alertControllerWithTitle:@"Missing post components."
           message:@"Please attach an image and fill in the caption."
    preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {}];
    [self.emptyComposeAlert addAction:okAction];
}

- (IBAction)tappedPic:(id)sender {
    NSLog(@"tapped the image view");
   
    [self presentViewController:self.imagePickerVC animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    UIImage *originalImage = info[UIImagePickerControllerOriginalImage];
   // UIImage *editedImage = info[UIImagePickerControllerEditedImage];
    
    CGFloat newWidth = originalImage.size.width / 5;
    CGFloat newHeight = originalImage.size.height / 5;
    
    
    CGSize newSize = CGSizeMake(newWidth,  newHeight);
    UIImage *resizedImage = [self resizeImage:originalImage withSize:newSize];
    [self.pictureView setImage:resizedImage];
    
//    [self.pictureView setImage:[self resizeImage:editedImage withSize:CGSizeMake(1000, 1000)]];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (UIImage *)resizeImage:(UIImage *)image withSize:(CGSize)size {
    UIImageView *resizeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    
    resizeImageView.contentMode = UIViewContentModeScaleAspectFill;
    resizeImageView.image = image;
    
    UIGraphicsBeginImageContext(size);
    [resizeImageView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (IBAction)tapOther:(id)sender {
    [self.view endEditing:YES];
}

- (IBAction)tapDelete:(id)sender {
    [self performSegueWithIdentifier:@"backToHomeSegue" sender:self];
}

- (IBAction)tapCompose:(id)sender {
    if ([self.captionField.text isEqual:@""]) {  // TODO: or if no picture add
           [self presentViewController:self.emptyComposeAlert animated:YES completion:^{  }];
    } else {
        PFObject *myPost = [PFObject objectWithClassName:@"Post"];
        myPost[@"caption"] = self.captionField.text;
        myPost[@"picAspectRatio"] = [NSNumber numberWithDouble:(self.pictureView.image.size.height / self.pictureView.image.size.width)];

        NSData *pictureData = UIImagePNGRepresentation(self.pictureView.image);
        myPost[@"picture"] = [PFFileObject fileObjectWithData:pictureData];
        myPost[@"user"] = PFUser.currentUser;
        
        Post *post =[[Post alloc] initWithPFObject:myPost];
        
        [myPost saveInBackgroundWithBlock:^(BOOL succeeded, NSError * error) {
            if (succeeded) {
                NSLog(@"The message was saved!");
                [self.delegate didPost:post];
                [self performSegueWithIdentifier:@"backToHomeSegue" sender:self];
            } else {
                NSLog(@"Problem saving message: %@", error.localizedDescription);
            }
        }];
        
        
    }
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
