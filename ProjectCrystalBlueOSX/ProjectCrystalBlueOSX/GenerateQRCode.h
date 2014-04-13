//
//  GenerateQRCode.h
//  ProjectCrystalBlueOSX
//
//  Created by josh on 3/2/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Foundation/Foundation.h>
#import "qrencode.h"

@interface GenerateQRCode : NSObject

struct bitmapData{
    int width;
    unsigned char data[3333];
};


/**
 * Generates bitmap data for the input string and returns it
 * in a bitmapData struct
**/
+ (struct bitmapData)getQRBitmap:(NSString *)qrData;


/**
 * Generates a QR Code for the input string and saves it to a bmp
 * file with the name of the input string with ".bmp" appended to it.
 * @param String to encode
 **/
//[GenerateQRCode writeQRCode:self.keyTextField.stringValue];
+ (void)writeQRCode:(NSString *)qrData;

@end
