package
{
	
	/**
	 *   主角人物行走 
	 *    神剑 格式  
	 *    1   方向<5>    2 帧   待机
	 * 	  2  方向<5> 6帧   行走
	 * 	  3  方向<5>  3帧  受击
	 *    4 方向<5> 1 帧    打坐 
	 *    5  方向 <1>   5帧  ///死亡
	 *    6  方向 <5>   8帧     //攻击
	 * 
	 * 
	 * 坐骑文件  
	 *  
	 * 1   方向<5>    2 帧   待机
	 *  2  方向<5> 6帧   行走
	 *    3  方向<5>  3帧  受击
	 *   4  方向 <5>   8帧     //攻击
	 * 
	 * 飞跳   
	 *   1  方向 <5>  六帧
	 */	
	import com.YFFramework.core.ui.movie.data.TypeAction;
	
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.geom.Matrix;

	/**   将4399  远古封神 英雄远征等游戏转化为序列帧   然后再旋转图片方向
	 * 
	 * 2012-7-24 下午12:35:03
	 *@author yefeng
	 */
	public class CovertFileManager
	{
		public function CovertFileManager()
		{
		}
		
		/** 神剑转化
		 * @param mc
		 * @param isPlayer
		 * @return 
		 */		
		public static function convertSWFToPNGSequence(mc:MovieClip,isPlayer:Boolean=true):Vector.<BitmapDataName>
		{  
			
			var px:int=-200;
			var py:int=-200;
			var width:int=600;
			var height:int=600;
			var len:int=mc.totalFrames;
			var data:BitmapDataName;
			var mat:Matrix=new Matrix();
			mat.tx=-px;
			mat.ty=-py;
			var direction:int;
			var myName:String;
			var myIndex:int=0;
			var arr:Vector.<BitmapDataName>=new Vector.<BitmapDataName>();
			var j:int;
			for(var i:int=1;i<=len;++i)
			{
				mc.gotoAndStop(i);
				myIndex++;
				j=i-1;
				if(isPlayer)
				{
					if(j>=0&&j<10)   // action    ==  1
					{
						direction=int(j/2)+1;
						direction=6-direction;
						myName="1-"+direction+"-"+myIndex
					}
					else if(j>=10&&j<50)   ///   2
					{
						direction=int((j-10)/8)+1;
						direction=6-direction;
						myName="2-"+direction+"-"+myIndex
					}
					else if(j>=50&&j<90)  //3 
					{
						direction=int((j-50)/8)+1;
						direction=6-direction;
						myName="3-"+direction+"-"+myIndex
						
					}
					else if(j>=90&&j<110)   ///4
					{
						direction=int((j-90)/4)+1;
						direction=6-direction;
						myName="4-"+direction+"-"+myIndex
						
					}
					     
					else if(j>=110&&j<130)///5
					{
						direction=int((j-110)/4)+1;
						direction=6-direction;
						myName="5-"+direction+"-"+myIndex
						
					}
					    
					else if(j>=130&&j<140)////6
					{
						direction=int((j-130)/2)+1;
						direction=6-direction;
						myName="6-"+direction+"-"+myIndex
						
					}
					    
					else if(j>=140&&j<145)///7
					{
						direction=int((j-140)/1)+1;
						direction=6-direction;
						myName="7-"+direction+"-"+myIndex
						
					}
					  
					else if(j>=145&&j<150)///8
					{
						direction=int((j-145)/1)+1;
						direction=6-direction;
						myName="8-"+direction+"-"+myIndex
					}
				}
				else 
				{
					myName="1-1-"+myIndex.toString();
				}
				
				
				
				data=new BitmapDataName(width,height,true,0xFFFFFF);
				data.draw(mc,mat);
				data.name=myName
				arr.push(data);
			}
			return arr;
		}
		
		
		
		/** 转化坐骑 swf 为程序需要的数据文件
		 */
		public static function converMountSWFToPNGSequence(mc:MovieClip):Vector.<BitmapDataName>
		{
			var px:int=-200;
			var py:int=-200;
			var width:int=600;
			var height:int=600;
			var len:int=mc.totalFrames;
			var data:BitmapDataName;
			var mat:Matrix=new Matrix();
			mat.tx=-px;
			mat.ty=-py;
			var direction:int;
			var myName:String;
			var myIndex:int=0;
			var arr:Vector.<BitmapDataName>=new Vector.<BitmapDataName>();
			var j:int;
			for(var i:int=1;i<=len;++i)
			{
				mc.gotoAndStop(i);
				myIndex++;
				j=i-1;
				if(j>=0&&j<10)   // action    ==  1
				{
					direction=int(j/2)+1;
					direction=6-direction;
					myName=TypeAction.Stand+"-"+direction+"-"+myIndex
				}
				else if(j>=10&&j<50)   ///   2
				{
					direction=int((j-10)/8)+1;
					direction=6-direction;
					myName=TypeAction.Walk+"-"+direction+"-"+myIndex
				}
				data=new BitmapDataName(width,height,true,0xFFFFFF);
				data.draw(mc,mat);
				data.name=myName
				arr.push(data);
			}
			return arr;
		}
		
		
		
		
		
		
		
		/**  将图片按照Y轴方向翻转
		 */
		public static function flipYPic(data:BitmapDataName):BitmapDataName
		{
			var mat:Matrix=new Matrix();
			mat.scale(-1,1);
			mat.tx=data.width;
			var bitmapDataName:BitmapDataName=new BitmapDataName(data.width,data.height,true,0xFFFFFF);
			bitmapDataName.draw(data,mat);
			bitmapDataName.name=data.name;
			data.dispose();
			return bitmapDataName;
		}
		
	}
}