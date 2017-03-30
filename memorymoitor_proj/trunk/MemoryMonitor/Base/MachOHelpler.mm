//
//  MachOHelpler.m
//  QQMSFContact
//
//  Created by rosenluo on 15/8/20.
//
//

#import "MachOHelpler.h"
#import <mach-o/dyld.h>
#import <dlfcn.h>
#import <vector>
//#if VCLeakMonitor_Enable
static MachOHelpler* helpler;

static std::vector<YellowImage> allImages;

@implementation MachOHelpler

+(MachOHelpler *)getInstance{
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        helpler = [[MachOHelpler alloc] init];
    });
    return helpler;
}

-(id)init{
    if(self = [super init]){
        uint32_t count = _dyld_image_count();
        for (uint32_t i = 0; i < count; i++) {
            const mach_header_t* header = (const mach_header_t*)_dyld_get_image_header(i);
            const char* name = _dyld_get_image_name(i);
            const char* tmp = strrchr(name, '/');
            long slide = _dyld_get_image_vmaddr_slide(i);
            if (tmp) {
                name = tmp + 1;
            }
    
            long offset = (long)header + sizeof(mach_header_t);
            
            for (unsigned int i = 0; i < header->ncmds; i++) {
                const segment_command_t* segment = (const segment_command_t*)offset;
                if (segment->cmd == MY_SEGMENT_CMD_TYPE && strcmp(segment->segname, SEG_TEXT) == 0) {
                    long begin = (long)segment->vmaddr + slide;
                    long end = (long)(begin + segment->vmsize);
                    YellowImage image;
                    image.loadAddr = (long)header;
                    image.beginAddr = begin;
                    image.endAddr = end;
                    image.name = name;
                    allImages.push_back(image);
                    NSLog(@"image info %s begin %ld end %ld",name,begin,end);
                }
                offset += segment->cmdsize;
            }
        }
    }
    return self;
}

-(BOOL)isInAppAddress:(long)addr{
    if(addr > allImages[0].beginAddr && addr < allImages[0].endAddr) return YES;
    return NO;
}

-(void)getImageByAddr:(long)addr image:(YellowImage *)image{
    for (size_t i = 0; i < allImages.size(); i++) {
        if (addr >= allImages[i].beginAddr && addr < allImages[i].endAddr) {
  //          *image = allImages[i];
            image->name = allImages[i].name;
            image->loadAddr = allImages[i].loadAddr;
            image->beginAddr = allImages[i].beginAddr;
            image->endAddr = allImages[i].endAddr;
        }
    }
}

@end
//#endif
