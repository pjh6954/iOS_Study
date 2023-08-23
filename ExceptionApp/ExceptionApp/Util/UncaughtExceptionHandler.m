//
//  UncaughtExceptionHandler.m
//  ExceptionApp
//
//  Created by JunHo Park on 2023/08/23.
//

#import "UncaughtExceptionHandler.h"
#include <libkern/OSAtomic.h>
#include <stdio.h>
#include <execinfo.h>
#include <stdatomic.h>


NSString * const UncaughtExceptionHandlerSignalExceptionName = @"UncaughtExceptionHandlerSignalExceptionName";
NSString * const UncaughtExceptionHandlerSignalKey = @"UncaughtExceptionHandlerSignalKey";
NSString * const UncaughtExceptionHandlerAddressesKey = @"UncaughtExceptionHandlerAddressesKey";

// volatile int32_t UncaughtExceptionCount = 0;
volatile _Atomic int32_t UncaughtExceptionCount = 0;
const int32_t UncaughtExceptionMaximum = 15;

const NSInteger UncaughtExceptionHandlerReportAddressCount = 15;

@implementation UncaughtExceptionHandler

- (void)dealloc {
    NSLog(@"UncaughtExceptionHandler Dealloc");
}

- (BOOL) installExceptionHandler {
    NSLog(@"AppDelegate : installExceptionHandler");
    
    //비정상종료로 인해 저장된 로그가 있는지 확인하여 서버 전송
    if([[[NSUserDefaults standardUserDefaults] objectForKey:@"ExceptionSymbol"] length] > 0) {
        
        NSString * log = [[NSUserDefaults standardUserDefaults] objectForKey:@"ExceptionSymbol"];
        NSLog(@"Symbol~~~ : %@", log);
        
        if([log isKindOfClass:[NSArray class]])
            log = [(NSArray *)log description];
        

        // [[UncaughtExceptionHandler alloc] sendLogToServer];
        
    }
    
    [self performSelector:@selector(installUncaughtExceptionHandler) withObject:nil afterDelay:0];
    
    return YES;
}

- (void) installUncaughtExceptionHandler
{
    InstallUncaughtExceptionHandler();
}

/**
 @brief 로그 trace 정보 (심볼릭된 정보 리턴됨.. 현재 10줄로 설정됨.)
 */
+ (NSArray *)backtrace
{
     void* callstack[128];
     int frames = backtrace(callstack, 128); // execinfo.h
     char **strs = backtrace_symbols(callstack, frames); // execinfo.h

     NSMutableArray *backtrace = [NSMutableArray arrayWithCapacity:frames];
//    int traceCount = (backtrace.count < UncaughtExceptionHandlerSkipAddressCount +
//                      UncaughtExceptionHandlerReportAddressCount) ? backtrace.count : (UncaughtExceptionHandlerSkipAddressCount +
//    UncaughtExceptionHandlerReportAddressCount);
     
    for (int i = 0; i < UncaughtExceptionHandlerReportAddressCount; i++)
     {
         if(frames == i) break;
          [backtrace addObject:[NSString stringWithUTF8String:strs[i]]]; // execinfo.h
     }
    
    NSLog(@"[backtrace] Exception : %@", backtrace); // execinfo.h

     free(strs);
     return backtrace; // execinfo.h
}


/**
 @brief uncaught exception이 발생한 경우 호출됨.
 @param exception 발생한 exception
 */
- (void)handleException:(NSException *)exception
{
    NSLog(@"Exception Desc : %@", exception.description);
    
    NSSetUncaughtExceptionHandler(NULL);
    signal(SIGABRT, SIG_DFL);
    signal(SIGILL, SIG_DFL);
    signal(SIGKILL, SIG_DFL);
    signal(SIGSEGV, SIG_DFL);
    signal(SIGFPE, SIG_DFL);
    signal(SIGBUS, SIG_DFL);
    signal(SIGPIPE, SIG_DFL);
    
    if ([[exception name] isEqual:UncaughtExceptionHandlerSignalExceptionName])
    {
        NSLog(@"Exception Type : %d", [[[exception userInfo] objectForKey:UncaughtExceptionHandlerSignalKey] intValue]);
        kill(getpid(), [[[exception userInfo] objectForKey:UncaughtExceptionHandlerSignalKey] intValue]);
    }
    else
    {
        NSLog(@"Exception Type : %@", exception.name);
        [exception raise];
    }
}

/**
 @brief @try @catch를 통해서 exception이 잡힌경우 호출되는 함수 (바로 서버로 전송함)
 @param exception : try catch에서 잡힌 exception
 */
