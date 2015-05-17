package manager
{
	import flash.utils.Dictionary;
	
	import utils.CommonUtil;

	/**
	 *  @author yefeng
	 *   @time:2012-4-5下午04:37:33
	 */
	public class ActionDataManager
	{
		
		public static const FrameRate:int=100;///默认帧频
		
		public function ActionDataManager()
		{
		}
		
	
		
		
		/**  actionData.headerData还具有血条数据 x y 和版本号码 version     actionData.headerData["blood"] ={x,y}  
		 * actionData.headerData["version"]  =""   actionData.headerData[action][direction]["len"]=directionLen;  //方向长度 
		 * 											actionData.headerData[action][direction]={}
		 *actionData.headerData[action][direction]["data"]=Vector.<BitmapDataExData>  是中间量  无需关注
		 * 
		 */		
		public static  function fillData (actionData:ActionData,url:String,myData:BitmapDataEx):Boolean
		{
			var vect:Vector.<int>=CommonUtil.GetURLData(url);
			var action:int=vect[0];
			var direction:int=vect[1];
			var frame:int=vect[2];
			if(!actionData.headerData["action"])	actionData.headerData["action"]=[];///动作数组
			if(!actionData.dataDict[action])  
			{
				actionData.dataDict[action]=new Dictionary();   //动作
				actionData.headerData["action"].push(action);
				actionData.headerData[action]={};
				actionData.headerData[action]["frameRate"]=FrameRate;
				if(!actionData.headerData[action]["direction"]) actionData.headerData[action]["direction"]=[];//方向数组
			}
			if(!actionData.dataDict[action][direction]) 
			{
				actionData.dataDict[action][direction]=new Vector.<BitmapDataEx>() //方向
				
				actionData.headerData[action]["direction"].push(direction);///方向保存
			}
			var len:int=actionData.dataDict[action][direction].length;
			myData.frameIndex=len;
			var canPush :Boolean = false;
			if (len==0)
			{
				canPush = true;
			}
			else 
			{   
				var preBitmapDataEx:BitmapDataEx =  actionData.dataDict[action][direction][len-1] as BitmapDataEx;
				//如果2 张图片相同 则应该去掉 相同图片
				if(ImageCheckUtil.checkSame(myData.bitmapData,preBitmapDataEx.bitmapData))
				{ //图片相同
					canPush = false;
					preBitmapDataEx.delay = preBitmapDataEx.delay + myData.delay;
				}
				else 
				{
					canPush = true;	
				}
			}
			if (canPush)
			{
				actionData.dataDict[action][direction].push(myData);
				return true;
			}
			
			return false;
		}
	}
}