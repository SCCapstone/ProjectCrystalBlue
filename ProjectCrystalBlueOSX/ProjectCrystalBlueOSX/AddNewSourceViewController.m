//
//  AddNewSourceViewController.m
//  ProjectCrystalBlueOSX
//
//  Created by Logan Hood on 2/9/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import "AddNewSourceViewController.h"
#import "SourceConstants.h"
#import "qrencode.h"

@interface AddNewSourceViewController ()

@end

@implementation AddNewSourceViewController

//const char bmpHeader[]={
//    0x42, 0x4d,                 // ID field ("BM")
//    0xa2, 0x07, 0x00, 0x00,     // Size of the BMP file (1954 bytes)
//    0x00, 0x00, 0x00, 0x00,     // App specific (unused)
//    0x36, 0x00, 0x00, 0x00,     // Offset where the pixel array can be found (54 bytes)
//    0x28, 0x00, 0x00, 0x00,     // Number of bytes in DIB header (40 bytes)
//    0x19, 0x00, 0x00, 0x00,     // Width of the bitmap in pixels (25)
//    0x19, 0x00, 0x00, 0x00,     // Height of the bitmap in pixels (25)
//    0x01, 0x00,                 // Number of color planes (1)
//    0x18, 0x00,                 // Number of bits per pixel (24 bits)
//    0x00, 0x00, 0x00, 0x00,     // BI_RGB, no pixel array compression
//    0x6c, 0x07, 0x00, 0x00,     // Size of raw data in pixel array including padding (1900 bytes)
//    0x13, 0x0b, 0x00, 0x00,     // Horizontal resolution of image (2835 pixels/meter)
//    0x13, 0x0b, 0x00, 0x00,     // Vertical resolution of image (2835 pixels/meter)
//    0x00, 0x00, 0x00, 0x00,     // Number of colors in the palette (0 colors)
//    0x00, 0x00, 0x00, 0x00      // Number of important colors in palette (all important)
//};
//
//const int bmp_length=1900;
//
//- (void)writeQRCode:(NSString *)qrData
//{
//    QRcode *qrcode;
//    const char *string=[qrData cStringUsingEncoding:NSASCIIStringEncoding];
//    qrcode = QRcode_encodeString(string, 0, QR_ECLEVEL_H, QR_MODE_8, 0);
//    int width = qrcode->width;
//    
//    char bitmap[bmp_length]={0};
//    
//    unsigned char *data = qrcode->data;
//    
//    int k=0;
//    for (int i = width-1; i >= 0; --i) {
//        for (int j = i*width; j < i*width+width; ++j) {
//            NSNumber *number = [[NSNumber alloc] initWithUnsignedChar:data[j]];
//            if ([number intValue] % 2 == 0) {
//                bitmap[k] = 0xFF;
//                bitmap[k+1] = 0xFF;
//                bitmap[k+2] = 0xFF;
//            } else {
//                bitmap[k] = 0x00;
//                bitmap[k+1] = 0x00;
//                bitmap[k+2] = 0x00;
//            }
//            k+=3;
//        }
//        bitmap[k] = 0x00;
//        k++;
//    }
//    
//    NSMutableData *bmp = [[NSMutableData alloc] init];
//    [bmp appendBytes:bmpHeader length:sizeof(bmpHeader)];
//    [bmp appendBytes:bitmap length:sizeof(bitmap)];
//    
//    NSArray *dirs = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *documents = [dirs objectAtIndex:0];
//    NSString *path = [documents stringByAppendingString:@"/"];
//    path = [path stringByAppendingString:[qrData stringByAppendingString:@".bmp"]];
//    
//    [[NSFileManager defaultManager] createFileAtPath:path
//                                            contents:bmp
//                                          attributes:nil];
//}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)loadView
{
    [super loadView];
    [self initializeTextFieldValues];
}

