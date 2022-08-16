#ifndef ACCEL_H
#define ACCEL_H

#include <math.h>

extern int enable_hwaccel;
extern int parallel_core;
extern int const_log2_parallel;
int pow_of_2(int x)
{
    if (x == 0 || x == 1)
    return 0;

    else
    return (int)sqrt(x);
}


#endif // ACCEL_H
