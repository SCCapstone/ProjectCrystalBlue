//
//  GenerateQRCode.m
//  ProjectCrystalBlueOSX
//
//  Created by josh on 3/2/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import "GenerateQRCode.h"

@implementation GenerateQRCode

const int max_size = 10000;

+ (struct bitmapData)getQRBitmap:(NSString *)qrData
{
    QRcode *qrcode;
    const char *string=[qrData cStringUsingEncoding:NSASCIIStringEncoding];
    qrcode = QRcode_encodeString(string, 0, QR_ECLEVEL_H, QR_MODE_8, 1); // case-sensitivy is 5th argument
    unsigned int width = qrcode->width;
    
    //const unsigned int bmp_length=width*width+width;
    
    struct bitmapData bitmap;
    bitmap.width=width;
    
    int k=0;
    for (int i = width-1; i >= 0; --i) {
        for (int j = i*width; j < i*width+width; ++j) {
            NSNumber *number = [[NSNumber alloc] initWithUnsignedChar:qrcode->data[j]];
            if ([number intValue] % 2 == 0) {
                bitmap.data[k] = 0xFF;
            } else {
                bitmap.data[k] = 0x00;
            }
            k++;
        }
    }
    return bitmap;
}

+ (void)writeQRCode:(NSString *)qrData
{
    QRcode *qrcode;
    const char *string=[qrData cStringUsingEncoding:NSASCIIStringEncoding];
    qrcode = QRcode_encodeString(string, 0, QR_ECLEVEL_H, QR_MODE_8, 1); // case-sensitivy is 5th argument
    unsigned int width = qrcode->width;
    
    const unsigned int bmp_length=width*width+width;
    const unsigned int header_length=54;
    const unsigned int file_size=bmp_length+header_length;
    const char bmpHeader[]={
        0x42, 0x4d,                 // ID field ("BM")
        (char)((file_size<<24)>>24), (char)((file_size<<16)>>24), (char)((file_size<<8)>>24), (char)(file_size>>24),     // Size of the BMP file
        0x00, 0x00, 0x00, 0x00,     // App specific (unused)
        0x36, 0x00, 0x00, 0x00,     // Offset where the pixel array can be found (header_length=54 bytes)
        0x28, 0x00, 0x00, 0x00,     // Number of bytes in DIB header (40 bytes)
        (char)((width<<24)>>24), (char)((width<<16)>>24), (char)((width<<8)>>24), (char)(width>>24),     // Width of the bitmap in pixels
        (char)((width<<24)>>24), (char)((width<<16)>>24), (char)((width<<8)>>24), (char)(width>>24),     // Height of the bitmap in pixels
        0x01, 0x00,                 // Number of color planes (1)
        0x18, 0x00,                 // Number of bits per pixel (24 bits)
        0x00, 0x00, 0x00, 0x00,     // BI_RGB, no pixel array compression
        (char)((bmp_length<<24)>>24), (char)((bmp_length<<16)>>24), (char)((bmp_length<<8)>>24), (char)((bmp_length)>>24),     // Size of raw data in pixel array including padding (bmp_length)
        0x13, 0x0b, 0x00, 0x00,     // Horizontal resolution of image (2835 pixels/meter)
        0x13, 0x0b, 0x00, 0x00,     // Vertical resolution of image (2835 pixels/meter)
        0x00, 0x00, 0x00, 0x00,     // Number of colors in the palette (0 colors)
        0x00, 0x00, 0x00, 0x00      // Number of important colors in palette (all important)
    };
    
    unsigned char bitmap[max_size]={0};

    int k=0;
    for (int i = width-1; i >= 0; --i) {
        for (int j = i*width; j < i*width+width; ++j) {
            NSNumber *number = [[NSNumber alloc] initWithUnsignedChar:qrcode->data[j]];
            if ([number intValue] % 2 == 0) {
                bitmap[k] = 0xFF;
                bitmap[k+1] = 0xFF;
                bitmap[k+2] = 0xFF;
            } else {
                bitmap[k] = 0x00;
                bitmap[k+1] = 0x00;
                bitmap[k+2] = 0x00;
            }
            k+=3;
        }
        bitmap[k] = 0x00;
        k++;
    }

    NSMutableData *bmp = [[NSMutableData alloc] init];
    [bmp appendBytes:bmpHeader length:sizeof(bmpHeader)];
    [bmp appendBytes:bitmap length:(bmp_length*3)];

    NSArray *dirs = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documents = [dirs objectAtIndex:0];
    NSString *path = [documents stringByAppendingString:@"/qrcodesfrompcb/"];
    path = [path stringByAppendingString:qrData];
    path = [path stringByAppendingString:@".bmp"];

    [[NSFileManager defaultManager] createFileAtPath:path
                                            contents:bmp
                                          attributes:nil];
    
    //free(bitmap);
}

@end

