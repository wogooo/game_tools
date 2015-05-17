package com.YFFramework.game.ui.imageText
{
	import com.YFFramework.core.ui.abs.AbsView;
	import com.YFFramework.core.utils.common.ClassInstance;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;

	/**  文本数字 以及其他的攻击文字   皮肤取自 uiSkin.swf
	 * 2012-7-23 下午12:31:32
	 *@author yefeng
	 */
	public class ImageTextManager
	{
		
		/// 七种字体颜色
		/** 数字
		 */		
		private static const Num:String="Num";
		/** 文本
		 */		
		private static const Text:String="Text";
		private var _dict:Dictionary;
		
		private static var _pool:Vector.<AbsView>;
		
		
		
		
		private static var _instance:ImageTextManager;
		public function ImageTextManager()
		{
			_dict=new Dictionary();		
			_dict[Num]=new Dictionary();
			_dict[Text]=new Dictionary();
			_pool=new Vector.<AbsView>();
			initAllSkin();
			
		}
		
		public static function get Instance():ImageTextManager
		{
			if(!_instance) _instance=new ImageTextManager();
			return _instance;
		}
		/**初始化所有的 皮肤
		 */
		private  function initAllSkin():void
		{
					/////////////      数字文字------------------------------------------------------------
			///红色 img103
			var redData:BitmapData=ClassInstance.getInstance("img103") as BitmapData;//
			var greenData:BitmapData=ClassInstance.getInstance("img102") as BitmapData; ///1
			var yellow_1_data:BitmapData=ClassInstance.getInstance("img106") as BitmapData;///
			var yellow_2_data:BitmapData=ClassInstance.getInstance("img101") as BitmapData;//
			var yellow_3_data:BitmapData=ClassInstance.getInstance("img201") as BitmapData;
			var yellow_4_data:BitmapData=ClassInstance.getInstance("img202") as BitmapData;
			var blueData:BitmapData=ClassInstance.getInstance("img105") as BitmapData;//
			
			///创建
			_dict[Num][TypeImageText.Num_Red]=createData(redData);
			_dict[Num][TypeImageText.Num_Green]=createData(greenData);
			_dict[Num][TypeImageText.Num_Yellow_1]=createData(yellow_1_data);
			_dict[Num][TypeImageText.Num_Yellow_2]=createData(yellow_2_data);			
			_dict[Num][TypeImageText.Num_Yellow_3]=createData(yellow_3_data);
			_dict[Num][TypeImageText.Num_Yellow_4]=createData(yellow_4_data);
			_dict[Num][TypeImageText.Num_Blue]=createData(blueData);
			
				
				////////  文本文字-------------------------------------------------------------------------------
			
			/////经验 
			var expData:BitmapData=ClassInstance.getInstance("exp") as BitmapData;
			///攻击
			var atkData_add:BitmapData=ClassInstance.getInstance("attackadd") as BitmapData;	
			var atkData_mul:BitmapData=ClassInstance.getInstance("attackmul") as BitmapData;	

			///防御 
			var defenseData_add:BitmapData=ClassInstance.getInstance("defenceadd") as BitmapData; 
			var defenseData_mul:BitmapData=ClassInstance.getInstance("defencemul") as BitmapData; 
			///生命值
			var hpData_add:BitmapData=ClassInstance.getInstance("max_hpadd") as BitmapData;
			var hpData_mul:BitmapData=ClassInstance.getInstance("max_hpmul") as BitmapData;

			///创建
			///经验
			_dict[Text][TypeImageText.Text_Exp]=expData;
			/// 攻击
			_dict[Text][TypeImageText.Text_Atk_Add]=atkData_add;
			_dict[Text][TypeImageText.Text_Atk_Mul]=atkData_mul;
			/// 防御
			_dict[Text][TypeImageText.Text_Defense_Add]=defenseData_add;
			_dict[Text][TypeImageText.Text_Defense_Mul]=defenseData_mul;
			/// 生命值
			_dict[Text][TypeImageText.Text_Hp_Add]=hpData_add;
			_dict[Text][TypeImageText.Text_Hp_Mul]=hpData_mul;

		}
		
		/**
		 * 
		 * @param sourceData 正个 bitmapData  将其切割成四个bitmapData
		 * 
		 */
		private  function createData(sourceData:BitmapData):Vector.<BitmapData>
		{
			var len:int=11;
			var cellData:BitmapData;
			var cellW:int=int(sourceData.width/11);
			var cellH:int=sourceData.height;
			var matrix:Matrix=new Matrix();
			var pt:Point=new Point();
			var rect:Rectangle=new Rectangle(0,0,cellW,cellH);
			var arr:Vector.<BitmapData>=new Vector.<BitmapData>();
			for(var i:int=0;i!=len;++i)
			{
				rect.x=i*cellW;
				matrix.tx=-i*cellW;
				cellData=new BitmapData(cellW,cellH,true);
				cellData.copyPixels(sourceData,rect,pt);
				arr[i]=cellData;
			}
			///释放大图内存 
			sourceData.dispose();
			return arr;
		}
		
		
		/** 获取文字皮肤   id 是 Green Red 这样的数值  index 是在数组中的位置  默认   0  代表  -/+     1-10  代表数值   比如取数字 5  则是   5+1
		 */
		private  function getNumSkin(id:int,index:int):BitmapData
		{
			return _dict[Num][id][index];
		}
		
		
		
		
		
		/**创建文字数字   num为数字  不包含前缀符号 "+/-"  要想包含请使用下面的方法createNumWidthPre
		 */
		public   function createNum(num:String,id:int=1):AbsView
		{
			var str:String=num;
			var arr:Array=str.split("");
			var myNum:int;
			var sp:AbsView= new AbsView();
			var data:BitmapData;
			var lastX:int=0;
			var bmp:Bitmap;
			for each (str in arr)
			{
				myNum=int(str);
				data=getNumSkin(id,myNum+1);
				bmp=new Bitmap(data);
				bmp.x=lastX;
				sp.addChild(bmp);
				lastX +=data.width;
			}
			return sp;
		}
		
		/** 创建文字 包含前缀  符号  +  -
		 *  比如  输入  123 返回的是  +123 或者 -123这样的数字
		 * @param num
		 * @param id
		 * @return 
		 */
		public  function createNumWidthPre(num:String,id:int=1):AbsView
		{
			var str:String=num;
			var arr:Array=str.split("");
			var myNum:int;
			var sp:AbsView=new AbsView();
			var data:BitmapData;
			var lastX:int=0;
			var bmp:Bitmap;
			//创建前缀符号
			data=getNumSkin(id,0);
			bmp=new Bitmap(data);
			sp.addChild(bmp);
			lastX +=data.width;
			for each (str in arr)
			{
				myNum=int(str);
				data=getNumSkin(id,myNum+1);
				bmp=new Bitmap(data);
				bmp.x=lastX;
				sp.addChild(bmp);
				lastX +=data.width;
			}
			return sp;
		}
		/**创建加血文字
		 */		
		public function getAddBloodText(num:String):AbsView
		{
			return createNumWidthPre(num,TypeImageText.Num_Green);
		}
		
		
		/**创建文本
		 */ 
		public function createText(textId:int):AbsView
		{
			var bitmapData:BitmapData=_dict[Text][textId] ;
			var ui:AbsView=new AbsView();
			ui.addChild(new Bitmap(bitmapData));
			return ui;
		}
		
		/** 创建文字   包含文本和数字
		 *   比如 经验+5     textId 就是  经验      num 是 5   skinId 是num的样式  文字默认有 +号 
		 * numType 值为 0 表示没有 + - 号  为  1 表示 +  为2  表示-
		 */		
		public function createTextNum(textId:int,num:String,numSkinId:int):AbsView
		{
			var sp:AbsView=new AbsView();
			var lastX:int=0;
			var textData:BitmapData=_dict[Text][textId] ;
			var textBmp:Bitmap=new Bitmap(textData);
			sp.addChild(textBmp);
			lastX +=textData.width;
			var str:String=num;
			var arr:Array=str.split("");
			var myNum:int;
			var data:BitmapData;
			var bmp:Bitmap;
			//创建前缀符号
			data=getNumSkin(numSkinId,0);
			bmp=new Bitmap(data);
			sp.addChild(bmp);
			bmp.x=lastX;
			lastX +=data.width;
			for each (str in arr)
			{
				myNum=int(str);
				data=getNumSkin(numSkinId,myNum+1);
				bmp=new Bitmap(data);
				bmp.x=lastX;
				sp.addChild(bmp);
				lastX +=data.width;
			}
			return sp;

		}
			
		/** 获取absView
//		 */			
//		private function getAbsView():AbsView	
//		{
//			if(_pool.length>0) return _pool.pop();
//			return new AbsView();
//		}
//		/** 回收 absView
//		 */		
//		private function recycleAbsView(absView:AbsView):void
//		{
//			absView.removeAllContent(true);
//			absView.alpha=1;
//			absView.scaleX=absView.scaleY=1;
//			absView.visible=true;
//			_pool.push(absView);
//		}
//		
//		/**
//		 */		
//		private function gc():void
//		{
//			_pool=new Vector.<AbsView>();
//		}
	}
}