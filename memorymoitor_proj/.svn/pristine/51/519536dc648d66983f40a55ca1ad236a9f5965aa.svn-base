



void recordMallocStack(vm_address_t address, uint32_t size, const char*name, size_t stack_num_to_skip)
{
    if(1)
    {
        base_ptr_t base_ptr = malloc_zone_malloc(memory_zone, sizeof(struct base_ptr_t));

        vm_address_t *stack[max_stack_depth];
        base_ptr.depth = backtrace(stack, 128);
        if(base_stack.depth)
        {
            base_ptr.stack = (vm_address_t**)malloc_zone_malloc(memory_zone, base_stack.depth*sizeof(vm_address_t*))
            memcpy(base_ptr.stack, stack, base_stack.depth*sizeof(vm_address_t*));
            base_ptr.name = name;
            base_ptr.size = size;
            base_ptr.address = address;

            OSSpinLockLock(&spinlock);

            if(ptrs_hashmap)
            {
                hashmap_put(ptrs_hashmap, address, &base_ptr);
            }

            OSSpinLockUnlock(&spinlock);
        }
    }
}


void recordFreeStack(vm_address_t address, const char*name, size_t stack_num_to_skip)
{
    if(1)
    {
        OSSpinLockLock(&spinlock);

        if(ptrs_hashmap)
        {
            vm_address_t tmp;
            hashmap_get(ptrs_hashmap, address, &tmp);
            malloc_zone_free(memory_zone, tmp);
            hashmap_remove(ptrs_hashmap, address);
        }

        OSSpinLockUnlock(&spinlock);
    }
}