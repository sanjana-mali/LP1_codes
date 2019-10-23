package n_queens;

import java.util.Scanner;

public class backtrack 
{
	int n;

	public void setN(int n)
	{
		this.n=n;
	}
	public void solve(int n)
	{
		int board[][]=new int[n][n];
		for(int i=0;i<n;i++)
		{
			for(int j=0;j<n;j++)
			{
				board[i][j]=0;
			}
		}
		if(solveNQ(board,0)==false)
		{
			System.out.println("\nSolution does not exist!");
			return;
		}
		printBoard(board);
	}
	
	public void printBoard(int[][] board)
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
	
	public boolean solveNQ(int[][] board,int col)
	{
		if(col>=n)
			return true;
		for(int i=0;i<n;i++)
		{
			if(isSafe(board,i,col))
			{
				board[i][col]=1;
				if(solveNQ(board,col+1))
					return true;
				board[i][col]=0;
			}
		}
		return false;
	}
	
	public boolean isSafe(int[][] board, int row, int col)
	{
		for(int i=0;i<col;i++)
		{
			if(board[row][i]==1)
				return false;
		}
		for(int i=row,j=col;i<n && j>=0;i++,j--)
		{
			if(board[i][j]==1)
				return false;
		}
		
		for(int i=row,j=col;i>=0 && j>=0;i--,j--)
		{
			if(board[i][j]==1)
				return false;
		}
		
		return true;
	}
	
	public static void main(String args[])
	{
		backtrack b=new backtrack();
		Scanner sc=new Scanner(System.in);
		System.out.println("Enter n:");
		int n=sc.nextInt();
		b.setN(n);
		b.solve(n);
	}
}
