package com.YFFramework.core.ui.yf2d.data
{
	import flash.utils.Dictionary;

	/**@author yefeng
	 *20122012-11-17下午7:01:01
	 */
	public class YF2dActionData
	{
		/**
		 * headerData["offsetData"] 判断是否 存在   存在的话就具有 马鞍点信息 就是每个方向  每个动作的偏移量     headData["offsetData"][action][direction][index]={x:x,y:y}
		 */		
		public var headerData:Object;////数据  和 ActionData的数据一样
		public var dataDict:Dictionary; ///  播放数据 [action][direciton]=movieData
		private var _isDispose:Boolean=false;

		public function YF2dActionData()
		{
			headerData={};
			dataDict=new Dictionary();
			_isDispose=false;
		}
		
		public function getVersion():String
		{
			return  String(headerData["version"]);
		}
		
		public function getBlood():Object
		{
			return headerData["blood"]; //={x,y}  
		}
		
		public function getDirectionLen(action:int,direction:int):int
		{
			return int(headerData[action][direction]["len"]);
		}
		public function getFrameRate(action:int):int
		{
			return headerData[action]["frameRate"];
		}
		
		
		/**得到该方向的数据信息
		 */
		public function getDirectionData(action:int,direction:int):MovieData
		{
			return dataDict[action][direction];
		}
		/**得到动作数字   1  2   3   4    5 
		 */
		public function getActionArr():Array
		{
			return headerData["action"];
		}
		/**得到方向数字   1  2   3   4    5 
		 */
		
		public function getDirectionArr(action:int):Array
		{
			return headerData[action]["direction"];
		}

		
		/**删除数据释放图像内存   释放所有数据
		 */		
		public function dispose():void
		{
			deleteAllData();
			remove();
			_isDispose=true;
		}
		/**是否释放内存
		 */		
		public function get isDispose():Boolean
		{
			return _isDispose;
		}
		/**删除引用  不释放图像内存
		 */		
		public function remove():void
		{
			headerData=null;
			dataDict=null;
		}
		
		
		private function deleteAllData():void
		{
			var movieData:MovieData;
			for each (var action:int in headerData["action"])
			{
				for each (var direction :int in headerData[action]["direction"])
				{
					movieData=dataDict[action][direction];
					movieData.dispose();
					dataDict[action][direction]=null;
					delete dataDict[action][direction];
				}
				headerData[action]["direction"]=null;
				delete dataDict[action][direction];
				dataDict[action]=null;
				delete dataDict[action];
			}
			headerData["action"]=null;
			delete headerData["action"];
		}
		/**
		 * @param actionData   是否可用
		 * 返回该数据是否可用
		 */		
		public static function isUsableActionData(actionData:YF2dActionData):Boolean
		{
			if(actionData)
			{
				if(!actionData.isDispose) return true;
			}
			return false;
		}
		/**是否具有坐骑、光效等便宜点信息
		 */		
		public function hasOffsetData():Boolean
		{
			if(headerData["offsetData"]) return true;
			return false;
		}

		
		
		
		
	}
}