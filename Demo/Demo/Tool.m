//
//  Tool.m
//  Demo
//
//  Created by DanyChen on 15/12/15.
//  Copyright © 2015 DanyChen. All rights reserved.
//

#import "Tool.h"
#import <objc/runtime.h>

@interface ProductDetails : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *color;
@property (nonatomic, assign) int quantity;

@end

@implementation ProductDetails



@end


@implementation Tool

+ (void)test {
    ProductDetails *details = [[ProductDetails alloc] init];
    details.name = @"Soap1";
    details.color = @"Red";
    details.quantity = 4;
    [details setValue:@"color" forKey:@"color"];
    NSDictionary *dict = [Tool dictionaryWithPropertiesOfObject: details];
    NSLog(@"%@", dict);
    
    //Add this utility method in your class.
    

}

+ (NSDictionary *) dictionaryWithPropertiesOfObject:(id)obj
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    unsigned count;
    objc_property_t *properties = class_copyPropertyList([obj class], &count);
    
    for (int i = 0; i < count; i++) {
        NSString *key = [NSString stringWithUTF8String:property_getName(properties[i])];
        [dict setObject:[obj valueForKey:key] forKey:key];
    }
    
    free(properties);
    
    return [NSDictionary dictionaryWithDictionary:dict];
}


@end
