#include <stdio.h>

__global__ void reduce1(int *g_idata, int *g_odata) {
   extern __shared__ int sdata[];

   unsigned int tid = threadIdx.x;
   unsigned int i = threadIdx.x + blockIdx.x * blockDim.x;
   sdata[tid] = g_idata[tid];
   __syncthreads();

   for (unsigned int s = 1; s < blockDim.x; s *= 2) {
      if (tid % (2*s) == 0) {
       sdata[tid] += sdata[tid + s];
      }
      __syncthreads();
   }
   
   if (tid == 0) g_odata[blockIdx.x] = sdata[0];
}

__global__ void reduce2(int *g_idata, int *g_odata) {
   extern __shared__ int sdata[];

   unsigned int tid = threadIdx.x;
   unsigned int i = threadIdx.x + blockIdx.x * blockDim.x;
   sdata[tid] = g_idata[tid];
   __syncthreads();

   for (unsigned int s = 1; s < blockDim.x; s *= 2) {
      int index = 2 * s * tid;
      if (index < blockDim.x) {
       sdata[index] += sdata[index + s];
      }
      __syncthreads();
   }
   
   if (tid == 0) g_odata[blockIdx.x] = sdata[0];
}

int main() {

}