- (void)tryCatchException:(NSException *)exception information:(NSString *)info {
    
    NSString * stack = @"";
    for( int i=0; i<UncaughtExceptionMaximum; i++)
    {
        if([exception callStackSymbols].count == i) break; //max값보다 심볼스택이 더 짧은경우 중단
        
        stack = [stack stringByAppendingString:[[exception callStackSymbols] objectAtIndex:i]];
        if(i < [exception callStackSymbols].count - 1)
            stack = [stack stringByAppendingString:@"\n"];
    }
    
//    NSString * log = [NSString stringWithFormat:@"Exception Desc: %@ \nException Symbols:\n%@\n", exception.description, stack];
    NSString * log = [NSString stringWithFormat:@"Exception Desc: %@\nException info: %@\nException Symbols:\n%@\n", exception.description, info, stack];

    NSLog(@"Catch Exception !! : %@", log);
    
    NSLocale* locale = [[NSLocale alloc] initWithLocaleIdentifier: @"ko_KR"];
    NSDateFormatter* df = [[NSDateFormatter alloc] init];
    [df setLocale: locale];
    [df setDateFormat: @"yyyyMMddhhmmss"];
    
    [[NSUserDefaults standardUserDefaults] setValue:log forKey:@"ExceptionSymbol"];
    [[NSUserDefaults standardUserDefaults] setValue:exception.name forKey:@"ExceptionType"];
    [[NSUserDefaults standardUserDefaults] setValue:[df stringFromDate:[NSDate date]] forKey:@"ExceptionDate"];
//    [[NSUserDefaults standardUserDefaults] setValue:[Util getAppVer] forKey:@"ExceptionAppVer"];
//    [[NSUserDefaults standardUserDefaults] setValue:[Util getDeviceLanguage] forKey:@"ExceptionLanguage"];
//    [[NSUserDefaults standardUserDefaults] setValue:[Util getOsVersion] forKey:@"ExceptionOSVer"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    
  
//    [self sendLogToServer];
    

    
    

}

@end


#pragma mark -
#pragma mark Uncaught Exception, Signal Handling

// Uncaught Exception 발생시 처리하는 부분
void HandleException(NSException *exception)
{
    NSLog(@"Stack Trace: %@", [exception callStackSymbols]);
    
    // int32_t exceptionCount = OSAtomicIncrement32(&UncaughtExceptionCount); // <libkern/OSAtomic.h> // 'OSAtomicIncrement32' is deprecated: first deprecated in iOS 10.0 - Use atomic_fetch_add_explicit(memory_order_relaxed) from <stdatomic.h> instead
    // Address argument to atomic operation must be a pointer to _Atomic type ('volatile int32_t *' (aka 'volatile int *') invalid)
    int32_t exceptionCount = atomic_fetch_add_explicit(&UncaughtExceptionCount, 1, memory_order_relaxed); // https://stackoverflow.com/questions/53979141/how-to-use-atomic-fetch-add-explicit-to-replace-osatomicincrement32
    
    NSLog(@"exceptionCount: %d", exceptionCount);
    if (exceptionCount > UncaughtExceptionMaximum)
    {
        return;
    }
    
//    NSArray *callStack = [UncaughtExceptionHandler backtrace];
    
    NSArray *callStack = [exception callStackSymbols];
    NSString * stack = @"";
    for( int i=0; i<UncaughtExceptionMaximum; i++)
    {
        if(callStack.count == i) break; //max값보다 심볼스택이 더 짧은경우 중단

        stack = [stack stringByAppendingString:[callStack objectAtIndex:i]];
        if(i < callStack.count - 1)
            stack = [stack stringByAppendingString:@"\n"];
    }
    
    NSString * log = [NSString stringWithFormat:@"Exception Desc: %@ \nException Symbols:\n%@\n", exception.description, stack];
    NSLog(@"HandleException : %@", log);
    
    NSLocale* locale = [[NSLocale alloc] initWithLocaleIdentifier: @"ko_KR"];
    NSDateFormatter* df = [[NSDateFormatter alloc] init];
    [df setLocale: locale];
    [df setDateFormat: @"yyyyMMddhhmmss"];
    
    [[NSUserDefaults standardUserDefaults] setValue:log forKey:@"ExceptionSymbol"];
    [[NSUserDefaults standardUserDefaults] setValue:exception.name forKey:@"ExceptionType"];
    [[NSUserDefaults standardUserDefaults] setValue:[df stringFromDate:[NSDate date]] forKey:@"ExceptionDate"];
//    [[NSUserDefaults standardUserDefaults] setValue:[Util getAppVer] forKey:@"ExceptionAppVer"];
//    [[NSUserDefaults standardUserDefaults] setValue:[Util getDeviceLanguage] forKey:@"ExceptionLanguage"];
//    [[NSUserDefaults standardUserDefaults] setValue:[Util getOsVersion] forKey:@"ExceptionOSVer"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    NSMutableDictionary *userInfo =
        [NSMutableDictionary dictionaryWithDictionary:[exception userInfo]];
    [userInfo
        setObject:callStack
        forKey:UncaughtExceptionHandlerAddressesKey];
    
    [[[UncaughtExceptionHandler alloc] init]
        performSelectorOnMainThread:@selector(handleException:)
        withObject:
            [NSException
                exceptionWithName:[exception name]
                reason:[exception reason]
                userInfo:userInfo]
        waitUntilDone:YES];
    
    
}

