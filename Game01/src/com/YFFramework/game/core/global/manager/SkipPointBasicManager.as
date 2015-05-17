package com.YFFramework.game.core.global.manager
{
	import com.YFFramework.game.core.global.model.SkipPointBasicVo;
	
	import flash.utils.Dictionary;

	/**地图跳转点信息 skipPoint.json
	 * 2012-11-13 下午5:12:53
	 *@author yefeng
	 */
	public class SkipPointBasicManager
	{
		
		private static var _instance:SkipPointBasicManager;
		
		private var _dict:Dictionary;
		public function SkipPointBasicManager()
		{
			_dict=new Dictionary();
		}
		public static function get Instance():SkipPointBasicManager
		{
			if(_instance==null) _instance=new SkipPointBasicManager();
			return _instance;
		}
		
		public function cacheData(obj:Object):void
		{
			 var id :int;
			 var skipPointBasicVo:SkipPointBasicVo;
			 var mapDict:Dictionary;
			 for (var idStr:String in obj)
			 {
				 id=int(idStr);
				 skipPointBasicVo=new SkipPointBasicVo();
				 skipPointBasicVo.id=id;
				 skipPointBasicVo.left=obj[id].left;
				 skipPointBasicVo.right=obj[id].right;
				 skipPointBasicVo.top=obj[id].top;
				 skipPointBasicVo.bottom=obj[id].bottom;
				 skipPointBasicVo.mapId=obj[id].mapId;
				 skipPointBasicVo.otherMapId=obj[id].otherMapId;
				 skipPointBasicVo.otherMapX=obj[id].otherMapX;
				 skipPointBasicVo.otherMapY=obj[id].otherMapY;
				 
				 mapDict=_dict[skipPointBasicVo.mapId];
				 if(mapDict==null)
				 {
					 mapDict=new Dictionary();
					 _dict[skipPointBasicVo.mapId]=mapDict;
				 }
				 mapDict[skipPointBasicVo.id]=skipPointBasicVo;
			 }
		}
		
//		public function getSkipPointBasicVo(mapId:int):SkipPointBasicVo
//		{
//			var mapDict:Dictionary=_dict[mapId];
//		}
		
		
		/** return  role should  walk  map Id 
		 *   跨地图寻路  返回  一系列 的地图id   比如 从  A->B->c  从A 到 c   人物在 A地图 最终返回的 的数组是   [B,C] 返回 BC 的地图id 信息 [{x,y,nextMapId},....]
		 */		
		public function getMapIdArr(nowMapId:int,seachId:int):Array
		{
			var myDict:Dictionary=_dict[nowMapId];
			var node:SeachNode=seachMapId(myDict,seachId);
			var arr:Array=idArrHandle(node);//[{x,y,nextMapId},....]
			return arr;
		}
		private function idArrHandle(node:SeachNode):Array
		{
			var arr:Array=[];   ///  x  ,y  nexMapId
			var len:int=0;
			while(node)
			{
				arr.unshift(node.mapId);
				node=node.parent;
				++len;
			}
			var nowMapId:int;
			var nextMapId:int;
			var temp:Dictionary;
			var returnArr:Array=[];
			for (var i:int=0;i!=len;++i)
			{
				if(i+1<len)
				{
					nowMapId=arr[i];
					nextMapId=arr[i+1];
					temp=_dict[nowMapId];
					for each(var skipPositionVo:SkipPointBasicVo in temp)
					{
						if(skipPositionVo.otherMapId==nextMapId)
						{
							returnArr.push({x:skipPositionVo.mapX,y:skipPositionVo.mapY,nextMapId:skipPositionVo.otherMapId});
							break;
						}
					}
				}
			}
			return returnArr;
		}

		private function seachMapId(myDict:Dictionary,seachId:int,parent:SeachNode=null):SeachNode
		{
			var tempDic:Dictionary;
			var node:SeachNode;
			var parentNode:SeachNode;
			for each(var skipPointBasicVo:SkipPointBasicVo in myDict)
			{
				parentNode=new SeachNode(skipPointBasicVo.mapId);
				parentNode.parent=parent;
				node=new SeachNode(skipPointBasicVo.otherMapId);
				node.parent=parentNode;
				if(skipPointBasicVo.otherMapId==seachId)
				{
					return node;
				}
				else 
				{
					tempDic=_dict[skipPointBasicVo.otherMapId];
					seachMapId(tempDic,seachId,node);  //// node  
				}
			}
			return null;
		}
		
		
	}
}
import com.YFFramework.game.core.global.model.SkipPointBasicVo;

class SeachNode
{
	public var mapId:int;
	public var parent:SeachNode;
	public function SeachNode(mapId:int,parent:SeachNode=null)
	{
		this.mapId=mapId;
		this.parent=parent;
	}

}