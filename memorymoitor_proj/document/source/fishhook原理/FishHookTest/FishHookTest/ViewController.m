//
//  ViewController.m
//  FishHookTest
//
//  Created by kirk on 15/7/16.
//  Copyright (c) 2015年 tencent. All rights reserved.
//

#import "ViewController.h"
#import <mach-o/dyld.h>
#import <mach-o/loader.h>
#import <mach-o/nlist.h>
#import <dlfcn.h>

#ifndef SEG_DATA_CONST
#define SEG_DATA_CONST  "__DATA_CONST"
#endif

//
//static int (*orig_open)(const char *, int, ...);
//

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

int shit = 1111;
int fucking = 2222;
int holyshit = 3333;
int fuckingholy = 4444;

NSString*sttr1=@"S1ViewController";//全局变量

-(void)myPrint:(int)index
{

    NSString *abc = [[NSString alloc]initWithFormat:@"abc"];
    struct mach_header_64* header = (struct mach_header_64*)_dyld_get_image_header(index);
    intptr_t slide = _dyld_get_image_vmaddr_slide(index);
    struct segment_command_64* cur_seg_cmd;
    struct symtab_command* symtab_cmd = NULL;
    struct dysymtab_command* dysymtab_cmd = NULL;
    
    char* stringTable_base = NULL;
    struct nlist_64* symbolTable_base = NULL;
    uint32_t* indirectSymbolTable_base = NULL;
    
    //第一次遍历
    uintptr_t cur = (uintptr_t)header + sizeof(struct mach_header_64);
    for (uint i = 0; i < header->ncmds; i++, cur += cur_seg_cmd->cmdsize)
    {
        cur_seg_cmd = (struct segment_command_64*)cur;
        
        if (cur_seg_cmd->cmd==LC_SYMTAB) {
            symtab_cmd = (struct symtab_command*)cur_seg_cmd;
            stringTable_base = (char*)((char*)header + symtab_cmd->stroff);
            symbolTable_base = (struct nlist_64*)((char*)header + symtab_cmd->symoff);
        }
        
        if(cur_seg_cmd->cmd==LC_DYSYMTAB){
            dysymtab_cmd =(struct dysymtab_command*)cur_seg_cmd;
            indirectSymbolTable_base = (uint32_t* )((char*)header + dysymtab_cmd->indirectsymoff);
        }

    }
    
    //第二次遍历
    cur = (uintptr_t)header + sizeof(struct mach_header_64);
    for (uint i = 0; i < header->ncmds; i++, cur += cur_seg_cmd->cmdsize)
    {
        cur_seg_cmd = (struct segment_command_64*)cur;
        if((cur_seg_cmd->cmd==LC_SEGMENT_64)&&(strcmp(cur_seg_cmd->segname, SEG_DATA)==0||strcmp(cur_seg_cmd->segname, SEG_DATA_CONST)==0))
        {
            uintptr_t cur_seg_base = (uintptr_t)slide + cur_seg_cmd->vmaddr - cur_seg_cmd->fileoff;
            struct section_64 *sect;
            for (uint j = 0; j < cur_seg_cmd->nsects; j++)
            {
                sect = (struct section_64 *)(cur + sizeof(struct segment_command_64)) + j;
                //if ((sect->flags & SECTION_TYPE) == S_LAZY_SYMBOL_POINTERS)
                char tmp_data_name[16] = SECT_DATA;
                if(strcmp(sect -> sectname, tmp_data_name)==0)
                {
                    uint32_t *tmp_ptr, tag1, tag2;
                    for(int i = 0; i < sect->size; ++i)
                    {
                        tmp_ptr = cur_seg_base + sect->offset;
                        uint32_t tag;
                        memcpy(&tag, tmp_ptr+sizeof(uint32_t)*i, sizeof(uint32_t));
                        if((uint32_t)tag == (uint32_t)sttr1)
                            NSLog(@"%@\n", sttr1);
                        if(tag == fucking)
                            puts("FUCKING");
                        if(tag == shit)
                            puts("SHIT");
                    }
                    puts("");
                }
                memcpy(tmp_data_name, SECT_BSS, 16*sizeof(char));
                if(strcmp(sect -> sectname, tmp_data_name)==0)
                {
                    uint32_t *tmp_ptr, tag1, tag2;
                    
                    for(int i = 0; i < sect->size; ++i)
                    {
                        tmp_ptr = cur_seg_base + sect->offset;
                        uint32_t tag;
                        memcpy(&tag, tmp_ptr+sizeof(uint32_t)*i, sizeof(uint32_t));
                        if((uint32_t)tag == (uint32_t)sttr1)
                            NSLog(@"%@\n", sttr1);
                        if(tag == fucking)
                            puts("FUCKING");
                        if(tag == shit)
                            puts("SHIT");
                    }
                    puts("");
                }

            }
        }
        
    }
    
}


-(void)myPrintTest:(int)index
{
    
    struct mach_header_64* header = (struct mach_header_64*)_dyld_get_image_header(index);
    intptr_t slide = _dyld_get_image_vmaddr_slide(index);
    struct segment_command_64* cur_seg_cmd;
    struct symtab_command* symtab_cmd = NULL;
    struct dysymtab_command* dysymtab_cmd = NULL;
    
    char* stringTable_base = NULL;
    struct nlist_64* symbolTable_base = NULL;
    uint32_t* indirectSymbolTable_base = NULL;
    
    //第一次遍历
    uintptr_t cur = (uintptr_t)header + sizeof(struct mach_header_64);
    for (uint i = 0; i < header->ncmds; i++, cur += cur_seg_cmd->cmdsize)
    {
        cur_seg_cmd = (struct segment_command_64*)cur;
        
        if (cur_seg_cmd->cmd==LC_SYMTAB) {
            symtab_cmd = (struct symtab_command*)cur_seg_cmd;
            stringTable_base = (char*)((char*)header + symtab_cmd->stroff);
            symbolTable_base = (struct nlist_64*)((char*)header + symtab_cmd->symoff);
        }
        
        if(cur_seg_cmd->cmd==LC_DYSYMTAB){
            dysymtab_cmd =(struct dysymtab_command*)cur_seg_cmd;
            indirectSymbolTable_base = (uint32_t* )((char*)header + dysymtab_cmd->indirectsymoff);
        }
        
    }
    
    //第二次遍历
    cur = (uintptr_t)header + sizeof(struct mach_header_64);
    for (uint i = 0; i < header->ncmds; i++, cur += cur_seg_cmd->cmdsize)
    {
        cur_seg_cmd = (struct segment_command_64*)cur;
        if((cur_seg_cmd->cmd==LC_SEGMENT_64)&&(strcmp(cur_seg_cmd->segname, SEG_DATA)==0||strcmp(cur_seg_cmd->segname, SEG_DATA_CONST)==0))
        {
            struct section_64 *sect;
            for (uint j = 0; j < cur_seg_cmd->nsects; j++)
            {
                sect = (struct section_64 *)(cur + sizeof(struct segment_command_64)) + j;
                if(sect->sectname==SECT_DATA){
                    
                    
                }
            }
        }
        
    }
    
}


- (IBAction)onTouch:(id)sender {
    NSLog(@"======================================================================");
    NSLog(@"dlsym NSLog:%p",dlsym(RTLD_DEFAULT, "NSLog"));
    [self myPrint:0];
   // [self myPrintTest:0];
//    NSLog(@"dlsym open:%p",dlsym(RTLD_DEFAULT, "open"));
//    for (uint32_t i=0; i<_dyld_image_count(); i++)
//    {
//        [self myPrint:i];
//    }

}
    
@end
