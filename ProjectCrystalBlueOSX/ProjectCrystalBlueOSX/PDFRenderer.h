//
//  PDFRenderer.h
//  ProjectCrystalBlueOSX
//
//  Created by josh on 3/30/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreText/CoreText.h>
#import "GenerateQRCode.h"

@interface PDFRenderer : NSObject

+(void)drawPDF:(NSString*)fileName;

@end
