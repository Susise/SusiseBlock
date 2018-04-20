//
//  ViewController.m
//  SusiseBlock
//
//  Created by sunqiaoqiao on 2018/4/20.
//  Copyright © 2018年 S. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property ( nonatomic,copy ) void (^block)(void);

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self testMthod];
    
    [self testMthod1];
    
    [self cycletest];
}

- (void)testMthod{
    
    /*
     block 会把 i变量复制为自己私有的const 变量，也就是说 block 会 捕获栈上 变量（或指针），将其复制为自己的私有变量，在进行i= 50 的操作的时候，block 已经将其复制为自己的私有变量，所以这里修改 堆block里面的 i 不会造成任何影响
     */
 
    NSInteger i = 42;
    
    void(^testBlock)(void) = ^{
        NSLog(@"%ld",i);
        
        NSLog(@"no -- __block --- %p",&i);
    };
    
    i = 50;
    
    testBlock();
    
    NSLog(@"no -- __block ---%p",&i);
    
}
- (void)testMthod1{
    
    /*
     i 是一个局部变量，存储在栈区的。给i 加上 __block 修饰符所起的作用就是只要观察到 该变量 被block 所持有，就将该变量在栈中的内存地址放到堆中，此时不管block 外部还是内部，i 的内存地址都是一样的，进而不管block 外部还是内部，都可以修改i 变量的值，所以i
      = 50 以后，在block 里面输出的值就是50了
     */
    
    __block NSInteger i = 42;
    
    void(^testBlock)(void) = ^{
        NSLog(@"__block = %ld",i);
        
        NSLog(@" __block ---%p",&i);
    };
    
    i = 50;
    
    testBlock();
    
    NSLog(@" __block ---%p",&i);
}
- (void)cycletest{
    /*
     self 对block 有一个强引用，而在block 内部又对self进行一次强引用，这样就形成了一个封闭的环，当self 释放，self对block的强引用被取消，但是 block 对self 没有取消，所以会造成 self没有释放，造成内存泄漏
     */
    self.block = ^{
        [self dosomething];
    };
    
    /*
     weakself之后，block 对self的强引用关系就变成了弱引用关系，这样属性所指的对象遭到摧毁的时候，属性值也会被清空，打破了block 捕获的作用域带来的循环引用。
     */
    
    __weak typeof(self) weakself = self;
    self.block = ^{
        [weakself dosomething];
    };
    
    /*
     在这种情况下是不需要考虑循环引用的，因为这里只有block对self进行了一次强引用，属于单向的强引用，没有形成循环引用。
     
     */
    [UIView animateWithDuration:0.5 animations:^{
        [self dosomething];
    }];
    
}
- (void)dosomething{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
