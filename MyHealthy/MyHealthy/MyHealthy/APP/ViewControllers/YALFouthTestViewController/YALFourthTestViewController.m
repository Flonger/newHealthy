// For License please refer to LICENSE file in the root of YALAnimatingTabBarController project

#import "YALFourthTestViewController.h"

#define debug 1

@implementation YALFourthTestViewController

#pragma mark - YALTabBarInteracting

- (void)tabBarViewWillCollapse {
    if (debug == 1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
}

- (void)tabBarViewWillExpand {
    if (debug == 1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
}

- (void)tabBarViewDidCollapsed {
    if (debug == 1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
}

- (void)tabBarViewDidExpanded {
    if (debug == 1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
}


- (void)viewDidLoad{

    NSString *Data = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"212121" ofType:@"txt"]encoding:NSUTF8StringEncoding error:nil];
    
    NSArray * arr1 = [Data componentsSeparatedByString:@"A."];
    NSLog(@"%@",arr1);
    NSMutableArray * A = [NSMutableArray array];
    for (int i = 1; i < arr1.count; i++) {
        NSArray * arr2 = [arr1[i] componentsSeparatedByString:@"B."];
        for (int i = 0; i< arr2.count; i++) {
            if (!(i%2)) {
                [A addObject:arr2[i]];
            }
        }
    }
    
    
    
}













@end
