


void recordMallocStack(vm_address_t address, uint32_t size, const char*name, size_t stack_num_to_skip);

void recordFreeStack(vm_address_t address, const char*name, size_t stack_num_to_skip);
