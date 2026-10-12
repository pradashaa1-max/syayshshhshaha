#import "OverlayView.h"
#import "Memory.h"
#import <objc/runtime.h>

@interface OverlayView ()
@property (nonatomic, strong) UIButton *floatBtn;
@property (nonatomic, strong) UIView *menuContainer;
@property (nonatomic, assign) BOOL menuVisible;
@property (nonatomic, assign) BOOL hideCapture;
@property (nonatomic, assign) BOOL enableESP;
@property (nonatomic, assign) BOOL enableAimbot;
@property (nonatomic, assign) BOOL enableNoRecoil;
@property (nonatomic, assign) BOOL enableWallhack;
@property (nonatomic, assign) BOOL fpsBoost;
@property (nonatomic, strong) CADisplayLink *link;
@property (nonatomic, strong) NSMutableArray *espBoxes;
@end

@implementation OverlayView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.userInteractionEnabled = YES;
        self.multipleTouchEnabled = YES;
        _menuVisible = NO;
        _hideCapture = YES;
        _espBoxes = [NSMutableArray array];
        [self setupFloatingButton];
        [self setupMenu];
        [self applySecureFlag];
        _link = [CADisplayLink displayLinkWithTarget:self selector:@selector(tick)];
        [_link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    }
    return self;
}

- (void)setupFloatingButton {
    CGFloat s = 56.0;
    _floatBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _floatBtn.frame = CGRectMake(20, UIScreen.mainScreen.bounds.size.height * 0.35, s, s);
    _floatBtn.layer.cornerRadius = s / 2.0;
    _floatBtn.clipsToBounds = YES;
    _floatBtn.layer.borderWidth = 2.0;
    _floatBtn.layer.borderColor = [UIColor colorWithRed:0.0 green:0.75 blue:1.0 alpha:1.0].CGColor;
    _floatBtn.backgroundColor = [UIColor colorWithWhite:0.05 alpha:0.85];

    UIImage *avatar = [UIImage imageNamed:@"AstralAvatar"];
    if (!avatar) avatar = [UIImage imageNamed:@"AppIcon"];
    [_floatBtn setImage:avatar forState:UIControlStateNormal];
    _floatBtn.imageView.contentMode = UIViewContentModeScaleAspectFill;

    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(dragFloat:)];
    [_floatBtn addGestureRecognizer:pan];
    [_floatBtn addTarget:self action:@selector(toggleMenu) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_floatBtn];
}

- (void)setupMenu {
    CGFloat w = 280.0, h = 340.0;
    _menuContainer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, w, h)];
    _menuContainer.center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    _menuContainer.backgroundColor = [UIColor colorWithRed:0.04 green:0.06 blue:0.12 alpha:0.92];
    _menuContainer.layer.cornerRadius = 16.0;
    _menuContainer.layer.borderWidth = 1.5;
    _menuContainer.layer.borderColor = [UIColor colorWithRed:0.0 green:0.7 blue:1.0 alpha:0.8].CGColor;
    _menuContainer.hidden = YES;
    _menuContainer.alpha = 0.0;
    _menuContainer.layer.shadowColor = [UIColor cyanColor].CGColor;
    _menuContainer.layer.shadowOpacity = 0.6;
    _menuContainer.layer.shadowRadius = 12.0;

    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 12, w, 28)];
    title.text = @"ASTRAL CHEAT";
    title.textAlignment = NSTextAlignmentCenter;
    title.font = [UIFont boldSystemFontOfSize:18];
    title.textColor = [UIColor colorWithRed:0.2 green:0.85 blue:1.0 alpha:1.0];
    [_menuContainer addSubview:title];

    UILabel *sub = [[UILabel alloc] initWithFrame:CGRectMake(0, 38, w, 18)];
    sub.text = @"StandRise Rework";
    sub.textAlignment = NSTextAlignmentCenter;
    sub.font = [UIFont systemFontOfSize:11];
    sub.textColor = [UIColor colorWithWhite:0.7 alpha:1.0];
    [_menuContainer addSubview:sub];

    NSArray *items = @[
        @[@"ESP",           @"enableESP"],
        @[@"Aimbot",        @"enableAimbot"],
        @[@"Wallhack",      @"enableWallhack"],
        @[@"No Recoil",     @"enableNoRecoil"],
        @[@"FPS Boost",     @"fpsBoost"],
        @[@"Hide Capture",  @"hideCapture"]
    ];
    CGFloat y = 70.0;
    for (NSArray *item in items) {
        UIButton *t = [self makeToggle:item[0] key:item[1] y:y];
        [_menuContainer addSubview:t];
        y += 42.0;
    }
    [self addSubview:_menuContainer];
}

