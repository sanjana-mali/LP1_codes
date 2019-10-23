#include <iostream>
#include <math.h>

using namespace std;

__global__ void min1(int *a,int *b,int n)
{
	int index=256*blockIdx.x;
	int mini=999999;
	for(int i=index;i<min(256+index,n);i++)
	{
		if(a[i]<mini)
		{
			mini=a[i];
		}
	}
	b[blockIdx.x]=mini;
}

int main()
{
	int n=0;
	cout<<"Enter n:";
	cin>>n;
	int *a=(int*)malloc(n*sizeof(int));
	int max=0;

	for(int i=0;i<n;i++)
	{
		a[i]=rand()%n;
		cout<<a[i]<<"\t";
	}

	for(int i=0;i<n;i++)
	{
		if(a[i]>max)
		{
			max=a[i];
		}
	}
	//cout<<"\nMax="<<max<<endl;

	int min=999999;
	for(int i=0;i<n;i++)
	{
		if(a[i]<min)
		{
			min=a[i];
		}
	}
	cout<<"\nMin="<<min<<endl;

	int *deviceA,*deviceB;

	int grids=ceil(n*1.0f/256*1.0f);
	cudaMalloc(&deviceA,n*sizeof(int));
	cudaMemcpy(deviceA,a,n*sizeof(int),cudaMemcpyHostToDevice);

	dim3 grid(grids,1);
	dim3 block(1,1);

	cudaMalloc(&deviceB,grids*sizeof(int));

	while(n>1)
	{
		min1<<<grid,block>>>(deviceA,deviceB,n);
		n=ceil(n*1.0f/256*1.0f);
		cudaMemcpy(deviceA,deviceB,n*sizeof(int),cudaMemcpyDeviceToDevice);
	}

	int ans[2];
	cudaMemcpy(ans,deviceA,4,cudaMemcpyDeviceToHost);

	cout<<"\nParallel Min="<<ans[0]<<endl;
	return cudaDeviceSynchronize();
}
