import java.util.*;

public class eight
{
	public static void main(String args[])
	{
		board init=new board();
		System.out.println("Enter initial state:");
		init.initBoard();

		board goal=new board();
		System.out.println("Enter goal state:");
		goal.initBoard();

		System.out.println("Given Initial state:");
		init.display();

		System.out.println("Given Goal state:");
		goal.display();

		int g=0;
		board curr=init;
		while(true)
		{
			System.out.println("\nBoard after "+g+" moves:");
			curr.display();
			if(curr.equalBoard(goal))
			{
				System.out.println("Goal Achieved!");
				return;
			}
			g++;
			curr=curr.nextMove(g,goal);
		}
	}
}
