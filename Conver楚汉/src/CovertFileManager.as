package
{
	
	/**
	 * 
	 *   楚汉 格式      方向 顺序     顺序     1  --5----3---2--------4   不用进行翻转 
	 *    1   方向<5>    2 帧      待机          <1---------10>
	 * 		2  方向<5> 8帧  攻击               <11--------50>
	 * 	3  方向<5>  8帧      行走            <51-------90>
	 *  4方向<5> 4帧          受击          <91---------110>
	 * 5 方向   <1 > 4帧   死亡
	 * 
	 * 
	 * 
	 * 打坐文件  
	 *   1   方向<5> 4帧             
	 * 
	 * 
	 * 坐骑文件
	 * 
	 *    1    方向 <5>   待机                  2帧   <1------------10>
	 *   2  方向  <8>  行走               8帧 <11---------50>
	 *   
	 * 
	 * 
	 * 
	 * 
	 * 
	 * 
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
		
		/** 楚汉转化  转化  行走文件
		 * @param mc
		 * @param isPlayer  如果是角色 则按照角色进行转化 否则按照技能命名进行转化
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
			var action:int;
			var arr:Vector.<BitmapDataName>=new Vector.<BitmapDataName>();
			var j:int;
			for(var i:int=1;i<=len;++i)
			{
				mc.gotoAndStop(i);
				myIndex++;
				j=i-1;
				if(isPlayer)
				{   ////    1  --5----3---2--------4
					if(j>=0&&j<10)   // action    ==  1   待机 
					{
						direction=int(j/2)+1;
						direction=6-direction;   ///5
						action=1;
						
				//		myName="1-"+direction+"-"+myIndex
					}
					else if(j>=10&&j<50)   ///   3    攻击
					{
						direction=int((j-10)/8)+1;
						direction=6-direction;  //4
						action=3;
				//		myName="3-"+direction+"-"+myIndex
					}
					else if(j>=50&&j<90)  //2   行走
					{
						direction=int((j-50)/8)+1;
						direction=6-direction;///3
						action=2;
				//		myName="2-"+direction+"-"+myIndex
						
					}
					else if(j>=90&&j<110)   ///4    受击
					{
						direction=int((j-90)/4)+1;
						direction=6-direction;///2
						action=4;
				//		myName="4-"+direction+"-"+myIndex
						
					}
					     
					else if(j>=110&&j<len)///5  死亡  1  帧
					{
						direction=int((j-110)/4)+1;
						direction=6-direction;///1
						action=5;
						
					}
					///转化为  楚汉的方向
					switch(direction)
					{
						case 1:
							direction=4;
							break;
						case 2:
							direction=2;
							break;
						case 3:
							direction=3;
							break;
						case 4:
							direction=5;
							break;
						case 5:
							direction=1;
							break;
					}
					
					myName=action+"-"+direction+"-"+myIndex
				}
				else 
				{
					var myStr:String=myIndex.toString();
					if(myStr.length==1) myStr ="0"+myStr
					myName="1-1-"+myStr;
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
			var action:int;
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
					action=TypeAction.Stand;
				//	myName=TypeAction.Stand+"-"+direction+"-"+myIndex
				}
				else if(j>=10&&j<50)   ///   2
				{
					direction=int((j-10)/8)+1;
					direction=6-direction;
					action=TypeAction.Walk;
			//		myName=TypeAction.Walk+"-"+direction+"-"+myIndex
				}
				
				///转化为  楚汉的方向
				switch(direction)
				{
					case 1:
						direction=4;
						break;
					case 2:
						direction=2;
						break;
					case 3:
						direction=3;
						break;
					case 4:
						direction=5;
						break;
					case 5:
						direction=1;
						break;
				}

				myName=action+"-"+direction+"-"+myIndex
				data=new BitmapDataName(width,height,true,0xFFFFFF);
				data.draw(mc,mat);
				data.name=myName
				arr.push(data);
			}
			return arr;
		}
		
		
		
		/**
		 *转化打坐文件 
		 */		
		public static function convertSitSWF(mc:MovieClip):Vector.<BitmapDataName>
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
			var action:int;
			var myName:String;
			var myIndex:int=0;
			var arr:Vector.<BitmapDataName>=new Vector.<BitmapDataName>();
			var j:int;
			for(var i:int=1;i<=len;++i)
			{
				mc.gotoAndStop(i);
				myIndex++;
				j=i-1;
				
				direction=int(j/4)+1;
				direction=6-direction;
			//	action=TypeAction.Sit;
				action=1;
				///转化为  楚汉的方向
				switch(direction)
				{
					case 1:
						direction=4;
						break;
					case 2:
						direction=2;
						break;
					case 3:
						direction=3;
						break;
					case 4:
						direction=5;
						break;
					case 5:
						direction=1;
						break;
				}
				myName=action+"-"+direction+"-"+myIndex
				data=new BitmapDataName(width,height,true,0xFFFFFF);
				data.draw(mc,mat);
				data.name=myName
				arr.push(data);
			}
			return arr;
		}
		
		
		
		
		
		
		
		
		
		
		
		
		/**  将图片按照Y轴方向翻转
		 */
//		public static function flipYPic(data:BitmapDataName):BitmapDataName
//		{
//			var mat:Matrix=new Matrix();
//			mat.scale(-1,1);
//			mat.tx=data.width;
//			var bitmapDataName:BitmapDataName=new BitmapDataName(data.width,data.height,true,0xFFFFFF);
//			bitmapDataName.draw(data,mat);
//			bitmapDataName.name=data.name;
//			data.dispose();
//			return bitmapDataName;
//		}
		
	}
}