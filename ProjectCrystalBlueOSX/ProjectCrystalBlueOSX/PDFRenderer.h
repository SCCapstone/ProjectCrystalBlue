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
#import <Quartz/Quartz.h>

@interface PDFRenderer : NSObject

+(void)printQRWithLibraryObjects:(NSArray*)libraryObjects WithWindow:(NSWindow *)window;

@end

@interface PDFDocument (CustomPDFDocument)

- (NSPrintOperation *)getPrintOperationForPrintInfo:(NSPrintInfo *)printInfo autoRotate:(BOOL)doRotate;

@end
