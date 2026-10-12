#import <UIKit/UIKit.h>
#import "OverlayView.h"

%hook UIApplication
- (void)setDelegate:(id)delegate {
    %orig;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            UIWindow *key = [UIApplication sharedApplication].keyWindow;
            if (!key) key = [UIApplication sharedApplication].windows.firstObject;
            if (key) {
                OverlayView *ov = [[OverlayView alloc] initWithFrame:key.bounds];
                ov.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
                [key addSubview:ov];
                key.windowLevel = UIWindowLevelAlert + 1.0;
            }
        });
    });
}
%end
