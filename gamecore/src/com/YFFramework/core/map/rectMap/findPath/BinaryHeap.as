/**
 *
 var a:BinaryHeap=new BinaryHeap(test)
var time:Number=getTimer()
var i:int;
var len:int=50000
for(i=0;i!=len;++i)
{
	a.ins({x:3});

	a.ins({x:1});
a.ins({x:2});
a.ins({x:5});

}


trace(a.pop().x)  //弹出最小的一个

///后一个和前一个    最小到大的顺序排列 
function test(obj:Object,obj2:Object):Boolean
{
	return obj.x<obj2.x;
}

trace(getTimer()-time)
 * 
 * 
 * 
 * 
 *  
 */

package com.YFFramework.core.map.rectMap.findPath
{
	/** 二叉树数组   
	 * 2012-7-13
	 *	@author yefeng
	 */
	public class BinaryHeap {
		public var a:Array;
		
		
		/**取最小的
		 */
		public var justMinFun:Function = function(x:Object, y:Object):Boolean 
		{
			return x < y;
		}
		
		public function BinaryHeap(justMinFun:Function = null)
		{
			identify();
			if (justMinFun != null)
				this.justMinFun = justMinFun;
		}
		
		public function ins(value:Object):void 
		{
			var p:int = a.length;
			a[p] = value;
			var pp:int = p >> 1;
			while (p > 1 && justMinFun(a[p], a[pp]))
			{
				var temp:Object = a[p];
				a[p] = a[pp];
				a[pp] = temp;
				p = pp;
				pp = p >> 1;
			}
		}
		
		public function pop():Object 
		{
			var min:Object = a[1];
			a[1] = a[a.length - 1];
			a.pop();
			var p:int = 1;
			var l:int = a.length;
			var sp1:int = p << 1;
			var sp2:int = sp1 + 1;
			while (sp1 < l)
			{
				if (sp2 < l)
				{
					var minp:int = justMinFun(a[sp2], a[sp1]) ? sp2 : sp1;
				} else
				{
					minp = sp1;
				}
				if (justMinFun(a[minp], a[p]))
				{
					var temp:Object = a[p];
					a[p] = a[minp];
					a[minp] = temp;
					p = minp;
					sp1 = p << 1;
					sp2 = sp1 + 1;
				} else
				{
					break;
				}
			}
			return min;
		}
		
		public function dispose():void
		{
			a=null;
		}
		/** 变为最初状态
		 */
		public function identify():void
		{
			a= [];
			a.push(-1);
		}
			
	}
}


