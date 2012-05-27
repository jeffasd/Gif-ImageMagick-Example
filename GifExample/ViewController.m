//
//  ViewController.m
//  GifExample
//
//  Created by Zach Orr on 5/26/12.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (IBAction)createGif {
    NSMutableArray *frames = [[NSMutableArray alloc] init];
    int x = 1;
    UIImage *imagezor = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%d", x] ofType:@"png"]];
    NSLog(@"%@", imagezor);
    while(imagezor != NULL) {
        [frames addObject:imagezor];
        x++;
        imagezor = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%d", x] ofType:@"png"]];
        NSLog(@"%@", imagezor);
    }
    MagickWand *mw = NewMagickWand();
    MagickSetFormat(mw, "gif");
    NSLog(@"Going into ImageMagick stuff");
    for (UIImage *img in frames) {
        MagickWand *localWand = NewMagickWand();
        NSData *dataObj = UIImagePNGRepresentation(img);
        MagickReadImageBlob(localWand, [dataObj bytes], [dataObj length]);
        MagickSetImageDelay(localWand, 10);
        MagickAddImage(mw, localWand);
        DestroyMagickWand(localWand);
    }
    size_t my_size;
    NSLog(@"This is the part that takes forever");
    unsigned char * my_image = MagickGetImagesBlob(mw, &my_size);
    NSData *data = [[NSData alloc] initWithBytes:my_image length:my_size];
    free(my_image);
    DestroyMagickWand(mw);

    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    path = [NSString stringWithFormat:@"%@/animation.gif", path];
    NSLog(@"Going to write to file");
    
    [data writeToFile:path atomically:YES];
    NSLog(@"Wrote to file");
    
    NSURL *urlzor = [NSURL fileURLWithPath:path];
    NSLog(@"%@", urlzor);
    NSLog(@"%@", path);
}

@end
