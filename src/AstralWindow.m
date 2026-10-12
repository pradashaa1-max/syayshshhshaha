#import <UIKit/UIKit.h>
@interface AstralWindow : UIWindow @end
@implementation AstralWindow
- (void)makeKeyAndVisible {
    [super makeKeyAndVisible];
    self.windowLevel = UIWindowLevelAlert + 1.0;
    self.backgroundColor = [UIColor clearColor];
}
@end
