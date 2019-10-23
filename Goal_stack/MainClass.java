import java.util.LinkedList;

class Node
{
	String name,on;
	boolean clear;
	
	Node()
	{
		name="";
		on="";
		clear=false;
	}

	public Node(String name, String on, boolean clear) 
	{
		this.name = name;
		this.on = on;
		this.clear = clear;
	}
	
}

class Stack
{
	LinkedList<Node> ll;

	public Stack(int no) 
	{
		if(no==1)
		{
			ll = new LinkedList<>();
			ll.add(new Node("B","A",true));
			ll.add(new Node("A","table",false));
			ll.add(new Node("C","table",true));
			ll.add(new Node("D","table",true));
		}
		else
		{
			ll = new LinkedList<>();
			ll.add(new Node("C","A",true));
			ll.add(new Node("A","table",false));
			ll.add(new Node("B","D",true));
			ll.add(new Node("D","table",false));
		}
	}

	@Override
	public String toString() 
	{
		String op="";
		for(int i=0;i<ll.size();i++)
		{
			op=op+ll.get(i).name+" on "+ll.get(i).on+"\tClear = "+ll.get(i).clear+"\n";
		}
		return op;
	}	
}

public class MainClass 
{
	static Stack start,goal;
	public static void main(String[] args) 
	{
		start=new Stack(1);
		goal=new Stack(0);
		show();
	}
	static void show()
	{
		System.out.println("Start state:\n"+start);
		System.out.println("\nGoal state:\n"+goal);
		for(int i=0;i<goal.ll.size();i++)
		{
			process(goal.ll.get(i));
		}
		System.out.println("\nFinal state:\n"+start);
	}
	static void process(Node n)
	{
		for(int i=0;i<start.ll.size();i++)
		{
			if(start.ll.get(i).name.equals(n.name) && start.ll.get(i).on.equals(n.on))
			{
				return;
			}
		}
		if(!n.on.equals("table"))
		{
			clear(n.on);
		}
		clear(n.name);
		put(n.name,n.on);
	}
	static void clear(String ele)
	{
		Node temp=null;
		for(int i=0;i<start.ll.size();i++)
		{
			if(start.ll.get(i).name.equals(ele))
			{
				temp=start.ll.get(i);
			}
		}
		if(!temp.clear)
		{
			System.out.println("Clear "+ele);
			for(int i=0;i<start.ll.size();i++)
			{
				if(start.ll.get(i).on.equals(temp.name))
				{
					clear(start.ll.get(i).name);
					put(start.ll.get(i).name,"table");
				}
			}
			temp.clear=true;
		}
	}
	static void put(String name,String on)
	{
		for(int i=0;i<start.ll.size();i++)
		{
			if(start.ll.get(i).name.equals(name))
			{
				start.ll.get(i).on=on;
			}
		}
		for(int i=0;i<start.ll.size();i++)
		{
			if(start.ll.get(i).name.equals(on))
			{
				start.ll.get(i).clear=false;
			}
		}
		System.out.println("Put "+name+" on "+on);
	}

}
