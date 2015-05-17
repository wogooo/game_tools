package manager.UV
{
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	
	import manager.ActionData;
	import manager.BitmapDataEx;
	
	import spark.primitives.Rect;
	

	/**@author yefeng
	 *20122012-4-12下午10:27:12
	 */
	public class PositionUtil
	{
		public function PositionUtil()
		{
		}
		
		/** 自动展UI   所有动作方向展到1 张图片上  用于js 
		 */
		public static function positionActionDataAuto3(headerObj:Object,actionData:ActionData,container:ActionContainer):void
		{
			var preW:int=2048;
			var preH:int=2048;
			var notMuch:Boolean=false;
			//处理高度
			while(notMuch==false&&preW>=2&&preH>=2)
			{
				notMuch=positionActionData4(headerObj,actionData,container,preW,preH);
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
				notMuch=positionActionData4(headerObj,actionData,container,preW,preH);
				if(notMuch==false)
				{
					preW =preW/2;
				}
			}
			preW=preW*2;
			if(preW>2048)preW=2048;
			positionActionData4(headerObj,actionData,container,preW,preH)
		}
		
		//最小放置图片,所有动作方向展到1张图片上  js 引擎用到
		private static function positionActionData4(headerObj:Object,actionData:ActionData,container:ActionContainer,sizeW:int=2048,sizeH:int=2048,color:uint=0xFFFF00):Boolean
		{
			container.removeAllContent();
			container.drawBg(color,sizeW,sizeH);
			var space:int=2;
			var lastX:int=space,lastY:int=space,maxY:int=space;
			var image:ImageEx;
			var rectData:RectData;
			var frameIndex:int;
//			var actionIndex:int=0;
			
			var vect:Vector.<ImageEx> = new Vector.<ImageEx>();
			
			for each(var action:int in actionData.getActionArr())
			{
				for each(var direction:int in actionData.getDirectionArr(action) )
				{
					frameIndex=0;
					var len:int = actionData.dataDict[action][direction].length;
				//	for each (var bitmapDataEx:BitmapDataEx in actionData.dataDict[action][direction])
					for(var i:int = 0;i!=len;++i)
					{
						var bitmapDataEx:BitmapDataEx = actionData.dataDict[action][direction][i];
						
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
						rectData.area =  rectData.rect.width * rectData.rect.height;
						image=new ImageEx();
						image.source=rectData;
						++frameIndex;
						image.atlas={};
						image.atlas.width = bitmapDataEx.bitmapData.width;
						image.atlas.height = bitmapDataEx.bitmapData.height;
						image.atlas.area = image.atlas.width*image.atlas.height;
						image.atlas.imageData = headerObj[action][direction]["data"][i];
						vect.push(image);
					}
				}
			}
			
			//对arr数组进行  排序  
			vect = vect.sort(sortFunc);
			return postionData(vect,container,sizeW,sizeH);
			
		}
		
		//最小放置图片 单一方向展UV  一个动作 一个方向 一张图片  header将要修改的header
		private static function positionActionData3(headerObj:Object,actionData:ActionData,action:int,direction:int,container:ActionContainer,sizeW:int=2048,sizeH:int=2048,color:uint=0xFFFF00):Boolean
		{
			container.removeAllContent();
			container.drawBg(color,sizeW,sizeH);
			var space:int=2;
			var lastX:int=space,lastY:int=space,maxY:int=space;
			var image:ImageEx;
			var rectData:RectData;
			var frameIndex:int;
//			var actionIndex:int=0;
			frameIndex=0;
			var vect:Vector.<ImageEx> = new Vector.<ImageEx>();
			var myIndex:int =0;
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
				rectData.area =  rectData.rect.width * rectData.rect.height;
				++frameIndex;

				image=new ImageEx();
				image.source = rectData;
				image.atlas={};
				image.atlas.width = bitmapDataEx.bitmapData.width;
				image.atlas.height = bitmapDataEx.bitmapData.height;
				image.atlas.area = image.atlas.width*image.atlas.height;
				image.atlas.imageData = headerObj[action][direction]["data"][myIndex];

				vect.push(image);
				myIndex++;
			}
			//对arr数组进行  排序  
			vect = vect.sort(sortFunc); 
			
			return postionData(vect,container,sizeW,sizeH);
			
		}
		
		
		//获取最小有用的rect
		private static function getValidRect(currentRect:Rectangle,rectArr:Array):Rectangle
		{
			var insect:Boolean = false;
			var loop:Boolean = true;
			while(loop)
			{
				insect = false;
				for each(var rect:Rectangle in rectArr)
				{
					if (rect.intersects(currentRect))
					{
						insect = true;
						break;
					}
				}
				if (insect)
				{
					currentRect.y +=2;
				}
				else 
				{
					loop = false;
				}
			}
			return currentRect;
		}
		//智能 高级展UV,最小展UV  一个动作一个方向 1张图片
		private static function postionData(vect:Vector.<ImageEx>,container:ActionContainer,sizeW:int=2048,sizeH:int=2048):Boolean
		{
			var space:int=2;
			var lastX:int=space,minY:int=space;
			var len:int = vect.length;
			var notMuch:Boolean=false;
			var rectArr:Array =[];
			for(var i:int = 0 ;i!=len;++i)
			{
				var image:ImageEx = vect[i];
				container.addContent(image);
				
				if(lastX+image.width>sizeW)
				{
					lastX=space;
				}
				var rect:Rectangle=new Rectangle(lastX,minY,image.width,image.height);
				
				rect=getValidRect(rect,rectArr); //获取能够放置的位置
				if(rect.y+rect.height>sizeH)
				{
					notMuch = true;
					return notMuch;
				}
				image.x = rect.x;
				image.y = rect.y;
				minY=rect.y;
				lastX +=image.width+space;
				rectArr.push(rect);
				image.atlas.imageData.atlasX=image.x;
				image.atlas.imageData.atlasY=image.y;
			}
			return notMuch;
		}
		
		/** 自动展UI   一个方向 一张图片
		 */
		public static function positionActionDataAuto2(headerObj:Object,actionData:ActionData,action:int,direction:int,container:ActionContainer):void
		{
			var preW:int=2048;
			var preH:int=2048;
			var notMuch:Boolean=false;
			
			//处理高度
			while(notMuch==false&&preW>=2&&preH>=2)
			{
				notMuch=positionActionData3(headerObj,actionData,action,direction,container,preW,preH);
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
				notMuch=positionActionData3(headerObj,actionData,action,direction,container,preW,preH);
				if(notMuch==false)
				{
					preW =preW/2;
				}
			}
			preW=preW*2;
			if(preW>2048)preW=2048;
			positionActionData3(headerObj,actionData,action,direction,container,preW,preH)
		}
		
		
		private static function sortFunc(image1:ImageEx,image2:ImageEx):Number
		{
			if (image1.atlas.area > image2.atlas.area)
			{
				return 1;
			}
			else if (image1.atlas.area < image2.atlas.area)
			{
				return -1;
			}
			else 
			{
				if(image1.atlas.height<image2.atlas.height)
				{
					return -1;
				}
				else if(image1.atlas.height>image2.atlas.height)
				{
					return 1;
				}
				else 
				{
					return 0 ;
				}
				
			}
		}
		
		
		
		
		
		private static function positionActionData2(actionData:ActionData,action:int,direction:int,container:ActionContainer,sizeW:int=2048,sizeH:int=2048,color:uint=0xFFFF00):Boolean
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
		
		
		
		
		/** 自动展UI  一个方向 一张图片
		 */
		public static function positionActionDataAuto(actionData:ActionData,action:int,direction:int,container:ActionContainer):void
		{
			var preW:int=2048;
			var preH:int=2048;
			var notMuch:Boolean=false;
			
			//处理高度
			while(notMuch==false&&preW>=2&&preH>=2)
			{
				notMuch=positionActionData2(actionData,action,direction,container,preW,preH);
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
				notMuch=positionActionData2(actionData,action,direction,container,preW,preH);
				if(notMuch==false)
				{
					preW =preW/2;
				}
			}
			preW=preW*2;
			if(preW>2048)preW=2048;
			positionActionData2(actionData,action,direction,container,preW,preH)
		}

	}
}