package utils
{
	import flash.geom.Point;
	import flash.utils.Dictionary;
	
	import manager.ActionData;
	import manager.BitmapDataEx;

	/**
	 *  @author yefeng
	 *   @time:2012-4-5下午12:09:09
	 */
	public class MovieDictUtil
	{
		public function MovieDictUtil()
		{
		}
		
		/** 得到某个动作的 序列帧
		 *  dataDict是  dict[action]=new Dictionary() 
		 * 				dict[action][direction]=new Vector.<BitmapDataEx>()  
		 */		
		public static  function GetActionArr(dataDict:Dictionary,action:int):Vector.<BitmapDataEx>
		{
			var dict:Object=dataDict[action];
			var arr:Vector.<BitmapDataEx>=new Vector.<BitmapDataEx>();
			for each (var direct:Vector.<BitmapDataEx> in dict)
			{	
				arr=arr.concat(direct);
/*				for each(var data:BitmapDataEx in direct)
				{
					arr.push(data);
				}
*/			}
			return arr;
		}
		
		
		
		public static  function getAllArr(actionData:ActionData):Vector.<BitmapDataEx>
		{
			var arr:Vector.<BitmapDataEx>=new Vector.<BitmapDataEx>();
			for each (var action:int in actionData.headerData["action"])
			{
				for each (var direction :int in actionData.headerData[action]["direction"])
				{
					arr=arr.concat(actionData.dataDict[action][direction]);
				}
			}
			return arr;
		}
		
		/**得到的索引是总索引 局部索引 用frameIndex
		 */
		public static function  GetIndex(actionData:ActionData,data:BitmapDataEx):Object
		{
			var index:int=-1;
			
			for each (var action:int in actionData.headerData["action"])
			{
				for each (var direction :int in actionData.headerData[action]["direction"])
				{
					for each (var bitmapDataEx:BitmapDataEx in actionData.dataDict[action][direction])
					{
						index++;
						if(bitmapDataEx==data)
						{
							return {index:index,action:action,direction:direction}
						}
					}
				}
			}
			return  null;
		}
		
		
		/**得到 actionData的长度
		 */
		public static function  GetActionDataLen(actionData:ActionData):int
		{
			var index:int=0;
			var len:int;
			for each (var action:int in actionData.headerData["action"])
			{
				for each (var direction :int in actionData.headerData[action]["direction"])
				{
					len=actionData.dataDict[action][direction].length;
					index +=len;
					
/*					for each (var bitmapDataEx:BitmapDataEx in actionData.dataDict[action][direction])
					{
						index++;
					}
*/				}
			}
			return index;
		}
		/**删除bitmapDataEx数据    并且更新该数组的 头部长度 以及数组中的各个索引frameIndex
		 */		
		public static function deleteBitmapDataEx(data:BitmapDataEx,actionData:ActionData):Boolean
		{
			
			var obj:Object=GetIndex(actionData,data);
			if(!obj) return false;
			var vector:Vector.<BitmapDataEx>=actionData.dataDict[obj.action][obj.direction]
			vector.splice(data.frameIndex,1); ///删除 该元素 
			//更新该数组中各个对象的 帧索引
			var len:int=vector.length;
			for(var i:int=0;i!=len;++i)
			{
				vector[i].frameIndex=i;
			}
			
			///更新头部长度 
			if(!actionData.headerData[obj.action][obj.direction]) actionData.headerData[obj.action][obj.direction]={};
			actionData.headerData[obj.action][obj.direction]["len"]=len;
			return true;
		}
		
		
		
		
		
		/** 根据新的引点点来更新所有的坐标信息  difPoint指的是相应的偏移量
		 */		
		public static  function updateActionDataCoordinate(difPoint:Point,actionData:ActionData):void
		{
			var directionLen:int;
			for each (var action:int in actionData.headerData["action"])
			{
				for each (var direction :int in actionData.headerData[action]["direction"])
				{
					directionLen=0;
					for each (var bitmapDataEx:BitmapDataEx in actionData.dataDict[action][direction])
					{
						++directionLen;
						bitmapDataEx.x +=difPoint.x;
						bitmapDataEx.y +=difPoint.y;
					}
					////更新该方向的长度  如果没有长度 则进行添加
					if(!actionData.headerData[action][direction]) actionData.headerData[action][direction]={};
					actionData.headerData[action][direction]["len"]=directionLen;
				}
			}
		}
		
	}
}