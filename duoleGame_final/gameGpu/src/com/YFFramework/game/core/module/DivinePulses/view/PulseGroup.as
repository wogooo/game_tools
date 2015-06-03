package com.YFFramework.game.core.module.DivinePulses.view
{
	import com.YFFramework.game.core.module.DivinePulses.model.Divine_pulseBasicVo;

	/***
	 *神脉组，用于设置单个图标选中
	 *@author ludingchang 时间：2013-11-13 上午10:26:43
	 */
	public class PulseGroup
	{
		private var _children:Array;
		private var _selectedIndex:int=0;
		public function PulseGroup()
		{
			_children=new Array;
		}
		public function add(icon:*):void
		{
			_children.push(icon);
		}
		public function remove(icon:*):void
		{
			var i:int,len:int=_children.length;
			for(i=0;i<len;i++)
			{
				if(_children[i]==icon)
				{
					_children.splice(i,1);
					break;
				}
			}
		}
		public function clear():void
		{
			_children.length=0;
		}
		/**
		 *设置单个选中 
		 * @param icon 要设置成选中的图标
		 */		
		public function set selected(index:int):void
		{
			var i:int,len:int=_children.length;
			for(i=0;i<len;i++)
			{
				var temp:* =_children[i];
				if(i==index)
				{
					temp.select=true;
					_selectedIndex=i;
				}
				else
				{
					temp.select=false;
				}
			}
		}
		public function get selected():int
		{
			return _selectedIndex;
		}
	}
}