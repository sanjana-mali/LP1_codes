package n_queens;

import java.util.Scanner;

public class branch 
{
	int n;
	public void setN(int n)
	{
		this.n=n;
	}
	
	void printBoard(int[][] board)
	{
		for(int i=0;i<n;i++)
		{
			for(int j=0;j<n;j++)
			{
				System.out.print(board[i][j]+"\t");
			}
			System.out.println();
		}
	}
	
	boolean isSafe(int row,int col,int slashCode[][],boolean slashCodeLookup[],int backslashCode[][],boolean backslashCodeLookup[],boolean rowlookup[])
	{
		if(slashCodeLookup[slashCode[row][col]] || backslashCodeLookup[backslashCode[row][col]] || rowlookup[row])
		{
			return false;
		}
		return true;
	}
	
	boolean solveNQ(int[][] board,int col,int slashCode[][],boolean slashCodeLookup[],int backslashCode[][],boolean backslashCodeLookup[],boolean rowlookup[])
	{
		if(col>=n)
			return true;
		
		for(int i=0;i<n;i++)
		{
			if(isSafe(i,col,slashCode,slashCodeLookup,backslashCode,backslashCodeLookup,rowlookup))
			{
				board[i][col]=1;
				rowlookup[i]=true;
				slashCodeLookup[slashCode[i][col]]=true;
				backslashCodeLookup[backslashCode[i][col]]=true;	
				
				if(solveNQ(board,col+1,slashCode,slashCodeLookup,backslashCode,backslashCodeLookup,rowlookup))
					return true;
				
				board[i][col]=0;
				rowlookup[i]=false;
				slashCodeLookup[slashCode[i][col]]=false;
				backslashCodeLookup[backslashCode[i][col]]=false;
			}
			
		}	
		
		return false;
	}
	
	void solve()
	{
		int board[][]=new int[n][n];		
		int slashCode[][]=new int[n][n];
		int backSlashCode[][]=new int[n][n];
		
		for(int i=0;i<n;i++)
		{
			for(int j=0;j<n;j++)
			{
				slashCode[i][j]=i+j;
				backSlashCode[i][j]=i-j+n-1;
			}
		}
		
		boolean slashCodeLookup[]=new boolean[2*n-1];
		boolean backSlashCodeLookup[]=new boolean[2*n-1];
		boolean rowlookup[]=new boolean[n];
		
		if(solveNQ(board,0,slashCode,slashCodeLookup,backSlashCode,backSlashCodeLookup,rowlookup)==false)
		{
			System.out.println("Solution doesnt exist!");
			return;
		}
		printBoard(board);
	}
	
	public static void main(String args[])
	{
		Scanner sc=new Scanner(System.in);
		branch b=new branch();
		System.out.println("Enter n:--");
		int n=sc.nextInt();
		b.setN(n);
		b.solve();
	}
}
