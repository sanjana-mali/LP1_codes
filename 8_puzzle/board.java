import java.util.*;

public class board
{
	String Board[][];
	int blankX,blankY;
	public board()
	{
		this.Board = new String[3][3];
	}
	public board(board b)
	{
		this.Board=b.Board;
		this.blankX=b.blankX;
		this.blankY=b.blankY;
	}

	public void initBoard()
	{
		Scanner s=new Scanner(System.in);
		for(int i=0;i<3;i++)
		{
			for (int j=0; j<3; j++) 
			{
				Board[i][j]=s.next();

				if(Board[i][j].equals("-"))
				{
					blankX=i;
					blankY=j;
				}	
			}
		}
	}

	public boolean equalBoard(board b)
	{
		for(int i=0;i<3;i++)
		{
			for(int j=0;j<3;j++)
			{
				if(!b.Board[i][j].equals(this.Board[i][j]))
				{
					return false;
				}
			}
		}
		return true;
	}

	public int h(board b)
	{
		int hn=0;
		for (int i=0;i<3;i++) 
		{
			for (int j=0;j<3;j++) 
			{
				if(!b.Board[i][j].equals(this.Board[i][j]))
				{
					hn++;
				}	
			}
		}
		return hn;
	}

	public void setBlankX(int x)
	{
		blankX=x;
	}
	public void setBlankY(int x)
	{
		blankY=x;
	}
	public void swap(int x1,int y1,int x2,int y2)
	{
		String t=Board[x1][y1];
		Board[x1][y1]=Board[x2][y2];
		Board[x2][y2]=t;
	}
	public void setBoard(String[][] b)
	{
		for(int i=0;i<3;i++)
		{
			for(int j=0;j<3;j++)
			{
				this.Board[i][j]=b[i][j];
			}
		}
	}
	public void display()
	{
		for(int i=0;i<3;i++)
		{
			for(int j=0;j<3;j++)
			{
				System.out.print(Board[i][j]+"\t");
			}
			System.out.println();
		}
	}

	public board nextMove(int g, board goal)
	{
		board curr=new board();
		board next=new board();
		int minFn=999;
		System.out.println("\nPossible moves=");
		if(blankX>0) //up move
		{
			curr.setBoard(Board);
			curr.swap(blankX,blankY,blankX-1,blankY);
			int fn=curr.h(goal);
			System.out.println("\nH(current) = "+curr.h(goal)+"\tF(current) = "+fn);
			curr.display();
			if(fn<minFn)
			{
				minFn=fn;
				next.setBoard(curr.Board);
				next.setBlankX(blankX-1);
				next.setBlankY(blankY);
			}
		}
		if(blankX<2) //down move
		{
			curr.setBoard(Board);
			curr.swap(blankX,blankY,blankX+1,blankY);
			int fn=curr.h(goal);
			System.out.println("H(current) = "+curr.h(goal)+"\tF(current) = "+fn);
			curr.display();
			if(fn<minFn)
			{
				minFn=fn;
				next.setBoard(curr.Board);
				next.setBlankX(blankX+1);
				next.setBlankY(blankY);
			}
		}
		if(blankY>0) //left move
		{
			curr.setBoard(Board);
			curr.swap(blankX,blankY,blankX,blankY-1);
			int fn=curr.h(goal);
			System.out.println("H(current) = "+curr.h(goal)+"\tF(current) = "+fn);
			curr.display();
			if(fn<minFn)
			{
				minFn=fn;
				next.setBoard(curr.Board);
				next.setBlankX(blankX);
				next.setBlankY(blankY-1);
			}
		}
		if(blankY<2) //right move
		{
			curr.setBoard(Board);
			curr.swap(blankX,blankY,blankX,blankY+1);
			int fn=curr.h(goal);
			System.out.println("H(current) = "+curr.h(goal)+"\tF(current) = "+fn);
			curr.display();
			if(fn<minFn)
			{
				minFn=fn;
				next.setBoard(curr.Board);
				next.setBlankX(blankX);
				next.setBlankY(blankY+1);
			}
		}
		return next;
	}

}
