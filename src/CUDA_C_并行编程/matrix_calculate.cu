#include <stdio.h>
#include <stdlib.h>

#define DIM 10
__global__ void kernel(int *matrix){
    int x = blockIdx.x;
    int y = blockIdx.y;
    int offset = x + y * gridDim.x;

    matrix[offset] = x * y;
}

int main(void){
    int *dev_matrix;
    int matrix[DIM*DIM];
    cudaMalloc((void**)&dev_matrix, DIM*DIM*sizeof(int));
    //dim3 grid(DIM, DIM)
    dim3 grid(DIM, DIM, 1);
    kernel<<<grid, 1>>>(dev_matrix);
    cudaMemcpy(matrix, dev_matrix, DIM*DIM*sizeof(int), cudaMemcpyDeviceToHost);
    cudaFree(dev_matrix);
    for (int i = 0; i < DIM; ++i){
        for (int j = 0; j < DIM; ++j){
            printf("%d ", matrix[i + j * DIM]);
        }
        printf("\n");
    }
}
