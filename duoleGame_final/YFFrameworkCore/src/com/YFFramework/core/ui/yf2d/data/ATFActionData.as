package com.YFFramework.core.ui.yf2d.data 
{
	import com.YFFramework.core.yf2d.display.BlendMode;
	
	import flash.utils.Dictionary;
	
	public class ATFActionData
	{
		/**
		 * headerData["offsetData"] 判断是否 存在   存在的话就具有 马鞍点信息 就是每个方向  每个动作的偏移量     headData["offsetData"][action][direction][index]={x:x,y:y}
		 */		
		public var headerData:Object;////数据  和 ActionData的数据一样
		public var dataDict:Dictionary; ///  播放数据 [action][direciton]=movieData
		
		
		/**是否进行了坐标偏移转化
		 */		
		private var _isDoOffset:Boolean;
		
		private var _isDispose:Boolean=false;
		
		public function ATFActionData()
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
		/**渲染模式  
		 */ 
		public function getBlendMode():String
		{
			var str:String=BlendMode.NORMAL;
			if(headerData["blendMode"])str=headerData["blendMode"];
			return str;
		}
		
		/**技能是否随机旋转， 打在人身上的技能是否随机旋转
		 */		
		public function getSkillRandomRotate():Boolean
		{
			if(headerData["skillRotate"])	return true;
			return false;
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
		public function getDirectionData(action:int,direction:int):ATFMovieData
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
		
		/** 是否是大翅膀 坐骑 用于调节层级关系  带翅膀煽动的坐骑 和不待翅膀的   比如 马类型的 坐骑   的人物层级处理关系不一样
		 */
		public function isWingMount():Boolean
		{
			var isWing:Boolean=false;
			if(headerData["isWingMount"])
			{
				isWing=headerData["isWingMount"]
			}
			return isWing
		}
		
		/**循环次数
		 */
		public function getLoopTime():int
		{
			var time:int=1;
			if(headerData["loopTime"])
			{
				time=headerData["loopTime"];
			}
			return time;
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
			var movieData:ATFMovieData;
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
		
		/**释放所有的贴图 但是资源不释放  只是释放贴图  防止贴图不够用
		 */		
		public function deleteAllTexture():void
		{
			var movieData:ATFMovieData;
			for each (var action:int in headerData["action"])
			{
				for each (var direction :int in headerData[action]["direction"])
				{
					movieData=dataDict[action][direction];
					movieData.disposeTexture();
				}
			}
		}
		
		/**
		 * @param actionData   是否可用
		 * 返回该数据是否可用
		 */		
		public static function isUsableActionData(actionData:ATFActionData):Boolean
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
		/**获取偏移量
		 */		
		public function getOffsetData():Object
		{
			return headerData["offsetData"];
		}
	}
}