#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

int main(int argc, char **argv)             // copilot
{
    if (argc != 3)
    {
        fprintf(2, "Format -> setpriority priority pid\n");
        exit(1);
    }
    int priority = atoi(argv[1]);
    int pid = atoi(argv[2]);
    int oldpriority = set_priority(priority, pid);
    if(oldpriority == -1)
    {
        exit(1);
    }
    printf("Priority updated from %d to %d for the process %d\n", oldpriority, priority, pid);
    exit(0);
}