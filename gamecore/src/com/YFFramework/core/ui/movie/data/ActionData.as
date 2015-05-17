package com.YFFramework.core.ui.movie.data
{
	import flash.geom.Point;
	import flash.utils.Dictionary;

	/** 动作数据   格式在  ActionDataManager中 
	 *  @author yefeng
	 *   @time:2012-4-5下午04:35:20
	 */
	public class ActionData
	{
		public var headerData:Object;
		public var dataDict:Dictionary;
		public function ActionData()
		{
			headerData={};
			dataDict=new Dictionary();
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
		public function getDirectionData(action:int,direction:int):Vector.<BitmapDataEx>
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
		
		
		/**
		 * @param addedData  要整合进 本类中的信息 假如  本类已经有了某个动作  则不进行整合     只整合本类不存在的动作 
		 * 用途  比如 一个角色的动作 包含 待机  1 2 3 4 5死亡  五个基础动作， 而如果加上了 后来加载进来的 特殊动作   则需要整合后来加载加载进来的特殊动作
		 *  来形成一个新的特殊动作
		 * offsetAction 动作的偏移量  比如  一个 人物 有   1  待机  2 行走   3 攻击 4  受击  5  死亡的的动作   并且 添加的 动作为 坐骑动作 
		 *    addedData  的 1 为坐骑上待机  2 为坐骑上行走   这时候我们需要将 addedData数据 和原来的数据组合成一个新的数据 就需要将 addedData 的动作信息进行偏移
		 *  例如 将 坐骑待机   偏移到   人物的 死亡动作之后    也就是   在 死亡的 后面    即 offset=5    5+ 坐骑上待机 5+坐骑上行走
		 */
		public function addActionData(addedData:ActionData,offsetAction:int=0):void
		{
			var addedActionArr:Array=addedData.getActionArr();
			//当前的动作信息
			var currentActionArr:Array=getActionArr();
			var index:int;
			for each (var action:int in addedActionArr)
			{
				
				action +=offsetAction;
				index=currentActionArr.indexOf(action);
				if(index==-1)//当 本动作数组中不存在该动作    //动作 具有:  动作数组   动作信息  动作帧频      动作方向数组 动作方向长度
				{
					//将该动作存入当前的 动作数组中
					currentActionArr.push(action);
					///存入动作信息
					dataDict[action]=addedData.dataDict[action];
					//动作帧频
					headerData[action]={};
					headerData[action]["frameRate"]=addedData.getFrameRate(action);
					//动作方向  数组
					headerData[action]["direction"]=addedData.getDirectionArr(action);
					// 动作方向长度
					for each (var direction:int in headerData[action]["direction"] ) //动作方向数组中
					{
						headerData[action][direction]={};
						headerData[action][direction]["len"]=dataDict[action][direction].length;
					}
				}
			}
		}
		
		/**删除数据释放图像内存   释放所有数据
		 */		
		public function dispose():void
		{
			deleteAllData();
			remove();
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
			for each (var action:int in headerData["action"])
			{
				for each (var direction :int in headerData[action]["direction"])
				{
					for each (var bitmapDataEx:BitmapDataEx in dataDict[action][direction])
					{
						bitmapDataEx.dispose();
					}
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
		
		
		
		/** 释放 图像像素数据 但是不释放头数据  这种情况 用于 图片影子   角色人物的影子        释放除头以外的所有数据
		 */
		public function disposeBitmapDatas():void
		{
			for each (var action:int in headerData["action"])
			{
				for each (var direction :int in headerData[action]["direction"])
				{
					for each (var bitmapDataEx:BitmapDataEx in dataDict[action][direction])
					{
						bitmapDataEx.dispose();
					}
					dataDict[action][direction]=null;
					delete dataDict[action][direction];
				}
				delete dataDict[action][direction];
				dataDict[action]=null;
				delete dataDict[action];
			}
			//删除引用
			remove();
		}
		
		
	}
}