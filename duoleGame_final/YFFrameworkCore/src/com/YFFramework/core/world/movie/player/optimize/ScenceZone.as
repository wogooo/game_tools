package com.YFFramework.core.world.movie.player.optimize
{
	import com.YFFramework.core.debug.print;
	
	import flash.utils.Dictionary;

	/**屏幕区域  四叉树优化    将屏幕按照 300×300的像素进行切割
	 * 2012-11-2 上午9:29:14
	 *@author yefeng
	 */
	public class ScenceZone
	{
		
		private var _dict:Dictionary;
		/**保存playerView
		 */		
		private var _playerArr:Array;
		public function ScenceZone()
		{
			_dict=new Dictionary();
			_playerArr=[];
		}
		/**注册节点
		 */		
		public function addNode(playerNode:PlayerNode):void
		{
			var player:ZonePlayer;
			if(playerNode.zone&&playerNode.zone!=this)
			{
				playerNode.zone.delNode(playerNode);
				player=playerNode.playerView;
				if(_dict[player.getYF2dID()]==null)
				{
					_dict[player.getYF2dID()]=player;
					_playerArr.push(playerNode.playerView);
				}
				playerNode.zone=this;
			}
			else if(playerNode.zone==null)
			{
				player=playerNode.playerView;
				if(_dict[player.getYF2dID()]==null)
				{
					_dict[player.getYF2dID()]=player;
					_playerArr.push(playerNode.playerView);
				}
				playerNode.zone=this;
			}
		}
		
		/**删除节点
		 */ 
		public function delNode(playerNode:PlayerNode):void
		{
			var player:ZonePlayer=playerNode.playerView;
//			if(_dict[player.getYF2dID()]!=null)
//			{
				var index:int=_playerArr.indexOf(playerNode.playerView);
				if(index!=-1)_playerArr.splice(index,1);
				delete _dict[player.getYF2dID()];
//			}
//			else
//			{
//				print(this,"此处有bug");
//			}
			playerNode.zone=null;
		}
		/**清空所有的数据对象
		 */		
		public function clear():void
		{
			_dict=new Dictionary();
			_playerArr=[];
//			change=false;
		}
		/**  获取数组
		 * @return 
		 */		
		public function getArr():Array
		{
			return _playerArr;
		}
		
		public function getDict():Dictionary
		{
			return _dict;
		}
		/**处理深度排序
		 */		
//		public function handleDeepth(index:int):void
//		{
//			if(change)  ///只有内部发生改变才进行深度排序
//			{
//				//按照 y坐标进行深度排序
//				_playerArr=_playerArr.sort(sortFunc);
//				//开始开始设置深度
//			//	var index:int=0;
//				var __parent:DisplayObjectContainer;
//				for each (var playerView:ZonePlayer in _playerArr)
//				{
//					__parent=playerView.parent;
//					if(__parent)
//					{
//						index=index<__parent.numChildren?index:__parent.numChildren-1;
//						if(__parent.getChildIndex(playerView)!=index) 	__parent.setChildIndex(playerView,index);
//					}
//					++index;
//				}
//			}
//		}
//		
//		private function sortFunc(x:ZonePlayer,y:ZonePlayer):int
//		{
//			if(x.mouseY>y.mouseY) return -1;
//			else if(x.mouseY==y.mouseY) return 0;
//			return 1;
//		}
		
	}
}