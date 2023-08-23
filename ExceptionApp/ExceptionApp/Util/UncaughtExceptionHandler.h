//
//  UncaughtExceptionHandler.h
//  ExceptionApp
//
//  Created by JunHo Park on 2023/08/23.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UncaughtExceptionHandler : NSObject <UIAlertViewDelegate>

- (BOOL) installExceptionHandler;
- (void) installUncaughtExceptionHandler;
- (void)tryCatchException:(NSException *)exception information:(NSString *)info;
@end

void InstallUncaughtExceptionHandler(void);

NS_ASSUME_NONNULL_END
