//
//  PDFRenderer.m
//  ProjectCrystalBlueOSX
//
//  Created by josh on 3/30/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import "PDFRenderer.h"
#import <Quartz/Quartz.h>

@implementation PDFRenderer


+(void)printPDF:(NSURL *)fileURL
{
    // Create the print settings.
    NSPrintInfo *printInfo = [NSPrintInfo sharedPrintInfo];
    [printInfo setTopMargin:0.0];
    [printInfo setBottomMargin:0.0];
    [printInfo setLeftMargin:0.0];
    [printInfo setRightMargin:0.0];
    [printInfo setHorizontalPagination:NSFitPagination];
    [printInfo setVerticalPagination:NSFitPagination];
    
    // Create the document reference.
    PDFDocument *pdfDocument = [[PDFDocument alloc] initWithURL:fileURL];
    
    // Invoke private method.
    // NOTE: Use NSInvocation because one argument is a BOOL type. Alternately, you could declare the method in a category and just call it.
    BOOL autoRotate = YES;
    NSMethodSignature *signature = [PDFDocument instanceMethodSignatureForSelector:@selector(getPrintOperationForPrintInfo:autoRotate:)];
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
    [invocation setSelector:@selector(getPrintOperationForPrintInfo:autoRotate:)];
    [invocation setArgument:&printInfo atIndex:2];
    [invocation setArgument:&autoRotate atIndex:3];
    [invocation invokeWithTarget:pdfDocument];
    
    // Grab the returned print operation.
    NSPrintOperation *op = nil;
    [invocation getReturnValue:&op];
    
    // Run the print operation without showing any dialogs.
    [op setShowsPrintPanel:NO];
    [op setShowsProgressPanel:NO];
    [op runOperation];
}

+(void) drawQR:(CGContextRef)ctx :(CGRect)pageRect :(NSString*)key :(CGFloat)x :(CGFloat)y :(CGFloat)qrWidth
{
    y=pageRect.size.height-y;
    CGContextSaveGState(ctx);
    
    struct bitmapData bitmap = [GenerateQRCode getQRBitmap:key];
    CGFloat pix_dist = qrWidth/(CGFloat)bitmap.width;
    //while(bitmap.width*pix_dist<=qr_width)
    //    pix_dist++;
    //pix_dist-=1;
    /*CGDataProviderRef data = CGDataProviderCreateWithData(NULL, bitmap.data, bitmap.length, NULL);
    CGImageRef image = CGImageCreateWithPNGDataProvider(data, NULL, false, kCGRenderingIntentDefault);
    CGDataProviderRelease(data);*/
    
    CGContextSetFillColorWithColor(ctx, CGColorCreateGenericRGB(0, 0, 0, 1));
    CGContextConcatCTM(ctx, CGAffineTransformIdentity);
    //CGContextFillRect(ctx, CGRectMake(100, 100, 100, 100));
    for(int i=0; i<bitmap.width; i++)
    {
        for(int j=0; j<bitmap.width; j++)
        {
            if(bitmap.data[i*bitmap.width+j]==0x00)
            {
                CGRect rect;
                if(bitmap.data[i*bitmap.width+j]==0x00)
                {
                    
                    if(i>0 && bitmap.data[(i-1)*bitmap.width+j]==0x00)
                    {
                        if(j>0 && bitmap.data[(i*bitmap.width+j-1)==0x00])
                            rect=CGRectMake(x+i*pix_dist, y+j*pix_dist, pix_dist*(CGFloat)-1.05, pix_dist*(CGFloat)-1.1);
                        else
                            rect=CGRectMake(x+i*pix_dist, y+j*pix_dist, pix_dist*(CGFloat)-1.05, -pix_dist);
                    }
                    else if(j>0 && bitmap.data[i*bitmap.width+j-1]==0x00)
                    {
                        rect=CGRectMake(x+i*pix_dist, y+j*pix_dist, -pix_dist, pix_dist*(CGFloat)-1.05);
                    }
                    else
                    {
                        rect=CGRectMake(x+i*pix_dist, y+j*pix_dist, -pix_dist, -pix_dist);
                    }
                }
                CGContextFillRect(ctx, rect);
            }
        }
    }
    
    CGContextRestoreGState(ctx);
    
}