- (UIButton *)makeToggle:(NSString *)name key:(NSString *)key y:(CGFloat)y {
    UIButton *b = [UIButton buttonWithType:UIButtonTypeSystem];
    b.frame = CGRectMake(20, y, 240, 36);
    b.backgroundColor = [UIColor colorWithWhite:0.12 alpha:1.0];
    b.layer.cornerRadius = 8.0;
    [b setTitle:[NSString stringWithFormat:@"  %@  ○", name] forState:UIControlStateNormal];
    [b setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    b.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    b.titleLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightMedium];
    [b addTarget:self action:@selector(toggleFeature:) forControlEvents:UIControlEventTouchUpInside];
    objc_setAssociatedObject(b, "key", key, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return b;
}

- (void)toggleFeature:(UIButton *)sender {
    NSString *key = objc_getAssociatedObject(sender, "key");
    BOOL *flag = NULL;
    if ([key isEqualToString:@"enableESP"]) flag = &_enableESP;
    else if ([key isEqualToString:@"enableAimbot"]) flag = &_enableAimbot;
    else if ([key isEqualToString:@"enableWallhack"]) flag = &_enableWallhack;
    else if ([key isEqualToString:@"enableNoRecoil"]) flag = &_enableNoRecoil;
    else if ([key isEqualToString:@"fpsBoost"]) flag = &_fpsBoost;
    else if ([key isEqualToString:@"hideCapture"]) flag = &_hideCapture;

    if (flag) {
        *flag = !*flag;
        NSString *name = [[sender.titleLabel.text componentsSeparatedByString:@"  "] objectAtIndex:1];
        [sender setTitle:[NSString stringWithFormat:@"  %@  %@", name, *flag ? @"●" : @"○"] forState:UIControlStateNormal];
        sender.backgroundColor = *flag ?
            [UIColor colorWithRed:0.0 green:0.45 blue:0.7 alpha:1.0] :
            [UIColor colorWithWhite:0.12 alpha:1.0];
        if ([key isEqualToString:@"hideCapture"]) [self applySecureFlag];
    }
}

- (void)toggleMenu {
    _menuVisible = !_menuVisible;
    if (_menuVisible) {
        _menuContainer.hidden = NO;
        _menuContainer.transform = CGAffineTransformMakeScale(0.92, 0.92);
        [UIView animateWithDuration:0.22 animations:^{
            self->_menuContainer.alpha = 1.0;
            self->_menuContainer.transform = CGAffineTransformIdentity;
        }];
    } else {
        [UIView animateWithDuration:0.18 animations:^{
            self->_menuContainer.alpha = 0.0;
            self->_menuContainer.transform = CGAffineTransformMakeScale(0.92, 0.92);
        } completion:^(BOOL f){ self->_menuContainer.hidden = YES; }];
    }
}

- (void)dragFloat:(UIPanGestureRecognizer *)g {
    CGPoint t = [g translationInView:self];
    CGPoint c = _floatBtn.center;
    c.x += t.x; c.y += t.y;
    CGFloat r = _floatBtn.bounds.size.width / 2;
    c.x = MAX(r, MIN(self.bounds.size.width - r, c.x));
    c.y = MAX(r + 40, MIN(self.bounds.size.height - r - 20, c.y));
    _floatBtn.center = c;
    [g setTranslation:CGPointZero inView:self];
}

- (void)applySecureFlag {
    [self setSecure:_hideCapture];
    UIWindow *w = self.window;
    if ([w respondsToSelector:@selector(setSecure:)]) {
        [w performSelector:@selector(setSecure:) withObject:@(_hideCapture)];
    }
}

- (void)setSecure:(BOOL)secure {
    SEL sel = NSSelectorFromString(@"_setSecure:");
    if ([self respondsToSelector:sel]) {
        NSMethodSignature *sig = [self methodSignatureForSelector:sel];
        NSInvocation *inv = [NSInvocation invocationWithMethodSignature:sig];
        [inv setSelector:sel];
        [inv setTarget:self];
        [inv setArgument:&secure atIndex:2];
        [inv invoke];
    }
}

- (void)tick {
    if (_hideCapture && UIScreen.mainScreen.isCaptured) {
        self.alpha = 0.0;
        return;
    }
    self.alpha = 1.0;

    if (_enableESP || _enableAimbot || _enableNoRecoil || _enableWallhack) {
        [self processEntities];
    }
    if (_fpsBoost) [self runFPSBoost];
    [self setNeedsDisplay];
}

- (uint64_t)getLocalPlayer {
    uint64_t base = get_il2cpp_base();
    if (!base) return 0;
    uint64_t local = 0;
    return local;
}

- (void)processEntities {
    uint64_t local = [self getLocalPlayer];
    if (!local) return;

    if (_enableNoRecoil) {
        uint64_t weaponry = 0;
        mem_read(local + OFF_PC_WeaponryController, &weaponry, 8);
        if (weaponry) {
            float zero = 0.f;
            mem_write(weaponry + OFF_WC_Float1, &zero, 4);
            mem_write(weaponry + OFF_WC_Float2, &zero, 4);
        }
    }
}

- (void)runESP {}
- (void)runAimbot {}
- (void)runNoRecoil {}
- (void)runWallhack {}
- (void)runFPSBoost {}

- (void)drawRect:(CGRect)rect {
    if (!_enableESP || _espBoxes.count == 0) return;
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(ctx, [UIColor cyanColor].CGColor);
    CGContextSetLineWidth(ctx, 1.5);
    for (NSValue *v in _espBoxes) {
        CGRect box = [v CGRectValue];
        CGContextStrokeRect(ctx, box);
    }
}

@end
