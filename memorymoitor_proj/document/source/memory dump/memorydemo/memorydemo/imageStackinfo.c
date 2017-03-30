//
//  imageStackinfo.c
//  memorydemo
//
//  Created by michaelbi on 16/11/2.
//  Copyright © 2016年 tencent. All rights reserved.
//




void initallstackimage(){
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
                StackImage image;
                image.loadAddr = (long)header;
                image.beginAddr = begin;
                image.endAddr = end;
                image.name = name;
                allstackimage[i]=image;
                allimagecount++;
                malloc_printf("image info %s begin %ld end %ld \n",name,begin,end);
            }
            offset += segment->cmdsize;
        }
    }
}

void getImageByAddr(long addr,StackImage *image){
    for (size_t i = 0; i < allimagecount; i++) {
        if (addr >= allstackimage[i].beginAddr && addr < allstackimage[i].endAddr) {
            //     *image = allImages[i];
            image->name = allstackimage[i].name;
            image->loadAddr = allstackimage[i].loadAddr;
            image->beginAddr = allstackimage[i].beginAddr;
            image->endAddr = allstackimage[i].endAddr;
        }
    }
}