// 강제종료 타입에 따라 처리하는 부분
void SignalHandler(int signal)
{
    // int32_t exceptionCount = OSAtomicIncrement32(&UncaughtExceptionCount);
    int32_t exceptionCount = atomic_fetch_add_explicit(&UncaughtExceptionCount, 1, memory_order_relaxed);;
    if (exceptionCount > UncaughtExceptionMaximum)
    {
        return;
    }
    
    NSMutableDictionary *userInfo =
        [NSMutableDictionary
            dictionaryWithObject:[NSNumber numberWithInt:signal]
            forKey:UncaughtExceptionHandlerSignalKey];

    NSArray *callStack = [UncaughtExceptionHandler backtrace];
    
    NSString * stack = @"";
    for( int i=0; i<callStack.count; i++)
    {
        stack = [stack stringByAppendingString:[callStack objectAtIndex:i]];
        if(i < callStack.count - 1)
            stack = [stack stringByAppendingString:@"\n"];
    }
    NSString * log = [NSString stringWithFormat:@"Exception Type: %d \nException Symbols:\n%@\n", signal, callStack];
//    NSString * log = [NSString stringWithFormat:@"Exception Type: %d \nException Symbols: %@", signal, callStack];
    NSLog(@"SignalHandler : %@", log);
    
    NSLocale* locale = [[NSLocale alloc] initWithLocaleIdentifier: @"ko_KR"];
    NSDateFormatter* df = [[NSDateFormatter alloc] init];
    [df setLocale: locale];
    [df setDateFormat: @"yyyyMMddhhmmss"];
    
    [[NSUserDefaults standardUserDefaults] setValue:log forKey:@"ExceptionSymbol"];
    [[NSUserDefaults standardUserDefaults] setValue:[NSString stringWithFormat:@"ExceptionType:%d", signal] forKey:@"ExceptionType"];
    [[NSUserDefaults standardUserDefaults] setValue:[df stringFromDate:[NSDate date]] forKey:@"ExceptionDate"];
//    [[NSUserDefaults standardUserDefaults] setValue:[Util getAppVer] forKey:@"ExceptionAppVer"];
//    [[NSUserDefaults standardUserDefaults] setValue:[Util getDeviceLanguage] forKey:@"ExceptionLanguage"];
//    [[NSUserDefaults standardUserDefaults] setValue:[Util getOsVersion] forKey:@"ExceptionOSVer"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [userInfo
        setObject:callStack
        forKey:UncaughtExceptionHandlerAddressesKey];
//    NSLog(@"Exception userInfo : %@", userInfo);
    
    [[[UncaughtExceptionHandler alloc] init]
        performSelectorOnMainThread:@selector(handleException:)
        withObject:
            [NSException
                exceptionWithName:UncaughtExceptionHandlerSignalExceptionName
                reason:
                    [NSString stringWithFormat:
                        NSLocalizedString(@"Signal %d was raised.", nil),
                        signal]
                userInfo:
                    [NSDictionary
                        dictionaryWithObject:[NSNumber numberWithInt:signal]
                        forKey:UncaughtExceptionHandlerSignalKey]]
        waitUntilDone:YES];
    

}

// Exception 발생 시 처리할 함수들을 정의해주는 부분.
void InstallUncaughtExceptionHandler(void)
{
    // NOTE:- It does not catch any Swift 2 errors (from throw) or Swift runtime errors, so this is not caught: https://stackoverflow.com/questions/25441302/how-should-i-use-nssetuncaughtexceptionhandler-in-swift
    NSSetUncaughtExceptionHandler(&HandleException);
    signal(SIGABRT, SignalHandler);
    signal(SIGILL, SignalHandler);
    signal(SIGKILL, SignalHandler);
    signal(SIGSEGV, SignalHandler);
    signal(SIGFPE, SignalHandler);
    signal(SIGBUS, SignalHandler);
    signal(SIGPIPE, SignalHandler);
}
