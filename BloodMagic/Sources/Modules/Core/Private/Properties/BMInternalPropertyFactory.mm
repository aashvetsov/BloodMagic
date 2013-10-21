//
// Created by Alex Denisov on 20.07.13.
// Copyright (c) 2013 railsware. All rights reserved.
//

#include <objc/runtime.h>

#import "BMInternalPropertyFactory.h"
#import "BMInternalProperty.h"
#import "BMCompsiteProperty.h"
#import "BMPrimitiveCharProperty.h"
#import "BMPrimitiveUnsignedCharProperty.h"
#import "BMPrimitiveShortProperty.h"
#import "BMPrimitiveUnsignedShortProperty.h"
#import "BMPrimitiveIntProperty.h"
#import "BMPrimitiveUnsignedIntProperty.h"
#import "BMPrimitiveLongProperty.h"
#import "BMPrimitiveUnsignedLongProperty.h"
#import "BMPrimitiveLongLongProperty.h"
#import "BMPrimitiveUnsignedLongLongProperty.h"
#import "BMPrimitiveFloatProperty.h"
#import "BMPrimitiveDoubleProperty.h"

@implementation BMInternalPropertyFactory

+ (BMInternalProperty *)newInternalPropertyFromType:(const char *)type
{
    if (type[0] == '@') {
        return [self compositeProperty:type];
    }
    return [self primitivePropertyFromType:type];
}

+ (BMInternalProperty *)compositeProperty:(const char *)type
{
    std::string className(type);
    if (className.length() > 3) {
        className = className.substr(2, className.length() - 3);
    }
    
    if (className == "@") {
        className = "NSObject";
    }

    BMCompositeProperty *compositeProperty = new BMCompositeProperty;
    compositeProperty->setPropertyClassName(className);
    return compositeProperty;
}

+ (BMInternalProperty *)primitivePropertyFromType:(const char *)type
{
    BMInternalProperty *property = NULL;
    switch (type[0]) {
        case _C_CHR:{
            property = new BMPrimitiveCharProperty;
        } break;
        case _C_UCHR:{
            property = new BMPrimitiveUnsignedCharProperty;
        } break;
        case _C_SHT:{
            property = new BMPrimitiveShortProperty;
        } break;
        case _C_USHT:{
            return new BMPrimitiveUnsignedShortProperty;
        } break;
        case _C_INT:{
            property = new BMPrimitiveIntProperty;
        } break;
        case _C_UINT:{
            property = new BMPrimitiveUnsignedIntProperty;
        } break;
        case _C_LNG:{
            property = new BMPrimitiveLongProperty;
        } break;
        case _C_ULNG:{
            property = new BMPrimitiveUnsignedLongProperty;
        } break;
        case _C_LNG_LNG:{
            property = new BMPrimitiveLongLongProperty;
        } break;
        case _C_ULNG_LNG:{
            property = new BMPrimitiveUnsignedLongLongProperty;
        } break;
        case _C_FLT:{
            property = new BMPrimitiveFloatProperty;
        } break;
        case _C_DBL:{
            property = new BMPrimitiveDoubleProperty;
        } break;
        default:{
//            NSLog(@"Unknown property type '%s", type);
        };
    };
    if (property != NULL) {
        property->setPropertyClassName("NSNumber");
    }

    return property;
}

@end