- (void)initializeTextFieldValues
{
    [self.keyTextField          setStringValue:SRC_DEF_VAL_KEY];
    [self.continentTextField    setStringValue:SRC_DEF_VAL_CONTINENT];
    [self.typeTextField         setStringValue:SRC_DEF_VAL_TYPE];
    [self.lithologyTextField    setStringValue:SRC_DEF_VAL_LITHOLOGY];
    [self.deposystemTextField   setStringValue:SRC_DEF_VAL_DEPOSYSTEM];
    [self.groupTextField        setStringValue:SRC_DEF_VAL_GROUP];
    [self.formationTextField    setStringValue:SRC_DEF_VAL_FORMATION];
    [self.memberTextField       setStringValue:SRC_DEF_VAL_MEMBER];
    [self.regionTextField       setStringValue:SRC_DEF_VAL_REGION];
    [self.localityTextField     setStringValue:SRC_DEF_VAL_LOCALITY];
    [self.sectionTextField      setStringValue:SRC_DEF_VAL_SECTION];
    [self.meterLevelTextField   setStringValue:SRC_DEF_VAL_METER_LEVEL];
    [self.latitudeTextField     setStringValue:SRC_DEF_VAL_LATITUDE];
    [self.longitudeTextField    setStringValue:SRC_DEF_VAL_LONGITUDE];
    [self.ageTextField          setStringValue:SRC_DEF_VAL_AGE];
    [self.ageBasis1TextField    setStringValue:SRC_DEF_VAL_AGE_BASIS1];
    [self.ageBasis2TextField    setStringValue:SRC_DEF_VAL_AGE_BASIS2];
    
    NSString *now = [NSString stringWithFormat:@"%@", [[NSDate alloc] init]];
    [self.dateCollectedTextField setStringValue:now];
    [self.projectTextField setStringValue:SRC_DEF_VAL_PROJECT];
    [self.subProjectTextField setStringValue:SRC_DEF_VAL_SUBPROJECT];
}

- (IBAction)cancelButtonPressed:(id)sender {
    [self.view.window close];
}

- (IBAction)saveButtonPressed:(id)sender {
    NSString *key = self.keyTextField.stringValue;
    
    NSMutableDictionary *attributes = [[NSMutableDictionary alloc] initWithObjects:[SourceConstants attributeDefaultValues]
                                                                           forKeys:[SourceConstants attributeNames]];
    
    [attributes setObject:self.keyTextField.stringValue             forKey:SRC_KEY];
    [attributes setObject:self.continentTextField.stringValue       forKey:SRC_CONTINENT];
    [attributes setObject:self.typeTextField.stringValue            forKey:SRC_TYPE];
    [attributes setObject:self.lithologyTextField.stringValue       forKey:SRC_LITHOLOGY];
    [attributes setObject:self.deposystemTextField.stringValue      forKey:SRC_DEPOSYSTEM];
    [attributes setObject:self.groupTextField.stringValue           forKey:SRC_GROUP];
    [attributes setObject:self.formationTextField.stringValue       forKey:SRC_FORMATION];
    [attributes setObject:self.memberTextField.stringValue          forKey:SRC_MEMBER];
    [attributes setObject:self.regionTextField.stringValue          forKey:SRC_REGION];
    [attributes setObject:self.localityTextField.stringValue        forKey:SRC_LOCALITY];
    [attributes setObject:self.sectionTextField.stringValue         forKey:SRC_SECTION];
    [attributes setObject:self.meterLevelTextField.stringValue      forKey:SRC_METER_LEVEL];
    [attributes setObject:self.latitudeTextField.stringValue        forKey:SRC_LATITUDE];
    [attributes setObject:self.longitudeTextField.stringValue       forKey:SRC_LONGITUDE];
    [attributes setObject:self.ageTextField.stringValue             forKey:SRC_AGE];
    [attributes setObject:self.ageBasis1TextField.stringValue       forKey:SRC_AGE_BASIS1];
    [attributes setObject:self.ageBasis2TextField.stringValue       forKey:SRC_AGE_BASIS2];
    [attributes setObject:self.dateCollectedTextField.stringValue   forKey:SRC_DATE_COLLECTED];
    [attributes setObject:self.projectTextField.stringValue         forKey:SRC_PROJECT];
    [attributes setObject:self.subProjectTextField.stringValue      forKey:SRC_SUBPROJECT];
    
    //[self writeQRCode:self.keyTextField.stringValue]; // Writes a qr code to a bitmap file with value of key
    
    Source* s = [[Source alloc] initWithKey:key AndWithAttributeDictionary:attributes];
    [self.sourcesViewController addSource:s];
    [self.view.window close];
}
@end
