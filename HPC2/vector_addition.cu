#include <iostream>
#include <math.h>

using namespace std;

__global__ void kernel_sum (int *A, int *B, int *C, int n); 

void sum (int *A, int *B, int *C, int n);

int main()
{
	int n;
	cout<<"Enter n:";
	cin>>n;

	int size=n*sizeof(int);
	int *deviceA,*deviceB,*deviceC;
	int *hostA = (int*)malloc(size);
	int *hostB = (int*)malloc(size);
	int *hostC = (int*)malloc(size);
	cudaEvent_t start,end,start1,end1;
	cudaEventCreate(&start);
	cudaEventCreate(&end);
	cudaEventCreate(&start1);
	cudaEventCreate(&end1);


	for(int i=0;i<n;i++)
	{
		hostA[i]=rand()%n;
		hostB[i]=rand()%n;
	}

	cout<<"\nHost A:\n";
	for(int i=0;i<n;i++)
	{
		cout<<hostA[i]<<"\t";
	}

	cout<<"\nHost B:\n";
	for(int i=0;i<n;i++)
	{
		cout<<hostB[i]<<"\t";
	}

	float t=0,t1=0;
	cudaEventRecord(start);
	cout<<"\nSequential processing result:\n";
	for(int i=0;i<n;i++)
	{
		cout<<hostA[i]+hostB[i]<<"\t";
	}

	cudaEventRecord(end);
	cudaEventSynchronize(end);
	cudaEventElapsedTime(&t,start,end);

	cudaMalloc(&deviceA,size);
	cudaMalloc(&deviceB,size);
	cudaMalloc(&deviceC,size);


	cudaMemcpy(deviceA,hostA,size,cudaMemcpyHostToDevice);
	cudaMemcpy(deviceB,hostB,size,cudaMemcpyHostToDevice);

	cudaEventRecord(start1);

	sum(deviceA,deviceB,deviceC,n);

	cudaEventRecord(end1);
	cudaEventSynchronize(end1);
	cudaEventElapsedTime(&t1,start1,end1);

	cudaMemcpy(hostC,deviceC,size,cudaMemcpyDeviceToHost);

	cout<<"\nParallel Execution:\nExpected\tActual\n\n";
	for(int i=0;i<n;i++)
	{
		cout<<hostA[i]+hostB[i]<<"\t\t"<<hostC[i]<<"\n";
	}
	cout<<"\n";

	cout<<"\nSequential time:"<<t;
	cout<<"\nParallel time:"<<t1;

	cudaFree(deviceA);
	cudaFree(deviceB);
	cudaFree(deviceC);

	return cudaDeviceSynchronize();
}

void sum(int *A, int *B, int *C, int n)
{
	int threadsPerBlock, blocksPerGrid;
	if(n<512)
	{
		threadsPerBlock = n;
		blocksPerGrid = 1;
	}
	else
	{
		threadsPerBlock = 512;
		blocksPerGrid = ceil(double(n)/double(threadsPerBlock));
	}
	kernel_sum<<<blocksPerGrid,threadsPerBlock>>>(A,B,C,n);
}

__global__ void kernel_sum (int *A, int *B, int *C, int n)
{
	int index=blockDim.x * blockIdx.x + threadIdx.x;

	if(index<n)
		C[index] = A[index] + B[index];
} 


