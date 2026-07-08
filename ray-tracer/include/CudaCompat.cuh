#pragma once

#ifdef __CUDACC__
#define RT_HD __host__ __device__
#define RT_G __global__
#else
#define RT_HD
#define RT_G
#endif