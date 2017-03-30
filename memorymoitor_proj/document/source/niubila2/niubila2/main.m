//
//  main.m
//  niubila2
//
//  Created by michaelbi on 17/1/4.
//  Copyright © 2017年 tencent. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <malloc/malloc.h>

#define MALLOC_LOG_TYPE_ALLOCATE    2
#define MALLOC_LOG_TYPE_DEALLOCATE  4
#define MALLOC_LOG_TYPE_HAS_ZONE    8
#define MALLOC_LOG_TYPE_CLEARED     64

#define MALLOC_OP_MALLOC    (MALLOC_LOG_TYPE_ALLOCATE|MALLOC_LOG_TYPE_HAS_ZONE)
#define MALLOC_OP_CALLOC    (MALLOC_OP_MALLOC|MALLOC_LOG_TYPE_CLEARED)
#define MALLOC_OP_REALLOC   (MALLOC_OP_MALLOC|MALLOC_LOG_TYPE_DEALLOCATE)
#define MALLOC_OP_FREE      (MALLOC_LOG_TYPE_DEALLOCATE|MALLOC_LOG_TYPE_HAS_ZONE)

typedef void (malloc_logger_t)(unsigned, unsigned, unsigned, unsigned, unsigned, unsigned);

// decleared in the Libc malloc implementation
extern malloc_logger_t *malloc_logger;

void
print_malloc_record(unsigned type, unsigned arg1, unsigned arg2, unsigned arg3,
                    unsigned result, unsigned num_hot_franes_to_skip)
{
    switch(type) {
        case MALLOC_OP_MALLOC: //malloc() or valloc()
        case MALLOC_OP_CALLOC:
            malloc_printf("%s    : zone=%p, size=%u, pointer=%p\n", (type == MALLOC_OP_MALLOC) ? "malloc" : "calloc", arg1, arg2, result);
            break;
        case MALLOC_OP_REALLOC:
            malloc_printf("realloc   : zone=%p, size=%u, old = pointer=%p, "
                            "new pointer=%p\n", arg1, arg3, arg2, result);
            break;
        case MALLOC_OP_FREE:
            malloc_printf("free      : zone=%p, pointer=%p\n", arg1, arg2);
            break;
    }
}

void
do_some_allocations(void)
{
    void *m, *m_new, *c, *v, *m_z;
    malloc_zone_t *zone;
    
    m = malloc(1<<10);
    m_new = realloc(m, 1<<13);
    v = valloc(1<<10);
    c = calloc(1<<2, 1<<10);
    
    free(m_new);
    free(c);
    free(v);
    
    zone = malloc_create_zone(1<<14, 0);
    m_z = malloc_zone_malloc(zone, 1<<12);
    malloc_zone_free(zone, m_z);
    malloc_destroy_zone(zone);
}


int
main(void)
{
    malloc_logger = print_malloc_record;
    do_some_allocations();
    
    return 0;
}
