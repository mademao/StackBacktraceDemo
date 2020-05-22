//
//  ViewController.m
//  StackBacktraceDemo
//
//  Created by mademao on 2020/5/22.
//  Copyright © 2020 mademao. All rights reserved.
//

#import "ViewController.h"
#import "manual_mth_stack_backtrace.h"
#import <mth_stack_backtrace.h>
#import <dlfcn.h>
#import "MDMDyldImagesUtil.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    mdm_dyld_load_current_dyld_image_info();
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    manual_mth_stack_backtrace *stack_backtrace1 = manual_mth_malloc_stack_backtrace();
    manual_mth_stack_backtrace_of_thread(mach_thread_self(), stack_backtrace1, 50, 0);
    for (int i = 0; i < stack_backtrace1->frames_size; i++) {
        NSLog(@"%p---%@", (void *)stack_backtrace1->frames[i], [self transformToStackFrameWithFrame:stack_backtrace1->frames[i]]);
    }
    manual_mth_free_stack_backtrace(stack_backtrace1);
    
    NSLog(@"----------------------------------");
    
    mth_stack_backtrace *stack_backtrace2 = mth_malloc_stack_backtrace();
    mth_stack_backtrace_of_thread(mach_thread_self(), stack_backtrace2, 50, 0);
    for (int i = 0; i < stack_backtrace2->frames_size; i++) {
        NSLog(@"%p---%@", (void *)stack_backtrace2->frames[i], [self transformToStackFrameWithFrame:stack_backtrace2->frames[i]]);
    }
    mth_free_stack_backtrace(stack_backtrace2);
}

- (NSString *)transformToStackFrameWithFrame:(uintptr_t)frame
{
    NSString *title = @"";
    
    Dl_info dlinfo = {NULL, NULL, NULL, NULL};
    mdm_dyld_get_DLInfo(mdm_current_dyld_image_info, (vm_address_t)frame, &dlinfo);
    
    if (dlinfo.dli_sname) {
        title = [NSString stringWithFormat:@"%s", dlinfo.dli_sname];
    } else {
        title = [NSString stringWithFormat:@"%s %p %p", dlinfo.dli_fname, dlinfo.dli_fbase, dlinfo.dli_saddr];
    }
    return title;
}

@end
