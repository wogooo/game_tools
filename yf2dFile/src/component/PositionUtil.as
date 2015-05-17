package component
{
	import component.manager.RectData;
	
	import manager.ActionData;
	import manager.BitmapDataEx;
	
	import mx.controls.Alert;
	
	import utils.ActionUtil;

	/**@author yefeng
	 *20122012-4-12下午10:27:12
	 */
	public class PositionUtil
	{
		public function PositionUtil()
		{
		}
		public static function positionActionData(actionData:ActionData,action:int,direction:int,container:ActionContainer,sizeW:int=2048,sizeH:int=2048,color:uint=0xFFFFF):void
		{
			container.removeAllContent();
			container.drawBg(color,sizeW,sizeH);
			var space:int=2;
			var lastX:int=space,lastY:int=space,maxY:int=space;
			var image:ImageEx;
			var rectData:RectData;
			var frameIndex:int;
			var actionIndex:int=0;
			var notMuch:Boolean=false;
			frameIndex=0;
			for each (var bitmapDataEx:BitmapDataEx in actionData.dataDict[action][direction])
			{
				rectData=new RectData();
				rectData.x=bitmapDataEx.x;
				rectData.y=bitmapDataEx.y;
				rectData.bitmapData=bitmapDataEx.bitmapData;
				rectData.rect.width=bitmapDataEx.bitmapData.width;
				rectData.rect.height=bitmapDataEx.bitmapData.height;
				rectData.frameIndex=frameIndex;
				rectData.delay=bitmapDataEx.delay;
				rectData.action=action;
				rectData.direction=direction;
				image=new ImageEx();
				image.source=rectData;
				container.addContent(image);
				if(lastX+image.width>sizeW)
				{
					lastX=space;
					lastY=maxY;
				}
				if((lastY+image.height>sizeH)||(lastX+image.width>sizeW)) 
				{
					//	Alert.show("位置不够，请分多张使用");
					notMuch=true;
				}
				
				image.x=lastX;
				image.y=lastY;
				maxY=Math.max(image.y+image.height+space,maxY);
				lastX +=image.width+space;
				++frameIndex;
				
				if(lastY>sizeH) 
				{
					//	Alert.show("位置不够，请分多张使用");
					notMuch=true;
					break;
				}
				
				
			}
			if(notMuch)	Alert.show(ActionUtil.GetActionName(action)+"  的位置不够，请分多张使用");
		}
		
		
		
		
		private static function positionActionData2(actionData:ActionData,action:int,direction:int,container:ActionContainer,sizeW:int=2048,sizeH:int=2048,color:uint=0xFFFFF):Boolean
		{
			container.removeAllContent();
			container.drawBg(color,sizeW,sizeH);
			var space:int=2;
			var lastX:int=space,lastY:int=space,maxY:int=space;
			var image:ImageEx;
			var rectData:RectData;
			var frameIndex:int;
			var actionIndex:int=0;
			var notMuch:Boolean=false;
			frameIndex=0;
			for each (var bitmapDataEx:BitmapDataEx in actionData.dataDict[action][direction])
			{
				rectData=new RectData();
				rectData.x=bitmapDataEx.x;
				rectData.y=bitmapDataEx.y;
				rectData.bitmapData=bitmapDataEx.bitmapData;
				rectData.rect.width=bitmapDataEx.bitmapData.width;
				rectData.rect.height=bitmapDataEx.bitmapData.height;
				rectData.frameIndex=frameIndex;
				rectData.delay=bitmapDataEx.delay;
				rectData.action=action;
				rectData.direction=direction;
				image=new ImageEx();
				image.source=rectData;
				container.addContent(image);
				if(lastX+image.width>sizeW)
				{
					lastX=space;
					lastY=maxY;
				}
				if((lastY+image.height>sizeH)||(lastX+image.width>sizeW)) 
				{
					//	Alert.show("位置不够，请分多张使用");
					notMuch=true;
				}
				
				image.x=lastX;
				image.y=lastY;
				maxY=Math.max(image.y+image.height+space,maxY);
				lastX +=image.width+space;
				++frameIndex;
				
				if(lastY>sizeH) 
				{
					//	Alert.show("位置不够，请分多张使用");
					notMuch=true;
					break;
				}
				
				
			}
			return notMuch;
		}
		
		
		
		
		/** 自动展UI 
		 */
		public static function positionActionDataAuto(actionData:ActionData,action:int,direction:int,container:ActionContainer,color:int):void
		{
			var preW:int=2048;
			var preH:int=2048;
			var notMuch:Boolean=false;
			
			//处理高度
			while(notMuch==false&&preW>=2&&preH>=2)
			{
				notMuch=positionActionData2(actionData,action,direction,container,preW,preH,color);
				if(notMuch==false)
				{
					preH =preH/2;
				}
			}
			preH=preH*2;
			if(preH>2048)preH=2048
			notMuch=false;
			//处理 宽度
			while(notMuch==false&&preW>=2&&preH>=2)
			{
				notMuch=positionActionData2(actionData,action,direction,container,preW,preH,color);
				if(notMuch==false)
				{
					preW =preW/2;
				}
			}
			preW=preW*2;
			if(preW>2048)preW=2048;
			positionActionData2(actionData,action,direction,container,preW,preH,color)
		}

		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		

		
		
		
		
	}
}