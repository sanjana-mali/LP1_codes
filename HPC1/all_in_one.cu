#include <iostream>
#include <stdlib.h>
#include <math.h>

using namespace std;
__global__ void maximum(int *a, int *b, int n)
{
	int max=0;
	int index = 256 * blockIdx.x;
	for(int i=index;i<min(256+index,n);i++)
	{
		if(a[i]>max)
		{
			max=a[i];
		}
	}
	b[blockIdx.x]=max;
}

__global__ void minimum(int *a, int *b, int n)
{
	int mini=999999;
	int index = 256 * blockIdx.x;
	for(int i=index;i<min(256+index,n);i++)
	{
		if(a[i]<mini)
		{
			mini=a[i];
		}
	}
	b[blockIdx.x]=mini;
}

__global__ void sum(int *a, int *b, int n)
{
	int sum=0;
	int index = 256 * blockIdx.x;
	for(int i=index;i<min(256+index,n);i++)
	{
		sum+=a[i];
	}
	b[blockIdx.x]=sum;
}

__global__ void standard_deviation(int *a, int *b, int n,double mean)
{
	double sum=0;
	int index = 256 * blockIdx.x;
	for(int i=index;i<min(256+index,n);i++)
	{
		sum+=(a[i]-mean)*(a[i]-mean);
	}
	b[blockIdx.x]=sum;
}

int main()
{
	int n,nmin,nsum,nmean,nsd;
	cout<<"\nEnter n:";
	cin>>n;
	int *hostA=(int*)malloc(sizeof(int)*n);

	nmin=n;
	nsum=n;
	nmean=n;
	nsd=n;

	float timeS=0.0,timeP=0.0;

	cudaEvent_t startS,endS,startP,endP;
	cudaEventCreate(&startS);
	cudaEventCreate(&endS);
	cudaEventCreate(&startP);
	cudaEventCreate(&endP);

	cudaEventRecord(startS);

	int max=0,min=9999999,ssum=0;
	double sd_sum=0.0f;
	for(int i=0;i<n;i++)
	{
		hostA[i]=rand()%n;
		cout<<hostA[i]<<"\t";
		if(hostA[i]>max)
		{
			max=hostA[i];
		}

		if(hostA[i]<min)
		{
			min=hostA[i];
		}
		ssum+=hostA[i];
	}
	double means=(ssum*1.0f)/(nmean*1.0f);
	for(int i=0;i<n;i++)
	{
		sd_sum+=(hostA[i]-means)*(hostA[i]-means);
	}

	cudaEventRecord(endS);
	cudaEventSynchronize(endS);
	cudaEventElapsedTime(&timeS,startS,endS);


	cudaEventRecord(startP);

	int *deviceA;
	cudaMalloc(&deviceA, sizeof(int)*n);
	cudaMemcpy(deviceA,hostA,sizeof(int)*n,cudaMemcpyHostToDevice);

	int *deviceB;	
	int grids=ceil(n*1.0f/256*1.0f);
	cudaMalloc(&deviceB, sizeof(int)*grids);

	dim3 grid(grids,1);
	dim3 block(1,1);

	while(n>1)
	{
		maximum<<<grid,block>>>(deviceA,deviceB,n);
		n=ceil(n*1.0f/256*1.0f);
		cudaMemcpy(deviceA,deviceB,n*sizeof(int),cudaMemcpyDeviceToDevice);
	}

	int maxi[2];
	cudaMemcpy(maxi,deviceA,4,cudaMemcpyDeviceToHost);
	cout<<"\nParallel Max="<<maxi[0]<<endl<<"Sequential Max="<<max<<endl;

//----------------------------------min----------------------------------------------------------

	cudaMemcpy(deviceA,hostA,sizeof(int)*nmin,cudaMemcpyHostToDevice);
	while(nmin>1)
	{
		minimum<<<grid,block>>>(deviceA,deviceB,nmin);
		nmin=ceil(nmin*1.0f/256*1.0f);
		cudaMemcpy(deviceA,deviceB,nmin*sizeof(int),cudaMemcpyDeviceToDevice);
	}

	int mini[2];
	cudaMemcpy(mini,deviceA,4,cudaMemcpyDeviceToHost);
	cout<<"\nParallel Min="<<mini[0]<<endl<<"Sequential Min="<<min<<endl;

//--------------------------------sum------------------------------------------------------------

	cudaMemcpy(deviceA,hostA,sizeof(int)*nsum,cudaMemcpyHostToDevice);
	while(nsum>1)
	{
		sum<<<grid,block>>>(deviceA,deviceB,nsum);
		nsum=ceil(nsum*1.0f/256*1.0f);
		cudaMemcpy(deviceA,deviceB,nsum*sizeof(int),cudaMemcpyDeviceToDevice);
	}

	int sums[2];
	cudaMemcpy(sums,deviceA,4,cudaMemcpyDeviceToHost);
	cout<<"\nParallel Sum="<<sums[0]<<endl<<"Sequential sum="<<ssum<<endl;

	double mean=(double)(sums[0]*1.0f/nmean*1.0f);

	cout<<"\nParallel Mean="<<mean<<endl<<"Sequential mean="<<means<<endl;


//--------------------------------sd-------------------------------------------------------------

	cudaMemcpy(deviceA,hostA,sizeof(int)*nsd,cudaMemcpyHostToDevice);
	while(nsd>1)
	{
		standard_deviation<<<grid,block>>>(deviceA,deviceB,nsd,mean);
		nsd=ceil(nsd*1.0f/256*1.0f);
		cudaMemcpy(deviceA,deviceB,nsd*sizeof(int),cudaMemcpyDeviceToDevice);
	}

	int sdp[2];
	cudaMemcpy(sdp,deviceA,4,cudaMemcpyDeviceToHost);
	cout<<"\nParallel SD="<<(double)sqrt((sdp[0]*1.0f)/(nmean*1.0f))<<endl<<"Sequential SD="<<(double)sqrt((sd_sum*1.0f)/(nmean*1.0f))<<endl;


	cudaEventRecord(endP);
	cudaEventSynchronize(endP);
	cudaEventElapsedTime(&timeP,startP,endP);

	cout<<"\nSequential Time="<<timeS;
	cout<<"\nParallel Time="<<timeP<<endl;

	return cudaDeviceSynchronize();
}