+(void) drawText:(CGContextRef)ctx :(CGRect)pageRect :(NSString*)textToDraw :(CGFloat)x :(CGFloat)y
{
    CGContextSaveGState(ctx);
    
    NSMutableAttributedString* string = [[NSMutableAttributedString alloc] initWithString:textToDraw];
    
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)string);
    
    
    CGContextSetTextMatrix(ctx, CGAffineTransformIdentity);
    

    CGFloat xoffset=0;
    CGFloat yoffset=0;
    if(x>pageRect.size.width/2)
        xoffset=pageRect.size.width/2;
    if(y>pageRect.size.height/2)
        yoffset=pageRect.size.height/2;
    
    CGMutablePathRef framePath = CGPathCreateMutable();
    CGPathAddRect(framePath, NULL, CGRectInset(pageRect, x-xoffset, y-yoffset));
    
    CTFrameRef frameRef = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), framePath, NULL);
    CGPathRelease(framePath);
    
    // Core Text draws from the bottom-left corner up, so flip the current transform
     //CGContextTranslateCTM(pdfContext, 0, pageRect.size.height);
    if(xoffset>0)
        CGContextTranslateCTM(ctx, xoffset, 0);
    if(yoffset>0)
        CGContextTranslateCTM(ctx, 0, -yoffset);
    // CGContextScaleCTM(pdfContext, 1.0, -1.0);

    // Draw the frame
    CTFrameDraw(frameRef, ctx);
    
    CFRelease(frameRef);
    CFRelease(framesetter);
    
    CGContextRestoreGState(ctx);

}

+(void)drawPDF:(NSString*)fileName
{
    CGContextRef pdfContext;
    NSArray *dirs = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documents = [dirs objectAtIndex:0];
    NSString *pdfPath = [documents stringByAppendingString:@"/qrcodesfrompcb/test.pdf"];
    NSURL *pdfUrl = [NSURL fileURLWithPath:pdfPath];

    CFMutableDictionaryRef myDictionary = CFDictionaryCreateMutable(NULL, 0, &kCFTypeDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);
    CFDictionarySetValue(myDictionary, kCGPDFContextTitle, CFSTR("QR Codes"));
    CFDictionarySetValue(myDictionary, kCGPDFContextCreator, CFSTR("Project Crystal Blue"));
    CGRect pageRect = CGRectMake(0, 0, 595.44, 841.68);
    pdfContext = CGPDFContextCreateWithURL ((CFURLRef)pdfUrl, NULL, myDictionary);
    CFRelease(myDictionary);
    
    CGContextBeginPage (pdfContext, &pageRect);
    
    CGContextSetShouldAntialias(pdfContext, true);
    
    [self drawText:pdfContext :pageRect :@"test" :100 :150];
    [self drawQR:pdfContext :pageRect :@"test" :100 :100 :25];
    
    [self drawText:pdfContext :pageRect :@"test" :200 :150];
    [self drawQR:pdfContext :pageRect :@"test" :200 :100 :35];
    
    [self drawText:pdfContext :pageRect :@"test" :300 :150];
    [self drawQR:pdfContext :pageRect :@"test" :300 :100 :45];
    
    [self drawText:pdfContext :pageRect :@"test" :400 :150];
    [self drawQR:pdfContext :pageRect :@"test" :400 :100 :65];
    
    [self drawText:pdfContext :pageRect :@"test" :500 :150];
    [self drawQR:pdfContext :pageRect :@"test" :500 :100 :75];
    
    [self drawText:pdfContext :pageRect :@"test" :600 :150];
    [self drawQR:pdfContext :pageRect :@"test" :600 :100 :85];
    
    CGContextEndPage (pdfContext);
    CGContextRelease (pdfContext);
    [self printPDF:pdfUrl];
}

@end
