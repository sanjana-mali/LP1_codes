#include<iostream>
#include<cstdio>

using namespace std;


__global__ void var(int *a,int *b,int n,float mean)
{
	int block=256*blockIdx.x;
	double sum=0.0f;
	for(int i=block;i<min(block+256,n);i++)
	{
		sum=sum+((a[i]-mean)*(a[i]-mean));
	}
	b[blockIdx.x]=sum;
}

__global__ void sum(int *a,int *b,int n)
{
	int block=256*blockIdx.x;
	int sum=0;
	for(int i=block;i<min(block+256,n);i++)
	{
		sum=sum+a[i];
	}
	b[blockIdx.x]=sum;
}

int main()
{
	cout<<"Enter the no of elements:";
	int n;
	cin>>n;
	int n1=n,p1=n;
	int *a=(int*)malloc(n*sizeof(int));
	for(int i=0;i<n;i++)
	{
		a[i]=rand()%100;
		cout<<a[i]<<"\t";
	}

	cudaEvent_t start1,end1;
	cudaEventCreate(&start1);
	cudaEventCreate(&end1);
	cudaEventRecord(start1);
	int sum1=0;
	for(int i=0;i<n;i++)
	{
		sum1+=a[i];
	}
	float mean1=0.0f;
	mean1=sum1/(n*1.0f);
	double s=0.0f;
	for(int i=0;i<n;i++)
	{
		s=s+((a[i]-mean1)*(a[i]-mean1));
	}
	double sd1=sqrt(s/n*1.0f);
	cout<<"\nAdd="<<s;
	cudaEventRecord(end1);
	cudaEventSynchronize(end1);
	float time1=0;
	cudaEventElapsedTime(&time1,start1,end1);
	cout<<"\nSequential Processing:";
	cout<<"\nSum="<<sum1;
	cout<<"\nMean="<<mean1;
	cout<<"\nStandard deviation="<<sd1;
	cout<<"\nSequential time="<<time1<<endl;

	int *ad,*bd;
	int size=n*sizeof(int);
	cudaMalloc(&ad,size);
	cudaMemcpy(ad,a,size,cudaMemcpyHostToDevice);
	int grids=ceil(n*1.0f/256.0f);
	cudaMalloc(&bd,grids*sizeof(int));
	dim3 grid(grids,1);
	dim3 block(1,1);
	int p=n;
	cudaEvent_t start,end;
	cudaEventCreate(&start);
	cudaEventCreate(&end);
	cudaEventRecord(start);
	while(n>1)
	{

		sum<<<grid,block>>>(ad,bd,n);
		n=ceil(n*1.0f/256.0f);
		cudaMemcpy(ad,bd,n*sizeof(int),cudaMemcpyDeviceToDevice);

	}
	cudaEventRecord(end);
	cudaEventSynchronize(end);
	float time=0;
	cudaEventElapsedTime(&time,start,end);
	int add[2];
	n=p;
	cudaMemcpy(add,ad,4,cudaMemcpyDeviceToHost);
	cout<<"\nSum="<<add[0]<<endl;
	float mean=0.0f;
	mean=add[0]/(n*1.0f);
	cout<<"Mean="<<mean<<endl;


	int *ad1,*bd1;

	cudaMalloc(&ad1,size);
	cudaMemcpy(ad1,a,size,cudaMemcpyHostToDevice);
	int grids1=ceil(n1*1.0f/256.0f);
	cudaMalloc(&bd1,grids1*sizeof(int));
	dim3 grid1(grids1,1);
	dim3 block1(1,1);

	//var<<<grid,block>>>(ad,bd,n,mean);
	//n=ceil(n*1.0f/256.0f);	
	//sum<<<grid,block>>>(bd,ad,n);

	while(n1>1)
	{

		var<<<grid1,block1>>>(ad1,bd1,n1,mean);
		n1=ceil(n1*1.0f/256.0f);
		cudaMemcpy(ad1,bd1,n1*sizeof(int),cudaMemcpyDeviceToDevice);

	}

	long long int add1[2];
	cudaMemcpy(add1,ad1,4,cudaMemcpyDeviceToHost);
	cout<<"\nAdd="<<add1[0]<<endl;
	float sd_=sqrt(add1[0]/(p1*1.0f));
	cout<<"Standard deviation="<<sd_<<endl;
	cout<<"Parallel time="<<time<<endl;
	return cudaDeviceSynchronize();
}
