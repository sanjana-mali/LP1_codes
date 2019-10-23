#include <iostream>
#include <omp.h>
#include <bits/stdc++.h>
using namespace std;

int* parallel_bubble(int arr[],int n)
{
	bool fl=true;
	for(int i=0;i<n;i++)
	{
		int first=i%2;
		#pragma omp parallel for shared(arr,first)
		for (int j = first; j < n-1; j+=2)
		 {
		 	if(arr[j]>arr[j+1])
		 	{
		 		swap(arr[j],arr[j+1]);
		 		fl=false;
		 	}
		 } 
		 if(fl)
		 	break;
	}
	return arr;
}

void serial_bubble(int arr[],int n)
{
	bool fl=true;
	for(int i=0;i<n;i++)
	{
		for (int j = 0; j < n-i-1; j+=1)
		 {
		 	if(arr[j]>arr[j+1])
		 	{
		 		swap(arr[j],arr[j+1]);
		 		fl=false;
		 	}
		 } 
		 if(fl)
		 	break;
	}
	//return arr;
}

void merge(int arr[],int l, int m, int r)
{
	int temp1[m-l+1],temp2[r-m];

	for(int i=0;i<(m-l+1);i++)
	{
		temp1[i]=arr[l+i];
	}

	for (int i = 0; i < (r-m); ++i)
	{
		temp2[i]=arr[m+1+i];
	}

	int i=0,j=0,k=l;
	while(i<(m-l+1) && j<(r-m))
	{
		if(temp1[i]>temp2[j])
		{
			arr[k++]=temp2[j++];
		}
		else
		{
			arr[k++]=temp1[i++];
		}
	}

	while(i<(m-l+1))
	{
		arr[k++]=temp1[i++];
	}

	while(j<(r-m))
	{
		arr[k++]=temp2[j++];
	}
}

void serial_mergesort(int arr[],int l,int r)
{
	if(l<r)
	{
		int m=(l+r)/2;
		serial_mergesort(arr,l,m);
		serial_mergesort(arr,m+1,r);
		merge(arr,l,m,r);
	}
}

void parallel_mergesort(int arr[],int l,int r)
{
	if(l<r)
	{
		int m=(l+r)/2;
		#pragma omp parallel sections num_threads(2)
		{
			#pragma omp section
			{
				parallel_mergesort(arr,l,m);
			}
			#pragma omp section
			{
				parallel_mergesort(arr,m+1,r);
			}
		}
		merge(arr,l,m,r);
	}
}


int main()
{
	int n=100;
	cout<<"\nEnter n:";
	cin>>n;
	int arr[n],temp[n];
	for (int i = 0; i < n; i++)
	{
		arr[i]=rand()%n;
		temp[i]=arr[i];
	}
	double start=0.0f,end=0.0f;
	start=omp_get_wtime();
	serial_bubble(temp,n);
	end=omp_get_wtime();
	cout<<"\nSerial Bubble sorted=";
	for (int i = 0; i < n; i++)
	{
		cout<<temp[i]<<"\t";
	}
	cout<<"\nSerial Bubble time = "<<(end-start);



	for (int i = 0; i < n; i++)
	{
		temp[i]=arr[i];
	}
	start=0.0f,end=0.0f;
	start=omp_get_wtime();
	int *result=parallel_bubble(temp,n);
	end=omp_get_wtime();
	cout<<"\n\nParallel Bubble sorted=";
	for (int i = 0; i < n; i++)
	{
		cout<<temp[i]<<"\t";
	}
	cout<<"\nParallel Bubble time = "<<(end-start)<<endl;



	for (int i = 0; i < n; i++)
	{
		temp[i]=arr[i];
	}
	start=0.0f,end=0.0f;
	start=omp_get_wtime();
	serial_mergesort(temp,0,n-1);
	end=omp_get_wtime();
	cout<<"\n\nSerial merge sorted=";
	for (int i = 0; i < n; i++)
	{
		cout<<temp[i]<<"\t";
	}
	cout<<"\nSerial merge time = "<<(end-start)<<endl;



	for (int i = 0; i < n; i++)
	{
		temp[i]=arr[i];
	}
	start=0.0f,end=0.0f;
	start=omp_get_wtime();
	parallel_mergesort(temp,0,n-1);
	end=omp_get_wtime();
	cout<<"\n\nParallel merge sorted=";
	for (int i = 0; i < n; i++)
	{
		cout<<temp[i]<<"\t";
	}
	cout<<"\nParallel merge time = "<<(end-start)<<endl;
}
