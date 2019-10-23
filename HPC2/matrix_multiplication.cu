#include <iostream>
#include <math.h>
#include <cstdlib>

using namespace std;	


__global__ void kernel_multiply(int *A, int *B, int *C, int n)
{
	int row = blockDim.y * blockIdx.y + threadIdx.y;
	int col = blockDim.x * blockIdx.x + threadIdx.x;
	int sum = 0;
	if(row<n && col<n)
	{
		for(int i=0;i<n;i++)
		{
			sum+=A[row*n+i]*B[i*n+col]; 
		}
		__syncthreads();
		C[row*n+col] = sum;
	}
}

void mm(int *A, int *B, int *C, int n)
{
	dim3 threadsPerBlock(n,n);
	dim3 blocksPerGrid(1,1);
	if(n*n>512)
	{
		threadsPerBlock.x=512;
		threadsPerBlock.y=512;
		blocksPerGrid.x=ceil(double(n)/double(threadsPerBlock.x));
		blocksPerGrid.y=ceil(double(n)/double(threadsPerBlock.y));
	}
	kernel_multiply<<<blocksPerGrid,threadsPerBlock>>>(A,B,C,n);
}

int main()
{
	int n;
	cout<<"\nEnter n:";
	cin>>n;
	int size=n*sizeof(int);

	int *hostA = (int*)malloc(size*n);
	int *hostB = (int*)malloc(size*n);
	int *hostC = (int*)malloc(size*n);
	int *ans = (int*)malloc(size*n);

	for(int i=0;i<n;i++)
	{
		for(int j=0;j<n;j++)
		{
			hostA[i*n+j] = rand()%n;
		}
	}

	for(int i=0;i<n;i++)
	{
		for(int j=0;j<n;j++)
		{
			hostB[i*n+j] = rand()%n;
		}
	}

	cout<<"\nMatrix A:\n";
	for(int i=0;i<n;i++)
	{
		for(int j=0;j<n;j++)
		{
			cout<<hostA[i*n+j]<<"\t";
		}
		cout<<endl;
	}
	cout<<endl;

	cout<<"\nMatrix B:\n";
	for(int i=0;i<n;i++)
	{
		for(int j=0;j<n;j++)
		{
			cout<<hostB[i*n+j]<<"\t";
		}
		cout<<endl;
	}
	cout<<endl;

	int sum=0;
	for(int row=0;row<n;row++)
	{
		for(int col=0;col<n;col++)
		{
			sum=0;
			for(int i=0;i<n;i++)
			{
				sum+=hostA[row*n+i]*hostB[i*n+col];
			}
			ans[row*n+col] = sum;
		}
	}


	int *deviceA,*deviceB,*deviceC;

	cudaMalloc(&deviceA,size*n);
	cudaMalloc(&deviceB,size*n);
	cudaMalloc(&deviceC,size*n);

	cudaMemcpy(deviceA,hostA,size*n,cudaMemcpyHostToDevice);
	cudaMemcpy(deviceB,hostB,size*n,cudaMemcpyHostToDevice);

	mm(deviceA,deviceB,deviceC,n);

	cudaMemcpy(hostC,deviceC,size*n,cudaMemcpyDeviceToHost);

	cout<<"\nAnswer=\n";
	for(int i=0;i<n*n;i++)
	{
		cout<<"( "<<i<<" )\tE = "<<ans[i]<<"\tA = "<<hostC[i]<<endl;
	}

	cudaFree(deviceA);
	cudaFree(deviceB);
	cudaFree(deviceC);

	return cudaDeviceSynchronize();
}
