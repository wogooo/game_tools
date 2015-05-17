package manager
{
	import flash.display.BlendMode;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;

	/** 动作数据   格式在  ActionDataManager中 
	 *  @author yefeng
	 *   @time:2012-4-5下午04:35:20
	 */
	public class ActionData
	{
		/**
		 * headerData["offsetData"] 判断是否 存在   存在的话就具有 马鞍点信息 就是每个方向  每个动作的偏移量     headData["offsetData"][action][direction][index]={x:x,y:y}
		 */		
		public var headerData:Object;
		public var dataDict:Dictionary;
		
		/** 数据偏移量     坐骑 数据   武器光效 数据  保存在该对象里面  用来 驱动其他对象运动
		 */		

		public function ActionData()
		{
			headerData={};
			dataDict=new Dictionary();
		}
		public function get version():String
		{
			return  String(headerData["version"]);
		}
		
		public function get blood():Object
		{
			return headerData["blood"]; //={x,y}  
		}
		/**渲染模式  
		 */ 
		public function get blendMode():String
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
		 */
		public function addActionData(addedData:ActionData):void
		{
			var addedActionArr:Array=addedData.getActionArr();
			//当前的动作信息
			var currentActionArr:Array=getActionArr();
			var index:int;
			for each (var action:int in addedActionArr)
			{
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
		
		/**将 changeActionData部分动作 代替 sourceActionData的动作
		 * @param sourActionData  源动作
		 * @param changeActionData   局部动作 
		 */		
		public function replaceActionData(changeActionData:ActionData):void
		{
			var addedActionArr:Array=changeActionData.getActionArr();
			//当前的动作信息
			var currentActionArr:Array=getActionArr();
			var index:int;
//			var objBytes:ByteArray;
			for each (var action:int in addedActionArr)
			{
				index=currentActionArr.indexOf(action);
					//将该动作存入当前的 动作数组中
				deleteAction(action);//当 本动作数组中存在该动作    删除该动作
				///添加新资源
				
				var arr:Array=getActionArr();
				if(arr.indexOf(action)==-1) headerData["action"].push(action);

				if(!headerData[action]) 
				{
					headerData[action]=changeActionData.headerData[action];
					
//					objBytes=new ByteArray();
//					objBytes.writeObject(changeActionData.headerData[action]);
//					objBytes.position=0;
//					headerData[action]=objBytes.readObject();
				}
				if(!dataDict[action])
				{
					dataDict[action]=changeActionData.dataDict[action];
//					objBytes=new ByteArray();
//					objBytes.writeObject(changeActionData.dataDict[action]);
//					objBytes.position=0;
//					headerData[action]=objBytes.readObject();
				}
			}
			changeActionData=null;
		}
		/**
		 * @param sourceActionData
		 * @param deleteAction    要删除的动作
		 * 
		 */		
		public function deleteAction(deleteAction:int):void
		{
			//当前的动作信息
			var currentActionArr:Array=getActionArr();
			var index:int=currentActionArr.indexOf(deleteAction);
			if(index!=-1)
			{
				currentActionArr.splice(index,1);
				headerData[deleteAction]=null;
				dataDict[deleteAction]=null;
			}
			delete headerData[deleteAction];
			delete dataDict[deleteAction]
		}

		/**删除动作 
		 * @param exceptAction   不进行删除的 动作数组
		 */
		public function deleteActionExcept(exceptAction:Array):void
		{
			var currentActionArr:Array=getActionArr().concat();
			var index:int;
			for each(var action:int in currentActionArr)
			{
				index=exceptAction.indexOf(action);
				if(index==-1)  //不在排除列表内 可以进行删除
				{
					deleteAction(action);
				}
			}
		}
		
		
		
		
		
		/**删除数据释放图像内存
		 */		
		public function dispose():void
		{
			deleteAllData();
			headerData=null;
			dataDict=null;
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
		
		/**是否具有坐骑、光效等便宜点信息
		 */		
		public function hasOffsetData():Boolean
		{
			if(headerData["offsetData"]) return true;
			return false;
		}
		
		
		
		/** 获取  待机  行走 数据包
		 */
//		public function getStandAWalkAction():ActionData
//		{
//			var head:Object=copyHead();
//			
//			var actionArr:Array=head["action"];
//			
//			//当前的动作信息
//			var index:int=actionArr.indexOf(deleteAction);
//			if(index!=-1)
//			{
//				currentActionArr.splice(index,1);
//				headerData[deleteAction]=null;
//				dataDict[deleteAction]=null;
//			}
//			delete headerData[deleteAction];
//			delete dataDict[deleteAction]
//		}
//		/** 获取攻击动作数据包
//		 */
//		public function getAtkAction():ActionData
//		{
//			
//		}
//		
//		/**  获取受击 死亡 数据包  有 死亡则有没有则没有
//		 */
//		public function getHurtDeadAction():ActionData
//		{
//			
//		}

		
		/**拷贝头数据
		 */
//		private function  copyHead():Object
//		{
//			var myBytes:ByteArray=new ByteArray();
//			myBytes.writeObject(headerData);
//			myBytes.position=0;
//			var myHead:Object=myBytes.readObject();
//			return myHead;
//		}
		
	}
}